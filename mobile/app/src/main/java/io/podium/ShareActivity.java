package io.podium;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.CookieHandler;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by Runar on 01.10.2015.
 */
public class ShareActivity extends AppCompatActivity {

    private static final String SCOPE = "http://www.thepodium.io/";

    private ShareActivity instance;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_share);

        this.instance = this;

        final Button button = (Button) findViewById(R.id.button_cancel);
        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                finish();
            }
        });

        CookieProxy cookieManager = CookieProxy.getInstance();
        CookieHandler.setDefault(cookieManager);

        if (getIntent().getAction().equals(Intent.ACTION_SEND)) {
            String url = getIntent().getStringExtra(Intent.EXTRA_TEXT);
            checkCampaignStatus(url);
        }
    }

    private String getCampaignTitle(String url) {
        try {
            URI uri = new URI(url);
            String[] split = url.replace("http://", "").replace("https://", "").split("/");

            switch (uri.getHost().replace("www.", "")) {
                case "kickstarter.com":
                    if (!split[1].equals("projects")) {
                        return null;
                    }
                    String[] removeParams = split[3].split("\\?");
                    return removeParams[0];

                case "indiegogo.com":
                    if (!split[1].equals("projects")) {
                        return null;
                    }
                    removeParams = split[2].split("#");
                    return removeParams[0];

                default:
                    logUnsupportedWebsite(uri.getHost());
                    hideProgressBar();
                    setStatus("Unsupported website/campaign!");
                    setButtonOK();
                    return null;
            }

        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void checkCampaignStatus(final String campaignURL) {
        String title = getCampaignTitle(campaignURL);

        if (title == null) {
            return;
        }

        RequestQueue queue = Volley.newRequestQueue(this);
        String url = SCOPE + "campaigns/checkIfCanAdd/" + title;

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        Iterator<String> it = response.keys();
                        while (it.hasNext()) {
                            String key = it.next();
                            try {
                            String val = response.getString(key);
                                switch (key) {
                                    case "User":
                                        switch(val) {
                                            case "not logged in":
                                                Intent loginIntent = new Intent(instance, LoginActivity.class);
                                                startActivity(loginIntent);
                                                break;

                                            case "too many campaigns nominated":
                                                hideProgressBar();
                                                setStatus("You have already nominated your three campaigns for today!");
                                                setButtonOK();
                                                break;
                                        }
                                        break;

                                    case "Campaign":
                                        switch(val) {
                                            case "nominated: true":
                                                hideProgressBar();
                                                setStatus("Campaign is already nominated!");
                                                setButtonOK();
                                                break;

                                            case "nominated: false":
                                                nominate(campaignURL);
                                                hideProgressBar();
                                                setStatus("Campaign is being nominated!");
                                                setButtonOK();
                                                break;

                                            case "was not found":
                                                nominate(campaignURL);
                                                hideProgressBar();
                                                setStatus("Campaign is being nominated!");
                                                setButtonOK();
                                                break;
                                        }
                                        break;
                                }
                            } catch (JSONException je) {
                                je.printStackTrace();
                            }
                        }
                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                    }
        }) {
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                headers.put("Accept", "application/json");
                return headers;
            }
        };
        queue.add(request);
    }

    private void setButtonOK() {
        Button button = (Button) findViewById(R.id.button_cancel);
        button.setText("Ok");
    }

    private void setStatus(String s) {
        TextView status = (TextView) findViewById(R.id.status);
        status.setText(s);
    }

    private void hideProgressBar() {
        ProgressBar progressBar = (ProgressBar) findViewById(R.id.progressBar);
        progressBar.setVisibility(View.INVISIBLE);
    }

    private void nominate(final String campaignURL) {
        RequestQueue queue = Volley.newRequestQueue(this);
        String url = SCOPE + "campaigns";

        StringRequest request = new StringRequest(Request.Method.POST, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {

                    }
                }, new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {

                    }
        }) {
            @Override
            protected Map<String,String> getParams(){
                Map<String,String> params = new HashMap<String, String>();
                params.put("campaign[link]", campaignURL);
                params.put("campaign[category_id]", "" + 1);
                return params;
            }
        };
        queue.add(request);
    }

    private void logUnsupportedWebsite(String website) {
        RequestQueue queue = Volley.newRequestQueue(this);
        String url = SCOPE + "campaigns/log/" + website;

        StringRequest request = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {

                    }
                }, new Response.ErrorListener() {
                    @Override
                     public void onErrorResponse(VolleyError error) {

                    }
                });
        queue.add(request);
    }
}
