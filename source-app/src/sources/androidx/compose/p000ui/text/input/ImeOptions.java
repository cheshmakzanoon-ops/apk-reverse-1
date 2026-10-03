package androidx.compose.p000ui.text.input;

import androidx.compose.p000ui.text.intl.LocaleList;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.webkit.Profile;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0007\u0018\u0000 +2\u00020\u0001:\u0001+BE\b\u0017\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\n\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\rB9\b\u0017\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000eBM\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0007\u001a\u00020\b\u0012\b\b\u0002\u0010\t\u001a\u00020\n\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\b\b\u0002\u0010\u000f\u001a\u00020\u0010¢\u0006\u0002\u0010\u0011JD\u0010\u001e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\nH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 JP\u0010\u001e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\fH\u0007ø\u0001\u0000¢\u0006\u0004\b!\u0010\"JX\u0010\u001e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\b\u0002\u0010\u000f\u001a\u00020\u0010ø\u0001\u0000¢\u0006\u0004\b#\u0010$J\u0013\u0010%\u001a\u00020\u00032\b\u0010&\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010'\u001a\u00020(H\u0016J\b\u0010)\u001a\u00020*H\u0016R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0019\u0010\u0004\u001a\u00020\u0005ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0016\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\u000f\u001a\u00020\u0010¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0019\u0010\t\u001a\u00020\nø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0016\u001a\u0004\b\u0019\u0010\u0015R\u0019\u0010\u0007\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0016\u001a\u0004\b\u001a\u0010\u0015R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0013\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006,"}, d2 = {"Landroidx/compose/ui/text/input/ImeOptions;", "", "singleLine", "", "capitalization", "Landroidx/compose/ui/text/input/KeyboardCapitalization;", "autoCorrect", "keyboardType", "Landroidx/compose/ui/text/input/KeyboardType;", "imeAction", "Landroidx/compose/ui/text/input/ImeAction;", "platformImeOptions", "Landroidx/compose/ui/text/input/PlatformImeOptions;", "(ZIZIILandroidx/compose/ui/text/input/PlatformImeOptions;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "(ZIZIILkotlin/jvm/internal/DefaultConstructorMarker;)V", "hintLocales", "Landroidx/compose/ui/text/intl/LocaleList;", "(ZIZIILandroidx/compose/ui/text/input/PlatformImeOptions;Landroidx/compose/ui/text/intl/LocaleList;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "getAutoCorrect", "()Z", "getCapitalization-IUNYP9k", "()I", "I", "getHintLocales", "()Landroidx/compose/ui/text/intl/LocaleList;", "getImeAction-eUduSuo", "getKeyboardType-PjHm6EE", "getPlatformImeOptions", "()Landroidx/compose/ui/text/input/PlatformImeOptions;", "getSingleLine", "copy", "copy-uxg59PA", "(ZIZII)Landroidx/compose/ui/text/input/ImeOptions;", "copy-YTHSh70", "(ZIZIILandroidx/compose/ui/text/input/PlatformImeOptions;)Landroidx/compose/ui/text/input/ImeOptions;", "copy-wBHncE4", "(ZIZIILandroidx/compose/ui/text/input/PlatformImeOptions;Landroidx/compose/ui/text/intl/LocaleList;)Landroidx/compose/ui/text/input/ImeOptions;", "equals", "other", "hashCode", "", "toString", "", "Companion", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ImeOptions {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private static final ImeOptions Default = new ImeOptions(false, 0, false, 0, 0, null, null, 127, null);
    private final boolean autoCorrect;
    private final int capitalization;
    private final LocaleList hintLocales;
    private final int imeAction;
    private final int keyboardType;
    private final PlatformImeOptions platformImeOptions;
    private final boolean singleLine;

    public ImeOptions(boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, LocaleList localeList, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, i, z2, i2, i3, platformImeOptions, localeList);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Please use the new constructor that takes optional hintLocales parameter.")
    public ImeOptions(boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, i, z2, i2, i3, platformImeOptions);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Please use the new constructor that takes optional platformImeOptions parameter.")
    public ImeOptions(boolean z, int i, boolean z2, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, i, z2, i2, i3);
    }

    private ImeOptions(boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, LocaleList localeList) {
        this.singleLine = z;
        this.capitalization = i;
        this.autoCorrect = z2;
        this.keyboardType = i2;
        this.imeAction = i3;
        this.platformImeOptions = platformImeOptions;
        this.hintLocales = localeList;
    }

    public final boolean getSingleLine() {
        return this.singleLine;
    }

    public ImeOptions(boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, LocaleList localeList, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? false : z, (i4 & 2) != 0 ? KeyboardCapitalization.INSTANCE.m1501getNoneIUNYP9k() : i, (i4 & 4) != 0 ? true : z2, (i4 & 8) != 0 ? KeyboardType.INSTANCE.m1529getTextPjHm6EE() : i2, (i4 & 16) != 0 ? ImeAction.INSTANCE.m1467getDefaulteUduSuo() : i3, (i4 & 32) != 0 ? null : platformImeOptions, (i4 & 64) != 0 ? LocaleList.INSTANCE.getEmpty() : localeList, (DefaultConstructorMarker) null);
    }

    public final int getCapitalization() {
        return this.capitalization;
    }

    public final boolean getAutoCorrect() {
        return this.autoCorrect;
    }

    public final int getKeyboardType() {
        return this.keyboardType;
    }

    public final int getImeAction() {
        return this.imeAction;
    }

    public final PlatformImeOptions getPlatformImeOptions() {
        return this.platformImeOptions;
    }

    public final LocaleList getHintLocales() {
        return this.hintLocales;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/text/input/ImeOptions$Companion;", "", "()V", Profile.DEFAULT_PROFILE_NAME, "Landroidx/compose/ui/text/input/ImeOptions;", "getDefault", "()Landroidx/compose/ui/text/input/ImeOptions;", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ImeOptions getDefault() {
            return ImeOptions.Default;
        }
    }

    public ImeOptions(boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? false : z, (i4 & 2) != 0 ? KeyboardCapitalization.INSTANCE.m1501getNoneIUNYP9k() : i, (i4 & 4) != 0 ? true : z2, (i4 & 8) != 0 ? KeyboardType.INSTANCE.m1529getTextPjHm6EE() : i2, (i4 & 16) != 0 ? ImeAction.INSTANCE.m1467getDefaulteUduSuo() : i3, (i4 & 32) != 0 ? null : platformImeOptions, (DefaultConstructorMarker) null);
    }

    private ImeOptions(boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions) {
        this(z, i, z2, i2, i3, platformImeOptions, LocaleList.INSTANCE.getEmpty(), (DefaultConstructorMarker) null);
    }

    public ImeOptions(boolean z, int i, boolean z2, int i2, int i3, int i4, DefaultConstructorMarker defaultConstructorMarker) {
        this((i4 & 1) != 0 ? false : z, (i4 & 2) != 0 ? KeyboardCapitalization.INSTANCE.m1501getNoneIUNYP9k() : i, (i4 & 4) != 0 ? true : z2, (i4 & 8) != 0 ? KeyboardType.INSTANCE.m1529getTextPjHm6EE() : i2, (i4 & 16) != 0 ? ImeAction.INSTANCE.m1467getDefaulteUduSuo() : i3, (DefaultConstructorMarker) null);
    }

    private ImeOptions(boolean z, int i, boolean z2, int i2, int i3) {
        this(z, i, z2, i2, i3, null, null, 64, null);
    }

    public static ImeOptions m1478copywBHncE4$default(ImeOptions imeOptions, boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, LocaleList localeList, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            z = imeOptions.singleLine;
        }
        if ((i4 & 2) != 0) {
            i = imeOptions.capitalization;
        }
        int i5 = i;
        if ((i4 & 4) != 0) {
            z2 = imeOptions.autoCorrect;
        }
        boolean z3 = z2;
        if ((i4 & 8) != 0) {
            i2 = imeOptions.keyboardType;
        }
        int i6 = i2;
        if ((i4 & 16) != 0) {
            i3 = imeOptions.imeAction;
        }
        int i7 = i3;
        if ((i4 & 32) != 0) {
            platformImeOptions = imeOptions.platformImeOptions;
        }
        PlatformImeOptions platformImeOptions2 = platformImeOptions;
        if ((i4 & 64) != 0) {
            localeList = imeOptions.hintLocales;
        }
        return imeOptions.m1481copywBHncE4(z, i5, z3, i6, i7, platformImeOptions2, localeList);
    }

    public final ImeOptions m1481copywBHncE4(boolean singleLine, int capitalization, boolean autoCorrect, int keyboardType, int imeAction, PlatformImeOptions platformImeOptions, LocaleList hintLocales) {
        return new ImeOptions(singleLine, capitalization, autoCorrect, keyboardType, imeAction, platformImeOptions, hintLocales, (DefaultConstructorMarker) null);
    }

    public static ImeOptions m1476copyYTHSh70$default(ImeOptions imeOptions, boolean z, int i, boolean z2, int i2, int i3, PlatformImeOptions platformImeOptions, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            z = imeOptions.singleLine;
        }
        if ((i4 & 2) != 0) {
            i = imeOptions.capitalization;
        }
        int i5 = i;
        if ((i4 & 4) != 0) {
            z2 = imeOptions.autoCorrect;
        }
        boolean z3 = z2;
        if ((i4 & 8) != 0) {
            i2 = imeOptions.keyboardType;
        }
        int i6 = i2;
        if ((i4 & 16) != 0) {
            i3 = imeOptions.imeAction;
        }
        int i7 = i3;
        if ((i4 & 32) != 0) {
            platformImeOptions = imeOptions.platformImeOptions;
        }
        return imeOptions.m1479copyYTHSh70(z, i5, z3, i6, i7, platformImeOptions);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Please use the new copy function that takes optional hintLocales parameter.")
    public final ImeOptions m1479copyYTHSh70(boolean singleLine, int capitalization, boolean autoCorrect, int keyboardType, int imeAction, PlatformImeOptions platformImeOptions) {
        return new ImeOptions(singleLine, capitalization, autoCorrect, keyboardType, imeAction, platformImeOptions, this.hintLocales, (DefaultConstructorMarker) null);
    }

    public static ImeOptions m1477copyuxg59PA$default(ImeOptions imeOptions, boolean z, int i, boolean z2, int i2, int i3, int i4, Object obj) {
        if ((i4 & 1) != 0) {
            z = imeOptions.singleLine;
        }
        if ((i4 & 2) != 0) {
            i = imeOptions.capitalization;
        }
        int i5 = i;
        if ((i4 & 4) != 0) {
            z2 = imeOptions.autoCorrect;
        }
        boolean z3 = z2;
        if ((i4 & 8) != 0) {
            i2 = imeOptions.keyboardType;
        }
        int i6 = i2;
        if ((i4 & 16) != 0) {
            i3 = imeOptions.imeAction;
        }
        return imeOptions.m1480copyuxg59PA(z, i5, z3, i6, i3);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Please use the new copy function that takes optional platformImeOptions parameter.")
    public final ImeOptions m1480copyuxg59PA(boolean singleLine, int capitalization, boolean autoCorrect, int keyboardType, int imeAction) {
        return new ImeOptions(singleLine, capitalization, autoCorrect, keyboardType, imeAction, this.platformImeOptions, this.hintLocales, (DefaultConstructorMarker) null);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ImeOptions)) {
            return false;
        }
        ImeOptions imeOptions = (ImeOptions) other;
        return this.singleLine == imeOptions.singleLine && KeyboardCapitalization.m1491equalsimpl0(this.capitalization, imeOptions.capitalization) && this.autoCorrect == imeOptions.autoCorrect && KeyboardType.m1508equalsimpl0(this.keyboardType, imeOptions.keyboardType) && ImeAction.m1454equalsimpl0(this.imeAction, imeOptions.imeAction) && Intrinsics.areEqual(this.platformImeOptions, imeOptions.platformImeOptions) && Intrinsics.areEqual(this.hintLocales, imeOptions.hintLocales);
    }

    public int hashCode() {
        int iM = ((((((((UByte$.ExternalSyntheticBackport0.m(this.singleLine) * 31) + KeyboardCapitalization.m1492hashCodeimpl(this.capitalization)) * 31) + UByte$.ExternalSyntheticBackport0.m(this.autoCorrect)) * 31) + KeyboardType.m1509hashCodeimpl(this.keyboardType)) * 31) + ImeAction.m1455hashCodeimpl(this.imeAction)) * 31;
        PlatformImeOptions platformImeOptions = this.platformImeOptions;
        return ((iM + (platformImeOptions != null ? platformImeOptions.hashCode() : 0)) * 31) + this.hintLocales.hashCode();
    }

    public String toString() {
        return "ImeOptions(singleLine=" + this.singleLine + ", capitalization=" + ((Object) KeyboardCapitalization.m1493toStringimpl(this.capitalization)) + ", autoCorrect=" + this.autoCorrect + ", keyboardType=" + ((Object) KeyboardType.m1510toStringimpl(this.keyboardType)) + ", imeAction=" + ((Object) ImeAction.m1456toStringimpl(this.imeAction)) + ", platformImeOptions=" + this.platformImeOptions + ", hintLocales=" + this.hintLocales + ')';
    }
}
