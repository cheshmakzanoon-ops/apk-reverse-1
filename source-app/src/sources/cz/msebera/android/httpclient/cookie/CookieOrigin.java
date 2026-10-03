package cz.msebera.android.httpclient.cookie;

import cz.msebera.android.httpclient.util.Args;
import java.util.Locale;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

public final class CookieOrigin {
    private final String host;
    private final String path;
    private final int port;
    private final boolean secure;

    public CookieOrigin(String str, int i, String str2, boolean z) {
        Args.notBlank(str, "Host");
        Args.notNegative(i, "Port");
        Args.notNull(str2, "Path");
        this.host = str.toLowerCase(Locale.ENGLISH);
        this.port = i;
        if (str2.trim().length() != 0) {
            this.path = str2;
        } else {
            this.path = "/";
        }
        this.secure = z;
    }

    public String getHost() {
        return this.host;
    }

    public String getPath() {
        return this.path;
    }

    public int getPort() {
        return this.port;
    }

    public boolean isSecure() {
        return this.secure;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("[");
        if (this.secure) {
            sb.append("(secure)");
        }
        sb.append(this.host);
        sb.append(AbstractJsonLexerKt.COLON);
        sb.append(Integer.toString(this.port));
        sb.append(this.path);
        sb.append(AbstractJsonLexerKt.END_LIST);
        return sb.toString();
    }
}
