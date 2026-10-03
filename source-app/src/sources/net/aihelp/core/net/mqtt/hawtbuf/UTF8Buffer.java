package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.UnsupportedEncodingException;

public final class UTF8Buffer extends Buffer {
    int hashCode;
    String value;

    public UTF8Buffer(Buffer buffer) {
        super(buffer);
    }

    public UTF8Buffer(byte[] bArr, int i, int i2) {
        super(bArr, i, i2);
    }

    public UTF8Buffer(byte[] bArr) {
        super(bArr);
    }

    public UTF8Buffer(String str) {
        super(encode(str));
    }

    @Override
    public String toString() {
        if (this.value == null) {
            this.value = decode(this);
        }
        return this.value;
    }

    @Override
    public int compareTo(Buffer buffer) {
        return toString().compareTo(buffer.toString());
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj == null || obj.getClass() != UTF8Buffer.class) {
            return false;
        }
        return equals((Buffer) obj);
    }

    @Override
    public int hashCode() {
        if (this.hashCode == 0) {
            this.hashCode = super.hashCode();
        }
        return this.hashCode;
    }

    public static UTF8Buffer utf8(String str) {
        if (str == null) {
            return null;
        }
        return new UTF8Buffer(str);
    }

    public static UTF8Buffer utf8(Buffer buffer) {
        if (buffer == null) {
            return null;
        }
        if (buffer.getClass() == UTF8Buffer.class) {
            return (UTF8Buffer) buffer;
        }
        return new UTF8Buffer(buffer);
    }

    public static byte[] encode(String str) {
        try {
            return str.getBytes("UTF-8");
        } catch (UnsupportedEncodingException unused) {
            throw new RuntimeException("A UnsupportedEncodingException was thrown for teh UTF-8 encoding. (This should never happen)");
        }
    }

    public static String decode(Buffer buffer) {
        try {
            return new String(buffer.getData(), buffer.getOffset(), buffer.getLength(), "UTF-8");
        } catch (UnsupportedEncodingException unused) {
            throw new RuntimeException("A UnsupportedEncodingException was thrown for teh UTF-8 encoding. (This should never happen)");
        }
    }
}
