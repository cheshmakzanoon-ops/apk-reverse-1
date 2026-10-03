package cz.msebera.android.httpclient.util;

import cz.msebera.android.httpclient.Consts;
import java.io.UnsupportedEncodingException;

public final class EncodingUtils {
    public static String getString(byte[] bArr, int i, int i2, String str) {
        Args.notNull(bArr, "Input");
        Args.notEmpty(str, "Charset");
        try {
            return new String(bArr, i, i2, str);
        } catch (UnsupportedEncodingException unused) {
            return new String(bArr, i, i2);
        }
    }

    public static String getString(byte[] bArr, String str) {
        Args.notNull(bArr, "Input");
        return getString(bArr, 0, bArr.length, str);
    }

    public static byte[] getBytes(String str, String str2) {
        Args.notNull(str, "Input");
        Args.notEmpty(str2, "Charset");
        try {
            return str.getBytes(str2);
        } catch (UnsupportedEncodingException unused) {
            return str.getBytes();
        }
    }

    public static byte[] getAsciiBytes(String str) {
        Args.notNull(str, "Input");
        try {
            return str.getBytes(Consts.ASCII.name());
        } catch (UnsupportedEncodingException unused) {
            throw new Error("ASCII not supported");
        }
    }

    public static String getAsciiString(byte[] bArr, int i, int i2) {
        Args.notNull(bArr, "Input");
        try {
            return new String(bArr, i, i2, Consts.ASCII.name());
        } catch (UnsupportedEncodingException unused) {
            throw new Error("ASCII not supported");
        }
    }

    public static String getAsciiString(byte[] bArr) {
        Args.notNull(bArr, "Input");
        return getAsciiString(bArr, 0, bArr.length);
    }

    private EncodingUtils() {
    }
}
