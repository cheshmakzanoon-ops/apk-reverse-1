package net.aihelp.core.net.mqtt.hawtbuf;

import kotlin.UByte;

public final class AsciiBuffer extends Buffer {
    private int hashCode;
    private String value;

    public AsciiBuffer(Buffer buffer) {
        super(buffer);
    }

    public AsciiBuffer(byte[] bArr, int i, int i2) {
        super(bArr, i, i2);
    }

    public AsciiBuffer(byte[] bArr) {
        super(bArr);
    }

    public AsciiBuffer(String str) {
        super(encode(str));
        this.value = str;
    }

    @Override
    public String toString() {
        if (this.value == null) {
            this.value = decode(this);
        }
        return this.value;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj == null || obj.getClass() != AsciiBuffer.class) {
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

    public static AsciiBuffer ascii(String str) {
        if (str == null) {
            return null;
        }
        return new AsciiBuffer(str);
    }

    public static AsciiBuffer ascii(Buffer buffer) {
        if (buffer == null) {
            return null;
        }
        if (buffer.getClass() == AsciiBuffer.class) {
            return (AsciiBuffer) buffer;
        }
        return new AsciiBuffer(buffer);
    }

    public static byte[] encode(String str) {
        int length = str.length();
        byte[] bArr = new byte[length];
        for (int i = 0; i < length; i++) {
            bArr[i] = (byte) (str.charAt(i) & 255);
        }
        return bArr;
    }

    public static String decode(Buffer buffer) {
        int length = buffer.getLength();
        char[] cArr = new char[length];
        for (int i = 0; i < length; i++) {
            cArr[i] = (char) (buffer.get(i) & UByte.MAX_VALUE);
        }
        return new String(cArr);
    }
}
