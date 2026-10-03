package cz.msebera.android.httpclient.impl.client;

import cz.msebera.android.httpclient.client.methods.HttpPost;

public class LaxRedirectStrategy extends DefaultRedirectStrategy {
    private static final String[] REDIRECT_METHODS = {"GET", HttpPost.METHOD_NAME, "HEAD"};

    @Override
    protected boolean isRedirectable(String str) {
        for (String str2 : REDIRECT_METHODS) {
            if (str2.equalsIgnoreCase(str)) {
                return true;
            }
        }
        return false;
    }
}
