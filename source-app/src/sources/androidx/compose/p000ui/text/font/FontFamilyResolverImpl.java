package androidx.compose.p000ui.text.font;

import androidx.compose.runtime.State;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B5\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u0016\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016H\u0096@¢\u0006\u0002\u0010\u0017J:\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00100\u00192\b\u0010\u0015\u001a\u0004\u0018\u00010\u00162\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001fH\u0016ø\u0001\u0000¢\u0006\u0004\b \u0010!J\u0016\u0010\u0018\u001a\b\u0012\u0004\u0012\u00020\u00100\u00192\u0006\u0010\"\u001a\u00020\u000fH\u0002R\u001a\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u00100\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006#"}, d2 = {"Landroidx/compose/ui/text/font/FontFamilyResolverImpl;", "Landroidx/compose/ui/text/font/FontFamily$Resolver;", "platformFontLoader", "Landroidx/compose/ui/text/font/PlatformFontLoader;", "platformResolveInterceptor", "Landroidx/compose/ui/text/font/PlatformResolveInterceptor;", "typefaceRequestCache", "Landroidx/compose/ui/text/font/TypefaceRequestCache;", "fontListFontFamilyTypefaceAdapter", "Landroidx/compose/ui/text/font/FontListFontFamilyTypefaceAdapter;", "platformFamilyTypefaceAdapter", "Landroidx/compose/ui/text/font/PlatformFontFamilyTypefaceAdapter;", "(Landroidx/compose/ui/text/font/PlatformFontLoader;Landroidx/compose/ui/text/font/PlatformResolveInterceptor;Landroidx/compose/ui/text/font/TypefaceRequestCache;Landroidx/compose/ui/text/font/FontListFontFamilyTypefaceAdapter;Landroidx/compose/ui/text/font/PlatformFontFamilyTypefaceAdapter;)V", "createDefaultTypeface", "Lkotlin/Function1;", "Landroidx/compose/ui/text/font/TypefaceRequest;", "", "getPlatformFontLoader$ui_text_release", "()Landroidx/compose/ui/text/font/PlatformFontLoader;", "preload", "", "fontFamily", "Landroidx/compose/ui/text/font/FontFamily;", "(Landroidx/compose/ui/text/font/FontFamily;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "resolve", "Landroidx/compose/runtime/State;", "fontWeight", "Landroidx/compose/ui/text/font/FontWeight;", "fontStyle", "Landroidx/compose/ui/text/font/FontStyle;", "fontSynthesis", "Landroidx/compose/ui/text/font/FontSynthesis;", "resolve-DPcqOEQ", "(Landroidx/compose/ui/text/font/FontFamily;Landroidx/compose/ui/text/font/FontWeight;II)Landroidx/compose/runtime/State;", "typefaceRequest", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class FontFamilyResolverImpl implements FontFamily.Resolver {
    public static final int $stable = 8;
    private final Function1<TypefaceRequest, Object> createDefaultTypeface;
    private final FontListFontFamilyTypefaceAdapter fontListFontFamilyTypefaceAdapter;
    private final PlatformFontFamilyTypefaceAdapter platformFamilyTypefaceAdapter;
    private final PlatformFontLoader platformFontLoader;
    private final PlatformResolveInterceptor platformResolveInterceptor;
    private final TypefaceRequestCache typefaceRequestCache;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    @DebugMetadata(c = "androidx.compose.ui.text.font.FontFamilyResolverImpl", f = "FontFamilyResolver.kt", i = {0, 0}, l = {45}, m = "preload", n = {"this", "fontFamily"}, s = {"L$0", "L$1"})
    static final class C00121 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C00121(Continuation<? super C00121> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FontFamilyResolverImpl.this.preload(null, (Continuation) this);
        }
    }

    public FontFamilyResolverImpl(PlatformFontLoader platformFontLoader, PlatformResolveInterceptor platformResolveInterceptor, TypefaceRequestCache typefaceRequestCache, FontListFontFamilyTypefaceAdapter fontListFontFamilyTypefaceAdapter, PlatformFontFamilyTypefaceAdapter platformFontFamilyTypefaceAdapter) {
        this.platformFontLoader = platformFontLoader;
        this.platformResolveInterceptor = platformResolveInterceptor;
        this.typefaceRequestCache = typefaceRequestCache;
        this.fontListFontFamilyTypefaceAdapter = fontListFontFamilyTypefaceAdapter;
        this.platformFamilyTypefaceAdapter = platformFontFamilyTypefaceAdapter;
        this.createDefaultTypeface = new Function1<TypefaceRequest, Object>() {
            {
                super(1);
            }

            public final Object invoke(TypefaceRequest typefaceRequest) {
                return this.this$0.resolve(TypefaceRequest.m1440copye1PVR60$default(typefaceRequest, null, null, 0, 0, null, 30, null)).getValue();
            }
        };
    }

    public final PlatformFontLoader getPlatformFontLoader() {
        return this.platformFontLoader;
    }

    public FontFamilyResolverImpl(PlatformFontLoader platformFontLoader, PlatformResolveInterceptor platformResolveInterceptor, TypefaceRequestCache typefaceRequestCache, FontListFontFamilyTypefaceAdapter fontListFontFamilyTypefaceAdapter, PlatformFontFamilyTypefaceAdapter platformFontFamilyTypefaceAdapter, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(platformFontLoader, (i & 2) != 0 ? PlatformResolveInterceptor.INSTANCE.getDefault$ui_text_release() : platformResolveInterceptor, (i & 4) != 0 ? FontFamilyResolverKt.getGlobalTypefaceRequestCache() : typefaceRequestCache, (i & 8) != 0 ? new FontListFontFamilyTypefaceAdapter(FontFamilyResolverKt.getGlobalAsyncTypefaceCache(), null, 2, null) : fontListFontFamilyTypefaceAdapter, (i & 16) != 0 ? new PlatformFontFamilyTypefaceAdapter() : platformFontFamilyTypefaceAdapter);
    }

    @Override
    public Object preload(FontFamily fontFamily, Continuation<? super Unit> continuation) {
        C00121 c00121;
        FontFamilyResolverImpl fontFamilyResolverImpl;
        FontFamily fontFamily2 = fontFamily;
        if (continuation instanceof C00121) {
            c00121 = (C00121) continuation;
            if ((c00121.label & Integer.MIN_VALUE) != 0) {
                c00121.label -= Integer.MIN_VALUE;
            } else {
                c00121 = new C00121(continuation);
            }
        } else {
            c00121 = new C00121(continuation);
        }
        Object obj = c00121.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c00121.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (!(fontFamily2 instanceof FontListFontFamily)) {
                return Unit.INSTANCE;
            }
            FontListFontFamilyTypefaceAdapter fontListFontFamilyTypefaceAdapter = this.fontListFontFamilyTypefaceAdapter;
            PlatformFontLoader platformFontLoader = this.platformFontLoader;
            c00121.L$0 = this;
            c00121.L$1 = fontFamily2;
            c00121.label = 1;
            if (fontListFontFamilyTypefaceAdapter.preload(fontFamily2, platformFontLoader, c00121) == coroutine_suspended) {
                return coroutine_suspended;
            }
            fontFamilyResolverImpl = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            fontFamily2 = (FontFamily) c00121.L$1;
            fontFamilyResolverImpl = (FontFamilyResolverImpl) c00121.L$0;
            ResultKt.throwOnFailure(obj);
        }
        List<Font> fonts = ((FontListFontFamily) fontFamily2).getFonts();
        ArrayList arrayList = new ArrayList(fonts.size());
        int size = fonts.size();
        for (int i2 = 0; i2 < size; i2++) {
            Font font = fonts.get(i2);
            arrayList.add(new TypefaceRequest(fontFamilyResolverImpl.platformResolveInterceptor.interceptFontFamily(fontFamily2), fontFamilyResolverImpl.platformResolveInterceptor.interceptFontWeight(font.getWeight()), fontFamilyResolverImpl.platformResolveInterceptor.mo1350interceptFontStyleT2F_aPo(font.getStyle()), FontSynthesis.INSTANCE.m1416getAllGVVA2EU(), fontFamilyResolverImpl.platformFontLoader.getCacheKey(), null));
        }
        fontFamilyResolverImpl.typefaceRequestCache.preWarmCache(arrayList, new Function1<TypefaceRequest, TypefaceResult>() {
            {
                super(1);
            }

            public final TypefaceResult invoke(TypefaceRequest typefaceRequest) {
                TypefaceResult typefaceResultResolve = FontFamilyResolverImpl.this.fontListFontFamilyTypefaceAdapter.resolve(typefaceRequest, FontFamilyResolverImpl.this.getPlatformFontLoader(), new Function1<TypefaceResult.Immutable, Unit>() {
                    public final void invoke(TypefaceResult.Immutable immutable) {
                    }

                    public Object invoke(Object obj2) {
                        invoke((TypefaceResult.Immutable) obj2);
                        return Unit.INSTANCE;
                    }
                }, FontFamilyResolverImpl.this.createDefaultTypeface);
                if (typefaceResultResolve == null && (typefaceResultResolve = FontFamilyResolverImpl.this.platformFamilyTypefaceAdapter.resolve(typefaceRequest, FontFamilyResolverImpl.this.getPlatformFontLoader(), new Function1<TypefaceResult.Immutable, Unit>() {
                    public final void invoke(TypefaceResult.Immutable immutable) {
                    }

                    public Object invoke(Object obj2) {
                        invoke((TypefaceResult.Immutable) obj2);
                        return Unit.INSTANCE;
                    }
                }, FontFamilyResolverImpl.this.createDefaultTypeface)) == null) {
                    throw new IllegalStateException("Could not load font");
                }
                return typefaceResultResolve;
            }
        });
        return Unit.INSTANCE;
    }

    @Override
    public State<Object> mo1373resolveDPcqOEQ(FontFamily fontFamily, FontWeight fontWeight, int fontStyle, int fontSynthesis) {
        return resolve(new TypefaceRequest(this.platformResolveInterceptor.interceptFontFamily(fontFamily), this.platformResolveInterceptor.interceptFontWeight(fontWeight), this.platformResolveInterceptor.mo1350interceptFontStyleT2F_aPo(fontStyle), this.platformResolveInterceptor.mo1351interceptFontSynthesisMscr08Y(fontSynthesis), this.platformFontLoader.getCacheKey(), null));
    }

    public final State<Object> resolve(final TypefaceRequest typefaceRequest) {
        return this.typefaceRequestCache.runCached(typefaceRequest, new Function1<Function1<? super TypefaceResult, ? extends Unit>, TypefaceResult>() {
            {
                super(1);
            }

            public final TypefaceResult invoke(Function1<? super TypefaceResult, Unit> function1) {
                TypefaceResult typefaceResultResolve = this.this$0.fontListFontFamilyTypefaceAdapter.resolve(typefaceRequest, this.this$0.getPlatformFontLoader(), function1, this.this$0.createDefaultTypeface);
                if (typefaceResultResolve == null && (typefaceResultResolve = this.this$0.platformFamilyTypefaceAdapter.resolve(typefaceRequest, this.this$0.getPlatformFontLoader(), function1, this.this$0.createDefaultTypeface)) == null) {
                    throw new IllegalStateException("Could not load font");
                }
                return typefaceResultResolve;
            }
        });
    }
}
