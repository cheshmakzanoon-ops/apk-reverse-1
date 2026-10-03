package androidx.compose.material3;

import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsetsKt;
import androidx.compose.foundation.layout.WindowInsetsPaddingKt;
import androidx.compose.material3.internal.MutableWindowInsets;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.layout.SubcomposeLayoutKt;
import androidx.compose.p002ui.layout.SubcomposeMeasureScope;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000B\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\t\u001a±\u0001\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\u0013\b\u0002\u0010\u0007\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\u0013\b\u0002\u0010\n\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\u0013\b\u0002\u0010\u000b\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\u0013\b\u0002\u0010\f\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u00102\b\b\u0002\u0010\u0012\u001a\u00020\u00132\u0017\u0010\u0014\u001a\u0013\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00040\u0015¢\u0006\u0002\b\tH\u0007ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018\u001a\u0087\u0001\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00020\u000e2\u0011\u0010\u0007\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\u0017\u0010\u0014\u001a\u0013\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00040\u0015¢\u0006\u0002\b\t2\u0011\u0010\u001b\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\u0011\u0010\u001c\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\t2\u0006\u0010\u0012\u001a\u00020\u00132\u0011\u0010\n\u001a\r\u0012\u0004\u0012\u00020\u00040\b¢\u0006\u0002\b\tH\u0003ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001e\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001f"}, d2 = {"FabSpacing", "Landroidx/compose/ui/unit/Dp;", "F", "Scaffold", "", "modifier", "Landroidx/compose/ui/Modifier;", "topBar", "Lkotlin/Function0;", "Landroidx/compose/runtime/Composable;", "bottomBar", "snackbarHost", "floatingActionButton", "floatingActionButtonPosition", "Landroidx/compose/material3/FabPosition;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "contentColor", "contentWindowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/PaddingValues;", "Scaffold-TvnljyQ", "(Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;IJJLandroidx/compose/foundation/layout/WindowInsets;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "ScaffoldLayout", "fabPosition", "snackbar", "fab", "ScaffoldLayout-FMILGgc", "(ILkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/foundation/layout/WindowInsets;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ScaffoldKt {
    private static final float FabSpacing = Dp.constructor-impl(16);

    public static final void m2720ScaffoldTvnljyQ(Modifier modifier, Function2<? super Composer, ? super Integer, Unit> function2, Function2<? super Composer, ? super Integer, Unit> function3, Function2<? super Composer, ? super Integer, Unit> function4, Function2<? super Composer, ? super Integer, Unit> function5, int i, long j, long j2, WindowInsets windowInsets, final Function3<? super PaddingValues, ? super Composer, ? super Integer, Unit> function6, Composer composer, final int i2, final int i3) {
        int i4;
        Function2<? super Composer, ? super Integer, Unit> function7;
        int i5;
        Function2<? super Composer, ? super Integer, Unit> function8;
        int i6;
        int i7;
        int i8;
        int i9;
        Function2<? super Composer, ? super Integer, Unit> function9;
        int i10;
        int i11;
        int i12;
        long jM2173contentColorForek8zF_U;
        int i13;
        Modifier.Companion companion;
        Function2<? super Composer, ? super Integer, Unit> function2M2219getLambda1$material3_release;
        Function2<? super Composer, ? super Integer, Unit> function2M2220getLambda2$material3_release;
        Function2<? super Composer, ? super Integer, Unit> function2M2221getLambda3$material3_release;
        Function2<? super Composer, ? super Integer, Unit> function2M2222getLambda4$material3_release;
        int iM2388getEndERTFSPs;
        int i14;
        long background;
        final WindowInsets contentWindowInsets;
        int i15;
        long j3;
        boolean z;
        Object objRememberedValue;
        final MutableWindowInsets mutableWindowInsets;
        boolean zChanged;
        Object objRememberedValue2;
        long j4;
        final Function2<? super Composer, ? super Integer, Unit> function10;
        final Function2<? super Composer, ? super Integer, Unit> function11;
        final Function2<? super Composer, ? super Integer, Unit> function12;
        WindowInsets windowInsets2;
        long j5;
        Modifier modifier2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i16;
        int i17;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1219521777);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(Scaffold)P(7,9!1,8,5,6:c#material3.FabPosition,1:c#ui.graphics.Color,3:c#ui.graphics.Color,4)90@4654L11,91@4704L31,92@4794L19,95@4889L74,98@5047L224,104@5347L314,96@4968L693:Scaffold.kt#uh7d8r");
        int i18 = i3 & 1;
        if (i18 != 0) {
            i4 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i2;
        } else {
            i4 = i2;
        }
        int i19 = i3 & 2;
        if (i19 == 0) {
            if ((i2 & 48) == 0) {
                function7 = function2;
                i4 |= composerStartRestartGroup.changedInstance(function7) ? 32 : 16;
            }
            i5 = i3 & 4;
            if (i5 != 0) {
                if ((i2 & 384) == 0) {
                    function8 = function3;
                    if (composerStartRestartGroup.changedInstance(function8)) {
                        i6 = Fields.RotationX;
                    } else {
                        i6 = Fields.SpotShadowColor;
                    }
                    i4 |= i6;
                }
                i7 = i3 & 8;
                if (i7 != 0) {
                    if ((i2 & 3072) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i8 = Fields.CameraDistance;
                        } else {
                            i8 = Fields.RotationZ;
                        }
                        i4 |= i8;
                    }
                    i9 = i3 & 16;
                    if (i9 != 0) {
                        if ((i2 & 24576) == 0) {
                            function9 = function5;
                            if (composerStartRestartGroup.changedInstance(function9)) {
                                i10 = Fields.Clip;
                            } else {
                                i10 = Fields.Shape;
                            }
                            i4 |= i10;
                        }
                        i11 = i3 & 32;
                        if (i11 != 0) {
                            i4 |= 196608;
                        } else if ((i2 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i)) {
                                i12 = Fields.RenderEffect;
                            } else {
                                i12 = 65536;
                            }
                            i4 |= i12;
                        }
                        if ((i2 & 1572864) != 0) {
                            if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(j)) {
                                i17 = 524288;
                            } else {
                                i17 = 1048576;
                            }
                            i4 |= i17;
                        }
                        if ((i2 & 12582912) == 0) {
                            jM2173contentColorForek8zF_U = j2;
                            if ((i3 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(jM2173contentColorForek8zF_U)) {
                                i16 = 4194304;
                            } else {
                                i16 = 8388608;
                            }
                            i4 |= i16;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & 100663296) != 0) {
                            i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                        }
                        if ((i3 & Fields.RotationY) != 0) {
                            if ((i2 & 805306368) == 0) {
                                if (composerStartRestartGroup.changedInstance(function6)) {
                                    i13 = 536870912;
                                } else {
                                    i13 = 268435456;
                                }
                                i4 |= i13;
                            }
                            if ((i4 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                                composerStartRestartGroup.startDefaults();
                                if ((i2 & 1) == 0 && !composerStartRestartGroup.getDefaultsInvalid()) {
                                    composerStartRestartGroup.skipToGroupEnd();
                                    if ((i3 & 64) != 0) {
                                        i4 &= -3670017;
                                    }
                                    if ((i3 & Fields.SpotShadowColor) != 0) {
                                        i4 &= -29360129;
                                    }
                                    if ((i3 & Fields.RotationX) != 0) {
                                        i4 &= -234881025;
                                    }
                                    companion = modifier;
                                    i14 = i4;
                                    function2M2219getLambda1$material3_release = function7;
                                    function2M2220getLambda2$material3_release = function8;
                                    function2M2222getLambda4$material3_release = function9;
                                    function2M2221getLambda3$material3_release = function4;
                                    iM2388getEndERTFSPs = i;
                                    background = j;
                                } else {
                                    if (i18 != 0) {
                                        companion = Modifier.INSTANCE;
                                    } else {
                                        companion = modifier;
                                    }
                                    if (i19 != 0) {
                                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                    } else {
                                        function2M2219getLambda1$material3_release = function7;
                                    }
                                    if (i5 != 0) {
                                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                    } else {
                                        function2M2220getLambda2$material3_release = function8;
                                    }
                                    if (i7 != 0) {
                                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                    } else {
                                        function2M2221getLambda3$material3_release = function4;
                                    }
                                    if (i9 != 0) {
                                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                    } else {
                                        function2M2222getLambda4$material3_release = function9;
                                    }
                                    if (i11 != 0) {
                                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                    } else {
                                        iM2388getEndERTFSPs = i;
                                    }
                                    if ((i3 & 64) != 0) {
                                        i14 = i4 & (-3670017);
                                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                    } else {
                                        i14 = i4;
                                        background = j;
                                    }
                                    if ((i3 & Fields.SpotShadowColor) != 0) {
                                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                        i14 &= -29360129;
                                    }
                                    if ((i3 & Fields.RotationX) != 0) {
                                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                        i14 &= -234881025;
                                    }
                                    composerStartRestartGroup.endDefaults();
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                                    }
                                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                                    i15 = (234881024 & i14) ^ 100663296;
                                    if (i15 > 67108864 || !composerStartRestartGroup.changed(contentWindowInsets)) {
                                        j3 = jM2173contentColorForek8zF_U;
                                        if ((i14 & 100663296) != 67108864) {
                                            z = false;
                                        }
                                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                                        if (!z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                        }
                                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                                        if (!zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                                {
                                                    super(1);
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((WindowInsets) obj);
                                                    return Unit.INSTANCE;
                                                }

                                                public final void invoke(WindowInsets windowInsets3) {
                                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets3));
                                                }
                                            };
                                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                                        }
                                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                        final int i20 = iM2388getEndERTFSPs;
                                        final Function2<? super Composer, ? super Integer, Unit> function13 = function2M2219getLambda1$material3_release;
                                        final Function2<? super Composer, ? super Integer, Unit> function14 = function2M2221getLambda3$material3_release;
                                        final Function2<? super Composer, ? super Integer, Unit> function15 = function2M2222getLambda4$material3_release;
                                        final Function2<? super Composer, ? super Integer, Unit> function16 = function2M2220getLambda2$material3_release;
                                        int i21 = i14 >> 12;
                                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                            {
                                                super(2);
                                            }

                                            public Object invoke(Object obj, Object obj2) {
                                                invoke((Composer) obj, ((Number) obj2).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(Composer composer2, int i22) {
                                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                                if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventStart(-1979205334, i22, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                                    }
                                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i20, function13, function6, function14, function15, mutableWindowInsets, function16, composer2, 0);
                                                    if (ComposerKt.isTraceInProgress()) {
                                                        ComposerKt.traceEventEnd();
                                                        return;
                                                    }
                                                    return;
                                                }
                                                composer2.skipToGroupEnd();
                                            }
                                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 896) | 12582912 | (i21 & 7168), 114);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                        j4 = background;
                                        function10 = function2M2220getLambda2$material3_release;
                                        function11 = function2M2221getLambda3$material3_release;
                                        function12 = function2M2222getLambda4$material3_release;
                                        windowInsets2 = contentWindowInsets;
                                        j5 = j3;
                                        function7 = function2M2219getLambda1$material3_release;
                                        modifier2 = companion;
                                    } else {
                                        j3 = jM2173contentColorForek8zF_U;
                                    }
                                    z = true;
                                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                                    if (!z) {
                                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                    } else {
                                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                    }
                                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                                    if (!zChanged) {
                                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((WindowInsets) obj);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(WindowInsets windowInsets3) {
                                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets3));
                                            }
                                        };
                                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                                    } else {
                                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                            {
                                                super(1);
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((WindowInsets) obj);
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(WindowInsets windowInsets3) {
                                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets3));
                                            }
                                        };
                                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                                    }
                                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                    final int i22 = iM2388getEndERTFSPs;
                                    final Function2<? super Composer, ? super Integer, Unit> function17 = function2M2219getLambda1$material3_release;
                                    final Function2<? super Composer, ? super Integer, Unit> function18 = function2M2221getLambda3$material3_release;
                                    final Function2<? super Composer, ? super Integer, Unit> function19 = function2M2222getLambda4$material3_release;
                                    final Function2<? super Composer, ? super Integer, Unit> function110 = function2M2220getLambda2$material3_release;
                                    int i23 = i14 >> 12;
                                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                        {
                                            super(2);
                                        }

                                        public Object invoke(Object obj, Object obj2) {
                                            invoke((Composer) obj, ((Number) obj2).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(Composer composer2, int i24) {
                                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                            if ((i24 & 3) != 2 || !composer2.getSkipping()) {
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(-1979205334, i24, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                                }
                                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i22, function17, function6, function18, function19, mutableWindowInsets, function110, composer2, 0);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                    return;
                                                }
                                                return;
                                            }
                                            composer2.skipToGroupEnd();
                                        }
                                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i23 & 896) | 12582912 | (i23 & 7168), 114);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                    j4 = background;
                                    function10 = function2M2220getLambda2$material3_release;
                                    function11 = function2M2221getLambda3$material3_release;
                                    function12 = function2M2222getLambda4$material3_release;
                                    windowInsets2 = contentWindowInsets;
                                    j5 = j3;
                                    function7 = function2M2219getLambda1$material3_release;
                                    modifier2 = companion;
                                }
                                contentWindowInsets = windowInsets;
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                                }
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                                i15 = (234881024 & i14) ^ 100663296;
                                if (i15 > 67108864) {
                                    j3 = jM2173contentColorForek8zF_U;
                                    if ((i14 & 100663296) != 67108864) {
                                        z = true;
                                    } else {
                                        z = false;
                                    }
                                } else {
                                    j3 = jM2173contentColorForek8zF_U;
                                    if ((i14 & 100663296) != 67108864) {
                                        z = true;
                                    } else {
                                        z = false;
                                    }
                                }
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (!z) {
                                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                } else {
                                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                                }
                                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                                if (!zChanged) {
                                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((WindowInsets) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(WindowInsets windowInsets3) {
                                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets3));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                                } else {
                                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                        {
                                            super(1);
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((WindowInsets) obj);
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(WindowInsets windowInsets3) {
                                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets3));
                                        }
                                    };
                                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                                }
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                final int i24 = iM2388getEndERTFSPs;
                                final Function2<? super Composer, ? super Integer, Unit> function111 = function2M2219getLambda1$material3_release;
                                final Function2<? super Composer, ? super Integer, Unit> function112 = function2M2221getLambda3$material3_release;
                                final Function2<? super Composer, ? super Integer, Unit> function113 = function2M2222getLambda4$material3_release;
                                final Function2<? super Composer, ? super Integer, Unit> function114 = function2M2220getLambda2$material3_release;
                                int i25 = i14 >> 12;
                                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i26) {
                                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                        if ((i26 & 3) != 2 || !composer2.getSkipping()) {
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(-1979205334, i26, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                            }
                                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i24, function111, function6, function112, function113, mutableWindowInsets, function114, composer2, 0);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                                return;
                                            }
                                            return;
                                        }
                                        composer2.skipToGroupEnd();
                                    }
                                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i25 & 896) | 12582912 | (i25 & 7168), 114);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                j4 = background;
                                function10 = function2M2220getLambda2$material3_release;
                                function11 = function2M2221getLambda3$material3_release;
                                function12 = function2M2222getLambda4$material3_release;
                                windowInsets2 = contentWindowInsets;
                                j5 = j3;
                                function7 = function2M2219getLambda1$material3_release;
                                modifier2 = companion;
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                modifier2 = modifier;
                                function11 = function4;
                                windowInsets2 = windowInsets;
                                function10 = function8;
                                function12 = function9;
                                iM2388getEndERTFSPs = i;
                                j5 = jM2173contentColorForek8zF_U;
                                j4 = j;
                            }
                            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                            if (scopeUpdateScopeEndRestartGroup != null) {
                                final Modifier modifier3 = modifier2;
                                final Function2<? super Composer, ? super Integer, Unit> function20 = function7;
                                final int i26 = iM2388getEndERTFSPs;
                                final long j6 = j4;
                                final long j7 = j5;
                                final WindowInsets windowInsets3 = windowInsets2;
                                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i27) {
                                        ScaffoldKt.m2720ScaffoldTvnljyQ(modifier3, function20, function10, function11, function12, i26, j6, j7, windowInsets3, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                                    }
                                });
                            }
                        }
                        i4 |= 805306368;
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets4) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets4));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets4) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets4));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i27 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function115 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function116 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function117 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function118 = function2M2220getLambda2$material3_release;
                            int i28 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i29) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i29 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i29, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i27, function115, function6, function116, function117, mutableWindowInsets, function118, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i28 & 896) | 12582912 | (i28 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets4) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets4));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets4) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets4));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i29 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function119 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1110 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1111 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1112 = function2M2220getLambda2$material3_release;
                            int i210 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i211) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i211 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i211, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i29, function119, function6, function1110, function1111, mutableWindowInsets, function1112, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i210 & 896) | 12582912 | (i210 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier4 = modifier2;
                            final Function2<? super Composer, ? super Integer, Unit> function21 = function7;
                            final int i211 = iM2388getEndERTFSPs;
                            final long j8 = j4;
                            final long j9 = j5;
                            final WindowInsets windowInsets4 = windowInsets2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i212) {
                                    ScaffoldKt.m2720ScaffoldTvnljyQ(modifier4, function21, function10, function11, function12, i211, j8, j9, windowInsets4, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                                }
                            });
                        }
                    }
                    i4 |= 24576;
                    function9 = function5;
                    i11 = i3 & 32;
                    if (i11 != 0) {
                        i4 |= 196608;
                    } else if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i4 |= i12;
                    }
                    if ((i2 & 1572864) != 0) {
                        if ((i3 & 64) == 0) {
                            i17 = 524288;
                        } else {
                            i17 = 524288;
                        }
                        i4 |= i17;
                    }
                    if ((i2 & 12582912) == 0) {
                        jM2173contentColorForek8zF_U = j2;
                        if ((i3 & Fields.SpotShadowColor) == 0) {
                            i16 = 4194304;
                        } else {
                            i16 = 4194304;
                        }
                        i4 |= i16;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & 100663296) != 0) {
                        i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i2 & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function6)) {
                                i13 = 536870912;
                            } else {
                                i13 = 268435456;
                            }
                            i4 |= i13;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets5) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets5));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets5) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets5));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i212 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function1113 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1114 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1115 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1116 = function2M2220getLambda2$material3_release;
                            int i213 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i214) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i214 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i214, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i212, function1113, function6, function1114, function1115, mutableWindowInsets, function1116, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i213 & 896) | 12582912 | (i213 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets5) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets5));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets5) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets5));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i214 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function1117 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1118 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1119 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function11110 = function2M2220getLambda2$material3_release;
                            int i215 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i216) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i216 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i216, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i214, function1117, function6, function1118, function1119, mutableWindowInsets, function11110, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i215 & 896) | 12582912 | (i215 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier5 = modifier2;
                            final Function2<? super Composer, ? super Integer, Unit> function22 = function7;
                            final int i216 = iM2388getEndERTFSPs;
                            final long j10 = j4;
                            final long j11 = j5;
                            final WindowInsets windowInsets5 = windowInsets2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i217) {
                                    ScaffoldKt.m2720ScaffoldTvnljyQ(modifier5, function22, function10, function11, function12, i216, j10, j11, windowInsets5, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets6) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets6));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets6) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets6));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i217 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function11111 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11112 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11113 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11114 = function2M2220getLambda2$material3_release;
                        int i218 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i219) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i219 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i219, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i217, function11111, function6, function11112, function11113, mutableWindowInsets, function11114, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i218 & 896) | 12582912 | (i218 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets6) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets6));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets6) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets6));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i219 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function11115 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11116 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11117 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11118 = function2M2220getLambda2$material3_release;
                        int i2110 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i2111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i2111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i219, function11115, function6, function11116, function11117, mutableWindowInsets, function11118, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2110 & 896) | 12582912 | (i2110 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier6 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function23 = function7;
                        final int i2111 = iM2388getEndERTFSPs;
                        final long j12 = j4;
                        final long j13 = j5;
                        final WindowInsets windowInsets6 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2112) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier6, function23, function10, function11, function12, i2111, j12, j13, windowInsets6, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 3072;
                i9 = i3 & 16;
                if (i9 != 0) {
                    if ((i2 & 24576) == 0) {
                        function9 = function5;
                        if (composerStartRestartGroup.changedInstance(function9)) {
                            i10 = Fields.Clip;
                        } else {
                            i10 = Fields.Shape;
                        }
                        i4 |= i10;
                    }
                    i11 = i3 & 32;
                    if (i11 != 0) {
                        i4 |= 196608;
                    } else if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i4 |= i12;
                    }
                    if ((i2 & 1572864) != 0) {
                        if ((i3 & 64) == 0) {
                            i17 = 524288;
                        } else {
                            i17 = 524288;
                        }
                        i4 |= i17;
                    }
                    if ((i2 & 12582912) == 0) {
                        jM2173contentColorForek8zF_U = j2;
                        if ((i3 & Fields.SpotShadowColor) == 0) {
                            i16 = 4194304;
                        } else {
                            i16 = 4194304;
                        }
                        i4 |= i16;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & 100663296) != 0) {
                        i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i2 & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function6)) {
                                i13 = 536870912;
                            } else {
                                i13 = 268435456;
                            }
                            i4 |= i13;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets7) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets7));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets7) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets7));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i2112 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function11119 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111110 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111112 = function2M2220getLambda2$material3_release;
                            int i2113 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2114) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i2114 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i2114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2112, function11119, function6, function111110, function111111, mutableWindowInsets, function111112, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2113 & 896) | 12582912 | (i2113 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets7) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets7));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets7) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets7));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i2114 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function111113 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111114 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111115 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111116 = function2M2220getLambda2$material3_release;
                            int i2115 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2116) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i2116 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i2116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2114, function111113, function6, function111114, function111115, mutableWindowInsets, function111116, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2115 & 896) | 12582912 | (i2115 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier7 = modifier2;
                            final Function2<? super Composer, ? super Integer, Unit> function24 = function7;
                            final int i2116 = iM2388getEndERTFSPs;
                            final long j14 = j4;
                            final long j15 = j5;
                            final WindowInsets windowInsets7 = windowInsets2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2117) {
                                    ScaffoldKt.m2720ScaffoldTvnljyQ(modifier7, function24, function10, function11, function12, i2116, j14, j15, windowInsets7, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets8) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets8));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets8) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets8));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i2117 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function111117 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111118 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111119 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111110 = function2M2220getLambda2$material3_release;
                        int i2118 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2119) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i2119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i2119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2117, function111117, function6, function111118, function111119, mutableWindowInsets, function1111110, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2118 & 896) | 12582912 | (i2118 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets8) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets8));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets8) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets8));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i2119 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111112 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111113 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111114 = function2M2220getLambda2$material3_release;
                        int i21110 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2119, function1111111, function6, function1111112, function1111113, mutableWindowInsets, function1111114, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21110 & 896) | 12582912 | (i21110 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier8 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function25 = function7;
                        final int i21111 = iM2388getEndERTFSPs;
                        final long j16 = j4;
                        final long j17 = j5;
                        final WindowInsets windowInsets8 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21112) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier8, function25, function10, function11, function12, i21111, j16, j17, windowInsets8, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 24576;
                function9 = function5;
                i11 = i3 & 32;
                if (i11 != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                if ((i2 & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i17 = 524288;
                    } else {
                        i17 = 524288;
                    }
                    i4 |= i17;
                }
                if ((i2 & 12582912) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        i16 = 4194304;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i13 = 536870912;
                        } else {
                            i13 = 268435456;
                        }
                        i4 |= i13;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets9) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets9));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets9) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets9));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21112 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111115 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111116 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111117 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111118 = function2M2220getLambda2$material3_release;
                        int i21113 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21114) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21112, function1111115, function6, function1111116, function1111117, mutableWindowInsets, function1111118, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21113 & 896) | 12582912 | (i21113 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets9) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets9));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets9) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets9));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21114 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111119 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111110 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111112 = function2M2220getLambda2$material3_release;
                        int i21115 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21116) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21114, function1111119, function6, function11111110, function11111111, mutableWindowInsets, function11111112, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21115 & 896) | 12582912 | (i21115 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier9 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function26 = function7;
                        final int i21116 = iM2388getEndERTFSPs;
                        final long j18 = j4;
                        final long j19 = j5;
                        final WindowInsets windowInsets9 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21117) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier9, function26, function10, function11, function12, i21116, j18, j19, windowInsets9, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets10) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets10));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets10) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets10));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21117 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111113 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111114 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111115 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111116 = function2M2220getLambda2$material3_release;
                    int i21118 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21119) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i21119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i21119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21117, function11111113, function6, function11111114, function11111115, mutableWindowInsets, function11111116, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21118 & 896) | 12582912 | (i21118 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets10) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets10));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets10) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets10));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21119 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111117 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111118 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111119 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111110 = function2M2220getLambda2$material3_release;
                    int i211110 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21119, function11111117, function6, function11111118, function11111119, mutableWindowInsets, function111111110, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211110 & 896) | 12582912 | (i211110 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier10 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function27 = function7;
                    final int i211111 = iM2388getEndERTFSPs;
                    final long j110 = j4;
                    final long j111 = j5;
                    final WindowInsets windowInsets10 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211112) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier10, function27, function10, function11, function12, i211111, j110, j111, windowInsets10, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 384;
            function8 = function3;
            i7 = i3 & 8;
            if (i7 != 0) {
                if ((i2 & 3072) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = Fields.CameraDistance;
                    } else {
                        i8 = Fields.RotationZ;
                    }
                    i4 |= i8;
                }
                i9 = i3 & 16;
                if (i9 != 0) {
                    if ((i2 & 24576) == 0) {
                        function9 = function5;
                        if (composerStartRestartGroup.changedInstance(function9)) {
                            i10 = Fields.Clip;
                        } else {
                            i10 = Fields.Shape;
                        }
                        i4 |= i10;
                    }
                    i11 = i3 & 32;
                    if (i11 != 0) {
                        i4 |= 196608;
                    } else if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i4 |= i12;
                    }
                    if ((i2 & 1572864) != 0) {
                        if ((i3 & 64) == 0) {
                            i17 = 524288;
                        } else {
                            i17 = 524288;
                        }
                        i4 |= i17;
                    }
                    if ((i2 & 12582912) == 0) {
                        jM2173contentColorForek8zF_U = j2;
                        if ((i3 & Fields.SpotShadowColor) == 0) {
                            i16 = 4194304;
                        } else {
                            i16 = 4194304;
                        }
                        i4 |= i16;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & 100663296) != 0) {
                        i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i2 & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function6)) {
                                i13 = 536870912;
                            } else {
                                i13 = 268435456;
                            }
                            i4 |= i13;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets11) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets11));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets11) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets11));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i211112 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111112 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111113 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111114 = function2M2220getLambda2$material3_release;
                            int i211113 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i211114) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i211114 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i211114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211112, function111111111, function6, function111111112, function111111113, mutableWindowInsets, function111111114, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211113 & 896) | 12582912 | (i211113 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets11) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets11));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets11) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets11));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i211114 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function111111115 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111116 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111117 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111118 = function2M2220getLambda2$material3_release;
                            int i211115 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i211116) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i211116 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i211116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211114, function111111115, function6, function111111116, function111111117, mutableWindowInsets, function111111118, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211115 & 896) | 12582912 | (i211115 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier11 = modifier2;
                            final Function2<? super Composer, ? super Integer, Unit> function28 = function7;
                            final int i211116 = iM2388getEndERTFSPs;
                            final long j112 = j4;
                            final long j113 = j5;
                            final WindowInsets windowInsets11 = windowInsets2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i211117) {
                                    ScaffoldKt.m2720ScaffoldTvnljyQ(modifier11, function28, function10, function11, function12, i211116, j112, j113, windowInsets11, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets12) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets12));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets12) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets12));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i211117 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function111111119 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111110 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111112 = function2M2220getLambda2$material3_release;
                        int i211118 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211119) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i211119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i211119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211117, function111111119, function6, function1111111110, function1111111111, mutableWindowInsets, function1111111112, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211118 & 896) | 12582912 | (i211118 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets12) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets12));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets12) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets12));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i211119 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111113 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111114 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111115 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111116 = function2M2220getLambda2$material3_release;
                        int i2111110 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111111) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i2111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i2111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211119, function1111111113, function6, function1111111114, function1111111115, mutableWindowInsets, function1111111116, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111110 & 896) | 12582912 | (i2111110 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier12 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function29 = function7;
                        final int i2111111 = iM2388getEndERTFSPs;
                        final long j114 = j4;
                        final long j115 = j5;
                        final WindowInsets windowInsets12 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111112) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier12, function29, function10, function11, function12, i2111111, j114, j115, windowInsets12, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 24576;
                function9 = function5;
                i11 = i3 & 32;
                if (i11 != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                if ((i2 & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i17 = 524288;
                    } else {
                        i17 = 524288;
                    }
                    i4 |= i17;
                }
                if ((i2 & 12582912) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        i16 = 4194304;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i13 = 536870912;
                        } else {
                            i13 = 268435456;
                        }
                        i4 |= i13;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets13) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets13));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets13) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets13));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i2111112 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111117 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111118 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111119 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111110 = function2M2220getLambda2$material3_release;
                        int i2111113 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111114) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i2111114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i2111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111112, function1111111117, function6, function1111111118, function1111111119, mutableWindowInsets, function11111111110, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111113 & 896) | 12582912 | (i2111113 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets13) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets13));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets13) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets13));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i2111114 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111112 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111113 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111114 = function2M2220getLambda2$material3_release;
                        int i2111115 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111116) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i2111116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i2111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111114, function11111111111, function6, function11111111112, function11111111113, mutableWindowInsets, function11111111114, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111115 & 896) | 12582912 | (i2111115 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier13 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function210 = function7;
                        final int i2111116 = iM2388getEndERTFSPs;
                        final long j116 = j4;
                        final long j117 = j5;
                        final WindowInsets windowInsets13 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111117) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier13, function210, function10, function11, function12, i2111116, j116, j117, windowInsets13, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets14) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets14));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets14) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets14));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i2111117 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111115 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111116 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111117 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111118 = function2M2220getLambda2$material3_release;
                    int i2111118 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111119) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i2111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i2111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111117, function11111111115, function6, function11111111116, function11111111117, mutableWindowInsets, function11111111118, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111118 & 896) | 12582912 | (i2111118 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets14) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets14));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets14) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets14));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i2111119 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111119 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111110 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111112 = function2M2220getLambda2$material3_release;
                    int i21111110 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111111) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i21111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i21111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111119, function11111111119, function6, function111111111110, function111111111111, mutableWindowInsets, function111111111112, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111110 & 896) | 12582912 | (i21111110 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier14 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function211 = function7;
                    final int i21111111 = iM2388getEndERTFSPs;
                    final long j118 = j4;
                    final long j119 = j5;
                    final WindowInsets windowInsets14 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111112) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier14, function211, function10, function11, function12, i21111111, j118, j119, windowInsets14, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            i9 = i3 & 16;
            if (i9 != 0) {
                if ((i2 & 24576) == 0) {
                    function9 = function5;
                    if (composerStartRestartGroup.changedInstance(function9)) {
                        i10 = Fields.Clip;
                    } else {
                        i10 = Fields.Shape;
                    }
                    i4 |= i10;
                }
                i11 = i3 & 32;
                if (i11 != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                if ((i2 & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i17 = 524288;
                    } else {
                        i17 = 524288;
                    }
                    i4 |= i17;
                }
                if ((i2 & 12582912) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        i16 = 4194304;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i13 = 536870912;
                        } else {
                            i13 = 268435456;
                        }
                        i4 |= i13;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets15) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets15));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets15) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets15));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21111112 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111113 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111114 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111115 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111116 = function2M2220getLambda2$material3_release;
                        int i21111113 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111114) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111112, function111111111113, function6, function111111111114, function111111111115, mutableWindowInsets, function111111111116, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111113 & 896) | 12582912 | (i21111113 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets15) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets15));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets15) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets15));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21111114 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111117 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111118 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111119 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111110 = function2M2220getLambda2$material3_release;
                        int i21111115 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111116) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111114, function111111111117, function6, function111111111118, function111111111119, mutableWindowInsets, function1111111111110, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111115 & 896) | 12582912 | (i21111115 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier15 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function212 = function7;
                        final int i21111116 = iM2388getEndERTFSPs;
                        final long j1110 = j4;
                        final long j1111 = j5;
                        final WindowInsets windowInsets15 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111117) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier15, function212, function10, function11, function12, i21111116, j1110, j1111, windowInsets15, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets16) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets16));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets16) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets16));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21111117 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111112 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111113 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111114 = function2M2220getLambda2$material3_release;
                    int i21111118 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111119) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i21111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i21111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111117, function1111111111111, function6, function1111111111112, function1111111111113, mutableWindowInsets, function1111111111114, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111118 & 896) | 12582912 | (i21111118 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets16) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets16));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets16) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets16));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21111119 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111115 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111116 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111117 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111118 = function2M2220getLambda2$material3_release;
                    int i211111110 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111119, function1111111111115, function6, function1111111111116, function1111111111117, mutableWindowInsets, function1111111111118, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111110 & 896) | 12582912 | (i211111110 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier16 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function213 = function7;
                    final int i211111111 = iM2388getEndERTFSPs;
                    final long j1112 = j4;
                    final long j1113 = j5;
                    final WindowInsets windowInsets16 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111112) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier16, function213, function10, function11, function12, i211111111, j1112, j1113, windowInsets16, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            function9 = function5;
            i11 = i3 & 32;
            if (i11 != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i12 = Fields.RenderEffect;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            if ((i2 & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i17 = 524288;
                } else {
                    i17 = 524288;
                }
                i4 |= i17;
            }
            if ((i2 & 12582912) == 0) {
                jM2173contentColorForek8zF_U = j2;
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i16 = 4194304;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            } else {
                jM2173contentColorForek8zF_U = j2;
            }
            if ((i2 & 100663296) != 0) {
                i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
            }
            if ((i3 & Fields.RotationY) != 0) {
                if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i13 = 536870912;
                    } else {
                        i13 = 268435456;
                    }
                    i4 |= i13;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets17) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets17));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets17) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets17));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i211111112 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111119 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111110 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111112 = function2M2220getLambda2$material3_release;
                    int i211111113 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111114) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111112, function1111111111119, function6, function11111111111110, function11111111111111, mutableWindowInsets, function11111111111112, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111113 & 896) | 12582912 | (i211111113 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets17) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets17));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets17) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets17));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i211111114 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111113 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111114 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111115 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111116 = function2M2220getLambda2$material3_release;
                    int i211111115 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111116) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111114, function11111111111113, function6, function11111111111114, function11111111111115, mutableWindowInsets, function11111111111116, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111115 & 896) | 12582912 | (i211111115 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier17 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function214 = function7;
                    final int i211111116 = iM2388getEndERTFSPs;
                    final long j1114 = j4;
                    final long j1115 = j5;
                    final WindowInsets windowInsets17 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111117) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier17, function214, function10, function11, function12, i211111116, j1114, j1115, windowInsets17, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets18) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets18));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets18) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets18));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i211111117 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111117 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111118 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111119 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111110 = function2M2220getLambda2$material3_release;
                int i211111118 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i211111119) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i211111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i211111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111117, function11111111111117, function6, function11111111111118, function11111111111119, mutableWindowInsets, function111111111111110, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111118 & 896) | 12582912 | (i211111118 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets18) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets18));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets18) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets18));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i211111119 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111112 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111113 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111114 = function2M2220getLambda2$material3_release;
                int i2111111110 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111111111) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i2111111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i2111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111119, function111111111111111, function6, function111111111111112, function111111111111113, mutableWindowInsets, function111111111111114, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111110 & 896) | 12582912 | (i2111111110 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier18 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function215 = function7;
                final int i2111111111 = iM2388getEndERTFSPs;
                final long j1116 = j4;
                final long j1117 = j5;
                final WindowInsets windowInsets18 = windowInsets2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111111112) {
                        ScaffoldKt.m2720ScaffoldTvnljyQ(modifier18, function215, function10, function11, function12, i2111111111, j1116, j1117, windowInsets18, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 48;
        function7 = function2;
        i5 = i3 & 4;
        if (i5 != 0) {
            if ((i2 & 384) == 0) {
                function8 = function3;
                if (composerStartRestartGroup.changedInstance(function8)) {
                    i6 = Fields.RotationX;
                } else {
                    i6 = Fields.SpotShadowColor;
                }
                i4 |= i6;
            }
            i7 = i3 & 8;
            if (i7 != 0) {
                if ((i2 & 3072) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i8 = Fields.CameraDistance;
                    } else {
                        i8 = Fields.RotationZ;
                    }
                    i4 |= i8;
                }
                i9 = i3 & 16;
                if (i9 != 0) {
                    if ((i2 & 24576) == 0) {
                        function9 = function5;
                        if (composerStartRestartGroup.changedInstance(function9)) {
                            i10 = Fields.Clip;
                        } else {
                            i10 = Fields.Shape;
                        }
                        i4 |= i10;
                    }
                    i11 = i3 & 32;
                    if (i11 != 0) {
                        i4 |= 196608;
                    } else if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i)) {
                            i12 = Fields.RenderEffect;
                        } else {
                            i12 = 65536;
                        }
                        i4 |= i12;
                    }
                    if ((i2 & 1572864) != 0) {
                        if ((i3 & 64) == 0) {
                            i17 = 524288;
                        } else {
                            i17 = 524288;
                        }
                        i4 |= i17;
                    }
                    if ((i2 & 12582912) == 0) {
                        jM2173contentColorForek8zF_U = j2;
                        if ((i3 & Fields.SpotShadowColor) == 0) {
                            i16 = 4194304;
                        } else {
                            i16 = 4194304;
                        }
                        i4 |= i16;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & 100663296) != 0) {
                        i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i2 & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function6)) {
                                i13 = 536870912;
                            } else {
                                i13 = 268435456;
                            }
                            i4 |= i13;
                        }
                        if ((i4 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets19) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets19));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets19) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets19));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i2111111112 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111111115 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111111116 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111111117 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111111118 = function2M2220getLambda2$material3_release;
                            int i2111111113 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2111111114) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i2111111114 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i2111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111112, function111111111111115, function6, function111111111111116, function111111111111117, mutableWindowInsets, function111111111111118, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111113 & 896) | 12582912 | (i2111111113 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i2 & 1) == 0) {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            } else {
                                if (i18 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i19 != 0) {
                                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                                } else {
                                    function2M2219getLambda1$material3_release = function7;
                                }
                                if (i5 != 0) {
                                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                                } else {
                                    function2M2220getLambda2$material3_release = function8;
                                }
                                if (i7 != 0) {
                                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                                } else {
                                    function2M2221getLambda3$material3_release = function4;
                                }
                                if (i9 != 0) {
                                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                                } else {
                                    function2M2222getLambda4$material3_release = function9;
                                }
                                if (i11 != 0) {
                                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                                } else {
                                    iM2388getEndERTFSPs = i;
                                }
                                if ((i3 & 64) != 0) {
                                    i14 = i4 & (-3670017);
                                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                                } else {
                                    i14 = i4;
                                    background = j;
                                }
                                if ((i3 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                    i14 &= -29360129;
                                }
                                if ((i3 & Fields.RotationX) != 0) {
                                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                    i14 &= -234881025;
                                } else {
                                    contentWindowInsets = windowInsets;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                            i15 = (234881024 & i14) ^ 100663296;
                            if (i15 > 67108864) {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            } else {
                                j3 = jM2173contentColorForek8zF_U;
                                if ((i14 & 100663296) != 67108864) {
                                    z = true;
                                } else {
                                    z = false;
                                }
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z) {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            } else {
                                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged) {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets19) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets19));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            } else {
                                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                    {
                                        super(1);
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((WindowInsets) obj);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(WindowInsets windowInsets19) {
                                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets19));
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final int i2111111114 = iM2388getEndERTFSPs;
                            final Function2<? super Composer, ? super Integer, Unit> function111111111111119 = function2M2219getLambda1$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1111111111111110 = function2M2221getLambda3$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1111111111111111 = function2M2222getLambda4$material3_release;
                            final Function2<? super Composer, ? super Integer, Unit> function1111111111111112 = function2M2220getLambda2$material3_release;
                            int i2111111115 = i14 >> 12;
                            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2111111116) {
                                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                    if ((i2111111116 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1979205334, i2111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                        }
                                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111114, function111111111111119, function6, function1111111111111110, function1111111111111111, mutableWindowInsets, function1111111111111112, composer2, 0);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111115 & 896) | 12582912 | (i2111111115 & 7168), 114);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            j4 = background;
                            function10 = function2M2220getLambda2$material3_release;
                            function11 = function2M2221getLambda3$material3_release;
                            function12 = function2M2222getLambda4$material3_release;
                            windowInsets2 = contentWindowInsets;
                            j5 = j3;
                            function7 = function2M2219getLambda1$material3_release;
                            modifier2 = companion;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier19 = modifier2;
                            final Function2<? super Composer, ? super Integer, Unit> function216 = function7;
                            final int i2111111116 = iM2388getEndERTFSPs;
                            final long j1118 = j4;
                            final long j1119 = j5;
                            final WindowInsets windowInsets19 = windowInsets2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2111111117) {
                                    ScaffoldKt.m2720ScaffoldTvnljyQ(modifier19, function216, function10, function11, function12, i2111111116, j1118, j1119, windowInsets19, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets110) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets110));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets110) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets110));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i2111111117 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111113 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111114 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111115 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111116 = function2M2220getLambda2$material3_release;
                        int i2111111118 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111111119) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i2111111119 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i2111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111117, function1111111111111113, function6, function1111111111111114, function1111111111111115, mutableWindowInsets, function1111111111111116, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111118 & 896) | 12582912 | (i2111111118 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets110) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets110));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets110) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets110));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i2111111119 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111117 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111118 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111119 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111110 = function2M2220getLambda2$material3_release;
                        int i21111111110 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111111) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111111111 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111119, function1111111111111117, function6, function1111111111111118, function1111111111111119, mutableWindowInsets, function11111111111111110, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111110 & 896) | 12582912 | (i21111111110 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier110 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function217 = function7;
                        final int i21111111111 = iM2388getEndERTFSPs;
                        final long j11110 = j4;
                        final long j11111 = j5;
                        final WindowInsets windowInsets110 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111112) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier110, function217, function10, function11, function12, i21111111111, j11110, j11111, windowInsets110, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 24576;
                function9 = function5;
                i11 = i3 & 32;
                if (i11 != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                if ((i2 & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i17 = 524288;
                    } else {
                        i17 = 524288;
                    }
                    i4 |= i17;
                }
                if ((i2 & 12582912) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        i16 = 4194304;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i13 = 536870912;
                        } else {
                            i13 = 268435456;
                        }
                        i4 |= i13;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets111) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets111));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets111) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets111));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21111111112 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111111 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111112 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111113 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111114 = function2M2220getLambda2$material3_release;
                        int i21111111113 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111114) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111111114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111112, function11111111111111111, function6, function11111111111111112, function11111111111111113, mutableWindowInsets, function11111111111111114, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111113 & 896) | 12582912 | (i21111111113 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets111) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets111));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets111) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets111));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21111111114 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111115 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111116 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111117 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function11111111111111118 = function2M2220getLambda2$material3_release;
                        int i21111111115 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111116) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111111116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111114, function11111111111111115, function6, function11111111111111116, function11111111111111117, mutableWindowInsets, function11111111111111118, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111115 & 896) | 12582912 | (i21111111115 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier111 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function218 = function7;
                        final int i21111111116 = iM2388getEndERTFSPs;
                        final long j11112 = j4;
                        final long j11113 = j5;
                        final WindowInsets windowInsets111 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111117) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier111, function218, function10, function11, function12, i21111111116, j11112, j11113, windowInsets111, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets112) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets112));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets112) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets112));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21111111117 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111119 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111110 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111111 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111112 = function2M2220getLambda2$material3_release;
                    int i21111111118 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111111119) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i21111111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i21111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111117, function11111111111111119, function6, function111111111111111110, function111111111111111111, mutableWindowInsets, function111111111111111112, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111118 & 896) | 12582912 | (i21111111118 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets112) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets112));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets112) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets112));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21111111119 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111113 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111114 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111115 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111116 = function2M2220getLambda2$material3_release;
                    int i211111111110 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111111) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111119, function111111111111111113, function6, function111111111111111114, function111111111111111115, mutableWindowInsets, function111111111111111116, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111110 & 896) | 12582912 | (i211111111110 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier112 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function219 = function7;
                    final int i211111111111 = iM2388getEndERTFSPs;
                    final long j11114 = j4;
                    final long j11115 = j5;
                    final WindowInsets windowInsets112 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111112) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier112, function219, function10, function11, function12, i211111111111, j11114, j11115, windowInsets112, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            i9 = i3 & 16;
            if (i9 != 0) {
                if ((i2 & 24576) == 0) {
                    function9 = function5;
                    if (composerStartRestartGroup.changedInstance(function9)) {
                        i10 = Fields.Clip;
                    } else {
                        i10 = Fields.Shape;
                    }
                    i4 |= i10;
                }
                i11 = i3 & 32;
                if (i11 != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                if ((i2 & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i17 = 524288;
                    } else {
                        i17 = 524288;
                    }
                    i4 |= i17;
                }
                if ((i2 & 12582912) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        i16 = 4194304;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i13 = 536870912;
                        } else {
                            i13 = 268435456;
                        }
                        i4 |= i13;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets113) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets113));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets113) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets113));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i211111111112 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111111111117 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111111111118 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111111111119 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111110 = function2M2220getLambda2$material3_release;
                        int i211111111113 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211111111114) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i211111111114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i211111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111112, function111111111111111117, function6, function111111111111111118, function111111111111111119, mutableWindowInsets, function1111111111111111110, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111113 & 896) | 12582912 | (i211111111113 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets113) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets113));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets113) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets113));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i211111111114 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111112 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111113 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111114 = function2M2220getLambda2$material3_release;
                        int i211111111115 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211111111116) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i211111111116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i211111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111114, function1111111111111111111, function6, function1111111111111111112, function1111111111111111113, mutableWindowInsets, function1111111111111111114, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111115 & 896) | 12582912 | (i211111111115 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier113 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function2110 = function7;
                        final int i211111111116 = iM2388getEndERTFSPs;
                        final long j11116 = j4;
                        final long j11117 = j5;
                        final WindowInsets windowInsets113 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211111111117) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier113, function2110, function10, function11, function12, i211111111116, j11116, j11117, windowInsets113, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets114) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets114));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets114) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets114));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i211111111117 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111115 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111116 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111117 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111118 = function2M2220getLambda2$material3_release;
                    int i211111111118 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111119) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111117, function1111111111111111115, function6, function1111111111111111116, function1111111111111111117, mutableWindowInsets, function1111111111111111118, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111118 & 896) | 12582912 | (i211111111118 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets114) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets114));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets114) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets114));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i211111111119 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111119 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111110 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111112 = function2M2220getLambda2$material3_release;
                    int i2111111111110 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111111) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i2111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i2111111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111119, function1111111111111111119, function6, function11111111111111111110, function11111111111111111111, mutableWindowInsets, function11111111111111111112, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111110 & 896) | 12582912 | (i2111111111110 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier114 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function2111 = function7;
                    final int i2111111111111 = iM2388getEndERTFSPs;
                    final long j11118 = j4;
                    final long j11119 = j5;
                    final WindowInsets windowInsets114 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111112) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier114, function2111, function10, function11, function12, i2111111111111, j11118, j11119, windowInsets114, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            function9 = function5;
            i11 = i3 & 32;
            if (i11 != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i12 = Fields.RenderEffect;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            if ((i2 & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i17 = 524288;
                } else {
                    i17 = 524288;
                }
                i4 |= i17;
            }
            if ((i2 & 12582912) == 0) {
                jM2173contentColorForek8zF_U = j2;
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i16 = 4194304;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            } else {
                jM2173contentColorForek8zF_U = j2;
            }
            if ((i2 & 100663296) != 0) {
                i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
            }
            if ((i3 & Fields.RotationY) != 0) {
                if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i13 = 536870912;
                    } else {
                        i13 = 268435456;
                    }
                    i4 |= i13;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets115) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets115));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets115) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets115));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i2111111111112 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111113 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111114 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111115 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111116 = function2M2220getLambda2$material3_release;
                    int i2111111111113 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111114) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i2111111111114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i2111111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111112, function11111111111111111113, function6, function11111111111111111114, function11111111111111111115, mutableWindowInsets, function11111111111111111116, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111113 & 896) | 12582912 | (i2111111111113 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets115) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets115));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets115) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets115));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i2111111111114 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111117 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111118 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111119 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111111110 = function2M2220getLambda2$material3_release;
                    int i2111111111115 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111116) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i2111111111116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i2111111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111114, function11111111111111111117, function6, function11111111111111111118, function11111111111111111119, mutableWindowInsets, function111111111111111111110, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111115 & 896) | 12582912 | (i2111111111115 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier115 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function2112 = function7;
                    final int i2111111111116 = iM2388getEndERTFSPs;
                    final long j111110 = j4;
                    final long j111111 = j5;
                    final WindowInsets windowInsets115 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111117) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier115, function2112, function10, function11, function12, i2111111111116, j111110, j111111, windowInsets115, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets116) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets116));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets116) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets116));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i2111111111117 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111112 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111113 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111114 = function2M2220getLambda2$material3_release;
                int i2111111111118 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111111111119) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i2111111111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i2111111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111117, function111111111111111111111, function6, function111111111111111111112, function111111111111111111113, mutableWindowInsets, function111111111111111111114, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111118 & 896) | 12582912 | (i2111111111118 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets116) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets116));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets116) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets116));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i2111111111119 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111115 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111116 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111117 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111118 = function2M2220getLambda2$material3_release;
                int i21111111111110 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111111) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i21111111111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i21111111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111119, function111111111111111111115, function6, function111111111111111111116, function111111111111111111117, mutableWindowInsets, function111111111111111111118, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111110 & 896) | 12582912 | (i21111111111110 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier116 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function2113 = function7;
                final int i21111111111111 = iM2388getEndERTFSPs;
                final long j111112 = j4;
                final long j111113 = j5;
                final WindowInsets windowInsets116 = windowInsets2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111112) {
                        ScaffoldKt.m2720ScaffoldTvnljyQ(modifier116, function2113, function10, function11, function12, i21111111111111, j111112, j111113, windowInsets116, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 384;
        function8 = function3;
        i7 = i3 & 8;
        if (i7 != 0) {
            if ((i2 & 3072) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i8 = Fields.CameraDistance;
                } else {
                    i8 = Fields.RotationZ;
                }
                i4 |= i8;
            }
            i9 = i3 & 16;
            if (i9 != 0) {
                if ((i2 & 24576) == 0) {
                    function9 = function5;
                    if (composerStartRestartGroup.changedInstance(function9)) {
                        i10 = Fields.Clip;
                    } else {
                        i10 = Fields.Shape;
                    }
                    i4 |= i10;
                }
                i11 = i3 & 32;
                if (i11 != 0) {
                    i4 |= 196608;
                } else if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i12 = Fields.RenderEffect;
                    } else {
                        i12 = 65536;
                    }
                    i4 |= i12;
                }
                if ((i2 & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i17 = 524288;
                    } else {
                        i17 = 524288;
                    }
                    i4 |= i17;
                }
                if ((i2 & 12582912) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & Fields.SpotShadowColor) == 0) {
                        i16 = 4194304;
                    } else {
                        i16 = 4194304;
                    }
                    i4 |= i16;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i13 = 536870912;
                        } else {
                            i13 = 268435456;
                        }
                        i4 |= i13;
                    }
                    if ((i4 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets117) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets117));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets117) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets117));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21111111111112 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function111111111111111111119 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111110 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111112 = function2M2220getLambda2$material3_release;
                        int i21111111111113 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111111114) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111111111114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111112, function111111111111111111119, function6, function1111111111111111111110, function1111111111111111111111, mutableWindowInsets, function1111111111111111111112, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111113 & 896) | 12582912 | (i21111111111113 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i2 & 1) == 0) {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        } else {
                            if (i18 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i19 != 0) {
                                function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                            } else {
                                function2M2219getLambda1$material3_release = function7;
                            }
                            if (i5 != 0) {
                                function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                            } else {
                                function2M2220getLambda2$material3_release = function8;
                            }
                            if (i7 != 0) {
                                function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                            } else {
                                function2M2221getLambda3$material3_release = function4;
                            }
                            if (i9 != 0) {
                                function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                            } else {
                                function2M2222getLambda4$material3_release = function9;
                            }
                            if (i11 != 0) {
                                iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                            } else {
                                iM2388getEndERTFSPs = i;
                            }
                            if ((i3 & 64) != 0) {
                                i14 = i4 & (-3670017);
                                background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                            } else {
                                i14 = i4;
                                background = j;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                                i14 &= -29360129;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -234881025;
                            } else {
                                contentWindowInsets = windowInsets;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                        i15 = (234881024 & i14) ^ 100663296;
                        if (i15 > 67108864) {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        } else {
                            j3 = jM2173contentColorForek8zF_U;
                            if ((i14 & 100663296) != 67108864) {
                                z = true;
                            } else {
                                z = false;
                            }
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets117) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets117));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        } else {
                            objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((WindowInsets) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(WindowInsets windowInsets117) {
                                    mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets117));
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final int i21111111111114 = iM2388getEndERTFSPs;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111113 = function2M2219getLambda1$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111114 = function2M2221getLambda3$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111115 = function2M2222getLambda4$material3_release;
                        final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111116 = function2M2220getLambda2$material3_release;
                        int i21111111111115 = i14 >> 12;
                        SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111111116) {
                                ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                                if ((i21111111111116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1979205334, i21111111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                    }
                                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111114, function1111111111111111111113, function6, function1111111111111111111114, function1111111111111111111115, mutableWindowInsets, function1111111111111111111116, composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111115 & 896) | 12582912 | (i21111111111115 & 7168), 114);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        j4 = background;
                        function10 = function2M2220getLambda2$material3_release;
                        function11 = function2M2221getLambda3$material3_release;
                        function12 = function2M2222getLambda4$material3_release;
                        windowInsets2 = contentWindowInsets;
                        j5 = j3;
                        function7 = function2M2219getLambda1$material3_release;
                        modifier2 = companion;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier117 = modifier2;
                        final Function2<? super Composer, ? super Integer, Unit> function2114 = function7;
                        final int i21111111111116 = iM2388getEndERTFSPs;
                        final long j111114 = j4;
                        final long j111115 = j5;
                        final WindowInsets windowInsets117 = windowInsets2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21111111111117) {
                                ScaffoldKt.m2720ScaffoldTvnljyQ(modifier117, function2114, function10, function11, function12, i21111111111116, j111114, j111115, windowInsets117, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets118) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets118));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets118) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets118));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21111111111117 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111117 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111118 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111119 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111110 = function2M2220getLambda2$material3_release;
                    int i21111111111118 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111111111119) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i21111111111119 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i21111111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111117, function1111111111111111111117, function6, function1111111111111111111118, function1111111111111111111119, mutableWindowInsets, function11111111111111111111110, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111118 & 896) | 12582912 | (i21111111111118 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets118) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets118));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets118) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets118));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i21111111111119 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111112 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111113 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111114 = function2M2220getLambda2$material3_release;
                    int i211111111111110 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111111111) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111111111111 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111119, function11111111111111111111111, function6, function11111111111111111111112, function11111111111111111111113, mutableWindowInsets, function11111111111111111111114, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111111110 & 896) | 12582912 | (i211111111111110 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier118 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function2115 = function7;
                    final int i211111111111111 = iM2388getEndERTFSPs;
                    final long j111116 = j4;
                    final long j111117 = j5;
                    final WindowInsets windowInsets118 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111111112) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier118, function2115, function10, function11, function12, i211111111111111, j111116, j111117, windowInsets118, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            function9 = function5;
            i11 = i3 & 32;
            if (i11 != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i12 = Fields.RenderEffect;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            if ((i2 & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i17 = 524288;
                } else {
                    i17 = 524288;
                }
                i4 |= i17;
            }
            if ((i2 & 12582912) == 0) {
                jM2173contentColorForek8zF_U = j2;
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i16 = 4194304;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            } else {
                jM2173contentColorForek8zF_U = j2;
            }
            if ((i2 & 100663296) != 0) {
                i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
            }
            if ((i3 & Fields.RotationY) != 0) {
                if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i13 = 536870912;
                    } else {
                        i13 = 268435456;
                    }
                    i4 |= i13;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets119) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets119));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets119) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets119));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i211111111111112 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111115 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111116 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111117 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111118 = function2M2220getLambda2$material3_release;
                    int i211111111111113 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111111114) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111111111114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111111112, function11111111111111111111115, function6, function11111111111111111111116, function11111111111111111111117, mutableWindowInsets, function11111111111111111111118, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111111113 & 896) | 12582912 | (i211111111111113 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets119) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets119));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets119) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets119));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i211111111111114 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111119 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111110 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111112 = function2M2220getLambda2$material3_release;
                    int i211111111111115 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111111116) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i211111111111116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i211111111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111111114, function11111111111111111111119, function6, function111111111111111111111110, function111111111111111111111111, mutableWindowInsets, function111111111111111111111112, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111111115 & 896) | 12582912 | (i211111111111115 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier119 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function2116 = function7;
                    final int i211111111111116 = iM2388getEndERTFSPs;
                    final long j111118 = j4;
                    final long j111119 = j5;
                    final WindowInsets windowInsets119 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211111111111117) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier119, function2116, function10, function11, function12, i211111111111116, j111118, j111119, windowInsets119, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1110) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1110));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1110) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1110));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i211111111111117 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111113 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111114 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111115 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111116 = function2M2220getLambda2$material3_release;
                int i211111111111118 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i211111111111119) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i211111111111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i211111111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111111117, function111111111111111111111113, function6, function111111111111111111111114, function111111111111111111111115, mutableWindowInsets, function111111111111111111111116, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111111118 & 896) | 12582912 | (i211111111111118 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1110) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1110));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1110) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1110));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i211111111111119 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111117 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111118 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111119 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111110 = function2M2220getLambda2$material3_release;
                int i2111111111111110 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111111111111111) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i2111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i2111111111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i211111111111119, function111111111111111111111117, function6, function111111111111111111111118, function111111111111111111111119, mutableWindowInsets, function1111111111111111111111110, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111111110 & 896) | 12582912 | (i2111111111111110 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1110 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function2117 = function7;
                final int i2111111111111111 = iM2388getEndERTFSPs;
                final long j1111110 = j4;
                final long j1111111 = j5;
                final WindowInsets windowInsets1110 = windowInsets2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111111111111112) {
                        ScaffoldKt.m2720ScaffoldTvnljyQ(modifier1110, function2117, function10, function11, function12, i2111111111111111, j1111110, j1111111, windowInsets1110, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        i9 = i3 & 16;
        if (i9 != 0) {
            if ((i2 & 24576) == 0) {
                function9 = function5;
                if (composerStartRestartGroup.changedInstance(function9)) {
                    i10 = Fields.Clip;
                } else {
                    i10 = Fields.Shape;
                }
                i4 |= i10;
            }
            i11 = i3 & 32;
            if (i11 != 0) {
                i4 |= 196608;
            } else if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i12 = Fields.RenderEffect;
                } else {
                    i12 = 65536;
                }
                i4 |= i12;
            }
            if ((i2 & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i17 = 524288;
                } else {
                    i17 = 524288;
                }
                i4 |= i17;
            }
            if ((i2 & 12582912) == 0) {
                jM2173contentColorForek8zF_U = j2;
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i16 = 4194304;
                } else {
                    i16 = 4194304;
                }
                i4 |= i16;
            } else {
                jM2173contentColorForek8zF_U = j2;
            }
            if ((i2 & 100663296) != 0) {
                i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
            }
            if ((i3 & Fields.RotationY) != 0) {
                if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i13 = 536870912;
                    } else {
                        i13 = 268435456;
                    }
                    i4 |= i13;
                }
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets1111) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1111));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets1111) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1111));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i2111111111111112 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111111 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111112 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111113 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111114 = function2M2220getLambda2$material3_release;
                    int i2111111111111113 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111111114) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i2111111111111114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i2111111111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111111112, function1111111111111111111111111, function6, function1111111111111111111111112, function1111111111111111111111113, mutableWindowInsets, function1111111111111111111111114, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111111113 & 896) | 12582912 | (i2111111111111113 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i2 & 1) == 0) {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    } else {
                        if (i18 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i19 != 0) {
                            function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                        } else {
                            function2M2219getLambda1$material3_release = function7;
                        }
                        if (i5 != 0) {
                            function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                        } else {
                            function2M2220getLambda2$material3_release = function8;
                        }
                        if (i7 != 0) {
                            function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                        } else {
                            function2M2221getLambda3$material3_release = function4;
                        }
                        if (i9 != 0) {
                            function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                        } else {
                            function2M2222getLambda4$material3_release = function9;
                        }
                        if (i11 != 0) {
                            iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                        } else {
                            iM2388getEndERTFSPs = i;
                        }
                        if ((i3 & 64) != 0) {
                            i14 = i4 & (-3670017);
                            background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                        } else {
                            i14 = i4;
                            background = j;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                            i14 &= -29360129;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -234881025;
                        } else {
                            contentWindowInsets = windowInsets;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                    i15 = (234881024 & i14) ^ 100663296;
                    if (i15 > 67108864) {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    } else {
                        j3 = jM2173contentColorForek8zF_U;
                        if ((i14 & 100663296) != 67108864) {
                            z = true;
                        } else {
                            z = false;
                        }
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets1111) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1111));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    } else {
                        objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((WindowInsets) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(WindowInsets windowInsets1111) {
                                mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1111));
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final int i2111111111111114 = iM2388getEndERTFSPs;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111115 = function2M2219getLambda1$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111116 = function2M2221getLambda3$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111117 = function2M2222getLambda4$material3_release;
                    final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111118 = function2M2220getLambda2$material3_release;
                    int i2111111111111115 = i14 >> 12;
                    SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111111116) {
                            ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                            if ((i2111111111111116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1979205334, i2111111111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                                }
                                ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111111114, function1111111111111111111111115, function6, function1111111111111111111111116, function1111111111111111111111117, mutableWindowInsets, function1111111111111111111111118, composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111111115 & 896) | 12582912 | (i2111111111111115 & 7168), 114);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    j4 = background;
                    function10 = function2M2220getLambda2$material3_release;
                    function11 = function2M2221getLambda3$material3_release;
                    function12 = function2M2222getLambda4$material3_release;
                    windowInsets2 = contentWindowInsets;
                    j5 = j3;
                    function7 = function2M2219getLambda1$material3_release;
                    modifier2 = companion;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier1111 = modifier2;
                    final Function2<? super Composer, ? super Integer, Unit> function2118 = function7;
                    final int i2111111111111116 = iM2388getEndERTFSPs;
                    final long j1111112 = j4;
                    final long j1111113 = j5;
                    final WindowInsets windowInsets1111 = windowInsets2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111111111111117) {
                            ScaffoldKt.m2720ScaffoldTvnljyQ(modifier1111, function2118, function10, function11, function12, i2111111111111116, j1111112, j1111113, windowInsets1111, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1112) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1112));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1112) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1112));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i2111111111111117 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111119 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111110 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111111 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111112 = function2M2220getLambda2$material3_release;
                int i2111111111111118 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111111111111119) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i2111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i2111111111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111111117, function1111111111111111111111119, function6, function11111111111111111111111110, function11111111111111111111111111, mutableWindowInsets, function11111111111111111111111112, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111111111111118 & 896) | 12582912 | (i2111111111111118 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1112) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1112));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1112) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1112));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i2111111111111119 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111113 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111114 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111115 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111116 = function2M2220getLambda2$material3_release;
                int i21111111111111110 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111111111) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i21111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i21111111111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i2111111111111119, function11111111111111111111111113, function6, function11111111111111111111111114, function11111111111111111111111115, mutableWindowInsets, function11111111111111111111111116, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111111110 & 896) | 12582912 | (i21111111111111110 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1112 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function2119 = function7;
                final int i21111111111111111 = iM2388getEndERTFSPs;
                final long j1111114 = j4;
                final long j1111115 = j5;
                final WindowInsets windowInsets1112 = windowInsets2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111111112) {
                        ScaffoldKt.m2720ScaffoldTvnljyQ(modifier1112, function2119, function10, function11, function12, i21111111111111111, j1111114, j1111115, windowInsets1112, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        function9 = function5;
        i11 = i3 & 32;
        if (i11 != 0) {
            i4 |= 196608;
        } else if ((i2 & 196608) == 0) {
            if (composerStartRestartGroup.changed(i)) {
                i12 = Fields.RenderEffect;
            } else {
                i12 = 65536;
            }
            i4 |= i12;
        }
        if ((i2 & 1572864) != 0) {
            if ((i3 & 64) == 0) {
                i17 = 524288;
            } else {
                i17 = 524288;
            }
            i4 |= i17;
        }
        if ((i2 & 12582912) == 0) {
            jM2173contentColorForek8zF_U = j2;
            if ((i3 & Fields.SpotShadowColor) == 0) {
                i16 = 4194304;
            } else {
                i16 = 4194304;
            }
            i4 |= i16;
        } else {
            jM2173contentColorForek8zF_U = j2;
        }
        if ((i2 & 100663296) != 0) {
            i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 33554432 : 67108864;
        }
        if ((i3 & Fields.RotationY) != 0) {
            if ((i2 & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i13 = 536870912;
                } else {
                    i13 = 268435456;
                }
                i4 |= i13;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1113) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1113));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1113) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1113));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i21111111111111112 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111117 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111118 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function11111111111111111111111119 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111110 = function2M2220getLambda2$material3_release;
                int i21111111111111113 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111111114) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i21111111111111114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i21111111111111114, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111111112, function11111111111111111111111117, function6, function11111111111111111111111118, function11111111111111111111111119, mutableWindowInsets, function111111111111111111111111110, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111111113 & 896) | 12582912 | (i21111111111111113 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i2 & 1) == 0) {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                } else {
                    if (i18 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i19 != 0) {
                        function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                    } else {
                        function2M2219getLambda1$material3_release = function7;
                    }
                    if (i5 != 0) {
                        function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                    } else {
                        function2M2220getLambda2$material3_release = function8;
                    }
                    if (i7 != 0) {
                        function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                    } else {
                        function2M2221getLambda3$material3_release = function4;
                    }
                    if (i9 != 0) {
                        function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                    } else {
                        function2M2222getLambda4$material3_release = function9;
                    }
                    if (i11 != 0) {
                        iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                    } else {
                        iM2388getEndERTFSPs = i;
                    }
                    if ((i3 & 64) != 0) {
                        i14 = i4 & (-3670017);
                        background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                    } else {
                        i14 = i4;
                        background = j;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                        i14 &= -29360129;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -234881025;
                    } else {
                        contentWindowInsets = windowInsets;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
                i15 = (234881024 & i14) ^ 100663296;
                if (i15 > 67108864) {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                } else {
                    j3 = jM2173contentColorForek8zF_U;
                    if ((i14 & 100663296) != 67108864) {
                        z = true;
                    } else {
                        z = false;
                    }
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1113) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1113));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                } else {
                    objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((WindowInsets) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(WindowInsets windowInsets1113) {
                            mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1113));
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final int i21111111111111114 = iM2388getEndERTFSPs;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111111 = function2M2219getLambda1$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111112 = function2M2221getLambda3$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111113 = function2M2222getLambda4$material3_release;
                final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111114 = function2M2220getLambda2$material3_release;
                int i21111111111111115 = i14 >> 12;
                SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111111116) {
                        ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                        if ((i21111111111111116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1979205334, i21111111111111116, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                            }
                            ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111111114, function111111111111111111111111111, function6, function111111111111111111111111112, function111111111111111111111111113, mutableWindowInsets, function111111111111111111111111114, composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111111115 & 896) | 12582912 | (i21111111111111115 & 7168), 114);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                j4 = background;
                function10 = function2M2220getLambda2$material3_release;
                function11 = function2M2221getLambda3$material3_release;
                function12 = function2M2222getLambda4$material3_release;
                windowInsets2 = contentWindowInsets;
                j5 = j3;
                function7 = function2M2219getLambda1$material3_release;
                modifier2 = companion;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1113 = modifier2;
                final Function2<? super Composer, ? super Integer, Unit> function21110 = function7;
                final int i21111111111111116 = iM2388getEndERTFSPs;
                final long j1111116 = j4;
                final long j1111117 = j5;
                final WindowInsets windowInsets1113 = windowInsets2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111111111111117) {
                        ScaffoldKt.m2720ScaffoldTvnljyQ(modifier1113, function21110, function10, function11, function12, i21111111111111116, j1111116, j1111117, windowInsets1113, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                    }
                });
            }
        }
        i4 |= 805306368;
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i18 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i19 != 0) {
                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                } else {
                    function2M2219getLambda1$material3_release = function7;
                }
                if (i5 != 0) {
                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                } else {
                    function2M2220getLambda2$material3_release = function8;
                }
                if (i7 != 0) {
                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                } else {
                    function2M2221getLambda3$material3_release = function4;
                }
                if (i9 != 0) {
                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                } else {
                    function2M2222getLambda4$material3_release = function9;
                }
                if (i11 != 0) {
                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                } else {
                    iM2388getEndERTFSPs = i;
                }
                if ((i3 & 64) != 0) {
                    i14 = i4 & (-3670017);
                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                } else {
                    i14 = i4;
                    background = j;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                    i14 &= -29360129;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -234881025;
                } else {
                    contentWindowInsets = windowInsets;
                }
            } else {
                if (i18 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i19 != 0) {
                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                } else {
                    function2M2219getLambda1$material3_release = function7;
                }
                if (i5 != 0) {
                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                } else {
                    function2M2220getLambda2$material3_release = function8;
                }
                if (i7 != 0) {
                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                } else {
                    function2M2221getLambda3$material3_release = function4;
                }
                if (i9 != 0) {
                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                } else {
                    function2M2222getLambda4$material3_release = function9;
                }
                if (i11 != 0) {
                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                } else {
                    iM2388getEndERTFSPs = i;
                }
                if ((i3 & 64) != 0) {
                    i14 = i4 & (-3670017);
                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                } else {
                    i14 = i4;
                    background = j;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                    i14 &= -29360129;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -234881025;
                } else {
                    contentWindowInsets = windowInsets;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
            i15 = (234881024 & i14) ^ 100663296;
            if (i15 > 67108864) {
                j3 = jM2173contentColorForek8zF_U;
                if ((i14 & 100663296) != 67108864) {
                    z = true;
                } else {
                    z = false;
                }
            } else {
                j3 = jM2173contentColorForek8zF_U;
                if ((i14 & 100663296) != 67108864) {
                    z = true;
                } else {
                    z = false;
                }
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((WindowInsets) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(WindowInsets windowInsets1114) {
                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1114));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((WindowInsets) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(WindowInsets windowInsets1114) {
                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1114));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            final int i21111111111111117 = iM2388getEndERTFSPs;
            final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111115 = function2M2219getLambda1$material3_release;
            final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111116 = function2M2221getLambda3$material3_release;
            final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111117 = function2M2222getLambda4$material3_release;
            final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111118 = function2M2220getLambda2$material3_release;
            int i21111111111111118 = i14 >> 12;
            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i21111111111111119) {
                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                    if ((i21111111111111119 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1979205334, i21111111111111119, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                        }
                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111111117, function111111111111111111111111115, function6, function111111111111111111111111116, function111111111111111111111111117, mutableWindowInsets, function111111111111111111111111118, composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111111111111118 & 896) | 12582912 | (i21111111111111118 & 7168), 114);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            j4 = background;
            function10 = function2M2220getLambda2$material3_release;
            function11 = function2M2221getLambda3$material3_release;
            function12 = function2M2222getLambda4$material3_release;
            windowInsets2 = contentWindowInsets;
            j5 = j3;
            function7 = function2M2219getLambda1$material3_release;
            modifier2 = companion;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i2 & 1) == 0) {
                if (i18 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i19 != 0) {
                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                } else {
                    function2M2219getLambda1$material3_release = function7;
                }
                if (i5 != 0) {
                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                } else {
                    function2M2220getLambda2$material3_release = function8;
                }
                if (i7 != 0) {
                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                } else {
                    function2M2221getLambda3$material3_release = function4;
                }
                if (i9 != 0) {
                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                } else {
                    function2M2222getLambda4$material3_release = function9;
                }
                if (i11 != 0) {
                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                } else {
                    iM2388getEndERTFSPs = i;
                }
                if ((i3 & 64) != 0) {
                    i14 = i4 & (-3670017);
                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                } else {
                    i14 = i4;
                    background = j;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                    i14 &= -29360129;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -234881025;
                } else {
                    contentWindowInsets = windowInsets;
                }
            } else {
                if (i18 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i19 != 0) {
                    function2M2219getLambda1$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2219getLambda1$material3_release();
                } else {
                    function2M2219getLambda1$material3_release = function7;
                }
                if (i5 != 0) {
                    function2M2220getLambda2$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2220getLambda2$material3_release();
                } else {
                    function2M2220getLambda2$material3_release = function8;
                }
                if (i7 != 0) {
                    function2M2221getLambda3$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2221getLambda3$material3_release();
                } else {
                    function2M2221getLambda3$material3_release = function4;
                }
                if (i9 != 0) {
                    function2M2222getLambda4$material3_release = ComposableSingletons$ScaffoldKt.INSTANCE.m2222getLambda4$material3_release();
                } else {
                    function2M2222getLambda4$material3_release = function9;
                }
                if (i11 != 0) {
                    iM2388getEndERTFSPs = FabPosition.INSTANCE.m2388getEndERTFSPs();
                } else {
                    iM2388getEndERTFSPs = i;
                }
                if ((i3 & 64) != 0) {
                    i14 = i4 & (-3670017);
                    background = MaterialTheme.INSTANCE.getColorScheme(composerStartRestartGroup, 6).getBackground();
                } else {
                    i14 = i4;
                    background = j;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(background, composerStartRestartGroup, (i14 >> 18) & 14);
                    i14 &= -29360129;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    contentWindowInsets = ScaffoldDefaults.INSTANCE.getContentWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -234881025;
                } else {
                    contentWindowInsets = windowInsets;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1219521777, i14, -1, "androidx.compose.material3.Scaffold (Scaffold.kt:94)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794939901, "CC(remember):Scaffold.kt#9igjgp");
            i15 = (234881024 & i14) ^ 100663296;
            if (i15 > 67108864) {
                j3 = jM2173contentColorForek8zF_U;
                if ((i14 & 100663296) != 67108864) {
                    z = true;
                } else {
                    z = false;
                }
            } else {
                j3 = jM2173contentColorForek8zF_U;
                if ((i14 & 100663296) != 67108864) {
                    z = true;
                } else {
                    z = false;
                }
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = new MutableWindowInsets(contentWindowInsets);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableWindowInsets = (MutableWindowInsets) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1794934695, "CC(remember):Scaffold.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(mutableWindowInsets) | ((i15 <= 67108864 && composerStartRestartGroup.changed(contentWindowInsets)) || (100663296 & i14) == 67108864);
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((WindowInsets) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(WindowInsets windowInsets1114) {
                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1114));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            } else {
                objRememberedValue2 = (Function1) new Function1<WindowInsets, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((WindowInsets) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(WindowInsets windowInsets1114) {
                        mutableWindowInsets.setInsets(WindowInsetsKt.exclude(contentWindowInsets, windowInsets1114));
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            final int i21111111111111119 = iM2388getEndERTFSPs;
            final Function2<? super Composer, ? super Integer, Unit> function111111111111111111111111119 = function2M2219getLambda1$material3_release;
            final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111111110 = function2M2221getLambda3$material3_release;
            final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111111111 = function2M2222getLambda4$material3_release;
            final Function2<? super Composer, ? super Integer, Unit> function1111111111111111111111111112 = function2M2220getLambda2$material3_release;
            int i211111111111111110 = i14 >> 12;
            SurfaceKt.m2868SurfaceT9BRK9s(WindowInsetsPaddingKt.onConsumedWindowInsetsChanged(companion, (Function1) objRememberedValue2), null, background, j3, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1979205334, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i211111111111111111) {
                    ComposerKt.sourceInformation(composer2, "C105@5357L298:Scaffold.kt#uh7d8r");
                    if ((i211111111111111111 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1979205334, i211111111111111111, -1, "androidx.compose.material3.Scaffold.<anonymous> (Scaffold.kt:105)");
                        }
                        ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i21111111111111119, function111111111111111111111111119, function6, function1111111111111111111111111110, function1111111111111111111111111111, mutableWindowInsets, function1111111111111111111111111112, composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211111111111111110 & 896) | 12582912 | (i211111111111111110 & 7168), 114);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            j4 = background;
            function10 = function2M2220getLambda2$material3_release;
            function11 = function2M2221getLambda3$material3_release;
            function12 = function2M2222getLambda4$material3_release;
            windowInsets2 = contentWindowInsets;
            j5 = j3;
            function7 = function2M2219getLambda1$material3_release;
            modifier2 = companion;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier1114 = modifier2;
            final Function2<? super Composer, ? super Integer, Unit> function21111 = function7;
            final int i211111111111111111 = iM2388getEndERTFSPs;
            final long j1111118 = j4;
            final long j1111119 = j5;
            final WindowInsets windowInsets1114 = windowInsets2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i211111111111111112) {
                    ScaffoldKt.m2720ScaffoldTvnljyQ(modifier1114, function21111, function10, function11, function12, i211111111111111111, j1111118, j1111119, windowInsets1114, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), i3);
                }
            });
        }
    }

    public static final void m2721ScaffoldLayoutFMILGgc(final int i, final Function2<? super Composer, ? super Integer, Unit> function2, final Function3<? super PaddingValues, ? super Composer, ? super Integer, Unit> function3, final Function2<? super Composer, ? super Integer, Unit> function4, final Function2<? super Composer, ? super Integer, Unit> function5, final WindowInsets windowInsets, final Function2<? super Composer, ? super Integer, Unit> function6, Composer composer, final int i2) {
        int i3;
        Object obj;
        Composer composerStartRestartGroup = composer.startRestartGroup(-975511942);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ScaffoldLayout)P(4:c#material3.FabPosition,6,1,5,3,2)139@6582L6951,139@6565L6968:Scaffold.kt#uh7d8r");
        if ((i2 & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(i) ? 4 : 2) | i2;
        } else {
            i3 = i2;
        }
        if ((i2 & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function2) ? 32 : 16;
        }
        if ((i2 & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i2 & 3072) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function4) ? 2048 : Fields.RotationZ;
        }
        if ((i2 & 24576) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function5) ? Fields.Clip : Fields.Shape;
        }
        if ((196608 & i2) == 0) {
            i3 |= composerStartRestartGroup.changed(windowInsets) ? 131072 : 65536;
        }
        if ((i2 & 1572864) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function6) ? 1048576 : 524288;
        }
        if ((i3 & 599187) != 599186 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-975511942, i3, -1, "androidx.compose.material3.ScaffoldLayout (Scaffold.kt:138)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1690368138, "CC(remember):Scaffold.kt#9igjgp");
            boolean z = ((i3 & 112) == 32) | ((i3 & 7168) == 2048) | ((458752 & i3) == 131072) | ((57344 & i3) == 16384) | ((i3 & 14) == 4) | ((3670016 & i3) == 1048576) | ((i3 & 896) == 256);
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                obj = (Function2) new Function2<SubcomposeMeasureScope, Constraints, MeasureResult>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        return m2723invoke0kLqBqw((SubcomposeMeasureScope) obj2, ((Constraints) obj3).unbox-impl());
                    }

                    public final MeasureResult m2723invoke0kLqBqw(final SubcomposeMeasureScope subcomposeMeasureScope, long j) {
                        Object obj2;
                        Object obj3;
                        Object obj4;
                        FabPlacement fabPlacement;
                        Object obj5;
                        Integer numValueOf;
                        int i4;
                        int iIntValue;
                        int height;
                        int bottom;
                        Object obj6;
                        Object obj7;
                        int i5;
                        int i6;
                        final int i7 = Constraints.getMaxWidth-impl(j);
                        final int i8 = Constraints.getMaxHeight-impl(j);
                        long j2 = Constraints.copy-Zbe2FdA$default(j, 0, 0, 0, 0, 10, (Object) null);
                        List<Measurable> listSubcompose = subcomposeMeasureScope.subcompose(ScaffoldLayoutContent.TopBar, function2);
                        ArrayList arrayList = new ArrayList(listSubcompose.size());
                        int size = listSubcompose.size();
                        for (int i9 = 0; i9 < size; i9++) {
                            arrayList.add(listSubcompose.get(i9).mo6026measureBRTryo0(j2));
                        }
                        final ArrayList arrayList2 = arrayList;
                        if (!arrayList2.isEmpty()) {
                            obj2 = arrayList2.get(0);
                            int height2 = ((Placeable) obj2).getHeight();
                            int lastIndex = CollectionsKt.getLastIndex(arrayList2);
                            if (1 <= lastIndex) {
                                int i10 = 1;
                                while (true) {
                                    Object obj8 = arrayList2.get(i10);
                                    int height3 = ((Placeable) obj8).getHeight();
                                    if (height2 < height3) {
                                        obj2 = obj8;
                                        height2 = height3;
                                    }
                                    if (i10 == lastIndex) {
                                        break;
                                    }
                                    i10++;
                                }
                            }
                        } else {
                            obj2 = null;
                        }
                        Placeable placeable = (Placeable) obj2;
                        final int height4 = placeable != null ? placeable.getHeight() : 0;
                        List<Measurable> listSubcompose2 = subcomposeMeasureScope.subcompose(ScaffoldLayoutContent.Snackbar, function4);
                        WindowInsets windowInsets2 = windowInsets;
                        ArrayList arrayList3 = new ArrayList(listSubcompose2.size());
                        int size2 = listSubcompose2.size();
                        int i11 = 0;
                        while (i11 < size2) {
                            SubcomposeMeasureScope subcomposeMeasureScope2 = subcomposeMeasureScope;
                            arrayList3.add(listSubcompose2.get(i11).mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j2, (-windowInsets2.getLeft(subcomposeMeasureScope2, subcomposeMeasureScope.getLayoutDirection())) - windowInsets2.getRight(subcomposeMeasureScope2, subcomposeMeasureScope.getLayoutDirection()), -windowInsets2.getBottom(subcomposeMeasureScope2))));
                            i11++;
                            listSubcompose2 = listSubcompose2;
                        }
                        final ArrayList arrayList4 = arrayList3;
                        if (arrayList4.isEmpty()) {
                            obj3 = null;
                        } else {
                            obj3 = arrayList4.get(0);
                            int height5 = ((Placeable) obj3).getHeight();
                            int lastIndex2 = CollectionsKt.getLastIndex(arrayList4);
                            if (1 <= lastIndex2) {
                                Object obj9 = obj3;
                                int i12 = height5;
                                int i13 = 1;
                                while (true) {
                                    Object obj10 = arrayList4.get(i13);
                                    int height6 = ((Placeable) obj10).getHeight();
                                    if (i12 < height6) {
                                        obj9 = obj10;
                                        i12 = height6;
                                    }
                                    if (i13 == lastIndex2) {
                                        break;
                                    }
                                    i13++;
                                }
                                obj3 = obj9;
                            }
                        }
                        Placeable placeable2 = (Placeable) obj3;
                        int height7 = placeable2 != null ? placeable2.getHeight() : 0;
                        if (arrayList4.isEmpty()) {
                            obj4 = null;
                        } else {
                            obj4 = arrayList4.get(0);
                            int width = ((Placeable) obj4).getWidth();
                            int lastIndex3 = CollectionsKt.getLastIndex(arrayList4);
                            if (1 <= lastIndex3) {
                                Object obj11 = obj4;
                                int i14 = width;
                                int i15 = 1;
                                while (true) {
                                    Object obj12 = arrayList4.get(i15);
                                    int width2 = ((Placeable) obj12).getWidth();
                                    if (i14 < width2) {
                                        obj11 = obj12;
                                        i14 = width2;
                                    }
                                    if (i15 == lastIndex3) {
                                        break;
                                    }
                                    i15++;
                                }
                                obj4 = obj11;
                            }
                        }
                        Placeable placeable3 = (Placeable) obj4;
                        int width3 = placeable3 != null ? placeable3.getWidth() : 0;
                        List<Measurable> listSubcompose3 = subcomposeMeasureScope.subcompose(ScaffoldLayoutContent.Fab, function5);
                        WindowInsets windowInsets3 = windowInsets;
                        ArrayList arrayList5 = new ArrayList(listSubcompose3.size());
                        int size3 = listSubcompose3.size();
                        int i16 = 0;
                        while (i16 < size3) {
                            Measurable measurable = listSubcompose3.get(i16);
                            SubcomposeMeasureScope subcomposeMeasureScope3 = subcomposeMeasureScope;
                            List<Measurable> list = listSubcompose3;
                            int i17 = size3;
                            int right = (-windowInsets3.getLeft(subcomposeMeasureScope3, subcomposeMeasureScope.getLayoutDirection())) - windowInsets3.getRight(subcomposeMeasureScope3, subcomposeMeasureScope.getLayoutDirection());
                            int i18 = -windowInsets3.getBottom(subcomposeMeasureScope3);
                            WindowInsets windowInsets4 = windowInsets3;
                            Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(ConstraintsKt.offset-NN6Ew-U(j2, right, i18));
                            if (placeableMo6026measureBRTryo0.getHeight() == 0 || placeableMo6026measureBRTryo0.getWidth() == 0) {
                                placeableMo6026measureBRTryo0 = null;
                            }
                            if (placeableMo6026measureBRTryo0 != null) {
                                arrayList5.add(placeableMo6026measureBRTryo0);
                            }
                            i16++;
                            windowInsets3 = windowInsets4;
                            listSubcompose3 = list;
                            size3 = i17;
                        }
                        final ArrayList arrayList6 = arrayList5;
                        if (arrayList6.isEmpty()) {
                            fabPlacement = null;
                        } else {
                            if (arrayList6.isEmpty()) {
                                obj6 = null;
                            } else {
                                obj6 = arrayList6.get(0);
                                int width4 = ((Placeable) obj6).getWidth();
                                int lastIndex4 = CollectionsKt.getLastIndex(arrayList6);
                                if (1 <= lastIndex4) {
                                    Object obj13 = obj6;
                                    int i19 = width4;
                                    int i20 = 1;
                                    while (true) {
                                        Object obj14 = arrayList6.get(i20);
                                        int width5 = ((Placeable) obj14).getWidth();
                                        if (i19 < width5) {
                                            obj13 = obj14;
                                            i19 = width5;
                                        }
                                        if (i20 == lastIndex4) {
                                            break;
                                        }
                                        i20++;
                                    }
                                    obj6 = obj13;
                                }
                            }
                            Intrinsics.checkNotNull(obj6);
                            int width6 = ((Placeable) obj6).getWidth();
                            if (arrayList6.isEmpty()) {
                                obj7 = null;
                            } else {
                                obj7 = arrayList6.get(0);
                                int height8 = ((Placeable) obj7).getHeight();
                                int lastIndex5 = CollectionsKt.getLastIndex(arrayList6);
                                if (1 <= lastIndex5) {
                                    Object obj15 = obj7;
                                    int i21 = height8;
                                    int i22 = 1;
                                    while (true) {
                                        Object obj16 = arrayList6.get(i22);
                                        Object obj17 = obj15;
                                        int height9 = ((Placeable) obj16).getHeight();
                                        if (i21 < height9) {
                                            i21 = height9;
                                            obj15 = obj16;
                                        } else {
                                            obj15 = obj17;
                                        }
                                        if (i22 == lastIndex5) {
                                            break;
                                        }
                                        i22++;
                                    }
                                    obj7 = obj15;
                                }
                            }
                            Intrinsics.checkNotNull(obj7);
                            int height10 = ((Placeable) obj7).getHeight();
                            int i23 = i;
                            if (FabPosition.m2383equalsimpl0(i23, FabPosition.INSTANCE.m2390getStartERTFSPs())) {
                                if (subcomposeMeasureScope.getLayoutDirection() == LayoutDirection.Ltr) {
                                    i5 = subcomposeMeasureScope.roundToPx-0680j_4(ScaffoldKt.FabSpacing);
                                } else {
                                    i6 = subcomposeMeasureScope.roundToPx-0680j_4(ScaffoldKt.FabSpacing);
                                    i5 = (i7 - i6) - width6;
                                }
                            } else if (FabPosition.m2383equalsimpl0(i23, FabPosition.INSTANCE.m2388getEndERTFSPs()) ? true : FabPosition.m2383equalsimpl0(i23, FabPosition.INSTANCE.m2389getEndOverlayERTFSPs())) {
                                if (subcomposeMeasureScope.getLayoutDirection() == LayoutDirection.Ltr) {
                                    i6 = subcomposeMeasureScope.roundToPx-0680j_4(ScaffoldKt.FabSpacing);
                                    i5 = (i7 - i6) - width6;
                                } else {
                                    i5 = subcomposeMeasureScope.roundToPx-0680j_4(ScaffoldKt.FabSpacing);
                                }
                            } else {
                                i5 = (i7 - width6) / 2;
                            }
                            fabPlacement = new FabPlacement(i5, width6, height10);
                        }
                        ScaffoldLayoutContent scaffoldLayoutContent = ScaffoldLayoutContent.BottomBar;
                        final Function2<Composer, Integer, Unit> function7 = function6;
                        List<Measurable> listSubcompose4 = subcomposeMeasureScope.subcompose(scaffoldLayoutContent, ComposableLambdaKt.composableLambdaInstance(-2146438447, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj18, Object obj19) {
                                invoke((Composer) obj18, ((Number) obj19).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i24) {
                                ComposerKt.sourceInformation(composer2, "C209@10015L11:Scaffold.kt#uh7d8r");
                                if ((i24 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-2146438447, i24, -1, "androidx.compose.material3.ScaffoldLayout.<anonymous>.<anonymous>.<anonymous> (Scaffold.kt:209)");
                                }
                                function7.invoke(composer2, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        ArrayList arrayList7 = new ArrayList(listSubcompose4.size());
                        int size4 = listSubcompose4.size();
                        for (int i24 = 0; i24 < size4; i24++) {
                            arrayList7.add(listSubcompose4.get(i24).mo6026measureBRTryo0(j2));
                        }
                        final ArrayList arrayList8 = arrayList7;
                        if (!arrayList8.isEmpty()) {
                            obj5 = arrayList8.get(0);
                            int height11 = ((Placeable) obj5).getHeight();
                            int lastIndex6 = CollectionsKt.getLastIndex(arrayList8);
                            if (1 <= lastIndex6) {
                                int i25 = 1;
                                while (true) {
                                    Object obj18 = arrayList8.get(i25);
                                    int height12 = ((Placeable) obj18).getHeight();
                                    if (height11 < height12) {
                                        height11 = height12;
                                        obj5 = obj18;
                                    }
                                    if (i25 == lastIndex6) {
                                        break;
                                    }
                                    i25++;
                                }
                            }
                        } else {
                            obj5 = null;
                        }
                        Placeable placeable4 = (Placeable) obj5;
                        Integer numValueOf2 = placeable4 != null ? Integer.valueOf(placeable4.getHeight()) : null;
                        if (fabPlacement != null) {
                            int i26 = i;
                            WindowInsets windowInsets5 = windowInsets;
                            if (numValueOf2 == null || FabPosition.m2383equalsimpl0(i26, FabPosition.INSTANCE.m2389getEndOverlayERTFSPs())) {
                                height = fabPlacement.getHeight() + subcomposeMeasureScope.roundToPx-0680j_4(ScaffoldKt.FabSpacing);
                                bottom = windowInsets5.getBottom(subcomposeMeasureScope);
                            } else {
                                height = numValueOf2.intValue() + fabPlacement.getHeight();
                                bottom = subcomposeMeasureScope.roundToPx-0680j_4(ScaffoldKt.FabSpacing);
                            }
                            numValueOf = Integer.valueOf(height + bottom);
                        } else {
                            numValueOf = null;
                        }
                        if (height7 != 0) {
                            if (numValueOf != null) {
                                iIntValue = numValueOf.intValue();
                            } else {
                                iIntValue = numValueOf2 != null ? numValueOf2.intValue() : windowInsets.getBottom(subcomposeMeasureScope);
                            }
                            i4 = height7 + iIntValue;
                        } else {
                            i4 = 0;
                        }
                        ScaffoldLayoutContent scaffoldLayoutContent2 = ScaffoldLayoutContent.MainContent;
                        final WindowInsets windowInsets6 = windowInsets;
                        final Function3<PaddingValues, Composer, Integer, Unit> function8 = function3;
                        final int i27 = width3;
                        final Integer num = numValueOf2;
                        List<Measurable> listSubcompose5 = subcomposeMeasureScope.subcompose(scaffoldLayoutContent2, ComposableLambdaKt.composableLambdaInstance(-1213360416, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj19, Object obj20) {
                                invoke((Composer) obj19, ((Number) obj20).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i28) {
                                float top;
                                float bottom2;
                                Integer num2;
                                ComposerKt.sourceInformation(composer2, "C260@12377L21:Scaffold.kt#uh7d8r");
                                if ((i28 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1213360416, i28, -1, "androidx.compose.material3.ScaffoldLayout.<anonymous>.<anonymous>.<anonymous> (Scaffold.kt:238)");
                                    }
                                    PaddingValues paddingValuesAsPaddingValues = WindowInsetsKt.asPaddingValues(windowInsets6, subcomposeMeasureScope);
                                    if (arrayList2.isEmpty()) {
                                        top = paddingValuesAsPaddingValues.getTop();
                                    } else {
                                        top = subcomposeMeasureScope.toDp-u2uoSUM(height4);
                                    }
                                    if (arrayList8.isEmpty() || (num2 = num) == null) {
                                        bottom2 = paddingValuesAsPaddingValues.getBottom();
                                    } else {
                                        bottom2 = subcomposeMeasureScope.toDp-u2uoSUM(num2.intValue());
                                    }
                                    function8.invoke(PaddingKt.m1031PaddingValuesa9UjIt4(PaddingKt.calculateStartPadding(paddingValuesAsPaddingValues, subcomposeMeasureScope.getLayoutDirection()), top, PaddingKt.calculateEndPadding(paddingValuesAsPaddingValues, subcomposeMeasureScope.getLayoutDirection()), bottom2), composer2, 0);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }));
                        ArrayList arrayList9 = new ArrayList(listSubcompose5.size());
                        int size5 = listSubcompose5.size();
                        for (int i28 = 0; i28 < size5; i28++) {
                            arrayList9.add(listSubcompose5.get(i28).mo6026measureBRTryo0(j2));
                        }
                        final ArrayList arrayList10 = arrayList9;
                        final WindowInsets windowInsets7 = windowInsets;
                        final FabPlacement fabPlacement2 = fabPlacement;
                        final int i29 = i4;
                        final Integer num2 = numValueOf2;
                        final Integer num3 = numValueOf;
                        return MeasureScope.CC.layout$default(subcomposeMeasureScope, i7, i8, null, new Function1<Placeable.PlacementScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj19) {
                                invoke((Placeable.PlacementScope) obj19);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Placeable.PlacementScope placementScope) {
                                List<Placeable> list2 = arrayList10;
                                int size6 = list2.size();
                                for (int i30 = 0; i30 < size6; i30++) {
                                    Placeable.PlacementScope.place$default(placementScope, list2.get(i30), 0, 0, 0.0f, 4, null);
                                }
                                List<Placeable> list3 = arrayList2;
                                int size7 = list3.size();
                                for (int i31 = 0; i31 < size7; i31++) {
                                    Placeable.PlacementScope.place$default(placementScope, list3.get(i31), 0, 0, 0.0f, 4, null);
                                }
                                List<Placeable> list4 = arrayList4;
                                int i32 = i7;
                                int i33 = i27;
                                WindowInsets windowInsets8 = windowInsets7;
                                SubcomposeMeasureScope subcomposeMeasureScope4 = subcomposeMeasureScope;
                                int i34 = i8;
                                int i35 = i29;
                                int size8 = list4.size();
                                for (int i36 = 0; i36 < size8; i36++) {
                                    Placeable.PlacementScope.place$default(placementScope, list4.get(i36), ((i32 - i33) / 2) + windowInsets8.getLeft(subcomposeMeasureScope4, subcomposeMeasureScope4.getLayoutDirection()), i34 - i35, 0.0f, 4, null);
                                }
                                List<Placeable> list5 = arrayList8;
                                int i37 = i8;
                                Integer num4 = num2;
                                int size9 = list5.size();
                                for (int i38 = 0; i38 < size9; i38++) {
                                    Placeable.PlacementScope.place$default(placementScope, list5.get(i38), 0, i37 - (num4 != null ? num4.intValue() : 0), 0.0f, 4, null);
                                }
                                FabPlacement fabPlacement3 = fabPlacement2;
                                if (fabPlacement3 != null) {
                                    List<Placeable> list6 = arrayList6;
                                    int i39 = i8;
                                    Integer num5 = num3;
                                    int size10 = list6.size();
                                    for (int i40 = 0; i40 < size10; i40++) {
                                        Placeable placeable5 = list6.get(i40);
                                        int left = fabPlacement3.getLeft();
                                        Intrinsics.checkNotNull(num5);
                                        Placeable.PlacementScope.place$default(placementScope, placeable5, left, i39 - num5.intValue(), 0.0f, 4, null);
                                    }
                                }
                            }
                        }, 4, null);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(obj);
            } else {
                obj = objRememberedValue;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            SubcomposeLayoutKt.SubcomposeLayout(null, (Function2) obj, composerStartRestartGroup, 0, 1);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        } else {
            composerStartRestartGroup.skipToGroupEnd();
        }
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    ScaffoldKt.m2721ScaffoldLayoutFMILGgc(i, function2, function3, function4, function5, windowInsets, function6, composer2, RecomposeScopeImplKt.updateChangedFlags(i2 | 1));
                }
            });
        }
    }
}
