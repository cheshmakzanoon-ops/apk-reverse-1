package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder;
import net.aihelp.core.p004ui.glide.gifdecoder.GifHeader;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;

public class GifDrawable extends GlideDrawable implements GifFrameLoader.FrameCallback {
    private boolean applyGravity;
    private final GifDecoder decoder;
    private final Rect destRect;
    private final GifFrameLoader frameLoader;
    private boolean isRecycled;
    private boolean isRunning;
    private boolean isStarted;
    private boolean isVisible;
    private int loopCount;
    private int maxLoopCount;
    private final Paint paint;
    private final GifState state;

    @Override
    public int getOpacity() {
        return -2;
    }

    @Override
    public boolean isAnimated() {
        return true;
    }

    public GifDrawable(Context context, GifDecoder.BitmapProvider bitmapProvider, BitmapPool bitmapPool, Transformation<Bitmap> transformation, int i, int i2, GifHeader gifHeader, byte[] bArr, Bitmap bitmap) {
        this(new GifState(gifHeader, bArr, context, transformation, i, i2, bitmapProvider, bitmapPool, bitmap));
    }

    public GifDrawable(GifDrawable gifDrawable, Bitmap bitmap, Transformation<Bitmap> transformation) {
        this(new GifState(gifDrawable.state.gifHeader, gifDrawable.state.data, gifDrawable.state.context, transformation, gifDrawable.state.targetWidth, gifDrawable.state.targetHeight, gifDrawable.state.bitmapProvider, gifDrawable.state.bitmapPool, bitmap));
    }

    GifDrawable(GifState gifState) {
        this.destRect = new Rect();
        this.isVisible = true;
        this.maxLoopCount = -1;
        if (gifState == null) {
            throw new NullPointerException("GifState must not be null");
        }
        this.state = gifState;
        GifDecoder gifDecoder = new GifDecoder(gifState.bitmapProvider);
        this.decoder = gifDecoder;
        this.paint = new Paint();
        gifDecoder.setData(gifState.gifHeader, gifState.data);
        GifFrameLoader gifFrameLoader = new GifFrameLoader(gifState.context, this, gifDecoder, gifState.targetWidth, gifState.targetHeight);
        this.frameLoader = gifFrameLoader;
        gifFrameLoader.setFrameTransformation(gifState.frameTransformation);
    }

    GifDrawable(GifDecoder gifDecoder, GifFrameLoader gifFrameLoader, Bitmap bitmap, BitmapPool bitmapPool, Paint paint) {
        this.destRect = new Rect();
        this.isVisible = true;
        this.maxLoopCount = -1;
        this.decoder = gifDecoder;
        this.frameLoader = gifFrameLoader;
        GifState gifState = new GifState(null);
        this.state = gifState;
        this.paint = paint;
        gifState.bitmapPool = bitmapPool;
        gifState.firstFrame = bitmap;
    }

    public Bitmap getFirstFrame() {
        return this.state.firstFrame;
    }

    public void setFrameTransformation(Transformation<Bitmap> transformation, Bitmap bitmap) {
        if (bitmap == null) {
            throw new NullPointerException("The first frame of the GIF must not be null");
        }
        if (transformation == null) {
            throw new NullPointerException("The frame transformation must not be null");
        }
        this.state.frameTransformation = transformation;
        this.state.firstFrame = bitmap;
        this.frameLoader.setFrameTransformation(transformation);
    }

    public GifDecoder getDecoder() {
        return this.decoder;
    }

    public Transformation<Bitmap> getFrameTransformation() {
        return this.state.frameTransformation;
    }

    public byte[] getData() {
        return this.state.data;
    }

    public int getFrameCount() {
        return this.decoder.getFrameCount();
    }

    private void resetLoopCount() {
        this.loopCount = 0;
    }

    @Override
    public void start() {
        this.isStarted = true;
        resetLoopCount();
        if (this.isVisible) {
            startRunning();
        }
    }

    @Override
    public void stop() {
        this.isStarted = false;
        stopRunning();
    }

    private void reset() {
        this.frameLoader.clear();
        invalidateSelf();
    }

    private void startRunning() {
        if (this.decoder.getFrameCount() == 1) {
            invalidateSelf();
        } else {
            if (this.isRunning) {
                return;
            }
            this.isRunning = true;
            this.frameLoader.start();
            invalidateSelf();
        }
    }

    private void stopRunning() {
        this.isRunning = false;
        this.frameLoader.stop();
    }

    @Override
    public boolean setVisible(boolean z, boolean z2) {
        this.isVisible = z;
        if (!z) {
            stopRunning();
        } else if (this.isStarted) {
            startRunning();
        }
        return super.setVisible(z, z2);
    }

    @Override
    public int getIntrinsicWidth() {
        return this.state.firstFrame.getWidth();
    }

    @Override
    public int getIntrinsicHeight() {
        return this.state.firstFrame.getHeight();
    }

    @Override
    public boolean isRunning() {
        return this.isRunning;
    }

    void setIsRunning(boolean z) {
        this.isRunning = z;
    }

    @Override
    protected void onBoundsChange(Rect rect) {
        super.onBoundsChange(rect);
        this.applyGravity = true;
    }

    @Override
    public void draw(Canvas canvas) {
        if (this.isRecycled) {
            return;
        }
        if (this.applyGravity) {
            Gravity.apply(119, getIntrinsicWidth(), getIntrinsicHeight(), getBounds(), this.destRect);
            this.applyGravity = false;
        }
        Bitmap currentFrame = this.frameLoader.getCurrentFrame();
        if (currentFrame == null) {
            currentFrame = this.state.firstFrame;
        }
        canvas.drawBitmap(currentFrame, (Rect) null, this.destRect, this.paint);
    }

    @Override
    public void setAlpha(int i) {
        this.paint.setAlpha(i);
    }

    @Override
    public void setColorFilter(ColorFilter colorFilter) {
        this.paint.setColorFilter(colorFilter);
    }

    @Override
    public void onFrameReady(int i) {
        if (getCallback() == null) {
            stop();
            reset();
            return;
        }
        invalidateSelf();
        if (i == this.decoder.getFrameCount() - 1) {
            this.loopCount++;
        }
        int i2 = this.maxLoopCount;
        if (i2 == -1 || this.loopCount < i2) {
            return;
        }
        stop();
    }

    @Override
    public Drawable.ConstantState getConstantState() {
        return this.state;
    }

    public void recycle() {
        this.isRecycled = true;
        this.state.bitmapPool.put(this.state.firstFrame);
        this.frameLoader.clear();
        this.frameLoader.stop();
    }

    boolean isRecycled() {
        return this.isRecycled;
    }

    @Override
    public void setLoopCount(int i) {
        if (i <= 0 && i != -1 && i != 0) {
            throw new IllegalArgumentException("Loop count must be greater than 0, or equal to GlideDrawable.LOOP_FOREVER, or equal to GlideDrawable.LOOP_INTRINSIC");
        }
        if (i == 0) {
            int totalIterationCount = this.decoder.getTotalIterationCount();
            this.maxLoopCount = totalIterationCount != 0 ? totalIterationCount : -1;
        } else {
            this.maxLoopCount = i;
        }
    }

    static class GifState extends Drawable.ConstantState {
        private static final int GRAVITY = 119;
        BitmapPool bitmapPool;
        GifDecoder.BitmapProvider bitmapProvider;
        Context context;
        byte[] data;
        Bitmap firstFrame;
        Transformation<Bitmap> frameTransformation;
        GifHeader gifHeader;
        int targetHeight;
        int targetWidth;

        @Override
        public int getChangingConfigurations() {
            return 0;
        }

        public GifState(GifHeader gifHeader, byte[] bArr, Context context, Transformation<Bitmap> transformation, int i, int i2, GifDecoder.BitmapProvider bitmapProvider, BitmapPool bitmapPool, Bitmap bitmap) {
            if (bitmap == null) {
                throw new NullPointerException("The first frame of the GIF must not be null");
            }
            this.gifHeader = gifHeader;
            this.data = bArr;
            this.bitmapPool = bitmapPool;
            this.firstFrame = bitmap;
            this.context = context.getApplicationContext();
            this.frameTransformation = transformation;
            this.targetWidth = i;
            this.targetHeight = i2;
            this.bitmapProvider = bitmapProvider;
        }

        public GifState(GifState gifState) {
            if (gifState != null) {
                this.gifHeader = gifState.gifHeader;
                this.data = gifState.data;
                this.context = gifState.context;
                this.frameTransformation = gifState.frameTransformation;
                this.targetWidth = gifState.targetWidth;
                this.targetHeight = gifState.targetHeight;
                this.bitmapProvider = gifState.bitmapProvider;
                this.bitmapPool = gifState.bitmapPool;
                this.firstFrame = gifState.firstFrame;
            }
        }

        @Override
        public Drawable newDrawable(Resources resources) {
            return newDrawable();
        }

        @Override
        public Drawable newDrawable() {
            return new GifDrawable(this);
        }
    }
}
