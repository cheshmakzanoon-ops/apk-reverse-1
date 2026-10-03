package net.aihelp.core.p004ui.glide.gifdecoder;

import android.graphics.Bitmap;
import android.util.Log;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Iterator;
import kotlin.UByte;

public class GifDecoder {
    private static final Bitmap.Config BITMAP_CONFIG = Bitmap.Config.ARGB_8888;
    private static final int DISPOSAL_BACKGROUND = 2;
    private static final int DISPOSAL_NONE = 1;
    private static final int DISPOSAL_PREVIOUS = 3;
    private static final int DISPOSAL_UNSPECIFIED = 0;
    private static final int INITIAL_FRAME_POINTER = -1;
    private static final int MAX_STACK_SIZE = 4096;
    private static final int NULL_CODE = -1;
    public static final int STATUS_FORMAT_ERROR = 1;
    public static final int STATUS_OK = 0;
    public static final int STATUS_OPEN_ERROR = 2;
    public static final int STATUS_PARTIAL_DECODE = 3;
    private static final String TAG = "GifDecoder";
    public static final int TOTAL_ITERATION_COUNT_FOREVER = 0;
    private int[] act;
    private BitmapProvider bitmapProvider;
    private byte[] data;
    private int framePointer;
    private byte[] mainPixels;
    private int[] mainScratch;
    private GifHeaderParser parser;
    private byte[] pixelStack;
    private short[] prefix;
    private Bitmap previousImage;
    private ByteBuffer rawData;
    private boolean savePrevious;
    private int status;
    private byte[] suffix;
    private final int[] pct = new int[256];
    private final byte[] block = new byte[256];
    private GifHeader header = new GifHeader();

    public interface BitmapProvider {
        Bitmap obtain(int i, int i2, Bitmap.Config config);

        void release(Bitmap bitmap);
    }

    public GifDecoder(BitmapProvider bitmapProvider) {
        this.bitmapProvider = bitmapProvider;
    }

    public int getWidth() {
        return this.header.width;
    }

    public int getHeight() {
        return this.header.height;
    }

    public byte[] getData() {
        return this.data;
    }

    public int getStatus() {
        return this.status;
    }

    public void advance() {
        this.framePointer = (this.framePointer + 1) % this.header.frameCount;
    }

    public int getDelay(int i) {
        if (i < 0 || i >= this.header.frameCount) {
            return -1;
        }
        return this.header.frames.get(i).delay;
    }

    public int getNextDelay() {
        int i;
        if (this.header.frameCount <= 0 || (i = this.framePointer) < 0) {
            return -1;
        }
        return getDelay(i);
    }

    public int getFrameCount() {
        return this.header.frameCount;
    }

    public int getCurrentFrameIndex() {
        return this.framePointer;
    }

    public void resetFrameIndex() {
        this.framePointer = -1;
    }

    @Deprecated
    public int getLoopCount() {
        if (this.header.loopCount == -1) {
            return 1;
        }
        return this.header.loopCount;
    }

    public int getNetscapeLoopCount() {
        return this.header.loopCount;
    }

    public int getTotalIterationCount() {
        if (this.header.loopCount == -1) {
            return 1;
        }
        if (this.header.loopCount == 0) {
            return 0;
        }
        return this.header.loopCount + 1;
    }

    public synchronized Bitmap getNextFrame() {
        if (this.header.frameCount <= 0 || this.framePointer < 0) {
            String str = TAG;
            if (Log.isLoggable(str, 3)) {
                Log.d(str, "unable to decode frame, frameCount=" + this.header.frameCount + " framePointer=" + this.framePointer);
            }
            this.status = 1;
        }
        int i = this.status;
        if (i != 1 && i != 2) {
            this.status = 0;
            GifFrame gifFrame = this.header.frames.get(this.framePointer);
            int i2 = this.framePointer - 1;
            GifFrame gifFrame2 = i2 >= 0 ? this.header.frames.get(i2) : null;
            int[] iArr = gifFrame.lct != null ? gifFrame.lct : this.header.gct;
            this.act = iArr;
            if (iArr == null) {
                String str2 = TAG;
                if (Log.isLoggable(str2, 3)) {
                    Log.d(str2, "No Valid Color Table");
                }
                this.status = 1;
                return null;
            }
            if (gifFrame.transparency) {
                int[] iArr2 = this.act;
                System.arraycopy(iArr2, 0, this.pct, 0, iArr2.length);
                int[] iArr3 = this.pct;
                this.act = iArr3;
                iArr3[gifFrame.transIndex] = 0;
            }
            return setPixels(gifFrame, gifFrame2);
        }
        String str3 = TAG;
        if (Log.isLoggable(str3, 3)) {
            Log.d(str3, "Unable to decode frame, status=" + this.status);
        }
        return null;
    }

    public int read(InputStream inputStream, int i) {
        if (inputStream != null) {
            try {
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(i > 0 ? i + 4096 : 16384);
                byte[] bArr = new byte[16384];
                while (true) {
                    int i2 = inputStream.read(bArr, 0, 16384);
                    if (i2 == -1) {
                        break;
                    }
                    byteArrayOutputStream.write(bArr, 0, i2);
                }
                byteArrayOutputStream.flush();
                read(byteArrayOutputStream.toByteArray());
            } catch (IOException e) {
                Log.w(TAG, "Error reading data from stream", e);
            }
        } else {
            this.status = 2;
        }
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (IOException e2) {
                Log.w(TAG, "Error closing stream", e2);
            }
        }
        return this.status;
    }

    public void clear() {
        this.header = null;
        this.data = null;
        this.mainPixels = null;
        this.mainScratch = null;
        Bitmap bitmap = this.previousImage;
        if (bitmap != null) {
            this.bitmapProvider.release(bitmap);
        }
        this.previousImage = null;
        this.rawData = null;
    }

    public void setData(GifHeader gifHeader, byte[] bArr) {
        this.header = gifHeader;
        this.data = bArr;
        this.status = 0;
        this.framePointer = -1;
        ByteBuffer byteBufferWrap = ByteBuffer.wrap(bArr);
        this.rawData = byteBufferWrap;
        byteBufferWrap.rewind();
        this.rawData.order(ByteOrder.LITTLE_ENDIAN);
        this.savePrevious = false;
        Iterator<GifFrame> it = gifHeader.frames.iterator();
        while (it.hasNext()) {
            if (it.next().dispose == 3) {
                this.savePrevious = true;
                break;
            }
        }
        this.mainPixels = new byte[gifHeader.width * gifHeader.height];
        this.mainScratch = new int[gifHeader.width * gifHeader.height];
    }

    private GifHeaderParser getHeaderParser() {
        if (this.parser == null) {
            this.parser = new GifHeaderParser();
        }
        return this.parser;
    }

    public int read(byte[] bArr) {
        this.data = bArr;
        this.header = getHeaderParser().setData(bArr).parseHeader();
        if (bArr != null) {
            ByteBuffer byteBufferWrap = ByteBuffer.wrap(bArr);
            this.rawData = byteBufferWrap;
            byteBufferWrap.rewind();
            this.rawData.order(ByteOrder.LITTLE_ENDIAN);
            this.mainPixels = new byte[this.header.width * this.header.height];
            this.mainScratch = new int[this.header.width * this.header.height];
            this.savePrevious = false;
            Iterator<GifFrame> it = this.header.frames.iterator();
            while (it.hasNext()) {
                if (it.next().dispose == 3) {
                    this.savePrevious = true;
                    break;
                }
            }
        }
        return this.status;
    }

    private android.graphics.Bitmap setPixels(net.aihelp.core.p004ui.glide.gifdecoder.GifFrame r18, net.aihelp.core.p004ui.glide.gifdecoder.GifFrame r19) {
        throw new UnsupportedOperationException("Method not decompiled: net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder.setPixels(net.aihelp.core.ui.glide.gifdecoder.GifFrame, net.aihelp.core.ui.glide.gifdecoder.GifFrame):android.graphics.Bitmap");
    }

    private void decodeBitmapData(GifFrame gifFrame) {
        short s;
        if (gifFrame != null) {
            this.rawData.position(gifFrame.bufferFrameStart);
        }
        int i = gifFrame == null ? this.header.width * this.header.height : gifFrame.f80ih * gifFrame.f81iw;
        byte[] bArr = this.mainPixels;
        if (bArr == null || bArr.length < i) {
            this.mainPixels = new byte[i];
        }
        if (this.prefix == null) {
            this.prefix = new short[4096];
        }
        if (this.suffix == null) {
            this.suffix = new byte[4096];
        }
        if (this.pixelStack == null) {
            this.pixelStack = new byte[4097];
        }
        int i2 = read();
        int i3 = 1;
        int i4 = 1 << i2;
        int i5 = i4 + 1;
        int i6 = i4 + 2;
        int i7 = i2 + 1;
        int i8 = (1 << i7) - 1;
        for (int i9 = 0; i9 < i4; i9++) {
            this.prefix[i9] = 0;
            this.suffix[i9] = (byte) i9;
        }
        int i10 = -1;
        int i11 = i7;
        int i12 = i6;
        int i13 = i8;
        int i14 = 0;
        int block = 0;
        int i15 = 0;
        int i16 = 0;
        int i17 = 0;
        int i18 = 0;
        int i19 = 0;
        int i20 = 0;
        int i21 = -1;
        while (i14 < i) {
            int i22 = 3;
            if (block == 0) {
                block = readBlock();
                if (block <= 0) {
                    this.status = 3;
                    break;
                }
                i15 = 0;
            }
            i17 += (this.block[i15] & UByte.MAX_VALUE) << i16;
            i16 += 8;
            i15 += i3;
            block += i10;
            i12 = i12;
            i11 = i11;
            int i23 = i21;
            int i24 = i19;
            while (true) {
                if (i16 < i11) {
                    i19 = i24;
                    i21 = i23;
                    i5 = i5;
                    i3 = 1;
                    break;
                }
                int i25 = i17 & i13;
                i17 >>= i11;
                i16 -= i11;
                if (i25 != i4) {
                    if (i25 > i12) {
                        this.status = i22;
                    } else if (i25 != i5) {
                        int i26 = i7;
                        int i27 = i23;
                        if (i27 == -1) {
                            this.pixelStack[i20] = this.suffix[i25];
                            i23 = i25;
                            i24 = i23;
                            i7 = i26;
                            i20++;
                            i22 = 3;
                            i10 = -1;
                        } else {
                            if (i25 >= i12) {
                                this.pixelStack[i20] = (byte) i24;
                                s = i27;
                                i20++;
                            } else {
                                s = i25;
                            }
                            while (s >= i4) {
                                this.pixelStack[i20] = this.suffix[s];
                                s = this.prefix[s];
                                i20++;
                                i4 = i4;
                            }
                            int i28 = i4;
                            byte[] bArr2 = this.suffix;
                            int i29 = bArr2[s] & UByte.MAX_VALUE;
                            int i30 = i20 + 1;
                            int i31 = i6;
                            byte b = (byte) i29;
                            this.pixelStack[i20] = b;
                            if (i12 < 4096) {
                                this.prefix[i12] = (short) i27;
                                bArr2[i12] = b;
                                i12++;
                                if ((i12 & i13) == 0 && i12 < 4096) {
                                    i11++;
                                    i13 += i12;
                                }
                            }
                            i20 = i30;
                            while (i20 > 0) {
                                i20--;
                                this.mainPixels[i18] = this.pixelStack[i20];
                                i14++;
                                i18++;
                            }
                            i23 = i25;
                            i4 = i28;
                            i5 = i5;
                            i6 = i31;
                            i22 = 3;
                            i10 = -1;
                            i24 = i29;
                            i7 = i26;
                        }
                    }
                    i21 = i23;
                    i19 = i24;
                    i3 = 1;
                    i10 = -1;
                    break;
                }
                i11 = i7;
                i12 = i6;
                i13 = i8;
                i10 = -1;
                i23 = -1;
            }
        }
        for (int i32 = i18; i32 < i; i32++) {
            this.mainPixels[i32] = 0;
        }
    }

    private int read() {
        try {
            return this.rawData.get() & UByte.MAX_VALUE;
        } catch (Exception unused) {
            this.status = 1;
            return 0;
        }
    }

    private int readBlock() {
        int i = read();
        int i2 = 0;
        if (i > 0) {
            while (i2 < i) {
                int i3 = i - i2;
                try {
                    this.rawData.get(this.block, i2, i3);
                    i2 += i3;
                } catch (Exception e) {
                    Log.w(TAG, "Error Reading Block", e);
                    this.status = 1;
                }
            }
        }
        return i2;
    }

    private Bitmap getNextBitmap() {
        BitmapProvider bitmapProvider = this.bitmapProvider;
        int i = this.header.width;
        int i2 = this.header.height;
        Bitmap.Config config = BITMAP_CONFIG;
        Bitmap bitmapObtain = bitmapProvider.obtain(i, i2, config);
        if (bitmapObtain == null) {
            bitmapObtain = Bitmap.createBitmap(this.header.width, this.header.height, config);
        }
        setAlpha(bitmapObtain);
        return bitmapObtain;
    }

    private static void setAlpha(Bitmap bitmap) {
        bitmap.setHasAlpha(true);
    }
}
