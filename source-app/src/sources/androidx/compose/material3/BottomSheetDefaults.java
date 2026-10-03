package androidx.compose.material3;

import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsetsKt;
import androidx.compose.foundation.layout.WindowInsetsSides;
import androidx.compose.foundation.layout.WindowInsets_androidKt;
import androidx.compose.material3.internal.Strings;
import androidx.compose.material3.internal.Strings_androidKt;
import androidx.compose.material3.tokens.ScrimTokens;
import androidx.compose.material3.tokens.SheetBottomTokens;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002JD\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001f2\b\b\u0002\u0010 \u001a\u00020\b2\b\b\u0002\u0010!\u001a\u00020\b2\b\b\u0002\u0010\"\u001a\u00020\r2\b\b\u0002\u0010#\u001a\u00020\u0004H\u0007ø\u0001\u0000¢\u0006\u0004\b$\u0010%R\u0017\u0010\u0003\u001a\u00020\u00048Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\u0007\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\nR\u0011\u0010\f\u001a\u00020\r8G¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0010\u001a\u00020\r8G¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u000fR\u0017\u0010\u0012\u001a\u00020\u00048Gø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0006R\u0019\u0010\u0014\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\u0015\u0010\nR\u0019\u0010\u0016\u001a\u00020\bø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\u0017\u0010\nR\u0011\u0010\u0018\u001a\u00020\u00198G¢\u0006\u0006\u001a\u0004\b\u001a\u0010\u001b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006&"}, d2 = {"Landroidx/compose/material3/BottomSheetDefaults;", "", "()V", "ContainerColor", "Landroidx/compose/ui/graphics/Color;", "getContainerColor", "(Landroidx/compose/runtime/Composer;I)J", "Elevation", "Landroidx/compose/ui/unit/Dp;", "getElevation-D9Ej5fM", "()F", "F", "ExpandedShape", "Landroidx/compose/ui/graphics/Shape;", "getExpandedShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/Shape;", "HiddenShape", "getHiddenShape", "ScrimColor", "getScrimColor", "SheetMaxWidth", "getSheetMaxWidth-D9Ej5fM", "SheetPeekHeight", "getSheetPeekHeight-D9Ej5fM", "windowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "getWindowInsets", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/layout/WindowInsets;", "DragHandle", "", "modifier", "Landroidx/compose/ui/Modifier;", "width", "height", "shape", "color", "DragHandle-lgZ2HuY", "(Landroidx/compose/ui/Modifier;FFLandroidx/compose/ui/graphics/Shape;JLandroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class BottomSheetDefaults {
    public static final int $stable = 0;
    public static final BottomSheetDefaults INSTANCE = new BottomSheetDefaults();
    private static final float Elevation = SheetBottomTokens.INSTANCE.m3848getDockedModalContainerElevationD9Ej5fM();
    private static final float SheetPeekHeight = Dp.constructor-impl(56);
    private static final float SheetMaxWidth = Dp.constructor-impl(640);

    private BottomSheetDefaults() {
    }

    public final Shape getHiddenShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1971658024, "C291@11425L5:SheetDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1971658024, i, -1, "androidx.compose.material3.BottomSheetDefaults.<get-HiddenShape> (SheetDefaults.kt:291)");
        }
        Shape value = ShapesKt.getValue(SheetBottomTokens.INSTANCE.getDockedMinimizedContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final Shape getExpandedShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1683783414, "C295@11623L5:SheetDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1683783414, i, -1, "androidx.compose.material3.BottomSheetDefaults.<get-ExpandedShape> (SheetDefaults.kt:295)");
        }
        Shape value = ShapesKt.getValue(SheetBottomTokens.INSTANCE.getDockedContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final long getContainerColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 433375448, "C299@11786L5:SheetDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(433375448, i, -1, "androidx.compose.material3.BottomSheetDefaults.<get-ContainerColor> (SheetDefaults.kt:299)");
        }
        long value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedContainerColor(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final float m2029getElevationD9Ej5fM() {
        return Elevation;
    }

    public final long getScrimColor(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -2040719176, "C306@12070L5:SheetDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2040719176, i, -1, "androidx.compose.material3.BottomSheetDefaults.<get-ScrimColor> (SheetDefaults.kt:306)");
        }
        long jM4589copywmQWz5c$default = Color.m4589copywmQWz5c$default(ColorSchemeKt.getValue(ScrimTokens.INSTANCE.getContainerColor(), composer, 6), 0.32f, 0.0f, 0.0f, 0.0f, 14, null);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return jM4589copywmQWz5c$default;
    }

    public final float m2031getSheetPeekHeightD9Ej5fM() {
        return SheetPeekHeight;
    }

    public final float m2030getSheetMaxWidthD9Ej5fM() {
        return SheetMaxWidth;
    }

    public final WindowInsets getWindowInsets(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -511309409, "C316@12492L11:SheetDefaults.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-511309409, i, -1, "androidx.compose.material3.BottomSheetDefaults.<get-windowInsets> (SheetDefaults.kt:316)");
        }
        WindowInsets windowInsetsM1106onlybOOhFvg = WindowInsetsKt.m1106onlybOOhFvg(WindowInsets_androidKt.getSafeDrawing(WindowInsets.INSTANCE, composer, 6), WindowInsetsSides.INSTANCE.m1125getBottomJoeWqyM());
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return windowInsetsM1106onlybOOhFvg;
    }

    public final void m2028DragHandlelgZ2HuY(Modifier modifier, float f, float f2, Shape shape, long j, Composer composer, final int i, final int i2) {
        Modifier modifier2;
        int i3;
        final float fM3847getDockedDragHandleWidthD9Ej5fM;
        int i4;
        float fM3846getDockedDragHandleHeightD9Ej5fM;
        int i5;
        Shape extraLarge;
        long value;
        final Modifier.Companion companion;
        int i6;
        final String strM3334getString2EP1pXo;
        boolean zChanged;
        Object objRememberedValue;
        final Shape shape2;
        final float f3;
        final float f4;
        final long j2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i7;
        int i8;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1364277227);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DragHandle)P(2,4:c#ui.unit.Dp,1:c#ui.unit.Dp,3,0:c#ui.graphics.Color)324@12873L6,325@12955L5,327@13006L51,330@13179L82,335@13326L74,328@13066L334:SheetDefaults.kt#uh7d8r");
        int i9 = i2 & 1;
        if (i9 != 0) {
            i3 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i3 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i3 = i;
        }
        int i10 = i2 & 2;
        if (i10 == 0) {
            if ((i & 48) == 0) {
                fM3847getDockedDragHandleWidthD9Ej5fM = f;
                i3 |= composerStartRestartGroup.changed(fM3847getDockedDragHandleWidthD9Ej5fM) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    fM3846getDockedDragHandleHeightD9Ej5fM = f2;
                    if (composerStartRestartGroup.changed(fM3846getDockedDragHandleHeightD9Ej5fM)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        extraLarge = shape;
                        if (composerStartRestartGroup.changed(extraLarge)) {
                            i8 = Fields.CameraDistance;
                        }
                        i3 |= i8;
                    } else {
                        extraLarge = shape;
                    }
                    i8 = Fields.RotationZ;
                    i3 |= i8;
                } else {
                    extraLarge = shape;
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        value = j;
                        if (composerStartRestartGroup.changed(value)) {
                            i7 = Fields.Clip;
                        }
                        i3 |= i7;
                    } else {
                        value = j;
                    }
                    i7 = Fields.Shape;
                    i3 |= i7;
                } else {
                    value = j;
                }
                if ((i3 & 9363) == 9362 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i9 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i10 != 0) {
                            fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                        }
                        if (i4 != 0) {
                            fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                        }
                        if ((i2 & 16) != 0) {
                            value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                            i3 &= -57345;
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                        }
                        companion = modifier2;
                    }
                    i6 = i3;
                    final float f5 = fM3846getDockedDragHandleHeightD9Ej5fM;
                    Shape shape3 = extraLarge;
                    long j3 = value;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
                    }
                    Strings.Companion companion2 = Strings.INSTANCE;
                    strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
                    Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) {
                                invoke((SemanticsPropertyReceiver) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i11 = i6 >> 6;
                    SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default, false, (Function1) objRememberedValue, 1, null), shape3, j3, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i12) {
                            ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                            if ((i12 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1039573072, i12, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                            }
                            BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f5), composer2, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11 & 112) | 12582912 | (i11 & 896), MenuKt.InTransitionDuration);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    shape2 = shape3;
                    f3 = f5;
                    f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
                    j2 = j3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    companion = modifier2;
                    f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
                    f3 = fM3846getDockedDragHandleHeightD9Ej5fM;
                    shape2 = extraLarge;
                    j2 = value;
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

                        public final void invoke(Composer composer2, int i12) {
                            this.$tmp1_rcvr.m2028DragHandlelgZ2HuY(companion, f4, f3, shape2, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            fM3846getDockedDragHandleHeightD9Ej5fM = f2;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    extraLarge = shape;
                    if (composerStartRestartGroup.changed(extraLarge)) {
                        i8 = Fields.CameraDistance;
                    }
                    i3 |= i8;
                } else {
                    extraLarge = shape;
                }
                i8 = Fields.RotationZ;
                i3 |= i8;
            } else {
                extraLarge = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    value = j;
                    if (composerStartRestartGroup.changed(value)) {
                        i7 = Fields.Clip;
                    }
                    i3 |= i7;
                } else {
                    value = j;
                }
                i7 = Fields.Shape;
                i3 |= i7;
            } else {
                value = j;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                }
                i6 = i3;
                final float f6 = fM3846getDockedDragHandleHeightD9Ej5fM;
                Shape shape4 = extraLarge;
                long j4 = value;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
                }
                Strings.Companion companion3 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
                Modifier modifierM1037paddingVpY3zN4$default2 = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i12 = i6 >> 6;
                SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default2, false, (Function1) objRememberedValue, 1, null), shape4, j4, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i13) {
                        ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                        if ((i13 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1039573072, i13, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                        }
                        BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f6), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i12 & 112) | 12582912 | (i12 & 896), MenuKt.InTransitionDuration);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape2 = shape4;
                f3 = f6;
                f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
                j2 = j4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                }
                i6 = i3;
                final float f7 = fM3846getDockedDragHandleHeightD9Ej5fM;
                Shape shape5 = extraLarge;
                long j5 = value;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
                }
                Strings.Companion companion4 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
                Modifier modifierM1037paddingVpY3zN4$default3 = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i13 = i6 >> 6;
                SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default3, false, (Function1) objRememberedValue, 1, null), shape5, j5, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                        if ((i14 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1039573072, i14, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                        }
                        BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f7), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i13 & 112) | 12582912 | (i13 & 896), MenuKt.InTransitionDuration);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape2 = shape5;
                f3 = f7;
                f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
                j2 = j5;
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

                    public final void invoke(Composer composer2, int i14) {
                        this.$tmp1_rcvr.m2028DragHandlelgZ2HuY(companion, f4, f3, shape2, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        fM3847getDockedDragHandleWidthD9Ej5fM = f;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                fM3846getDockedDragHandleHeightD9Ej5fM = f2;
                if (composerStartRestartGroup.changed(fM3846getDockedDragHandleHeightD9Ej5fM)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    extraLarge = shape;
                    if (composerStartRestartGroup.changed(extraLarge)) {
                        i8 = Fields.CameraDistance;
                    }
                    i3 |= i8;
                } else {
                    extraLarge = shape;
                }
                i8 = Fields.RotationZ;
                i3 |= i8;
            } else {
                extraLarge = shape;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    value = j;
                    if (composerStartRestartGroup.changed(value)) {
                        i7 = Fields.Clip;
                    }
                    i3 |= i7;
                } else {
                    value = j;
                }
                i7 = Fields.Shape;
                i3 |= i7;
            } else {
                value = j;
            }
            if ((i3 & 9363) == 9362) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                }
                i6 = i3;
                final float f8 = fM3846getDockedDragHandleHeightD9Ej5fM;
                Shape shape6 = extraLarge;
                long j6 = value;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
                }
                Strings.Companion companion5 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
                Modifier modifierM1037paddingVpY3zN4$default4 = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i14 = i6 >> 6;
                SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default4, false, (Function1) objRememberedValue, 1, null), shape6, j6, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                        if ((i15 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1039573072, i15, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                        }
                        BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f8), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i14 & 112) | 12582912 | (i14 & 896), MenuKt.InTransitionDuration);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape2 = shape6;
                f3 = f8;
                f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
                j2 = j6;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                } else {
                    if (i9 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i10 != 0) {
                        fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                    }
                    if (i4 != 0) {
                        fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                    }
                    if ((i2 & 16) != 0) {
                        value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                        i3 &= -57345;
                    }
                }
                i6 = i3;
                final float f9 = fM3846getDockedDragHandleHeightD9Ej5fM;
                Shape shape7 = extraLarge;
                long j7 = value;
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
                }
                Strings.Companion companion6 = Strings.INSTANCE;
                strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
                Modifier modifierM1037paddingVpY3zN4$default5 = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i15 = i6 >> 6;
                SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default5, false, (Function1) objRememberedValue, 1, null), shape7, j7, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                        if ((i16 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1039573072, i16, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                        }
                        BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f9), composer2, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i15 & 112) | 12582912 | (i15 & 896), MenuKt.InTransitionDuration);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                shape2 = shape7;
                f3 = f9;
                f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
                j2 = j7;
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

                    public final void invoke(Composer composer2, int i16) {
                        this.$tmp1_rcvr.m2028DragHandlelgZ2HuY(companion, f4, f3, shape2, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        fM3846getDockedDragHandleHeightD9Ej5fM = f2;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                extraLarge = shape;
                if (composerStartRestartGroup.changed(extraLarge)) {
                    i8 = Fields.CameraDistance;
                }
                i3 |= i8;
            } else {
                extraLarge = shape;
            }
            i8 = Fields.RotationZ;
            i3 |= i8;
        } else {
            extraLarge = shape;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                value = j;
                if (composerStartRestartGroup.changed(value)) {
                    i7 = Fields.Clip;
                }
                i3 |= i7;
            } else {
                value = j;
            }
            i7 = Fields.Shape;
            i3 |= i7;
        } else {
            value = j;
        }
        if ((i3 & 9363) == 9362) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                }
                if (i4 != 0) {
                    fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                }
                if ((i2 & 16) != 0) {
                    value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                }
                if (i4 != 0) {
                    fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                }
                if ((i2 & 16) != 0) {
                    value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
            }
            i6 = i3;
            final float f10 = fM3846getDockedDragHandleHeightD9Ej5fM;
            Shape shape8 = extraLarge;
            long j8 = value;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
            }
            Strings.Companion companion7 = Strings.INSTANCE;
            strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
            Modifier modifierM1037paddingVpY3zN4$default6 = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i16 = i6 >> 6;
            SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default6, false, (Function1) objRememberedValue, 1, null), shape8, j8, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i17) {
                    ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                    if ((i17 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1039573072, i17, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                    }
                    BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f10), composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i16 & 112) | 12582912 | (i16 & 896), MenuKt.InTransitionDuration);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            shape2 = shape8;
            f3 = f10;
            f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
            j2 = j8;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                }
                if (i4 != 0) {
                    fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                }
                if ((i2 & 16) != 0) {
                    value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
            } else {
                if (i9 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i10 != 0) {
                    fM3847getDockedDragHandleWidthD9Ej5fM = SheetBottomTokens.INSTANCE.m3847getDockedDragHandleWidthD9Ej5fM();
                }
                if (i4 != 0) {
                    fM3846getDockedDragHandleHeightD9Ej5fM = SheetBottomTokens.INSTANCE.m3846getDockedDragHandleHeightD9Ej5fM();
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    extraLarge = MaterialTheme.INSTANCE.getShapes(composerStartRestartGroup, 6).getExtraLarge();
                }
                if ((i2 & 16) != 0) {
                    value = ColorSchemeKt.getValue(SheetBottomTokens.INSTANCE.getDockedDragHandleColor(), composerStartRestartGroup, 6);
                    i3 &= -57345;
                }
            }
            i6 = i3;
            final float f11 = fM3846getDockedDragHandleHeightD9Ej5fM;
            Shape shape9 = extraLarge;
            long j9 = value;
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1364277227, i6, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle (SheetDefaults.kt:326)");
            }
            Strings.Companion companion8 = Strings.INSTANCE;
            strM3334getString2EP1pXo = Strings_androidKt.m3334getString2EP1pXo(Strings.m3264constructorimpl(C1305R.string.m3c_bottom_sheet_drag_handle_description), composerStartRestartGroup, 0);
            Modifier modifierM1037paddingVpY3zN4$default7 = PaddingKt.m1037paddingVpY3zN4$default(companion, 0.0f, SheetDefaultsKt.DragHandleVerticalPadding, 1, null);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1620989881, "CC(remember):SheetDefaults.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(strM3334getString2EP1pXo);
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = (Function1) new Function1<SemanticsPropertyReceiver, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.setContentDescription(semanticsPropertyReceiver, strM3334getString2EP1pXo);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i17 = i6 >> 6;
            SurfaceKt.m2868SurfaceT9BRK9s(SemanticsModifierKt.semantics$default(modifierM1037paddingVpY3zN4$default7, false, (Function1) objRememberedValue, 1, null), shape9, j9, 0L, 0.0f, 0.0f, null, ComposableLambdaKt.rememberComposableLambda(-1039573072, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i18) {
                    ComposerKt.sourceInformation(composer2, "C336@13340L50:SheetDefaults.kt#uh7d8r");
                    if ((i18 & 3) == 2 && composer2.getSkipping()) {
                        composer2.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1039573072, i18, -1, "androidx.compose.material3.BottomSheetDefaults.DragHandle.<anonymous> (SheetDefaults.kt:336)");
                    }
                    BoxKt.Box(SizeKt.m1082sizeVpY3zN4(Modifier.INSTANCE, fM3847getDockedDragHandleWidthD9Ej5fM, f11), composer2, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i17 & 112) | 12582912 | (i17 & 896), MenuKt.InTransitionDuration);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            shape2 = shape9;
            f3 = f11;
            f4 = fM3847getDockedDragHandleWidthD9Ej5fM;
            j2 = j9;
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

                public final void invoke(Composer composer2, int i18) {
                    this.$tmp1_rcvr.m2028DragHandlelgZ2HuY(companion, f4, f3, shape2, j2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
