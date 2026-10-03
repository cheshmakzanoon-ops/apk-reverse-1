package androidx.compose.material3;

import androidx.compose.animation.AnimatedVisibilityKt;
import androidx.compose.animation.AnimatedVisibilityScope;
import androidx.compose.animation.EnterExitTransitionKt;
import androidx.compose.animation.EnterTransition;
import androidx.compose.animation.ExitTransition;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.RowKt;
import androidx.compose.foundation.layout.RowScope;
import androidx.compose.foundation.layout.RowScopeInstance;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.layout.SpacerKt;
import androidx.compose.material3.internal.ProvideContentColorTextStyleKt;
import androidx.compose.material3.tokens.ExtendedFabPrimaryTokens;
import androidx.compose.material3.tokens.FabPrimaryLargeTokens;
import androidx.compose.material3.tokens.FabPrimarySmallTokens;
import androidx.compose.material3.tokens.FabPrimaryTokens;
import androidx.compose.material3.tokens.MotionTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.p002ui.semantics.Role;
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
import androidx.compose.ui.text.TextStyle;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000`\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\n\u001a|\u0010\n\u001a\u00020\u000b2\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u00162\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u001c\u0010\u0019\u001a\u0018\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\u000b0\u001a¢\u0006\u0002\b\u001c¢\u0006\u0002\b\u001dH\u0007ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001f\u001a\u008e\u0001\u0010\n\u001a\u00020\u000b2\u0011\u0010 \u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u001c2\u0011\u0010!\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u001c2\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\"\u001a\u00020#2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u00162\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u0018H\u0007ø\u0001\u0000¢\u0006\u0004\b$\u0010%\u001aq\u0010&\u001a\u00020\u000b2\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u00162\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u0011\u0010\u0019\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u001cH\u0007ø\u0001\u0000¢\u0006\u0004\b'\u0010(\u001aq\u0010)\u001a\u00020\u000b2\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u00162\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u0011\u0010\u0019\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u001cH\u0007ø\u0001\u0000¢\u0006\u0004\b*\u0010(\u001aq\u0010+\u001a\u00020\u000b2\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u00132\b\b\u0002\u0010\u0014\u001a\u00020\u00132\b\b\u0002\u0010\u0015\u001a\u00020\u00162\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u00182\u0011\u0010\u0019\u001a\r\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\u0002\b\u001cH\u0007ø\u0001\u0000¢\u0006\u0004\b,\u0010(\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0010\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0010\u0010\u0007\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0010\u0010\b\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\"\u0010\u0010\t\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006-"}, d2 = {"ExtendedFabCollapseAnimation", "Landroidx/compose/animation/ExitTransition;", "ExtendedFabEndIconPadding", "Landroidx/compose/ui/unit/Dp;", "F", "ExtendedFabExpandAnimation", "Landroidx/compose/animation/EnterTransition;", "ExtendedFabMinimumWidth", "ExtendedFabStartIconPadding", "ExtendedFabTextPadding", "ExtendedFloatingActionButton", "", "onClick", "Lkotlin/Function0;", "modifier", "Landroidx/compose/ui/Modifier;", "shape", "Landroidx/compose/ui/graphics/Shape;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "contentColor", "elevation", "Landroidx/compose/material3/FloatingActionButtonElevation;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/RowScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "ExtendedFloatingActionButton-X-z6DiA", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/ui/graphics/Shape;JJLandroidx/compose/material3/FloatingActionButtonElevation;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "text", "icon", "expanded", "", "ExtendedFloatingActionButton-ElI5-7k", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;ZLandroidx/compose/ui/graphics/Shape;JJLandroidx/compose/material3/FloatingActionButtonElevation;Landroidx/compose/foundation/interaction/MutableInteractionSource;Landroidx/compose/runtime/Composer;II)V", "FloatingActionButton", "FloatingActionButton-X-z6DiA", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/ui/Modifier;Landroidx/compose/ui/graphics/Shape;JJLandroidx/compose/material3/FloatingActionButtonElevation;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;II)V", "LargeFloatingActionButton", "LargeFloatingActionButton-X-z6DiA", "SmallFloatingActionButton", "SmallFloatingActionButton-X-z6DiA", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class FloatingActionButtonKt {
    private static final float ExtendedFabStartIconPadding = Dp.constructor-impl(16);
    private static final float ExtendedFabEndIconPadding = Dp.constructor-impl(12);
    private static final float ExtendedFabTextPadding = Dp.constructor-impl(20);
    private static final float ExtendedFabMinimumWidth = Dp.constructor-impl(80);
    private static final ExitTransition ExtendedFabCollapseAnimation = EnterExitTransitionKt.fadeOut$default(AnimationSpecKt.tween$default(100, 0, MotionTokens.INSTANCE.getEasingLinearCubicBezier(), 2, null), 0.0f, 2, null).plus(EnterExitTransitionKt.shrinkHorizontally$default(AnimationSpecKt.tween$default(500, 0, MotionTokens.INSTANCE.getEasingEmphasizedCubicBezier(), 2, null), Alignment.INSTANCE.getStart(), false, null, 12, null));
    private static final EnterTransition ExtendedFabExpandAnimation = EnterExitTransitionKt.fadeIn$default(AnimationSpecKt.tween(ComposerKt.invocationKey, 100, MotionTokens.INSTANCE.getEasingLinearCubicBezier()), 0.0f, 2, null).plus(EnterExitTransitionKt.expandHorizontally$default(AnimationSpecKt.tween$default(500, 0, MotionTokens.INSTANCE.getEasingEmphasizedCubicBezier(), 2, null), Alignment.INSTANCE.getStart(), false, null, 12, null));

    public static final void m2408FloatingActionButtonXz6DiA(final Function0<Unit> function0, Modifier modifier, Shape shape, long j, long j2, FloatingActionButtonElevation floatingActionButtonElevation, MutableInteractionSource mutableInteractionSource, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Shape shape2;
        long containerColor;
        final long j3;
        FloatingActionButtonElevation floatingActionButtonElevationM2400elevationxZ9QkE;
        int i4;
        int i5;
        int i6;
        Modifier.Companion companion;
        Shape shape3;
        int i7;
        long jM2173contentColorForek8zF_U;
        int i8;
        MutableInteractionSource mutableInteractionSource2;
        int i9;
        FloatingActionButtonElevation floatingActionButtonElevation2;
        MutableInteractionSource mutableInteractionSource3;
        MutableInteractionSource mutableInteractionSource4;
        final Shape shape4;
        final long j4;
        final long j5;
        final Modifier modifier2;
        final FloatingActionButtonElevation floatingActionButtonElevation3;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i10;
        int i11;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(-731723913);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(FloatingActionButton)P(6,5,7,0:c#ui.graphics.Color,2:c#ui.graphics.Color,3,4)100@4948L5,101@5012L14,102@5054L31,103@5163L11,116@5678L54,118@5792L536,109@5399L929:FloatingActionButton.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 2;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i12 = Fields.RotationX;
                    }
                    i3 |= i12;
                } else {
                    shape2 = shape;
                }
                i12 = Fields.SpotShadowColor;
                i3 |= i12;
            } else {
                shape2 = shape;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    containerColor = j;
                    if (composerStartRestartGroup.changed(containerColor)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    containerColor = j;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                containerColor = j;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    j3 = j2;
                    if (composerStartRestartGroup.changed(j3)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    j3 = j2;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                j3 = j2;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                    int i14 = composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE) ? Fields.RenderEffect : 65536;
                    i3 |= i14;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                }
                i3 |= i14;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i4 = i2 & 64;
            if (i4 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i5 = 1048576;
                } else {
                    i5 = 524288;
                }
                i3 |= i5;
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i6 = 8388608;
                } else {
                    i6 = 4194304;
                }
                i3 |= i6;
            }
            if ((4793491 & i3) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        shape3 = FloatingActionButtonDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                    } else {
                        shape3 = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        i9 = i8;
                        floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        shape2 = shape3;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                        i9 = i8;
                        floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        shape2 = shape3;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                    }
                    companion = modifier;
                    mutableInteractionSource2 = mutableInteractionSource;
                    i9 = i3;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-731723913, i9, -1, "androidx.compose.material3.FloatingActionButton (FloatingActionButton.kt:106)");
                }
                composerStartRestartGroup.startReplaceGroup(519755085);
                ComposerKt.sourceInformation(composerStartRestartGroup, "108@5355L39");
                if (mutableInteractionSource2 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519755736, "CC(remember):FloatingActionButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                composerStartRestartGroup.endReplaceGroup();
                MutableInteractionSource mutableInteractionSource5 = mutableInteractionSource2;
                Modifier modifier3 = companion;
                int i15 = i9 << 3;
                SurfaceKt.m2871Surfaceo_FOJdg(function0, SemanticsModifierKt.semantics$default(companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6611getButtono7Vup1c());
                    }
                }, 1, null), false, shape2, containerColor, j3, floatingActionButtonElevation2.getDefaultElevation(), floatingActionButtonElevation2.shadowElevation$material3_release(mutableInteractionSource3, composerStartRestartGroup, (i9 >> 12) & 112).getValue().unbox-impl(), null, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(1249316354, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        ComposerKt.sourceInformation(composer2, "C121@5936L5,122@5952L370,119@5802L520:FloatingActionButton.kt#uh7d8r");
                        if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1249316354, i16, -1, "androidx.compose.material3.FloatingActionButton.<anonymous> (FloatingActionButton.kt:119)");
                            }
                            long j6 = j3;
                            TextStyle value = TypographyKt.getValue(ExtendedFabPrimaryTokens.INSTANCE.getLabelTextFont(), composer2, 6);
                            final Function2<Composer, Integer, Unit> function3 = function2;
                            ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(j6, value, ComposableLambdaKt.rememberComposableLambda(-1771489750, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i17) {
                                    ComposerKt.sourceInformation(composer3, "C123@5966L346:FloatingActionButton.kt#uh7d8r");
                                    if ((i17 & 3) != 2 || !composer3.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-1771489750, i17, -1, "androidx.compose.material3.FloatingActionButton.<anonymous>.<anonymous> (FloatingActionButton.kt:123)");
                                        }
                                        Modifier modifierM1064defaultMinSizeVpY3zN4 = SizeKt.m1064defaultMinSizeVpY3zN4(Modifier.INSTANCE, FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM(), FabPrimaryTokens.INSTANCE.m3576getContainerHeightD9Ej5fM());
                                        Alignment center = Alignment.INSTANCE.getCenter();
                                        Function2<Composer, Integer, Unit> function4 = function3;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                        MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(center, false);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierM1064defaultMinSizeVpY3zN4);
                                        Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                        BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1494899604, "C131@6289L9:FloatingActionButton.kt#uh7d8r");
                                        function4.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                            return;
                                        }
                                        return;
                                    }
                                    composer3.skipToGroupEnd();
                                }
                            }, composer2, 54), composer2, 384);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                                return;
                            }
                            return;
                        }
                        composer2.skipToGroupEnd();
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i9 & 14) | (i15 & 7168) | (57344 & i15) | (i15 & 458752), 6, 260);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource4 = mutableInteractionSource5;
                shape4 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = modifier3;
                floatingActionButtonElevation3 = floatingActionButtonElevation2;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier2 = modifier;
                mutableInteractionSource4 = mutableInteractionSource;
                shape4 = shape2;
                j4 = containerColor;
                j5 = j3;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource6 = mutableInteractionSource4;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i16) {
                        FloatingActionButtonKt.m2408FloatingActionButtonXz6DiA(function0, modifier2, shape4, j4, j5, floatingActionButtonElevation3, mutableInteractionSource6, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i12 = Fields.RotationX;
                }
                i3 |= i12;
            } else {
                shape2 = shape;
            }
            i12 = Fields.SpotShadowColor;
            i3 |= i12;
        } else {
            shape2 = shape;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                containerColor = j;
                if (composerStartRestartGroup.changed(containerColor)) {
                    i11 = Fields.CameraDistance;
                }
                i3 |= i11;
            } else {
                containerColor = j;
            }
            i11 = Fields.RotationZ;
            i3 |= i11;
        } else {
            containerColor = j;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                j3 = j2;
                if (composerStartRestartGroup.changed(j3)) {
                    i10 = Fields.Clip;
                }
                i3 |= i10;
            } else {
                j3 = j2;
            }
            i10 = Fields.Shape;
            i3 |= i10;
        } else {
            j3 = j2;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                if (composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE)) {
                }
                i3 |= i14;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i3 |= i14;
        } else {
            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
        }
        i4 = i2 & 64;
        if (i4 != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i5 = 1048576;
            } else {
                i5 = 524288;
            }
            i3 |= i5;
        }
        if ((i2 & Fields.SpotShadowColor) != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i6 = 8388608;
            } else {
                i6 = 4194304;
            }
            i3 |= i6;
        }
        if ((4793491 & i3) == 4793490) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    shape3 = FloatingActionButtonDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    shape3 = FloatingActionButtonDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-731723913, i9, -1, "androidx.compose.material3.FloatingActionButton (FloatingActionButton.kt:106)");
            }
            composerStartRestartGroup.startReplaceGroup(519755085);
            ComposerKt.sourceInformation(composerStartRestartGroup, "108@5355L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519755736, "CC(remember):FloatingActionButton.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            MutableInteractionSource mutableInteractionSource7 = mutableInteractionSource2;
            Modifier modifier4 = companion;
            int i16 = i9 << 3;
            SurfaceKt.m2871Surfaceo_FOJdg(function0, SemanticsModifierKt.semantics$default(companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                public Object invoke(Object obj) {
                    invoke((SemanticsPropertyReceiver) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6611getButtono7Vup1c());
                }
            }, 1, null), false, shape2, containerColor, j3, floatingActionButtonElevation2.getDefaultElevation(), floatingActionButtonElevation2.shadowElevation$material3_release(mutableInteractionSource3, composerStartRestartGroup, (i9 >> 12) & 112).getValue().unbox-impl(), null, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(1249316354, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i17) {
                    ComposerKt.sourceInformation(composer2, "C121@5936L5,122@5952L370,119@5802L520:FloatingActionButton.kt#uh7d8r");
                    if ((i17 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1249316354, i17, -1, "androidx.compose.material3.FloatingActionButton.<anonymous> (FloatingActionButton.kt:119)");
                        }
                        long j6 = j3;
                        TextStyle value = TypographyKt.getValue(ExtendedFabPrimaryTokens.INSTANCE.getLabelTextFont(), composer2, 6);
                        final Function2<? super Composer, ? super Integer, Unit> function3 = function2;
                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(j6, value, ComposableLambdaKt.rememberComposableLambda(-1771489750, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i18) {
                                ComposerKt.sourceInformation(composer3, "C123@5966L346:FloatingActionButton.kt#uh7d8r");
                                if ((i18 & 3) != 2 || !composer3.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1771489750, i18, -1, "androidx.compose.material3.FloatingActionButton.<anonymous>.<anonymous> (FloatingActionButton.kt:123)");
                                    }
                                    Modifier modifierM1064defaultMinSizeVpY3zN4 = SizeKt.m1064defaultMinSizeVpY3zN4(Modifier.INSTANCE, FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM(), FabPrimaryTokens.INSTANCE.m3576getContainerHeightD9Ej5fM());
                                    Alignment center = Alignment.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(center, false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierM1064defaultMinSizeVpY3zN4);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1494899604, "C131@6289L9:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer3.skipToGroupEnd();
                            }
                        }, composer2, 54), composer2, 384);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i9 & 14) | (i16 & 7168) | (57344 & i16) | (i16 & 458752), 6, 260);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource4 = mutableInteractionSource7;
            shape4 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = modifier4;
            floatingActionButtonElevation3 = floatingActionButtonElevation2;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    shape3 = FloatingActionButtonDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    shape3 = FloatingActionButtonDefaults.INSTANCE.getShape(composerStartRestartGroup, 6);
                } else {
                    shape3 = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = shape3;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-731723913, i9, -1, "androidx.compose.material3.FloatingActionButton (FloatingActionButton.kt:106)");
            }
            composerStartRestartGroup.startReplaceGroup(519755085);
            ComposerKt.sourceInformation(composerStartRestartGroup, "108@5355L39");
            if (mutableInteractionSource2 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 519755736, "CC(remember):FloatingActionButton.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource3 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource3 = mutableInteractionSource2;
            }
            composerStartRestartGroup.endReplaceGroup();
            MutableInteractionSource mutableInteractionSource8 = mutableInteractionSource2;
            Modifier modifier5 = companion;
            int i17 = i9 << 3;
            SurfaceKt.m2871Surfaceo_FOJdg(function0, SemanticsModifierKt.semantics$default(companion, false, new Function1<SemanticsPropertyReceiver, Unit>() {
                public Object invoke(Object obj) {
                    invoke((SemanticsPropertyReceiver) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6611getButtono7Vup1c());
                }
            }, 1, null), false, shape2, containerColor, j3, floatingActionButtonElevation2.getDefaultElevation(), floatingActionButtonElevation2.shadowElevation$material3_release(mutableInteractionSource3, composerStartRestartGroup, (i9 >> 12) & 112).getValue().unbox-impl(), null, mutableInteractionSource3, ComposableLambdaKt.rememberComposableLambda(1249316354, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i18) {
                    ComposerKt.sourceInformation(composer2, "C121@5936L5,122@5952L370,119@5802L520:FloatingActionButton.kt#uh7d8r");
                    if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1249316354, i18, -1, "androidx.compose.material3.FloatingActionButton.<anonymous> (FloatingActionButton.kt:119)");
                        }
                        long j6 = j3;
                        TextStyle value = TypographyKt.getValue(ExtendedFabPrimaryTokens.INSTANCE.getLabelTextFont(), composer2, 6);
                        final Function2<? super Composer, ? super Integer, Unit> function3 = function2;
                        ProvideContentColorTextStyleKt.m3262ProvideContentColorTextStyle3JVO9M(j6, value, ComposableLambdaKt.rememberComposableLambda(-1771489750, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i19) {
                                ComposerKt.sourceInformation(composer3, "C123@5966L346:FloatingActionButton.kt#uh7d8r");
                                if ((i19 & 3) != 2 || !composer3.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-1771489750, i19, -1, "androidx.compose.material3.FloatingActionButton.<anonymous>.<anonymous> (FloatingActionButton.kt:123)");
                                    }
                                    Modifier modifierM1064defaultMinSizeVpY3zN4 = SizeKt.m1064defaultMinSizeVpY3zN4(Modifier.INSTANCE, FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM(), FabPrimaryTokens.INSTANCE.m3576getContainerHeightD9Ej5fM());
                                    Alignment center = Alignment.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
                                    MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(center, false);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer3, modifierM1064defaultMinSizeVpY3zN4);
                                    Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
                                    BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1494899604, "C131@6289L9:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                        return;
                                    }
                                    return;
                                }
                                composer3.skipToGroupEnd();
                            }
                        }, composer2, 54), composer2, 384);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                            return;
                        }
                        return;
                    }
                    composer2.skipToGroupEnd();
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i9 & 14) | (i17 & 7168) | (57344 & i17) | (i17 & 458752), 6, 260);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource4 = mutableInteractionSource8;
            shape4 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = modifier5;
            floatingActionButtonElevation3 = floatingActionButtonElevation2;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final MutableInteractionSource mutableInteractionSource9 = mutableInteractionSource4;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i18) {
                    FloatingActionButtonKt.m2408FloatingActionButtonXz6DiA(function0, modifier2, shape4, j4, j5, floatingActionButtonElevation3, mutableInteractionSource9, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2410SmallFloatingActionButtonXz6DiA(final Function0<Unit> function0, Modifier modifier, Shape shape, long j, long j2, FloatingActionButtonElevation floatingActionButtonElevation, MutableInteractionSource mutableInteractionSource, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Shape shape2;
        long containerColor;
        long j3;
        FloatingActionButtonElevation floatingActionButtonElevationM2400elevationxZ9QkE;
        int i4;
        MutableInteractionSource mutableInteractionSource2;
        int i5;
        int i6;
        Modifier.Companion companion;
        Shape smallShape;
        int i7;
        long jM2173contentColorForek8zF_U;
        int i8;
        MutableInteractionSource mutableInteractionSource3;
        final Shape shape3;
        final long j4;
        final long j5;
        final Modifier modifier2;
        final FloatingActionButtonElevation floatingActionButtonElevation2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        int i10;
        int i11;
        Composer composerStartRestartGroup = composer.startRestartGroup(1444748300);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SmallFloatingActionButton)P(6,5,7,0:c#ui.graphics.Color,2:c#ui.graphics.Color,3,4)170@8224L10,171@8293L14,172@8335L31,173@8444L11,177@8559L455:FloatingActionButton.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i12 = i2 & 2;
        if (i12 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i11 = Fields.RotationX;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i11 = Fields.SpotShadowColor;
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    containerColor = j;
                    if (composerStartRestartGroup.changed(containerColor)) {
                        i10 = Fields.CameraDistance;
                    }
                    i3 |= i10;
                } else {
                    containerColor = j;
                }
                i10 = Fields.RotationZ;
                i3 |= i10;
            } else {
                containerColor = j;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    j3 = j2;
                    if (composerStartRestartGroup.changed(j3)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    j3 = j2;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                j3 = j2;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                    int i13 = composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE) ? Fields.RenderEffect : 65536;
                    i3 |= i13;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i4 = i2 & 64;
            if (i4 != 0) {
                if ((1572864 & i) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i5 = 1048576;
                    } else {
                        i5 = 524288;
                    }
                    i3 |= i5;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i6 = 8388608;
                        } else {
                            i6 = 4194304;
                        }
                        i3 |= i6;
                    }
                    if ((i3 & 4793491) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                i3 &= -897;
                                smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                            } else {
                                smallShape = shape2;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i7 = i3 & (-57345);
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                            } else {
                                i7 = i3;
                                jM2173contentColorForek8zF_U = j3;
                            }
                            if ((i2 & 32) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i8 = i7 & (-458753);
                            } else {
                                i8 = i7;
                            }
                            if (i4 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource2;
                            }
                            shape2 = smallShape;
                            j3 = jM2173contentColorForek8zF_U;
                            containerColor = containerColor;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 4) != 0) {
                                i3 &= -897;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            if ((i2 & 32) != 0) {
                                i3 &= -458753;
                            }
                            companion = modifier;
                            i8 = i3;
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevationM2400elevationxZ9QkE;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                        }
                        m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        mutableInteractionSource2 = mutableInteractionSource3;
                        shape3 = shape2;
                        j4 = containerColor;
                        j5 = j3;
                        modifier2 = companion;
                        floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = modifier;
                        shape3 = shape2;
                        j4 = containerColor;
                        j5 = j3;
                        floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final MutableInteractionSource mutableInteractionSource4 = mutableInteractionSource2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 12582912;
                if ((i3 & 4793491) == 4793490) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final MutableInteractionSource mutableInteractionSource5 = mutableInteractionSource2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource5, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((i2 & Fields.SpotShadowColor) != 0) {
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i6 = 8388608;
                    } else {
                        i6 = 4194304;
                    }
                    i3 |= i6;
                }
                if ((i3 & 4793491) == 4793490) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final MutableInteractionSource mutableInteractionSource6 = mutableInteractionSource2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource6, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 12582912;
            if ((i3 & 4793491) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource7 = mutableInteractionSource2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource7, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i11 = Fields.RotationX;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i11 = Fields.SpotShadowColor;
            i3 |= i11;
        } else {
            shape2 = shape;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                containerColor = j;
                if (composerStartRestartGroup.changed(containerColor)) {
                    i10 = Fields.CameraDistance;
                }
                i3 |= i10;
            } else {
                containerColor = j;
            }
            i10 = Fields.RotationZ;
            i3 |= i10;
        } else {
            containerColor = j;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                j3 = j2;
                if (composerStartRestartGroup.changed(j3)) {
                    i9 = Fields.Clip;
                }
                i3 |= i9;
            } else {
                j3 = j2;
            }
            i9 = Fields.Shape;
            i3 |= i9;
        } else {
            j3 = j2;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                if (composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE)) {
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i3 |= i13;
        } else {
            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
        }
        i4 = i2 & 64;
        if (i4 != 0) {
            if ((1572864 & i) == 0) {
                mutableInteractionSource2 = mutableInteractionSource;
                if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                    i5 = 1048576;
                } else {
                    i5 = 524288;
                }
                i3 |= i5;
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i6 = 8388608;
                    } else {
                        i6 = 4194304;
                    }
                    i3 |= i6;
                }
                if ((i3 & 4793491) == 4793490) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                        } else {
                            smallShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = smallShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final MutableInteractionSource mutableInteractionSource8 = mutableInteractionSource2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource8, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 12582912;
            if ((i3 & 4793491) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource9 = mutableInteractionSource2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource9, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 1572864;
        mutableInteractionSource2 = mutableInteractionSource;
        if ((i2 & Fields.SpotShadowColor) != 0) {
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i6 = 8388608;
                } else {
                    i6 = 4194304;
                }
                i3 |= i6;
            }
            if ((i3 & 4793491) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                    } else {
                        smallShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = smallShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource10 = mutableInteractionSource2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource10, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 12582912;
        if ((i3 & 4793491) == 4793490) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                } else {
                    smallShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = smallShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                } else {
                    smallShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = smallShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
            }
            m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource2 = mutableInteractionSource3;
            shape3 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = companion;
            floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                } else {
                    smallShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = smallShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    smallShape = FloatingActionButtonDefaults.INSTANCE.getSmallShape(composerStartRestartGroup, 6);
                } else {
                    smallShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = smallShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1444748300, i8, -1, "androidx.compose.material3.SmallFloatingActionButton (FloatingActionButton.kt:176)");
            }
            m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimarySmallTokens.INSTANCE.m3566getContainerWidthD9Ej5fM(), FabPrimarySmallTokens.INSTANCE.m3565getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource2 = mutableInteractionSource3;
            shape3 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = companion;
            floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final MutableInteractionSource mutableInteractionSource11 = mutableInteractionSource2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    FloatingActionButtonKt.m2410SmallFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource11, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2409LargeFloatingActionButtonXz6DiA(final Function0<Unit> function0, Modifier modifier, Shape shape, long j, long j2, FloatingActionButtonElevation floatingActionButtonElevation, MutableInteractionSource mutableInteractionSource, final Function2<? super Composer, ? super Integer, Unit> function2, Composer composer, final int i, final int i2) {
        int i3;
        Shape shape2;
        long containerColor;
        long j3;
        FloatingActionButtonElevation floatingActionButtonElevationM2400elevationxZ9QkE;
        int i4;
        MutableInteractionSource mutableInteractionSource2;
        int i5;
        int i6;
        Modifier.Companion companion;
        Shape largeShape;
        int i7;
        long jM2173contentColorForek8zF_U;
        int i8;
        MutableInteractionSource mutableInteractionSource3;
        final Shape shape3;
        final long j4;
        final long j5;
        final Modifier modifier2;
        final FloatingActionButtonElevation floatingActionButtonElevation2;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i9;
        int i10;
        int i11;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1650866856);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LargeFloatingActionButton)P(6,5,7,0:c#ui.graphics.Color,2:c#ui.graphics.Color,3,4)226@10910L10,227@10979L14,228@11021L31,229@11130L11,233@11245L455:FloatingActionButton.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i12 = i2 & 2;
        if (i12 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i11 = Fields.RotationX;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i11 = Fields.SpotShadowColor;
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    containerColor = j;
                    if (composerStartRestartGroup.changed(containerColor)) {
                        i10 = Fields.CameraDistance;
                    }
                    i3 |= i10;
                } else {
                    containerColor = j;
                }
                i10 = Fields.RotationZ;
                i3 |= i10;
            } else {
                containerColor = j;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    j3 = j2;
                    if (composerStartRestartGroup.changed(j3)) {
                        i9 = Fields.Clip;
                    }
                    i3 |= i9;
                } else {
                    j3 = j2;
                }
                i9 = Fields.Shape;
                i3 |= i9;
            } else {
                j3 = j2;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                    int i13 = composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE) ? Fields.RenderEffect : 65536;
                    i3 |= i13;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i4 = i2 & 64;
            if (i4 != 0) {
                if ((1572864 & i) == 0) {
                    mutableInteractionSource2 = mutableInteractionSource;
                    if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                        i5 = 1048576;
                    } else {
                        i5 = 524288;
                    }
                    i3 |= i5;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function2)) {
                            i6 = 8388608;
                        } else {
                            i6 = 4194304;
                        }
                        i3 |= i6;
                    }
                    if ((i3 & 4793491) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                            if (i12 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                i3 &= -897;
                                largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                            } else {
                                largeShape = shape2;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            }
                            if ((i2 & 16) != 0) {
                                i7 = i3 & (-57345);
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                            } else {
                                i7 = i3;
                                jM2173contentColorForek8zF_U = j3;
                            }
                            if ((i2 & 32) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i8 = i7 & (-458753);
                            } else {
                                i8 = i7;
                            }
                            if (i4 != 0) {
                                mutableInteractionSource3 = null;
                            } else {
                                mutableInteractionSource3 = mutableInteractionSource2;
                            }
                            shape2 = largeShape;
                            j3 = jM2173contentColorForek8zF_U;
                            containerColor = containerColor;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            if ((i2 & 4) != 0) {
                                i3 &= -897;
                            }
                            if ((i2 & 8) != 0) {
                                i3 &= -7169;
                            }
                            if ((i2 & 16) != 0) {
                                i3 &= -57345;
                            }
                            if ((i2 & 32) != 0) {
                                i3 &= -458753;
                            }
                            companion = modifier;
                            i8 = i3;
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevationM2400elevationxZ9QkE;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                        }
                        m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        mutableInteractionSource2 = mutableInteractionSource3;
                        shape3 = shape2;
                        j4 = containerColor;
                        j5 = j3;
                        modifier2 = companion;
                        floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        modifier2 = modifier;
                        shape3 = shape2;
                        j4 = containerColor;
                        j5 = j3;
                        floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final MutableInteractionSource mutableInteractionSource4 = mutableInteractionSource2;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i14) {
                                FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource4, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 12582912;
                if ((i3 & 4793491) == 4793490) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final MutableInteractionSource mutableInteractionSource5 = mutableInteractionSource2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource5, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 1572864;
            mutableInteractionSource2 = mutableInteractionSource;
            if ((i2 & Fields.SpotShadowColor) != 0) {
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i6 = 8388608;
                    } else {
                        i6 = 4194304;
                    }
                    i3 |= i6;
                }
                if ((i3 & 4793491) == 4793490) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final MutableInteractionSource mutableInteractionSource6 = mutableInteractionSource2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource6, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 12582912;
            if ((i3 & 4793491) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource7 = mutableInteractionSource2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource7, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i11 = Fields.RotationX;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i11 = Fields.SpotShadowColor;
            i3 |= i11;
        } else {
            shape2 = shape;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                containerColor = j;
                if (composerStartRestartGroup.changed(containerColor)) {
                    i10 = Fields.CameraDistance;
                }
                i3 |= i10;
            } else {
                containerColor = j;
            }
            i10 = Fields.RotationZ;
            i3 |= i10;
        } else {
            containerColor = j;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                j3 = j2;
                if (composerStartRestartGroup.changed(j3)) {
                    i9 = Fields.Clip;
                }
                i3 |= i9;
            } else {
                j3 = j2;
            }
            i9 = Fields.Shape;
            i3 |= i9;
        } else {
            j3 = j2;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                if (composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE)) {
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i3 |= i13;
        } else {
            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
        }
        i4 = i2 & 64;
        if (i4 != 0) {
            if ((1572864 & i) == 0) {
                mutableInteractionSource2 = mutableInteractionSource;
                if (composerStartRestartGroup.changed(mutableInteractionSource2)) {
                    i5 = 1048576;
                } else {
                    i5 = 524288;
                }
                i3 |= i5;
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i6 = 8388608;
                    } else {
                        i6 = 4194304;
                    }
                    i3 |= i6;
                }
                if ((i3 & 4793491) == 4793490) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    } else {
                        if (i12 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            i3 &= -897;
                            largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                        } else {
                            largeShape = shape2;
                        }
                        if ((i2 & 8) != 0) {
                            i3 &= -7169;
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        }
                        if ((i2 & 16) != 0) {
                            i7 = i3 & (-57345);
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                        } else {
                            i7 = i3;
                            jM2173contentColorForek8zF_U = j3;
                        }
                        if ((i2 & 32) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i8 = i7 & (-458753);
                        } else {
                            i8 = i7;
                        }
                        if (i4 != 0) {
                            mutableInteractionSource3 = null;
                        } else {
                            mutableInteractionSource3 = mutableInteractionSource2;
                        }
                        shape2 = largeShape;
                        j3 = jM2173contentColorForek8zF_U;
                        containerColor = containerColor;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                    }
                    m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    mutableInteractionSource2 = mutableInteractionSource3;
                    shape3 = shape2;
                    j4 = containerColor;
                    j5 = j3;
                    modifier2 = companion;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final MutableInteractionSource mutableInteractionSource8 = mutableInteractionSource2;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i14) {
                            FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource8, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 12582912;
            if ((i3 & 4793491) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource9 = mutableInteractionSource2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource9, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 1572864;
        mutableInteractionSource2 = mutableInteractionSource;
        if ((i2 & Fields.SpotShadowColor) != 0) {
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i6 = 8388608;
                } else {
                    i6 = 4194304;
                }
                i3 |= i6;
            }
            if ((i3 & 4793491) == 4793490) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    if (i12 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                    } else {
                        largeShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource3 = null;
                    } else {
                        mutableInteractionSource3 = mutableInteractionSource2;
                    }
                    shape2 = largeShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
                }
                m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource2 = mutableInteractionSource3;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource10 = mutableInteractionSource2;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i14) {
                        FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource10, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 12582912;
        if ((i3 & 4793491) == 4793490) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                } else {
                    largeShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = largeShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                } else {
                    largeShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = largeShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
            }
            m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource2 = mutableInteractionSource3;
            shape3 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = companion;
            floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                } else {
                    largeShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = largeShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            } else {
                if (i12 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    largeShape = FloatingActionButtonDefaults.INSTANCE.getLargeShape(composerStartRestartGroup, 6);
                } else {
                    largeShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource3 = null;
                } else {
                    mutableInteractionSource3 = mutableInteractionSource2;
                }
                shape2 = largeShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1650866856, i8, -1, "androidx.compose.material3.LargeFloatingActionButton (FloatingActionButton.kt:232)");
            }
            m2408FloatingActionButtonXz6DiA(function0, SizeKt.m1084sizeInqDBjuR0$default(companion, FabPrimaryLargeTokens.INSTANCE.m3555getContainerWidthD9Ej5fM(), FabPrimaryLargeTokens.INSTANCE.m3554getContainerHeightD9Ej5fM(), 0.0f, 0.0f, 12, null), shape2, containerColor, j3, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource3, function2, composerStartRestartGroup, i8 & 33554318, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource2 = mutableInteractionSource3;
            shape3 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = companion;
            floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final MutableInteractionSource mutableInteractionSource11 = mutableInteractionSource2;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i14) {
                    FloatingActionButtonKt.m2409LargeFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation2, mutableInteractionSource11, function2, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2407ExtendedFloatingActionButtonXz6DiA(final Function0<Unit> function0, Modifier modifier, Shape shape, long j, long j2, FloatingActionButtonElevation floatingActionButtonElevation, MutableInteractionSource mutableInteractionSource, final Function3<? super RowScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Shape shape2;
        long containerColor;
        long j3;
        FloatingActionButtonElevation floatingActionButtonElevationM2400elevationxZ9QkE;
        int i4;
        int i5;
        int i6;
        Modifier.Companion companion;
        Shape extendedFabShape;
        int i7;
        long jM2173contentColorForek8zF_U;
        int i8;
        MutableInteractionSource mutableInteractionSource2;
        int i9;
        FloatingActionButtonElevation floatingActionButtonElevation2;
        MutableInteractionSource mutableInteractionSource3;
        final Shape shape3;
        final long j4;
        final long j5;
        final Modifier modifier2;
        final FloatingActionButtonElevation floatingActionButtonElevation3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i10;
        int i11;
        int i12;
        Composer composerStartRestartGroup = composer.startRestartGroup(-326283107);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ExtendedFloatingActionButton)P(6,5,7,0:c#ui.graphics.Color,2:c#ui.graphics.Color,3,4)285@13734L16,286@13809L14,287@13851L31,288@13960L11,300@14347L335,292@14084L598:FloatingActionButton.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function0) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 2;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) == 0) {
                if ((i2 & 4) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                        i12 = Fields.RotationX;
                    }
                    i3 |= i12;
                } else {
                    shape2 = shape;
                }
                i12 = Fields.SpotShadowColor;
                i3 |= i12;
            } else {
                shape2 = shape;
            }
            if ((i & 3072) == 0) {
                if ((i2 & 8) == 0) {
                    containerColor = j;
                    if (composerStartRestartGroup.changed(containerColor)) {
                        i11 = Fields.CameraDistance;
                    }
                    i3 |= i11;
                } else {
                    containerColor = j;
                }
                i11 = Fields.RotationZ;
                i3 |= i11;
            } else {
                containerColor = j;
            }
            if ((i & 24576) == 0) {
                if ((i2 & 16) == 0) {
                    j3 = j2;
                    if (composerStartRestartGroup.changed(j3)) {
                        i10 = Fields.Clip;
                    }
                    i3 |= i10;
                } else {
                    j3 = j2;
                }
                i10 = Fields.Shape;
                i3 |= i10;
            } else {
                j3 = j2;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                    int i14 = composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE) ? Fields.RenderEffect : 65536;
                    i3 |= i14;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                }
                i3 |= i14;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i4 = i2 & 64;
            if (i4 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i5 = 1048576;
                } else {
                    i5 = 524288;
                }
                i3 |= i5;
            }
            if ((i2 & Fields.SpotShadowColor) != 0) {
                i3 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i6 = 8388608;
                } else {
                    i6 = 4194304;
                }
                i3 |= i6;
            }
            if ((4793491 & i3) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    }
                    if ((i2 & 16) != 0) {
                        i7 = i3 & (-57345);
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                    } else {
                        i7 = i3;
                        jM2173contentColorForek8zF_U = j3;
                    }
                    if ((i2 & 32) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i8 = i7 & (-458753);
                    } else {
                        i8 = i7;
                    }
                    if (i4 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    i9 = i8;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    shape2 = extendedFabShape;
                    j3 = jM2173contentColorForek8zF_U;
                    containerColor = containerColor;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    if ((i2 & 4) != 0) {
                        i3 &= -897;
                    }
                    if ((i2 & 8) != 0) {
                        i3 &= -7169;
                    }
                    if ((i2 & 16) != 0) {
                        i3 &= -57345;
                    }
                    if ((i2 & 32) != 0) {
                        i3 &= -458753;
                    }
                    companion = modifier;
                    mutableInteractionSource2 = mutableInteractionSource;
                    i9 = i3;
                    floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-326283107, i9, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:291)");
                }
                m2408FloatingActionButtonXz6DiA(function0, companion, shape2, containerColor, j3, floatingActionButtonElevation2, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(398457247, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        ComposerKt.sourceInformation(composer2, "C301@14357L319:FloatingActionButton.kt#uh7d8r");
                        if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(398457247, i15, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:301)");
                            }
                            Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1084sizeInqDBjuR0$default(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabMinimumWidth, 0.0f, 0.0f, 0.0f, 14, null), FloatingActionButtonKt.ExtendedFabTextPadding, 0.0f, 2, null);
                            Arrangement.HorizontalOrVertical center = Arrangement.INSTANCE.getCenter();
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(center, centerVertically, composer2, 54);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                            function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i9 & 14) | 12582912 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9) | (i9 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                modifier2 = companion;
                floatingActionButtonElevation3 = floatingActionButtonElevation2;
            } else {
                composerStartRestartGroup.skipToGroupEnd();
                modifier2 = modifier;
                mutableInteractionSource3 = mutableInteractionSource;
                shape3 = shape2;
                j4 = containerColor;
                j5 = j3;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final MutableInteractionSource mutableInteractionSource4 = mutableInteractionSource3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i15) {
                        FloatingActionButtonKt.m2407ExtendedFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation3, mutableInteractionSource4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) == 0) {
            if ((i2 & 4) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                    i12 = Fields.RotationX;
                }
                i3 |= i12;
            } else {
                shape2 = shape;
            }
            i12 = Fields.SpotShadowColor;
            i3 |= i12;
        } else {
            shape2 = shape;
        }
        if ((i & 3072) == 0) {
            if ((i2 & 8) == 0) {
                containerColor = j;
                if (composerStartRestartGroup.changed(containerColor)) {
                    i11 = Fields.CameraDistance;
                }
                i3 |= i11;
            } else {
                containerColor = j;
            }
            i11 = Fields.RotationZ;
            i3 |= i11;
        } else {
            containerColor = j;
        }
        if ((i & 24576) == 0) {
            if ((i2 & 16) == 0) {
                j3 = j2;
                if (composerStartRestartGroup.changed(j3)) {
                    i10 = Fields.Clip;
                }
                i3 |= i10;
            } else {
                j3 = j2;
            }
            i10 = Fields.Shape;
            i3 |= i10;
        } else {
            j3 = j2;
        }
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
                if (composerStartRestartGroup.changed(floatingActionButtonElevationM2400elevationxZ9QkE)) {
                }
                i3 |= i14;
            } else {
                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
            }
            i3 |= i14;
        } else {
            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation;
        }
        i4 = i2 & 64;
        if (i4 != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i5 = 1048576;
            } else {
                i5 = 524288;
            }
            i3 |= i5;
        }
        if ((i2 & Fields.SpotShadowColor) != 0) {
            i3 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i6 = 8388608;
            } else {
                i6 = 4194304;
            }
            i3 |= i6;
        }
        if ((4793491 & i3) == 4793490) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                i9 = i8;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                shape2 = extendedFabShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                i9 = i8;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                shape2 = extendedFabShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-326283107, i9, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:291)");
            }
            m2408FloatingActionButtonXz6DiA(function0, companion, shape2, containerColor, j3, floatingActionButtonElevation2, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(398457247, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i15) {
                    ComposerKt.sourceInformation(composer2, "C301@14357L319:FloatingActionButton.kt#uh7d8r");
                    if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(398457247, i15, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:301)");
                        }
                        Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1084sizeInqDBjuR0$default(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabMinimumWidth, 0.0f, 0.0f, 0.0f, 14, null), FloatingActionButtonKt.ExtendedFabTextPadding, 0.0f, 2, null);
                        Arrangement.HorizontalOrVertical center = Arrangement.INSTANCE.getCenter();
                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                        Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(center, centerVertically, composer2, 54);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                        function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i9 & 14) | 12582912 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9) | (i9 & 3670016), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource3 = mutableInteractionSource2;
            shape3 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = companion;
            floatingActionButtonElevation3 = floatingActionButtonElevation2;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                i9 = i8;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                shape2 = extendedFabShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    i3 &= -897;
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 8) != 0) {
                    i3 &= -7169;
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                }
                if ((i2 & 16) != 0) {
                    i7 = i3 & (-57345);
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 9) & 14);
                } else {
                    i7 = i3;
                    jM2173contentColorForek8zF_U = j3;
                }
                if ((i2 & 32) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i8 = i7 & (-458753);
                } else {
                    i8 = i7;
                }
                if (i4 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                i9 = i8;
                floatingActionButtonElevation2 = floatingActionButtonElevationM2400elevationxZ9QkE;
                shape2 = extendedFabShape;
                j3 = jM2173contentColorForek8zF_U;
                containerColor = containerColor;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-326283107, i9, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:291)");
            }
            m2408FloatingActionButtonXz6DiA(function0, companion, shape2, containerColor, j3, floatingActionButtonElevation2, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(398457247, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i15) {
                    ComposerKt.sourceInformation(composer2, "C301@14357L319:FloatingActionButton.kt#uh7d8r");
                    if ((i15 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(398457247, i15, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:301)");
                        }
                        Modifier modifierM1037paddingVpY3zN4$default = PaddingKt.m1037paddingVpY3zN4$default(SizeKt.m1084sizeInqDBjuR0$default(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabMinimumWidth, 0.0f, 0.0f, 0.0f, 14, null), FloatingActionButtonKt.ExtendedFabTextPadding, 0.0f, 2, null);
                        Arrangement.HorizontalOrVertical center = Arrangement.INSTANCE.getCenter();
                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                        Function3<RowScope, Composer, Integer, Unit> function4 = function3;
                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(center, centerVertically, composer2, 54);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1037paddingVpY3zN4$default);
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
                        function4.invoke(RowScopeInstance.INSTANCE, composer2, 6);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i9 & 14) | 12582912 | (i9 & 112) | (i9 & 896) | (i9 & 7168) | (57344 & i9) | (458752 & i9) | (i9 & 3670016), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            mutableInteractionSource3 = mutableInteractionSource2;
            shape3 = shape2;
            j4 = containerColor;
            j5 = j3;
            modifier2 = companion;
            floatingActionButtonElevation3 = floatingActionButtonElevation2;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final MutableInteractionSource mutableInteractionSource5 = mutableInteractionSource3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i15) {
                    FloatingActionButtonKt.m2407ExtendedFloatingActionButtonXz6DiA(function0, modifier2, shape3, j4, j5, floatingActionButtonElevation3, mutableInteractionSource5, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2406ExtendedFloatingActionButtonElI57k(final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, final Function0<Unit> function0, Modifier modifier, boolean z, Shape shape, long j, long j2, FloatingActionButtonElevation floatingActionButtonElevation, MutableInteractionSource mutableInteractionSource, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        Modifier modifier2;
        int i5;
        int i6;
        final boolean z2;
        int i7;
        Shape shape2;
        long j3;
        FloatingActionButtonElevation floatingActionButtonElevation2;
        int i8;
        int i9;
        Modifier.Companion companion;
        final Shape extendedFabShape;
        final long containerColor;
        long jM2173contentColorForek8zF_U;
        FloatingActionButtonElevation floatingActionButtonElevationM2400elevationxZ9QkE;
        MutableInteractionSource mutableInteractionSource2;
        final boolean z3;
        final Modifier modifier3;
        final long j4;
        final FloatingActionButtonElevation floatingActionButtonElevation3;
        final MutableInteractionSource mutableInteractionSource3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i10;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1387401842);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ExtendedFloatingActionButton)P(9,4,7,6,3,8,0:c#ui.graphics.Color,1:c#ui.graphics.Color)359@17300L16,360@17375L14,361@17417L31,362@17526L11,373@17867L1053,365@17604L1316:FloatingActionButton.kt#uh7d8r");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changedInstance(function2) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        if ((i2 & 2) != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? 32 : 16;
        }
        if ((i2 & 4) == 0) {
            if ((i & 384) == 0) {
                i3 |= composerStartRestartGroup.changedInstance(function0) ? Fields.RotationX : Fields.SpotShadowColor;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    modifier2 = modifier;
                    if (composerStartRestartGroup.changed(modifier2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 16;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        z2 = z;
                        if (composerStartRestartGroup.changed(z2)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    if ((196608 & i) == 0) {
                        if ((i2 & 32) == 0) {
                            shape2 = shape;
                            int i11 = composerStartRestartGroup.changed(shape2) ? Fields.RenderEffect : 65536;
                            i3 |= i11;
                        } else {
                            shape2 = shape;
                        }
                        i3 |= i11;
                    } else {
                        shape2 = shape;
                    }
                    if ((1572864 & i) == 0) {
                        if ((i2 & 64) == 0) {
                            j3 = j;
                            int i12 = composerStartRestartGroup.changed(j3) ? 1048576 : 524288;
                            i3 |= i12;
                        } else {
                            j3 = j;
                        }
                        i3 |= i12;
                    } else {
                        j3 = j;
                    }
                    if ((i & 12582912) != 0) {
                        if ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(j2)) {
                            i10 = 4194304;
                        } else {
                            i10 = 8388608;
                        }
                        i3 |= i10;
                    }
                    if ((i & 100663296) == 0) {
                        if ((i2 & Fields.RotationX) == 0) {
                            floatingActionButtonElevation2 = floatingActionButtonElevation;
                            int i13 = composerStartRestartGroup.changed(floatingActionButtonElevation2) ? 67108864 : 33554432;
                            i3 |= i13;
                        } else {
                            floatingActionButtonElevation2 = floatingActionButtonElevation;
                        }
                        i3 |= i13;
                    } else {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                    }
                    i8 = i2 & Fields.RotationY;
                    if (i8 != 0) {
                        if ((805306368 & i) == 0) {
                            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                                i9 = 536870912;
                            } else {
                                i9 = 268435456;
                            }
                            i3 |= i9;
                        }
                        if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                if (i4 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i6 != 0) {
                                    z2 = true;
                                }
                                if ((i2 & 32) != 0) {
                                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                    i3 &= -458753;
                                } else {
                                    extendedFabShape = shape2;
                                }
                                if ((i2 & 64) != 0) {
                                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                    i3 &= -3670017;
                                } else {
                                    containerColor = j3;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                    i3 &= -29360129;
                                } else {
                                    jM2173contentColorForek8zF_U = j2;
                                }
                                if ((i2 & Fields.RotationX) != 0) {
                                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                    i3 &= -234881025;
                                } else {
                                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                                }
                                if (i8 != 0) {
                                    mutableInteractionSource2 = null;
                                } else {
                                    mutableInteractionSource2 = mutableInteractionSource;
                                }
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 32) != 0) {
                                    i3 &= -458753;
                                }
                                if ((i2 & 64) != 0) {
                                    i3 &= -3670017;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    i3 &= -29360129;
                                }
                                if ((i2 & Fields.RotationX) != 0) {
                                    i3 &= -234881025;
                                }
                                mutableInteractionSource2 = mutableInteractionSource;
                                companion = modifier2;
                                extendedFabShape = shape2;
                                containerColor = j3;
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                                jM2173contentColorForek8zF_U = j2;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                            }
                            boolean z4 = z2;
                            int i14 = i3 >> 6;
                            int i15 = i3 >> 9;
                            m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i16) {
                                    float f;
                                    float f2;
                                    float fM3577getContainerWidthD9Ej5fM;
                                    ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                    if ((i16 & 3) != 2 || !composer2.getSkipping()) {
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(1172118032, i16, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                        }
                                        if (z2) {
                                            f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                        } else {
                                            f = Dp.constructor-impl(0);
                                        }
                                        float f3 = f;
                                        if (z2) {
                                            f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                        } else {
                                            f2 = Dp.constructor-impl(0);
                                        }
                                        float f4 = f2;
                                        Modifier.Companion companion2 = Modifier.INSTANCE;
                                        if (z2) {
                                            fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                        } else {
                                            fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                        }
                                        Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                        Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                        Function2<Composer, Integer, Unit> function4 = function3;
                                        boolean z5 = z2;
                                        final Function2<Composer, Integer, Unit> function5 = function2;
                                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                        ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                        function4.invoke(composer2, 0);
                                        AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z5, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                            {
                                                super(3);
                                            }

                                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                                invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                                return Unit.INSTANCE;
                                            }

                                            public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i17) {
                                                ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventStart(176242764, i17, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                                }
                                                Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                    }

                                                    public Object invoke(Object obj) {
                                                        invoke((SemanticsPropertyReceiver) obj);
                                                        return Unit.INSTANCE;
                                                    }
                                                });
                                                Function2<Composer, Integer, Unit> function6 = function5;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                                MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                                if (!(composer3.getApplier() instanceof Applier)) {
                                                    ComposablesKt.invalidApplier();
                                                }
                                                composer3.startReusableNode();
                                                if (composer3.getInserting()) {
                                                    composer3.createNode(constructor2);
                                                } else {
                                                    composer3.useNode();
                                                }
                                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                                }
                                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                                ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                                RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                                ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                                SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                                function6.invoke(composer3, 0);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                composer3.endNode();
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                                if (ComposerKt.isTraceInProgress()) {
                                                    ComposerKt.traceEventEnd();
                                                }
                                            }
                                        }, composer2, 54), composer2, 1600518, 18);
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
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i14 & 112) | (i14 & 14) | 12582912 | (i15 & 896) | (i15 & 7168) | (57344 & i15) | (458752 & i15) | (i15 & 3670016), 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            z3 = z4;
                            modifier3 = companion;
                            j4 = jM2173contentColorForek8zF_U;
                            floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                            mutableInteractionSource3 = mutableInteractionSource2;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier3 = modifier2;
                            z3 = z2;
                            extendedFabShape = shape2;
                            containerColor = j3;
                            floatingActionButtonElevation3 = floatingActionButtonElevation2;
                            j4 = j2;
                            mutableInteractionSource3 = mutableInteractionSource;
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
                                    FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z5 = z2;
                        int i16 = i3 >> 6;
                        int i17 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i18) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i18 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i18, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z6 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z6, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i19) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i19, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i16 & 112) | (i16 & 14) | 12582912 | (i17 & 896) | (i17 & 7168) | (57344 & i17) | (458752 & i17) | (i17 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z5;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z6 = z2;
                        int i18 = i3 >> 6;
                        int i19 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i110) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i110 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i110, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z7 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z7, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i111) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i111, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i18 & 112) | (i18 & 14) | 12582912 | (i19 & 896) | (i19 & 7168) | (57344 & i19) | (458752 & i19) | (i19 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z6;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
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

                            public final void invoke(Composer composer2, int i110) {
                                FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                z2 = z;
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        shape2 = shape;
                        if (composerStartRestartGroup.changed(shape2)) {
                        }
                        i3 |= i11;
                    } else {
                        shape2 = shape;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        j3 = j;
                        if (composerStartRestartGroup.changed(j3)) {
                        }
                        i3 |= i12;
                    } else {
                        j3 = j;
                    }
                    i3 |= i12;
                } else {
                    j3 = j;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0) {
                        i10 = 4194304;
                    } else {
                        i10 = 4194304;
                    }
                    i3 |= i10;
                }
                if ((i & 100663296) == 0) {
                    if ((i2 & Fields.RotationX) == 0) {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                        if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                        }
                        i3 |= i13;
                    } else {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                    }
                    i3 |= i13;
                } else {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                }
                i8 = i2 & Fields.RotationY;
                if (i8 != 0) {
                    if ((805306368 & i) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i9 = 536870912;
                        } else {
                            i9 = 268435456;
                        }
                        i3 |= i9;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z7 = z2;
                        int i110 = i3 >> 6;
                        int i111 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i112) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i112 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i112, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z8 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z8, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i113) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i113, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i110 & 112) | (i110 & 14) | 12582912 | (i111 & 896) | (i111 & 7168) | (57344 & i111) | (458752 & i111) | (i111 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z7;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z8 = z2;
                        int i112 = i3 >> 6;
                        int i113 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i114) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i114 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i114, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z9 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z9, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i115) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i115, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i112 & 112) | (i112 & 14) | 12582912 | (i113 & 896) | (i113 & 7168) | (57344 & i113) | (458752 & i113) | (i113 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z8;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
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

                            public final void invoke(Composer composer2, int i114) {
                                FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z9 = z2;
                    int i114 = i3 >> 6;
                    int i115 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i116, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z10 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z10, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i117) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i117, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i114 & 112) | (i114 & 14) | 12582912 | (i115 & 896) | (i115 & 7168) | (57344 & i115) | (458752 & i115) | (i115 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z9;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z10 = z2;
                    int i116 = i3 >> 6;
                    int i117 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i118) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i118 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i118, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z11 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z11, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i119) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i119, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i116 & 112) | (i116 & 14) | 12582912 | (i117 & 896) | (i117 & 7168) | (57344 & i117) | (458752 & i117) | (i117 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z10;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i118) {
                            FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            modifier2 = modifier;
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        shape2 = shape;
                        if (composerStartRestartGroup.changed(shape2)) {
                        }
                        i3 |= i11;
                    } else {
                        shape2 = shape;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        j3 = j;
                        if (composerStartRestartGroup.changed(j3)) {
                        }
                        i3 |= i12;
                    } else {
                        j3 = j;
                    }
                    i3 |= i12;
                } else {
                    j3 = j;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0) {
                        i10 = 4194304;
                    } else {
                        i10 = 4194304;
                    }
                    i3 |= i10;
                }
                if ((i & 100663296) == 0) {
                    if ((i2 & Fields.RotationX) == 0) {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                        if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                        }
                        i3 |= i13;
                    } else {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                    }
                    i3 |= i13;
                } else {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                }
                i8 = i2 & Fields.RotationY;
                if (i8 != 0) {
                    if ((805306368 & i) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i9 = 536870912;
                        } else {
                            i9 = 268435456;
                        }
                        i3 |= i9;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z11 = z2;
                        int i118 = i3 >> 6;
                        int i119 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1110) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i1110 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i1110, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z12 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z12, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1111) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i1111, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i118 & 112) | (i118 & 14) | 12582912 | (i119 & 896) | (i119 & 7168) | (57344 & i119) | (458752 & i119) | (i119 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z11;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z12 = z2;
                        int i1110 = i3 >> 6;
                        int i1111 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1112) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i1112 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i1112, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z13 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z13, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1113) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i1113, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1110 & 112) | (i1110 & 14) | 12582912 | (i1111 & 896) | (i1111 & 7168) | (57344 & i1111) | (458752 & i1111) | (i1111 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z12;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
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

                            public final void invoke(Composer composer2, int i1112) {
                                FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z13 = z2;
                    int i1112 = i3 >> 6;
                    int i1113 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1114) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i1114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i1114, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z14 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z14, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1115) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i1115, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1112 & 112) | (i1112 & 14) | 12582912 | (i1113 & 896) | (i1113 & 7168) | (57344 & i1113) | (458752 & i1113) | (i1113 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z13;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z14 = z2;
                    int i1114 = i3 >> 6;
                    int i1115 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1116) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i1116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i1116, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z15 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z15, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1117) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i1117, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1114 & 112) | (i1114 & 14) | 12582912 | (i1115 & 896) | (i1115 & 7168) | (57344 & i1115) | (458752 & i1115) | (i1115 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z14;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i1116) {
                            FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z2 = z;
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    j3 = j;
                    if (composerStartRestartGroup.changed(j3)) {
                    }
                    i3 |= i12;
                } else {
                    j3 = j;
                }
                i3 |= i12;
            } else {
                j3 = j;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i10 = 4194304;
                } else {
                    i10 = 4194304;
                }
                i3 |= i10;
            }
            if ((i & 100663296) == 0) {
                if ((i2 & Fields.RotationX) == 0) {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                    if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                    }
                    i3 |= i13;
                } else {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevation2 = floatingActionButtonElevation;
            }
            i8 = i2 & Fields.RotationY;
            if (i8 != 0) {
                if ((805306368 & i) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i9 = 536870912;
                    } else {
                        i9 = 268435456;
                    }
                    i3 |= i9;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z15 = z2;
                    int i1116 = i3 >> 6;
                    int i1117 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1118) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i1118 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i1118, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z16 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z16, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1119) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i1119, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1116 & 112) | (i1116 & 14) | 12582912 | (i1117 & 896) | (i1117 & 7168) | (57344 & i1117) | (458752 & i1117) | (i1117 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z15;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z16 = z2;
                    int i1118 = i3 >> 6;
                    int i1119 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11110) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i11110 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i11110, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z17 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z17, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11111) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i11111, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1118 & 112) | (i1118 & 14) | 12582912 | (i1119 & 896) | (i1119 & 7168) | (57344 & i1119) | (458752 & i1119) | (i1119 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z16;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i11110) {
                            FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z17 = z2;
                int i11110 = i3 >> 6;
                int i11111 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11112) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i11112 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i11112, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z18 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z18, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11113) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i11113, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11110 & 112) | (i11110 & 14) | 12582912 | (i11111 & 896) | (i11111 & 7168) | (57344 & i11111) | (458752 & i11111) | (i11111 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z17;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z18 = z2;
                int i11112 = i3 >> 6;
                int i11113 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11114) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i11114 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i11114, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z19 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z19, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11115) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i11115, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11112 & 112) | (i11112 & 14) | 12582912 | (i11113 & 896) | (i11113 & 7168) | (57344 & i11113) | (458752 & i11113) | (i11113 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z18;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i11114) {
                        FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 384;
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                modifier2 = modifier;
                if (composerStartRestartGroup.changed(modifier2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    z2 = z;
                    if (composerStartRestartGroup.changed(z2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                if ((196608 & i) == 0) {
                    if ((i2 & 32) == 0) {
                        shape2 = shape;
                        if (composerStartRestartGroup.changed(shape2)) {
                        }
                        i3 |= i11;
                    } else {
                        shape2 = shape;
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                if ((1572864 & i) == 0) {
                    if ((i2 & 64) == 0) {
                        j3 = j;
                        if (composerStartRestartGroup.changed(j3)) {
                        }
                        i3 |= i12;
                    } else {
                        j3 = j;
                    }
                    i3 |= i12;
                } else {
                    j3 = j;
                }
                if ((i & 12582912) != 0) {
                    if ((i2 & Fields.SpotShadowColor) == 0) {
                        i10 = 4194304;
                    } else {
                        i10 = 4194304;
                    }
                    i3 |= i10;
                }
                if ((i & 100663296) == 0) {
                    if ((i2 & Fields.RotationX) == 0) {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                        if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                        }
                        i3 |= i13;
                    } else {
                        floatingActionButtonElevation2 = floatingActionButtonElevation;
                    }
                    i3 |= i13;
                } else {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                }
                i8 = i2 & Fields.RotationY;
                if (i8 != 0) {
                    if ((805306368 & i) == 0) {
                        if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                            i9 = 536870912;
                        } else {
                            i9 = 268435456;
                        }
                        i3 |= i9;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z19 = z2;
                        int i11114 = i3 >> 6;
                        int i11115 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11116) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i11116 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i11116, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z110 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z110, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11117) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i11117, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11114 & 112) | (i11114 & 14) | 12582912 | (i11115 & 896) | (i11115 & 7168) | (57344 & i11115) | (458752 & i11115) | (i11115 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z19;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        } else {
                            if (i4 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i6 != 0) {
                                z2 = true;
                            }
                            if ((i2 & 32) != 0) {
                                extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                                i3 &= -458753;
                            } else {
                                extendedFabShape = shape2;
                            }
                            if ((i2 & 64) != 0) {
                                containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                                i3 &= -3670017;
                            } else {
                                containerColor = j3;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                                i3 &= -29360129;
                            } else {
                                jM2173contentColorForek8zF_U = j2;
                            }
                            if ((i2 & Fields.RotationX) != 0) {
                                floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                                i3 &= -234881025;
                            } else {
                                floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                            }
                            if (i8 != 0) {
                                mutableInteractionSource2 = null;
                            } else {
                                mutableInteractionSource2 = mutableInteractionSource;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                        }
                        boolean z110 = z2;
                        int i11116 = i3 >> 6;
                        int i11117 = i3 >> 9;
                        m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11118) {
                                float f;
                                float f2;
                                float fM3577getContainerWidthD9Ej5fM;
                                ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                                if ((i11118 & 3) != 2 || !composer2.getSkipping()) {
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1172118032, i11118, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                    }
                                    if (z2) {
                                        f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                    } else {
                                        f = Dp.constructor-impl(0);
                                    }
                                    float f3 = f;
                                    if (z2) {
                                        f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                    } else {
                                        f2 = Dp.constructor-impl(0);
                                    }
                                    float f4 = f2;
                                    Modifier.Companion companion2 = Modifier.INSTANCE;
                                    if (z2) {
                                        fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                    } else {
                                        fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                    }
                                    Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                    Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                    Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                    Function2<Composer, Integer, Unit> function4 = function3;
                                    boolean z111 = z2;
                                    final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                    ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                    ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                    CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                    ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                    function4.invoke(composer2, 0);
                                    AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z111, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                        {
                                            super(3);
                                        }

                                        public Object invoke(Object obj, Object obj2, Object obj3) {
                                            invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                            return Unit.INSTANCE;
                                        }

                                        public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11119) {
                                            ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventStart(176242764, i11119, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                            }
                                            Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                                }

                                                public Object invoke(Object obj) {
                                                    invoke((SemanticsPropertyReceiver) obj);
                                                    return Unit.INSTANCE;
                                                }
                                            });
                                            Function2<Composer, Integer, Unit> function6 = function5;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                            MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                            ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                            int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                            CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                            Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                            Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                            ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                            if (!(composer3.getApplier() instanceof Applier)) {
                                                ComposablesKt.invalidApplier();
                                            }
                                            composer3.startReusableNode();
                                            if (composer3.getInserting()) {
                                                composer3.createNode(constructor2);
                                            } else {
                                                composer3.useNode();
                                            }
                                            Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                            Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                            Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                            if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                                composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                                composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                            }
                                            Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                            ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                            RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                            ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                            SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                            function6.invoke(composer3, 0);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            composer3.endNode();
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            ComposerKt.sourceInformationMarkerEnd(composer3);
                                            if (ComposerKt.isTraceInProgress()) {
                                                ComposerKt.traceEventEnd();
                                            }
                                        }
                                    }, composer2, 54), composer2, 1600518, 18);
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
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11116 & 112) | (i11116 & 14) | 12582912 | (i11117 & 896) | (i11117 & 7168) | (57344 & i11117) | (458752 & i11117) | (i11117 & 3670016), 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        z3 = z110;
                        modifier3 = companion;
                        j4 = jM2173contentColorForek8zF_U;
                        floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                        mutableInteractionSource3 = mutableInteractionSource2;
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

                            public final void invoke(Composer composer2, int i11118) {
                                FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z111 = z2;
                    int i11118 = i3 >> 6;
                    int i11119 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111110) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i111110 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i111110, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z112 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z112, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i111111) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i111111, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11118 & 112) | (i11118 & 14) | 12582912 | (i11119 & 896) | (i11119 & 7168) | (57344 & i11119) | (458752 & i11119) | (i11119 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z111;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z112 = z2;
                    int i111110 = i3 >> 6;
                    int i111111 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111112) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i111112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i111112, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z113 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z113, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i111113) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i111113, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111110 & 112) | (i111110 & 14) | 12582912 | (i111111 & 896) | (i111111 & 7168) | (57344 & i111111) | (458752 & i111111) | (i111111 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z112;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i111112) {
                            FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z2 = z;
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    j3 = j;
                    if (composerStartRestartGroup.changed(j3)) {
                    }
                    i3 |= i12;
                } else {
                    j3 = j;
                }
                i3 |= i12;
            } else {
                j3 = j;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i10 = 4194304;
                } else {
                    i10 = 4194304;
                }
                i3 |= i10;
            }
            if ((i & 100663296) == 0) {
                if ((i2 & Fields.RotationX) == 0) {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                    if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                    }
                    i3 |= i13;
                } else {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevation2 = floatingActionButtonElevation;
            }
            i8 = i2 & Fields.RotationY;
            if (i8 != 0) {
                if ((805306368 & i) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i9 = 536870912;
                    } else {
                        i9 = 268435456;
                    }
                    i3 |= i9;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z113 = z2;
                    int i111112 = i3 >> 6;
                    int i111113 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111114) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i111114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i111114, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z114 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z114, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i111115) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i111115, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111112 & 112) | (i111112 & 14) | 12582912 | (i111113 & 896) | (i111113 & 7168) | (57344 & i111113) | (458752 & i111113) | (i111113 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z113;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z114 = z2;
                    int i111114 = i3 >> 6;
                    int i111115 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111116) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i111116 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i111116, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z115 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z115, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i111117) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i111117, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111114 & 112) | (i111114 & 14) | 12582912 | (i111115 & 896) | (i111115 & 7168) | (57344 & i111115) | (458752 & i111115) | (i111115 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z114;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i111116) {
                            FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z115 = z2;
                int i111116 = i3 >> 6;
                int i111117 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111118) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i111118 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i111118, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z116 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z116, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i111119) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i111119, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111116 & 112) | (i111116 & 14) | 12582912 | (i111117 & 896) | (i111117 & 7168) | (57344 & i111117) | (458752 & i111117) | (i111117 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z115;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z116 = z2;
                int i111118 = i3 >> 6;
                int i111119 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111110) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i1111110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i1111110, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z117 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z117, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1111111) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i1111111, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i111118 & 112) | (i111118 & 14) | 12582912 | (i111119 & 896) | (i111119 & 7168) | (57344 & i111119) | (458752 & i111119) | (i111119 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z116;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i1111110) {
                        FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        modifier2 = modifier;
        i6 = i2 & 16;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                z2 = z;
                if (composerStartRestartGroup.changed(z2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            if ((196608 & i) == 0) {
                if ((i2 & 32) == 0) {
                    shape2 = shape;
                    if (composerStartRestartGroup.changed(shape2)) {
                    }
                    i3 |= i11;
                } else {
                    shape2 = shape;
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            if ((1572864 & i) == 0) {
                if ((i2 & 64) == 0) {
                    j3 = j;
                    if (composerStartRestartGroup.changed(j3)) {
                    }
                    i3 |= i12;
                } else {
                    j3 = j;
                }
                i3 |= i12;
            } else {
                j3 = j;
            }
            if ((i & 12582912) != 0) {
                if ((i2 & Fields.SpotShadowColor) == 0) {
                    i10 = 4194304;
                } else {
                    i10 = 4194304;
                }
                i3 |= i10;
            }
            if ((i & 100663296) == 0) {
                if ((i2 & Fields.RotationX) == 0) {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                    if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                    }
                    i3 |= i13;
                } else {
                    floatingActionButtonElevation2 = floatingActionButtonElevation;
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevation2 = floatingActionButtonElevation;
            }
            i8 = i2 & Fields.RotationY;
            if (i8 != 0) {
                if ((805306368 & i) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i9 = 536870912;
                    } else {
                        i9 = 268435456;
                    }
                    i3 |= i9;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z117 = z2;
                    int i1111110 = i3 >> 6;
                    int i1111111 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111112) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i1111112 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i1111112, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z118 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z118, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1111113) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i1111113, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111110 & 112) | (i1111110 & 14) | 12582912 | (i1111111 & 896) | (i1111111 & 7168) | (57344 & i1111111) | (458752 & i1111111) | (i1111111 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z117;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    } else {
                        if (i4 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i6 != 0) {
                            z2 = true;
                        }
                        if ((i2 & 32) != 0) {
                            extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                            i3 &= -458753;
                        } else {
                            extendedFabShape = shape2;
                        }
                        if ((i2 & 64) != 0) {
                            containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                            i3 &= -3670017;
                        } else {
                            containerColor = j3;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                            i3 &= -29360129;
                        } else {
                            jM2173contentColorForek8zF_U = j2;
                        }
                        if ((i2 & Fields.RotationX) != 0) {
                            floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                            i3 &= -234881025;
                        } else {
                            floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                        }
                        if (i8 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                    }
                    boolean z118 = z2;
                    int i1111112 = i3 >> 6;
                    int i1111113 = i3 >> 9;
                    m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111114) {
                            float f;
                            float f2;
                            float fM3577getContainerWidthD9Ej5fM;
                            ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                            if ((i1111114 & 3) != 2 || !composer2.getSkipping()) {
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1172118032, i1111114, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                                }
                                if (z2) {
                                    f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                                } else {
                                    f = Dp.constructor-impl(0);
                                }
                                float f3 = f;
                                if (z2) {
                                    f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                                } else {
                                    f2 = Dp.constructor-impl(0);
                                }
                                float f4 = f2;
                                Modifier.Companion companion2 = Modifier.INSTANCE;
                                if (z2) {
                                    fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                                } else {
                                    fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                                }
                                Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                                Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                                Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                                Function2<Composer, Integer, Unit> function4 = function3;
                                boolean z119 = z2;
                                final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                                ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                                ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                                CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                                ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                                function4.invoke(composer2, 0);
                                AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z119, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                    {
                                        super(3);
                                    }

                                    public Object invoke(Object obj, Object obj2, Object obj3) {
                                        invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1111115) {
                                        ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(176242764, i1111115, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                        }
                                        Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                            public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                            }

                                            public Object invoke(Object obj) {
                                                invoke((SemanticsPropertyReceiver) obj);
                                                return Unit.INSTANCE;
                                            }
                                        });
                                        Function2<Composer, Integer, Unit> function6 = function5;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                        MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                        ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                        CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                        ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                        if (!(composer3.getApplier() instanceof Applier)) {
                                            ComposablesKt.invalidApplier();
                                        }
                                        composer3.startReusableNode();
                                        if (composer3.getInserting()) {
                                            composer3.createNode(constructor2);
                                        } else {
                                            composer3.useNode();
                                        }
                                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                        }
                                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                        ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                        RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                        ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                        SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                        function6.invoke(composer3, 0);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        composer3.endNode();
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        ComposerKt.sourceInformationMarkerEnd(composer3);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }, composer2, 54), composer2, 1600518, 18);
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
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111112 & 112) | (i1111112 & 14) | 12582912 | (i1111113 & 896) | (i1111113 & 7168) | (57344 & i1111113) | (458752 & i1111113) | (i1111113 & 3670016), 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z3 = z118;
                    modifier3 = companion;
                    j4 = jM2173contentColorForek8zF_U;
                    floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                    mutableInteractionSource3 = mutableInteractionSource2;
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

                        public final void invoke(Composer composer2, int i1111114) {
                            FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z119 = z2;
                int i1111114 = i3 >> 6;
                int i1111115 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111116) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i1111116 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i1111116, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z1110 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z1110, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1111117) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i1111117, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111114 & 112) | (i1111114 & 14) | 12582912 | (i1111115 & 896) | (i1111115 & 7168) | (57344 & i1111115) | (458752 & i1111115) | (i1111115 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z119;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z1110 = z2;
                int i1111116 = i3 >> 6;
                int i1111117 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111118) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i1111118 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i1111118, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z1111 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z1111, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i1111119) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i1111119, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111116 & 112) | (i1111116 & 14) | 12582912 | (i1111117 & 896) | (i1111117 & 7168) | (57344 & i1111117) | (458752 & i1111117) | (i1111117 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z1110;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i1111118) {
                        FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        z2 = z;
        if ((196608 & i) == 0) {
            if ((i2 & 32) == 0) {
                shape2 = shape;
                if (composerStartRestartGroup.changed(shape2)) {
                }
                i3 |= i11;
            } else {
                shape2 = shape;
            }
            i3 |= i11;
        } else {
            shape2 = shape;
        }
        if ((1572864 & i) == 0) {
            if ((i2 & 64) == 0) {
                j3 = j;
                if (composerStartRestartGroup.changed(j3)) {
                }
                i3 |= i12;
            } else {
                j3 = j;
            }
            i3 |= i12;
        } else {
            j3 = j;
        }
        if ((i & 12582912) != 0) {
            if ((i2 & Fields.SpotShadowColor) == 0) {
                i10 = 4194304;
            } else {
                i10 = 4194304;
            }
            i3 |= i10;
        }
        if ((i & 100663296) == 0) {
            if ((i2 & Fields.RotationX) == 0) {
                floatingActionButtonElevation2 = floatingActionButtonElevation;
                if (composerStartRestartGroup.changed(floatingActionButtonElevation2)) {
                }
                i3 |= i13;
            } else {
                floatingActionButtonElevation2 = floatingActionButtonElevation;
            }
            i3 |= i13;
        } else {
            floatingActionButtonElevation2 = floatingActionButtonElevation;
        }
        i8 = i2 & Fields.RotationY;
        if (i8 != 0) {
            if ((805306368 & i) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i9 = 536870912;
                } else {
                    i9 = 268435456;
                }
                i3 |= i9;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z1111 = z2;
                int i1111118 = i3 >> 6;
                int i1111119 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111110) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i11111110 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i11111110, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z1112 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z1112, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11111111) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i11111111, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i1111118 & 112) | (i1111118 & 14) | 12582912 | (i1111119 & 896) | (i1111119 & 7168) | (57344 & i1111119) | (458752 & i1111119) | (i1111119 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z1111;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                } else {
                    if (i4 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i6 != 0) {
                        z2 = true;
                    }
                    if ((i2 & 32) != 0) {
                        extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                        i3 &= -458753;
                    } else {
                        extendedFabShape = shape2;
                    }
                    if ((i2 & 64) != 0) {
                        containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                        i3 &= -3670017;
                    } else {
                        containerColor = j3;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                        i3 &= -29360129;
                    } else {
                        jM2173contentColorForek8zF_U = j2;
                    }
                    if ((i2 & Fields.RotationX) != 0) {
                        floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                        i3 &= -234881025;
                    } else {
                        floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                    }
                    if (i8 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
                }
                boolean z1112 = z2;
                int i11111110 = i3 >> 6;
                int i11111111 = i3 >> 9;
                m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111112) {
                        float f;
                        float f2;
                        float fM3577getContainerWidthD9Ej5fM;
                        ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                        if ((i11111112 & 3) != 2 || !composer2.getSkipping()) {
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1172118032, i11111112, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                            }
                            if (z2) {
                                f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                            } else {
                                f = Dp.constructor-impl(0);
                            }
                            float f3 = f;
                            if (z2) {
                                f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                            } else {
                                f2 = Dp.constructor-impl(0);
                            }
                            float f4 = f2;
                            Modifier.Companion companion2 = Modifier.INSTANCE;
                            if (z2) {
                                fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                            } else {
                                fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                            }
                            Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                            Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                            Function2<Composer, Integer, Unit> function4 = function3;
                            boolean z1113 = z2;
                            final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                            ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                            ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                            CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                            ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                            function4.invoke(composer2, 0);
                            AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z1113, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                                {
                                    super(3);
                                }

                                public Object invoke(Object obj, Object obj2, Object obj3) {
                                    invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11111113) {
                                    ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(176242764, i11111113, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                    }
                                    Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                        }

                                        public Object invoke(Object obj) {
                                            invoke((SemanticsPropertyReceiver) obj);
                                            return Unit.INSTANCE;
                                        }
                                    });
                                    Function2<Composer, Integer, Unit> function6 = function5;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                    MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                    ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                    int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                    CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                    Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                    Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                    ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                    if (!(composer3.getApplier() instanceof Applier)) {
                                        ComposablesKt.invalidApplier();
                                    }
                                    composer3.startReusableNode();
                                    if (composer3.getInserting()) {
                                        composer3.createNode(constructor2);
                                    } else {
                                        composer3.useNode();
                                    }
                                    Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                    Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                    Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                    Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                    if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                        composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                        composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                    }
                                    Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                    ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                    RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                    ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                    SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                    function6.invoke(composer3, 0);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    composer3.endNode();
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    ComposerKt.sourceInformationMarkerEnd(composer3);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composer2, 54), composer2, 1600518, 18);
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
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111110 & 112) | (i11111110 & 14) | 12582912 | (i11111111 & 896) | (i11111111 & 7168) | (57344 & i11111111) | (458752 & i11111111) | (i11111111 & 3670016), 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z3 = z1112;
                modifier3 = companion;
                j4 = jM2173contentColorForek8zF_U;
                floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
                mutableInteractionSource3 = mutableInteractionSource2;
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

                    public final void invoke(Composer composer2, int i11111112) {
                        FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 805306368;
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    z2 = true;
                }
                if ((i2 & 32) != 0) {
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 64) != 0) {
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    containerColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                    i3 &= -29360129;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i3 &= -234881025;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                }
                if (i8 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    z2 = true;
                }
                if ((i2 & 32) != 0) {
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 64) != 0) {
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    containerColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                    i3 &= -29360129;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i3 &= -234881025;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                }
                if (i8 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
            }
            boolean z1113 = z2;
            int i11111112 = i3 >> 6;
            int i11111113 = i3 >> 9;
            m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111114) {
                    float f;
                    float f2;
                    float fM3577getContainerWidthD9Ej5fM;
                    ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                    if ((i11111114 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1172118032, i11111114, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                        }
                        if (z2) {
                            f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                        } else {
                            f = Dp.constructor-impl(0);
                        }
                        float f3 = f;
                        if (z2) {
                            f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                        } else {
                            f2 = Dp.constructor-impl(0);
                        }
                        float f4 = f2;
                        Modifier.Companion companion2 = Modifier.INSTANCE;
                        if (z2) {
                            fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                        } else {
                            fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                        }
                        Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                        Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                        Function2<Composer, Integer, Unit> function4 = function3;
                        boolean z1114 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z1114, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11111115) {
                                ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(176242764, i11111115, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                }
                                Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function6 = function5;
                                ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor2);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                function6.invoke(composer3, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, 1600518, 18);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111112 & 112) | (i11111112 & 14) | 12582912 | (i11111113 & 896) | (i11111113 & 7168) | (57344 & i11111113) | (458752 & i11111113) | (i11111113 & 3670016), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z3 = z1113;
            modifier3 = companion;
            j4 = jM2173contentColorForek8zF_U;
            floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
            mutableInteractionSource3 = mutableInteractionSource2;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    z2 = true;
                }
                if ((i2 & 32) != 0) {
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 64) != 0) {
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    containerColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                    i3 &= -29360129;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i3 &= -234881025;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                }
                if (i8 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            } else {
                if (i4 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i6 != 0) {
                    z2 = true;
                }
                if ((i2 & 32) != 0) {
                    extendedFabShape = FloatingActionButtonDefaults.INSTANCE.getExtendedFabShape(composerStartRestartGroup, 6);
                    i3 &= -458753;
                } else {
                    extendedFabShape = shape2;
                }
                if ((i2 & 64) != 0) {
                    containerColor = FloatingActionButtonDefaults.INSTANCE.getContainerColor(composerStartRestartGroup, 6);
                    i3 &= -3670017;
                } else {
                    containerColor = j3;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    jM2173contentColorForek8zF_U = ColorSchemeKt.m2173contentColorForek8zF_U(containerColor, composerStartRestartGroup, (i3 >> 18) & 14);
                    i3 &= -29360129;
                } else {
                    jM2173contentColorForek8zF_U = j2;
                }
                if ((i2 & Fields.RotationX) != 0) {
                    floatingActionButtonElevationM2400elevationxZ9QkE = FloatingActionButtonDefaults.INSTANCE.m2400elevationxZ9QkE(0.0f, 0.0f, 0.0f, 0.0f, composerStartRestartGroup, 24576, 15);
                    i3 &= -234881025;
                } else {
                    floatingActionButtonElevationM2400elevationxZ9QkE = floatingActionButtonElevation2;
                }
                if (i8 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1387401842, i3, -1, "androidx.compose.material3.ExtendedFloatingActionButton (FloatingActionButton.kt:364)");
            }
            boolean z1114 = z2;
            int i11111114 = i3 >> 6;
            int i11111115 = i3 >> 9;
            m2408FloatingActionButtonXz6DiA(function0, companion, extendedFabShape, containerColor, jM2173contentColorForek8zF_U, floatingActionButtonElevationM2400elevationxZ9QkE, mutableInteractionSource2, ComposableLambdaKt.rememberComposableLambda(1172118032, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111116) {
                    float f;
                    float f2;
                    float fM3577getContainerWidthD9Ej5fM;
                    ComposerKt.sourceInformation(composer2, "C377@18029L885:FloatingActionButton.kt#uh7d8r");
                    if ((i11111116 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1172118032, i11111116, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous> (FloatingActionButton.kt:374)");
                        }
                        if (z2) {
                            f = FloatingActionButtonKt.ExtendedFabStartIconPadding;
                        } else {
                            f = Dp.constructor-impl(0);
                        }
                        float f3 = f;
                        if (z2) {
                            f2 = FloatingActionButtonKt.ExtendedFabTextPadding;
                        } else {
                            f2 = Dp.constructor-impl(0);
                        }
                        float f4 = f2;
                        Modifier.Companion companion2 = Modifier.INSTANCE;
                        if (z2) {
                            fM3577getContainerWidthD9Ej5fM = FloatingActionButtonKt.ExtendedFabMinimumWidth;
                        } else {
                            fM3577getContainerWidthD9Ej5fM = FabPrimaryTokens.INSTANCE.m3577getContainerWidthD9Ej5fM();
                        }
                        Modifier modifierM1039paddingqDBjuR0$default = PaddingKt.m1039paddingqDBjuR0$default(SizeKt.m1084sizeInqDBjuR0$default(companion2, fM3577getContainerWidthD9Ej5fM, 0.0f, 0.0f, 0.0f, 14, null), f3, 0.0f, f4, 0.0f, 10, null);
                        Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
                        Arrangement.HorizontalOrVertical start = z2 ? Arrangement.INSTANCE.getStart() : Arrangement.INSTANCE.getCenter();
                        Function2<Composer, Integer, Unit> function4 = function3;
                        boolean z1115 = z2;
                        final Function2<? super Composer, ? super Integer, Unit> function5 = function2;
                        ComposerKt.sourceInformationMarkerStart(composer2, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                        MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(start, centerVertically, composer2, 48);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composer2, modifierM1039paddingqDBjuR0$default);
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
                        ComposerKt.sourceInformationMarkerStart(composer2, 1618821151, "C388@18524L6,393@18718L186,389@18543L361:FloatingActionButton.kt#uh7d8r");
                        function4.invoke(composer2, 0);
                        AnimatedVisibilityKt.AnimatedVisibility(rowScopeInstance, z1115, (Modifier) null, FloatingActionButtonKt.ExtendedFabExpandAnimation, FloatingActionButtonKt.ExtendedFabCollapseAnimation, (String) null, ComposableLambdaKt.rememberComposableLambda(176242764, true, new Function3<AnimatedVisibilityScope, Composer, Integer, Unit>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                invoke((AnimatedVisibilityScope) obj, (Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(AnimatedVisibilityScope animatedVisibilityScope, Composer composer3, int i11111117) {
                                ComposerKt.sourceInformation(composer3, "C394@18736L154:FloatingActionButton.kt#uh7d8r");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(176242764, i11111117, -1, "androidx.compose.material3.ExtendedFloatingActionButton.<anonymous>.<anonymous>.<anonymous> (FloatingActionButton.kt:394)");
                                }
                                Modifier modifierClearAndSetSemantics = SemanticsModifierKt.clearAndSetSemantics(Modifier.INSTANCE, new Function1<SemanticsPropertyReceiver, Unit>() {
                                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                                    }

                                    public Object invoke(Object obj) {
                                        invoke((SemanticsPropertyReceiver) obj);
                                        return Unit.INSTANCE;
                                    }
                                });
                                Function2<Composer, Integer, Unit> function6 = function5;
                                ComposerKt.sourceInformationMarkerStart(composer3, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
                                MeasurePolicy measurePolicyRowMeasurePolicy2 = RowKt.rowMeasurePolicy(Arrangement.INSTANCE.getStart(), Alignment.INSTANCE.getTop(), composer3, 0);
                                ComposerKt.sourceInformationMarkerStart(composer3, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                                int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer3, 0);
                                CompositionLocalMap currentCompositionLocalMap2 = composer3.getCurrentCompositionLocalMap();
                                Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer3, modifierClearAndSetSemantics);
                                Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                                ComposerKt.sourceInformationMarkerStart(composer3, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                                if (!(composer3.getApplier() instanceof Applier)) {
                                    ComposablesKt.invalidApplier();
                                }
                                composer3.startReusableNode();
                                if (composer3.getInserting()) {
                                    composer3.createNode(constructor2);
                                } else {
                                    composer3.useNode();
                                }
                                Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer3);
                                Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicyRowMeasurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                                Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                                Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                                if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                                    composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                                    composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                                }
                                Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                                ComposerKt.sourceInformationMarkerStart(composer3, -407918630, "C100@5047L9:Row.kt#2w3rfo");
                                RowScopeInstance rowScopeInstance2 = RowScopeInstance.INSTANCE;
                                ComposerKt.sourceInformationMarkerStart(composer3, 1967858577, "C395@18796L49,396@18866L6:FloatingActionButton.kt#uh7d8r");
                                SpacerKt.Spacer(SizeKt.m1085width3ABfNKs(Modifier.INSTANCE, FloatingActionButtonKt.ExtendedFabEndIconPadding), composer3, 6);
                                function6.invoke(composer3, 0);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                composer3.endNode();
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                ComposerKt.sourceInformationMarkerEnd(composer3);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composer2, 54), composer2, 1600518, 18);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i11111114 & 112) | (i11111114 & 14) | 12582912 | (i11111115 & 896) | (i11111115 & 7168) | (57344 & i11111115) | (458752 & i11111115) | (i11111115 & 3670016), 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z3 = z1114;
            modifier3 = companion;
            j4 = jM2173contentColorForek8zF_U;
            floatingActionButtonElevation3 = floatingActionButtonElevationM2400elevationxZ9QkE;
            mutableInteractionSource3 = mutableInteractionSource2;
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

                public final void invoke(Composer composer2, int i11111116) {
                    FloatingActionButtonKt.m2406ExtendedFloatingActionButtonElI57k(function2, function3, function0, modifier3, z3, extendedFabShape, containerColor, j4, floatingActionButtonElevation3, mutableInteractionSource3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }
}
