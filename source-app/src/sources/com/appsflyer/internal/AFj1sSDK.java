package com.appsflyer.internal;

import androidx.core.view.MotionEventCompat;
import androidx.core.view.ViewCompat;
import java.io.BufferedInputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

public final class AFj1sSDK extends FilterInputStream {
    private static final short AFKeystoreWrapper = (short) ((Math.sqrt(5.0d) - 1.0d) * Math.pow(2.0d, 15.0d));
    private byte[] AFInAppEventParameterName;
    private int AFInAppEventType;
    private int AFLogger;

    private int f412d;

    private int f413e;
    private int force;

    private int f414i;
    private int registerClient;
    private int unregisterClient;

    private int f415v;
    private byte[] valueOf;
    private byte[] values;

    @Override
    public final boolean markSupported() {
        return false;
    }

    public AFj1sSDK(InputStream inputStream, int[] iArr, int i, byte[] bArr, int i2, int i3) throws IOException {
        super(new BufferedInputStream(inputStream, 4096));
        this.registerClient = Integer.MAX_VALUE;
        this.valueOf = new byte[8];
        this.values = new byte[8];
        this.AFInAppEventParameterName = new byte[8];
        this.AFInAppEventType = 8;
        this.unregisterClient = 8;
        this.AFLogger = Math.min(Math.max(i2, 5), 16);
        this.f413e = i3;
        if (i3 == 3) {
            System.arraycopy(bArr, 0, this.values, 0, 8);
        }
        long j = ((((long) iArr[0]) & 4294967295L) << 32) | (4294967295L & ((long) iArr[1]));
        if (i != 0) {
            int i4 = (int) j;
            this.f412d = i4;
            this.force = i4 * i;
            this.f414i = i4 ^ i;
            this.f415v = (int) (j >> 32);
            return;
        }
        this.f412d = (int) j;
        long j2 = j >> 3;
        short s = AFKeystoreWrapper;
        this.force = (int) ((((long) s) * j2) >> 32);
        this.f414i = (int) (j >> 32);
        this.f415v = (int) (j2 + ((long) s));
    }

    @Override
    public final int read() throws IOException {
        values();
        int i = this.AFInAppEventType;
        if (i >= this.unregisterClient) {
            return -1;
        }
        byte[] bArr = this.valueOf;
        this.AFInAppEventType = i + 1;
        return bArr[i] & 255;
    }

    @Override
    public final int read(byte[] bArr, int i, int i2) throws IOException {
        int i3 = i + i2;
        for (int i4 = i; i4 < i3; i4++) {
            values();
            int i5 = this.AFInAppEventType;
            if (i5 >= this.unregisterClient) {
                if (i4 == i) {
                    return -1;
                }
                return i2 - (i3 - i4);
            }
            byte[] bArr2 = this.valueOf;
            this.AFInAppEventType = i5 + 1;
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
        values();
        return this.unregisterClient - this.AFInAppEventType;
    }

    private void AFInAppEventType() {
        if (this.f413e == 3) {
            byte[] bArr = this.valueOf;
            System.arraycopy(bArr, 0, this.AFInAppEventParameterName, 0, bArr.length);
        }
        byte[] bArr2 = this.valueOf;
        int i = ((bArr2[0] << 24) & ViewCompat.MEASURED_STATE_MASK) + ((bArr2[1] << 16) & 16711680) + ((bArr2[2] << 8) & MotionEventCompat.ACTION_POINTER_INDEX_MASK) + (bArr2[3] & 255);
        int i2 = ((-16777216) & (bArr2[4] << 24)) + (16711680 & (bArr2[5] << 16)) + (65280 & (bArr2[6] << 8)) + (bArr2[7] & 255);
        int i3 = 0;
        while (true) {
            int i4 = this.AFLogger;
            if (i3 >= i4) {
                break;
            }
            short s = AFKeystoreWrapper;
            i2 -= ((((i4 - i3) * s) + i) ^ ((i << 4) + this.f414i)) ^ ((i >>> 5) + this.f415v);
            i -= (((i2 << 4) + this.f412d) ^ ((s * (i4 - i3)) + i2)) ^ ((i2 >>> 5) + this.force);
            i3++;
        }
        byte[] bArr3 = this.valueOf;
        bArr3[0] = (byte) (i >> 24);
        bArr3[1] = (byte) (i >> 16);
        bArr3[2] = (byte) (i >> 8);
        bArr3[3] = (byte) i;
        bArr3[4] = (byte) (i2 >> 24);
        bArr3[5] = (byte) (i2 >> 16);
        bArr3[6] = (byte) (i2 >> 8);
        bArr3[7] = (byte) i2;
        if (this.f413e == 3) {
            for (int i5 = 0; i5 < 8; i5++) {
                byte[] bArr4 = this.valueOf;
                bArr4[i5] = (byte) (bArr4[i5] ^ this.values[i5]);
            }
            byte[] bArr5 = this.AFInAppEventParameterName;
            System.arraycopy(bArr5, 0, this.values, 0, bArr5.length);
        }
    }

    private int values() throws IOException {
        if (this.registerClient == Integer.MAX_VALUE) {
            this.registerClient = ((FilterInputStream) this).in.read();
        }
        if (this.AFInAppEventType == 8) {
            byte[] bArr = this.valueOf;
            int i = this.registerClient;
            bArr[0] = (byte) i;
            if (i < 0) {
                throw new IllegalStateException("unexpected block size");
            }
            int i2 = 1;
            do {
                int i3 = ((FilterInputStream) this).in.read(this.valueOf, i2, 8 - i2);
                if (i3 <= 0) {
                    break;
                }
                i2 += i3;
            } while (i2 < 8);
            if (i2 < 8) {
                throw new IllegalStateException("unexpected block size");
            }
            AFInAppEventType();
            int i4 = ((FilterInputStream) this).in.read();
            this.registerClient = i4;
            this.AFInAppEventType = 0;
            this.unregisterClient = i4 < 0 ? 8 - (this.valueOf[7] & 255) : 8;
        }
        return this.unregisterClient;
    }
}
