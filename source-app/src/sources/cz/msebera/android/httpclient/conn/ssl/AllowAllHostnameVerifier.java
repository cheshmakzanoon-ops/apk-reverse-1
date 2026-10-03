package cz.msebera.android.httpclient.conn.ssl;

public class AllowAllHostnameVerifier extends AbstractVerifier {
    @Override
    public final void verify(String str, String[] strArr, String[] strArr2) {
    }

    public final String toString() {
        return "ALLOW_ALL";
    }
}
