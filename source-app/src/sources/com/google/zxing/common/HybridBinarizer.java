package com.google.zxing.common;

import com.google.zxing.Binarizer;
import com.google.zxing.LuminanceSource;
import com.google.zxing.NotFoundException;
import java.lang.reflect.Array;

public final class HybridBinarizer extends GlobalHistogramBinarizer {
    private static final int BLOCK_SIZE = 8;
    private static final int BLOCK_SIZE_MASK = 7;
    private static final int BLOCK_SIZE_POWER = 3;
    private static final int MINIMUM_DIMENSION = 40;
    private static final int MIN_DYNAMIC_RANGE = 24;
    private BitMatrix matrix;

    private static int cap(int i, int i2, int i3) {
        if (i < i2) {
            return i2;
        }
        return i > i3 ? i3 : i;
    }

    public HybridBinarizer(LuminanceSource luminanceSource) {
        super(luminanceSource);
    }

    @Override
    public BitMatrix getBlackMatrix() throws NotFoundException {
        BitMatrix bitMatrix = this.matrix;
        if (bitMatrix != null) {
            return bitMatrix;
        }
        LuminanceSource luminanceSource = getLuminanceSource();
        int width = luminanceSource.getWidth();
        int height = luminanceSource.getHeight();
        if (width >= MINIMUM_DIMENSION && height >= MINIMUM_DIMENSION) {
            byte[] matrix = luminanceSource.getMatrix();
            int i = width >> 3;
            if ((width & 7) != 0) {
                i++;
            }
            int i2 = i;
            int i3 = height >> 3;
            if ((height & 7) != 0) {
                i3++;
            }
            int i4 = i3;
            int[][] iArrCalculateBlackPoints = calculateBlackPoints(matrix, i2, i4, width, height);
            BitMatrix bitMatrix2 = new BitMatrix(width, height);
            calculateThresholdForBlock(matrix, i2, i4, width, height, iArrCalculateBlackPoints, bitMatrix2);
            this.matrix = bitMatrix2;
        } else {
            this.matrix = super.getBlackMatrix();
        }
        return this.matrix;
    }

    @Override
    public Binarizer createBinarizer(LuminanceSource luminanceSource) {
        return new HybridBinarizer(luminanceSource);
    }

    private static void calculateThresholdForBlock(byte[] bArr, int i, int i2, int i3, int i4, int[][] iArr, BitMatrix bitMatrix) {
        int i5 = i4 - 8;
        int i6 = i3 - 8;
        for (int i7 = 0; i7 < i2; i7++) {
            int i8 = i7 << 3;
            if (i8 > i5) {
                i8 = i5;
            }
            int iCap = cap(i7, 2, i2 - 3);
            for (int i9 = 0; i9 < i; i9++) {
                int i10 = i9 << 3;
                int i11 = i10 > i6 ? i6 : i10;
                int iCap2 = cap(i9, 2, i - 3);
                int i12 = 0;
                for (int i13 = -2; i13 <= 2; i13++) {
                    int[] iArr2 = iArr[iCap + i13];
                    i12 += iArr2[iCap2 - 2] + iArr2[iCap2 - 1] + iArr2[iCap2] + iArr2[iCap2 + 1] + iArr2[iCap2 + 2];
                }
                thresholdBlock(bArr, i11, i8, i12 / 25, i3, bitMatrix);
            }
        }
    }

    private static void thresholdBlock(byte[] bArr, int i, int i2, int i3, int i4, BitMatrix bitMatrix) {
        int i5 = (i2 * i4) + i;
        int i6 = 0;
        while (i6 < 8) {
            for (int i7 = 0; i7 < 8; i7++) {
                if ((bArr[i5 + i7] & 255) <= i3) {
                    bitMatrix.set(i + i7, i2 + i6);
                }
            }
            i6++;
            i5 += i4;
        }
    }

    private static int[][] calculateBlackPoints(byte[] bArr, int i, int i2, int i3, int i4) {
        char c;
        int i5 = 8;
        int i6 = i4 - 8;
        int i7 = i3 - 8;
        char c2 = 2;
        boolean z = true;
        int i8 = 0;
        int[][] iArr = (int[][]) Array.newInstance((Class<?>) Integer.TYPE, i2, i);
        int i9 = 0;
        while (i9 < i2) {
            int i10 = i9 << 3;
            if (i10 > i6) {
                i10 = i6;
            }
            int i11 = i8;
            while (i11 < i) {
                int i12 = i11 << 3;
                if (i12 > i7) {
                    i12 = i7;
                }
                int i13 = (i10 * i3) + i12;
                int i14 = i8;
                int i15 = i14;
                int i16 = i15;
                int i17 = 255;
                while (i14 < i5) {
                    int i18 = i16;
                    int i19 = 0;
                    while (i19 < i5) {
                        int i20 = bArr[i13 + i19] & 255;
                        i15 += i20;
                        if (i20 < i17) {
                            i17 = i20;
                        }
                        if (i20 > i18) {
                            i18 = i20;
                        }
                        i19++;
                        i5 = 8;
                    }
                    if (i18 - i17 > 24) {
                        while (true) {
                            i14++;
                            i13 += i3;
                            if (i14 < 8) {
                                int i21 = 0;
                                for (int i22 = 8; i21 < i22; i22 = 8) {
                                    i15 += bArr[i13 + i21] & 255;
                                    i21++;
                                }
                            }
                        }
                    }
                    i14++;
                    i13 += i3;
                    i16 = i18;
                    z = true;
                    i5 = 8;
                }
                boolean z2 = z;
                int i23 = i15 >> 6;
                if (i16 - i17 <= 24) {
                    i23 = i17 / 2;
                    if (i9 <= 0 || i11 <= 0) {
                        c = 2;
                    } else {
                        int[] iArr2 = iArr[i9 - 1];
                        int i24 = i11 - 1;
                        c = 2;
                        int i25 = ((iArr2[i11] + (iArr[i9][i24] * 2)) + iArr2[i24]) / 4;
                        if (i17 < i25) {
                            i23 = i25;
                        }
                    }
                } else {
                    c = 2;
                }
                iArr[i9][i11] = i23;
                i11++;
                z = z2;
                c2 = c;
                i5 = 8;
                i8 = 0;
            }
            i9++;
            i5 = 8;
            i8 = 0;
        }
        return iArr;
    }
}
