package cz.msebera.android.httpclient.auth;

import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.LangUtils;
import java.io.Serializable;
import java.security.Principal;
import java.util.Locale;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

public class NTUserPrincipal implements Principal, Serializable {
    private static final long serialVersionUID = -6870169797924406894L;
    private final String domain;
    private final String ntname;
    private final String username;

    public NTUserPrincipal(String str, String str2) {
        Args.notNull(str2, "User name");
        this.username = str2;
        if (str != null) {
            this.domain = str.toUpperCase(Locale.ENGLISH);
        } else {
            this.domain = null;
        }
        String str3 = this.domain;
        if (str3 != null && str3.length() > 0) {
            this.ntname = this.domain + AbstractJsonLexerKt.STRING_ESC + str2;
            return;
        }
        this.ntname = str2;
    }

    @Override
    public String getName() {
        return this.ntname;
    }

    public String getDomain() {
        return this.domain;
    }

    public String getUsername() {
        return this.username;
    }

    @Override
    public int hashCode() {
        return LangUtils.hashCode(LangUtils.hashCode(17, this.username), this.domain);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof NTUserPrincipal)) {
            return false;
        }
        NTUserPrincipal nTUserPrincipal = (NTUserPrincipal) obj;
        return LangUtils.equals(this.username, nTUserPrincipal.username) && LangUtils.equals(this.domain, nTUserPrincipal.domain);
    }

    @Override
    public String toString() {
        return this.ntname;
    }
}
