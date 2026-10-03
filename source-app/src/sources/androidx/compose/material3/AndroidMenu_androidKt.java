package androidx.compose.material3;

import androidx.compose.animation.core.MutableTransitionState;
import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.ScrollKt;
import androidx.compose.foundation.ScrollState;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.material3.internal.DropdownMenuPositionProvider;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.TransformOrigin;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.DpKt;
import androidx.compose.ui.unit.IntRect;
import androidx.compose.ui.window.AndroidPopup_androidKt;
import androidx.compose.ui.window.PopupProperties;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001an\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00012\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00050\u0012¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\u0017\u001a¢\u0001\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00012\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001d2\n\b\u0002\u0010\u001f\u001a\u0004\u0018\u00010 2\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00050\u0012¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b!\u0010\"\u001ad\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00050\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u0010\u001a\u00020\u00012\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\u00050\u0012¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b#\u0010$\u001a\u0090\u0001\u0010%\u001a\u00020\u00052\u0011\u0010&\u001a\r\u0012\u0004\u0012\u00020\u00050\t¢\u0006\u0002\b\u00142\f\u0010'\u001a\b\u0012\u0004\u0012\u00020\u00050\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\u0015\b\u0002\u0010(\u001a\u000f\u0012\u0004\u0012\u00020\u0005\u0018\u00010\t¢\u0006\u0002\b\u00142\u0015\b\u0002\u0010)\u001a\u000f\u0012\u0004\u0012\u00020\u0005\u0018\u00010\t¢\u0006\u0002\b\u00142\b\b\u0002\u0010*\u001a\u00020\u00072\b\b\u0002\u0010+\u001a\u00020,2\b\b\u0002\u0010-\u001a\u00020.2\n\b\u0002\u0010/\u001a\u0004\u0018\u000100H\u0007¢\u0006\u0002\u00101\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0003\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00062"}, d2 = {"DefaultMenuProperties", "Landroidx/compose/ui/window/PopupProperties;", "getDefaultMenuProperties", "()Landroidx/compose/ui/window/PopupProperties;", "DropdownMenu", "", "expanded", "", "onDismissRequest", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "offset", "Landroidx/compose/ui/unit/DpOffset;", "scrollState", "Landroidx/compose/foundation/ScrollState;", "properties", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/ColumnScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "DropdownMenu-4kj-_NE", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JLandroidx/compose/foundation/ScrollState;Landroidx/compose/ui/window/PopupProperties;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "shape", "Landroidx/compose/ui/graphics/Shape;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "tonalElevation", "Landroidx/compose/ui/unit/Dp;", "shadowElevation", "border", "Landroidx/compose/foundation/BorderStroke;", "DropdownMenu-IlH_yew", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JLandroidx/compose/foundation/ScrollState;Landroidx/compose/ui/window/PopupProperties;Landroidx/compose/ui/graphics/Shape;JFFLandroidx/compose/foundation/BorderStroke;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;III)V", "DropdownMenu-ILWXrKs", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;JLandroidx/compose/ui/window/PopupProperties;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "DropdownMenuItem", "text", "onClick", "leadingIcon", "trailingIcon", "enabled", "colors", "Landroidx/compose/material3/MenuItemColors;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;ZLandroidx/compose/material3/MenuItemColors;Landroidx/compose/foundation/layout/PaddingValues;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class AndroidMenu_androidKt {
    private static final PopupProperties DefaultMenuProperties = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);

    public static final void m1995DropdownMenuIlH_yew(final boolean z, final Function0<Unit> function0, Modifier modifier, long j, ScrollState scrollState, PopupProperties popupProperties, Shape shape, long j2, float f, float f2, BorderStroke borderStroke, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        int i5;
        Modifier modifier2;
        int i6;
        int i7;
        int i8;
        int i9;
        PopupProperties popupProperties2;
        int i10;
        Shape shape2;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        int i19;
        Modifier.Companion companion;
        long j3;
        ScrollState scrollStateRememberScrollState;
        PopupProperties popupProperties3;
        Shape shape3;
        long containerColor;
        float fM2514getTonalElevationD9Ej5fM;
        float fM2513getShadowElevationD9Ej5fM;
        BorderStroke borderStroke2;
        Object objRememberedValue;
        final MutableTransitionState mutableTransitionState;
        Object objRememberedValue2;
        final MutableState mutableState;
        final BorderStroke borderStroke3;
        Density density;
        boolean z2;
        boolean zChanged;
        Object objRememberedValue3;
        final PopupProperties popupProperties4;
        final Modifier modifier3;
        final Shape shape4;
        final ScrollState scrollState2;
        final BorderStroke borderStroke4;
        final float f3;
        final float f4;
        final long j4;
        final long j5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i20;
        int i21;
        Composer composerStartRestartGroup = composer.startRestartGroup(1431928300);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DropdownMenu)P(3,6,4,5:c#ui.unit.DpOffset,8,7,10,1:c#ui.graphics.Color,11:c#ui.unit.Dp,9:c#ui.unit.Dp)182@6555L21,185@6667L5,187@6715L14,55@2073L42,59@2260L51,60@2347L7,62@2403L251,72@2825L494,68@2664L655:AndroidMenu.android.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        if ((i3 & 2) == 0) {
            if ((i & 48) == 0) {
                i4 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
            }
            i5 = i3 & 4;
            if (i5 != 0) {
                if ((i & 384) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i6 = Fields.RotationX;
                    } else {
                        i6 = Fields.SpotShadowColor;
                    }
                    i4 |= i6;
                }
                i7 = i3 & 8;
                if (i7 != 0) {
                    i4 |= 3072;
                } else if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(j)) {
                        i8 = Fields.CameraDistance;
                    } else {
                        i8 = Fields.RotationZ;
                    }
                    i4 |= i8;
                }
                if ((i & 24576) != 0) {
                    i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.Shape : Fields.Clip;
                }
                i9 = i3 & 32;
                if (i9 != 0) {
                    i4 |= 196608;
                    popupProperties2 = popupProperties;
                } else {
                    popupProperties2 = popupProperties;
                    if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changed(popupProperties2)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i4 |= i10;
                    }
                }
                if ((i & 1572864) == 0) {
                    shape2 = shape;
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(shape2)) {
                        i21 = 524288;
                    } else {
                        i21 = 1048576;
                    }
                    i4 |= i21;
                } else {
                    shape2 = shape;
                }
                if ((i & 12582912) != 0) {
                    if ((i3 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(j2)) {
                        i20 = 4194304;
                    } else {
                        i20 = 8388608;
                    }
                    i4 |= i20;
                }
                i11 = i3 & Fields.RotationX;
                if (i11 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i12 = 67108864;
                    } else {
                        i12 = 33554432;
                    }
                    i4 |= i12;
                }
                i13 = i3 & Fields.RotationY;
                if (i13 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i4 |= i14;
                }
                i15 = i3 & Fields.RotationZ;
                if (i15 != 0) {
                    i16 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changed(borderStroke)) {
                        i17 = 4;
                    } else {
                        i17 = 2;
                    }
                    i16 = i2 | i17;
                } else {
                    i16 = i2;
                }
                if ((i3 & Fields.CameraDistance) != 0) {
                    i16 |= 48;
                } else if ((i2 & 48) != 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i18 = 32;
                    } else {
                        i18 = 16;
                    }
                    i16 |= i18;
                }
                i19 = i16;
                if ((i4 & 306783379) == 306783378 || (i19 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i7 != 0) {
                            float f5 = 0;
                            j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f5), Dp.constructor-impl(f5));
                        } else {
                            j3 = j;
                        }
                        if ((i3 & 16) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -57345;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if (i9 != 0) {
                            popupProperties3 = DefaultMenuProperties;
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if ((i3 & 64) != 0) {
                            shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        } else {
                            shape3 = shape2;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        } else {
                            containerColor = j2;
                        }
                        if (i11 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i13 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i15 != 0) {
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 16) != 0) {
                            i4 &= -57345;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            i4 &= -29360129;
                        }
                        scrollStateRememberScrollState = scrollState;
                        fM2514getTonalElevationD9Ej5fM = f;
                        fM2513getShadowElevationD9Ej5fM = f2;
                        borderStroke2 = borderStroke;
                        companion = modifier2;
                        shape3 = shape2;
                        popupProperties3 = popupProperties2;
                        j3 = j;
                        containerColor = j2;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (!((Boolean) mutableTransitionState.getCurrentState()).booleanValue() || ((Boolean) mutableTransitionState.getTargetState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        mutableState = (MutableState) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                        borderStroke3 = borderStroke2;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localDensity);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                        if ((i4 & 7168) == 2048) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        zChanged = z2 | composerStartRestartGroup.changed(density);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 4, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier4 = companion;
                        final ScrollState scrollState3 = scrollStateRememberScrollState;
                        final Shape shape5 = shape3;
                        final long j6 = containerColor;
                        final float f6 = fM2514getTonalElevationD9Ej5fM;
                        final float f7 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i22) {
                                ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                                if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier4, mutableTransitionState, mutableState, scrollState3, shape5, j6, f6, f7, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                    } else {
                        borderStroke3 = borderStroke2;
                        popupProperties3 = popupProperties3;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties4 = popupProperties3;
                    modifier3 = companion;
                    shape4 = shape3;
                    scrollState2 = scrollStateRememberScrollState;
                    long j7 = containerColor;
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    j4 = j3;
                    j5 = j7;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    j4 = j;
                    scrollState2 = scrollState;
                    f4 = f;
                    modifier3 = modifier2;
                    shape4 = shape2;
                    popupProperties4 = popupProperties2;
                    j5 = j2;
                    f3 = f2;
                    borderStroke4 = borderStroke;
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

                        public final void invoke(Composer composer2, int i22) {
                            AndroidMenu_androidKt.m1995DropdownMenuIlH_yew(z, function0, modifier3, j4, scrollState2, popupProperties4, shape4, j5, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 384;
            modifier2 = modifier;
            i7 = i3 & 8;
            if (i7 != 0) {
                i4 |= 3072;
            } else if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(j)) {
                    i8 = Fields.CameraDistance;
                } else {
                    i8 = Fields.RotationZ;
                }
                i4 |= i8;
            }
            if ((i & 24576) != 0) {
                i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.Shape : Fields.Clip;
            }
            i9 = i3 & 32;
            if (i9 != 0) {
                i4 |= 196608;
                popupProperties2 = popupProperties;
            } else {
                popupProperties2 = popupProperties;
                if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i4 |= i10;
                }
            }
            if ((i & 1572864) == 0) {
                shape2 = shape;
                if ((i3 & 64) == 0) {
                    i21 = 524288;
                } else {
                    i21 = 524288;
                }
                i4 |= i21;
            } else {
                shape2 = shape;
            }
            if ((i & 12582912) != 0) {
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i20 = 4194304;
                } else {
                    i20 = 4194304;
                }
                i4 |= i20;
            }
            i11 = i3 & Fields.RotationX;
            if (i11 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i12 = 67108864;
                } else {
                    i12 = 33554432;
                }
                i4 |= i12;
            }
            i13 = i3 & Fields.RotationY;
            if (i13 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i4 |= i14;
            }
            i15 = i3 & Fields.RotationZ;
            if (i15 != 0) {
                i16 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i17 = 4;
                } else {
                    i17 = 2;
                }
                i16 = i2 | i17;
            } else {
                i16 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i16 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i18 = 32;
                } else {
                    i18 = 16;
                }
                i16 |= i18;
            }
            i19 = i16;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f8 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f8), Dp.constructor-impl(f8));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f9 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f9), Dp.constructor-impl(f9));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localDensity2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier5 = companion;
                    final ScrollState scrollState4 = scrollStateRememberScrollState;
                    final Shape shape6 = shape3;
                    final long j8 = containerColor;
                    final float f10 = fM2514getTonalElevationD9Ej5fM;
                    final float f11 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier5, mutableTransitionState, mutableState, scrollState4, shape6, j8, f10, f11, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localDensity3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume3;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier6 = companion;
                    final ScrollState scrollState5 = scrollStateRememberScrollState;
                    final Shape shape7 = shape3;
                    final long j9 = containerColor;
                    final float f12 = fM2514getTonalElevationD9Ej5fM;
                    final float f13 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier6, mutableTransitionState, mutableState, scrollState5, shape7, j9, f12, f13, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties4 = popupProperties3;
                modifier3 = companion;
                shape4 = shape3;
                scrollState2 = scrollStateRememberScrollState;
                long j10 = containerColor;
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                f4 = fM2514getTonalElevationD9Ej5fM;
                j4 = j3;
                j5 = j10;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f14 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f14), Dp.constructor-impl(f14));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f15 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f15), Dp.constructor-impl(f15));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localDensity4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume4;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier7 = companion;
                    final ScrollState scrollState6 = scrollStateRememberScrollState;
                    final Shape shape8 = shape3;
                    final long j11 = containerColor;
                    final float f16 = fM2514getTonalElevationD9Ej5fM;
                    final float f17 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier7, mutableTransitionState, mutableState, scrollState6, shape8, j11, f16, f17, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localDensity5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume5;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier8 = companion;
                    final ScrollState scrollState7 = scrollStateRememberScrollState;
                    final Shape shape9 = shape3;
                    final long j12 = containerColor;
                    final float f18 = fM2514getTonalElevationD9Ej5fM;
                    final float f19 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier8, mutableTransitionState, mutableState, scrollState7, shape9, j12, f18, f19, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties4 = popupProperties3;
                modifier3 = companion;
                shape4 = shape3;
                scrollState2 = scrollStateRememberScrollState;
                long j13 = containerColor;
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                f4 = fM2514getTonalElevationD9Ej5fM;
                j4 = j3;
                j5 = j13;
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

                    public final void invoke(Composer composer2, int i22) {
                        AndroidMenu_androidKt.m1995DropdownMenuIlH_yew(z, function0, modifier3, j4, scrollState2, popupProperties4, shape4, j5, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 48;
        i5 = i3 & 4;
        if (i5 != 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i6 = Fields.RotationX;
                } else {
                    i6 = Fields.SpotShadowColor;
                }
                i4 |= i6;
            }
            i7 = i3 & 8;
            if (i7 != 0) {
                i4 |= 3072;
            } else if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(j)) {
                    i8 = Fields.CameraDistance;
                } else {
                    i8 = Fields.RotationZ;
                }
                i4 |= i8;
            }
            if ((i & 24576) != 0) {
                i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.Shape : Fields.Clip;
            }
            i9 = i3 & 32;
            if (i9 != 0) {
                i4 |= 196608;
                popupProperties2 = popupProperties;
            } else {
                popupProperties2 = popupProperties;
                if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i4 |= i10;
                }
            }
            if ((i & 1572864) == 0) {
                shape2 = shape;
                if ((i3 & 64) == 0) {
                    i21 = 524288;
                } else {
                    i21 = 524288;
                }
                i4 |= i21;
            } else {
                shape2 = shape;
            }
            if ((i & 12582912) != 0) {
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i20 = 4194304;
                } else {
                    i20 = 4194304;
                }
                i4 |= i20;
            }
            i11 = i3 & Fields.RotationX;
            if (i11 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i12 = 67108864;
                } else {
                    i12 = 33554432;
                }
                i4 |= i12;
            }
            i13 = i3 & Fields.RotationY;
            if (i13 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i4 |= i14;
            }
            i15 = i3 & Fields.RotationZ;
            if (i15 != 0) {
                i16 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i17 = 4;
                } else {
                    i17 = 2;
                }
                i16 = i2 | i17;
            } else {
                i16 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i16 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i18 = 32;
                } else {
                    i18 = 16;
                }
                i16 |= i18;
            }
            i19 = i16;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f110 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f110), Dp.constructor-impl(f110));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f111 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f111), Dp.constructor-impl(f111));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume6 = composerStartRestartGroup.consume(localDensity6);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume6;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier9 = companion;
                    final ScrollState scrollState8 = scrollStateRememberScrollState;
                    final Shape shape10 = shape3;
                    final long j14 = containerColor;
                    final float f112 = fM2514getTonalElevationD9Ej5fM;
                    final float f113 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier9, mutableTransitionState, mutableState, scrollState8, shape10, j14, f112, f113, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume7 = composerStartRestartGroup.consume(localDensity7);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume7;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier10 = companion;
                    final ScrollState scrollState9 = scrollStateRememberScrollState;
                    final Shape shape11 = shape3;
                    final long j15 = containerColor;
                    final float f114 = fM2514getTonalElevationD9Ej5fM;
                    final float f115 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier10, mutableTransitionState, mutableState, scrollState9, shape11, j15, f114, f115, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties4 = popupProperties3;
                modifier3 = companion;
                shape4 = shape3;
                scrollState2 = scrollStateRememberScrollState;
                long j16 = containerColor;
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                f4 = fM2514getTonalElevationD9Ej5fM;
                j4 = j3;
                j5 = j16;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f116 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f116), Dp.constructor-impl(f116));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i7 != 0) {
                        float f117 = 0;
                        j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f117), Dp.constructor-impl(f117));
                    } else {
                        j3 = j;
                    }
                    if ((i3 & 16) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -57345;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if (i9 != 0) {
                        popupProperties3 = DefaultMenuProperties;
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if ((i3 & 64) != 0) {
                        shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        shape3 = shape2;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    } else {
                        containerColor = j2;
                    }
                    if (i11 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i13 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i15 != 0) {
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localDensity8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume8;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier11 = companion;
                    final ScrollState scrollState10 = scrollStateRememberScrollState;
                    final Shape shape12 = shape3;
                    final long j17 = containerColor;
                    final float f118 = fM2514getTonalElevationD9Ej5fM;
                    final float f119 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier11, mutableTransitionState, mutableState, scrollState10, shape12, j17, f118, f119, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableState = (MutableState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume9 = composerStartRestartGroup.consume(localDensity9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume9;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                    if ((i4 & 7168) == 2048) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    zChanged = z2 | composerStartRestartGroup.changed(density);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 4, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier12 = companion;
                    final ScrollState scrollState11 = scrollStateRememberScrollState;
                    final Shape shape13 = shape3;
                    final long j18 = containerColor;
                    final float f1110 = fM2514getTonalElevationD9Ej5fM;
                    final float f1111 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i22) {
                            ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                            if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier12, mutableTransitionState, mutableState, scrollState11, shape13, j18, f1110, f1111, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties4 = popupProperties3;
                modifier3 = companion;
                shape4 = shape3;
                scrollState2 = scrollStateRememberScrollState;
                long j19 = containerColor;
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                f4 = fM2514getTonalElevationD9Ej5fM;
                j4 = j3;
                j5 = j19;
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

                    public final void invoke(Composer composer2, int i22) {
                        AndroidMenu_androidKt.m1995DropdownMenuIlH_yew(z, function0, modifier3, j4, scrollState2, popupProperties4, shape4, j5, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 384;
        modifier2 = modifier;
        i7 = i3 & 8;
        if (i7 != 0) {
            i4 |= 3072;
        } else if ((i & 3072) == 0) {
            if (composerStartRestartGroup.changed(j)) {
                i8 = Fields.CameraDistance;
            } else {
                i8 = Fields.RotationZ;
            }
            i4 |= i8;
        }
        if ((i & 24576) != 0) {
            i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.Shape : Fields.Clip;
        }
        i9 = i3 & 32;
        if (i9 != 0) {
            i4 |= 196608;
            popupProperties2 = popupProperties;
        } else {
            popupProperties2 = popupProperties;
            if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(popupProperties2)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i4 |= i10;
            }
        }
        if ((i & 1572864) == 0) {
            shape2 = shape;
            if ((i3 & 64) == 0) {
                i21 = 524288;
            } else {
                i21 = 524288;
            }
            i4 |= i21;
        } else {
            shape2 = shape;
        }
        if ((i & 12582912) != 0) {
            if ((i3 & Fields.SpotShadowColor) == 0) {
                i20 = 4194304;
            } else {
                i20 = 4194304;
            }
            i4 |= i20;
        }
        i11 = i3 & Fields.RotationX;
        if (i11 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i12 = 67108864;
            } else {
                i12 = 33554432;
            }
            i4 |= i12;
        }
        i13 = i3 & Fields.RotationY;
        if (i13 != 0) {
            i4 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changed(f2)) {
                i14 = 536870912;
            } else {
                i14 = 268435456;
            }
            i4 |= i14;
        }
        i15 = i3 & Fields.RotationZ;
        if (i15 != 0) {
            i16 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changed(borderStroke)) {
                i17 = 4;
            } else {
                i17 = 2;
            }
            i16 = i2 | i17;
        } else {
            i16 = i2;
        }
        if ((i3 & Fields.CameraDistance) != 0) {
            i16 |= 48;
        } else if ((i2 & 48) != 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i18 = 32;
            } else {
                i18 = 16;
            }
            i16 |= i18;
        }
        i19 = i16;
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    float f1112 = 0;
                    j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f1112), Dp.constructor-impl(f1112));
                } else {
                    j3 = j;
                }
                if ((i3 & 16) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -57345;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if (i9 != 0) {
                    popupProperties3 = DefaultMenuProperties;
                } else {
                    popupProperties3 = popupProperties2;
                }
                if ((i3 & 64) != 0) {
                    shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    shape3 = shape2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                } else {
                    containerColor = j2;
                }
                if (i11 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i13 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i15 != 0) {
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    float f1113 = 0;
                    j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f1113), Dp.constructor-impl(f1113));
                } else {
                    j3 = j;
                }
                if ((i3 & 16) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -57345;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if (i9 != 0) {
                    popupProperties3 = DefaultMenuProperties;
                } else {
                    popupProperties3 = popupProperties2;
                }
                if ((i3 & 64) != 0) {
                    shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    shape3 = shape2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                } else {
                    containerColor = j2;
                }
                if (i11 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i13 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i15 != 0) {
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new MutableTransitionState(false);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableTransitionState = (MutableTransitionState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
            if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableState = (MutableState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume10 = composerStartRestartGroup.consume(localDensity10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume10;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z2 | composerStartRestartGroup.changed(density);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier13 = companion;
                final ScrollState scrollState12 = scrollStateRememberScrollState;
                final Shape shape14 = shape3;
                final long j110 = containerColor;
                final float f1114 = fM2514getTonalElevationD9Ej5fM;
                final float f1115 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i22) {
                        ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                        if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier13, mutableTransitionState, mutableState, scrollState12, shape14, j110, f1114, f1115, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
            } else {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableState = (MutableState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11 = composerStartRestartGroup.consume(localDensity11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume11;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z2 | composerStartRestartGroup.changed(density);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier14 = companion;
                final ScrollState scrollState13 = scrollStateRememberScrollState;
                final Shape shape15 = shape3;
                final long j111 = containerColor;
                final float f1116 = fM2514getTonalElevationD9Ej5fM;
                final float f1117 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i22) {
                        ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                        if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier14, mutableTransitionState, mutableState, scrollState13, shape15, j111, f1116, f1117, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            popupProperties4 = popupProperties3;
            modifier3 = companion;
            shape4 = shape3;
            scrollState2 = scrollStateRememberScrollState;
            long j112 = containerColor;
            borderStroke4 = borderStroke3;
            f3 = fM2513getShadowElevationD9Ej5fM;
            f4 = fM2514getTonalElevationD9Ej5fM;
            j4 = j3;
            j5 = j112;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    float f1118 = 0;
                    j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f1118), Dp.constructor-impl(f1118));
                } else {
                    j3 = j;
                }
                if ((i3 & 16) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -57345;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if (i9 != 0) {
                    popupProperties3 = DefaultMenuProperties;
                } else {
                    popupProperties3 = popupProperties2;
                }
                if ((i3 & 64) != 0) {
                    shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    shape3 = shape2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                } else {
                    containerColor = j2;
                }
                if (i11 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i13 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i15 != 0) {
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i7 != 0) {
                    float f1119 = 0;
                    j3 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f1119), Dp.constructor-impl(f1119));
                } else {
                    j3 = j;
                }
                if ((i3 & 16) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -57345;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if (i9 != 0) {
                    popupProperties3 = DefaultMenuProperties;
                } else {
                    popupProperties3 = popupProperties2;
                }
                if ((i3 & 64) != 0) {
                    shape3 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    shape3 = shape2;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                } else {
                    containerColor = j2;
                }
                if (i11 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i13 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i15 != 0) {
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1431928300, i4, i19, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:54)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468213501, "CC(remember):AndroidMenu.android.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new MutableTransitionState(false);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableTransitionState = (MutableTransitionState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
            if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableState = (MutableState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume12 = composerStartRestartGroup.consume(localDensity12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume12;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z2 | composerStartRestartGroup.changed(density);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier15 = companion;
                final ScrollState scrollState14 = scrollStateRememberScrollState;
                final Shape shape16 = shape3;
                final long j113 = containerColor;
                final float f11110 = fM2514getTonalElevationD9Ej5fM;
                final float f11111 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i22) {
                        ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                        if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier15, mutableTransitionState, mutableState, scrollState14, shape16, j113, f11110, f11111, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
            } else {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468219494, "CC(remember):AndroidMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableState = (MutableState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume13 = composerStartRestartGroup.consume(localDensity13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume13;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1468224270, "CC(remember):AndroidMenu.android.kt#9igjgp");
                if ((i4 & 7168) == 2048) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                zChanged = z2 | composerStartRestartGroup.changed(density);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = new DropdownMenuPositionProvider(j3, density, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 4, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier16 = companion;
                final ScrollState scrollState15 = scrollStateRememberScrollState;
                final Shape shape17 = shape3;
                final long j114 = containerColor;
                final float f11112 = fM2514getTonalElevationD9Ej5fM;
                final float f11113 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((DropdownMenuPositionProvider) objRememberedValue3, function0, popupProperties3, ComposableLambdaKt.rememberComposableLambda(2126968933, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i22) {
                        ComposerKt.sourceInformation(composer2, "C73@2839L470:AndroidMenu.android.kt#uh7d8r");
                        if ((i22 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2126968933, i22, -1, "androidx.compose.material3.DropdownMenu.<anonymous> (AndroidMenu.android.kt:73)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(modifier16, mutableTransitionState, mutableState, scrollState15, shape17, j114, f11112, f11113, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, ((i4 >> 9) & 896) | (i4 & 112) | 3072, 0);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            popupProperties4 = popupProperties3;
            modifier3 = companion;
            shape4 = shape3;
            scrollState2 = scrollStateRememberScrollState;
            long j115 = containerColor;
            borderStroke4 = borderStroke3;
            f3 = fM2513getShadowElevationD9Ej5fM;
            f4 = fM2514getTonalElevationD9Ej5fM;
            j4 = j3;
            j5 = j115;
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

                public final void invoke(Composer composer2, int i22) {
                    AndroidMenu_androidKt.m1995DropdownMenuIlH_yew(z, function0, modifier3, j4, scrollState2, popupProperties4, shape4, j5, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility. Use overload with parameters for shape, color, elevation, and border.", replaceWith = @ReplaceWith(expression = "DropdownMenu(\n    expanded = expanded,\n    onDismissRequest = onDismissRequest,\n    modifier = modifier,\n    offset = offset,\n    scrollState = scrollState,\n    properties = properties,\n    shape = MenuDefaults.shape,\n    containerColor = MenuDefaults.containerColor,\n    tonalElevation = MenuDefaults.TonalElevation,\n    shadowElevation = MenuDefaults.ShadowElevation,\n    border = null,\n    content = content,\n)", imports = {}))
    public static final void m1993DropdownMenu4kj_NE(final boolean z, final Function0 function0, Modifier modifier, long j, ScrollState scrollState, PopupProperties popupProperties, final Function3 function3, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        int i6;
        long j2;
        int i7;
        ScrollState scrollStateRememberScrollState;
        int i8;
        PopupProperties popupProperties2;
        int i9;
        int i10;
        int i11;
        PopupProperties popupProperties3;
        ScrollState scrollState2;
        long j3;
        final Modifier modifier3;
        final ScrollState scrollState3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1137929566);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DropdownMenu)P(1,4,2,3:c#ui.unit.DpOffset,6,5)119@4573L21,130@4960L5,131@5005L14,123@4721L465:AndroidMenu.android.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    i3 |= 3072;
                    j2 = j;
                } else {
                    j2 = j;
                    if ((i & 3072) == 0) {
                        if (composerStartRestartGroup.changed(j2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                }
                if ((i & 24576) == 0) {
                    if ((i2 & 16) == 0) {
                        scrollStateRememberScrollState = scrollState;
                        if (composerStartRestartGroup.changed(scrollStateRememberScrollState)) {
                            i12 = Fields.Clip;
                        }
                        i3 |= i12;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    i12 = Fields.Shape;
                    i3 |= i12;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        popupProperties2 = popupProperties;
                        if (composerStartRestartGroup.changed(popupProperties2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 64) != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = 1048576;
                        } else {
                            i10 = 524288;
                        }
                        i3 |= i10;
                    }
                    if ((599187 & i3) == 599186 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i4 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i6 != 0) {
                                float f = 0;
                                j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f), Dp.constructor-impl(f));
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                                scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            }
                            if (i8 != 0) {
                                i11 = i3;
                                popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                                scrollState2 = scrollStateRememberScrollState;
                                j3 = j2;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                            }
                            m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            popupProperties2 = popupProperties3;
                            modifier3 = modifier2;
                            scrollState3 = scrollState2;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                        }
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        popupProperties2 = popupProperties3;
                        modifier3 = modifier2;
                        scrollState3 = scrollState2;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier3 = modifier2;
                        scrollState3 = scrollStateRememberScrollState;
                        j3 = j2;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final long j4 = j3;
                        final PopupProperties popupProperties4 = popupProperties2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i13) {
                                AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j4, scrollState3, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                popupProperties2 = popupProperties;
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f2 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f2), Dp.constructor-impl(f2));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f3 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f3), Dp.constructor-impl(f3));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties2 = popupProperties3;
                    modifier3 = modifier2;
                    scrollState3 = scrollState2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f4 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f4), Dp.constructor-impl(f4));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f5 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f5), Dp.constructor-impl(f5));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties2 = popupProperties3;
                    modifier3 = modifier2;
                    scrollState3 = scrollState2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j5 = j3;
                    final PopupProperties popupProperties5 = popupProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i13) {
                            AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j5, scrollState3, popupProperties5, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            modifier2 = modifier;
            i6 = i2 & 8;
            if (i6 != 0) {
                i3 |= 3072;
                j2 = j;
            } else {
                j2 = j;
                if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(j2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    scrollStateRememberScrollState = scrollState;
                    if (composerStartRestartGroup.changed(scrollStateRememberScrollState)) {
                        i12 = Fields.Clip;
                    }
                    i3 |= i12;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                i12 = Fields.Shape;
                i3 |= i12;
            } else {
                scrollStateRememberScrollState = scrollState;
            }
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f6 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f6), Dp.constructor-impl(f6));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f7 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f7), Dp.constructor-impl(f7));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties2 = popupProperties3;
                    modifier3 = modifier2;
                    scrollState3 = scrollState2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f8 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f8), Dp.constructor-impl(f8));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f9 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f9), Dp.constructor-impl(f9));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties2 = popupProperties3;
                    modifier3 = modifier2;
                    scrollState3 = scrollState2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j6 = j3;
                    final PopupProperties popupProperties6 = popupProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i13) {
                            AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j6, scrollState3, popupProperties6, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            popupProperties2 = popupProperties;
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f10 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f10), Dp.constructor-impl(f10));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f11 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f11), Dp.constructor-impl(f11));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties2 = popupProperties3;
                modifier3 = modifier2;
                scrollState3 = scrollState2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f12 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f12), Dp.constructor-impl(f12));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f13 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f13), Dp.constructor-impl(f13));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties2 = popupProperties3;
                modifier3 = modifier2;
                scrollState3 = scrollState2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j7 = j3;
                final PopupProperties popupProperties7 = popupProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i13) {
                        AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j7, scrollState3, popupProperties7, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                i3 |= 3072;
                j2 = j;
            } else {
                j2 = j;
                if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(j2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    scrollStateRememberScrollState = scrollState;
                    if (composerStartRestartGroup.changed(scrollStateRememberScrollState)) {
                        i12 = Fields.Clip;
                    }
                    i3 |= i12;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                i12 = Fields.Shape;
                i3 |= i12;
            } else {
                scrollStateRememberScrollState = scrollState;
            }
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                if ((i2 & 64) != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = 1048576;
                    } else {
                        i10 = 524288;
                    }
                    i3 |= i10;
                }
                if ((599187 & i3) == 599186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f14 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f14), Dp.constructor-impl(f14));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f15 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f15), Dp.constructor-impl(f15));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties2 = popupProperties3;
                    modifier3 = modifier2;
                    scrollState3 = scrollState2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f16 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f16), Dp.constructor-impl(f16));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f17 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f17), Dp.constructor-impl(f17));
                        }
                        if ((i2 & 16) != 0) {
                            i3 &= -57345;
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        }
                        if (i8 != 0) {
                            i11 = i3;
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                        } else {
                            i11 = i3;
                            scrollState2 = scrollStateRememberScrollState;
                            j3 = j2;
                            popupProperties3 = popupProperties2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    popupProperties2 = popupProperties3;
                    modifier3 = modifier2;
                    scrollState3 = scrollState2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j8 = j3;
                    final PopupProperties popupProperties8 = popupProperties2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i13) {
                            AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j8, scrollState3, popupProperties8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            popupProperties2 = popupProperties;
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f18 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f18), Dp.constructor-impl(f18));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f19 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f19), Dp.constructor-impl(f19));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties2 = popupProperties3;
                modifier3 = modifier2;
                scrollState3 = scrollState2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f110 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f110), Dp.constructor-impl(f110));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f111 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f111), Dp.constructor-impl(f111));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties2 = popupProperties3;
                modifier3 = modifier2;
                scrollState3 = scrollState2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j9 = j3;
                final PopupProperties popupProperties9 = popupProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i13) {
                        AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j9, scrollState3, popupProperties9, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i6 = i2 & 8;
        if (i6 != 0) {
            i3 |= 3072;
            j2 = j;
        } else {
            j2 = j;
            if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(j2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                scrollStateRememberScrollState = scrollState;
                if (composerStartRestartGroup.changed(scrollStateRememberScrollState)) {
                    i12 = Fields.Clip;
                }
                i3 |= i12;
            } else {
                scrollStateRememberScrollState = scrollState;
            }
            i12 = Fields.Shape;
            i3 |= i12;
        } else {
            scrollStateRememberScrollState = scrollState;
        }
        i8 = i2 & 32;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                popupProperties2 = popupProperties;
                if (composerStartRestartGroup.changed(popupProperties2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            if ((i2 & 64) != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = 1048576;
                } else {
                    i10 = 524288;
                }
                i3 |= i10;
            }
            if ((599187 & i3) == 599186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f112 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f112), Dp.constructor-impl(f112));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f113 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f113), Dp.constructor-impl(f113));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties2 = popupProperties3;
                modifier3 = modifier2;
                scrollState3 = scrollState2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f114 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f114), Dp.constructor-impl(f114));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f115 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f115), Dp.constructor-impl(f115));
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    }
                    if (i8 != 0) {
                        i11 = i3;
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                    } else {
                        i11 = i3;
                        scrollState2 = scrollStateRememberScrollState;
                        j3 = j2;
                        popupProperties3 = popupProperties2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                popupProperties2 = popupProperties3;
                modifier3 = modifier2;
                scrollState3 = scrollState2;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j10 = j3;
                final PopupProperties popupProperties10 = popupProperties2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i13) {
                        AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j10, scrollState3, popupProperties10, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        popupProperties2 = popupProperties;
        if ((i2 & 64) != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = 1048576;
            } else {
                i10 = 524288;
            }
            i3 |= i10;
        }
        if ((599187 & i3) == 599186) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f116 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f116), Dp.constructor-impl(f116));
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                }
                if (i8 != 0) {
                    i11 = i3;
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                } else {
                    i11 = i3;
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                    popupProperties3 = popupProperties2;
                }
            } else {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f117 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f117), Dp.constructor-impl(f117));
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                }
                if (i8 != 0) {
                    i11 = i3;
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                } else {
                    i11 = i3;
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                    popupProperties3 = popupProperties2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
            }
            m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            popupProperties2 = popupProperties3;
            modifier3 = modifier2;
            scrollState3 = scrollState2;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f118 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f118), Dp.constructor-impl(f118));
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                }
                if (i8 != 0) {
                    i11 = i3;
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                } else {
                    i11 = i3;
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                    popupProperties3 = popupProperties2;
                }
            } else {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f119 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f119), Dp.constructor-impl(f119));
                }
                if ((i2 & 16) != 0) {
                    i3 &= -57345;
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                }
                if (i8 != 0) {
                    i11 = i3;
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                } else {
                    i11 = i3;
                    scrollState2 = scrollStateRememberScrollState;
                    j3 = j2;
                    popupProperties3 = popupProperties2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1137929566, i11, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:123)");
            }
            m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, scrollState2, popupProperties3, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i11 & 14) | 905969664 | (i11 & 112) | (i11 & 896) | (i11 & 7168) | (57344 & i11) | (458752 & i11), ((i11 >> 15) & 112) | 6, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            popupProperties2 = popupProperties3;
            modifier3 = modifier2;
            scrollState3 = scrollState2;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final long j11 = j3;
            final PopupProperties popupProperties11 = popupProperties2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i13) {
                    AndroidMenu_androidKt.m1993DropdownMenu4kj_NE(z, function0, modifier3, j11, scrollState3, popupProperties11, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Replaced by a DropdownMenu function with a ScrollState parameter", replaceWith = @ReplaceWith(expression = "DropdownMenu(expanded,onDismissRequest, modifier, offset, rememberScrollState(), properties, content)", imports = {"androidx.compose.foundation.rememberScrollState"}))
    public static final void m1994DropdownMenuILWXrKs(final boolean z, final Function0 function0, Modifier modifier, long j, PopupProperties popupProperties, final Function3 function3, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        int i6;
        long j2;
        int i7;
        int i8;
        PopupProperties popupProperties2;
        int i9;
        int i10;
        PopupProperties popupProperties3;
        final Modifier modifier3;
        final PopupProperties popupProperties4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(354826666);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DropdownMenu)P(1,4,2,3:c#ui.unit.DpOffset,5)163@6060L21,158@5896L251:AndroidMenu.android.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(z) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        j2 = j;
                        if (composerStartRestartGroup.changed(j2)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((i & 24576) == 0) {
                            popupProperties2 = popupProperties;
                            if (composerStartRestartGroup.changed(popupProperties2)) {
                                i9 = Fields.Clip;
                            } else {
                                i9 = Fields.Shape;
                            }
                            i3 |= i9;
                        }
                        if ((i2 & 32) != 0) {
                            i3 |= 196608;
                        } else if ((i & 196608) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i10 = Fields.RenderEffect;
                            } else {
                                i10 = 65536;
                            }
                            i3 |= i10;
                        }
                        if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                            if (i4 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i6 != 0) {
                                float f = 0;
                                j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f), Dp.constructor-impl(f));
                            }
                            long j3 = j2;
                            if (i8 != 0) {
                                popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                            } else {
                                popupProperties3 = popupProperties2;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                            }
                            m1995DropdownMenuIlH_yew(z, function0, modifier2, j3, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier2;
                            popupProperties4 = popupProperties3;
                            j2 = j3;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            popupProperties4 = popupProperties2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final long j4 = j2;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11) {
                                    AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j4, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    popupProperties2 = popupProperties;
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f2 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f2), Dp.constructor-impl(f2));
                        }
                        long j5 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j5, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j5;
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f3 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f3), Dp.constructor-impl(f3));
                        }
                        long j6 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j6, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j6;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final long j7 = j2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j7, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                j2 = j;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        popupProperties2 = popupProperties;
                        if (composerStartRestartGroup.changed(popupProperties2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f4 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f4), Dp.constructor-impl(f4));
                        }
                        long j8 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j8, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j8;
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f5 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f5), Dp.constructor-impl(f5));
                        }
                        long j9 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j9, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j9;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final long j10 = j2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j10, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                popupProperties2 = popupProperties;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f6 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f6), Dp.constructor-impl(f6));
                    }
                    long j11 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j11, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j11;
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f7 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f7), Dp.constructor-impl(f7));
                    }
                    long j12 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j12, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j12;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j13 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j13, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            modifier2 = modifier;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        popupProperties2 = popupProperties;
                        if (composerStartRestartGroup.changed(popupProperties2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f8 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f8), Dp.constructor-impl(f8));
                        }
                        long j14 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j14, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j14;
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f9 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f9), Dp.constructor-impl(f9));
                        }
                        long j15 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j15, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j15;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final long j16 = j2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j16, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                popupProperties2 = popupProperties;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f10 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f10), Dp.constructor-impl(f10));
                    }
                    long j17 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j17, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j17;
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f11 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f11), Dp.constructor-impl(f11));
                    }
                    long j18 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j18, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j18;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j19 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j19, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            j2 = j;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f12 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f12), Dp.constructor-impl(f12));
                    }
                    long j110 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j110, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j110;
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f13 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f13), Dp.constructor-impl(f13));
                    }
                    long j111 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j111, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j111;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j112 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j112, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            popupProperties2 = popupProperties;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f14 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f14), Dp.constructor-impl(f14));
                }
                long j113 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j113, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j113;
            } else {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f15 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f15), Dp.constructor-impl(f15));
                }
                long j114 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j114, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j114;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j115 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j115, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    j2 = j;
                    if (composerStartRestartGroup.changed(j2)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        popupProperties2 = popupProperties;
                        if (composerStartRestartGroup.changed(popupProperties2)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    if ((i2 & 32) != 0) {
                        i3 |= 196608;
                    } else if ((i & 196608) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i10 = Fields.RenderEffect;
                        } else {
                            i10 = 65536;
                        }
                        i3 |= i10;
                    }
                    if ((74899 & i3) == 74898) {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f16 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f16), Dp.constructor-impl(f16));
                        }
                        long j116 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j116, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j116;
                    } else {
                        if (i4 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i6 != 0) {
                            float f17 = 0;
                            j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f17), Dp.constructor-impl(f17));
                        }
                        long j117 = j2;
                        if (i8 != 0) {
                            popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                        } else {
                            popupProperties3 = popupProperties2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                        }
                        m1995DropdownMenuIlH_yew(z, function0, modifier2, j117, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier2;
                        popupProperties4 = popupProperties3;
                        j2 = j117;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final long j118 = j2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11) {
                                AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j118, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                popupProperties2 = popupProperties;
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f18 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f18), Dp.constructor-impl(f18));
                    }
                    long j119 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j119, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j119;
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f19 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f19), Dp.constructor-impl(f19));
                    }
                    long j1110 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j1110, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j1110;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j1111 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j1111, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            j2 = j;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f110 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f110), Dp.constructor-impl(f110));
                    }
                    long j1112 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j1112, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j1112;
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f111 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f111), Dp.constructor-impl(f111));
                    }
                    long j1113 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j1113, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j1113;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j1114 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j1114, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            popupProperties2 = popupProperties;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f112 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f112), Dp.constructor-impl(f112));
                }
                long j1115 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j1115, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j1115;
            } else {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f113 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f113), Dp.constructor-impl(f113));
                }
                long j1116 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j1116, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j1116;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j1117 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j1117, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                j2 = j;
                if (composerStartRestartGroup.changed(j2)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    popupProperties2 = popupProperties;
                    if (composerStartRestartGroup.changed(popupProperties2)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i10 = Fields.RenderEffect;
                    } else {
                        i10 = 65536;
                    }
                    i3 |= i10;
                }
                if ((74899 & i3) == 74898) {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f114 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f114), Dp.constructor-impl(f114));
                    }
                    long j1118 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j1118, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j1118;
                } else {
                    if (i4 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i6 != 0) {
                        float f115 = 0;
                        j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f115), Dp.constructor-impl(f115));
                    }
                    long j1119 = j2;
                    if (i8 != 0) {
                        popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                    } else {
                        popupProperties3 = popupProperties2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                    }
                    m1995DropdownMenuIlH_yew(z, function0, modifier2, j1119, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier2;
                    popupProperties4 = popupProperties3;
                    j2 = j1119;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final long j11110 = j2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11) {
                            AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j11110, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            popupProperties2 = popupProperties;
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f116 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f116), Dp.constructor-impl(f116));
                }
                long j11111 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j11111, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j11111;
            } else {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f117 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f117), Dp.constructor-impl(f117));
                }
                long j11112 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j11112, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j11112;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j11113 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j11113, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        j2 = j;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((i & 24576) == 0) {
                popupProperties2 = popupProperties;
                if (composerStartRestartGroup.changed(popupProperties2)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i3 |= i9;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i10 = Fields.RenderEffect;
                } else {
                    i10 = 65536;
                }
                i3 |= i10;
            }
            if ((74899 & i3) == 74898) {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f118 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f118), Dp.constructor-impl(f118));
                }
                long j11114 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j11114, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j11114;
            } else {
                if (i4 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i6 != 0) {
                    float f119 = 0;
                    j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f119), Dp.constructor-impl(f119));
                }
                long j11115 = j2;
                if (i8 != 0) {
                    popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
                } else {
                    popupProperties3 = popupProperties2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
                }
                m1995DropdownMenuIlH_yew(z, function0, modifier2, j11115, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier2;
                popupProperties4 = popupProperties3;
                j2 = j11115;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final long j11116 = j2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11) {
                        AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j11116, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        popupProperties2 = popupProperties;
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i10 = Fields.RenderEffect;
            } else {
                i10 = 65536;
            }
            i3 |= i10;
        }
        if ((74899 & i3) == 74898) {
            if (i4 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i6 != 0) {
                float f1110 = 0;
                j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f1110), Dp.constructor-impl(f1110));
            }
            long j11117 = j2;
            if (i8 != 0) {
                popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
            } else {
                popupProperties3 = popupProperties2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
            }
            m1995DropdownMenuIlH_yew(z, function0, modifier2, j11117, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = modifier2;
            popupProperties4 = popupProperties3;
            j2 = j11117;
        } else {
            if (i4 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i6 != 0) {
                float f1111 = 0;
                j2 = DpKt.DpOffset-YgX7TsA(Dp.constructor-impl(f1111), Dp.constructor-impl(f1111));
            }
            long j11118 = j2;
            if (i8 != 0) {
                popupProperties3 = new PopupProperties(true, false, false, false, 14, (DefaultConstructorMarker) null);
            } else {
                popupProperties3 = popupProperties2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(354826666, i3, -1, "androidx.compose.material3.DropdownMenu (AndroidMenu.android.kt:158)");
            }
            m1995DropdownMenuIlH_yew(z, function0, modifier2, j11118, ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1), popupProperties3, null, 0L, 0.0f, 0.0f, null, function3, composerStartRestartGroup, (i3 & 8190) | ((i3 << 3) & 458752), (i3 >> 12) & 112, 1984);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = modifier2;
            popupProperties4 = popupProperties3;
            j2 = j11118;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final long j11119 = j2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11) {
                    AndroidMenu_androidKt.m1994DropdownMenuILWXrKs(z, function0, modifier3, j11119, popupProperties4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void DropdownMenuItem(final Function2<? super Composer, ? super Integer, Unit> function2, final Function0<Unit> function0, Modifier modifier, Function2<? super Composer, ? super Integer, Unit> function3, Function2<? super Composer, ? super Integer, Unit> function4, boolean z, MenuItemColors menuItemColors, PaddingValues paddingValues, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        int i5;
        int i6;
        Function2<? super Composer, ? super Integer, Unit> function5;
        int i7;
        int i8;
        Function2<? super Composer, ? super Integer, Unit> function6;
        int i9;
        int i10;
        boolean z2;
        int i11;
        MenuItemColors menuItemColors2;
        int i12;
        int i13;
        int i14;
        int i15;
        Modifier.Companion companion;
        boolean z3;
        MenuItemColors menuItemColorsItemColors;
        PaddingValues dropdownMenuItemContentPadding;
        MutableInteractionSource mutableInteractionSource2;
        PaddingValues paddingValues2;
        Function2<? super Composer, ? super Integer, Unit> function7;
        final Modifier modifier2;
        final boolean z4;
        final Function2<? super Composer, ? super Integer, Unit> function8;
        final MenuItemColors menuItemColors3;
        final PaddingValues paddingValues3;
        final MutableInteractionSource mutableInteractionSource3;
        final Function2<? super Composer, ? super Integer, Unit> function9;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1826340448);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(DropdownMenuItem)P(7,6,5,4,8,2)194@8925L12,180@6505L319:AndroidMenu.android.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function2) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changedInstance(function0) ? 32 : 16;
            }
            i4 = i2 & 4;
            if (i4 != 0) {
                if ((i & 384) == 0) {
                    if (composerStartRestartGroup.changed(modifier)) {
                        i5 = Fields.RotationX;
                    } else {
                        i5 = Fields.SpotShadowColor;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 8;
                if (i6 != 0) {
                    if ((i & 3072) == 0) {
                        function5 = function3;
                        if (composerStartRestartGroup.changedInstance(function5)) {
                            i7 = Fields.CameraDistance;
                        } else {
                            i7 = Fields.RotationZ;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 16;
                    if (i8 != 0) {
                        if ((i & 24576) == 0) {
                            function6 = function4;
                            if (composerStartRestartGroup.changedInstance(function6)) {
                                i9 = Fields.Clip;
                            } else {
                                i9 = Fields.Shape;
                            }
                            i3 |= i9;
                        }
                        i10 = i2 & 32;
                        if (i10 != 0) {
                            if ((196608 & i) == 0) {
                                z2 = z;
                                if (composerStartRestartGroup.changed(z2)) {
                                    i11 = Fields.RenderEffect;
                                } else {
                                    i11 = 65536;
                                }
                                i3 |= i11;
                            }
                            if ((1572864 & i) == 0) {
                                if ((i2 & 64) == 0) {
                                    menuItemColors2 = menuItemColors;
                                    int i16 = composerStartRestartGroup.changed(menuItemColors2) ? 1048576 : 524288;
                                    i3 |= i16;
                                } else {
                                    menuItemColors2 = menuItemColors;
                                }
                                i3 |= i16;
                            } else {
                                menuItemColors2 = menuItemColors;
                            }
                            i12 = i2 & Fields.SpotShadowColor;
                            if (i12 != 0) {
                                i3 |= 12582912;
                            } else if ((i & 12582912) == 0) {
                                if (composerStartRestartGroup.changed(paddingValues)) {
                                    i13 = 8388608;
                                } else {
                                    i13 = 4194304;
                                }
                                i3 |= i13;
                            }
                            i14 = i2 & Fields.RotationX;
                            if (i14 != 0) {
                                i3 |= 100663296;
                            } else if ((i & 100663296) == 0) {
                                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                    i15 = 67108864;
                                } else {
                                    i15 = 33554432;
                                }
                                i3 |= i15;
                            }
                            if ((i3 & 38347923) == 38347922 || !composerStartRestartGroup.getSkipping()) {
                                composerStartRestartGroup.startDefaults();
                                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                    if (i4 != 0) {
                                        companion = Modifier.INSTANCE;
                                    } else {
                                        companion = modifier;
                                    }
                                    if (i6 != 0) {
                                        function5 = null;
                                    }
                                    if (i8 != 0) {
                                        function6 = null;
                                    }
                                    if (i10 != 0) {
                                        z3 = true;
                                    } else {
                                        z3 = z2;
                                    }
                                    if ((i2 & 64) != 0) {
                                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                        i3 &= -3670017;
                                    } else {
                                        menuItemColorsItemColors = menuItemColors2;
                                    }
                                    if (i12 != 0) {
                                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                    } else {
                                        dropdownMenuItemContentPadding = paddingValues;
                                    }
                                    mutableInteractionSource2 = i14 == 0 ? mutableInteractionSource : null;
                                    paddingValues2 = dropdownMenuItemContentPadding;
                                    function7 = function6;
                                } else {
                                    composerStartRestartGroup.skipToGroupEnd();
                                    if ((i2 & 64) != 0) {
                                        i3 &= -3670017;
                                    }
                                    companion = modifier;
                                    paddingValues2 = paddingValues;
                                    mutableInteractionSource2 = mutableInteractionSource;
                                    function7 = function6;
                                    z3 = z2;
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                                }
                                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                modifier2 = companion;
                                z4 = z3;
                                function8 = function5;
                                menuItemColors3 = menuItemColorsItemColors;
                                paddingValues3 = paddingValues2;
                                mutableInteractionSource3 = mutableInteractionSource2;
                                function9 = function7;
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                modifier2 = modifier;
                                mutableInteractionSource3 = mutableInteractionSource;
                                function8 = function5;
                                function9 = function6;
                                z4 = z2;
                                menuItemColors3 = menuItemColors2;
                                paddingValues3 = paddingValues;
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

                                    public final void invoke(Composer composer2, int i17) {
                                        AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                    }
                                });
                            }
                        }
                        i3 |= 196608;
                        z2 = z;
                        if ((1572864 & i) == 0) {
                            if ((i2 & 64) == 0) {
                                menuItemColors2 = menuItemColors;
                                if (composerStartRestartGroup.changed(menuItemColors2)) {
                                }
                                i3 |= i16;
                            } else {
                                menuItemColors2 = menuItemColors;
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i12 = i2 & Fields.SpotShadowColor;
                        if (i12 != 0) {
                            i3 |= 12582912;
                        } else if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(paddingValues)) {
                                i13 = 8388608;
                            } else {
                                i13 = 4194304;
                            }
                            i3 |= i13;
                        }
                        i14 = i2 & Fields.RotationX;
                        if (i14 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                i15 = 67108864;
                            } else {
                                i15 = 33554432;
                            }
                            i3 |= i15;
                        }
                        if ((i3 & 38347923) == 38347922) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
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

                                public final void invoke(Composer composer2, int i17) {
                                    AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 24576;
                    function6 = function4;
                    i10 = i2 & 32;
                    if (i10 != 0) {
                        if ((196608 & i) == 0) {
                            z2 = z;
                            if (composerStartRestartGroup.changed(z2)) {
                                i11 = Fields.RenderEffect;
                            } else {
                                i11 = 65536;
                            }
                            i3 |= i11;
                        }
                        if ((1572864 & i) == 0) {
                            if ((i2 & 64) == 0) {
                                menuItemColors2 = menuItemColors;
                                if (composerStartRestartGroup.changed(menuItemColors2)) {
                                }
                                i3 |= i16;
                            } else {
                                menuItemColors2 = menuItemColors;
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i12 = i2 & Fields.SpotShadowColor;
                        if (i12 != 0) {
                            i3 |= 12582912;
                        } else if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(paddingValues)) {
                                i13 = 8388608;
                            } else {
                                i13 = 4194304;
                            }
                            i3 |= i13;
                        }
                        i14 = i2 & Fields.RotationX;
                        if (i14 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                i15 = 67108864;
                            } else {
                                i15 = 33554432;
                            }
                            i3 |= i15;
                        }
                        if ((i3 & 38347923) == 38347922) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
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

                                public final void invoke(Composer composer2, int i17) {
                                    AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    z2 = z;
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 3072;
                function5 = function3;
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        function6 = function4;
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 32;
                    if (i10 != 0) {
                        if ((196608 & i) == 0) {
                            z2 = z;
                            if (composerStartRestartGroup.changed(z2)) {
                                i11 = Fields.RenderEffect;
                            } else {
                                i11 = 65536;
                            }
                            i3 |= i11;
                        }
                        if ((1572864 & i) == 0) {
                            if ((i2 & 64) == 0) {
                                menuItemColors2 = menuItemColors;
                                if (composerStartRestartGroup.changed(menuItemColors2)) {
                                }
                                i3 |= i16;
                            } else {
                                menuItemColors2 = menuItemColors;
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i12 = i2 & Fields.SpotShadowColor;
                        if (i12 != 0) {
                            i3 |= 12582912;
                        } else if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(paddingValues)) {
                                i13 = 8388608;
                            } else {
                                i13 = 4194304;
                            }
                            i3 |= i13;
                        }
                        i14 = i2 & Fields.RotationX;
                        if (i14 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                i15 = 67108864;
                            } else {
                                i15 = 33554432;
                            }
                            i3 |= i15;
                        }
                        if ((i3 & 38347923) == 38347922) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
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

                                public final void invoke(Composer composer2, int i17) {
                                    AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    z2 = z;
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function6 = function4;
                i10 = i2 & 32;
                if (i10 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = Fields.RenderEffect;
                        } else {
                            i11 = 65536;
                        }
                        i3 |= i11;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        function6 = function4;
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 32;
                    if (i10 != 0) {
                        if ((196608 & i) == 0) {
                            z2 = z;
                            if (composerStartRestartGroup.changed(z2)) {
                                i11 = Fields.RenderEffect;
                            } else {
                                i11 = 65536;
                            }
                            i3 |= i11;
                        }
                        if ((1572864 & i) == 0) {
                            if ((i2 & 64) == 0) {
                                menuItemColors2 = menuItemColors;
                                if (composerStartRestartGroup.changed(menuItemColors2)) {
                                }
                                i3 |= i16;
                            } else {
                                menuItemColors2 = menuItemColors;
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i12 = i2 & Fields.SpotShadowColor;
                        if (i12 != 0) {
                            i3 |= 12582912;
                        } else if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(paddingValues)) {
                                i13 = 8388608;
                            } else {
                                i13 = 4194304;
                            }
                            i3 |= i13;
                        }
                        i14 = i2 & Fields.RotationX;
                        if (i14 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                i15 = 67108864;
                            } else {
                                i15 = 33554432;
                            }
                            i3 |= i15;
                        }
                        if ((i3 & 38347923) == 38347922) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
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

                                public final void invoke(Composer composer2, int i17) {
                                    AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    z2 = z;
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function6 = function4;
                i10 = i2 & 32;
                if (i10 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = Fields.RenderEffect;
                        } else {
                            i11 = 65536;
                        }
                        i3 |= i11;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function5 = function3;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    function6 = function4;
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 32;
                if (i10 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = Fields.RenderEffect;
                        } else {
                            i11 = 65536;
                        }
                        i3 |= i11;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function6 = function4;
            i10 = i2 & 32;
            if (i10 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = Fields.RenderEffect;
                    } else {
                        i11 = 65536;
                    }
                    i3 |= i11;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    menuItemColors2 = menuItemColors;
                    if (composerStartRestartGroup.changed(menuItemColors2)) {
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i3 |= i16;
            } else {
                menuItemColors2 = menuItemColors;
            }
            i12 = i2 & Fields.SpotShadowColor;
            if (i12 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(paddingValues)) {
                    i13 = 8388608;
                } else {
                    i13 = 4194304;
                }
                i3 |= i13;
            }
            i14 = i2 & Fields.RotationX;
            if (i14 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i15 = 67108864;
                } else {
                    i15 = 33554432;
                }
                i3 |= i15;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
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

                    public final void invoke(Composer composer2, int i17) {
                        AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        i4 = i2 & 4;
        if (i4 != 0) {
            if ((i & 384) == 0) {
                if (composerStartRestartGroup.changed(modifier)) {
                    i5 = Fields.RotationX;
                } else {
                    i5 = Fields.SpotShadowColor;
                }
                i3 |= i5;
            }
            i6 = i2 & 8;
            if (i6 != 0) {
                if ((i & 3072) == 0) {
                    function5 = function3;
                    if (composerStartRestartGroup.changedInstance(function5)) {
                        i7 = Fields.CameraDistance;
                    } else {
                        i7 = Fields.RotationZ;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 16;
                if (i8 != 0) {
                    if ((i & 24576) == 0) {
                        function6 = function4;
                        if (composerStartRestartGroup.changedInstance(function6)) {
                            i9 = Fields.Clip;
                        } else {
                            i9 = Fields.Shape;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 32;
                    if (i10 != 0) {
                        if ((196608 & i) == 0) {
                            z2 = z;
                            if (composerStartRestartGroup.changed(z2)) {
                                i11 = Fields.RenderEffect;
                            } else {
                                i11 = 65536;
                            }
                            i3 |= i11;
                        }
                        if ((1572864 & i) == 0) {
                            if ((i2 & 64) == 0) {
                                menuItemColors2 = menuItemColors;
                                if (composerStartRestartGroup.changed(menuItemColors2)) {
                                }
                                i3 |= i16;
                            } else {
                                menuItemColors2 = menuItemColors;
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i12 = i2 & Fields.SpotShadowColor;
                        if (i12 != 0) {
                            i3 |= 12582912;
                        } else if ((i & 12582912) == 0) {
                            if (composerStartRestartGroup.changed(paddingValues)) {
                                i13 = 8388608;
                            } else {
                                i13 = 4194304;
                            }
                            i3 |= i13;
                        }
                        i14 = i2 & Fields.RotationX;
                        if (i14 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                i15 = 67108864;
                            } else {
                                i15 = 33554432;
                            }
                            i3 |= i15;
                        }
                        if ((i3 & 38347923) == 38347922) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            } else {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if (i6 != 0) {
                                    function5 = null;
                                }
                                if (i8 != 0) {
                                    function6 = null;
                                }
                                if (i10 != 0) {
                                    z3 = true;
                                } else {
                                    z3 = z2;
                                }
                                if ((i2 & 64) != 0) {
                                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    menuItemColorsItemColors = menuItemColors2;
                                }
                                if (i12 != 0) {
                                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                                } else {
                                    dropdownMenuItemContentPadding = paddingValues;
                                }
                                if (i14 == 0) {
                                }
                                paddingValues2 = dropdownMenuItemContentPadding;
                                function7 = function6;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                            }
                            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier2 = companion;
                            z4 = z3;
                            function8 = function5;
                            menuItemColors3 = menuItemColorsItemColors;
                            paddingValues3 = paddingValues2;
                            mutableInteractionSource3 = mutableInteractionSource2;
                            function9 = function7;
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

                                public final void invoke(Composer composer2, int i17) {
                                    AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    z2 = z;
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                function6 = function4;
                i10 = i2 & 32;
                if (i10 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = Fields.RenderEffect;
                        } else {
                            i11 = 65536;
                        }
                        i3 |= i11;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            function5 = function3;
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    function6 = function4;
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 32;
                if (i10 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = Fields.RenderEffect;
                        } else {
                            i11 = 65536;
                        }
                        i3 |= i11;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function6 = function4;
            i10 = i2 & 32;
            if (i10 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = Fields.RenderEffect;
                    } else {
                        i11 = 65536;
                    }
                    i3 |= i11;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    menuItemColors2 = menuItemColors;
                    if (composerStartRestartGroup.changed(menuItemColors2)) {
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i3 |= i16;
            } else {
                menuItemColors2 = menuItemColors;
            }
            i12 = i2 & Fields.SpotShadowColor;
            if (i12 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(paddingValues)) {
                    i13 = 8388608;
                } else {
                    i13 = 4194304;
                }
                i3 |= i13;
            }
            i14 = i2 & Fields.RotationX;
            if (i14 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i15 = 67108864;
                } else {
                    i15 = 33554432;
                }
                i3 |= i15;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
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

                    public final void invoke(Composer composer2, int i17) {
                        AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        i6 = i2 & 8;
        if (i6 != 0) {
            if ((i & 3072) == 0) {
                function5 = function3;
                if (composerStartRestartGroup.changedInstance(function5)) {
                    i7 = Fields.CameraDistance;
                } else {
                    i7 = Fields.RotationZ;
                }
                i3 |= i7;
            }
            i8 = i2 & 16;
            if (i8 != 0) {
                if ((i & 24576) == 0) {
                    function6 = function4;
                    if (composerStartRestartGroup.changedInstance(function6)) {
                        i9 = Fields.Clip;
                    } else {
                        i9 = Fields.Shape;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 32;
                if (i10 != 0) {
                    if ((196608 & i) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = Fields.RenderEffect;
                        } else {
                            i11 = 65536;
                        }
                        i3 |= i11;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            menuItemColors2 = menuItemColors;
                            if (composerStartRestartGroup.changed(menuItemColors2)) {
                            }
                            i3 |= i16;
                        } else {
                            menuItemColors2 = menuItemColors;
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i12 = i2 & Fields.SpotShadowColor;
                    if (i12 != 0) {
                        i3 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(paddingValues)) {
                            i13 = 8388608;
                        } else {
                            i13 = 4194304;
                        }
                        i3 |= i13;
                    }
                    i14 = i2 & Fields.RotationX;
                    if (i14 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i15 = 67108864;
                        } else {
                            i15 = 33554432;
                        }
                        i3 |= i15;
                    }
                    if ((i3 & 38347923) == 38347922) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i6 != 0) {
                                function5 = null;
                            }
                            if (i8 != 0) {
                                function6 = null;
                            }
                            if (i10 != 0) {
                                z3 = true;
                            } else {
                                z3 = z2;
                            }
                            if ((i2 & 64) != 0) {
                                menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                menuItemColorsItemColors = menuItemColors2;
                            }
                            if (i12 != 0) {
                                dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                            } else {
                                dropdownMenuItemContentPadding = paddingValues;
                            }
                            if (i14 == 0) {
                            }
                            paddingValues2 = dropdownMenuItemContentPadding;
                            function7 = function6;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                        }
                        MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier2 = companion;
                        z4 = z3;
                        function8 = function5;
                        menuItemColors3 = menuItemColorsItemColors;
                        paddingValues3 = paddingValues2;
                        mutableInteractionSource3 = mutableInteractionSource2;
                        function9 = function7;
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

                            public final void invoke(Composer composer2, int i17) {
                                AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                z2 = z;
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            function6 = function4;
            i10 = i2 & 32;
            if (i10 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = Fields.RenderEffect;
                    } else {
                        i11 = 65536;
                    }
                    i3 |= i11;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    menuItemColors2 = menuItemColors;
                    if (composerStartRestartGroup.changed(menuItemColors2)) {
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i3 |= i16;
            } else {
                menuItemColors2 = menuItemColors;
            }
            i12 = i2 & Fields.SpotShadowColor;
            if (i12 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(paddingValues)) {
                    i13 = 8388608;
                } else {
                    i13 = 4194304;
                }
                i3 |= i13;
            }
            i14 = i2 & Fields.RotationX;
            if (i14 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i15 = 67108864;
                } else {
                    i15 = 33554432;
                }
                i3 |= i15;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
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

                    public final void invoke(Composer composer2, int i17) {
                        AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        function5 = function3;
        i8 = i2 & 16;
        if (i8 != 0) {
            if ((i & 24576) == 0) {
                function6 = function4;
                if (composerStartRestartGroup.changedInstance(function6)) {
                    i9 = Fields.Clip;
                } else {
                    i9 = Fields.Shape;
                }
                i3 |= i9;
            }
            i10 = i2 & 32;
            if (i10 != 0) {
                if ((196608 & i) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = Fields.RenderEffect;
                    } else {
                        i11 = 65536;
                    }
                    i3 |= i11;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        menuItemColors2 = menuItemColors;
                        if (composerStartRestartGroup.changed(menuItemColors2)) {
                        }
                        i3 |= i16;
                    } else {
                        menuItemColors2 = menuItemColors;
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i12 = i2 & Fields.SpotShadowColor;
                if (i12 != 0) {
                    i3 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i13 = 8388608;
                    } else {
                        i13 = 4194304;
                    }
                    i3 |= i13;
                }
                i14 = i2 & Fields.RotationX;
                if (i14 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i15 = 67108864;
                    } else {
                        i15 = 33554432;
                    }
                    i3 |= i15;
                }
                if ((i3 & 38347923) == 38347922) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i6 != 0) {
                            function5 = null;
                        }
                        if (i8 != 0) {
                            function6 = null;
                        }
                        if (i10 != 0) {
                            z3 = true;
                        } else {
                            z3 = z2;
                        }
                        if ((i2 & 64) != 0) {
                            menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            menuItemColorsItemColors = menuItemColors2;
                        }
                        if (i12 != 0) {
                            dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                        } else {
                            dropdownMenuItemContentPadding = paddingValues;
                        }
                        if (i14 == 0) {
                        }
                        paddingValues2 = dropdownMenuItemContentPadding;
                        function7 = function6;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                    }
                    MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier2 = companion;
                    z4 = z3;
                    function8 = function5;
                    menuItemColors3 = menuItemColorsItemColors;
                    paddingValues3 = paddingValues2;
                    mutableInteractionSource3 = mutableInteractionSource2;
                    function9 = function7;
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

                        public final void invoke(Composer composer2, int i17) {
                            AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            z2 = z;
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    menuItemColors2 = menuItemColors;
                    if (composerStartRestartGroup.changed(menuItemColors2)) {
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i3 |= i16;
            } else {
                menuItemColors2 = menuItemColors;
            }
            i12 = i2 & Fields.SpotShadowColor;
            if (i12 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(paddingValues)) {
                    i13 = 8388608;
                } else {
                    i13 = 4194304;
                }
                i3 |= i13;
            }
            i14 = i2 & Fields.RotationX;
            if (i14 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i15 = 67108864;
                } else {
                    i15 = 33554432;
                }
                i3 |= i15;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
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

                    public final void invoke(Composer composer2, int i17) {
                        AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        function6 = function4;
        i10 = i2 & 32;
        if (i10 != 0) {
            if ((196608 & i) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = Fields.RenderEffect;
                } else {
                    i11 = 65536;
                }
                i3 |= i11;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    menuItemColors2 = menuItemColors;
                    if (composerStartRestartGroup.changed(menuItemColors2)) {
                    }
                    i3 |= i16;
                } else {
                    menuItemColors2 = menuItemColors;
                }
                i3 |= i16;
            } else {
                menuItemColors2 = menuItemColors;
            }
            i12 = i2 & Fields.SpotShadowColor;
            if (i12 != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(paddingValues)) {
                    i13 = 8388608;
                } else {
                    i13 = 4194304;
                }
                i3 |= i13;
            }
            i14 = i2 & Fields.RotationX;
            if (i14 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i15 = 67108864;
                } else {
                    i15 = 33554432;
                }
                i3 |= i15;
            }
            if ((i3 & 38347923) == 38347922) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i6 != 0) {
                        function5 = null;
                    }
                    if (i8 != 0) {
                        function6 = null;
                    }
                    if (i10 != 0) {
                        z3 = true;
                    } else {
                        z3 = z2;
                    }
                    if ((i2 & 64) != 0) {
                        menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        menuItemColorsItemColors = menuItemColors2;
                    }
                    if (i12 != 0) {
                        dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                    } else {
                        dropdownMenuItemContentPadding = paddingValues;
                    }
                    if (i14 == 0) {
                    }
                    paddingValues2 = dropdownMenuItemContentPadding;
                    function7 = function6;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
                }
                MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier2 = companion;
                z4 = z3;
                function8 = function5;
                menuItemColors3 = menuItemColorsItemColors;
                paddingValues3 = paddingValues2;
                mutableInteractionSource3 = mutableInteractionSource2;
                function9 = function7;
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

                    public final void invoke(Composer composer2, int i17) {
                        AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        z2 = z;
        if ((1572864 & i) == 0) {
            if ((i2 & 64) == 0) {
                menuItemColors2 = menuItemColors;
                if (composerStartRestartGroup.changed(menuItemColors2)) {
                }
                i3 |= i16;
            } else {
                menuItemColors2 = menuItemColors;
            }
            i3 |= i16;
        } else {
            menuItemColors2 = menuItemColors;
        }
        i12 = i2 & Fields.SpotShadowColor;
        if (i12 != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(paddingValues)) {
                i13 = 8388608;
            } else {
                i13 = 4194304;
            }
            i3 |= i13;
        }
        i14 = i2 & Fields.RotationX;
        if (i14 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i15 = 67108864;
            } else {
                i15 = 33554432;
            }
            i3 |= i15;
        }
        if ((i3 & 38347923) == 38347922) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i6 != 0) {
                    function5 = null;
                }
                if (i8 != 0) {
                    function6 = null;
                }
                if (i10 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if ((i2 & 64) != 0) {
                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    menuItemColorsItemColors = menuItemColors2;
                }
                if (i12 != 0) {
                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                } else {
                    dropdownMenuItemContentPadding = paddingValues;
                }
                if (i14 == 0) {
                }
                paddingValues2 = dropdownMenuItemContentPadding;
                function7 = function6;
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i6 != 0) {
                    function5 = null;
                }
                if (i8 != 0) {
                    function6 = null;
                }
                if (i10 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if ((i2 & 64) != 0) {
                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    menuItemColorsItemColors = menuItemColors2;
                }
                if (i12 != 0) {
                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                } else {
                    dropdownMenuItemContentPadding = paddingValues;
                }
                if (i14 == 0) {
                }
                paddingValues2 = dropdownMenuItemContentPadding;
                function7 = function6;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
            }
            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            z4 = z3;
            function8 = function5;
            menuItemColors3 = menuItemColorsItemColors;
            paddingValues3 = paddingValues2;
            mutableInteractionSource3 = mutableInteractionSource2;
            function9 = function7;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i6 != 0) {
                    function5 = null;
                }
                if (i8 != 0) {
                    function6 = null;
                }
                if (i10 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if ((i2 & 64) != 0) {
                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    menuItemColorsItemColors = menuItemColors2;
                }
                if (i12 != 0) {
                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                } else {
                    dropdownMenuItemContentPadding = paddingValues;
                }
                if (i14 == 0) {
                }
                paddingValues2 = dropdownMenuItemContentPadding;
                function7 = function6;
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i6 != 0) {
                    function5 = null;
                }
                if (i8 != 0) {
                    function6 = null;
                }
                if (i10 != 0) {
                    z3 = true;
                } else {
                    z3 = z2;
                }
                if ((i2 & 64) != 0) {
                    menuItemColorsItemColors = MenuDefaults.INSTANCE.itemColors(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    menuItemColorsItemColors = menuItemColors2;
                }
                if (i12 != 0) {
                    dropdownMenuItemContentPadding = MenuDefaults.INSTANCE.getDropdownMenuItemContentPadding();
                } else {
                    dropdownMenuItemContentPadding = paddingValues;
                }
                if (i14 == 0) {
                }
                paddingValues2 = dropdownMenuItemContentPadding;
                function7 = function6;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1826340448, i3, -1, "androidx.compose.material3.DropdownMenuItem (AndroidMenu.android.kt:179)");
            }
            MenuKt.DropdownMenuItemContent(function2, function0, companion, function5, function7, z3, menuItemColorsItemColors, paddingValues2, mutableInteractionSource2, composerStartRestartGroup, i3 & 268435454);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier2 = companion;
            z4 = z3;
            function8 = function5;
            menuItemColors3 = menuItemColorsItemColors;
            paddingValues3 = paddingValues2;
            mutableInteractionSource3 = mutableInteractionSource2;
            function9 = function7;
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

                public final void invoke(Composer composer2, int i17) {
                    AndroidMenu_androidKt.DropdownMenuItem(function2, function0, modifier2, function8, function9, z4, menuItemColors3, paddingValues3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final PopupProperties getDefaultMenuProperties() {
        return DefaultMenuProperties;
    }
}
