package androidx.compose.material3;

import android.view.View;
import androidx.compose.animation.core.MutableTransitionState;
import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.ScrollKt;
import androidx.compose.foundation.ScrollState;
import androidx.compose.foundation.layout.ColumnScope;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.foundation.layout.WindowInsets_androidKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.TransformOrigin;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntRect;
import androidx.compose.ui.window.AndroidPopup_androidKt;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000h\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\b7\u0018\u00002\u00020\u0001B\u0007\b\u0004¢\u0006\u0002\u0010\u0002JU\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\b0\u0012¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007¢\u0006\u0002\u0010\u0016J\u0098\u0001\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0017\u001a\u00020\n2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001d2\n\b\u0002\u0010\u001f\u001a\u0004\u0018\u00010 2\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\b0\u0012¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b!\u0010\"J¢\u0001\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010#\u001a\u00020\n2\b\b\u0002\u0010\u0017\u001a\u00020\n2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u001e\u001a\u00020\u001d2\n\b\u0002\u0010\u001f\u001a\u0004\u0018\u00010 2\u001c\u0010\u0011\u001a\u0018\u0012\u0004\u0012\u00020\u0013\u0012\u0004\u0012\u00020\b0\u0012¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007ø\u0001\u0000¢\u0006\u0004\b$\u0010%J\u0016\u0010&\u001a\u00020\u000e*\u00020\u000e2\b\b\u0002\u0010\u0017\u001a\u00020\nH&J\f\u0010'\u001a\u00020\u000e*\u00020\u000eH\u0007J(\u0010'\u001a\u00020\u000e*\u00020\u000e2\u0006\u0010(\u001a\u00020\u00042\b\b\u0002\u0010)\u001a\u00020\nH&ø\u0001\u0000¢\u0006\u0004\b*\u0010+R\u0018\u0010\u0003\u001a\u00020\u0004X \u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u0001,\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006-"}, d2 = {"Landroidx/compose/material3/ExposedDropdownMenuBoxScope;", "", "()V", "anchorType", "Landroidx/compose/material3/MenuAnchorType;", "getAnchorType-Mg6Rgbw$material3_release", "()Ljava/lang/String;", "ExposedDropdownMenu", "", "expanded", "", "onDismissRequest", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "scrollState", "Landroidx/compose/foundation/ScrollState;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/ColumnScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/ScrollState;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "matchTextFieldWidth", "shape", "Landroidx/compose/ui/graphics/Shape;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "tonalElevation", "Landroidx/compose/ui/unit/Dp;", "shadowElevation", "border", "Landroidx/compose/foundation/BorderStroke;", "ExposedDropdownMenu-vNxi1II", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/ScrollState;ZLandroidx/compose/ui/graphics/Shape;JFFLandroidx/compose/foundation/BorderStroke;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;III)V", "focusable", "ExposedDropdownMenu-kbRbctU", "(ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/ScrollState;ZZLandroidx/compose/ui/graphics/Shape;JFFLandroidx/compose/foundation/BorderStroke;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;III)V", "exposedDropdownSize", "menuAnchor", "type", "enabled", "menuAnchor-fsE2BvY", "(Landroidx/compose/ui/Modifier;Ljava/lang/String;Z)Landroidx/compose/ui/Modifier;", "Landroidx/compose/material3/ExposedDropdownMenuBoxScopeImpl;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class ExposedDropdownMenuBoxScope {
    public static final int $stable = 0;

    public ExposedDropdownMenuBoxScope(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    public abstract Modifier exposedDropdownSize(Modifier modifier, boolean z);

    public abstract String mo2358getAnchorTypeMg6Rgbw$material3_release();

    public abstract Modifier mo2359menuAnchorfsE2BvY(Modifier modifier, String str, boolean z);

    private ExposedDropdownMenuBoxScope() {
    }

    public static Modifier m2355menuAnchorfsE2BvY$default(ExposedDropdownMenuBoxScope exposedDropdownMenuBoxScope, Modifier modifier, String str, boolean z, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: menuAnchor-fsE2BvY");
        }
        if ((i & 2) != 0) {
            z = true;
        }
        return exposedDropdownMenuBoxScope.mo2359menuAnchorfsE2BvY(modifier, str, z);
    }

    public static Modifier exposedDropdownSize$default(ExposedDropdownMenuBoxScope exposedDropdownMenuBoxScope, Modifier modifier, boolean z, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: exposedDropdownSize");
        }
        if ((i & 1) != 0) {
            z = true;
        }
        return exposedDropdownMenuBoxScope.exposedDropdownSize(modifier, z);
    }

    public final void m2357ExposedDropdownMenuvNxi1II(final boolean z, final Function0<Unit> function0, Modifier modifier, ScrollState scrollState, boolean z2, Shape shape, long j, float f, float f2, BorderStroke borderStroke, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        int i5;
        Modifier modifier2;
        int i6;
        ScrollState scrollState2;
        int i7;
        boolean z3;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        Modifier.Companion companion;
        ScrollState scrollStateRememberScrollState;
        int i19;
        Shape shape2;
        long containerColor;
        float fM2514getTonalElevationD9Ej5fM;
        float fM2513getShadowElevationD9Ej5fM;
        BorderStroke borderStroke2;
        int i20;
        long j2;
        Object objRememberedValue;
        final MutableState mutableState;
        int i21;
        View view;
        final BorderStroke borderStroke3;
        Density density;
        int top;
        Object objRememberedValue2;
        final MutableTransitionState mutableTransitionState;
        Object objRememberedValue3;
        final MutableState mutableState2;
        boolean zChanged;
        Object objRememberedValue4;
        final BorderStroke borderStroke4;
        final float f3;
        final boolean z4;
        final float f4;
        final ScrollState scrollState3;
        final Modifier modifier3;
        final Shape shape3;
        final long j3;
        Object objRememberedValue5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i22;
        int i23;
        int i24;
        Composer composerStartRestartGroup = composer.startRestartGroup(720925481);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ExposedDropdownMenu)P(3,6,5,7,4,9,1:c#ui.graphics.Color,10:c#ui.unit.Dp,8:c#ui.unit.Dp)336@15550L21,338@15654L5,339@15706L14,347@16155L53,348@16238L7,349@16281L7,350@16332L10,357@16596L42,361@16795L51,363@16903L486,377@17583L27,378@17626L587,374@17403L810:ExposedDropdownMenu.android.kt#uh7d8r");
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
                if ((i & 3072) == 0) {
                    if ((i3 & 8) == 0) {
                        scrollState2 = scrollState;
                        if (composerStartRestartGroup.changed(scrollState2)) {
                            i24 = Fields.CameraDistance;
                        }
                        i4 |= i24;
                    } else {
                        scrollState2 = scrollState;
                    }
                    i24 = Fields.RotationZ;
                    i4 |= i24;
                } else {
                    scrollState2 = scrollState;
                }
                i7 = i3 & 16;
                if (i7 != 0) {
                    if ((i & 24576) == 0) {
                        z3 = z2;
                        if (composerStartRestartGroup.changed(z3)) {
                            i8 = Fields.Clip;
                        } else {
                            i8 = Fields.Shape;
                        }
                        i4 |= i8;
                    }
                    if ((i & 196608) != 0) {
                        if ((i3 & 32) == 0 || !composerStartRestartGroup.changed(shape)) {
                            i23 = 65536;
                        } else {
                            i23 = Fields.RenderEffect;
                        }
                        i4 |= i23;
                    }
                    if ((i & 1572864) != 0) {
                        if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(j)) {
                            i22 = 524288;
                        } else {
                            i22 = 1048576;
                        }
                        i4 |= i22;
                    }
                    i9 = i3 & Fields.SpotShadowColor;
                    if (i9 != 0) {
                        i4 |= 12582912;
                    } else if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(f)) {
                            i10 = 8388608;
                        } else {
                            i10 = 4194304;
                        }
                        i4 |= i10;
                    }
                    i11 = i3 & Fields.RotationX;
                    if (i11 != 0) {
                        i4 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(f2)) {
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
                        if (composerStartRestartGroup.changed(borderStroke)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i4 |= i14;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i15 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 4;
                        } else {
                            i16 = 2;
                        }
                        i15 = i2 | i16;
                    } else {
                        i15 = i2;
                    }
                    if ((i3 & Fields.CameraDistance) != 0) {
                        i15 |= 48;
                    } else if ((i2 & 48) != 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i17 = 32;
                        } else {
                            i17 = 16;
                        }
                        i15 |= i17;
                    }
                    i18 = i15;
                    if ((i4 & 306783379) == 306783378 || (i18 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i5 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if ((i3 & 8) != 0) {
                                scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                                i4 &= -7169;
                            } else {
                                scrollStateRememberScrollState = scrollState2;
                            }
                            if (i7 != 0) {
                                z3 = true;
                            }
                            if ((i3 & 32) != 0) {
                                i19 = 6;
                                shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i4 &= -458753;
                            } else {
                                i19 = 6;
                                shape2 = shape;
                            }
                            if ((i3 & 64) != 0) {
                                containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                                i4 &= -3670017;
                            } else {
                                containerColor = j;
                            }
                            if (i9 != 0) {
                                fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                            } else {
                                fM2514getTonalElevationD9Ej5fM = f;
                            }
                            if (i11 != 0) {
                                fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                            } else {
                                fM2513getShadowElevationD9Ej5fM = f2;
                            }
                            if (i13 != 0) {
                                i20 = i4;
                                j2 = containerColor;
                                borderStroke2 = null;
                            } else {
                                borderStroke2 = borderStroke;
                                i20 = i4;
                                j2 = containerColor;
                            }
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i3 & 8) != 0) {
                                i4 &= -7169;
                            }
                            if ((i3 & 32) != 0) {
                                i4 &= -458753;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                            }
                            shape2 = shape;
                            fM2514getTonalElevationD9Ej5fM = f;
                            fM2513getShadowElevationD9Ej5fM = f2;
                            i20 = i4;
                            companion = modifier2;
                            scrollStateRememberScrollState = scrollState2;
                            j2 = j;
                            borderStroke2 = borderStroke;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        mutableState = (MutableState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<View> localView = AndroidCompositionLocals_androidKt.getLocalView();
                        i21 = i20;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume = composerStartRestartGroup.consume(localView);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        view = (View) objConsume;
                        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
                        borderStroke3 = borderStroke2;
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume2 = composerStartRestartGroup.consume(localDensity);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        density = (Density) objConsume2;
                        top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                        composerStartRestartGroup.startReplaceGroup(321499814);
                        ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                        if (z) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                            objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue5 = (Function0) new Function0<Unit>() {
                                    {
                                        super(0);
                                    }

                                    public Object invoke() {
                                        m2360invoke();
                                        return Unit.INSTANCE;
                                    }

                                    public final void m2360invoke() {
                                        mutableState.setValue(Unit.INSTANCE);
                                    }
                                };
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                        }
                        composerStartRestartGroup.endReplaceGroup();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = new MutableTransitionState(false);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                        }
                        mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                        if (!((Boolean) mutableTransitionState.getCurrentState()).booleanValue() || ((Boolean) mutableTransitionState.getTargetState()).booleanValue()) {
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            mutableState2 = (MutableState) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                            objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((IntRect) obj, (IntRect) obj2);
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(IntRect intRect, IntRect intRect2) {
                                        mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                    }
                                }, 8, null);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            final Modifier modifier4 = companion;
                            final boolean z5 = z3;
                            final ScrollState scrollState4 = scrollStateRememberScrollState;
                            final Shape shape4 = shape2;
                            final long j4 = j2;
                            final float f5 = fM2514getTonalElevationD9Ej5fM;
                            final float f6 = fM2513getShadowElevationD9Ej5fM;
                            AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i25) {
                                    ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                    if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                        }
                                        MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier4, z5), mutableTransitionState, mutableState2, scrollState4, shape4, j4, f5, f6, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer2.skipToGroupEnd();
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                        } else {
                            fM2513getShadowElevationD9Ej5fM = fM2513getShadowElevationD9Ej5fM;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        borderStroke4 = borderStroke3;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z4 = z3;
                        ScrollState scrollState5 = scrollStateRememberScrollState;
                        f4 = fM2514getTonalElevationD9Ej5fM;
                        scrollState3 = scrollState5;
                        modifier3 = companion;
                        shape3 = shape2;
                        j3 = j2;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        shape3 = shape;
                        j3 = j;
                        borderStroke4 = borderStroke;
                        modifier3 = modifier2;
                        scrollState3 = scrollState2;
                        z4 = z3;
                        f4 = f;
                        f3 = f2;
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

                            public final void invoke(Composer composer2, int i25) {
                                ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 24576;
                z3 = z2;
                if ((i & 196608) != 0) {
                    if ((i3 & 32) == 0) {
                        i23 = 65536;
                    } else {
                        i23 = 65536;
                    }
                    i4 |= i23;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i22 = 524288;
                    } else {
                        i22 = 524288;
                    }
                    i4 |= i22;
                }
                i9 = i3 & Fields.SpotShadowColor;
                if (i9 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i10 = 8388608;
                    } else {
                        i10 = 4194304;
                    }
                    i4 |= i10;
                }
                i11 = i3 & Fields.RotationX;
                if (i11 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
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
                    if (composerStartRestartGroup.changed(borderStroke)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i4 |= i14;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i15 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 4;
                    } else {
                        i16 = 2;
                    }
                    i15 = i2 | i16;
                } else {
                    i15 = i2;
                }
                if ((i3 & Fields.CameraDistance) != 0) {
                    i15 |= 48;
                } else if ((i2 & 48) != 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i17 = 32;
                    } else {
                        i17 = 16;
                    }
                    i15 |= i17;
                }
                i18 = i15;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<View> localView2 = AndroidCompositionLocals_androidKt.getLocalView();
                    i21 = i20;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume3 = composerStartRestartGroup.consume(localView2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    view = (View) objConsume3;
                    ProvidableCompositionLocal<Density> localDensity2 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume4 = composerStartRestartGroup.consume(localDensity2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume4;
                    top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                    composerStartRestartGroup.startReplaceGroup(321499814);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                    if (z) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2360invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2360invoke() {
                                    mutableState.setValue(Unit.INSTANCE);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier5 = companion;
                        final boolean z6 = z3;
                        final ScrollState scrollState6 = scrollStateRememberScrollState;
                        final Shape shape5 = shape2;
                        final long j5 = j2;
                        final float f7 = fM2514getTonalElevationD9Ej5fM;
                        final float f8 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier5, z6), mutableTransitionState, mutableState2, scrollState6, shape5, j5, f7, f8, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    } else {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier6 = companion;
                        final boolean z7 = z3;
                        final ScrollState scrollState7 = scrollStateRememberScrollState;
                        final Shape shape6 = shape2;
                        final long j6 = j2;
                        final float f9 = fM2514getTonalElevationD9Ej5fM;
                        final float f10 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier6, z7), mutableTransitionState, mutableState2, scrollState7, shape6, j6, f9, f10, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z4 = z3;
                    ScrollState scrollState8 = scrollStateRememberScrollState;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    scrollState3 = scrollState8;
                    modifier3 = companion;
                    shape3 = shape2;
                    j3 = j2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<View> localView3 = AndroidCompositionLocals_androidKt.getLocalView();
                    i21 = i20;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localView3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    view = (View) objConsume5;
                    ProvidableCompositionLocal<Density> localDensity3 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume6 = composerStartRestartGroup.consume(localDensity3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume6;
                    top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                    composerStartRestartGroup.startReplaceGroup(321499814);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                    if (z) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2360invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2360invoke() {
                                    mutableState.setValue(Unit.INSTANCE);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier7 = companion;
                        final boolean z8 = z3;
                        final ScrollState scrollState9 = scrollStateRememberScrollState;
                        final Shape shape7 = shape2;
                        final long j7 = j2;
                        final float f11 = fM2514getTonalElevationD9Ej5fM;
                        final float f12 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier7, z8), mutableTransitionState, mutableState2, scrollState9, shape7, j7, f11, f12, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    } else {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier8 = companion;
                        final boolean z9 = z3;
                        final ScrollState scrollState10 = scrollStateRememberScrollState;
                        final Shape shape8 = shape2;
                        final long j8 = j2;
                        final float f13 = fM2514getTonalElevationD9Ej5fM;
                        final float f14 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier8, z9), mutableTransitionState, mutableState2, scrollState10, shape8, j8, f13, f14, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z4 = z3;
                    ScrollState scrollState11 = scrollStateRememberScrollState;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    scrollState3 = scrollState11;
                    modifier3 = companion;
                    shape3 = shape2;
                    j3 = j2;
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

                        public final void invoke(Composer composer2, int i25) {
                            ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 384;
            modifier2 = modifier;
            if ((i & 3072) == 0) {
                if ((i3 & 8) == 0) {
                    scrollState2 = scrollState;
                    if (composerStartRestartGroup.changed(scrollState2)) {
                        i24 = Fields.CameraDistance;
                    }
                    i4 |= i24;
                } else {
                    scrollState2 = scrollState;
                }
                i24 = Fields.RotationZ;
                i4 |= i24;
            } else {
                scrollState2 = scrollState;
            }
            i7 = i3 & 16;
            if (i7 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z2;
                    if (composerStartRestartGroup.changed(z3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i4 |= i8;
                }
                if ((i & 196608) != 0) {
                    if ((i3 & 32) == 0) {
                        i23 = 65536;
                    } else {
                        i23 = 65536;
                    }
                    i4 |= i23;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i22 = 524288;
                    } else {
                        i22 = 524288;
                    }
                    i4 |= i22;
                }
                i9 = i3 & Fields.SpotShadowColor;
                if (i9 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i10 = 8388608;
                    } else {
                        i10 = 4194304;
                    }
                    i4 |= i10;
                }
                i11 = i3 & Fields.RotationX;
                if (i11 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
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
                    if (composerStartRestartGroup.changed(borderStroke)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i4 |= i14;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i15 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 4;
                    } else {
                        i16 = 2;
                    }
                    i15 = i2 | i16;
                } else {
                    i15 = i2;
                }
                if ((i3 & Fields.CameraDistance) != 0) {
                    i15 |= 48;
                } else if ((i2 & 48) != 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i17 = 32;
                    } else {
                        i17 = 16;
                    }
                    i15 |= i17;
                }
                i18 = i15;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<View> localView4 = AndroidCompositionLocals_androidKt.getLocalView();
                    i21 = i20;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume7 = composerStartRestartGroup.consume(localView4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    view = (View) objConsume7;
                    ProvidableCompositionLocal<Density> localDensity4 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localDensity4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume8;
                    top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                    composerStartRestartGroup.startReplaceGroup(321499814);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                    if (z) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2360invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2360invoke() {
                                    mutableState.setValue(Unit.INSTANCE);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier9 = companion;
                        final boolean z10 = z3;
                        final ScrollState scrollState12 = scrollStateRememberScrollState;
                        final Shape shape9 = shape2;
                        final long j9 = j2;
                        final float f15 = fM2514getTonalElevationD9Ej5fM;
                        final float f16 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier9, z10), mutableTransitionState, mutableState2, scrollState12, shape9, j9, f15, f16, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    } else {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier10 = companion;
                        final boolean z11 = z3;
                        final ScrollState scrollState13 = scrollStateRememberScrollState;
                        final Shape shape10 = shape2;
                        final long j10 = j2;
                        final float f17 = fM2514getTonalElevationD9Ej5fM;
                        final float f18 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier10, z11), mutableTransitionState, mutableState2, scrollState13, shape10, j10, f17, f18, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z4 = z3;
                    ScrollState scrollState14 = scrollStateRememberScrollState;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    scrollState3 = scrollState14;
                    modifier3 = companion;
                    shape3 = shape2;
                    j3 = j2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<View> localView5 = AndroidCompositionLocals_androidKt.getLocalView();
                    i21 = i20;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume9 = composerStartRestartGroup.consume(localView5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    view = (View) objConsume9;
                    ProvidableCompositionLocal<Density> localDensity5 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume10 = composerStartRestartGroup.consume(localDensity5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume10;
                    top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                    composerStartRestartGroup.startReplaceGroup(321499814);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                    if (z) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2360invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2360invoke() {
                                    mutableState.setValue(Unit.INSTANCE);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier11 = companion;
                        final boolean z12 = z3;
                        final ScrollState scrollState15 = scrollStateRememberScrollState;
                        final Shape shape11 = shape2;
                        final long j11 = j2;
                        final float f19 = fM2514getTonalElevationD9Ej5fM;
                        final float f110 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier11, z12), mutableTransitionState, mutableState2, scrollState15, shape11, j11, f19, f110, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    } else {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier12 = companion;
                        final boolean z13 = z3;
                        final ScrollState scrollState16 = scrollStateRememberScrollState;
                        final Shape shape12 = shape2;
                        final long j12 = j2;
                        final float f111 = fM2514getTonalElevationD9Ej5fM;
                        final float f112 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier12, z13), mutableTransitionState, mutableState2, scrollState16, shape12, j12, f111, f112, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z4 = z3;
                    ScrollState scrollState17 = scrollStateRememberScrollState;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    scrollState3 = scrollState17;
                    modifier3 = companion;
                    shape3 = shape2;
                    j3 = j2;
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

                        public final void invoke(Composer composer2, int i25) {
                            ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            z3 = z2;
            if ((i & 196608) != 0) {
                if ((i3 & 32) == 0) {
                    i23 = 65536;
                } else {
                    i23 = 65536;
                }
                i4 |= i23;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i22 = 524288;
                } else {
                    i22 = 524288;
                }
                i4 |= i22;
            }
            i9 = i3 & Fields.SpotShadowColor;
            if (i9 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i10 = 8388608;
                } else {
                    i10 = 4194304;
                }
                i4 |= i10;
            }
            i11 = i3 & Fields.RotationX;
            if (i11 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
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
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i4 |= i14;
            }
            if ((i3 & Fields.RotationZ) != 0) {
                i15 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 4;
                } else {
                    i16 = 2;
                }
                i15 = i2 | i16;
            } else {
                i15 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i15 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i17 = 32;
                } else {
                    i17 = 16;
                }
                i15 |= i17;
            }
            i18 = i15;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<View> localView6 = AndroidCompositionLocals_androidKt.getLocalView();
                i21 = i20;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11 = composerStartRestartGroup.consume(localView6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume11;
                ProvidableCompositionLocal<Density> localDensity6 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume12 = composerStartRestartGroup.consume(localDensity6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume12;
                top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                composerStartRestartGroup.startReplaceGroup(321499814);
                ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                if (z) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2360invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2360invoke() {
                                mutableState.setValue(Unit.INSTANCE);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier13 = companion;
                    final boolean z14 = z3;
                    final ScrollState scrollState18 = scrollStateRememberScrollState;
                    final Shape shape13 = shape2;
                    final long j13 = j2;
                    final float f113 = fM2514getTonalElevationD9Ej5fM;
                    final float f114 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier13, z14), mutableTransitionState, mutableState2, scrollState18, shape13, j13, f113, f114, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier14 = companion;
                    final boolean z15 = z3;
                    final ScrollState scrollState19 = scrollStateRememberScrollState;
                    final Shape shape14 = shape2;
                    final long j14 = j2;
                    final float f115 = fM2514getTonalElevationD9Ej5fM;
                    final float f116 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier14, z15), mutableTransitionState, mutableState2, scrollState19, shape14, j14, f115, f116, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                z4 = z3;
                ScrollState scrollState110 = scrollStateRememberScrollState;
                f4 = fM2514getTonalElevationD9Ej5fM;
                scrollState3 = scrollState110;
                modifier3 = companion;
                shape3 = shape2;
                j3 = j2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<View> localView7 = AndroidCompositionLocals_androidKt.getLocalView();
                i21 = i20;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume13 = composerStartRestartGroup.consume(localView7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume13;
                ProvidableCompositionLocal<Density> localDensity7 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume14 = composerStartRestartGroup.consume(localDensity7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume14;
                top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                composerStartRestartGroup.startReplaceGroup(321499814);
                ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                if (z) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2360invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2360invoke() {
                                mutableState.setValue(Unit.INSTANCE);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier15 = companion;
                    final boolean z16 = z3;
                    final ScrollState scrollState111 = scrollStateRememberScrollState;
                    final Shape shape15 = shape2;
                    final long j15 = j2;
                    final float f117 = fM2514getTonalElevationD9Ej5fM;
                    final float f118 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier15, z16), mutableTransitionState, mutableState2, scrollState111, shape15, j15, f117, f118, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier16 = companion;
                    final boolean z17 = z3;
                    final ScrollState scrollState112 = scrollStateRememberScrollState;
                    final Shape shape16 = shape2;
                    final long j16 = j2;
                    final float f119 = fM2514getTonalElevationD9Ej5fM;
                    final float f1110 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier16, z17), mutableTransitionState, mutableState2, scrollState112, shape16, j16, f119, f1110, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                z4 = z3;
                ScrollState scrollState113 = scrollStateRememberScrollState;
                f4 = fM2514getTonalElevationD9Ej5fM;
                scrollState3 = scrollState113;
                modifier3 = companion;
                shape3 = shape2;
                j3 = j2;
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

                    public final void invoke(Composer composer2, int i25) {
                        ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
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
            if ((i & 3072) == 0) {
                if ((i3 & 8) == 0) {
                    scrollState2 = scrollState;
                    if (composerStartRestartGroup.changed(scrollState2)) {
                        i24 = Fields.CameraDistance;
                    }
                    i4 |= i24;
                } else {
                    scrollState2 = scrollState;
                }
                i24 = Fields.RotationZ;
                i4 |= i24;
            } else {
                scrollState2 = scrollState;
            }
            i7 = i3 & 16;
            if (i7 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z2;
                    if (composerStartRestartGroup.changed(z3)) {
                        i8 = Fields.Clip;
                    } else {
                        i8 = Fields.Shape;
                    }
                    i4 |= i8;
                }
                if ((i & 196608) != 0) {
                    if ((i3 & 32) == 0) {
                        i23 = 65536;
                    } else {
                        i23 = 65536;
                    }
                    i4 |= i23;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 64) == 0) {
                        i22 = 524288;
                    } else {
                        i22 = 524288;
                    }
                    i4 |= i22;
                }
                i9 = i3 & Fields.SpotShadowColor;
                if (i9 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i10 = 8388608;
                    } else {
                        i10 = 4194304;
                    }
                    i4 |= i10;
                }
                i11 = i3 & Fields.RotationX;
                if (i11 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
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
                    if (composerStartRestartGroup.changed(borderStroke)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i4 |= i14;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i15 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 4;
                    } else {
                        i16 = 2;
                    }
                    i15 = i2 | i16;
                } else {
                    i15 = i2;
                }
                if ((i3 & Fields.CameraDistance) != 0) {
                    i15 |= 48;
                } else if ((i2 & 48) != 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i17 = 32;
                    } else {
                        i17 = 16;
                    }
                    i15 |= i17;
                }
                i18 = i15;
                if ((i4 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<View> localView8 = AndroidCompositionLocals_androidKt.getLocalView();
                    i21 = i20;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume15 = composerStartRestartGroup.consume(localView8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    view = (View) objConsume15;
                    ProvidableCompositionLocal<Density> localDensity8 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume16 = composerStartRestartGroup.consume(localDensity8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume16;
                    top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                    composerStartRestartGroup.startReplaceGroup(321499814);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                    if (z) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2360invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2360invoke() {
                                    mutableState.setValue(Unit.INSTANCE);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier17 = companion;
                        final boolean z18 = z3;
                        final ScrollState scrollState114 = scrollStateRememberScrollState;
                        final Shape shape17 = shape2;
                        final long j17 = j2;
                        final float f1111 = fM2514getTonalElevationD9Ej5fM;
                        final float f1112 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier17, z18), mutableTransitionState, mutableState2, scrollState114, shape17, j17, f1111, f1112, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    } else {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier18 = companion;
                        final boolean z19 = z3;
                        final ScrollState scrollState115 = scrollStateRememberScrollState;
                        final Shape shape18 = shape2;
                        final long j18 = j2;
                        final float f1113 = fM2514getTonalElevationD9Ej5fM;
                        final float f1114 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier18, z19), mutableTransitionState, mutableState2, scrollState115, shape18, j18, f1113, f1114, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z4 = z3;
                    ScrollState scrollState116 = scrollStateRememberScrollState;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    scrollState3 = scrollState116;
                    modifier3 = companion;
                    shape3 = shape2;
                    j3 = j2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState2;
                        }
                        if (i7 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            i19 = 6;
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -458753;
                        } else {
                            i19 = 6;
                            shape2 = shape;
                        }
                        if ((i3 & 64) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                            i4 &= -3670017;
                        } else {
                            containerColor = j;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i20 = i4;
                            j2 = containerColor;
                            borderStroke2 = null;
                        } else {
                            borderStroke2 = borderStroke;
                            i20 = i4;
                            j2 = containerColor;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    mutableState = (MutableState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<View> localView9 = AndroidCompositionLocals_androidKt.getLocalView();
                    i21 = i20;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume17 = composerStartRestartGroup.consume(localView9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    view = (View) objConsume17;
                    ProvidableCompositionLocal<Density> localDensity9 = CompositionLocalsKt.getLocalDensity();
                    borderStroke3 = borderStroke2;
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume18 = composerStartRestartGroup.consume(localDensity9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    density = (Density) objConsume18;
                    top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                    composerStartRestartGroup.startReplaceGroup(321499814);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                    if (z) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue5 = (Function0) new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                public Object invoke() {
                                    m2360invoke();
                                    return Unit.INSTANCE;
                                }

                                public final void m2360invoke() {
                                    mutableState.setValue(Unit.INSTANCE);
                                }
                            };
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue2 = new MutableTransitionState(false);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                    }
                    mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                    if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier19 = companion;
                        final boolean z110 = z3;
                        final ScrollState scrollState117 = scrollStateRememberScrollState;
                        final Shape shape19 = shape2;
                        final long j19 = j2;
                        final float f1115 = fM2514getTonalElevationD9Ej5fM;
                        final float f1116 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier19, z110), mutableTransitionState, mutableState2, scrollState117, shape19, j19, f1115, f1116, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    } else {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        mutableState2 = (MutableState) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                        objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        } else {
                            objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((IntRect) obj, (IntRect) obj2);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(IntRect intRect, IntRect intRect2) {
                                    mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                                }
                            }, 8, null);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        final Modifier modifier110 = companion;
                        final boolean z111 = z3;
                        final ScrollState scrollState118 = scrollStateRememberScrollState;
                        final Shape shape110 = shape2;
                        final long j110 = j2;
                        final float f1117 = fM2514getTonalElevationD9Ej5fM;
                        final float f1118 = fM2513getShadowElevationD9Ej5fM;
                        AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i25) {
                                ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                                if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                    }
                                    MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier110, z111), mutableTransitionState, mutableState2, scrollState118, shape110, j110, f1117, f1118, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer2.skipToGroupEnd();
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke4 = borderStroke3;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z4 = z3;
                    ScrollState scrollState119 = scrollStateRememberScrollState;
                    f4 = fM2514getTonalElevationD9Ej5fM;
                    scrollState3 = scrollState119;
                    modifier3 = companion;
                    shape3 = shape2;
                    j3 = j2;
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

                        public final void invoke(Composer composer2, int i25) {
                            ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            z3 = z2;
            if ((i & 196608) != 0) {
                if ((i3 & 32) == 0) {
                    i23 = 65536;
                } else {
                    i23 = 65536;
                }
                i4 |= i23;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i22 = 524288;
                } else {
                    i22 = 524288;
                }
                i4 |= i22;
            }
            i9 = i3 & Fields.SpotShadowColor;
            if (i9 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i10 = 8388608;
                } else {
                    i10 = 4194304;
                }
                i4 |= i10;
            }
            i11 = i3 & Fields.RotationX;
            if (i11 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
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
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i4 |= i14;
            }
            if ((i3 & Fields.RotationZ) != 0) {
                i15 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 4;
                } else {
                    i16 = 2;
                }
                i15 = i2 | i16;
            } else {
                i15 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i15 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i17 = 32;
                } else {
                    i17 = 16;
                }
                i15 |= i17;
            }
            i18 = i15;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<View> localView10 = AndroidCompositionLocals_androidKt.getLocalView();
                i21 = i20;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume19 = composerStartRestartGroup.consume(localView10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume19;
                ProvidableCompositionLocal<Density> localDensity10 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume110 = composerStartRestartGroup.consume(localDensity10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume110;
                top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                composerStartRestartGroup.startReplaceGroup(321499814);
                ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                if (z) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2360invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2360invoke() {
                                mutableState.setValue(Unit.INSTANCE);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier111 = companion;
                    final boolean z112 = z3;
                    final ScrollState scrollState1110 = scrollStateRememberScrollState;
                    final Shape shape111 = shape2;
                    final long j111 = j2;
                    final float f1119 = fM2514getTonalElevationD9Ej5fM;
                    final float f11110 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier111, z112), mutableTransitionState, mutableState2, scrollState1110, shape111, j111, f1119, f11110, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier112 = companion;
                    final boolean z113 = z3;
                    final ScrollState scrollState1111 = scrollStateRememberScrollState;
                    final Shape shape112 = shape2;
                    final long j112 = j2;
                    final float f11111 = fM2514getTonalElevationD9Ej5fM;
                    final float f11112 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier112, z113), mutableTransitionState, mutableState2, scrollState1111, shape112, j112, f11111, f11112, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                z4 = z3;
                ScrollState scrollState1112 = scrollStateRememberScrollState;
                f4 = fM2514getTonalElevationD9Ej5fM;
                scrollState3 = scrollState1112;
                modifier3 = companion;
                shape3 = shape2;
                j3 = j2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<View> localView11 = AndroidCompositionLocals_androidKt.getLocalView();
                i21 = i20;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111 = composerStartRestartGroup.consume(localView11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume111;
                ProvidableCompositionLocal<Density> localDensity11 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume112 = composerStartRestartGroup.consume(localDensity11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume112;
                top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                composerStartRestartGroup.startReplaceGroup(321499814);
                ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                if (z) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2360invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2360invoke() {
                                mutableState.setValue(Unit.INSTANCE);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier113 = companion;
                    final boolean z114 = z3;
                    final ScrollState scrollState1113 = scrollStateRememberScrollState;
                    final Shape shape113 = shape2;
                    final long j113 = j2;
                    final float f11113 = fM2514getTonalElevationD9Ej5fM;
                    final float f11114 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier113, z114), mutableTransitionState, mutableState2, scrollState1113, shape113, j113, f11113, f11114, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier114 = companion;
                    final boolean z115 = z3;
                    final ScrollState scrollState1114 = scrollStateRememberScrollState;
                    final Shape shape114 = shape2;
                    final long j114 = j2;
                    final float f11115 = fM2514getTonalElevationD9Ej5fM;
                    final float f11116 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier114, z115), mutableTransitionState, mutableState2, scrollState1114, shape114, j114, f11115, f11116, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                z4 = z3;
                ScrollState scrollState1115 = scrollStateRememberScrollState;
                f4 = fM2514getTonalElevationD9Ej5fM;
                scrollState3 = scrollState1115;
                modifier3 = companion;
                shape3 = shape2;
                j3 = j2;
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

                    public final void invoke(Composer composer2, int i25) {
                        ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 384;
        modifier2 = modifier;
        if ((i & 3072) == 0) {
            if ((i3 & 8) == 0) {
                scrollState2 = scrollState;
                if (composerStartRestartGroup.changed(scrollState2)) {
                    i24 = Fields.CameraDistance;
                }
                i4 |= i24;
            } else {
                scrollState2 = scrollState;
            }
            i24 = Fields.RotationZ;
            i4 |= i24;
        } else {
            scrollState2 = scrollState;
        }
        i7 = i3 & 16;
        if (i7 != 0) {
            if ((i & 24576) == 0) {
                z3 = z2;
                if (composerStartRestartGroup.changed(z3)) {
                    i8 = Fields.Clip;
                } else {
                    i8 = Fields.Shape;
                }
                i4 |= i8;
            }
            if ((i & 196608) != 0) {
                if ((i3 & 32) == 0) {
                    i23 = 65536;
                } else {
                    i23 = 65536;
                }
                i4 |= i23;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i22 = 524288;
                } else {
                    i22 = 524288;
                }
                i4 |= i22;
            }
            i9 = i3 & Fields.SpotShadowColor;
            if (i9 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i10 = 8388608;
                } else {
                    i10 = 4194304;
                }
                i4 |= i10;
            }
            i11 = i3 & Fields.RotationX;
            if (i11 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
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
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i4 |= i14;
            }
            if ((i3 & Fields.RotationZ) != 0) {
                i15 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 4;
                } else {
                    i16 = 2;
                }
                i15 = i2 | i16;
            } else {
                i15 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i15 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i17 = 32;
                } else {
                    i17 = 16;
                }
                i15 |= i17;
            }
            i18 = i15;
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<View> localView12 = AndroidCompositionLocals_androidKt.getLocalView();
                i21 = i20;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume113 = composerStartRestartGroup.consume(localView12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume113;
                ProvidableCompositionLocal<Density> localDensity12 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume114 = composerStartRestartGroup.consume(localDensity12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume114;
                top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                composerStartRestartGroup.startReplaceGroup(321499814);
                ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                if (z) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2360invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2360invoke() {
                                mutableState.setValue(Unit.INSTANCE);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier115 = companion;
                    final boolean z116 = z3;
                    final ScrollState scrollState1116 = scrollStateRememberScrollState;
                    final Shape shape115 = shape2;
                    final long j115 = j2;
                    final float f11117 = fM2514getTonalElevationD9Ej5fM;
                    final float f11118 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier115, z116), mutableTransitionState, mutableState2, scrollState1116, shape115, j115, f11117, f11118, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier116 = companion;
                    final boolean z117 = z3;
                    final ScrollState scrollState1117 = scrollStateRememberScrollState;
                    final Shape shape116 = shape2;
                    final long j116 = j2;
                    final float f11119 = fM2514getTonalElevationD9Ej5fM;
                    final float f111110 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier116, z117), mutableTransitionState, mutableState2, scrollState1117, shape116, j116, f11119, f111110, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                z4 = z3;
                ScrollState scrollState1118 = scrollStateRememberScrollState;
                f4 = fM2514getTonalElevationD9Ej5fM;
                scrollState3 = scrollState1118;
                modifier3 = companion;
                shape3 = shape2;
                j3 = j2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                    if (i7 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        i19 = 6;
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -458753;
                    } else {
                        i19 = 6;
                        shape2 = shape;
                    }
                    if ((i3 & 64) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                        i4 &= -3670017;
                    } else {
                        containerColor = j;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i20 = i4;
                        j2 = containerColor;
                        borderStroke2 = null;
                    } else {
                        borderStroke2 = borderStroke;
                        i20 = i4;
                        j2 = containerColor;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                mutableState = (MutableState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<View> localView13 = AndroidCompositionLocals_androidKt.getLocalView();
                i21 = i20;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume115 = composerStartRestartGroup.consume(localView13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                view = (View) objConsume115;
                ProvidableCompositionLocal<Density> localDensity13 = CompositionLocalsKt.getLocalDensity();
                borderStroke3 = borderStroke2;
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume116 = composerStartRestartGroup.consume(localDensity13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                density = (Density) objConsume116;
                top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
                composerStartRestartGroup.startReplaceGroup(321499814);
                ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
                if (z) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue5 = (Function0) new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public Object invoke() {
                                m2360invoke();
                                return Unit.INSTANCE;
                            }

                            public final void m2360invoke() {
                                mutableState.setValue(Unit.INSTANCE);
                            }
                        };
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
                }
                composerStartRestartGroup.endReplaceGroup();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue2 = new MutableTransitionState(false);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
                }
                mutableTransitionState = (MutableTransitionState) objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
                if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier117 = companion;
                    final boolean z118 = z3;
                    final ScrollState scrollState1119 = scrollStateRememberScrollState;
                    final Shape shape117 = shape2;
                    final long j117 = j2;
                    final float f111111 = fM2514getTonalElevationD9Ej5fM;
                    final float f111112 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier117, z118), mutableTransitionState, mutableState2, scrollState1119, shape117, j117, f111111, f111112, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                } else {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    mutableState2 = (MutableState) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                    objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    } else {
                        objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((IntRect) obj, (IntRect) obj2);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(IntRect intRect, IntRect intRect2) {
                                mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                            }
                        }, 8, null);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    final Modifier modifier118 = companion;
                    final boolean z119 = z3;
                    final ScrollState scrollState11110 = scrollStateRememberScrollState;
                    final Shape shape118 = shape2;
                    final long j118 = j2;
                    final float f111113 = fM2514getTonalElevationD9Ej5fM;
                    final float f111114 = fM2513getShadowElevationD9Ej5fM;
                    AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i25) {
                            ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                            if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                                }
                                MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier118, z119), mutableTransitionState, mutableState2, scrollState11110, shape118, j118, f111113, f111114, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                    return;
                                }
                                return;
                            }
                            composer2.skipToGroupEnd();
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke4 = borderStroke3;
                f3 = fM2513getShadowElevationD9Ej5fM;
                z4 = z3;
                ScrollState scrollState11111 = scrollStateRememberScrollState;
                f4 = fM2514getTonalElevationD9Ej5fM;
                scrollState3 = scrollState11111;
                modifier3 = companion;
                shape3 = shape2;
                j3 = j2;
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

                    public final void invoke(Composer composer2, int i25) {
                        ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        z3 = z2;
        if ((i & 196608) != 0) {
            if ((i3 & 32) == 0) {
                i23 = 65536;
            } else {
                i23 = 65536;
            }
            i4 |= i23;
        }
        if ((i & 1572864) != 0) {
            if ((i3 & 64) == 0) {
                i22 = 524288;
            } else {
                i22 = 524288;
            }
            i4 |= i22;
        }
        i9 = i3 & Fields.SpotShadowColor;
        if (i9 != 0) {
            i4 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i10 = 8388608;
            } else {
                i10 = 4194304;
            }
            i4 |= i10;
        }
        i11 = i3 & Fields.RotationX;
        if (i11 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(f2)) {
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
            if (composerStartRestartGroup.changed(borderStroke)) {
                i14 = 536870912;
            } else {
                i14 = 268435456;
            }
            i4 |= i14;
        }
        if ((i3 & Fields.RotationZ) != 0) {
            i15 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i16 = 4;
            } else {
                i16 = 2;
            }
            i15 = i2 | i16;
        } else {
            i15 = i2;
        }
        if ((i3 & Fields.CameraDistance) != 0) {
            i15 |= 48;
        } else if ((i2 & 48) != 0) {
            if (composerStartRestartGroup.changed(this)) {
                i17 = 32;
            } else {
                i17 = 16;
            }
            i15 |= i17;
        }
        i18 = i15;
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
                if (i7 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    i19 = 6;
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -458753;
                } else {
                    i19 = 6;
                    shape2 = shape;
                }
                if ((i3 & 64) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                    i4 &= -3670017;
                } else {
                    containerColor = j;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i20 = i4;
                    j2 = containerColor;
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                    i20 = i4;
                    j2 = containerColor;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
                if (i7 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    i19 = 6;
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -458753;
                } else {
                    i19 = 6;
                    shape2 = shape;
                }
                if ((i3 & 64) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                    i4 &= -3670017;
                } else {
                    containerColor = j;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i20 = i4;
                    j2 = containerColor;
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                    i20 = i4;
                    j2 = containerColor;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<View> localView14 = AndroidCompositionLocals_androidKt.getLocalView();
            i21 = i20;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume117 = composerStartRestartGroup.consume(localView14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            view = (View) objConsume117;
            ProvidableCompositionLocal<Density> localDensity14 = CompositionLocalsKt.getLocalDensity();
            borderStroke3 = borderStroke2;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume118 = composerStartRestartGroup.consume(localDensity14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume118;
            top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
            composerStartRestartGroup.startReplaceGroup(321499814);
            ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
            if (z) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue5 = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m2360invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2360invoke() {
                            mutableState.setValue(Unit.INSTANCE);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = new MutableTransitionState(false);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            mutableTransitionState = (MutableTransitionState) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
            if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                mutableState2 = (MutableState) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier119 = companion;
                final boolean z1110 = z3;
                final ScrollState scrollState11112 = scrollStateRememberScrollState;
                final Shape shape119 = shape2;
                final long j119 = j2;
                final float f111115 = fM2514getTonalElevationD9Ej5fM;
                final float f111116 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i25) {
                        ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                        if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier119, z1110), mutableTransitionState, mutableState2, scrollState11112, shape119, j119, f111115, f111116, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
            } else {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                mutableState2 = (MutableState) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier1110 = companion;
                final boolean z1111 = z3;
                final ScrollState scrollState11113 = scrollStateRememberScrollState;
                final Shape shape1110 = shape2;
                final long j1110 = j2;
                final float f111117 = fM2514getTonalElevationD9Ej5fM;
                final float f111118 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i25) {
                        ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                        if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier1110, z1111), mutableTransitionState, mutableState2, scrollState11113, shape1110, j1110, f111117, f111118, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            borderStroke4 = borderStroke3;
            f3 = fM2513getShadowElevationD9Ej5fM;
            z4 = z3;
            ScrollState scrollState11114 = scrollStateRememberScrollState;
            f4 = fM2514getTonalElevationD9Ej5fM;
            scrollState3 = scrollState11114;
            modifier3 = companion;
            shape3 = shape2;
            j3 = j2;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
                if (i7 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    i19 = 6;
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -458753;
                } else {
                    i19 = 6;
                    shape2 = shape;
                }
                if ((i3 & 64) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                    i4 &= -3670017;
                } else {
                    containerColor = j;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i20 = i4;
                    j2 = containerColor;
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                    i20 = i4;
                    j2 = containerColor;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
                if (i7 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    i19 = 6;
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -458753;
                } else {
                    i19 = 6;
                    shape2 = shape;
                }
                if ((i3 & 64) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, i19);
                    i4 &= -3670017;
                } else {
                    containerColor = j;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i20 = i4;
                    j2 = containerColor;
                    borderStroke2 = null;
                } else {
                    borderStroke2 = borderStroke;
                    i20 = i4;
                    j2 = containerColor;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(720925481, i20, i18, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:344)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321492941, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = SnapshotStateKt.mutableStateOf(Unit.INSTANCE, SnapshotStateKt.neverEqualPolicy());
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            mutableState = (MutableState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<View> localView15 = AndroidCompositionLocals_androidKt.getLocalView();
            i21 = i20;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume119 = composerStartRestartGroup.consume(localView15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            view = (View) objConsume119;
            ProvidableCompositionLocal<Density> localDensity15 = CompositionLocalsKt.getLocalDensity();
            borderStroke3 = borderStroke2;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1110 = composerStartRestartGroup.consume(localDensity15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            density = (Density) objConsume1110;
            top = WindowInsets_androidKt.getStatusBars(WindowInsets.INSTANCE, composerStartRestartGroup, 6).getTop(density);
            composerStartRestartGroup.startReplaceGroup(321499814);
            ComposerKt.sourceInformation(composerStartRestartGroup, "353@16432L36,353@16396L72");
            if (z) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321501788, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue5 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue5 = (Function0) new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m2360invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m2360invoke() {
                            mutableState.setValue(Unit.INSTANCE);
                        }
                    };
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue5);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ExposedDropdownMenu_androidKt.SoftKeyboardListener(view, density, (Function0) objRememberedValue5, composerStartRestartGroup, 384);
            }
            composerStartRestartGroup.endReplaceGroup();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321507042, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue2 = new MutableTransitionState(false);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue2);
            }
            mutableTransitionState = (MutableTransitionState) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            mutableTransitionState.setTargetState$animation_core_release(Boolean.valueOf(z));
            if (((Boolean) mutableTransitionState.getCurrentState()).booleanValue()) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                mutableState2 = (MutableState) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier1111 = companion;
                final boolean z1112 = z3;
                final ScrollState scrollState11115 = scrollStateRememberScrollState;
                final Shape shape1111 = shape2;
                final long j1111 = j2;
                final float f111119 = fM2514getTonalElevationD9Ej5fM;
                final float f1111110 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i25) {
                        ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                        if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier1111, z1112), mutableTransitionState, mutableState2, scrollState11115, shape1111, j1111, f111119, f1111110, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
            } else {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321513419, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue3 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TransformOrigin.m4988boximpl(TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()), null, 2, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                mutableState2 = (MutableState) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 321517310, "CC(remember):ExposedDropdownMenu.android.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(density) | composerStartRestartGroup.changed(top);
                objRememberedValue4 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                } else {
                    objRememberedValue4 = new ExposedDropdownMenuPositionProvider(density, top, mutableState, 0, new Function2<IntRect, IntRect, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((IntRect) obj, (IntRect) obj2);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(IntRect intRect, IntRect intRect2) {
                            mutableState2.setValue(TransformOrigin.m4988boximpl(MenuKt.calculateTransformOrigin(intRect, intRect2)));
                        }
                    }, 8, null);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                final Modifier modifier1112 = companion;
                final boolean z1113 = z3;
                final ScrollState scrollState11116 = scrollStateRememberScrollState;
                final Shape shape1112 = shape2;
                final long j1112 = j2;
                final float f1111111 = fM2514getTonalElevationD9Ej5fM;
                final float f1111112 = fM2513getShadowElevationD9Ej5fM;
                AndroidPopup_androidKt.Popup((ExposedDropdownMenuPositionProvider) objRememberedValue4, function0, ExposedDropdownMenuDefaults.INSTANCE.m2364popupPropertiespR6Bxps$material3_release(mo2358getAnchorTypeMg6Rgbw$material3_release(), composerStartRestartGroup, 48), ComposableLambdaKt.rememberComposableLambda(-1082380263, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i25) {
                        ComposerKt.sourceInformation(composer2, "C379@17644L555:ExposedDropdownMenu.android.kt#uh7d8r");
                        if ((i25 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1082380263, i25, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu.<anonymous> (ExposedDropdownMenu.android.kt:379)");
                            }
                            MenuKt.m2527DropdownMenuContentQj0Zi0g(ExposedDropdownMenuBoxScope.this.exposedDropdownSize(modifier1112, z1113), mutableTransitionState, mutableState2, scrollState11116, shape1112, j1112, f1111111, f1111112, borderStroke3, function3, composer2, (MutableTransitionState.$stable << 3) | 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21 & 112) | 3072, 0);
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            borderStroke4 = borderStroke3;
            f3 = fM2513getShadowElevationD9Ej5fM;
            z4 = z3;
            ScrollState scrollState11117 = scrollStateRememberScrollState;
            f4 = fM2514getTonalElevationD9Ej5fM;
            scrollState3 = scrollState11117;
            modifier3 = companion;
            shape3 = shape2;
            j3 = j2;
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

                public final void invoke(Composer composer2, int i25) {
                    ExposedDropdownMenuBoxScope.this.m2357ExposedDropdownMenuvNxi1II(z, function0, modifier3, scrollState3, z4, shape3, j3, f4, f3, borderStroke4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Use overload that takes MenuAnchorType and enabled parameters", replaceWith = @ReplaceWith(expression = "menuAnchor(type, enabled)", imports = {}))
    public final Modifier menuAnchor(Modifier modifier) {
        return m2355menuAnchorfsE2BvY$default(this, modifier, MenuAnchorType.INSTANCE.m2511getPrimaryNotEditableMg6Rgbw(), false, 2, null);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "The `focusable` parameter is unused. Pass the proper MenuAnchorType to Modifier.menuAnchor instead, which will handle focusability automatically.")
    public final void m2356ExposedDropdownMenukbRbctU(final boolean z, final Function0<Unit> function0, Modifier modifier, ScrollState scrollState, boolean z2, boolean z3, Shape shape, long j, float f, float f2, BorderStroke borderStroke, final Function3<? super ColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        int i5;
        Modifier modifier2;
        int i6;
        int i7;
        int i8;
        Shape shape2;
        long containerColor;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        final Modifier.Companion companion;
        ScrollState scrollStateRememberScrollState;
        boolean z4;
        boolean z5;
        float fM2514getTonalElevationD9Ej5fM;
        float fM2513getShadowElevationD9Ej5fM;
        float f3;
        int i19;
        boolean z6;
        BorderStroke borderStroke2;
        final BorderStroke borderStroke3;
        final Shape shape3;
        final ScrollState scrollState2;
        final long j2;
        final boolean z7;
        final float f4;
        final float f5;
        final boolean z8;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i20;
        int i21;
        Composer composerStartRestartGroup = composer.startRestartGroup(366140493);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ExposedDropdownMenu)P(3,7,6,8,4,5,10,1:c#ui.graphics.Color,11:c#ui.unit.Dp,9:c#ui.unit.Dp)414@19050L21,417@19189L5,418@19241L14,424@19482L463:ExposedDropdownMenu.android.kt#uh7d8r");
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
                if ((i & 3072) != 0) {
                    i4 |= ((i3 & 8) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.RotationZ : Fields.CameraDistance;
                }
                i7 = i3 & 32;
                if (i7 != 0) {
                    i4 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i4 |= i8;
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
                if ((i & 12582912) == 0) {
                    containerColor = j;
                    if ((i3 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(containerColor)) {
                        i20 = 4194304;
                    } else {
                        i20 = 8388608;
                    }
                    i4 |= i20;
                } else {
                    containerColor = j;
                }
                i9 = i3 & Fields.RotationX;
                if (i9 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i10 = 67108864;
                    } else {
                        i10 = 33554432;
                    }
                    i4 |= i10;
                }
                i11 = i3 & Fields.RotationY;
                if (i11 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i4 |= i12;
                }
                i13 = i3 & Fields.RotationZ;
                if (i13 != 0) {
                    i14 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changed(borderStroke)) {
                        i15 = 4;
                    } else {
                        i15 = 2;
                    }
                    i14 = i2 | i15;
                } else {
                    i14 = i2;
                }
                if ((i3 & Fields.CameraDistance) != 0) {
                    i14 |= 48;
                } else if ((i2 & 48) != 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 32;
                    } else {
                        i16 = 16;
                    }
                    i14 |= i16;
                }
                i17 = i14;
                if ((i3 & Fields.TransformOrigin) != 0) {
                    if ((i2 & 384) == 0) {
                        if (composerStartRestartGroup.changed(this)) {
                            i18 = Fields.RotationX;
                        } else {
                            i18 = Fields.SpotShadowColor;
                        }
                        i17 |= i18;
                    }
                    if ((i4 & 306775187) == 306775186 || (i17 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i5 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if ((i3 & 8) != 0) {
                                scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                                i4 &= -7169;
                            } else {
                                scrollStateRememberScrollState = scrollState;
                            }
                            if ((i3 & 16) != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                            z5 = i7 == 0 ? z3 : true;
                            if ((i3 & 64) != 0) {
                                shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                                i4 &= -3670017;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i4 &= -29360129;
                            }
                            if (i9 != 0) {
                                fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                            } else {
                                fM2514getTonalElevationD9Ej5fM = f;
                            }
                            if (i11 != 0) {
                                fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                            } else {
                                fM2513getShadowElevationD9Ej5fM = f2;
                            }
                            if (i13 != 0) {
                                i19 = i4;
                                borderStroke2 = null;
                                f3 = fM2513getShadowElevationD9Ej5fM;
                                z6 = z4;
                            } else {
                                f3 = fM2513getShadowElevationD9Ej5fM;
                                i19 = i4;
                                z6 = z4;
                            }
                            composerStartRestartGroup.endDefaults();
                            boolean z9 = z6;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                            }
                            int i22 = i19 & 8190;
                            int i23 = i19 >> 3;
                            m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i22 | (57344 & i23) | (458752 & i23) | (3670016 & i23) | (29360128 & i23) | (i23 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            borderStroke3 = borderStroke2;
                            shape3 = shape2;
                            scrollState2 = scrollStateRememberScrollState;
                            j2 = containerColor;
                            z7 = z5;
                            f4 = f3;
                            f5 = fM2514getTonalElevationD9Ej5fM;
                            z8 = z9;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i3 & 8) != 0) {
                                i4 &= -7169;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                            }
                            if ((i3 & Fields.SpotShadowColor) != 0) {
                                i4 &= -29360129;
                            }
                            scrollStateRememberScrollState = scrollState;
                            z6 = z2;
                            fM2514getTonalElevationD9Ej5fM = f;
                            f3 = f2;
                            i19 = i4;
                            companion = modifier2;
                            z5 = z3;
                        }
                        borderStroke2 = borderStroke;
                        composerStartRestartGroup.endDefaults();
                        boolean z10 = z6;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                        }
                        int i24 = i19 & 8190;
                        int i25 = i19 >> 3;
                        m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i24 | (57344 & i25) | (458752 & i25) | (3670016 & i25) | (29360128 & i25) | (i25 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        borderStroke3 = borderStroke2;
                        shape3 = shape2;
                        scrollState2 = scrollStateRememberScrollState;
                        j2 = containerColor;
                        z7 = z5;
                        f4 = f3;
                        f5 = fM2514getTonalElevationD9Ej5fM;
                        z8 = z10;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        scrollState2 = scrollState;
                        z8 = z2;
                        borderStroke3 = borderStroke;
                        shape3 = shape2;
                        j2 = containerColor;
                        companion = modifier2;
                        z7 = z3;
                        f5 = f;
                        f4 = f2;
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

                            public final void invoke(Composer composer2, int i26) {
                                ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i17 |= 384;
                if ((i4 & 306775187) == 306775186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    boolean z11 = z6;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                    }
                    int i26 = i19 & 8190;
                    int i27 = i19 >> 3;
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i26 | (57344 & i27) | (458752 & i27) | (3670016 & i27) | (29360128 & i27) | (i27 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke3 = borderStroke2;
                    shape3 = shape2;
                    scrollState2 = scrollStateRememberScrollState;
                    j2 = containerColor;
                    z7 = z5;
                    f4 = f3;
                    f5 = fM2514getTonalElevationD9Ej5fM;
                    z8 = z11;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    boolean z12 = z6;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                    }
                    int i28 = i19 & 8190;
                    int i29 = i19 >> 3;
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i28 | (57344 & i29) | (458752 & i29) | (3670016 & i29) | (29360128 & i29) | (i29 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke3 = borderStroke2;
                    shape3 = shape2;
                    scrollState2 = scrollStateRememberScrollState;
                    j2 = containerColor;
                    z7 = z5;
                    f4 = f3;
                    f5 = fM2514getTonalElevationD9Ej5fM;
                    z8 = z12;
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

                        public final void invoke(Composer composer2, int i210) {
                            ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 384;
            modifier2 = modifier;
            if ((i & 3072) != 0) {
                i4 |= ((i3 & 8) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.RotationZ : Fields.CameraDistance;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i4 |= i8;
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
            if ((i & 12582912) == 0) {
                containerColor = j;
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i20 = 4194304;
                } else {
                    i20 = 4194304;
                }
                i4 |= i20;
            } else {
                containerColor = j;
            }
            i9 = i3 & Fields.RotationX;
            if (i9 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i10 = 67108864;
                } else {
                    i10 = 33554432;
                }
                i4 |= i10;
            }
            i11 = i3 & Fields.RotationY;
            if (i11 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i4 |= i12;
            }
            i13 = i3 & Fields.RotationZ;
            if (i13 != 0) {
                i14 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i15 = 4;
                } else {
                    i15 = 2;
                }
                i14 = i2 | i15;
            } else {
                i14 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i14 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 32;
                } else {
                    i16 = 16;
                }
                i14 |= i16;
            }
            i17 = i14;
            if ((i3 & Fields.TransformOrigin) != 0) {
                if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i18 = Fields.RotationX;
                    } else {
                        i18 = Fields.SpotShadowColor;
                    }
                    i17 |= i18;
                }
                if ((i4 & 306775187) == 306775186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    boolean z13 = z6;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                    }
                    int i210 = i19 & 8190;
                    int i211 = i19 >> 3;
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i210 | (57344 & i211) | (458752 & i211) | (3670016 & i211) | (29360128 & i211) | (i211 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke3 = borderStroke2;
                    shape3 = shape2;
                    scrollState2 = scrollStateRememberScrollState;
                    j2 = containerColor;
                    z7 = z5;
                    f4 = f3;
                    f5 = fM2514getTonalElevationD9Ej5fM;
                    z8 = z13;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    boolean z14 = z6;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                    }
                    int i212 = i19 & 8190;
                    int i213 = i19 >> 3;
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i212 | (57344 & i213) | (458752 & i213) | (3670016 & i213) | (29360128 & i213) | (i213 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke3 = borderStroke2;
                    shape3 = shape2;
                    scrollState2 = scrollStateRememberScrollState;
                    j2 = containerColor;
                    z7 = z5;
                    f4 = f3;
                    f5 = fM2514getTonalElevationD9Ej5fM;
                    z8 = z14;
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

                        public final void invoke(Composer composer2, int i214) {
                            ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i17 |= 384;
            if ((i4 & 306775187) == 306775186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                boolean z15 = z6;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                }
                int i214 = i19 & 8190;
                int i215 = i19 >> 3;
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i214 | (57344 & i215) | (458752 & i215) | (3670016 & i215) | (29360128 & i215) | (i215 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke3 = borderStroke2;
                shape3 = shape2;
                scrollState2 = scrollStateRememberScrollState;
                j2 = containerColor;
                z7 = z5;
                f4 = f3;
                f5 = fM2514getTonalElevationD9Ej5fM;
                z8 = z15;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                boolean z16 = z6;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                }
                int i216 = i19 & 8190;
                int i217 = i19 >> 3;
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i216 | (57344 & i217) | (458752 & i217) | (3670016 & i217) | (29360128 & i217) | (i217 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke3 = borderStroke2;
                shape3 = shape2;
                scrollState2 = scrollStateRememberScrollState;
                j2 = containerColor;
                z7 = z5;
                f4 = f3;
                f5 = fM2514getTonalElevationD9Ej5fM;
                z8 = z16;
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

                    public final void invoke(Composer composer2, int i218) {
                        ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
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
            if ((i & 3072) != 0) {
                i4 |= ((i3 & 8) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.RotationZ : Fields.CameraDistance;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i4 |= i8;
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
            if ((i & 12582912) == 0) {
                containerColor = j;
                if ((i3 & Fields.SpotShadowColor) == 0) {
                    i20 = 4194304;
                } else {
                    i20 = 4194304;
                }
                i4 |= i20;
            } else {
                containerColor = j;
            }
            i9 = i3 & Fields.RotationX;
            if (i9 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i10 = 67108864;
                } else {
                    i10 = 33554432;
                }
                i4 |= i10;
            }
            i11 = i3 & Fields.RotationY;
            if (i11 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i4 |= i12;
            }
            i13 = i3 & Fields.RotationZ;
            if (i13 != 0) {
                i14 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changed(borderStroke)) {
                    i15 = 4;
                } else {
                    i15 = 2;
                }
                i14 = i2 | i15;
            } else {
                i14 = i2;
            }
            if ((i3 & Fields.CameraDistance) != 0) {
                i14 |= 48;
            } else if ((i2 & 48) != 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 32;
                } else {
                    i16 = 16;
                }
                i14 |= i16;
            }
            i17 = i14;
            if ((i3 & Fields.TransformOrigin) != 0) {
                if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i18 = Fields.RotationX;
                    } else {
                        i18 = Fields.SpotShadowColor;
                    }
                    i17 |= i18;
                }
                if ((i4 & 306775187) == 306775186) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    boolean z17 = z6;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                    }
                    int i218 = i19 & 8190;
                    int i219 = i19 >> 3;
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i218 | (57344 & i219) | (458752 & i219) | (3670016 & i219) | (29360128 & i219) | (i219 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke3 = borderStroke2;
                    shape3 = shape2;
                    scrollState2 = scrollStateRememberScrollState;
                    j2 = containerColor;
                    z7 = z5;
                    f4 = f3;
                    f5 = fM2514getTonalElevationD9Ej5fM;
                    z8 = z17;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    } else {
                        if (i5 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i4 &= -7169;
                        } else {
                            scrollStateRememberScrollState = scrollState;
                        }
                        if ((i3 & 16) != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i7 == 0) {
                        }
                        if ((i3 & 64) != 0) {
                            shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        }
                        if ((i3 & Fields.SpotShadowColor) != 0) {
                            containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i4 &= -29360129;
                        }
                        if (i9 != 0) {
                            fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                        } else {
                            fM2514getTonalElevationD9Ej5fM = f;
                        }
                        if (i11 != 0) {
                            fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                        } else {
                            fM2513getShadowElevationD9Ej5fM = f2;
                        }
                        if (i13 != 0) {
                            i19 = i4;
                            borderStroke2 = null;
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            z6 = z4;
                        } else {
                            f3 = fM2513getShadowElevationD9Ej5fM;
                            i19 = i4;
                            z6 = z4;
                            borderStroke2 = borderStroke;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    boolean z18 = z6;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                    }
                    int i2110 = i19 & 8190;
                    int i2111 = i19 >> 3;
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i2110 | (57344 & i2111) | (458752 & i2111) | (3670016 & i2111) | (29360128 & i2111) | (i2111 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    borderStroke3 = borderStroke2;
                    shape3 = shape2;
                    scrollState2 = scrollStateRememberScrollState;
                    j2 = containerColor;
                    z7 = z5;
                    f4 = f3;
                    f5 = fM2514getTonalElevationD9Ej5fM;
                    z8 = z18;
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

                        public final void invoke(Composer composer2, int i2112) {
                            ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i17 |= 384;
            if ((i4 & 306775187) == 306775186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                boolean z19 = z6;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                }
                int i2112 = i19 & 8190;
                int i2113 = i19 >> 3;
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i2112 | (57344 & i2113) | (458752 & i2113) | (3670016 & i2113) | (29360128 & i2113) | (i2113 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke3 = borderStroke2;
                shape3 = shape2;
                scrollState2 = scrollStateRememberScrollState;
                j2 = containerColor;
                z7 = z5;
                f4 = f3;
                f5 = fM2514getTonalElevationD9Ej5fM;
                z8 = z19;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                boolean z110 = z6;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                }
                int i2114 = i19 & 8190;
                int i2115 = i19 >> 3;
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i2114 | (57344 & i2115) | (458752 & i2115) | (3670016 & i2115) | (29360128 & i2115) | (i2115 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke3 = borderStroke2;
                shape3 = shape2;
                scrollState2 = scrollStateRememberScrollState;
                j2 = containerColor;
                z7 = z5;
                f4 = f3;
                f5 = fM2514getTonalElevationD9Ej5fM;
                z8 = z110;
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

                    public final void invoke(Composer composer2, int i2116) {
                        ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 384;
        modifier2 = modifier;
        if ((i & 3072) != 0) {
            i4 |= ((i3 & 8) == 0 || !composerStartRestartGroup.changed(scrollState)) ? Fields.RotationZ : Fields.CameraDistance;
        }
        i7 = i3 & 32;
        if (i7 != 0) {
            i4 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(z3)) {
                i8 = Fields.RenderEffect;
            } else {
                i8 = 65536;
            }
            i4 |= i8;
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
        if ((i & 12582912) == 0) {
            containerColor = j;
            if ((i3 & Fields.SpotShadowColor) == 0) {
                i20 = 4194304;
            } else {
                i20 = 4194304;
            }
            i4 |= i20;
        } else {
            containerColor = j;
        }
        i9 = i3 & Fields.RotationX;
        if (i9 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i10 = 67108864;
            } else {
                i10 = 33554432;
            }
            i4 |= i10;
        }
        i11 = i3 & Fields.RotationY;
        if (i11 != 0) {
            i4 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changed(f2)) {
                i12 = 536870912;
            } else {
                i12 = 268435456;
            }
            i4 |= i12;
        }
        i13 = i3 & Fields.RotationZ;
        if (i13 != 0) {
            i14 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changed(borderStroke)) {
                i15 = 4;
            } else {
                i15 = 2;
            }
            i14 = i2 | i15;
        } else {
            i14 = i2;
        }
        if ((i3 & Fields.CameraDistance) != 0) {
            i14 |= 48;
        } else if ((i2 & 48) != 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i16 = 32;
            } else {
                i16 = 16;
            }
            i14 |= i16;
        }
        i17 = i14;
        if ((i3 & Fields.TransformOrigin) != 0) {
            if ((i2 & 384) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i18 = Fields.RotationX;
                } else {
                    i18 = Fields.SpotShadowColor;
                }
                i17 |= i18;
            }
            if ((i4 & 306775187) == 306775186) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                boolean z111 = z6;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                }
                int i2116 = i19 & 8190;
                int i2117 = i19 >> 3;
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i2116 | (57344 & i2117) | (458752 & i2117) | (3670016 & i2117) | (29360128 & i2117) | (i2117 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke3 = borderStroke2;
                shape3 = shape2;
                scrollState2 = scrollStateRememberScrollState;
                j2 = containerColor;
                z7 = z5;
                f4 = f3;
                f5 = fM2514getTonalElevationD9Ej5fM;
                z8 = z111;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                } else {
                    if (i5 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i4 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState;
                    }
                    if ((i3 & 16) != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i7 == 0) {
                    }
                    if ((i3 & 64) != 0) {
                        shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    }
                    if ((i3 & Fields.SpotShadowColor) != 0) {
                        containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i4 &= -29360129;
                    }
                    if (i9 != 0) {
                        fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                    } else {
                        fM2514getTonalElevationD9Ej5fM = f;
                    }
                    if (i11 != 0) {
                        fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                    } else {
                        fM2513getShadowElevationD9Ej5fM = f2;
                    }
                    if (i13 != 0) {
                        i19 = i4;
                        borderStroke2 = null;
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        z6 = z4;
                    } else {
                        f3 = fM2513getShadowElevationD9Ej5fM;
                        i19 = i4;
                        z6 = z4;
                        borderStroke2 = borderStroke;
                    }
                }
                composerStartRestartGroup.endDefaults();
                boolean z112 = z6;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
                }
                int i2118 = i19 & 8190;
                int i2119 = i19 >> 3;
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i2118 | (57344 & i2119) | (458752 & i2119) | (3670016 & i2119) | (29360128 & i2119) | (i2119 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                borderStroke3 = borderStroke2;
                shape3 = shape2;
                scrollState2 = scrollStateRememberScrollState;
                j2 = containerColor;
                z7 = z5;
                f4 = f3;
                f5 = fM2514getTonalElevationD9Ej5fM;
                z8 = z112;
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

                    public final void invoke(Composer composer2, int i21110) {
                        ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i17 |= 384;
        if ((i4 & 306775187) == 306775186) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if ((i3 & 16) != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i7 == 0) {
                }
                if ((i3 & 64) != 0) {
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i19 = i4;
                    borderStroke2 = null;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z6 = z4;
                } else {
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    i19 = i4;
                    z6 = z4;
                    borderStroke2 = borderStroke;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if ((i3 & 16) != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i7 == 0) {
                }
                if ((i3 & 64) != 0) {
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i19 = i4;
                    borderStroke2 = null;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z6 = z4;
                } else {
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    i19 = i4;
                    z6 = z4;
                    borderStroke2 = borderStroke;
                }
            }
            composerStartRestartGroup.endDefaults();
            boolean z113 = z6;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
            }
            int i21110 = i19 & 8190;
            int i21111 = i19 >> 3;
            m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i21110 | (57344 & i21111) | (458752 & i21111) | (3670016 & i21111) | (29360128 & i21111) | (i21111 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            borderStroke3 = borderStroke2;
            shape3 = shape2;
            scrollState2 = scrollStateRememberScrollState;
            j2 = containerColor;
            z7 = z5;
            f4 = f3;
            f5 = fM2514getTonalElevationD9Ej5fM;
            z8 = z113;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if ((i3 & 16) != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i7 == 0) {
                }
                if ((i3 & 64) != 0) {
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i19 = i4;
                    borderStroke2 = null;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z6 = z4;
                } else {
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    i19 = i4;
                    z6 = z4;
                    borderStroke2 = borderStroke;
                }
            } else {
                if (i5 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i4 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState;
                }
                if ((i3 & 16) != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i7 == 0) {
                }
                if ((i3 & 64) != 0) {
                    shape2 = MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    containerColor = MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i4 &= -29360129;
                }
                if (i9 != 0) {
                    fM2514getTonalElevationD9Ej5fM = MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM();
                } else {
                    fM2514getTonalElevationD9Ej5fM = f;
                }
                if (i11 != 0) {
                    fM2513getShadowElevationD9Ej5fM = MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM();
                } else {
                    fM2513getShadowElevationD9Ej5fM = f2;
                }
                if (i13 != 0) {
                    i19 = i4;
                    borderStroke2 = null;
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    z6 = z4;
                } else {
                    f3 = fM2513getShadowElevationD9Ej5fM;
                    i19 = i4;
                    z6 = z4;
                    borderStroke2 = borderStroke;
                }
            }
            composerStartRestartGroup.endDefaults();
            boolean z114 = z6;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(366140493, i19, i17, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:424)");
            }
            int i21112 = i19 & 8190;
            int i21113 = i19 >> 3;
            m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, z5, shape2, containerColor, fM2514getTonalElevationD9Ej5fM, f3, borderStroke2, function3, composerStartRestartGroup, i21112 | (57344 & i21113) | (458752 & i21113) | (3670016 & i21113) | (29360128 & i21113) | (i21113 & 234881024) | ((i17 << 27) & 1879048192), (i17 >> 3) & 126, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            borderStroke3 = borderStroke2;
            shape3 = shape2;
            scrollState2 = scrollStateRememberScrollState;
            j2 = containerColor;
            z7 = z5;
            f4 = f3;
            f5 = fM2514getTonalElevationD9Ej5fM;
            z8 = z114;
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

                public final void invoke(Composer composer2, int i21114) {
                    ExposedDropdownMenuBoxScope.this.m2356ExposedDropdownMenukbRbctU(z, function0, companion, scrollState2, z8, z7, shape3, j2, f5, f4, borderStroke3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility. Use overload with customization options parameters.")
    public final void ExposedDropdownMenu(final boolean z, final Function0 function0, Modifier modifier, ScrollState scrollState, final Function3 function3, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        ScrollState scrollState2;
        int i6;
        int i7;
        Modifier.Companion companion;
        ScrollState scrollStateRememberScrollState;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i8;
        Composer composerStartRestartGroup = composer.startRestartGroup(1729549851);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ExposedDropdownMenu)P(1,3,2,4)449@20337L21,458@20677L5,459@20726L14,452@20429L498:ExposedDropdownMenu.android.kt#uh7d8r");
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
                if ((i & 3072) == 0) {
                    if ((i2 & 8) == 0) {
                        scrollState2 = scrollState;
                        if (composerStartRestartGroup.changed(scrollState2)) {
                            i8 = Fields.CameraDistance;
                        }
                        i3 |= i8;
                    } else {
                        scrollState2 = scrollState;
                    }
                    i8 = Fields.RotationZ;
                    i3 |= i8;
                } else {
                    scrollState2 = scrollState;
                }
                if ((i2 & 16) != 0) {
                    i3 |= 24576;
                } else if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i3 |= i6;
                }
                if ((i2 & 32) != 0) {
                    i3 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(this)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i3 |= i7;
                }
                if ((74899 & i3) == 74898 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i2 & 8) != 0) {
                            scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                            i3 &= -7169;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
                        }
                        m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        scrollState2 = scrollStateRememberScrollState;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                        }
                        companion = modifier2;
                    }
                    scrollStateRememberScrollState = scrollState2;
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
                    }
                    m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    scrollState2 = scrollStateRememberScrollState;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    companion = modifier2;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier3 = companion;
                    final ScrollState scrollState3 = scrollState2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i9) {
                            ExposedDropdownMenuBoxScope.this.ExposedDropdownMenu(z, function0, modifier3, scrollState3, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 384;
            modifier2 = modifier;
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    scrollState2 = scrollState;
                    if (composerStartRestartGroup.changed(scrollState2)) {
                        i8 = Fields.CameraDistance;
                    }
                    i3 |= i8;
                } else {
                    scrollState2 = scrollState;
                }
                i8 = Fields.RotationZ;
                i3 |= i8;
            } else {
                scrollState2 = scrollState;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
                }
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                scrollState2 = scrollStateRememberScrollState;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
                }
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                scrollState2 = scrollStateRememberScrollState;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier4 = companion;
                final ScrollState scrollState4 = scrollState2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i9) {
                        ExposedDropdownMenuBoxScope.this.ExposedDropdownMenu(z, function0, modifier4, scrollState4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
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
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    scrollState2 = scrollState;
                    if (composerStartRestartGroup.changed(scrollState2)) {
                        i8 = Fields.CameraDistance;
                    }
                    i3 |= i8;
                } else {
                    scrollState2 = scrollState;
                }
                i8 = Fields.RotationZ;
                i3 |= i8;
            } else {
                scrollState2 = scrollState;
            }
            if ((i2 & 16) != 0) {
                i3 |= 24576;
            } else if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i3 |= i6;
            }
            if ((i2 & 32) != 0) {
                i3 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(this)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i3 |= i7;
            }
            if ((74899 & i3) == 74898) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
                }
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                scrollState2 = scrollStateRememberScrollState;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i2 & 8) != 0) {
                        scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                        i3 &= -7169;
                    } else {
                        scrollStateRememberScrollState = scrollState2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
                }
                m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                scrollState2 = scrollStateRememberScrollState;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier5 = companion;
                final ScrollState scrollState5 = scrollState2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i9) {
                        ExposedDropdownMenuBoxScope.this.ExposedDropdownMenu(z, function0, modifier5, scrollState5, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        modifier2 = modifier;
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                scrollState2 = scrollState;
                if (composerStartRestartGroup.changed(scrollState2)) {
                    i8 = Fields.CameraDistance;
                }
                i3 |= i8;
            } else {
                scrollState2 = scrollState;
            }
            i8 = Fields.RotationZ;
            i3 |= i8;
        } else {
            scrollState2 = scrollState;
        }
        if ((i2 & 16) != 0) {
            i3 |= 24576;
        } else if ((i & 24576) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i6 = Fields.Clip;
            } else {
                i6 = Fields.Shape;
            }
            i3 |= i6;
        }
        if ((i2 & 32) != 0) {
            i3 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(this)) {
                i7 = Fields.RenderEffect;
            } else {
                i7 = 65536;
            }
            i3 |= i7;
        }
        if ((74899 & i3) == 74898) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i3 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i3 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
            }
            m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            scrollState2 = scrollStateRememberScrollState;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i3 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i2 & 8) != 0) {
                    scrollStateRememberScrollState = ScrollKt.rememberScrollState(0, composerStartRestartGroup, 0, 1);
                    i3 &= -7169;
                } else {
                    scrollStateRememberScrollState = scrollState2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1729549851, i3, -1, "androidx.compose.material3.ExposedDropdownMenuBoxScope.ExposedDropdownMenu (ExposedDropdownMenu.android.kt:452)");
            }
            m2357ExposedDropdownMenuvNxi1II(z, function0, companion, scrollStateRememberScrollState, true, MenuDefaults.INSTANCE.getShape(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6), MenuDefaults.INSTANCE.m2514getTonalElevationD9Ej5fM(), MenuDefaults.INSTANCE.m2513getShadowElevationD9Ej5fM(), null, function3, composerStartRestartGroup, (i3 & 14) | 918577152 | (i3 & 112) | (i3 & 896) | (i3 & 7168), (i3 >> 12) & 126, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            scrollState2 = scrollStateRememberScrollState;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier6 = companion;
            final ScrollState scrollState6 = scrollState2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i9) {
                    ExposedDropdownMenuBoxScope.this.ExposedDropdownMenu(z, function0, modifier6, scrollState6, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
