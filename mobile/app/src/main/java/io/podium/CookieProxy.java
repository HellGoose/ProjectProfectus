package io.podium;

import java.io.IOException;
import java.net.CookieManager;
import java.net.CookieStore;
import java.net.URI;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * Created by Runar on 05.10.2015.
 */
public class CookieProxy extends CookieManager {

    private static CookieProxy INSTANCE = new CookieProxy();

    private android.webkit.CookieManager webkitCookieManager;

    public CookieProxy() {
        this.webkitCookieManager = android.webkit.CookieManager.getInstance();
    }

    @Override
    public void put(URI uri, Map<String, List<String>> responseHeaders) throws IOException {
        if (uri == null || responseHeaders == null) {
            return;
        }

        String url = uri.toString();
        for (String headerKey : responseHeaders.keySet()) {
            if (headerKey == null || !(headerKey.equalsIgnoreCase("Set-Cookie2") || headerKey.equalsIgnoreCase("Set-Cookie"))) {
                continue;
            }
            for (String headerValue : responseHeaders.get(headerKey)) {
                this.webkitCookieManager.setCookie(url, headerValue);
            }
        }
    }

    @Override
    public Map<String, List<String>> get(URI uri, Map<String, List<String>> requestHeaders) throws IOException {
        if (uri == null || requestHeaders == null) {
            throw new IllegalArgumentException("Argument is null");
        }

        String url = uri.toString();
        Map<String, List<String>> res = new java.util.HashMap<String, List<String>>();
        String cookie = this.webkitCookieManager.getCookie(url);

        if (cookie != null) {
            res.put("Cookie", Arrays.asList(cookie));
        }
        return res;
    }

    @Override
    public CookieStore getCookieStore() {
        throw new UnsupportedOperationException();
    }

    public void resetCookies() {
        webkitCookieManager.removeAllCookie();
    }

    public Map<String, List<String>> getAlltheCookies(String url) throws IOException {
        if (url == null) {
            throw new IllegalArgumentException("Argument is null");
        }

        Map<String, List<String>> res = new java.util.HashMap<String, List<String>>();
        String cookie = this.webkitCookieManager.getCookie(url);

        if (cookie != null) {
            res.put("Cookie", Arrays.asList(cookie));
        }
        return res;
    }

    public static CookieProxy getInstance() {
        return INSTANCE;
    }
}
