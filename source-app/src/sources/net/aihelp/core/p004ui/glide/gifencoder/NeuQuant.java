package net.aihelp.core.p004ui.glide.gifencoder;

import kotlin.UByte;

class NeuQuant {
    protected static final int alphabiasshift = 10;
    protected static final int alpharadbias = 262144;
    protected static final int alpharadbshift = 18;
    protected static final int beta = 64;
    protected static final int betagamma = 65536;
    protected static final int betashift = 10;
    protected static final int gamma = 1024;
    protected static final int gammashift = 10;
    protected static final int initalpha = 1024;
    protected static final int initrad = 32;
    protected static final int initradius = 2048;
    protected static final int intbias = 65536;
    protected static final int intbiasshift = 16;
    protected static final int maxnetpos = 255;
    protected static final int minpicturebytes = 1509;
    protected static final int ncycles = 100;
    protected static final int netbiasshift = 4;
    protected static final int netsize = 256;
    protected static final int prime1 = 499;
    protected static final int prime2 = 491;
    protected static final int prime3 = 487;
    protected static final int prime4 = 503;
    protected static final int radbias = 256;
    protected static final int radbiasshift = 8;
    protected static final int radiusbias = 64;
    protected static final int radiusbiasshift = 6;
    protected static final int radiusdec = 30;
    protected int alphadec;
    protected int lengthcount;
    protected int samplefac;
    protected byte[] thepicture;
    protected int[] netindex = new int[256];
    protected int[] bias = new int[256];
    protected int[] freq = new int[256];
    protected int[] radpower = new int[32];
    protected int[][] network = new int[256][];

    public NeuQuant(byte[] bArr, int i, int i2) {
        this.thepicture = bArr;
        this.lengthcount = i;
        this.samplefac = i2;
        for (int i3 = 0; i3 < 256; i3++) {
            this.network[i3] = new int[]{i, i, i, 0};
            int i4 = (i3 << 12) / 256;
            this.freq[i3] = 256;
            this.bias[i3] = 0;
        }
    }

    public byte[] colorMap() {
        byte[] bArr = new byte[768];
        int[] iArr = new int[256];
        for (int i = 0; i < 256; i++) {
            iArr[this.network[i][3]] = i;
        }
        int i2 = 0;
        for (int i3 = 0; i3 < 256; i3++) {
            int[] iArr2 = this.network[iArr[i3]];
            bArr[i2] = (byte) iArr2[0];
            int i4 = i2 + 2;
            bArr[i2 + 1] = (byte) iArr2[1];
            i2 += 3;
            bArr[i4] = (byte) iArr2[2];
        }
        return bArr;
    }

    public void inxbuild() {
        int i = 0;
        int i2 = 0;
        int i3 = 0;
        while (i < 256) {
            int[] iArr = this.network[i];
            int i4 = iArr[1];
            int i5 = i + 1;
            int i6 = i;
            for (int i7 = i5; i7 < 256; i7++) {
                int i8 = this.network[i7][1];
                if (i8 < i4) {
                    i6 = i7;
                    i4 = i8;
                }
            }
            int[] iArr2 = this.network[i6];
            if (i != i6) {
                int i9 = iArr2[0];
                iArr2[0] = iArr[0];
                iArr[0] = i9;
                int i10 = iArr2[1];
                iArr2[1] = iArr[1];
                iArr[1] = i10;
                int i11 = iArr2[2];
                iArr2[2] = iArr[2];
                iArr[2] = i11;
                int i12 = iArr2[3];
                iArr2[3] = iArr[3];
                iArr[3] = i12;
            }
            if (i4 != i2) {
                this.netindex[i2] = (i3 + i) >> 1;
                while (true) {
                    i2++;
                    if (i2 >= i4) {
                        break;
                    } else {
                        this.netindex[i2] = i;
                    }
                }
                i3 = i;
                i2 = i4;
            }
            i = i5;
        }
        this.netindex[i2] = (i3 + 255) >> 1;
        for (int i13 = i2 + 1; i13 < 256; i13++) {
            this.netindex[i13] = 255;
        }
    }

    public void learn() {
        int i;
        int i2 = this.lengthcount;
        int i3 = minpicturebytes;
        if (i2 < minpicturebytes) {
            this.samplefac = 1;
        }
        int i4 = this.samplefac;
        this.alphadec = ((i4 - 1) / 3) + 30;
        byte[] bArr = this.thepicture;
        int i5 = i2 / (i4 * 3);
        int i6 = i5 / 100;
        for (int i7 = 0; i7 < 32; i7++) {
            this.radpower[i7] = 1024 * (((1024 - (i7 * i7)) * 256) / 1024);
        }
        int i8 = this.lengthcount;
        if (i8 < minpicturebytes) {
            i = 3;
        } else {
            if (i8 % prime1 != 0) {
                i3 = 1497;
            } else if (i8 % prime2 != 0) {
                i3 = 1473;
            } else if (i8 % prime3 != 0) {
                i3 = 1461;
            }
            i = i3;
        }
        int i9 = initradius;
        int i10 = i6;
        int i11 = 1024;
        int i12 = 32;
        int i13 = 0;
        int i14 = 0;
        while (i13 < i5) {
            int i15 = (bArr[i14] & UByte.MAX_VALUE) << 4;
            int i16 = (bArr[i14 + 1] & UByte.MAX_VALUE) << 4;
            int i17 = (bArr[i14 + 2] & UByte.MAX_VALUE) << 4;
            int iContest = contest(i15, i16, i17);
            int i18 = i13;
            altersingle(i11, iContest, i15, i16, i17);
            if (i12 != 0) {
                alterneigh(i12, iContest, i15, i16, i17);
            }
            int i19 = i14 + i;
            if (i19 >= i2) {
                i19 -= this.lengthcount;
            }
            i14 = i19;
            i13 = i18 + 1;
            if (i10 == 0) {
                i10 = 1;
            }
            if (i13 % i10 == 0) {
                i11 -= i11 / this.alphadec;
                i9 -= i9 / 30;
                int i20 = i9 >> 6;
                if (i20 <= 1) {
                    i20 = 0;
                }
                for (int i21 = 0; i21 < i20; i21++) {
                    int i22 = i20 * i20;
                    this.radpower[i21] = (((i22 - (i21 * i21)) * 256) / i22) * i11;
                }
                i12 = i20;
            }
        }
    }

    public int map(int i, int i2, int i3) {
        int i4 = this.netindex[i2];
        int i5 = i4 - 1;
        int i6 = 1000;
        int i7 = -1;
        while (true) {
            if (i4 >= 256 && i5 < 0) {
                return i7;
            }
            if (i4 < 256) {
                int[] iArr = this.network[i4];
                int i8 = iArr[1] - i2;
                if (i8 >= i6) {
                    i4 = 256;
                } else {
                    i4++;
                    if (i8 < 0) {
                        i8 = -i8;
                    }
                    int i9 = iArr[0] - i;
                    if (i9 < 0) {
                        i9 = -i9;
                    }
                    int i10 = i8 + i9;
                    if (i10 < i6) {
                        int i11 = iArr[2] - i3;
                        if (i11 < 0) {
                            i11 = -i11;
                        }
                        int i12 = i10 + i11;
                        if (i12 < i6) {
                            i7 = iArr[3];
                            i6 = i12;
                        }
                    }
                }
            }
            if (i5 >= 0) {
                int[] iArr2 = this.network[i5];
                int i13 = i2 - iArr2[1];
                if (i13 >= i6) {
                    i5 = -1;
                } else {
                    i5--;
                    if (i13 < 0) {
                        i13 = -i13;
                    }
                    int i14 = iArr2[0] - i;
                    if (i14 < 0) {
                        i14 = -i14;
                    }
                    int i15 = i13 + i14;
                    if (i15 < i6) {
                        int i16 = iArr2[2] - i3;
                        if (i16 < 0) {
                            i16 = -i16;
                        }
                        int i17 = i16 + i15;
                        if (i17 < i6) {
                            i7 = iArr2[3];
                            i6 = i17;
                        }
                    }
                }
            }
        }
    }

    public byte[] process() {
        learn();
        unbiasnet();
        inxbuild();
        return colorMap();
    }

    public void unbiasnet() {
        for (int i = 0; i < 256; i++) {
            int[] iArr = this.network[i];
            iArr[0] = iArr[0] >> 4;
            iArr[1] = iArr[1] >> 4;
            iArr[2] = iArr[2] >> 4;
            iArr[3] = i;
        }
    }

    protected void alterneigh(int i, int i2, int i3, int i4, int i5) {
        int i6 = i2 - i;
        if (i6 < -1) {
            i6 = -1;
        }
        int i7 = i2 + i;
        if (i7 > 256) {
            i7 = 256;
        }
        int i8 = i2 + 1;
        int i9 = i2 - 1;
        int i10 = 1;
        while (true) {
            if (i8 >= i7 && i9 <= i6) {
                return;
            }
            i10++;
            int i11 = this.radpower[i10];
            if (i8 < i7) {
                int i12 = i8 + 1;
                int[] iArr = this.network[i8];
                try {
                    int i13 = iArr[0];
                    iArr[0] = i13 - (((i13 - i3) * i11) / alpharadbias);
                    int i14 = iArr[1];
                    iArr[1] = i14 - (((i14 - i4) * i11) / alpharadbias);
                    int i15 = iArr[2];
                    iArr[2] = i15 - (((i15 - i5) * i11) / alpharadbias);
                } catch (Exception unused) {
                }
                i8 = i12;
            }
            if (i9 > i6) {
                int i16 = i9 - 1;
                int[] iArr2 = this.network[i9];
                try {
                    int i17 = iArr2[0];
                    iArr2[0] = i17 - (((i17 - i3) * i11) / alpharadbias);
                    int i18 = iArr2[1];
                    iArr2[1] = i18 - (((i18 - i4) * i11) / alpharadbias);
                    int i19 = iArr2[2];
                    iArr2[2] = i19 - ((i11 * (i19 - i5)) / alpharadbias);
                } catch (Exception unused2) {
                }
                i9 = i16;
            }
        }
    }

    protected void altersingle(int i, int i2, int i3, int i4, int i5) {
        int[] iArr = this.network[i2];
        int i6 = iArr[0];
        iArr[0] = i6 - (((i6 - i3) * i) / 1024);
        int i7 = iArr[1];
        iArr[1] = i7 - (((i7 - i4) * i) / 1024);
        int i8 = iArr[2];
        iArr[2] = i8 - ((i * (i8 - i5)) / 1024);
    }

    protected int contest(int i, int i2, int i3) {
        int i4 = Integer.MAX_VALUE;
        int i5 = -1;
        int i6 = -1;
        int i7 = Integer.MAX_VALUE;
        for (int i8 = 0; i8 < 256; i8++) {
            int[] iArr = this.network[i8];
            int i9 = iArr[0] - i;
            if (i9 < 0) {
                i9 = -i9;
            }
            int i10 = iArr[1] - i2;
            if (i10 < 0) {
                i10 = -i10;
            }
            int i11 = i9 + i10;
            int i12 = iArr[2] - i3;
            if (i12 < 0) {
                i12 = -i12;
            }
            int i13 = i11 + i12;
            if (i13 < i4) {
                i5 = i8;
                i4 = i13;
            }
            int[] iArr2 = this.bias;
            int i14 = i13 - (iArr2[i8] >> 12);
            if (i14 < i7) {
                i6 = i8;
                i7 = i14;
            }
            int[] iArr3 = this.freq;
            int i15 = iArr3[i8];
            int i16 = i15 >> 10;
            iArr3[i8] = i15 - i16;
            iArr2[i8] = iArr2[i8] + (i16 << 10);
        }
        int[] iArr4 = this.freq;
        iArr4[i5] = iArr4[i5] + 64;
        int[] iArr5 = this.bias;
        iArr5[i5] = iArr5[i5] - 65536;
        return i6;
    }
}
