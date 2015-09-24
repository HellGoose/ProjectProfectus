package io.podium;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebView;

public class LoginActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        loadWebPage();
    }

    private void loadWebPage() {
        WebView myWebView = (WebView) findViewById(R.id.webview);
        myWebView.loadUrl("http://stianerkul.me/mobile/login");
    }
}
