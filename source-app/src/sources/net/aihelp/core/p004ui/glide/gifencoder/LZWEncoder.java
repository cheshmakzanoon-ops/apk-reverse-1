package net.aihelp.core.p004ui.glide.gifencoder;

import java.io.IOException;
import java.io.OutputStream;
import kotlin.UByte;
import okhttp3.internal.http2.Settings;

class LZWEncoder {
    static final int BITS = 12;
    private static final int EOF = -1;
    static final int HSIZE = 5003;
    int ClearCode;
    int EOFCode;
    int a_count;
    private int curPixel;
    int g_init_bits;
    private int imgH;
    private int imgW;
    private int initCodeSize;
    int maxcode;
    int n_bits;
    private byte[] pixAry;
    private int remaining;
    int maxbits = 12;
    int maxmaxcode = 4096;
    int[] htab = new int[HSIZE];
    int[] codetab = new int[HSIZE];
    int hsize = HSIZE;
    int free_ent = 0;
    boolean clear_flg = false;
    int cur_accum = 0;
    int cur_bits = 0;
    int[] masks = {0, 1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095, 8191, 16383, 32767, Settings.DEFAULT_INITIAL_WINDOW_SIZE};
    byte[] accum = new byte[256];

    final int MAXCODE(int i) {
        return (1 << i) - 1;
    }

    LZWEncoder(int i, int i2, byte[] bArr, int i3) {
        this.imgW = i;
        this.imgH = i2;
        this.pixAry = bArr;
        this.initCodeSize = Math.max(2, i3);
    }

    void char_out(byte b, OutputStream outputStream) throws IOException {
        byte[] bArr = this.accum;
        int i = this.a_count;
        int i2 = i + 1;
        this.a_count = i2;
        bArr[i] = b;
        if (i2 >= 254) {
            flush_char(outputStream);
        }
    }

    void cl_block(OutputStream outputStream) throws IOException {
        cl_hash(this.hsize);
        int i = this.ClearCode;
        this.free_ent = i + 2;
        this.clear_flg = true;
        output(i, outputStream);
    }

    void cl_hash(int i) {
        for (int i2 = 0; i2 < i; i2++) {
            this.htab[i2] = -1;
        }
    }

    void compress(int i, OutputStream outputStream) throws IOException {
        this.g_init_bits = i;
        int i2 = 0;
        this.clear_flg = false;
        this.n_bits = i;
        this.maxcode = MAXCODE(i);
        int i3 = 1 << (i - 1);
        this.ClearCode = i3;
        this.EOFCode = i3 + 1;
        this.free_ent = i3 + 2;
        this.a_count = 0;
        int iNextPixel = nextPixel();
        for (int i4 = this.hsize; i4 < 65536; i4 *= 2) {
            i2++;
        }
        int i5 = 8 - i2;
        int i6 = this.hsize;
        cl_hash(i6);
        output(this.ClearCode, outputStream);
        while (true) {
            int iNextPixel2 = nextPixel();
            if (iNextPixel2 != -1) {
                int i7 = (iNextPixel2 << this.maxbits) + iNextPixel;
                int i8 = (iNextPixel2 << i5) ^ iNextPixel;
                int i9 = this.htab[i8];
                if (i9 == i7) {
                    iNextPixel = this.codetab[i8];
                } else {
                    if (i9 >= 0) {
                        int i10 = i6 - i8;
                        if (i8 == 0) {
                            i10 = 1;
                        }
                        while (true) {
                            i8 -= i10;
                            if (i8 < 0) {
                                i8 += i6;
                            }
                            int i11 = this.htab[i8];
                            if (i11 == i7) {
                                iNextPixel = this.codetab[i8];
                            } else if (i11 < 0) {
                            }
                        }
                    }
                    output(iNextPixel, outputStream);
                    int i12 = this.free_ent;
                    if (i12 < this.maxmaxcode) {
                        int[] iArr = this.codetab;
                        this.free_ent = i12 + 1;
                        iArr[i8] = i12;
                        this.htab[i8] = i7;
                    } else {
                        cl_block(outputStream);
                    }
                    iNextPixel = iNextPixel2;
                }
            } else {
                output(iNextPixel, outputStream);
                output(this.EOFCode, outputStream);
                return;
            }
        }
    }

    void encode(OutputStream outputStream) throws IOException {
        outputStream.write(this.initCodeSize);
        this.remaining = this.imgW * this.imgH;
        this.curPixel = 0;
        compress(this.initCodeSize + 1, outputStream);
        outputStream.write(0);
    }

    void flush_char(OutputStream outputStream) throws IOException {
        int i = this.a_count;
        if (i > 0) {
            outputStream.write(i);
            outputStream.write(this.accum, 0, this.a_count);
            this.a_count = 0;
        }
    }

    private int nextPixel() {
        int i = this.remaining;
        if (i == 0) {
            return -1;
        }
        this.remaining = i - 1;
        byte[] bArr = this.pixAry;
        int i2 = this.curPixel;
        this.curPixel = i2 + 1;
        return bArr[i2] & UByte.MAX_VALUE;
    }

    void output(int i, OutputStream outputStream) throws IOException {
        int i2 = this.cur_accum;
        int[] iArr = this.masks;
        int i3 = this.cur_bits;
        int i4 = i2 & iArr[i3];
        this.cur_accum = i4;
        if (i3 > 0) {
            this.cur_accum = i4 | (i << i3);
        } else {
            this.cur_accum = i;
        }
        this.cur_bits = i3 + this.n_bits;
        while (this.cur_bits >= 8) {
            char_out((byte) (this.cur_accum & 255), outputStream);
            this.cur_accum >>= 8;
            this.cur_bits -= 8;
        }
        if (this.free_ent > this.maxcode || this.clear_flg) {
            if (this.clear_flg) {
                int i5 = this.g_init_bits;
                this.n_bits = i5;
                this.maxcode = MAXCODE(i5);
                this.clear_flg = false;
            } else {
                int i6 = this.n_bits + 1;
                this.n_bits = i6;
                if (i6 == this.maxbits) {
                    this.maxcode = this.maxmaxcode;
                } else {
                    this.maxcode = MAXCODE(i6);
                }
            }
        }
        if (i == this.EOFCode) {
            while (this.cur_bits > 0) {
                char_out((byte) (this.cur_accum & 255), outputStream);
                this.cur_accum >>= 8;
                this.cur_bits -= 8;
            }
            flush_char(outputStream);
        }
    }
}
