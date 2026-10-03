package cz.msebera.android.httpclient.conn.ssl;

import javax.net.ssl.SSLException;

public class BrowserCompatHostnameVerifier extends AbstractVerifier {
    @Override
    boolean validCountryWildcard(String str) {
        return true;
    }

    @Override
    public final void verify(String str, String[] strArr, String[] strArr2) throws SSLException {
        verify(str, strArr, strArr2, false);
    }

    public final String toString() {
        return "BROWSER_COMPATIBLE";
    }
}
