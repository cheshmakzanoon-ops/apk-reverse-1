package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.graphics.Bitmap;
import android.util.Log;
import java.io.IOException;
import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder;
import net.aihelp.core.p004ui.glide.gifdecoder.GifHeader;
import net.aihelp.core.p004ui.glide.gifdecoder.GifHeaderParser;
import net.aihelp.core.p004ui.glide.gifencoder.AnimatedGifEncoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.UnitTransformation;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.BitmapResource;
import net.aihelp.core.p004ui.glide.util.LogTime;

public class GifResourceEncoder implements ResourceEncoder<GifDrawable> {
    private static final Factory FACTORY = new Factory();
    private static final String TAG = "GifEncoder";
    private final BitmapPool bitmapPool;
    private final Factory factory;
    private final GifDecoder.BitmapProvider provider;

    public GifResourceEncoder(BitmapPool bitmapPool) {
        this(bitmapPool, FACTORY);
    }

    GifResourceEncoder(BitmapPool bitmapPool, Factory factory) {
        this.bitmapPool = bitmapPool;
        this.provider = new GifBitmapProvider(bitmapPool);
        this.factory = factory;
    }

    @Override
    public boolean encode(Resource<GifDrawable> resource, OutputStream outputStream) {
        long logTime = LogTime.getLogTime();
        GifDrawable gifDrawable = resource.get();
        Transformation<Bitmap> frameTransformation = gifDrawable.getFrameTransformation();
        if (frameTransformation instanceof UnitTransformation) {
            return writeDataDirect(gifDrawable.getData(), outputStream);
        }
        GifDecoder gifDecoderDecodeHeaders = decodeHeaders(gifDrawable.getData());
        AnimatedGifEncoder animatedGifEncoderBuildEncoder = this.factory.buildEncoder();
        if (!animatedGifEncoderBuildEncoder.start(outputStream)) {
            return false;
        }
        for (int i = 0; i < gifDecoderDecodeHeaders.getFrameCount(); i++) {
            Resource<Bitmap> transformedFrame = getTransformedFrame(gifDecoderDecodeHeaders.getNextFrame(), frameTransformation, gifDrawable);
            try {
                if (animatedGifEncoderBuildEncoder.addFrame(transformedFrame.get())) {
                    animatedGifEncoderBuildEncoder.setDelay(gifDecoderDecodeHeaders.getDelay(gifDecoderDecodeHeaders.getCurrentFrameIndex()));
                    gifDecoderDecodeHeaders.advance();
                    transformedFrame.recycle();
                } else {
                    transformedFrame.recycle();
                    return false;
                }
            } catch (Throwable th) {
                transformedFrame.recycle();
                throw th;
            }
        }
        boolean zFinish = animatedGifEncoderBuildEncoder.finish();
        if (Log.isLoggable(TAG, 2)) {
            Log.v(TAG, "Encoded gif with " + gifDecoderDecodeHeaders.getFrameCount() + " frames and " + gifDrawable.getData().length + " bytes in " + LogTime.getElapsedMillis(logTime) + " ms");
        }
        return zFinish;
    }

    private boolean writeDataDirect(byte[] bArr, OutputStream outputStream) {
        try {
            outputStream.write(bArr);
            return true;
        } catch (IOException e) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Failed to write data to output stream in GifResourceEncoder", e);
            }
            return false;
        }
    }

    private GifDecoder decodeHeaders(byte[] bArr) {
        GifHeaderParser gifHeaderParserBuildParser = this.factory.buildParser();
        gifHeaderParserBuildParser.setData(bArr);
        GifHeader header = gifHeaderParserBuildParser.parseHeader();
        GifDecoder gifDecoderBuildDecoder = this.factory.buildDecoder(this.provider);
        gifDecoderBuildDecoder.setData(header, bArr);
        gifDecoderBuildDecoder.advance();
        return gifDecoderBuildDecoder;
    }

    private Resource<Bitmap> getTransformedFrame(Bitmap bitmap, Transformation<Bitmap> transformation, GifDrawable gifDrawable) {
        Resource<Bitmap> resourceBuildFrameResource = this.factory.buildFrameResource(bitmap, this.bitmapPool);
        Resource<Bitmap> resourceTransform = transformation.transform(resourceBuildFrameResource, gifDrawable.getIntrinsicWidth(), gifDrawable.getIntrinsicHeight());
        if (!resourceBuildFrameResource.equals(resourceTransform)) {
            resourceBuildFrameResource.recycle();
        }
        return resourceTransform;
    }

    @Override
    public String getId() {
        return "";
    }

    static class Factory {
        Factory() {
        }

        public GifDecoder buildDecoder(GifDecoder.BitmapProvider bitmapProvider) {
            return new GifDecoder(bitmapProvider);
        }

        public GifHeaderParser buildParser() {
            return new GifHeaderParser();
        }

        public AnimatedGifEncoder buildEncoder() {
            return new AnimatedGifEncoder();
        }

        public Resource<Bitmap> buildFrameResource(Bitmap bitmap, BitmapPool bitmapPool) {
            return new BitmapResource(bitmap, bitmapPool);
        }
    }
}
