package com.appsflyer.internal;

import androidx.core.view.MotionEventCompat;
import androidx.core.view.ViewCompat;
import java.io.BufferedInputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

public final class AFj1uSDK extends FilterInputStream {
    private byte[] AFInAppEventParameterName;
    private final int AFInAppEventType;
    private AFj1vSDK AFKeystoreWrapper;
    private int[] AFLogger;

    private int f416d;

    private int f417e;
    private int registerClient;
    private int unregisterClient;
    private byte[] valueOf;
    private byte[] values;

    @Override
    public final boolean markSupported() {
        return false;
    }

    public AFj1uSDK(InputStream inputStream, int[] iArr, byte[] bArr, int i, boolean z, int i2) throws IOException {
        super(new BufferedInputStream(inputStream, 4096));
        this.f416d = Integer.MAX_VALUE;
        int iMin = Math.min(Math.max(i, 3), 16);
        this.AFInAppEventType = iMin;
        this.values = new byte[8];
        byte[] bArr2 = new byte[8];
        this.valueOf = bArr2;
        this.AFInAppEventParameterName = new byte[8];
        this.AFLogger = new int[2];
        this.registerClient = 8;
        this.unregisterClient = 8;
        this.f417e = i2;
        if (i2 == 2) {
            System.arraycopy(bArr, 0, bArr2, 0, 8);
        }
        this.AFKeystoreWrapper = new AFj1vSDK(iArr, iMin, true, false);
    }

    @Override
    public final int read() throws IOException {
        valueOf();
        int i = this.registerClient;
        if (i >= this.unregisterClient) {
            return -1;
        }
        byte[] bArr = this.values;
        this.registerClient = i + 1;
        return bArr[i] & 255;
    }

    @Override
    public final int read(byte[] bArr, int i, int i2) throws IOException {
        int i3 = i + i2;
        for (int i4 = i; i4 < i3; i4++) {
            valueOf();
            int i5 = this.registerClient;
            if (i5 >= this.unregisterClient) {
                if (i4 == i) {
                    return -1;
                }
                return i2 - (i3 - i4);
            }
            byte[] bArr2 = this.values;
            this.registerClient = i5 + 1;
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
        return this.unregisterClient - this.registerClient;
    }

    private void AFKeystoreWrapper() {
        if (this.f417e == 2) {
            byte[] bArr = this.values;
            System.arraycopy(bArr, 0, this.AFInAppEventParameterName, 0, bArr.length);
        }
        byte[] bArr2 = this.values;
        AFj1xSDK.AFInAppEventParameterName(((bArr2[0] << 24) & ViewCompat.MEASURED_STATE_MASK) + ((bArr2[1] << 16) & 16711680) + ((bArr2[2] << 8) & MotionEventCompat.ACTION_POINTER_INDEX_MASK) + (bArr2[3] & 255), ((-16777216) & (bArr2[4] << 24)) + (16711680 & (bArr2[5] << 16)) + (65280 & (bArr2[6] << 8)) + (bArr2[7] & 255), false, this.AFInAppEventType, this.AFKeystoreWrapper.values, this.AFKeystoreWrapper.AFKeystoreWrapper, this.AFLogger);
        int[] iArr = this.AFLogger;
        int i = iArr[0];
        int i2 = iArr[1];
        byte[] bArr3 = this.values;
        bArr3[0] = (byte) (i >> 24);
        bArr3[1] = (byte) (i >> 16);
        bArr3[2] = (byte) (i >> 8);
        bArr3[3] = (byte) i;
        bArr3[4] = (byte) (i2 >> 24);
        bArr3[5] = (byte) (i2 >> 16);
        bArr3[6] = (byte) (i2 >> 8);
        bArr3[7] = (byte) i2;
        if (this.f417e == 2) {
            for (int i3 = 0; i3 < 8; i3++) {
                byte[] bArr4 = this.values;
                bArr4[i3] = (byte) (bArr4[i3] ^ this.valueOf[i3]);
            }
            byte[] bArr5 = this.AFInAppEventParameterName;
            System.arraycopy(bArr5, 0, this.valueOf, 0, bArr5.length);
        }
    }

    private int valueOf() throws IOException {
        if (this.f416d == Integer.MAX_VALUE) {
            this.f416d = ((FilterInputStream) this).in.read();
        }
        if (this.registerClient == 8) {
            byte[] bArr = this.values;
            int i = this.f416d;
            bArr[0] = (byte) i;
            if (i < 0) {
                throw new IllegalStateException("unexpected block size");
            }
            int i2 = 1;
            do {
                int i3 = ((FilterInputStream) this).in.read(this.values, i2, 8 - i2);
                if (i3 <= 0) {
                    break;
                }
                i2 += i3;
            } while (i2 < 8);
            if (i2 < 8) {
                throw new IllegalStateException("unexpected block size");
            }
            AFKeystoreWrapper();
            int i4 = ((FilterInputStream) this).in.read();
            this.f416d = i4;
            this.registerClient = 0;
            this.unregisterClient = i4 < 0 ? 8 - (this.values[7] & 255) : 8;
        }
        return this.unregisterClient;
    }
}
