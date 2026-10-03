package androidx.compose.p000ui.text.platform;

import android.content.Context;
import android.graphics.Typeface;
import androidx.compose.p000ui.text.font.Font;
import androidx.compose.p000ui.text.font.FontFamily;
import androidx.compose.p000ui.text.font.FontListFontFamily;
import androidx.compose.p000ui.text.font.FontLoadingStrategy;
import androidx.compose.p000ui.text.font.FontMatcher;
import androidx.compose.p000ui.text.font.FontStyle;
import androidx.compose.p000ui.text.font.FontSynthesis_androidKt;
import androidx.compose.p000ui.text.font.FontWeight;
import androidx.compose.p000ui.util.ListUtilsKt;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Deprecated(message = "This is not supported after downloadable fonts.")
@Metadata(d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0001\u0018\u0000 \u001f2\u00020\u0001:\u0001\u001fB=\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u001c\b\u0002\u0010\u0006\u001a\u0016\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\b\u0018\u00010\u0007\u0012\b\b\u0002\u0010\u000b\u001a\u00020\f¢\u0006\u0002\u0010\rJ*\u0010\u0018\u001a\u00020\u00172\u0006\u0010\u0019\u001a\u00020\t2\u0006\u0010\u001a\u001a\u00020\n2\u0006\u0010\u001b\u001a\u00020\u001cH\u0016ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001eR\u0014\u0010\u0002\u001a\u00020\u000eX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0013\u0010\u000b\u001a\u00020\f¢\u0006\n\n\u0002\b\u0013\u001a\u0004\b\u0011\u0010\u0012R\u001a\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00170\u0015X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006 "}, d2 = {"Landroidx/compose/ui/text/platform/AndroidFontListTypeface;", "Landroidx/compose/ui/text/platform/AndroidTypeface;", "fontFamily", "Landroidx/compose/ui/text/font/FontListFontFamily;", "context", "Landroid/content/Context;", "necessaryStyles", "", "Lkotlin/Pair;", "Landroidx/compose/ui/text/font/FontWeight;", "Landroidx/compose/ui/text/font/FontStyle;", "fontMatcher", "Landroidx/compose/ui/text/font/FontMatcher;", "(Landroidx/compose/ui/text/font/FontListFontFamily;Landroid/content/Context;Ljava/util/List;Landroidx/compose/ui/text/font/FontMatcher;)V", "Landroidx/compose/ui/text/font/FontFamily;", "getFontFamily", "()Landroidx/compose/ui/text/font/FontFamily;", "getFontMatcher", "()Landroidx/compose/ui/text/font/FontMatcher;", "fontMatcher$1", "loadedTypefaces", "", "Landroidx/compose/ui/text/font/Font;", "Landroid/graphics/Typeface;", "getNativeTypeface", "fontWeight", "fontStyle", "synthesis", "Landroidx/compose/ui/text/font/FontSynthesis;", "getNativeTypeface-PYhJU0U", "(Landroidx/compose/ui/text/font/FontWeight;II)Landroid/graphics/Typeface;", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AndroidFontListTypeface implements AndroidTypeface {
    private final FontFamily fontFamily;

    private final FontMatcher fontMatcher;
    private final Map<Font, Typeface> loadedTypefaces;
    private static final Companion Companion = new Companion(null);
    public static final int $stable = 8;
    private static final FontMatcher fontMatcher = new FontMatcher();

    public AndroidFontListTypeface(FontListFontFamily fontListFontFamily, Context context, List<Pair<FontWeight, FontStyle>> list, FontMatcher fontMatcher2) {
        ArrayList arrayList;
        this.fontMatcher = fontMatcher2;
        List<Font> fonts = fontListFontFamily.getFonts();
        ArrayList arrayList2 = new ArrayList(fonts.size());
        int size = fonts.size();
        for (int i = 0; i < size; i++) {
            Font font = fonts.get(i);
            if (FontLoadingStrategy.m1386equalsimpl0(font.getLoadingStrategy(), FontLoadingStrategy.INSTANCE.m1391getBlockingPKNRLFQ())) {
                arrayList2.add(font);
            }
        }
        ArrayList arrayList3 = arrayList2;
        if (list != null) {
            ArrayList arrayList4 = new ArrayList(list.size());
            int size2 = list.size();
            for (int i2 = 0; i2 < size2; i2++) {
                Pair<FontWeight, FontStyle> pair = list.get(i2);
                arrayList4.add((Font) CollectionsKt.firstOrNull(this.fontMatcher.m1395matchFontRetOiIg(arrayList3, (FontWeight) pair.component1(), ((FontStyle) pair.component2()).m1402unboximpl())));
            }
            List listFastFilterNotNull = ListUtilsKt.fastFilterNotNull(arrayList4);
            if (listFastFilterNotNull != null) {
                HashSet hashSet = new HashSet(listFastFilterNotNull.size());
                ArrayList arrayList5 = new ArrayList(listFastFilterNotNull.size());
                int size3 = listFastFilterNotNull.size();
                for (int i3 = 0; i3 < size3; i3++) {
                    Object obj = listFastFilterNotNull.get(i3);
                    if (hashSet.add((Font) obj)) {
                        arrayList5.add(obj);
                    }
                }
                arrayList = arrayList5;
            } else {
                arrayList = null;
            }
        } else {
            arrayList = null;
        }
        arrayList3 = arrayList != null ? arrayList : arrayList3;
        if (arrayList3.isEmpty()) {
            throw new IllegalStateException("Could not match font".toString());
        }
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        int size4 = arrayList3.size();
        for (int i4 = 0; i4 < size4; i4++) {
            Font font2 = (Font) arrayList3.get(i4);
            try {
                linkedHashMap.put(font2, AndroidTypefaceCache.INSTANCE.getOrCreate(context, font2));
            } catch (Exception unused) {
                throw new IllegalStateException("Cannot create Typeface from " + font2);
            }
        }
        this.loadedTypefaces = linkedHashMap;
        this.fontFamily = fontListFontFamily;
    }

    public AndroidFontListTypeface(FontListFontFamily fontListFontFamily, Context context, List list, FontMatcher fontMatcher2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(fontListFontFamily, context, (i & 4) != 0 ? null : list, (i & 8) != 0 ? fontMatcher : fontMatcher2);
    }

    public final FontMatcher getFontMatcher() {
        return this.fontMatcher;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/text/platform/AndroidFontListTypeface$Companion;", "", "()V", "fontMatcher", "Landroidx/compose/ui/text/font/FontMatcher;", "getFontMatcher", "()Landroidx/compose/ui/text/font/FontMatcher;", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final FontMatcher getFontMatcher() {
            return AndroidFontListTypeface.fontMatcher;
        }
    }

    @Override
    public FontFamily getFontFamily() {
        return this.fontFamily;
    }

    @Override
    public Typeface mo1544getNativeTypefacePYhJU0U(FontWeight fontWeight, int fontStyle, int synthesis) {
        Font font = (Font) CollectionsKt.firstOrNull(this.fontMatcher.m1395matchFontRetOiIg(new ArrayList(this.loadedTypefaces.keySet()), fontWeight, fontStyle));
        if (font == null) {
            throw new IllegalStateException("Could not load font".toString());
        }
        Typeface typeface = this.loadedTypefaces.get(font);
        if (typeface == null) {
            throw new IllegalStateException("Could not load typeface".toString());
        }
        Object objM1420synthesizeTypefaceFxwP2eA = FontSynthesis_androidKt.m1420synthesizeTypefaceFxwP2eA(synthesis, typeface, font, fontWeight, fontStyle);
        Intrinsics.checkNotNull(objM1420synthesizeTypefaceFxwP2eA, "null cannot be cast to non-null type android.graphics.Typeface");
        return (Typeface) objM1420synthesizeTypefaceFxwP2eA;
    }
}
