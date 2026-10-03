package net.aihelp.core.p004ui.glide;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.view.animation.Animation;
import android.widget.ImageView;
import java.io.File;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.DiskCacheStrategy;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoWrapper;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.BitmapTransformation;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.GifBitmapWrapper;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.GifBitmapWrapperTransformation;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;
import net.aihelp.core.p004ui.glide.manager.Lifecycle;
import net.aihelp.core.p004ui.glide.manager.RequestTracker;
import net.aihelp.core.p004ui.glide.provider.LoadProvider;
import net.aihelp.core.p004ui.glide.request.RequestListener;
import net.aihelp.core.p004ui.glide.request.animation.DrawableCrossFadeFactory;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimationFactory;
import net.aihelp.core.p004ui.glide.request.animation.ViewPropertyAnimation;
import net.aihelp.core.p004ui.glide.request.target.Target;

public class DrawableRequestBuilder<ModelType> extends GenericRequestBuilder<ModelType, ImageVideoWrapper, GifBitmapWrapper, GlideDrawable> implements BitmapOptions, DrawableOptions {
    DrawableRequestBuilder(Context context, Class<ModelType> cls, LoadProvider<ModelType, ImageVideoWrapper, GifBitmapWrapper, GlideDrawable> loadProvider, Glide glide, RequestTracker requestTracker, Lifecycle lifecycle) {
        super(context, cls, loadProvider, GlideDrawable.class, glide, requestTracker, lifecycle);
        crossFade();
    }

    public DrawableRequestBuilder<ModelType> thumbnail(DrawableRequestBuilder<?> drawableRequestBuilder) {
        super.thumbnail((GenericRequestBuilder) drawableRequestBuilder);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> thumbnail(GenericRequestBuilder<?, ?, ?, GlideDrawable> genericRequestBuilder) {
        super.thumbnail((GenericRequestBuilder) genericRequestBuilder);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> thumbnail(float f) {
        super.thumbnail(f);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> sizeMultiplier(float f) {
        super.sizeMultiplier(f);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> decoder(ResourceDecoder<ImageVideoWrapper, GifBitmapWrapper> resourceDecoder) {
        super.decoder((ResourceDecoder) resourceDecoder);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> cacheDecoder(ResourceDecoder<File, GifBitmapWrapper> resourceDecoder) {
        super.cacheDecoder((ResourceDecoder) resourceDecoder);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> encoder(ResourceEncoder<GifBitmapWrapper> resourceEncoder) {
        super.encoder((ResourceEncoder) resourceEncoder);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> priority(Priority priority) {
        super.priority(priority);
        return this;
    }

    public DrawableRequestBuilder<ModelType> transform(BitmapTransformation... bitmapTransformationArr) {
        return bitmapTransform(bitmapTransformationArr);
    }

    @Override
    public DrawableRequestBuilder<ModelType> centerCrop() {
        return transform(this.glide.getDrawableCenterCrop());
    }

    @Override
    public DrawableRequestBuilder<ModelType> fitCenter() {
        return transform(this.glide.getDrawableFitCenter());
    }

    public DrawableRequestBuilder<ModelType> bitmapTransform(Transformation<Bitmap>... transformationArr) {
        GifBitmapWrapperTransformation[] gifBitmapWrapperTransformationArr = new GifBitmapWrapperTransformation[transformationArr.length];
        for (int i = 0; i < transformationArr.length; i++) {
            gifBitmapWrapperTransformationArr[i] = new GifBitmapWrapperTransformation(this.glide.getBitmapPool(), transformationArr[i]);
        }
        return transform((Transformation<GifBitmapWrapper>[]) gifBitmapWrapperTransformationArr);
    }

    @Override
    public DrawableRequestBuilder<ModelType> transform(Transformation<GifBitmapWrapper>... transformationArr) {
        super.transform((Transformation[]) transformationArr);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> transcoder(ResourceTranscoder<GifBitmapWrapper, GlideDrawable> resourceTranscoder) {
        super.transcoder((ResourceTranscoder) resourceTranscoder);
        return this;
    }

    @Override
    public final DrawableRequestBuilder<ModelType> crossFade() {
        super.animate((GlideAnimationFactory) new DrawableCrossFadeFactory());
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> crossFade(int i) {
        super.animate((GlideAnimationFactory) new DrawableCrossFadeFactory(i));
        return this;
    }

    @Override
    @Deprecated
    public DrawableRequestBuilder<ModelType> crossFade(Animation animation, int i) {
        super.animate((GlideAnimationFactory) new DrawableCrossFadeFactory(animation, i));
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> crossFade(int i, int i2) {
        super.animate((GlideAnimationFactory) new DrawableCrossFadeFactory(this.context, i, i2));
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> dontAnimate() {
        super.dontAnimate();
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> animate(ViewPropertyAnimation.Animator animator) {
        super.animate(animator);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> animate(GlideAnimationFactory<GlideDrawable> glideAnimationFactory) {
        super.animate((GlideAnimationFactory) glideAnimationFactory);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> animate(int i) {
        super.animate(i);
        return this;
    }

    @Override
    @Deprecated
    public DrawableRequestBuilder<ModelType> animate(Animation animation) {
        super.animate(animation);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> placeholder(int i) {
        super.placeholder(i);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> placeholder(Drawable drawable) {
        super.placeholder(drawable);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> fallback(Drawable drawable) {
        super.fallback(drawable);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> fallback(int i) {
        super.fallback(i);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> error(int i) {
        super.error(i);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> error(Drawable drawable) {
        super.error(drawable);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> listener(RequestListener<? super ModelType, GlideDrawable> requestListener) {
        super.listener((RequestListener) requestListener);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> diskCacheStrategy(DiskCacheStrategy diskCacheStrategy) {
        super.diskCacheStrategy(diskCacheStrategy);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> skipMemoryCache(boolean z) {
        super.skipMemoryCache(z);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> override(int i, int i2) {
        super.override(i, i2);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> sourceEncoder(Encoder<ImageVideoWrapper> encoder) {
        super.sourceEncoder((Encoder) encoder);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> dontTransform() {
        super.dontTransform();
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> signature(Key key) {
        super.signature(key);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> load(ModelType modeltype) {
        super.load((Object) modeltype);
        return this;
    }

    @Override
    public DrawableRequestBuilder<ModelType> clone() {
        return (DrawableRequestBuilder) super.clone();
    }

    @Override
    public Target<GlideDrawable> into(ImageView imageView) {
        return super.into(imageView);
    }

    @Override
    void applyFitCenter() {
        fitCenter();
    }

    @Override
    void applyCenterCrop() {
        centerCrop();
    }
}
