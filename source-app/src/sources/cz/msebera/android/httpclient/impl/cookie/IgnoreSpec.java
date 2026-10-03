package cz.msebera.android.httpclient.impl.cookie;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.cookie.Cookie;
import cz.msebera.android.httpclient.cookie.CookieOrigin;
import cz.msebera.android.httpclient.cookie.MalformedCookieException;
import java.util.Collections;
import java.util.List;

public class IgnoreSpec extends CookieSpecBase {
    @Override
    public int getVersion() {
        return 0;
    }

    @Override
    public Header getVersionHeader() {
        return null;
    }

    @Override
    public List<Cookie> parse(Header header, CookieOrigin cookieOrigin) throws MalformedCookieException {
        return Collections.emptyList();
    }

    @Override
    public List<Header> formatCookies(List<Cookie> list) {
        return Collections.emptyList();
    }
}
