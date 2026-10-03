package coil.drawable;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Movie;
import android.graphics.Paint;
import android.graphics.Picture;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.SystemClock;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.vectordrawable.graphics.drawable.Animatable2Compat;
import coil.decode.DecodeUtils;
import coil.size.Scale;
import coil.transform.AnimatedTransformation;
import coil.transform.PixelOpacity;
import coil.util.GifUtils;
import java.util.ArrayList;
import java.util.List;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u0088\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\b\u0018\u0000 I2\u00020\u00012\u00020\u0002:\u0001IB#\b\u0007\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\b\u00101\u001a\u000202H\u0016J\u0010\u00103\u001a\u0002022\u0006\u00104\u001a\u00020*H\u0016J\u0010\u00105\u001a\u0002022\u0006\u00104\u001a\u00020*H\u0002J\b\u00106\u001a\u0004\u0018\u00010\u000bJ\b\u00107\u001a\u00020\u001fH\u0016J\b\u00108\u001a\u00020\u001fH\u0016J\b\u00109\u001a\u00020\u001fH\u0017J\u0006\u0010:\u001a\u00020\u001fJ\b\u0010\u001b\u001a\u00020\u001cH\u0016J\u0010\u0010;\u001a\u0002022\u0006\u0010<\u001a\u00020\u0010H\u0016J\u0010\u0010=\u001a\u0002022\u0006\u0010>\u001a\u00020\u001fH\u0016J\u0010\u0010?\u001a\u0002022\b\u0010\n\u001a\u0004\u0018\u00010\u000bJ\u0012\u0010@\u001a\u0002022\b\u0010A\u001a\u0004\u0018\u00010BH\u0016J\u000e\u0010C\u001a\u0002022\u0006\u0010$\u001a\u00020\u001fJ\b\u0010D\u001a\u000202H\u0016J\b\u0010E\u001a\u000202H\u0016J\u0010\u0010F\u001a\u00020\u001c2\u0006\u0010<\u001a\u00020\u0010H\u0016J\u0010\u0010G\u001a\u0002022\u0006\u0010.\u001a\u00020\u0014H\u0002J\b\u0010H\u001a\u00020\u001cH\u0002R\u0010\u0010\n\u001a\u0004\u0018\u00010\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00100\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u0018X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001a\u001a\u00020\u0018X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001b\u001a\u00020\u001cX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u001cX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001e\u001a\u00020\u001fX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010 \u001a\u00020!X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020#X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010$\u001a\u00020\u001fX\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&R\u0010\u0010'\u001a\u0004\u0018\u00010(X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010)\u001a\u0004\u0018\u00010*X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010+\u001a\u00020\u0018X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010,\u001a\u00020\u0016X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010-\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010.\u001a\u00020\u0014*\u00020*8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b/\u00100¨\u0006J"}, d2 = {"Lcoil/drawable/MovieDrawable;", "Landroid/graphics/drawable/Drawable;", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat;", "movie", "Landroid/graphics/Movie;", "config", "Landroid/graphics/Bitmap$Config;", "scale", "Lcoil/size/Scale;", "(Landroid/graphics/Movie;Landroid/graphics/Bitmap$Config;Lcoil/size/Scale;)V", "animatedTransformation", "Lcoil/transform/AnimatedTransformation;", "animatedTransformationPicture", "Landroid/graphics/Picture;", "callbacks", "", "Landroidx/vectordrawable/graphics/drawable/Animatable2Compat$AnimationCallback;", "getConfig", "()Landroid/graphics/Bitmap$Config;", "currentBounds", "Landroid/graphics/Rect;", "frameTimeMillis", "", "hardwareDx", "", "hardwareDy", "hardwareScale", "isRunning", "", "isSoftwareScalingEnabled", "loopIteration", "", "paint", "Landroid/graphics/Paint;", "pixelOpacity", "Lcoil/transform/PixelOpacity;", "repeatCount", "getScale", "()Lcoil/size/Scale;", "softwareBitmap", "Landroid/graphics/Bitmap;", "softwareCanvas", "Landroid/graphics/Canvas;", "softwareScale", "startTimeMillis", "tempCanvasBounds", "bounds", "getBounds", "(Landroid/graphics/Canvas;)Landroid/graphics/Rect;", "clearAnimationCallbacks", "", "draw", "canvas", "drawFrame", "getAnimatedTransformation", "getIntrinsicHeight", "getIntrinsicWidth", "getOpacity", "getRepeatCount", "registerAnimationCallback", "callback", "setAlpha", "alpha", "setAnimatedTransformation", "setColorFilter", "colorFilter", "Landroid/graphics/ColorFilter;", "setRepeatCount", "start", "stop", "unregisterAnimationCallback", "updateBounds", "updateFrameTime", "Companion", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class MovieDrawable extends Drawable implements Animatable2Compat {
    public static final int REPEAT_INFINITE = -1;
    private AnimatedTransformation animatedTransformation;
    private Picture animatedTransformationPicture;
    private final List<Animatable2Compat.AnimationCallback> callbacks;
    private final Bitmap.Config config;
    private final Rect currentBounds;
    private long frameTimeMillis;
    private float hardwareDx;
    private float hardwareDy;
    private float hardwareScale;
    private boolean isRunning;
    private boolean isSoftwareScalingEnabled;
    private int loopIteration;
    private final Movie movie;
    private final Paint paint;
    private PixelOpacity pixelOpacity;
    private int repeatCount;
    private final Scale scale;
    private Bitmap softwareBitmap;
    private Canvas softwareCanvas;
    private float softwareScale;
    private long startTimeMillis;
    private final Rect tempCanvasBounds;

    public MovieDrawable(Movie movie) {
        this(movie, null, null, 6, null);
    }

    public MovieDrawable(Movie movie, Bitmap.Config config) {
        this(movie, config, null, 4, null);
    }

    public MovieDrawable(Movie movie, Bitmap.Config config, Scale scale, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(movie, (i & 2) != 0 ? Bitmap.Config.ARGB_8888 : config, (i & 4) != 0 ? Scale.FIT : scale);
    }

    public final Bitmap.Config getConfig() {
        return this.config;
    }

    public final Scale getScale() {
        return this.scale;
    }

    public MovieDrawable(Movie movie, Bitmap.Config config, Scale scale) {
        this.movie = movie;
        this.config = config;
        this.scale = scale;
        this.paint = new Paint(3);
        this.callbacks = new ArrayList();
        this.currentBounds = new Rect();
        this.tempCanvasBounds = new Rect();
        this.softwareScale = 1.0f;
        this.hardwareScale = 1.0f;
        this.repeatCount = -1;
        this.pixelOpacity = PixelOpacity.UNCHANGED;
        if (GifUtils.isHardware(config)) {
            throw new IllegalArgumentException("Bitmap config must not be hardware.".toString());
        }
    }

    @Override
    public void draw(Canvas canvas) throws NoWhenBranchMatchedException {
        boolean zUpdateFrameTime = updateFrameTime();
        if (this.isSoftwareScalingEnabled) {
            updateBounds(getBounds(canvas));
            int iSave = canvas.save();
            try {
                float f = 1 / this.softwareScale;
                canvas.scale(f, f);
                drawFrame(canvas);
                canvas.restoreToCount(iSave);
            } catch (Throwable th) {
                canvas.restoreToCount(iSave);
                throw th;
            }
        } else {
            updateBounds(getBounds());
            drawFrame(canvas);
        }
        if (this.isRunning && zUpdateFrameTime) {
            invalidateSelf();
        } else {
            stop();
        }
    }

    private final boolean updateFrameTime() {
        boolean z;
        int iDuration = this.movie.duration();
        int i = 0;
        if (iDuration == 0) {
            z = 0;
        } else {
            if (this.isRunning) {
                this.frameTimeMillis = SystemClock.uptimeMillis();
            }
            int i2 = (int) (this.frameTimeMillis - this.startTimeMillis);
            int i3 = i2 / iDuration;
            this.loopIteration = i3;
            int i4 = this.repeatCount;
            i = (i4 == -1 || i3 <= i4) ? 1 : 0;
            if (i != 0) {
                iDuration = i2 - (i3 * iDuration);
            }
            int i5 = i;
            i = iDuration;
            z = i5;
        }
        this.movie.setTime(i);
        return z;
    }

    private final void drawFrame(Canvas canvas) {
        Canvas canvas2 = this.softwareCanvas;
        Bitmap bitmap = this.softwareBitmap;
        if (canvas2 == null || bitmap == null) {
            return;
        }
        canvas2.drawColor(0, PorterDuff.Mode.CLEAR);
        int iSave = canvas2.save();
        try {
            float f = this.softwareScale;
            canvas2.scale(f, f);
            this.movie.draw(canvas2, 0.0f, 0.0f, this.paint);
            Picture picture = this.animatedTransformationPicture;
            if (picture != null) {
                picture.draw(canvas2);
            }
            canvas2.restoreToCount(iSave);
            int iSave2 = canvas.save();
            try {
                canvas.translate(this.hardwareDx, this.hardwareDy);
                float f2 = this.hardwareScale;
                canvas.scale(f2, f2);
                canvas.drawBitmap(bitmap, 0.0f, 0.0f, this.paint);
            } finally {
                canvas.restoreToCount(iSave2);
            }
        } catch (Throwable th) {
            canvas2.restoreToCount(iSave);
            throw th;
        }
    }

    public final void setRepeatCount(int repeatCount) {
        if (repeatCount < -1) {
            throw new IllegalArgumentException(("Invalid repeatCount: " + repeatCount).toString());
        }
        this.repeatCount = repeatCount;
    }

    public final int getRepeatCount() {
        return this.repeatCount;
    }

    public final void setAnimatedTransformation(AnimatedTransformation animatedTransformation) {
        this.animatedTransformation = animatedTransformation;
        if (animatedTransformation != null && this.movie.width() > 0 && this.movie.height() > 0) {
            Picture picture = new Picture();
            this.pixelOpacity = animatedTransformation.transform(picture.beginRecording(this.movie.width(), this.movie.height()));
            picture.endRecording();
            this.animatedTransformationPicture = picture;
            this.isSoftwareScalingEnabled = true;
        } else {
            this.animatedTransformationPicture = null;
            this.pixelOpacity = PixelOpacity.UNCHANGED;
            this.isSoftwareScalingEnabled = false;
        }
        invalidateSelf();
    }

    public final AnimatedTransformation getAnimatedTransformation() {
        return this.animatedTransformation;
    }

    @Override
    public void setAlpha(int alpha) {
        if (alpha < 0 || alpha >= 256) {
            throw new IllegalArgumentException(("Invalid alpha: " + alpha).toString());
        }
        this.paint.setAlpha(alpha);
    }

    @Override
    @Deprecated(message = "Deprecated in Java")
    public int getOpacity() {
        return (this.paint.getAlpha() == 255 && (this.pixelOpacity == PixelOpacity.OPAQUE || (this.pixelOpacity == PixelOpacity.UNCHANGED && this.movie.isOpaque()))) ? -1 : -3;
    }

    @Override
    public void setColorFilter(ColorFilter colorFilter) {
        this.paint.setColorFilter(colorFilter);
    }

    private final void updateBounds(Rect bounds) throws NoWhenBranchMatchedException {
        if (Intrinsics.areEqual(this.currentBounds, bounds)) {
            return;
        }
        this.currentBounds.set(bounds);
        int iWidth = bounds.width();
        int iHeight = bounds.height();
        int iWidth2 = this.movie.width();
        int iHeight2 = this.movie.height();
        if (iWidth2 <= 0 || iHeight2 <= 0) {
            return;
        }
        double dComputeSizeMultiplier = DecodeUtils.computeSizeMultiplier(iWidth2, iHeight2, iWidth, iHeight, this.scale);
        if (!this.isSoftwareScalingEnabled) {
            dComputeSizeMultiplier = RangesKt.coerceAtMost(dComputeSizeMultiplier, 1.0d);
        }
        float f = (float) dComputeSizeMultiplier;
        this.softwareScale = f;
        int i = (int) (iWidth2 * f);
        int i2 = (int) (f * iHeight2);
        Bitmap bitmapCreateBitmap = Bitmap.createBitmap(i, i2, this.config);
        Bitmap bitmap = this.softwareBitmap;
        if (bitmap != null) {
            bitmap.recycle();
        }
        this.softwareBitmap = bitmapCreateBitmap;
        this.softwareCanvas = new Canvas(bitmapCreateBitmap);
        if (this.isSoftwareScalingEnabled) {
            this.hardwareScale = 1.0f;
            this.hardwareDx = 0.0f;
            this.hardwareDy = 0.0f;
        } else {
            this.hardwareScale = (float) DecodeUtils.computeSizeMultiplier(i, i2, iWidth, iHeight, this.scale);
            float f2 = bounds.left;
            float f3 = iWidth - (this.hardwareScale * i);
            float f4 = 2;
            this.hardwareDx = f2 + (f3 / f4);
            this.hardwareDy = bounds.top + ((iHeight - (this.hardwareScale * i2)) / f4);
        }
    }

    @Override
    public int getIntrinsicWidth() {
        return this.movie.width();
    }

    @Override
    public int getIntrinsicHeight() {
        return this.movie.height();
    }

    @Override
    public boolean isRunning() {
        return this.isRunning;
    }

    @Override
    public void start() {
        if (this.isRunning) {
            return;
        }
        this.isRunning = true;
        this.loopIteration = 0;
        this.startTimeMillis = SystemClock.uptimeMillis();
        List<Animatable2Compat.AnimationCallback> list = this.callbacks;
        int size = list.size();
        for (int i = 0; i < size; i++) {
            list.get(i).onAnimationStart(this);
        }
        invalidateSelf();
    }

    @Override
    public void stop() {
        if (this.isRunning) {
            this.isRunning = false;
            List<Animatable2Compat.AnimationCallback> list = this.callbacks;
            int size = list.size();
            for (int i = 0; i < size; i++) {
                list.get(i).onAnimationEnd(this);
            }
        }
    }

    @Override
    public void registerAnimationCallback(Animatable2Compat.AnimationCallback callback) {
        this.callbacks.add(callback);
    }

    @Override
    public boolean unregisterAnimationCallback(Animatable2Compat.AnimationCallback callback) {
        return this.callbacks.remove(callback);
    }

    @Override
    public void clearAnimationCallbacks() {
        this.callbacks.clear();
    }

    private final Rect getBounds(Canvas canvas) {
        Rect rect = this.tempCanvasBounds;
        rect.set(0, 0, canvas.getWidth(), canvas.getHeight());
        return rect;
    }
}
