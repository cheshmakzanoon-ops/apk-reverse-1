package androidx.compose.p000ui.text.font;

import android.content.Context;
import android.graphics.Typeface;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0018\u0010\n\u001a\u0004\u0018\u00010\u000b2\u0006\u0010\f\u001a\u00020\rH\u0096@¢\u0006\u0002\u0010\u000eJ\u0012\u0010\u000f\u001a\u0004\u0018\u00010\u000b2\u0006\u0010\f\u001a\u00020\rH\u0016R\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0016\u0010\u0002\u001a\n \t*\u0004\u0018\u00010\u00030\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, d2 = {"Landroidx/compose/ui/text/font/AndroidFontLoader;", "Landroidx/compose/ui/text/font/PlatformFontLoader;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "cacheKey", "", "getCacheKey", "()Ljava/lang/Object;", "kotlin.jvm.PlatformType", "awaitLoad", "Landroid/graphics/Typeface;", "font", "Landroidx/compose/ui/text/font/Font;", "(Landroidx/compose/ui/text/font/Font;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "loadBlocking", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidFontLoader implements PlatformFontLoader {
    public static final int $stable = 8;
    private final Object cacheKey;
    private final Context context;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.compose.ui.text.font.AndroidFontLoader", f = "AndroidFontLoader.android.kt", i = {1, 1}, l = {57, 58}, m = "awaitLoad", n = {"this", "font"}, s = {"L$0", "L$1"})
    static final class C00091 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C00091(Continuation<? super C00091> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return AndroidFontLoader.this.awaitLoad(null, (Continuation) this);
        }
    }

    public AndroidFontLoader(Context context) {
        this.context = context.getApplicationContext();
    }

    @Override
    public Typeface loadBlocking(Font font) {
        Object obj;
        Typeface typefaceLoad;
        if (font instanceof AndroidFont) {
            AndroidFont androidFont = (AndroidFont) font;
            return androidFont.getTypefaceLoader().loadBlocking(this.context, androidFont);
        }
        if (!(font instanceof ResourceFont)) {
            return null;
        }
        int loadingStrategy = font.getLoadingStrategy();
        if (FontLoadingStrategy.m1386equalsimpl0(loadingStrategy, FontLoadingStrategy.INSTANCE.m1391getBlockingPKNRLFQ())) {
            typefaceLoad = AndroidFontLoader_androidKt.load((ResourceFont) font, this.context);
        } else if (FontLoadingStrategy.m1386equalsimpl0(loadingStrategy, FontLoadingStrategy.INSTANCE.m1392getOptionalLocalPKNRLFQ())) {
            try {
                Result.Companion companion = Result.Companion;
                AndroidFontLoader androidFontLoader = this;
                obj = Result.constructor-impl(AndroidFontLoader_androidKt.load((ResourceFont) font, this.context));
            } catch (Throwable th) {
                Result.Companion companion2 = Result.Companion;
                obj = Result.constructor-impl(ResultKt.createFailure(th));
            }
            typefaceLoad = (Typeface) (Result.isFailure-impl(obj) ? null : obj);
        } else {
            if (FontLoadingStrategy.m1386equalsimpl0(loadingStrategy, FontLoadingStrategy.INSTANCE.m1390getAsyncPKNRLFQ())) {
                throw new UnsupportedOperationException("Unsupported Async font load path");
            }
            throw new IllegalArgumentException("Unknown loading type " + ((Object) FontLoadingStrategy.m1388toStringimpl(font.getLoadingStrategy())));
        }
        return PlatformTypefaces_androidKt.setFontVariationSettings(typefaceLoad, ((ResourceFont) font).getVariationSettings(), this.context);
    }

    @Override
    public Object awaitLoad(Font font, Continuation<? super Typeface> continuation) {
        C00091 c00091;
        AndroidFontLoader androidFontLoader;
        if (continuation instanceof C00091) {
            c00091 = (C00091) continuation;
            if ((c00091.label & Integer.MIN_VALUE) != 0) {
                c00091.label -= Integer.MIN_VALUE;
            } else {
                c00091 = new C00091(continuation);
            }
        } else {
            c00091 = new C00091(continuation);
        }
        Object objLoadAsync = c00091.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c00091.label;
        if (i != 0) {
            if (i == 1) {
                ResultKt.throwOnFailure(objLoadAsync);
            }
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            font = (Font) c00091.L$1;
            androidFontLoader = (AndroidFontLoader) c00091.L$0;
            ResultKt.throwOnFailure(objLoadAsync);
            return PlatformTypefaces_androidKt.setFontVariationSettings((Typeface) objLoadAsync, ((ResourceFont) font).getVariationSettings(), androidFontLoader.context);
        }
        ResultKt.throwOnFailure(objLoadAsync);
        if (font instanceof AndroidFont) {
            AndroidFont androidFont = (AndroidFont) font;
            AndroidFont.TypefaceLoader typefaceLoader = androidFont.getTypefaceLoader();
            Context context = this.context;
            c00091.label = 1;
            objLoadAsync = typefaceLoader.awaitLoad(context, androidFont, c00091);
            return objLoadAsync == coroutine_suspended ? coroutine_suspended : objLoadAsync;
        }
        if (font instanceof ResourceFont) {
            Context context2 = this.context;
            c00091.L$0 = this;
            c00091.L$1 = font;
            c00091.label = 2;
            objLoadAsync = AndroidFontLoader_androidKt.loadAsync((ResourceFont) font, context2, c00091);
            if (objLoadAsync == coroutine_suspended) {
                return coroutine_suspended;
            }
            androidFontLoader = this;
            return PlatformTypefaces_androidKt.setFontVariationSettings((Typeface) objLoadAsync, ((ResourceFont) font).getVariationSettings(), androidFontLoader.context);
        }
        throw new IllegalArgumentException("Unknown font type: " + font);
    }

    @Override
    public Object getCacheKey() {
        return this.cacheKey;
    }
}
