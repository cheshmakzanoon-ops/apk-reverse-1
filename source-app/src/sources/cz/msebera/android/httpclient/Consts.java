package cz.msebera.android.httpclient;

import java.nio.charset.Charset;

public final class Consts {

    public static final int f0CR = 13;

    public static final int f1HT = 9;

    public static final int f2LF = 10;

    public static final int f3SP = 32;
    public static final Charset UTF_8 = Charset.forName("UTF-8");
    public static final Charset ASCII = Charset.forName("US-ASCII");
    public static final Charset ISO_8859_1 = Charset.forName("ISO-8859-1");

    private Consts() {
    }
}
