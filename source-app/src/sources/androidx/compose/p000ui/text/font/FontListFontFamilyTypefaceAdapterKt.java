package androidx.compose.p000ui.text.font;

import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000,\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001aR\u0010\u0000\u001a\u0016\u0012\f\u0012\n\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0002\u0012\u0004\u0012\u00020\u00040\u0001*\b\u0012\u0004\u0012\u00020\u00030\u00022\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00040\fH\u0002¨\u0006\r"}, d2 = {"firstImmediatelyAvailable", "Lkotlin/Pair;", "", "Landroidx/compose/ui/text/font/Font;", "", "typefaceRequest", "Landroidx/compose/ui/text/font/TypefaceRequest;", "asyncTypefaceCache", "Landroidx/compose/ui/text/font/AsyncTypefaceCache;", "platformFontLoader", "Landroidx/compose/ui/text/font/PlatformFontLoader;", "createDefaultTypeface", "Lkotlin/Function1;", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class FontListFontFamilyTypefaceAdapterKt {
    public static final Pair<List<Font>, Object> firstImmediatelyAvailable(List<? extends Font> list, TypefaceRequest typefaceRequest, AsyncTypefaceCache asyncTypefaceCache, PlatformFontLoader platformFontLoader, Function1<? super TypefaceRequest, ? extends Object> function1) {
        Object objLoadBlocking;
        Object objM1362unboximpl;
        int size = list.size();
        List listMutableListOf = null;
        for (int i = 0; i < size; i++) {
            Font font = list.get(i);
            int loadingStrategy = font.getLoadingStrategy();
            if (!FontLoadingStrategy.m1386equalsimpl0(loadingStrategy, FontLoadingStrategy.INSTANCE.m1391getBlockingPKNRLFQ())) {
                if (!FontLoadingStrategy.m1386equalsimpl0(loadingStrategy, FontLoadingStrategy.INSTANCE.m1392getOptionalLocalPKNRLFQ())) {
                    if (FontLoadingStrategy.m1386equalsimpl0(loadingStrategy, FontLoadingStrategy.INSTANCE.m1390getAsyncPKNRLFQ())) {
                        AsyncTypefaceCache.AsyncTypefaceResult asyncTypefaceResultM1354get1ASDuI8 = asyncTypefaceCache.m1354get1ASDuI8(font, platformFontLoader);
                        if (asyncTypefaceResultM1354get1ASDuI8 != null) {
                            if (!AsyncTypefaceCache.AsyncTypefaceResult.m1360isPermanentFailureimpl(asyncTypefaceResultM1354get1ASDuI8.m1362unboximpl()) && asyncTypefaceResultM1354get1ASDuI8.m1362unboximpl() != null) {
                                return TuplesKt.to(listMutableListOf, FontSynthesis_androidKt.m1420synthesizeTypefaceFxwP2eA(typefaceRequest.m1445getFontSynthesisGVVA2EU(), asyncTypefaceResultM1354get1ASDuI8.m1362unboximpl(), font, typefaceRequest.getFontWeight(), typefaceRequest.m1444getFontStyle_LCdwA()));
                            }
                        } else if (listMutableListOf == null) {
                            listMutableListOf = CollectionsKt.mutableListOf(new Font[]{font});
                        } else {
                            listMutableListOf.add(font);
                        }
                    } else {
                        throw new IllegalStateException("Unknown font type " + font);
                    }
                } else {
                    synchronized (asyncTypefaceCache.cacheLock) {
                        AsyncTypefaceCache.Key key = new AsyncTypefaceCache.Key(font, platformFontLoader.getCacheKey());
                        AsyncTypefaceCache.AsyncTypefaceResult asyncTypefaceResult = (AsyncTypefaceCache.AsyncTypefaceResult) asyncTypefaceCache.resultCache.get(key);
                        if (asyncTypefaceResult == null) {
                            asyncTypefaceResult = (AsyncTypefaceCache.AsyncTypefaceResult) asyncTypefaceCache.permanentCache.get(key);
                        }
                        if (asyncTypefaceResult != null) {
                            objM1362unboximpl = asyncTypefaceResult.m1362unboximpl();
                        } else {
                            Unit unit = Unit.INSTANCE;
                            try {
                                Result.Companion companion = Result.Companion;
                                objM1362unboximpl = Result.constructor-impl(platformFontLoader.loadBlocking(font));
                            } catch (Throwable th) {
                                Result.Companion companion2 = Result.Companion;
                                objM1362unboximpl = Result.constructor-impl(ResultKt.createFailure(th));
                            }
                            if (Result.isFailure-impl(objM1362unboximpl)) {
                                objM1362unboximpl = null;
                            }
                            AsyncTypefaceCache.put$default(asyncTypefaceCache, font, platformFontLoader, objM1362unboximpl, false, 8, null);
                        }
                    }
                    if (objM1362unboximpl != null) {
                        return TuplesKt.to(listMutableListOf, FontSynthesis_androidKt.m1420synthesizeTypefaceFxwP2eA(typefaceRequest.m1445getFontSynthesisGVVA2EU(), objM1362unboximpl, font, typefaceRequest.getFontWeight(), typefaceRequest.m1444getFontStyle_LCdwA()));
                    }
                }
            } else {
                synchronized (asyncTypefaceCache.cacheLock) {
                    AsyncTypefaceCache.Key key2 = new AsyncTypefaceCache.Key(font, platformFontLoader.getCacheKey());
                    AsyncTypefaceCache.AsyncTypefaceResult asyncTypefaceResult2 = (AsyncTypefaceCache.AsyncTypefaceResult) asyncTypefaceCache.resultCache.get(key2);
                    if (asyncTypefaceResult2 == null) {
                        asyncTypefaceResult2 = (AsyncTypefaceCache.AsyncTypefaceResult) asyncTypefaceCache.permanentCache.get(key2);
                    }
                    if (asyncTypefaceResult2 != null) {
                        objLoadBlocking = asyncTypefaceResult2.m1362unboximpl();
                    } else {
                        Unit unit2 = Unit.INSTANCE;
                        try {
                            objLoadBlocking = platformFontLoader.loadBlocking(font);
                            AsyncTypefaceCache.put$default(asyncTypefaceCache, font, platformFontLoader, objLoadBlocking, false, 8, null);
                        } catch (Exception e) {
                            throw new IllegalStateException("Unable to load font " + font, e);
                        }
                    }
                }
                if (objLoadBlocking == null) {
                    throw new IllegalStateException("Unable to load font " + font);
                }
                return TuplesKt.to(listMutableListOf, FontSynthesis_androidKt.m1420synthesizeTypefaceFxwP2eA(typefaceRequest.m1445getFontSynthesisGVVA2EU(), objLoadBlocking, font, typefaceRequest.getFontWeight(), typefaceRequest.m1444getFontStyle_LCdwA()));
            }
        }
        return TuplesKt.to(listMutableListOf, function1.invoke(typefaceRequest));
    }
}
