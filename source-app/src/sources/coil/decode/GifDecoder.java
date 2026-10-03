package coil.decode;

import android.graphics.Bitmap;
import android.graphics.Movie;
import androidx.constraintlayout.widget.ConstraintLayout;
import coil.ImageLoader;
import coil.drawable.MovieDrawable;
import coil.fetch.SourceResult;
import coil.request.Gifs;
import coil.request.Options;
import coil.util.GifUtils;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.share.internal.ShareConstants;
import java.io.Closeable;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.io.CloseableKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlinx.coroutines.InterruptibleKt;
import okio.BufferedSource;
import okio.Okio;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\u0018\u0000 \f2\u00020\u0001:\u0002\f\rB!\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000e\u0010\t\u001a\u00020\nH\u0096@¢\u0006\u0002\u0010\u000bR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000e"}, d2 = {"Lcoil/decode/GifDecoder;", "Lcoil/decode/Decoder;", ShareConstants.FEED_SOURCE_PARAM, "Lcoil/decode/ImageSource;", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "enforceMinimumFrameDelay", "", "(Lcoil/decode/ImageSource;Lcoil/request/Options;Z)V", "decode", "Lcoil/decode/DecodeResult;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "Factory", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class GifDecoder implements Decoder {
    public static final String ANIMATED_TRANSFORMATION_KEY = "coil#animated_transformation";
    public static final String ANIMATION_END_CALLBACK_KEY = "coil#animation_end_callback";
    public static final String ANIMATION_START_CALLBACK_KEY = "coil#animation_start_callback";
    public static final String REPEAT_COUNT_KEY = "coil#repeat_count";
    private final boolean enforceMinimumFrameDelay;
    private final Options options;
    private final ImageSource source;

    public GifDecoder(ImageSource imageSource, Options options) {
        this(imageSource, options, false, 4, null);
    }

    public GifDecoder(ImageSource imageSource, Options options, boolean z) {
        this.source = imageSource;
        this.options = options;
        this.enforceMinimumFrameDelay = z;
    }

    public GifDecoder(ImageSource imageSource, Options options, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(imageSource, options, (i & 4) != 0 ? true : z);
    }

    @Override
    public Object decode(Continuation<? super DecodeResult> continuation) {
        return InterruptibleKt.runInterruptible$default((CoroutineContext) null, new Function0<DecodeResult>() {
            {
                super(0);
            }

            public final DecodeResult m2321invoke() {
                BufferedSource bufferedSourceSource;
                Bitmap.Config config;
                if (!GifDecoder.this.enforceMinimumFrameDelay) {
                    bufferedSourceSource = GifDecoder.this.source.source();
                } else {
                    bufferedSourceSource = Okio.buffer(new FrameDelayRewritingSource(GifDecoder.this.source.source()));
                }
                BufferedSource bufferedSource = (Closeable) bufferedSourceSource;
                try {
                    Movie movieDecodeStream = Movie.decodeStream(bufferedSource.inputStream());
                    CloseableKt.closeFinally(bufferedSource, (Throwable) null);
                    if (movieDecodeStream == null || movieDecodeStream.width() <= 0 || movieDecodeStream.height() <= 0) {
                        throw new IllegalStateException("Failed to decode GIF.".toString());
                    }
                    if (movieDecodeStream.isOpaque() && GifDecoder.this.options.getAllowRgb565()) {
                        config = Bitmap.Config.RGB_565;
                    } else {
                        config = GifUtils.isHardware(GifDecoder.this.options.getConfig()) ? Bitmap.Config.ARGB_8888 : GifDecoder.this.options.getConfig();
                    }
                    MovieDrawable movieDrawable = new MovieDrawable(movieDecodeStream, config, GifDecoder.this.options.getScale());
                    Integer numRepeatCount = Gifs.repeatCount(GifDecoder.this.options.getParameters());
                    movieDrawable.setRepeatCount(numRepeatCount != null ? numRepeatCount.intValue() : -1);
                    Function0<Unit> function0AnimationStartCallback = Gifs.animationStartCallback(GifDecoder.this.options.getParameters());
                    Function0<Unit> function0AnimationEndCallback = Gifs.animationEndCallback(GifDecoder.this.options.getParameters());
                    if (function0AnimationStartCallback != null || function0AnimationEndCallback != null) {
                        movieDrawable.registerAnimationCallback(GifUtils.animatable2CompatCallbackOf(function0AnimationStartCallback, function0AnimationEndCallback));
                    }
                    movieDrawable.setAnimatedTransformation(Gifs.animatedTransformation(GifDecoder.this.options.getParameters()));
                    return new DecodeResult(movieDrawable, false);
                } catch (Throwable th) {
                    try {
                        throw th;
                    } catch (Throwable th2) {
                        CloseableKt.closeFinally(bufferedSource, th);
                        throw th2;
                    }
                }
            }
        }, continuation, 1, (Object) null);
    }

    @Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\u0018\u00002\u00020\u0001B\u0011\b\u0007\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\"\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0016J\u0013\u0010\r\u001a\u00020\u00032\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fH\u0096\u0002J\b\u0010\u0010\u001a\u00020\u0011H\u0016R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"Lcoil/decode/GifDecoder$Factory;", "Lcoil/decode/Decoder$Factory;", "enforceMinimumFrameDelay", "", "(Z)V", "create", "Lcoil/decode/Decoder;", "result", "Lcoil/fetch/SourceResult;", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "imageLoader", "Lcoil/ImageLoader;", "equals", "other", "", "hashCode", "", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Factory implements Decoder.Factory {
        private final boolean enforceMinimumFrameDelay;

        public Factory() {
            this(false, 1, null);
        }

        public Factory(boolean z) {
            this.enforceMinimumFrameDelay = z;
        }

        public Factory(boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? true : z);
        }

        @Override
        public Decoder create(SourceResult result, Options options, ImageLoader imageLoader) {
            if (GifDecodeUtils.isGif(DecodeUtils.INSTANCE, result.getSource().source())) {
                return new GifDecoder(result.getSource(), options, this.enforceMinimumFrameDelay);
            }
            return null;
        }

        public boolean equals(Object other) {
            return other instanceof Factory;
        }

        public int hashCode() {
            return getClass().hashCode();
        }
    }
}
