package cz.msebera.android.httpclient.impl.cookie;

import cz.msebera.android.httpclient.cookie.InterfaceC0009SM;
import cz.msebera.android.httpclient.cookie.MalformedCookieException;
import cz.msebera.android.httpclient.cookie.SetCookie;
import cz.msebera.android.httpclient.util.Args;

public class BasicCommentHandler extends AbstractCookieAttributeHandler {
    @Override
    public void parse(SetCookie setCookie, String str) throws MalformedCookieException {
        Args.notNull(setCookie, InterfaceC0009SM.COOKIE);
        setCookie.setComment(str);
    }
}
