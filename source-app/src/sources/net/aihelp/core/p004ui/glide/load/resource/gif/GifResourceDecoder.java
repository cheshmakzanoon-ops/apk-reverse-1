package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Queue;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder;
import net.aihelp.core.p004ui.glide.gifdecoder.GifHeader;
import net.aihelp.core.p004ui.glide.gifdecoder.GifHeaderParser;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.UnitTransformation;
import net.aihelp.core.p004ui.glide.util.Util;

public class GifResourceDecoder implements ResourceDecoder<InputStream, GifDrawable> {
    private static final String TAG = "GifResourceDecoder";
    private final BitmapPool bitmapPool;
    private final Context context;
    private final GifDecoderPool decoderPool;
    private final GifHeaderParserPool parserPool;
    private final GifBitmapProvider provider;
    private static final GifHeaderParserPool PARSER_POOL = new GifHeaderParserPool();
    private static final GifDecoderPool DECODER_POOL = new GifDecoderPool();

    public GifResourceDecoder(Context context) {
        this(context, Glide.get(context).getBitmapPool());
    }

    public GifResourceDecoder(Context context, BitmapPool bitmapPool) {
        this(context, bitmapPool, PARSER_POOL, DECODER_POOL);
    }

    GifResourceDecoder(Context context, BitmapPool bitmapPool, GifHeaderParserPool gifHeaderParserPool, GifDecoderPool gifDecoderPool) {
        this.context = context.getApplicationContext();
        this.bitmapPool = bitmapPool;
        this.decoderPool = gifDecoderPool;
        this.provider = new GifBitmapProvider(bitmapPool);
        this.parserPool = gifHeaderParserPool;
    }

    @Override
    public GifDrawableResource decode(InputStream inputStream, int i, int i2) {
        byte[] bArrInputStreamToBytes = inputStreamToBytes(inputStream);
        GifHeaderParser gifHeaderParserObtain = this.parserPool.obtain(bArrInputStreamToBytes);
        GifDecoder gifDecoderObtain = this.decoderPool.obtain(this.provider);
        try {
            return decode(bArrInputStreamToBytes, i, i2, gifHeaderParserObtain, gifDecoderObtain);
        } finally {
            this.parserPool.release(gifHeaderParserObtain);
            this.decoderPool.release(gifDecoderObtain);
        }
    }

    private GifDrawableResource decode(byte[] bArr, int i, int i2, GifHeaderParser gifHeaderParser, GifDecoder gifDecoder) {
        Bitmap bitmapDecodeFirstFrame;
        GifHeader header = gifHeaderParser.parseHeader();
        if (header.getNumFrames() <= 0 || header.getStatus() != 0 || (bitmapDecodeFirstFrame = decodeFirstFrame(gifDecoder, header, bArr)) == null) {
            return null;
        }
        return new GifDrawableResource(new GifDrawable(this.context, this.provider, this.bitmapPool, UnitTransformation.get(), i, i2, header, bArr, bitmapDecodeFirstFrame));
    }

    private Bitmap decodeFirstFrame(GifDecoder gifDecoder, GifHeader gifHeader, byte[] bArr) {
        gifDecoder.setData(gifHeader, bArr);
        gifDecoder.advance();
        return gifDecoder.getNextFrame();
    }

    @Override
    public String getId() {
        return "";
    }

    private static byte[] inputStreamToBytes(InputStream inputStream) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(16384);
        try {
            byte[] bArr = new byte[16384];
            while (true) {
                int i = inputStream.read(bArr);
                if (i == -1) {
                    break;
                }
                byteArrayOutputStream.write(bArr, 0, i);
            }
            byteArrayOutputStream.flush();
        } catch (IOException e) {
            Log.w(TAG, "Error reading data from stream", e);
        }
        return byteArrayOutputStream.toByteArray();
    }

    static class GifDecoderPool {
        private final Queue<GifDecoder> pool = Util.createQueue(0);

        GifDecoderPool() {
        }

        public synchronized GifDecoder obtain(GifDecoder.BitmapProvider bitmapProvider) {
            GifDecoder gifDecoderPoll;
            gifDecoderPoll = this.pool.poll();
            if (gifDecoderPoll == null) {
                gifDecoderPoll = new GifDecoder(bitmapProvider);
            }
            return gifDecoderPoll;
        }

        public synchronized void release(GifDecoder gifDecoder) {
            gifDecoder.clear();
            this.pool.offer(gifDecoder);
        }
    }

    static class GifHeaderParserPool {
        private final Queue<GifHeaderParser> pool = Util.createQueue(0);

        GifHeaderParserPool() {
        }

        public synchronized GifHeaderParser obtain(byte[] bArr) {
            GifHeaderParser gifHeaderParserPoll;
            gifHeaderParserPoll = this.pool.poll();
            if (gifHeaderParserPoll == null) {
                gifHeaderParserPoll = new GifHeaderParser();
            }
            return gifHeaderParserPoll.setData(bArr);
        }

        public synchronized void release(GifHeaderParser gifHeaderParser) {
            gifHeaderParser.clear();
            this.pool.offer(gifHeaderParser);
        }
    }
}
