package coil.decode;

import android.graphics.ImageDecoder;
import android.graphics.drawable.AnimatedImageDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.util.Size;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.graphics.ColorKt$$ExternalSyntheticApiModelOutline0;
import cn.thinkingdata.android.j$$ExternalSyntheticApiModelOutline0;
import coil.ImageLoader;
import coil.drawable.ScaleDrawable;
import coil.fetch.SourceResult;
import coil.request.Gifs;
import coil.request.Options;
import coil.size.Sizes;
import coil.transform.AnimatedTransformation;
import coil.util.GifUtils;
import com.facebook.gamingservices.cloudgaming.internal.SDKConstants;
import com.facebook.share.internal.ShareConstants;
import java.nio.ByteBuffer;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlin.math.MathKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.InterruptibleKt;
import okio.BufferedSource;
import okio.Okio;
import okio.Path;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001:\u0001\u0016B!\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u000e\u0010\t\u001a\u00020\nH\u0096@¢\u0006\u0002\u0010\u000bJ\u0016\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\rH\u0082@¢\u0006\u0002\u0010\u000fJ\u0010\u0010\u0010\u001a\u00020\u00032\u0006\u0010\u0002\u001a\u00020\u0003H\u0002J\f\u0010\u0011\u001a\u00020\u0012*\u00020\u0013H\u0002J\f\u0010\u0014\u001a\u00020\u0015*\u00020\u0003H\u0002R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0017"}, d2 = {"Lcoil/decode/ImageDecoderDecoder;", "Lcoil/decode/Decoder;", ShareConstants.FEED_SOURCE_PARAM, "Lcoil/decode/ImageSource;", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "enforceMinimumFrameDelay", "", "(Lcoil/decode/ImageSource;Lcoil/request/Options;Z)V", "decode", "Lcoil/decode/DecodeResult;", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "wrapDrawable", "Landroid/graphics/drawable/Drawable;", "baseDrawable", "(Landroid/graphics/drawable/Drawable;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "wrapImageSource", "configureImageDecoderProperties", "", "Landroid/graphics/ImageDecoder;", "toImageDecoderSource", "Landroid/graphics/ImageDecoder$Source;", "Factory", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ImageDecoderDecoder implements Decoder {
    private final boolean enforceMinimumFrameDelay;
    private final Options options;
    private final ImageSource source;

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.decode.ImageDecoderDecoder", f = "ImageDecoderDecoder.kt", i = {0, 0, 1}, l = {50, 90}, m = "decode", n = {"this", "isSampled", "isSampled"}, s = {"L$0", "L$1", "L$0"})
    static final class C07931 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C07931(Continuation<? super C07931> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ImageDecoderDecoder.this.decode((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.decode.ImageDecoderDecoder", f = "ImageDecoderDecoder.kt", i = {0, 0}, l = {158}, m = "wrapDrawable", n = {"this", "baseDrawable"}, s = {"L$0", "L$1"})
    static final class C07951 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C07951(Continuation<? super C07951> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ImageDecoderDecoder.this.wrapDrawable(null, (Continuation) this);
        }
    }

    public ImageDecoderDecoder(ImageSource imageSource, Options options) {
        this(imageSource, options, false, 4, null);
    }

    public ImageDecoderDecoder(ImageSource imageSource, Options options, boolean z) {
        this.source = imageSource;
        this.options = options;
        this.enforceMinimumFrameDelay = z;
    }

    public ImageDecoderDecoder(ImageSource imageSource, Options options, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(imageSource, options, (i & 4) != 0 ? true : z);
    }

    @Override
    public Object decode(Continuation<? super DecodeResult> continuation) {
        C07931 c07931;
        ImageDecoderDecoder imageDecoderDecoder;
        Ref.BooleanRef booleanRef;
        Ref.BooleanRef booleanRef2;
        if (continuation instanceof C07931) {
            c07931 = (C07931) continuation;
            if ((c07931.label & Integer.MIN_VALUE) != 0) {
                c07931.label -= Integer.MIN_VALUE;
            } else {
                c07931 = new C07931(continuation);
            }
        } else {
            c07931 = new C07931(continuation);
        }
        Object objWrapDrawable = c07931.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c07931.label;
        if (i != 0) {
            if (i == 1) {
                booleanRef = (Ref.BooleanRef) c07931.L$1;
                imageDecoderDecoder = (ImageDecoderDecoder) c07931.L$0;
                ResultKt.throwOnFailure(objWrapDrawable);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                booleanRef2 = (Ref.BooleanRef) c07931.L$0;
                ResultKt.throwOnFailure(objWrapDrawable);
            }
            return new DecodeResult((Drawable) objWrapDrawable, booleanRef2.element);
        }
        ResultKt.throwOnFailure(objWrapDrawable);
        final Ref.BooleanRef booleanRef3 = new Ref.BooleanRef();
        Function0<Drawable> function0 = new Function0<Drawable>() {
            {
                super(0);
            }

            public final Drawable m2322invoke() {
                final Ref.ObjectRef objectRef = new Ref.ObjectRef();
                ImageDecoderDecoder imageDecoderDecoder2 = this.this$0;
                ImageSource imageSourceWrapImageSource = imageDecoderDecoder2.wrapImageSource(imageDecoderDecoder2.source);
                try {
                    ImageDecoder.Source imageDecoderSource = this.this$0.toImageDecoderSource(imageSourceWrapImageSource);
                    final ImageDecoderDecoder imageDecoderDecoder3 = this.this$0;
                    final Ref.BooleanRef booleanRef4 = booleanRef3;
                    return ImageDecoder.decodeDrawable(imageDecoderSource, ColorKt$$ExternalSyntheticApiModelOutline0.m118m((Object) new ImageDecoder.OnHeaderDecodedListener() {
                        @Override
                        public final void onHeaderDecoded(ImageDecoder imageDecoder, ImageDecoder.ImageInfo imageInfo, ImageDecoder.Source source) throws NoWhenBranchMatchedException {
                            objectRef.element = imageDecoder;
                            Size size = imageInfo.getSize();
                            int width = size.getWidth();
                            int height = size.getHeight();
                            coil.size.Size size2 = imageDecoderDecoder3.options.getSize();
                            int px = Sizes.isOriginal(size2) ? width : GifUtils.toPx(size2.getWidth(), imageDecoderDecoder3.options.getScale());
                            coil.size.Size size3 = imageDecoderDecoder3.options.getSize();
                            int px2 = Sizes.isOriginal(size3) ? height : GifUtils.toPx(size3.getHeight(), imageDecoderDecoder3.options.getScale());
                            if (width > 0 && height > 0 && (width != px || height != px2)) {
                                double dComputeSizeMultiplier = DecodeUtils.computeSizeMultiplier(width, height, px, px2, imageDecoderDecoder3.options.getScale());
                                booleanRef4.element = dComputeSizeMultiplier < 1.0d;
                                if (booleanRef4.element || !imageDecoderDecoder3.options.getAllowInexactSize()) {
                                    imageDecoder.setTargetSize(MathKt.roundToInt(((double) width) * dComputeSizeMultiplier), MathKt.roundToInt(dComputeSizeMultiplier * ((double) height)));
                                }
                            }
                            imageDecoderDecoder3.configureImageDecoderProperties(imageDecoder);
                        }
                    }));
                } finally {
                    ImageDecoder imageDecoderM575m = j$$ExternalSyntheticApiModelOutline0.m575m(objectRef.element);
                    if (imageDecoderM575m != null) {
                        imageDecoderM575m.close();
                    }
                    imageSourceWrapImageSource.close();
                }
            }
        };
        c07931.L$0 = this;
        c07931.L$1 = booleanRef3;
        c07931.label = 1;
        Object objRunInterruptible$default = InterruptibleKt.runInterruptible$default((CoroutineContext) null, function0, c07931, 1, (Object) null);
        if (objRunInterruptible$default == coroutine_suspended) {
            return coroutine_suspended;
        }
        imageDecoderDecoder = this;
        booleanRef = booleanRef3;
        objWrapDrawable = objRunInterruptible$default;
        c07931.L$0 = booleanRef;
        c07931.L$1 = null;
        c07931.label = 2;
        objWrapDrawable = imageDecoderDecoder.wrapDrawable((Drawable) objWrapDrawable, c07931);
        if (objWrapDrawable == coroutine_suspended) {
            return coroutine_suspended;
        }
        booleanRef2 = booleanRef;
        return new DecodeResult((Drawable) objWrapDrawable, booleanRef2.element);
    }

    public final ImageSource wrapImageSource(ImageSource source) {
        return (this.enforceMinimumFrameDelay && GifDecodeUtils.isGif(DecodeUtils.INSTANCE, source.source())) ? ImageSources.create(Okio.buffer(new FrameDelayRewritingSource(source.source())), this.options.getContext()) : source;
    }

    public final ImageDecoder.Source toImageDecoderSource(ImageSource imageSource) {
        Path pathFileOrNull = imageSource.fileOrNull();
        if (pathFileOrNull != null) {
            return ImageDecoder.createSource(pathFileOrNull.toFile());
        }
        ImageSource.Metadata metadata = imageSource.getMetadata();
        if (metadata instanceof AssetMetadata) {
            return ImageDecoder.createSource(this.options.getContext().getAssets(), ((AssetMetadata) metadata).getFilePath());
        }
        if (metadata instanceof ContentMetadata) {
            return ImageDecoder.createSource(this.options.getContext().getContentResolver(), ((ContentMetadata) metadata).getUri());
        }
        if (metadata instanceof ResourceMetadata) {
            ResourceMetadata resourceMetadata = (ResourceMetadata) metadata;
            if (Intrinsics.areEqual(resourceMetadata.getPackageName(), this.options.getContext().getPackageName())) {
                return ImageDecoder.createSource(this.options.getContext().getResources(), resourceMetadata.getResId());
            }
        }
        if (Build.VERSION.SDK_INT >= 31) {
            return ImageDecoder.createSource(imageSource.source().readByteArray());
        }
        return Build.VERSION.SDK_INT == 30 ? ImageDecoder.createSource(ByteBuffer.wrap(imageSource.source().readByteArray())) : ImageDecoder.createSource(imageSource.file().toFile());
    }

    public final void configureImageDecoderProperties(ImageDecoder imageDecoder) {
        imageDecoder.setAllocator(GifUtils.isHardware(this.options.getConfig()) ? 3 : 1);
        imageDecoder.setMemorySizePolicy(!this.options.getAllowRgb565() ? 1 : 0);
        if (this.options.getColorSpace() != null) {
            imageDecoder.setTargetColorSpace(this.options.getColorSpace());
        }
        imageDecoder.setUnpremultipliedRequired(!this.options.getPremultipliedAlpha());
        AnimatedTransformation animatedTransformation = Gifs.animatedTransformation(this.options.getParameters());
        imageDecoder.setPostProcessor(animatedTransformation != null ? GifUtils.asPostProcessor(animatedTransformation) : null);
    }

    public final Object wrapDrawable(Drawable drawable, Continuation<? super Drawable> continuation) {
        C07951 c07951;
        ImageDecoderDecoder imageDecoderDecoder;
        if (continuation instanceof C07951) {
            c07951 = (C07951) continuation;
            if ((c07951.label & Integer.MIN_VALUE) != 0) {
                c07951.label -= Integer.MIN_VALUE;
            } else {
                c07951 = new C07951(continuation);
            }
        } else {
            c07951 = new C07951(continuation);
        }
        Object obj = c07951.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c07951.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!j$$ExternalSyntheticApiModelOutline0.m646m((Object) drawable)) {
                return drawable;
            }
            AnimatedImageDrawable animatedImageDrawableM576m = j$$ExternalSyntheticApiModelOutline0.m576m((Object) drawable);
            Integer numRepeatCount = Gifs.repeatCount(this.options.getParameters());
            animatedImageDrawableM576m.setRepeatCount(numRepeatCount != null ? numRepeatCount.intValue() : -1);
            Function0<Unit> function0AnimationStartCallback = Gifs.animationStartCallback(this.options.getParameters());
            Function0<Unit> function0AnimationEndCallback = Gifs.animationEndCallback(this.options.getParameters());
            if (function0AnimationStartCallback != null || function0AnimationEndCallback != null) {
                CoroutineContext immediate = Dispatchers.getMain().getImmediate();
                C07962 c07962 = new C07962(drawable, function0AnimationStartCallback, function0AnimationEndCallback, null);
                c07951.L$0 = this;
                c07951.L$1 = drawable;
                c07951.label = 1;
                if (BuildersKt.withContext(immediate, c07962, c07951) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            imageDecoderDecoder = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            drawable = (Drawable) c07951.L$1;
            imageDecoderDecoder = (ImageDecoderDecoder) c07951.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return new ScaleDrawable(drawable, imageDecoderDecoder.options.getScale());
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "coil.decode.ImageDecoderDecoder$wrapDrawable$2", f = "ImageDecoderDecoder.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C07962 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Drawable $baseDrawable;
        final Function0<Unit> $onEnd;
        final Function0<Unit> $onStart;
        int label;

        C07962(Drawable drawable, Function0<Unit> function0, Function0<Unit> function1, Continuation<? super C07962> continuation) {
            super(2, continuation);
            this.$baseDrawable = drawable;
            this.$onStart = function0;
            this.$onEnd = function1;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C07962(this.$baseDrawable, this.$onStart, this.$onEnd, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            j$$ExternalSyntheticApiModelOutline0.m576m((Object) this.$baseDrawable).registerAnimationCallback(GifUtils.animatable2CallbackOf(this.$onStart, this.$onEnd));
            return Unit.INSTANCE;
        }
    }

    @Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u0018\u00002\u00020\u0001B\u0011\b\u0007\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\"\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0016J\u0013\u0010\r\u001a\u00020\u00032\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fH\u0096\u0002J\b\u0010\u0010\u001a\u00020\u0011H\u0016J\u0010\u0010\u0012\u001a\u00020\u00032\u0006\u0010\u0013\u001a\u00020\u0014H\u0002R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0015"}, d2 = {"Lcoil/decode/ImageDecoderDecoder$Factory;", "Lcoil/decode/Decoder$Factory;", "enforceMinimumFrameDelay", "", "(Z)V", "create", "Lcoil/decode/Decoder;", "result", "Lcoil/fetch/SourceResult;", SDKConstants.PARAM_GAME_REQUESTS_OPTIONS, "Lcoil/request/Options;", "imageLoader", "Lcoil/ImageLoader;", "equals", "other", "", "hashCode", "", "isApplicable", ShareConstants.FEED_SOURCE_PARAM, "Lokio/BufferedSource;", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
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
            if (isApplicable(result.getSource().source())) {
                return new ImageDecoderDecoder(result.getSource(), options, this.enforceMinimumFrameDelay);
            }
            return null;
        }

        private final boolean isApplicable(BufferedSource source) {
            return GifDecodeUtils.isGif(DecodeUtils.INSTANCE, source) || GifDecodeUtils.isAnimatedWebP(DecodeUtils.INSTANCE, source) || (Build.VERSION.SDK_INT >= 30 && GifDecodeUtils.isAnimatedHeif(DecodeUtils.INSTANCE, source));
        }

        public boolean equals(Object other) {
            return other instanceof Factory;
        }

        public int hashCode() {
            return getClass().hashCode();
        }
    }
}
