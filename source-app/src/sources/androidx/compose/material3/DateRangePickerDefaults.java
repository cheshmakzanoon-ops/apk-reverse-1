package androidx.compose.material3;

import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.RowKt;
import androidx.compose.foundation.layout.RowScopeInstance;
import androidx.compose.material3.internal.Strings;
import androidx.compose.material3.internal.Strings_androidKt;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.semantics.LiveRegionMode;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.font.FontStyle;
import androidx.compose.ui.text.font.FontWeight;
import androidx.compose.ui.text.style.TextAlign;
import androidx.compose.ui.text.style.TextDecoration;
import androidx.compose.ui.unit.Dp;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J@\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\u00062\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\rH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fJ\u0087\u0001\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\u00062\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00112\u0011\u0010\u0013\u001a\r\u0012\u0004\u0012\u00020\u00040\u0014¢\u0006\u0002\b\u00152\u0011\u0010\u0016\u001a\r\u0012\u0004\u0012\u00020\u00040\u0014¢\u0006\u0002\b\u00152\u0011\u0010\u0017\u001a\r\u0012\u0004\u0012\u00020\u00040\u0014¢\u0006\u0002\b\u0015H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019J$\u0010\u001a\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\f\u001a\u00020\rH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001c\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001d"}, d2 = {"Landroidx/compose/material3/DateRangePickerDefaults;", "", "()V", "DateRangePickerHeadline", "", "selectedStartDateMillis", "", "selectedEndDateMillis", "displayMode", "Landroidx/compose/material3/DisplayMode;", "dateFormatter", "Landroidx/compose/material3/DatePickerFormatter;", "modifier", "Landroidx/compose/ui/Modifier;", "DateRangePickerHeadline-v84Udv0", "(Ljava/lang/Long;Ljava/lang/Long;ILandroidx/compose/material3/DatePickerFormatter;Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "startDateText", "", "endDateText", "startDatePlaceholder", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "endDatePlaceholder", "datesDelimiter", "DateRangePickerHeadline-0YIUgSQ", "(Ljava/lang/Long;Ljava/lang/Long;ILandroidx/compose/material3/DatePickerFormatter;Landroidx/compose/ui/Modifier;Ljava/lang/String;Ljava/lang/String;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "DateRangePickerTitle", "DateRangePickerTitle-hOD91z4", "(ILandroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DateRangePickerDefaults {
    public static final int $stable = 0;
    public static final DateRangePickerDefaults INSTANCE = new DateRangePickerDefaults();

    private DateRangePickerDefaults() {
    }

    public final void m2306DateRangePickerTitlehOD91z4(final int i, Modifier modifier, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        int i5;
        Modifier modifier3;
        final Modifier modifier4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1412719908);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DateRangePickerTitle)P(0:c#material3.DisplayMode):DateRangePicker.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = i2 | (composerStartRestartGroup.changed(i) ? 4 : 2);
        } else {
            i4 = i2;
        }
        int i6 = i3 & 2;
        if (i6 == 0) {
            if ((i2 & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i5 = i4;
            if ((i5 & 19) == 18 || !composerStartRestartGroup.getSkipping()) {
                if (i6 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1412719908, i5, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerTitle (DateRangePicker.kt:338)");
                }
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(980469064);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "341@15673L48,341@15668L75");
                    Strings.Companion companion = Strings.INSTANCE;
                    TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                    composerStartRestartGroup.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composerStartRestartGroup.startReplaceGroup(980473063);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "343@15798L47,343@15793L74");
                    Strings.Companion companion2 = Strings.INSTANCE;
                    TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_input_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                    composerStartRestartGroup.endReplaceGroup();
                } else {
                    composerStartRestartGroup.startReplaceGroup(329974917);
                    composerStartRestartGroup.endReplaceGroup();
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier4 = modifier2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        this.$tmp0_rcvr.m2306DateRangePickerTitlehOD91z4(i, modifier4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        i5 = i4;
        if ((i5 & 19) == 18) {
            if (i6 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1412719908, i5, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerTitle (DateRangePicker.kt:338)");
            }
            if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(980469064);
                ComposerKt.sourceInformation(composerStartRestartGroup, "341@15673L48,341@15668L75");
                Strings.Companion companion3 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(980473063);
                ComposerKt.sourceInformation(composerStartRestartGroup, "343@15798L47,343@15793L74");
                Strings.Companion companion4 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_input_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(329974917);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
        } else {
            if (i6 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1412719908, i5, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerTitle (DateRangePicker.kt:338)");
            }
            if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(980469064);
                ComposerKt.sourceInformation(composerStartRestartGroup, "341@15673L48,341@15668L75");
                Strings.Companion companion5 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composerStartRestartGroup.startReplaceGroup(980473063);
                ComposerKt.sourceInformation(composerStartRestartGroup, "343@15798L47,343@15793L74");
                Strings.Companion companion6 = Strings.INSTANCE;
                TextKt.m3021Text4IGK_g(Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_input_title), composerStartRestartGroup, 0), modifier3, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composerStartRestartGroup, i5 & 112, 0, 131068);
                composerStartRestartGroup.endReplaceGroup();
            } else {
                composerStartRestartGroup.startReplaceGroup(329974917);
                composerStartRestartGroup.endReplaceGroup();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    this.$tmp0_rcvr.m2306DateRangePickerTitlehOD91z4(i, modifier4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public final void m2305DateRangePickerHeadlinev84Udv0(final Long l, final Long l2, final int i, final DatePickerFormatter datePickerFormatter, Modifier modifier, Composer composer, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        int i5;
        Modifier modifier3;
        final Modifier modifier4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1611069472);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DateRangePickerHeadline)P(4,3,1:c#material3.DisplayMode)367@16887L47,368@16961L45,377@17394L30,378@17459L28,369@17015L534:DateRangePicker.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(l) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        if ((i3 & 2) != 0) {
            i4 |= 48;
        } else if ((i2 & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(l2) ? 32 : 16;
        }
        if ((i3 & 4) != 0) {
            i4 |= 384;
        } else if ((i2 & 384) == 0) {
            i4 |= composerStartRestartGroup.changed(i) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 8) != 0) {
            i4 |= 3072;
        } else if ((i2 & 3072) == 0) {
            i4 |= (i2 & Fields.TransformOrigin) == 0 ? composerStartRestartGroup.changed(datePickerFormatter) : composerStartRestartGroup.changedInstance(datePickerFormatter) ? Fields.CameraDistance : Fields.RotationZ;
        }
        int i6 = i3 & 16;
        if (i6 == 0) {
            if ((i2 & 24576) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? Fields.Clip : Fields.Shape;
            }
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i5 = Fields.RenderEffect;
                } else {
                    i5 = 65536;
                }
                i4 |= i5;
            }
            if ((74899 & i4) == 74898 || !composerStartRestartGroup.getSkipping()) {
                if (i6 != 0) {
                    modifier3 = Modifier.INSTANCE;
                } else {
                    modifier3 = modifier2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1611069472, i4, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline (DateRangePicker.kt:366)");
                }
                Strings.Companion companion = Strings.INSTANCE;
                final String strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_start_headline), composerStartRestartGroup, 0);
                Strings.Companion companion2 = Strings.INSTANCE;
                final String strM3334getString2EP1pXo2 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_end_headline), composerStartRestartGroup, 0);
                m2303DateRangePickerHeadline0YIUgSQ(l, l2, i, datePickerFormatter, modifier3, strM3334getString2EP1pXo, strM3334getString2EP1pXo2, ComposableLambdaKt.rememberComposableLambda(482821121, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        ComposerKt.sourceInformation(composer2, "C377@17396L26:DateRangePicker.kt#uh7d8r");
                        if ((i7 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(482821121, i7, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline.<anonymous> (DateRangePicker.kt:377)");
                        }
                        TextKt.m3021Text4IGK_g(strM3334getString2EP1pXo, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), ComposableLambdaKt.rememberComposableLambda(-1522669758, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        ComposerKt.sourceInformation(composer2, "C378@17461L24:DateRangePicker.kt#uh7d8r");
                        if ((i7 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1522669758, i7, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline.<anonymous> (DateRangePicker.kt:378)");
                        }
                        TextKt.m3021Text4IGK_g(strM3334getString2EP1pXo2, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), ComposableSingletons$DateRangePickerKt.INSTANCE.m2210getLambda1$material3_release(), composerStartRestartGroup, (i4 & 14) | 918552576 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (57344 & i4), (i4 >> 15) & 14);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier4 = modifier3;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier4 = modifier2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i7) {
                        this.$tmp0_rcvr.m2305DateRangePickerHeadlinev84Udv0(l, l2, i, datePickerFormatter, modifier4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        modifier2 = modifier;
        if ((i3 & 32) != 0) {
            i4 |= 196608;
        } else if ((i2 & 196608) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i5 = Fields.RenderEffect;
            } else {
                i5 = 65536;
            }
            i4 |= i5;
        }
        if ((74899 & i4) == 74898) {
            if (i6 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1611069472, i4, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline (DateRangePicker.kt:366)");
            }
            Strings.Companion companion3 = Strings.INSTANCE;
            final String strM3334getString2EP1pXo3 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_start_headline), composerStartRestartGroup, 0);
            Strings.Companion companion4 = Strings.INSTANCE;
            final String strM3334getString2EP1pXo4 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_end_headline), composerStartRestartGroup, 0);
            m2303DateRangePickerHeadline0YIUgSQ(l, l2, i, datePickerFormatter, modifier3, strM3334getString2EP1pXo3, strM3334getString2EP1pXo4, ComposableLambdaKt.rememberComposableLambda(482821121, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    ComposerKt.sourceInformation(composer2, "C377@17396L26:DateRangePicker.kt#uh7d8r");
                    if ((i7 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(482821121, i7, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline.<anonymous> (DateRangePicker.kt:377)");
                    }
                    TextKt.m3021Text4IGK_g(strM3334getString2EP1pXo3, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), ComposableLambdaKt.rememberComposableLambda(-1522669758, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    ComposerKt.sourceInformation(composer2, "C378@17461L24:DateRangePicker.kt#uh7d8r");
                    if ((i7 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1522669758, i7, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline.<anonymous> (DateRangePicker.kt:378)");
                    }
                    TextKt.m3021Text4IGK_g(strM3334getString2EP1pXo4, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), ComposableSingletons$DateRangePickerKt.INSTANCE.m2210getLambda1$material3_release(), composerStartRestartGroup, (i4 & 14) | 918552576 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (57344 & i4), (i4 >> 15) & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
        } else {
            if (i6 != 0) {
                modifier3 = Modifier.INSTANCE;
            } else {
                modifier3 = modifier2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1611069472, i4, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline (DateRangePicker.kt:366)");
            }
            Strings.Companion companion5 = Strings.INSTANCE;
            final String strM3334getString2EP1pXo5 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_start_headline), composerStartRestartGroup, 0);
            Strings.Companion companion6 = Strings.INSTANCE;
            final String strM3334getString2EP1pXo6 = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_range_picker_end_headline), composerStartRestartGroup, 0);
            m2303DateRangePickerHeadline0YIUgSQ(l, l2, i, datePickerFormatter, modifier3, strM3334getString2EP1pXo5, strM3334getString2EP1pXo6, ComposableLambdaKt.rememberComposableLambda(482821121, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    ComposerKt.sourceInformation(composer2, "C377@17396L26:DateRangePicker.kt#uh7d8r");
                    if ((i7 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(482821121, i7, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline.<anonymous> (DateRangePicker.kt:377)");
                    }
                    TextKt.m3021Text4IGK_g(strM3334getString2EP1pXo5, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), ComposableLambdaKt.rememberComposableLambda(-1522669758, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    ComposerKt.sourceInformation(composer2, "C378@17461L24:DateRangePicker.kt#uh7d8r");
                    if ((i7 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1522669758, i7, -1, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline.<anonymous> (DateRangePicker.kt:378)");
                    }
                    TextKt.m3021Text4IGK_g(strM3334getString2EP1pXo6, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), ComposableSingletons$DateRangePickerKt.INSTANCE.m2210getLambda1$material3_release(), composerStartRestartGroup, (i4 & 14) | 918552576 | (i4 & 112) | (i4 & 896) | (i4 & 7168) | (57344 & i4), (i4 >> 15) & 14);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier4 = modifier3;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i7) {
                    this.$tmp0_rcvr.m2305DateRangePickerHeadlinev84Udv0(l, l2, i, datePickerFormatter, modifier4, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public final void m2303DateRangePickerHeadline0YIUgSQ(final Long l, final Long l2, final int i, final DatePickerFormatter datePickerFormatter, final Modifier modifier, final String str, final String str2, final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, final Function2<? super Composer, ? super Integer, Unit> function4, Composer composer, final int i2, final int i3) {
        int i4;
        Composer composer2;
        Composer composerStartRestartGroup = composer.startRestartGroup(-820363420);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DateRangePickerHeadline)P(7,6,2:c#material3.DisplayMode!1,5,9,4,8,3)420@19570L15,456@21103L168,454@21029L748:DateRangePicker.kt#uh7d8r");
        if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(l) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        if ((i2 & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(l2) ? 32 : 16;
        }
        if ((i2 & 384) == 0) {
            i4 |= composerStartRestartGroup.changed(i) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 3072) == 0) {
            i4 |= (i2 & Fields.TransformOrigin) == 0 ? composerStartRestartGroup.changed(datePickerFormatter) : composerStartRestartGroup.changedInstance(datePickerFormatter) ? Fields.CameraDistance : Fields.RotationZ;
        }
        if ((i2 & 24576) == 0) {
            i4 |= composerStartRestartGroup.changed(modifier) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i2) == 0) {
            i4 |= composerStartRestartGroup.changed(str) ? Fields.RenderEffect : 65536;
        }
        if ((1572864 & i2) == 0) {
            i4 |= composerStartRestartGroup.changed(str2) ? 1048576 : 524288;
        }
        if ((12582912 & i2) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function2) ? 8388608 : 4194304;
        }
        if ((100663296 & i2) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function3) ? 67108864 : 33554432;
        }
        if ((805306368 & i2) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function4) ? 536870912 : 268435456;
        }
        int i5 = i4;
        if ((306783379 & i5) != 306783378 || (i3 & 1) != 0 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-820363420, i5, i3, "androidx.compose.material3.DateRangePickerDefaults.DateRangePickerHeadline (DateRangePicker.kt:419)");
            }
            Locale localeDefaultLocale = CalendarLocale_androidKt.defaultLocale(composerStartRestartGroup, 0);
            String date$default = DatePickerFormatter.CC.formatDate$default(datePickerFormatter, l, localeDefaultLocale, false, 4, null);
            String date$default2 = DatePickerFormatter.CC.formatDate$default(datePickerFormatter, l2, localeDefaultLocale, false, 4, null);
            String date = datePickerFormatter.formatDate(l, localeDefaultLocale, true);
            composer2 = composerStartRestartGroup;
            composer2.startReplaceGroup(1063158288);
            String strM3334getString2EP1pXo = "";
            ComposerKt.sourceInformation(composer2, "");
            if (date == null) {
                if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                    composer2.startReplaceGroup(1063166242);
                    ComposerKt.sourceInformation(composer2, "434@20163L51");
                    Strings.Companion companion = Strings.INSTANCE;
                    date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_no_selection_description), composer2, 0);
                    composer2.endReplaceGroup();
                } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                    composer2.startReplaceGroup(1063169213);
                    ComposerKt.sourceInformation(composer2, "435@20256L46");
                    Strings.Companion companion2 = Strings.INSTANCE;
                    date = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_no_input_description), composer2, 0);
                    composer2.endReplaceGroup();
                } else {
                    composer2.startReplaceGroup(-1401419729);
                    composer2.endReplaceGroup();
                    date = "";
                }
            }
            composer2.endReplaceGroup();
            String date2 = datePickerFormatter.formatDate(l2, localeDefaultLocale, true);
            composer2.startReplaceGroup(1063174382);
            ComposerKt.sourceInformation(composer2, "");
            if (date2 != null) {
                strM3334getString2EP1pXo = date2;
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2341getPickerjFl4v0())) {
                composer2.startReplaceGroup(1063182274);
                ComposerKt.sourceInformation(composer2, "446@20664L51");
                Strings.Companion companion3 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_picker_no_selection_description), composer2, 0);
                composer2.endReplaceGroup();
            } else if (DisplayMode.m2336equalsimpl0(i, DisplayMode.INSTANCE.m2340getInputjFl4v0())) {
                composer2.startReplaceGroup(1063185245);
                ComposerKt.sourceInformation(composer2, "447@20757L46");
                Strings.Companion companion4 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_date_input_no_input_description), composer2, 0);
                composer2.endReplaceGroup();
            } else {
                composer2.startReplaceGroup(-1400922737);
                composer2.endReplaceGroup();
            }
            composer2.endReplaceGroup();
            final String str3 = str + ": " + date;
            final String str4 = str2 + ": " + strM3334getString2EP1pXo;
            ComposerKt.sourceInformationMarkerStart(composer2, 1063196439, "CC(remember):DateRangePicker.kt#9igjgp");
            boolean zChanged = composer2.changed(str3) | composer2.changed(str4);
            Object objRememberedValue = composer2.rememberedValue();
            if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6629setLiveRegionhR3wRGc(semanticsPropertyReceiver, LiveRegionMode.INSTANCE.m6603getPolite0phEisY());
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, str3 + ", " + str4);
                    }
                };
                composer2.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(modifier, (Function1) objRememberedValue);
            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
            Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(4));
            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composer2, 54);
            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierClearAndSetSemantics);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composer2.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composer2.startReusableNode();
            if (composer2.getInserting()) {
                composer2.createNode(constructor);
            } else {
                composer2.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer2);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composer2, -407918630, "C100@5047L9:Row.kt#2w3rfo");
            RowScopeInstance rowScopeInstance = RowScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composer2, 303513083, "C468@21589L16:DateRangePicker.kt#uh7d8r");
            if (date$default != null) {
                composer2.startReplaceGroup(303536053);
                ComposerKt.sourceInformation(composer2, "464@21471L31");
                TextKt.m3021Text4IGK_g(date$default, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                composer2.endReplaceGroup();
            } else {
                composer2.startReplaceGroup(303604222);
                ComposerKt.sourceInformation(composer2, "466@21540L22");
                function2.invoke(composer2, Integer.valueOf((i5 >> 21) & 14));
                composer2.endReplaceGroup();
            }
            function4.invoke(composer2, Integer.valueOf((i5 >> 27) & 14));
            if (date$default2 != null) {
                composer2.startReplaceGroup(303729431);
                ComposerKt.sourceInformation(composer2, "470@21666L29");
                TextKt.m3021Text4IGK_g(date$default2, (Modifier) null, 0L, 0L, (FontStyle) null, (FontWeight) null, (FontFamily) null, 0L, (TextDecoration) null, (TextAlign) null, 0L, 0, false, 0, 0, (Function1<? super TextLayoutResult, Unit>) null, (TextStyle) null, composer2, 0, 0, 131070);
                composer2.endReplaceGroup();
            } else {
                composer2.startReplaceGroup(303795616);
                ComposerKt.sourceInformation(composer2, "472@21733L20");
                function3.invoke(composer2, Integer.valueOf((i5 >> 24) & 14));
                composer2.endReplaceGroup();
            }
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            composer2.endNode();
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
            composer2 = composerStartRestartGroup;
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i6) {
                    this.$tmp7_rcvr.m2303DateRangePickerHeadline0YIUgSQ(l, l2, i, datePickerFormatter, modifier, str, str2, function2, function3, function4, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3));
                }
            });
        }
    }
}
