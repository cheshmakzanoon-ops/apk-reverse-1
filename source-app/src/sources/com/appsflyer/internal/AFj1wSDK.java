package com.appsflyer.internal;

import java.io.BufferedInputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

public final class AFj1wSDK extends FilterInputStream {
    private byte[] AFInAppEventParameterName;
    private long[] AFInAppEventType;
    private final int AFKeystoreWrapper;
    private int AFLogger;

    private int f418d;

    private int f419e;
    private long[] valueOf;
    private short values;

    @Override
    public final boolean markSupported() {
        return false;
    }

    public AFj1wSDK(InputStream inputStream, int i, int i2, short s, int i3, int i4) throws IOException {
        super(new BufferedInputStream(inputStream, 4096));
        this.f419e = Integer.MAX_VALUE;
        int iMin = Math.min(Math.max((int) s, 4), 8);
        this.AFKeystoreWrapper = iMin;
        this.AFInAppEventParameterName = new byte[iMin];
        this.AFInAppEventType = new long[4];
        this.valueOf = new long[4];
        this.f418d = iMin;
        this.AFLogger = iMin;
        this.AFInAppEventType = AFj1rSDK.AFInAppEventType(i ^ i4, iMin ^ i4);
        this.valueOf = AFj1rSDK.AFInAppEventType(i2 ^ i4, i3 ^ i4);
    }

    @Override
    public final int read() throws IOException {
        valueOf();
        int i = this.f418d;
        if (i >= this.AFLogger) {
            return -1;
        }
        byte[] bArr = this.AFInAppEventParameterName;
        this.f418d = i + 1;
        return bArr[i] & 255;
    }

    @Override
    public final int read(byte[] bArr, int i, int i2) throws IOException {
        int i3 = i + i2;
        for (int i4 = i; i4 < i3; i4++) {
            valueOf();
            int i5 = this.f418d;
            if (i5 >= this.AFLogger) {
                if (i4 == i) {
                    return -1;
                }
                return i2 - (i3 - i4);
            }
            byte[] bArr2 = this.AFInAppEventParameterName;
            this.f418d = i5 + 1;
            bArr[i4] = bArr2[i5];
        }
        return i2;
    }

    @Override
    public final long skip(long j) throws IOException {
        long j2 = 0;
        while (j2 < j && read() != -1) {
            j2++;
        }
        return j2;
    }

    @Override
    public final int available() throws IOException {
        valueOf();
        return this.AFLogger - this.f418d;
    }

    private void AFInAppEventParameterName() {
        long[] jArr = this.AFInAppEventType;
        long[] jArr2 = this.valueOf;
        short s = this.values;
        long j = jArr[s % 4] * 2147483085;
        long j2 = jArr2[(s + 2) % 4];
        int i = (s + 3) % 4;
        jArr2[i] = ((jArr[i] * 2147483085) + j2) / 2147483647L;
        jArr[i] = (j + j2) % 2147483647L;
        for (int i2 = 0; i2 < this.AFKeystoreWrapper; i2++) {
            byte[] bArr = this.AFInAppEventParameterName;
            bArr[i2] = (byte) (((long) bArr[i2]) ^ ((this.AFInAppEventType[this.values] >> (i2 << 3)) & 255));
        }
        this.values = (short) ((this.values + 1) % 4);
    }

    private int valueOf() throws IOException {
        int i;
        if (this.f419e == Integer.MAX_VALUE) {
            this.f419e = ((FilterInputStream) this).in.read();
        }
        if (this.f418d == this.AFKeystoreWrapper) {
            byte[] bArr = this.AFInAppEventParameterName;
            int i2 = this.f419e;
            bArr[0] = (byte) i2;
            if (i2 < 0) {
                throw new IllegalStateException("unexpected block size");
            }
            int i3 = 1;
            do {
                int i4 = ((FilterInputStream) this).in.read(this.AFInAppEventParameterName, i3, this.AFKeystoreWrapper - i3);
                if (i4 <= 0) {
                    break;
                }
                i3 += i4;
            } while (i3 < this.AFKeystoreWrapper);
            if (i3 < this.AFKeystoreWrapper) {
                throw new IllegalStateException("unexpected block size");
            }
            AFInAppEventParameterName();
            int i5 = ((FilterInputStream) this).in.read();
            this.f419e = i5;
            this.f418d = 0;
            if (i5 < 0) {
                int i6 = this.AFKeystoreWrapper;
                i = i6 - (this.AFInAppEventParameterName[i6 - 1] & 255);
            } else {
                i = this.AFKeystoreWrapper;
            }
            this.AFLogger = i;
        }
        return this.AFLogger;
    }
}
