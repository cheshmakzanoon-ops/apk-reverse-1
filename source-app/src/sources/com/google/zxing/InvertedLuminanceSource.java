package com.google.zxing;

import com.google.common.primitives.UnsignedBytes;

public final class InvertedLuminanceSource extends LuminanceSource {
    private final LuminanceSource delegate;

    public InvertedLuminanceSource(LuminanceSource luminanceSource) {
        super(luminanceSource.getWidth(), luminanceSource.getHeight());
        this.delegate = luminanceSource;
    }

    @Override
    public byte[] getRow(int i, byte[] bArr) {
        byte[] row = this.delegate.getRow(i, bArr);
        int width = getWidth();
        for (int i2 = 0; i2 < width; i2++) {
            row[i2] = (byte) (255 - (row[i2] & UnsignedBytes.MAX_VALUE));
        }
        return row;
    }

    @Override
    public byte[] getMatrix() {
        byte[] matrix = this.delegate.getMatrix();
        int width = getWidth() * getHeight();
        byte[] bArr = new byte[width];
        for (int i = 0; i < width; i++) {
            bArr[i] = (byte) (255 - (matrix[i] & UnsignedBytes.MAX_VALUE));
        }
        return bArr;
    }

    @Override
    public boolean isCropSupported() {
        return this.delegate.isCropSupported();
    }

    @Override
    public LuminanceSource crop(int i, int i2, int i3, int i4) {
        return new InvertedLuminanceSource(this.delegate.crop(i, i2, i3, i4));
    }

    @Override
    public boolean isRotateSupported() {
        return this.delegate.isRotateSupported();
    }

    @Override
    public LuminanceSource invert() {
        return this.delegate;
    }

    @Override
    public LuminanceSource rotateCounterClockwise() {
        return new InvertedLuminanceSource(this.delegate.rotateCounterClockwise());
    }

    @Override
    public LuminanceSource rotateCounterClockwise45() {
        return new InvertedLuminanceSource(this.delegate.rotateCounterClockwise45());
    }
}
