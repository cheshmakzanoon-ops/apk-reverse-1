package androidx.compose.material3;

import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.foundation.DarkThemeKt;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.WindowInsets;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.platform.AndroidCompositionLocals_androidKt;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.semantics.SemanticsModifierKt;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionContext;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.DisposableEffectResult;
import androidx.compose.runtime.DisposableEffectScope;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.LayoutDirection;
import androidx.compose.ui.window.SecureFlagPolicy;
import java.util.UUID;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000r\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a¹\u0001\u0010\u0000\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\r2\b\b\u0002\u0010\u000f\u001a\u00020\t2\b\b\u0002\u0010\u0010\u001a\u00020\r2\u0015\b\u0002\u0010\u0011\u001a\u000f\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u0003¢\u0006\u0002\b\u00122\b\b\u0002\u0010\u0013\u001a\u00020\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u00162\u001c\u0010\u0017\u001a\u0018\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00010\u0018¢\u0006\u0002\b\u0012¢\u0006\u0002\b\u001aH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001c\u001aJ\u0010\u001d\u001a\u00020\u00012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00010\u00032\u0006\u0010\u0015\u001a\u00020\u00162\u0012\u0010\u001e\u001a\u000e\u0012\u0004\u0012\u00020 \u0012\u0004\u0012\u00020!0\u001f2\u0011\u0010\u0017\u001a\r\u0012\u0004\u0012\u00020\u00010\u0003¢\u0006\u0002\b\u0012H\u0001¢\u0006\u0002\u0010\"\u001a\f\u0010#\u001a\u00020$*\u00020%H\u0000\u001a\u0014\u0010&\u001a\u00020$*\u00020'2\u0006\u0010(\u001a\u00020$H\u0002\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006)²\u0006\u0015\u0010*\u001a\r\u0012\u0004\u0012\u00020\u00010\u0003¢\u0006\u0002\b\u0012X\u008a\u0084\u0002"}, d2 = {"ModalBottomSheet", "", "onDismissRequest", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "sheetState", "Landroidx/compose/material3/SheetState;", "sheetMaxWidth", "Landroidx/compose/ui/unit/Dp;", "shape", "Landroidx/compose/ui/graphics/Shape;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "contentColor", "tonalElevation", "scrimColor", "dragHandle", "Landroidx/compose/runtime/Composable;", "windowInsets", "Landroidx/compose/foundation/layout/WindowInsets;", "properties", "Landroidx/compose/material3/ModalBottomSheetProperties;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/ColumnScope;", "Lkotlin/ExtensionFunctionType;", "ModalBottomSheet-dYc4hso", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/material3/SheetState;FLandroidx/compose/ui/graphics/Shape;JJFJLkotlin/jvm/functions/Function2;Landroidx/compose/foundation/layout/WindowInsets;Landroidx/compose/material3/ModalBottomSheetProperties;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;III)V", "ModalBottomSheetDialog", "predictiveBackProgress", "Landroidx/compose/animation/core/Animatable;", "", "Landroidx/compose/animation/core/AnimationVector1D;", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/material3/ModalBottomSheetProperties;Landroidx/compose/animation/core/Animatable;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "isFlagSecureEnabled", "", "Landroid/view/View;", "shouldApplySecureFlag", "Landroidx/compose/ui/window/SecureFlagPolicy;", "isSecureFlagSetOnParent", "material3_release", "currentContent"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ModalBottomSheet_androidKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[SecureFlagPolicy.values().length];
            try {
                iArr[SecureFlagPolicy.SecureOff.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[SecureFlagPolicy.SecureOn.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[SecureFlagPolicy.Inherit.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Use constructor with contentWindowInsets parameter.", replaceWith = @ReplaceWith(expression = "ModalBottomSheet(onDismissRequest,modifier,sheetState,sheetMaxWidth,shape,containerColor,contentColor,tonalElevation,scrimColor,dragHandle,{ windowInsets },properties,content,)", imports = {}))
    public static final void m2540ModalBottomSheetdYc4hso(final Function0 function0, Modifier modifier, SheetState sheetState, float f, Shape shape, long j, long j2, float f2, long j3, Function2 function2, WindowInsets windowInsets, ModalBottomSheetProperties modalBottomSheetProperties, final Function3 function3, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        Modifier modifier2;
        SheetState sheetState2;
        int i5;
        int i6;
        long jM2173contentColorForek8zF_U;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        Modifier.Companion companion;
        SheetState sheetStateRememberModalBottomSheetState;
        float fM2030getSheetMaxWidthD9Ej5fM;
        Shape expandedShape;
        int i16;
        long containerColor;
        float f3;
        long scrimColor;
        int i17;
        Function2 function2M2217getLambda1$material3_release;
        final WindowInsets windowInsets2;
        ModalBottomSheetProperties properties;
        int i18;
        float f4;
        Function2 function4;
        long j4;
        Composer composer2;
        final float f5;
        final WindowInsets windowInsets3;
        final ModalBottomSheetProperties modalBottomSheetProperties2;
        final Function2 function5;
        final float f6;
        final SheetState sheetState3;
        final long j5;
        final Shape shape2;
        final Modifier modifier3;
        final long j6;
        final long j7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i19;
        int i20;
        int i21;
        Composer composerStartRestartGroup = composer.startRestartGroup(944867294);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ModalBottomSheet)P(5,4,10,9:c#ui.unit.Dp,8,0:c#ui.graphics.Color,2:c#ui.graphics.Color,11:c#ui.unit.Dp,7:c#ui.graphics.Color,3,12,6)235@10240L31,237@10371L13,238@10434L14,239@10476L31,241@10584L10,243@10731L12,247@10884L485:ModalBottomSheet.android.kt#uh7d8r");
        if ((i3 & 1) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        int i22 = i3 & 2;
        if (i22 == 0) {
            if ((i & 48) == 0) {
                modifier2 = modifier;
                i4 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i3 & 4) == 0) {
                    sheetState2 = sheetState;
                    if (composerStartRestartGroup.changed(sheetState2)) {
                        i21 = Fields.RotationX;
                    }
                    i4 |= i21;
                } else {
                    sheetState2 = sheetState;
                }
                i21 = Fields.SpotShadowColor;
                i4 |= i21;
            } else {
                sheetState2 = sheetState;
            }
            i5 = i3 & 8;
            if (i5 != 0) {
                if ((i & 3072) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i6 = Fields.CameraDistance;
                    } else {
                        i6 = Fields.RotationZ;
                    }
                    i4 |= i6;
                }
                if ((i & 24576) != 0) {
                    i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
                }
                if ((i & 196608) != 0) {
                    if ((i3 & 32) == 0 || !composerStartRestartGroup.changed(j)) {
                        i20 = 65536;
                    } else {
                        i20 = Fields.RenderEffect;
                    }
                    i4 |= i20;
                }
                if ((i & 1572864) == 0) {
                    jM2173contentColorForek8zF_U = j2;
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(jM2173contentColorForek8zF_U)) {
                        i19 = 524288;
                    } else {
                        i19 = 1048576;
                    }
                    i4 |= i19;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                i7 = i3 & Fields.SpotShadowColor;
                if (i7 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(f2)) {
                        i8 = 8388608;
                    } else {
                        i8 = 4194304;
                    }
                    i4 |= i8;
                }
                if ((i & 100663296) != 0) {
                    i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(j3)) ? 33554432 : 67108864;
                }
                i9 = i3 & Fields.RotationY;
                if (i9 != 0) {
                    if ((805306368 & i) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i2 & 6) == 0) {
                        i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
                    } else {
                        i11 = i2;
                    }
                    i12 = i3 & Fields.CameraDistance;
                    if (i12 != 0) {
                        i11 |= 48;
                    } else if ((i2 & 48) == 0) {
                        if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                            i13 = 32;
                        } else {
                            i13 = 16;
                        }
                        i11 |= i13;
                    }
                    i14 = i11;
                    if ((i3 & Fields.TransformOrigin) != 0) {
                        i14 |= 384;
                    } else if ((i2 & 384) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i15 = Fields.RotationX;
                        } else {
                            i15 = Fields.SpotShadowColor;
                        }
                        i14 |= i15;
                    }
                    if ((306783379 & i4) == 306783378 || (i14 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i22 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if ((i3 & 4) != 0) {
                                sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                                i4 &= -897;
                            } else {
                                sheetStateRememberModalBottomSheetState = sheetState2;
                            }
                            if (i5 != 0) {
                                fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                            } else {
                                fM2030getSheetMaxWidthD9Ej5fM = f;
                            }
                            if ((i3 & 16) != 0) {
                                expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                                i4 &= -57345;
                            } else {
                                expandedShape = shape;
                            }
                            if ((i3 & 32) != 0) {
                                i16 = i4 & (-458753);
                                containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            } else {
                                i16 = i4;
                                containerColor = j;
                            }
                            if ((i3 & 64) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                                i16 &= -3670017;
                            }
                            if (i7 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                                i17 = i16 & (-234881025);
                            } else {
                                scrimColor = j3;
                                i17 = i16;
                            }
                            if (i9 != 0) {
                                function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                            } else {
                                function2M2217getLambda1$material3_release = function2;
                            }
                            if ((i3 & Fields.RotationZ) != 0) {
                                windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                                i14 &= -15;
                            } else {
                                windowInsets2 = windowInsets;
                            }
                            if (i12 != 0) {
                                properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                            } else {
                                properties = modalBottomSheetProperties;
                            }
                            i18 = i14;
                            modifier2 = companion;
                            f4 = f3;
                            function4 = function2M2217getLambda1$material3_release;
                            j4 = scrimColor;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i3 & 4) != 0) {
                                i4 &= -897;
                            }
                            if ((i3 & 16) != 0) {
                                i4 &= -57345;
                            }
                            if ((i3 & 32) != 0) {
                                i4 &= -458753;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                            }
                            if ((i3 & Fields.RotationX) != 0) {
                                i4 &= -234881025;
                            }
                            if ((i3 & Fields.RotationZ) != 0) {
                                i14 &= -15;
                            }
                            expandedShape = shape;
                            f4 = f2;
                            j4 = j3;
                            windowInsets2 = windowInsets;
                            properties = modalBottomSheetProperties;
                            i18 = i14;
                            i17 = i4;
                            sheetStateRememberModalBottomSheetState = sheetState2;
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                            containerColor = j;
                            function4 = function2;
                        }
                        composerStartRestartGroup.endDefaults();
                        composer2 = composerStartRestartGroup;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                        }
                        ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                return invoke((Composer) obj, ((Number) obj2).intValue());
                            }

                            public final WindowInsets invoke(Composer composer3, int i23) {
                                composer3.startReplaceGroup(-2061903609);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                                }
                                WindowInsets windowInsets4 = windowInsets2;
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                composer3.endReplaceGroup();
                                return windowInsets4;
                            }
                        }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        f5 = fM2030getSheetMaxWidthD9Ej5fM;
                        windowInsets3 = windowInsets2;
                        modalBottomSheetProperties2 = properties;
                        function5 = function4;
                        f6 = f4;
                        long j8 = j4;
                        sheetState3 = sheetStateRememberModalBottomSheetState;
                        j5 = containerColor;
                        shape2 = expandedShape;
                        modifier3 = modifier2;
                        j6 = jM2173contentColorForek8zF_U;
                        j7 = j8;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        f5 = f;
                        shape2 = shape;
                        j5 = j;
                        function5 = function2;
                        windowInsets3 = windowInsets;
                        modalBottomSheetProperties2 = modalBottomSheetProperties;
                        composer2 = composerStartRestartGroup;
                        modifier3 = modifier2;
                        sheetState3 = sheetState2;
                        j6 = jM2173contentColorForek8zF_U;
                        f6 = f2;
                        j7 = j3;
                    }
                    scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i23) {
                                ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i2 & 6) == 0) {
                    i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
                } else {
                    i11 = i2;
                }
                i12 = i3 & Fields.CameraDistance;
                if (i12 != 0) {
                    i11 |= 48;
                } else if ((i2 & 48) == 0) {
                    if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                        i13 = 32;
                    } else {
                        i13 = 16;
                    }
                    i11 |= i13;
                }
                i14 = i11;
                if ((i3 & Fields.TransformOrigin) != 0) {
                    i14 |= 384;
                } else if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i15 = Fields.RotationX;
                    } else {
                        i15 = Fields.SpotShadowColor;
                    }
                    i14 |= i15;
                }
                if ((306783379 & i4) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    } else {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    composer2 = composerStartRestartGroup;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                    }
                    ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke((Composer) obj, ((Number) obj2).intValue());
                        }

                        public final WindowInsets invoke(Composer composer3, int i23) {
                            composer3.startReplaceGroup(-2061903609);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                            }
                            WindowInsets windowInsets4 = windowInsets2;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            composer3.endReplaceGroup();
                            return windowInsets4;
                        }
                    }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f5 = fM2030getSheetMaxWidthD9Ej5fM;
                    windowInsets3 = windowInsets2;
                    modalBottomSheetProperties2 = properties;
                    function5 = function4;
                    f6 = f4;
                    long j9 = j4;
                    sheetState3 = sheetStateRememberModalBottomSheetState;
                    j5 = containerColor;
                    shape2 = expandedShape;
                    modifier3 = modifier2;
                    j6 = jM2173contentColorForek8zF_U;
                    j7 = j9;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    } else {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    composer2 = composerStartRestartGroup;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                    }
                    ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke((Composer) obj, ((Number) obj2).intValue());
                        }

                        public final WindowInsets invoke(Composer composer3, int i23) {
                            composer3.startReplaceGroup(-2061903609);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                            }
                            WindowInsets windowInsets4 = windowInsets2;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            composer3.endReplaceGroup();
                            return windowInsets4;
                        }
                    }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f5 = fM2030getSheetMaxWidthD9Ej5fM;
                    windowInsets3 = windowInsets2;
                    modalBottomSheetProperties2 = properties;
                    function5 = function4;
                    f6 = f4;
                    long j10 = j4;
                    sheetState3 = sheetStateRememberModalBottomSheetState;
                    j5 = containerColor;
                    shape2 = expandedShape;
                    modifier3 = modifier2;
                    j6 = jM2173contentColorForek8zF_U;
                    j7 = j10;
                }
                scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i23) {
                            ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 3072;
            if ((i & 24576) != 0) {
                i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
            }
            if ((i & 196608) != 0) {
                if ((i3 & 32) == 0) {
                    i20 = 65536;
                } else {
                    i20 = 65536;
                }
                i4 |= i20;
            }
            if ((i & 1572864) == 0) {
                jM2173contentColorForek8zF_U = j2;
                if ((i3 & 64) == 0) {
                    i19 = 524288;
                } else {
                    i19 = 524288;
                }
                i4 |= i19;
            } else {
                jM2173contentColorForek8zF_U = j2;
            }
            i7 = i3 & Fields.SpotShadowColor;
            if (i7 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i8 = 8388608;
                } else {
                    i8 = 4194304;
                }
                i4 |= i8;
            }
            if ((i & 100663296) != 0) {
                i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(j3)) ? 33554432 : 67108864;
            }
            i9 = i3 & Fields.RotationY;
            if (i9 != 0) {
                if ((805306368 & i) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i2 & 6) == 0) {
                    i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
                } else {
                    i11 = i2;
                }
                i12 = i3 & Fields.CameraDistance;
                if (i12 != 0) {
                    i11 |= 48;
                } else if ((i2 & 48) == 0) {
                    if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                        i13 = 32;
                    } else {
                        i13 = 16;
                    }
                    i11 |= i13;
                }
                i14 = i11;
                if ((i3 & Fields.TransformOrigin) != 0) {
                    i14 |= 384;
                } else if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i15 = Fields.RotationX;
                    } else {
                        i15 = Fields.SpotShadowColor;
                    }
                    i14 |= i15;
                }
                if ((306783379 & i4) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    } else {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    composer2 = composerStartRestartGroup;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                    }
                    ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke((Composer) obj, ((Number) obj2).intValue());
                        }

                        public final WindowInsets invoke(Composer composer3, int i23) {
                            composer3.startReplaceGroup(-2061903609);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                            }
                            WindowInsets windowInsets4 = windowInsets2;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            composer3.endReplaceGroup();
                            return windowInsets4;
                        }
                    }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f5 = fM2030getSheetMaxWidthD9Ej5fM;
                    windowInsets3 = windowInsets2;
                    modalBottomSheetProperties2 = properties;
                    function5 = function4;
                    f6 = f4;
                    long j11 = j4;
                    sheetState3 = sheetStateRememberModalBottomSheetState;
                    j5 = containerColor;
                    shape2 = expandedShape;
                    modifier3 = modifier2;
                    j6 = jM2173contentColorForek8zF_U;
                    j7 = j11;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    } else {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    composer2 = composerStartRestartGroup;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                    }
                    ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke((Composer) obj, ((Number) obj2).intValue());
                        }

                        public final WindowInsets invoke(Composer composer3, int i23) {
                            composer3.startReplaceGroup(-2061903609);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                            }
                            WindowInsets windowInsets4 = windowInsets2;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            composer3.endReplaceGroup();
                            return windowInsets4;
                        }
                    }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f5 = fM2030getSheetMaxWidthD9Ej5fM;
                    windowInsets3 = windowInsets2;
                    modalBottomSheetProperties2 = properties;
                    function5 = function4;
                    f6 = f4;
                    long j12 = j4;
                    sheetState3 = sheetStateRememberModalBottomSheetState;
                    j5 = containerColor;
                    shape2 = expandedShape;
                    modifier3 = modifier2;
                    j6 = jM2173contentColorForek8zF_U;
                    j7 = j12;
                }
                scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i23) {
                            ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i2 & 6) == 0) {
                i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
            } else {
                i11 = i2;
            }
            i12 = i3 & Fields.CameraDistance;
            if (i12 != 0) {
                i11 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                    i13 = 32;
                } else {
                    i13 = 16;
                }
                i11 |= i13;
            }
            i14 = i11;
            if ((i3 & Fields.TransformOrigin) != 0) {
                i14 |= 384;
            } else if ((i2 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i15 = Fields.RotationX;
                } else {
                    i15 = Fields.SpotShadowColor;
                }
                i14 |= i15;
            }
            if ((306783379 & i4) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                } else {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                }
                composerStartRestartGroup.endDefaults();
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                }
                ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke((Composer) obj, ((Number) obj2).intValue());
                    }

                    public final WindowInsets invoke(Composer composer3, int i23) {
                        composer3.startReplaceGroup(-2061903609);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                        }
                        WindowInsets windowInsets4 = windowInsets2;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer3.endReplaceGroup();
                        return windowInsets4;
                    }
                }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f5 = fM2030getSheetMaxWidthD9Ej5fM;
                windowInsets3 = windowInsets2;
                modalBottomSheetProperties2 = properties;
                function5 = function4;
                f6 = f4;
                long j13 = j4;
                sheetState3 = sheetStateRememberModalBottomSheetState;
                j5 = containerColor;
                shape2 = expandedShape;
                modifier3 = modifier2;
                j6 = jM2173contentColorForek8zF_U;
                j7 = j13;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                } else {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                }
                composerStartRestartGroup.endDefaults();
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                }
                ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke((Composer) obj, ((Number) obj2).intValue());
                    }

                    public final WindowInsets invoke(Composer composer3, int i23) {
                        composer3.startReplaceGroup(-2061903609);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                        }
                        WindowInsets windowInsets4 = windowInsets2;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer3.endReplaceGroup();
                        return windowInsets4;
                    }
                }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f5 = fM2030getSheetMaxWidthD9Ej5fM;
                windowInsets3 = windowInsets2;
                modalBottomSheetProperties2 = properties;
                function5 = function4;
                f6 = f4;
                long j14 = j4;
                sheetState3 = sheetStateRememberModalBottomSheetState;
                j5 = containerColor;
                shape2 = expandedShape;
                modifier3 = modifier2;
                j6 = jM2173contentColorForek8zF_U;
                j7 = j14;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i23) {
                        ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 48;
        modifier2 = modifier;
        if ((i & 384) == 0) {
            if ((i3 & 4) == 0) {
                sheetState2 = sheetState;
                if (composerStartRestartGroup.changed(sheetState2)) {
                    i21 = Fields.RotationX;
                }
                i4 |= i21;
            } else {
                sheetState2 = sheetState;
            }
            i21 = Fields.SpotShadowColor;
            i4 |= i21;
        } else {
            sheetState2 = sheetState;
        }
        i5 = i3 & 8;
        if (i5 != 0) {
            if ((i & 3072) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i6 = Fields.CameraDistance;
                } else {
                    i6 = Fields.RotationZ;
                }
                i4 |= i6;
            }
            if ((i & 24576) != 0) {
                i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
            }
            if ((i & 196608) != 0) {
                if ((i3 & 32) == 0) {
                    i20 = 65536;
                } else {
                    i20 = 65536;
                }
                i4 |= i20;
            }
            if ((i & 1572864) == 0) {
                jM2173contentColorForek8zF_U = j2;
                if ((i3 & 64) == 0) {
                    i19 = 524288;
                } else {
                    i19 = 524288;
                }
                i4 |= i19;
            } else {
                jM2173contentColorForek8zF_U = j2;
            }
            i7 = i3 & Fields.SpotShadowColor;
            if (i7 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(f2)) {
                    i8 = 8388608;
                } else {
                    i8 = 4194304;
                }
                i4 |= i8;
            }
            if ((i & 100663296) != 0) {
                i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(j3)) ? 33554432 : 67108864;
            }
            i9 = i3 & Fields.RotationY;
            if (i9 != 0) {
                if ((805306368 & i) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i2 & 6) == 0) {
                    i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
                } else {
                    i11 = i2;
                }
                i12 = i3 & Fields.CameraDistance;
                if (i12 != 0) {
                    i11 |= 48;
                } else if ((i2 & 48) == 0) {
                    if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                        i13 = 32;
                    } else {
                        i13 = 16;
                    }
                    i11 |= i13;
                }
                i14 = i11;
                if ((i3 & Fields.TransformOrigin) != 0) {
                    i14 |= 384;
                } else if ((i2 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i15 = Fields.RotationX;
                    } else {
                        i15 = Fields.SpotShadowColor;
                    }
                    i14 |= i15;
                }
                if ((306783379 & i4) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    } else {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    composer2 = composerStartRestartGroup;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                    }
                    ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke((Composer) obj, ((Number) obj2).intValue());
                        }

                        public final WindowInsets invoke(Composer composer3, int i23) {
                            composer3.startReplaceGroup(-2061903609);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                            }
                            WindowInsets windowInsets4 = windowInsets2;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            composer3.endReplaceGroup();
                            return windowInsets4;
                        }
                    }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f5 = fM2030getSheetMaxWidthD9Ej5fM;
                    windowInsets3 = windowInsets2;
                    modalBottomSheetProperties2 = properties;
                    function5 = function4;
                    f6 = f4;
                    long j15 = j4;
                    sheetState3 = sheetStateRememberModalBottomSheetState;
                    j5 = containerColor;
                    shape2 = expandedShape;
                    modifier3 = modifier2;
                    j6 = jM2173contentColorForek8zF_U;
                    j7 = j15;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    } else {
                        if (i22 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if ((i3 & 4) != 0) {
                            sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                            i4 &= -897;
                        } else {
                            sheetStateRememberModalBottomSheetState = sheetState2;
                        }
                        if (i5 != 0) {
                            fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                        } else {
                            fM2030getSheetMaxWidthD9Ej5fM = f;
                        }
                        if ((i3 & 16) != 0) {
                            expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                            i4 &= -57345;
                        } else {
                            expandedShape = shape;
                        }
                        if ((i3 & 32) != 0) {
                            i16 = i4 & (-458753);
                            containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        } else {
                            i16 = i4;
                            containerColor = j;
                        }
                        if ((i3 & 64) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                            i16 &= -3670017;
                        }
                        if (i7 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if ((i3 & Fields.RotationX) != 0) {
                            scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                            i17 = i16 & (-234881025);
                        } else {
                            scrimColor = j3;
                            i17 = i16;
                        }
                        if (i9 != 0) {
                            function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                        } else {
                            function2M2217getLambda1$material3_release = function2;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                            i14 &= -15;
                        } else {
                            windowInsets2 = windowInsets;
                        }
                        if (i12 != 0) {
                            properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                        } else {
                            properties = modalBottomSheetProperties;
                        }
                        i18 = i14;
                        modifier2 = companion;
                        f4 = f3;
                        function4 = function2M2217getLambda1$material3_release;
                        j4 = scrimColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    composer2 = composerStartRestartGroup;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                    }
                    ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            return invoke((Composer) obj, ((Number) obj2).intValue());
                        }

                        public final WindowInsets invoke(Composer composer3, int i23) {
                            composer3.startReplaceGroup(-2061903609);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                            }
                            WindowInsets windowInsets4 = windowInsets2;
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            composer3.endReplaceGroup();
                            return windowInsets4;
                        }
                    }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    f5 = fM2030getSheetMaxWidthD9Ej5fM;
                    windowInsets3 = windowInsets2;
                    modalBottomSheetProperties2 = properties;
                    function5 = function4;
                    f6 = f4;
                    long j16 = j4;
                    sheetState3 = sheetStateRememberModalBottomSheetState;
                    j5 = containerColor;
                    shape2 = expandedShape;
                    modifier3 = modifier2;
                    j6 = jM2173contentColorForek8zF_U;
                    j7 = j16;
                }
                scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i23) {
                            ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i2 & 6) == 0) {
                i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
            } else {
                i11 = i2;
            }
            i12 = i3 & Fields.CameraDistance;
            if (i12 != 0) {
                i11 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                    i13 = 32;
                } else {
                    i13 = 16;
                }
                i11 |= i13;
            }
            i14 = i11;
            if ((i3 & Fields.TransformOrigin) != 0) {
                i14 |= 384;
            } else if ((i2 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i15 = Fields.RotationX;
                } else {
                    i15 = Fields.SpotShadowColor;
                }
                i14 |= i15;
            }
            if ((306783379 & i4) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                } else {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                }
                composerStartRestartGroup.endDefaults();
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                }
                ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke((Composer) obj, ((Number) obj2).intValue());
                    }

                    public final WindowInsets invoke(Composer composer3, int i23) {
                        composer3.startReplaceGroup(-2061903609);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                        }
                        WindowInsets windowInsets4 = windowInsets2;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer3.endReplaceGroup();
                        return windowInsets4;
                    }
                }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f5 = fM2030getSheetMaxWidthD9Ej5fM;
                windowInsets3 = windowInsets2;
                modalBottomSheetProperties2 = properties;
                function5 = function4;
                f6 = f4;
                long j17 = j4;
                sheetState3 = sheetStateRememberModalBottomSheetState;
                j5 = containerColor;
                shape2 = expandedShape;
                modifier3 = modifier2;
                j6 = jM2173contentColorForek8zF_U;
                j7 = j17;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                } else {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                }
                composerStartRestartGroup.endDefaults();
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                }
                ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke((Composer) obj, ((Number) obj2).intValue());
                    }

                    public final WindowInsets invoke(Composer composer3, int i23) {
                        composer3.startReplaceGroup(-2061903609);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                        }
                        WindowInsets windowInsets4 = windowInsets2;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer3.endReplaceGroup();
                        return windowInsets4;
                    }
                }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f5 = fM2030getSheetMaxWidthD9Ej5fM;
                windowInsets3 = windowInsets2;
                modalBottomSheetProperties2 = properties;
                function5 = function4;
                f6 = f4;
                long j18 = j4;
                sheetState3 = sheetStateRememberModalBottomSheetState;
                j5 = containerColor;
                shape2 = expandedShape;
                modifier3 = modifier2;
                j6 = jM2173contentColorForek8zF_U;
                j7 = j18;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i23) {
                        ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        if ((i & 24576) != 0) {
            i4 |= ((i3 & 16) == 0 || !composerStartRestartGroup.changed(shape)) ? Fields.Shape : Fields.Clip;
        }
        if ((i & 196608) != 0) {
            if ((i3 & 32) == 0) {
                i20 = 65536;
            } else {
                i20 = 65536;
            }
            i4 |= i20;
        }
        if ((i & 1572864) == 0) {
            jM2173contentColorForek8zF_U = j2;
            if ((i3 & 64) == 0) {
                i19 = 524288;
            } else {
                i19 = 524288;
            }
            i4 |= i19;
        } else {
            jM2173contentColorForek8zF_U = j2;
        }
        i7 = i3 & Fields.SpotShadowColor;
        if (i7 != 0) {
            i4 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(f2)) {
                i8 = 8388608;
            } else {
                i8 = 4194304;
            }
            i4 |= i8;
        }
        if ((i & 100663296) != 0) {
            i4 |= ((i3 & Fields.RotationX) == 0 || !composerStartRestartGroup.changed(j3)) ? 33554432 : 67108864;
        }
        i9 = i3 & Fields.RotationY;
        if (i9 != 0) {
            if ((805306368 & i) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i10 = 536870912;
                } else {
                    i10 = 268435456;
                }
                i4 |= i10;
            }
            if ((i2 & 6) == 0) {
                i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
            } else {
                i11 = i2;
            }
            i12 = i3 & Fields.CameraDistance;
            if (i12 != 0) {
                i11 |= 48;
            } else if ((i2 & 48) == 0) {
                if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                    i13 = 32;
                } else {
                    i13 = 16;
                }
                i11 |= i13;
            }
            i14 = i11;
            if ((i3 & Fields.TransformOrigin) != 0) {
                i14 |= 384;
            } else if ((i2 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i15 = Fields.RotationX;
                } else {
                    i15 = Fields.SpotShadowColor;
                }
                i14 |= i15;
            }
            if ((306783379 & i4) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                } else {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                }
                composerStartRestartGroup.endDefaults();
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                }
                ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke((Composer) obj, ((Number) obj2).intValue());
                    }

                    public final WindowInsets invoke(Composer composer3, int i23) {
                        composer3.startReplaceGroup(-2061903609);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                        }
                        WindowInsets windowInsets4 = windowInsets2;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer3.endReplaceGroup();
                        return windowInsets4;
                    }
                }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f5 = fM2030getSheetMaxWidthD9Ej5fM;
                windowInsets3 = windowInsets2;
                modalBottomSheetProperties2 = properties;
                function5 = function4;
                f6 = f4;
                long j19 = j4;
                sheetState3 = sheetStateRememberModalBottomSheetState;
                j5 = containerColor;
                shape2 = expandedShape;
                modifier3 = modifier2;
                j6 = jM2173contentColorForek8zF_U;
                j7 = j19;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                } else {
                    if (i22 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if ((i3 & 4) != 0) {
                        sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                        i4 &= -897;
                    } else {
                        sheetStateRememberModalBottomSheetState = sheetState2;
                    }
                    if (i5 != 0) {
                        fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                    } else {
                        fM2030getSheetMaxWidthD9Ej5fM = f;
                    }
                    if ((i3 & 16) != 0) {
                        expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                        i4 &= -57345;
                    } else {
                        expandedShape = shape;
                    }
                    if ((i3 & 32) != 0) {
                        i16 = i4 & (-458753);
                        containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    } else {
                        i16 = i4;
                        containerColor = j;
                    }
                    if ((i3 & 64) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                        i16 &= -3670017;
                    }
                    if (i7 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                        i17 = i16 & (-234881025);
                    } else {
                        scrimColor = j3;
                        i17 = i16;
                    }
                    if (i9 != 0) {
                        function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                    } else {
                        function2M2217getLambda1$material3_release = function2;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                        i14 &= -15;
                    } else {
                        windowInsets2 = windowInsets;
                    }
                    if (i12 != 0) {
                        properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                    } else {
                        properties = modalBottomSheetProperties;
                    }
                    i18 = i14;
                    modifier2 = companion;
                    f4 = f3;
                    function4 = function2M2217getLambda1$material3_release;
                    j4 = scrimColor;
                }
                composerStartRestartGroup.endDefaults();
                composer2 = composerStartRestartGroup;
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
                }
                ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        return invoke((Composer) obj, ((Number) obj2).intValue());
                    }

                    public final WindowInsets invoke(Composer composer3, int i23) {
                        composer3.startReplaceGroup(-2061903609);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                        }
                        WindowInsets windowInsets4 = windowInsets2;
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        composer3.endReplaceGroup();
                        return windowInsets4;
                    }
                }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                f5 = fM2030getSheetMaxWidthD9Ej5fM;
                windowInsets3 = windowInsets2;
                modalBottomSheetProperties2 = properties;
                function5 = function4;
                f6 = f4;
                long j110 = j4;
                sheetState3 = sheetStateRememberModalBottomSheetState;
                j5 = containerColor;
                shape2 = expandedShape;
                modifier3 = modifier2;
                j6 = jM2173contentColorForek8zF_U;
                j7 = j110;
            }
            scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i23) {
                        ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 805306368;
        if ((i2 & 6) == 0) {
            i11 = i2 | (((i3 & Fields.RotationZ) == 0 || !composerStartRestartGroup.changed(windowInsets)) ? 2 : 4);
        } else {
            i11 = i2;
        }
        i12 = i3 & Fields.CameraDistance;
        if (i12 != 0) {
            i11 |= 48;
        } else if ((i2 & 48) == 0) {
            if (composerStartRestartGroup.changed(modalBottomSheetProperties)) {
                i13 = 32;
            } else {
                i13 = 16;
            }
            i11 |= i13;
        }
        i14 = i11;
        if ((i3 & Fields.TransformOrigin) != 0) {
            i14 |= 384;
        } else if ((i2 & 384) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i15 = Fields.RotationX;
            } else {
                i15 = Fields.SpotShadowColor;
            }
            i14 |= i15;
        }
        if ((306783379 & i4) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i22 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                    i4 &= -897;
                } else {
                    sheetStateRememberModalBottomSheetState = sheetState2;
                }
                if (i5 != 0) {
                    fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                } else {
                    fM2030getSheetMaxWidthD9Ej5fM = f;
                }
                if ((i3 & 16) != 0) {
                    expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    expandedShape = shape;
                }
                if ((i3 & 32) != 0) {
                    i16 = i4 & (-458753);
                    containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                } else {
                    i16 = i4;
                    containerColor = j;
                }
                if ((i3 & 64) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                    i16 &= -3670017;
                }
                if (i7 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                    i17 = i16 & (-234881025);
                } else {
                    scrimColor = j3;
                    i17 = i16;
                }
                if (i9 != 0) {
                    function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                } else {
                    function2M2217getLambda1$material3_release = function2;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -15;
                } else {
                    windowInsets2 = windowInsets;
                }
                if (i12 != 0) {
                    properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                } else {
                    properties = modalBottomSheetProperties;
                }
                i18 = i14;
                modifier2 = companion;
                f4 = f3;
                function4 = function2M2217getLambda1$material3_release;
                j4 = scrimColor;
            } else {
                if (i22 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                    i4 &= -897;
                } else {
                    sheetStateRememberModalBottomSheetState = sheetState2;
                }
                if (i5 != 0) {
                    fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                } else {
                    fM2030getSheetMaxWidthD9Ej5fM = f;
                }
                if ((i3 & 16) != 0) {
                    expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    expandedShape = shape;
                }
                if ((i3 & 32) != 0) {
                    i16 = i4 & (-458753);
                    containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                } else {
                    i16 = i4;
                    containerColor = j;
                }
                if ((i3 & 64) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                    i16 &= -3670017;
                }
                if (i7 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                    i17 = i16 & (-234881025);
                } else {
                    scrimColor = j3;
                    i17 = i16;
                }
                if (i9 != 0) {
                    function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                } else {
                    function2M2217getLambda1$material3_release = function2;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -15;
                } else {
                    windowInsets2 = windowInsets;
                }
                if (i12 != 0) {
                    properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                } else {
                    properties = modalBottomSheetProperties;
                }
                i18 = i14;
                modifier2 = companion;
                f4 = f3;
                function4 = function2M2217getLambda1$material3_release;
                j4 = scrimColor;
            }
            composerStartRestartGroup.endDefaults();
            composer2 = composerStartRestartGroup;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
            }
            ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return invoke((Composer) obj, ((Number) obj2).intValue());
                }

                public final WindowInsets invoke(Composer composer3, int i23) {
                    composer3.startReplaceGroup(-2061903609);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                    }
                    WindowInsets windowInsets4 = windowInsets2;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer3.endReplaceGroup();
                    return windowInsets4;
                }
            }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f5 = fM2030getSheetMaxWidthD9Ej5fM;
            windowInsets3 = windowInsets2;
            modalBottomSheetProperties2 = properties;
            function5 = function4;
            f6 = f4;
            long j111 = j4;
            sheetState3 = sheetStateRememberModalBottomSheetState;
            j5 = containerColor;
            shape2 = expandedShape;
            modifier3 = modifier2;
            j6 = jM2173contentColorForek8zF_U;
            j7 = j111;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i22 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                    i4 &= -897;
                } else {
                    sheetStateRememberModalBottomSheetState = sheetState2;
                }
                if (i5 != 0) {
                    fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                } else {
                    fM2030getSheetMaxWidthD9Ej5fM = f;
                }
                if ((i3 & 16) != 0) {
                    expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    expandedShape = shape;
                }
                if ((i3 & 32) != 0) {
                    i16 = i4 & (-458753);
                    containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                } else {
                    i16 = i4;
                    containerColor = j;
                }
                if ((i3 & 64) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                    i16 &= -3670017;
                }
                if (i7 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                    i17 = i16 & (-234881025);
                } else {
                    scrimColor = j3;
                    i17 = i16;
                }
                if (i9 != 0) {
                    function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                } else {
                    function2M2217getLambda1$material3_release = function2;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -15;
                } else {
                    windowInsets2 = windowInsets;
                }
                if (i12 != 0) {
                    properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                } else {
                    properties = modalBottomSheetProperties;
                }
                i18 = i14;
                modifier2 = companion;
                f4 = f3;
                function4 = function2M2217getLambda1$material3_release;
                j4 = scrimColor;
            } else {
                if (i22 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if ((i3 & 4) != 0) {
                    sheetStateRememberModalBottomSheetState = ModalBottomSheetKt.rememberModalBottomSheetState(false, null, composerStartRestartGroup, 0, 3);
                    i4 &= -897;
                } else {
                    sheetStateRememberModalBottomSheetState = sheetState2;
                }
                if (i5 != 0) {
                    fM2030getSheetMaxWidthD9Ej5fM = BottomSheetDefaults.INSTANCE.m2030getSheetMaxWidthD9Ej5fM();
                } else {
                    fM2030getSheetMaxWidthD9Ej5fM = f;
                }
                if ((i3 & 16) != 0) {
                    expandedShape = BottomSheetDefaults.INSTANCE.getExpandedShape(composerStartRestartGroup, 6);
                    i4 &= -57345;
                } else {
                    expandedShape = shape;
                }
                if ((i3 & 32) != 0) {
                    i16 = i4 & (-458753);
                    containerColor = BottomSheetDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                } else {
                    i16 = i4;
                    containerColor = j;
                }
                if ((i3 & 64) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i16 >> 15) & 14);
                    i16 &= -3670017;
                }
                if (i7 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    scrimColor = BottomSheetDefaults.INSTANCE.getScrimColor(composerStartRestartGroup, 6);
                    i17 = i16 & (-234881025);
                } else {
                    scrimColor = j3;
                    i17 = i16;
                }
                if (i9 != 0) {
                    function2M2217getLambda1$material3_release = ComposableSingletons$ModalBottomSheet_androidKt.INSTANCE.m2217getLambda1$material3_release();
                } else {
                    function2M2217getLambda1$material3_release = function2;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    windowInsets2 = BottomSheetDefaults.INSTANCE.getWindowInsets(composerStartRestartGroup, 6);
                    i14 &= -15;
                } else {
                    windowInsets2 = windowInsets;
                }
                if (i12 != 0) {
                    properties = ModalBottomSheetDefaults.INSTANCE.getProperties();
                } else {
                    properties = modalBottomSheetProperties;
                }
                i18 = i14;
                modifier2 = companion;
                f4 = f3;
                function4 = function2M2217getLambda1$material3_release;
                j4 = scrimColor;
            }
            composerStartRestartGroup.endDefaults();
            composer2 = composerStartRestartGroup;
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(944867294, i17, i18, "androidx.compose.material3.ModalBottomSheet (ModalBottomSheet.android.kt:247)");
            }
            ModalBottomSheetKt.m2528ModalBottomSheetdYc4hso(function0, modifier2, sheetStateRememberModalBottomSheetState, fM2030getSheetMaxWidthD9Ej5fM, expandedShape, containerColor, jM2173contentColorForek8zF_U, f4, j4, function4, new Function2<Composer, Integer, WindowInsets>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return invoke((Composer) obj, ((Number) obj2).intValue());
                }

                public final WindowInsets invoke(Composer composer3, int i23) {
                    composer3.startReplaceGroup(-2061903609);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-2061903609, i23, -1, "androidx.compose.material3.ModalBottomSheet.<anonymous> (ModalBottomSheet.android.kt:258)");
                    }
                    WindowInsets windowInsets4 = windowInsets2;
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    composer3.endReplaceGroup();
                    return windowInsets4;
                }
            }, properties, function3, composer2, i17 & 2147483646, i18 & 1008, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            f5 = fM2030getSheetMaxWidthD9Ej5fM;
            windowInsets3 = windowInsets2;
            modalBottomSheetProperties2 = properties;
            function5 = function4;
            f6 = f4;
            long j112 = j4;
            sheetState3 = sheetStateRememberModalBottomSheetState;
            j5 = containerColor;
            shape2 = expandedShape;
            modifier3 = modifier2;
            j6 = jM2173contentColorForek8zF_U;
            j7 = j112;
        }
        scopeUpdateScopeEndRestartGroup = composer2.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i23) {
                    ModalBottomSheet_androidKt.m2540ModalBottomSheetdYc4hso(function0, modifier3, sheetState3, f5, shape2, j5, j6, f6, j7, function5, windowInsets3, modalBottomSheetProperties2, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    public static final void ModalBottomSheetDialog(final Function0<Unit> function0, final ModalBottomSheetProperties modalBottomSheetProperties, final Animatable<Float, AnimationVector1D> animatable, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i) {
        int i2;
        boolean z;
        Composer composerStartRestartGroup = composer.startRestartGroup(1254951810);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ModalBottomSheetDialog)P(1,3,2)273@11822L7,274@11861L7,275@11916L7,276@11946L28,277@12001L29,278@12050L38,279@12105L24,280@12157L21,282@12204L697,305@12932L129,305@12907L154,314@13078L182,314@13067L193:ModalBottomSheet.android.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changed(modalBottomSheetProperties) ? 32 : 16;
        }
        if ((i & 384) == 0) {
            i2 |= (i & Fields.RotationY) == 0 ? composerStartRestartGroup.changed(animatable) : composerStartRestartGroup.changedInstance(animatable) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i & 3072) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function2) ? Fields.CameraDistance : Fields.RotationZ;
        }
        int i3 = i2;
        if ((i3 & 1171) != 1170 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1254951810, i3, -1, "androidx.compose.material3.ModalBottomSheetDialog (ModalBottomSheet.android.kt:272)");
            }
            ProvidableCompositionLocal<View> localView = AndroidCompositionLocals_androidKt.getLocalView();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composerStartRestartGroup.consume(localView);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            View view = (View) objConsume;
            ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume2 = composerStartRestartGroup.consume(localDensity);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Density density = (Density) objConsume2;
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume3 = composerStartRestartGroup.consume(localLayoutDirection);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            final LayoutDirection layoutDirection = (LayoutDirection) objConsume3;
            CompositionContext compositionContextRememberCompositionContext = ComposablesKt.rememberCompositionContext(composerStartRestartGroup, 0);
            final State stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(function2, composerStartRestartGroup, (i3 >> 9) & 14);
            UUID uuid = (UUID) RememberSaveableKt.m4142rememberSaveable(new Object[0], (Saver) null, (String) null, (Function0) new Function0<UUID>() {
                public final UUID invoke() {
                    return UUID.randomUUID();
                }
            }, composerStartRestartGroup, 3072, 6);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954363344, "CC(remember):Effects.kt#9igjgp");
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                objRememberedValue = compositionScopedCoroutineScopeCanceller;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            boolean zIsSystemInDarkTheme = DarkThemeKt.isSystemInDarkTheme(composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1981517173, "CC(remember):ModalBottomSheet.android.kt#9igjgp");
            boolean zChanged = composerStartRestartGroup.changed(view) | composerStartRestartGroup.changed(density);
            Object objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (zChanged || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                z = true;
                ModalBottomSheetDialogWrapper modalBottomSheetDialogWrapper = new ModalBottomSheetDialogWrapper(function0, modalBottomSheetProperties, view, layoutDirection, density, uuid, animatable, coroutineScope, zIsSystemInDarkTheme);
                modalBottomSheetDialogWrapper.setContent(compositionContextRememberCompositionContext, ComposableLambdaKt.composableLambdaInstance(-1560960657, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i4) {
                        ComposerKt.sourceInformation(composer2, "C296@12687L164:ModalBottomSheet.android.kt#uh7d8r");
                        if ((i4 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1560960657, i4, -1, "androidx.compose.material3.ModalBottomSheetDialog.<anonymous>.<anonymous>.<anonymous> (ModalBottomSheet.android.kt:296)");
                            }
                            Modifier modifierSemantics$default = SemanticsModifierKt.semantics$default(Modifier.INSTANCE, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                                public Object invoke(Object obj) {
                                    invoke((SemanticsPropertyReceiver) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    SemanticsPropertiesKt.dialog(semanticsPropertyReceiver);
                                }
                            }, 1, null);
                            State<Function2<Composer, Integer, Unit>> state = stateRememberUpdatedState;
                            ComposerKt.sourceInformationMarkerStart(composer2, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(Alignment.INSTANCE.getTopStart(), false);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierSemantics$default);
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
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            ComposerKt.sourceInformationMarkerStart(composer2, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                            ComposerKt.sourceInformationMarkerStart(composer2, -490070203, "C299@12809L16:ModalBottomSheet.android.kt#uh7d8r");
                            ModalBottomSheet_androidKt.ModalBottomSheetDialog$lambda$0(state).invoke(composer2, 0);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            composer2.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            ComposerKt.sourceInformationMarkerEnd(composer2);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }));
                composerStartRestartGroup.updateRememberedValue(modalBottomSheetDialogWrapper);
                objRememberedValue2 = modalBottomSheetDialogWrapper;
            } else {
                z = true;
            }
            final ModalBottomSheetDialogWrapper modalBottomSheetDialogWrapper2 = (ModalBottomSheetDialogWrapper) objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1981494445, "CC(remember):ModalBottomSheet.android.kt#9igjgp");
            boolean zChangedInstance = composerStartRestartGroup.changedInstance(modalBottomSheetDialogWrapper2);
            Object objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue3 = (Function1) new Function1<DisposableEffectScope, DisposableEffectResult>() {
                    {
                        super(1);
                    }

                    public final DisposableEffectResult invoke(DisposableEffectScope disposableEffectScope) {
                        modalBottomSheetDialogWrapper2.show();
                        final ModalBottomSheetDialogWrapper modalBottomSheetDialogWrapper3 = modalBottomSheetDialogWrapper2;
                        return new DisposableEffectResult() {
                            @Override
                            public void dispose() {
                                modalBottomSheetDialogWrapper3.dismiss();
                                modalBottomSheetDialogWrapper3.disposeComposition();
                            }
                        };
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.DisposableEffect(modalBottomSheetDialogWrapper2, (Function1<? super DisposableEffectScope, ? extends DisposableEffectResult>) objRememberedValue3, composerStartRestartGroup, 0);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1981489720, "CC(remember):ModalBottomSheet.android.kt#9igjgp");
            boolean zChangedInstance2 = composerStartRestartGroup.changedInstance(modalBottomSheetDialogWrapper2) | ((i3 & 14) == 4 ? z : false) | ((i3 & 112) == 32 ? z : false) | composerStartRestartGroup.changed(layoutDirection);
            Object objRememberedValue4 = composerStartRestartGroup.rememberedValue();
            if (zChangedInstance2 || objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
                objRememberedValue4 = (Function0) new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m2541invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m2541invoke() {
                        modalBottomSheetDialogWrapper2.updateParameters(function0, modalBottomSheetProperties, layoutDirection);
                    }
                };
                composerStartRestartGroup.updateRememberedValue(objRememberedValue4);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            EffectsKt.SideEffect((Function0) objRememberedValue4, composerStartRestartGroup, 0);
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

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i4) {
                    ModalBottomSheet_androidKt.ModalBottomSheetDialog(function0, modalBottomSheetProperties, animatable, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    public static final boolean isFlagSecureEnabled(View view) {
        ViewGroup.LayoutParams layoutParams = view.getRootView().getLayoutParams();
        WindowManager.LayoutParams layoutParams2 = layoutParams instanceof WindowManager.LayoutParams ? (WindowManager.LayoutParams) layoutParams : null;
        return (layoutParams2 == null || (layoutParams2.flags & Fields.Shape) == 0) ? false : true;
    }

    public static final boolean shouldApplySecureFlag(SecureFlagPolicy secureFlagPolicy, boolean z) throws NoWhenBranchMatchedException {
        int i = WhenMappings.$EnumSwitchMapping$0[secureFlagPolicy.ordinal()];
        if (i == 1) {
            return false;
        }
        if (i == 2) {
            return true;
        }
        if (i == 3) {
            return z;
        }
        throw new NoWhenBranchMatchedException();
    }

    public static final Function2<Composer, Integer, Unit> ModalBottomSheetDialog$lambda$0(State<? extends Function2<? super Composer, ? super Integer, Unit>> state) {
        return state.getValue();
    }
}
