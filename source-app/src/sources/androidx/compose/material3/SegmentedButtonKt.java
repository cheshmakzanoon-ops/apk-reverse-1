package androidx.compose.material3;

import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.interaction.InteractionSource;
import androidx.compose.foundation.interaction.InteractionSourceKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.BoxKt;
import androidx.compose.foundation.layout.BoxScopeInstance;
import androidx.compose.foundation.layout.IntrinsicKt;
import androidx.compose.foundation.layout.IntrinsicSize;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.RowKt;
import androidx.compose.foundation.layout.RowScope;
import androidx.compose.foundation.layout.RowScopeInstance;
import androidx.compose.foundation.layout.SizeKt;
import androidx.compose.foundation.selection.SelectableGroupKt;
import androidx.compose.material3.tokens.OutlinedSegmentedButtonTokens;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.layout.LayoutKt;
import androidx.compose.p002ui.layout.LayoutModifierKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.MultiContentMeasurePolicyKt;
import androidx.compose.p002ui.layout.Placeable;
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
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.MutableIntState;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.SnapshotIntStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.internal.ComposableLambda;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Dp;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000v\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0004\u001aD\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u00032\u001c\u0010\n\u001a\u0018\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\u00060\u000b¢\u0006\u0002\b\r¢\u0006\u0002\b\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010\u001a3\u0010\u0011\u001a\u00020\u00062\u0011\u0010\u0012\u001a\r\u0012\u0004\u0012\u00020\u00060\u0013¢\u0006\u0002\b\r2\u0011\u0010\n\u001a\r\u0012\u0004\u0012\u00020\u00060\u0013¢\u0006\u0002\b\rH\u0003¢\u0006\u0002\u0010\u0014\u001aD\u0010\u0015\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\t\u001a\u00020\u00032\u001c\u0010\n\u001a\u0018\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00060\u000b¢\u0006\u0002\b\r¢\u0006\u0002\b\u000eH\u0007ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0010\u001a\u0091\u0001\u0010\u0018\u001a\u00020\u0006*\u00020\f2\u0006\u0010\u0019\u001a\u00020\u001a2\u0012\u0010\u001b\u001a\u000e\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00060\u000b2\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\u001e\u001a\u00020\u001a2\b\b\u0002\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010!\u001a\u00020\"2\n\b\u0002\u0010#\u001a\u0004\u0018\u00010$2\u0013\b\u0002\u0010\u0012\u001a\r\u0012\u0004\u0012\u00020\u00060\u0013¢\u0006\u0002\b\r2\u0011\u0010%\u001a\r\u0012\u0004\u0012\u00020\u00060\u0013¢\u0006\u0002\b\rH\u0007¢\u0006\u0002\u0010&\u001a\u008b\u0001\u0010\u0018\u001a\u00020\u0006*\u00020\u00162\u0006\u0010'\u001a\u00020\u001a2\f\u0010(\u001a\b\u0012\u0004\u0012\u00020\u00060\u00132\u0006\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0007\u001a\u00020\b2\b\b\u0002\u0010\u001e\u001a\u00020\u001a2\b\b\u0002\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010!\u001a\u00020\"2\n\b\u0002\u0010#\u001a\u0004\u0018\u00010$2\u0013\b\u0002\u0010\u0012\u001a\r\u0012\u0004\u0012\u00020\u00060\u0013¢\u0006\u0002\b\r2\u0011\u0010%\u001a\r\u0012\u0004\u0012\u00020\u00060\u0013¢\u0006\u0002\b\rH\u0007¢\u0006\u0002\u0010)\u001a\u0017\u0010*\u001a\b\u0012\u0004\u0012\u00020,0+*\u00020-H\u0003¢\u0006\u0002\u0010.\u001a\"\u0010/\u001a\u00020\b*\u00020\b2\u0006\u0010\u0019\u001a\u00020\u001a2\f\u00100\u001a\b\u0012\u0004\u0012\u00020,0+H\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0010\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0004\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00061"}, d2 = {"CheckedZIndexFactor", "", "IconSpacing", "Landroidx/compose/ui/unit/Dp;", "F", "MultiChoiceSegmentedButtonRow", "", "modifier", "Landroidx/compose/ui/Modifier;", "space", "content", "Lkotlin/Function1;", "Landroidx/compose/material3/MultiChoiceSegmentedButtonRowScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "MultiChoiceSegmentedButtonRow-uFdPcIQ", "(Landroidx/compose/ui/Modifier;FLkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "SegmentedButtonContent", "icon", "Lkotlin/Function0;", "(Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;I)V", "SingleChoiceSegmentedButtonRow", "Landroidx/compose/material3/SingleChoiceSegmentedButtonRowScope;", "SingleChoiceSegmentedButtonRow-uFdPcIQ", "SegmentedButton", "checked", "", "onCheckedChange", "shape", "Landroidx/compose/ui/graphics/Shape;", "enabled", "colors", "Landroidx/compose/material3/SegmentedButtonColors;", "border", "Landroidx/compose/foundation/BorderStroke;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "label", "(Landroidx/compose/material3/MultiChoiceSegmentedButtonRowScope;ZLkotlin/jvm/functions/Function1;Landroidx/compose/ui/graphics/Shape;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/SegmentedButtonColors;Landroidx/compose/foundation/BorderStroke;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;III)V", "selected", "onClick", "(Landroidx/compose/material3/SingleChoiceSegmentedButtonRowScope;ZLkotlin/jvm/functions/Function0;Landroidx/compose/ui/graphics/Shape;Landroidx/compose/ui/Modifier;ZLandroidx/compose/material3/SegmentedButtonColors;Landroidx/compose/foundation/BorderStroke;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Landroidx/compose/runtime/Composer;III)V", "interactionCountAsState", "Landroidx/compose/runtime/State;", "", "Landroidx/compose/foundation/interaction/InteractionSource;", "(Landroidx/compose/foundation/interaction/InteractionSource;Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "interactionZIndex", "interactionCount", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SegmentedButtonKt {
    private static final float CheckedZIndexFactor = 5.0f;
    private static final float IconSpacing = Dp.constructor-impl(8);

    public static final void SegmentedButton(final MultiChoiceSegmentedButtonRowScope multiChoiceSegmentedButtonRowScope, final boolean z, final Function1<? super Boolean, Unit> function1, final Shape shape, Modifier modifier, boolean z2, SegmentedButtonColors segmentedButtonColors, BorderStroke borderStroke, MutableInteractionSource mutableInteractionSource, Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        int i5;
        boolean z3;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        Modifier.Companion companion;
        SegmentedButtonColors segmentedButtonColorsColors;
        BorderStroke borderStrokeM2766borderStrokel07J4OM$default;
        MutableInteractionSource mutableInteractionSource2;
        int i13;
        final ComposableLambda composableLambdaRememberComposableLambda;
        MutableInteractionSource mutableInteractionSource3;
        Modifier modifier2;
        SegmentedButtonColors segmentedButtonColors2;
        BorderStroke borderStroke2;
        boolean z4;
        MutableInteractionSource mutableInteractionSource4;
        Composer composer2;
        final Function2<? super Composer, ? super Integer, Unit> function4;
        final SegmentedButtonColors segmentedButtonColors3;
        final boolean z5;
        final Modifier modifier3;
        final BorderStroke borderStroke3;
        final MutableInteractionSource mutableInteractionSource5;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i14;
        int i15;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1596038053);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SegmentedButton)P(1,8,9,7,3,2!1,5)133@6692L8,137@6905L41,144@7279L25,163@7880L51,146@7310L621:SegmentedButton.kt#uh7d8r");
        if ((Integer.MIN_VALUE & i3) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(multiChoiceSegmentedButtonRowScope) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        if ((i3 & 1) != 0) {
            i4 |= 48;
        } else if ((i & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(z) ? 32 : 16;
        }
        if ((i3 & 2) != 0) {
            i4 |= 384;
        } else if ((i & 384) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function1) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 4) != 0) {
            i4 |= 3072;
        } else if ((i & 3072) == 0) {
            i4 |= composerStartRestartGroup.changed(shape) ? Fields.CameraDistance : Fields.RotationZ;
        }
        int i16 = i3 & 8;
        if (i16 == 0) {
            if ((i & 24576) == 0) {
                i4 |= composerStartRestartGroup.changed(modifier) ? Fields.Clip : Fields.Shape;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((196608 & i) == 0) {
                    z3 = z2;
                    if (composerStartRestartGroup.changed(z3)) {
                        i6 = Fields.RenderEffect;
                    } else {
                        i6 = 65536;
                    }
                    i4 |= i6;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 32) == 0 || !composerStartRestartGroup.changed(segmentedButtonColors)) {
                        i15 = 524288;
                    } else {
                        i15 = 1048576;
                    }
                    i4 |= i15;
                }
                if ((i & 12582912) != 0) {
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(borderStroke)) {
                        i14 = 4194304;
                    } else {
                        i14 = 8388608;
                    }
                    i4 |= i14;
                }
                i7 = i3 & Fields.SpotShadowColor;
                if (i7 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i8 = 67108864;
                    } else {
                        i8 = 33554432;
                    }
                    i4 |= i8;
                }
                i9 = i3 & Fields.RotationX;
                if (i9 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i12 = 4;
                    } else {
                        i12 = 2;
                    }
                    i11 = i2 | i12;
                } else {
                    i11 = i2;
                }
                if ((i4 & 306783379) == 306783378 || (i11 & 3) != 2 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i5 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        } else {
                            segmentedButtonColorsColors = segmentedButtonColors;
                        }
                        if ((i3 & 64) != 0) {
                            borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                            i4 &= -29360129;
                        } else {
                            borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                        }
                        if (i7 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        if (i9 != 0) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i17) {
                                    ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                    if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                        composer3.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                    }
                                    SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composerStartRestartGroup, 54);
                            i13 = i4;
                        } else {
                            i13 = i4;
                            composableLambdaRememberComposableLambda = function2;
                        }
                        mutableInteractionSource3 = mutableInteractionSource2;
                        modifier2 = companion;
                        segmentedButtonColors2 = segmentedButtonColorsColors;
                        borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                        z4 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 32) != 0) {
                            i4 &= -3670017;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -29360129;
                        }
                        modifier2 = modifier;
                        borderStroke2 = borderStroke;
                        mutableInteractionSource3 = mutableInteractionSource;
                        composableLambdaRememberComposableLambda = function2;
                        i13 = i4;
                        z4 = z3;
                        segmentedButtonColors2 = segmentedButtonColors;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
                    }
                    composerStartRestartGroup.startReplaceGroup(1788099965);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    Function2<? super Composer, ? super Integer, Unit> function5 = composableLambdaRememberComposableLambda;
                    SegmentedButtonColors segmentedButtonColors4 = segmentedButtonColors2;
                    composer2 = composerStartRestartGroup;
                    boolean z6 = z4;
                    SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                            }
                            SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function4 = function5;
                    segmentedButtonColors3 = segmentedButtonColors4;
                    z5 = z6;
                    modifier3 = modifier2;
                    borderStroke3 = borderStroke2;
                    mutableInteractionSource5 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    segmentedButtonColors3 = segmentedButtonColors;
                    borderStroke3 = borderStroke;
                    mutableInteractionSource5 = mutableInteractionSource;
                    function4 = function2;
                    composer2 = composerStartRestartGroup;
                    z5 = z3;
                    modifier3 = modifier;
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

                        public final void invoke(Composer composer3, int i17) {
                            SegmentedButtonKt.SegmentedButton(multiChoiceSegmentedButtonRowScope, z, function1, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 196608;
            z3 = z2;
            if ((i & 1572864) != 0) {
                if ((i3 & 32) == 0) {
                    i15 = 524288;
                } else {
                    i15 = 524288;
                }
                i4 |= i15;
            }
            if ((i & 12582912) != 0) {
                if ((i3 & 64) == 0) {
                    i14 = 4194304;
                } else {
                    i14 = 4194304;
                }
                i4 |= i14;
            }
            i7 = i3 & Fields.SpotShadowColor;
            if (i7 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i8 = 67108864;
                } else {
                    i8 = 33554432;
                }
                i4 |= i8;
            }
            i9 = i3 & Fields.RotationX;
            if (i9 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i10 = 536870912;
                } else {
                    i10 = 268435456;
                }
                i4 |= i10;
            }
            if ((i3 & Fields.RotationY) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i12 = 4;
                } else {
                    i12 = 2;
                }
                i11 = i2 | i12;
            } else {
                i11 = i2;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
                }
                composerStartRestartGroup.startReplaceGroup(1788099965);
                ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                Function2<? super Composer, ? super Integer, Unit> function6 = composableLambdaRememberComposableLambda;
                SegmentedButtonColors segmentedButtonColors5 = segmentedButtonColors2;
                composer2 = composerStartRestartGroup;
                boolean z7 = z4;
                SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function6;
                segmentedButtonColors3 = segmentedButtonColors5;
                z5 = z7;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
                }
                composerStartRestartGroup.startReplaceGroup(1788099965);
                ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                Function2<? super Composer, ? super Integer, Unit> function7 = composableLambdaRememberComposableLambda;
                SegmentedButtonColors segmentedButtonColors6 = segmentedButtonColors2;
                composer2 = composerStartRestartGroup;
                boolean z8 = z4;
                SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function7;
                segmentedButtonColors3 = segmentedButtonColors6;
                z5 = z8;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
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

                    public final void invoke(Composer composer3, int i17) {
                        SegmentedButtonKt.SegmentedButton(multiChoiceSegmentedButtonRowScope, z, function1, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((196608 & i) == 0) {
                z3 = z2;
                if (composerStartRestartGroup.changed(z3)) {
                    i6 = Fields.RenderEffect;
                } else {
                    i6 = 65536;
                }
                i4 |= i6;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 32) == 0) {
                    i15 = 524288;
                } else {
                    i15 = 524288;
                }
                i4 |= i15;
            }
            if ((i & 12582912) != 0) {
                if ((i3 & 64) == 0) {
                    i14 = 4194304;
                } else {
                    i14 = 4194304;
                }
                i4 |= i14;
            }
            i7 = i3 & Fields.SpotShadowColor;
            if (i7 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i8 = 67108864;
                } else {
                    i8 = 33554432;
                }
                i4 |= i8;
            }
            i9 = i3 & Fields.RotationX;
            if (i9 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i10 = 536870912;
                } else {
                    i10 = 268435456;
                }
                i4 |= i10;
            }
            if ((i3 & Fields.RotationY) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i12 = 4;
                } else {
                    i12 = 2;
                }
                i11 = i2 | i12;
            } else {
                i11 = i2;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
                }
                composerStartRestartGroup.startReplaceGroup(1788099965);
                ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                Function2<? super Composer, ? super Integer, Unit> function8 = composableLambdaRememberComposableLambda;
                SegmentedButtonColors segmentedButtonColors7 = segmentedButtonColors2;
                composer2 = composerStartRestartGroup;
                boolean z9 = z4;
                SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function8;
                segmentedButtonColors3 = segmentedButtonColors7;
                z5 = z9;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
                }
                composerStartRestartGroup.startReplaceGroup(1788099965);
                ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                Function2<? super Composer, ? super Integer, Unit> function9 = composableLambdaRememberComposableLambda;
                SegmentedButtonColors segmentedButtonColors8 = segmentedButtonColors2;
                composer2 = composerStartRestartGroup;
                boolean z10 = z4;
                SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function9;
                segmentedButtonColors3 = segmentedButtonColors8;
                z5 = z10;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
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

                    public final void invoke(Composer composer3, int i17) {
                        SegmentedButtonKt.SegmentedButton(multiChoiceSegmentedButtonRowScope, z, function1, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 196608;
        z3 = z2;
        if ((i & 1572864) != 0) {
            if ((i3 & 32) == 0) {
                i15 = 524288;
            } else {
                i15 = 524288;
            }
            i4 |= i15;
        }
        if ((i & 12582912) != 0) {
            if ((i3 & 64) == 0) {
                i14 = 4194304;
            } else {
                i14 = 4194304;
            }
            i4 |= i14;
        }
        i7 = i3 & Fields.SpotShadowColor;
        if (i7 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i8 = 67108864;
            } else {
                i8 = 33554432;
            }
            i4 |= i8;
        }
        i9 = i3 & Fields.RotationX;
        if (i9 != 0) {
            i4 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i10 = 536870912;
            } else {
                i10 = 268435456;
            }
            i4 |= i10;
        }
        if ((i3 & Fields.RotationY) != 0) {
            i11 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i12 = 4;
            } else {
                i12 = 2;
            }
            i11 = i2 | i12;
        } else {
            i11 = i2;
        }
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
            }
            composerStartRestartGroup.startReplaceGroup(1788099965);
            ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
            if (mutableInteractionSource3 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            composerStartRestartGroup.endReplaceGroup();
            Function2<? super Composer, ? super Integer, Unit> function10 = composableLambdaRememberComposableLambda;
            SegmentedButtonColors segmentedButtonColors9 = segmentedButtonColors2;
            composer2 = composerStartRestartGroup;
            boolean z11 = z4;
            SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i17) {
                    ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                    if ((i17 & 3) == 2 && composer3.getSkipping()) {
                        composer3.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                    }
                    SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function4 = function10;
            segmentedButtonColors3 = segmentedButtonColors9;
            z5 = z11;
            modifier3 = modifier2;
            borderStroke3 = borderStroke2;
            mutableInteractionSource5 = mutableInteractionSource3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(970447394, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C137@6931L13:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(970447394, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:137)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1596038053, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:139)");
            }
            composerStartRestartGroup.startReplaceGroup(1788099965);
            ComposerKt.sourceInformation(composerStartRestartGroup, "141@7068L39");
            if (mutableInteractionSource3 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788100616, "CC(remember):SegmentedButton.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            composerStartRestartGroup.endReplaceGroup();
            Function2<? super Composer, ? super Integer, Unit> function11 = composableLambdaRememberComposableLambda;
            SegmentedButtonColors segmentedButtonColors10 = segmentedButtonColors2;
            composer2 = composerStartRestartGroup;
            boolean z12 = z4;
            SurfaceKt.m2870Surfaced85dljk(z, function1, SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(multiChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(1635710341, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i17) {
                    ComposerKt.sourceInformation(composer3, "C164@7890L35:SegmentedButton.kt#uh7d8r");
                    if ((i17 & 3) == 2 && composer3.getSkipping()) {
                        composer3.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1635710341, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:164)");
                    }
                    SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function4 = function11;
            segmentedButtonColors3 = segmentedButtonColors10;
            z5 = z12;
            modifier3 = modifier2;
            borderStroke3 = borderStroke2;
            mutableInteractionSource5 = mutableInteractionSource3;
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

                public final void invoke(Composer composer3, int i17) {
                    SegmentedButtonKt.SegmentedButton(multiChoiceSegmentedButtonRowScope, z, function1, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    public static final void SegmentedButton(final SingleChoiceSegmentedButtonRowScope singleChoiceSegmentedButtonRowScope, final boolean z, final Function0<Unit> function0, final Shape shape, Modifier modifier, boolean z2, SegmentedButtonColors segmentedButtonColors, BorderStroke borderStroke, MutableInteractionSource mutableInteractionSource, Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2, final int i3) {
        int i4;
        int i5;
        boolean z3;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        Modifier.Companion companion;
        SegmentedButtonColors segmentedButtonColorsColors;
        BorderStroke borderStrokeM2766borderStrokel07J4OM$default;
        MutableInteractionSource mutableInteractionSource2;
        int i13;
        final ComposableLambda composableLambdaRememberComposableLambda;
        MutableInteractionSource mutableInteractionSource3;
        Modifier modifier2;
        SegmentedButtonColors segmentedButtonColors2;
        BorderStroke borderStroke2;
        boolean z4;
        MutableInteractionSource mutableInteractionSource4;
        Composer composer2;
        final Function2<? super Composer, ? super Integer, Unit> function4;
        final SegmentedButtonColors segmentedButtonColors3;
        final boolean z5;
        final Modifier modifier3;
        final BorderStroke borderStroke3;
        final MutableInteractionSource mutableInteractionSource5;
        Object objRememberedValue;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i14;
        int i15;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1016574361);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SegmentedButton)P(8,7,9,6,2,1!1,4)211@10255L8,215@10469L42,222@10846L25,242@11489L51,224@10877L663:SegmentedButton.kt#uh7d8r");
        if ((Integer.MIN_VALUE & i3) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changed(singleChoiceSegmentedButtonRowScope) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        if ((i3 & 1) != 0) {
            i4 |= 48;
        } else if ((i & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(z) ? 32 : 16;
        }
        if ((i3 & 2) != 0) {
            i4 |= 384;
        } else if ((i & 384) == 0) {
            i4 |= composerStartRestartGroup.changedInstance(function0) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 4) != 0) {
            i4 |= 3072;
        } else if ((i & 3072) == 0) {
            i4 |= composerStartRestartGroup.changed(shape) ? Fields.CameraDistance : Fields.RotationZ;
        }
        int i16 = i3 & 8;
        if (i16 == 0) {
            if ((i & 24576) == 0) {
                i4 |= composerStartRestartGroup.changed(modifier) ? Fields.Clip : Fields.Shape;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((196608 & i) == 0) {
                    z3 = z2;
                    if (composerStartRestartGroup.changed(z3)) {
                        i6 = Fields.RenderEffect;
                    } else {
                        i6 = 65536;
                    }
                    i4 |= i6;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 32) == 0 || !composerStartRestartGroup.changed(segmentedButtonColors)) {
                        i15 = 524288;
                    } else {
                        i15 = 1048576;
                    }
                    i4 |= i15;
                }
                if ((i & 12582912) != 0) {
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(borderStroke)) {
                        i14 = 4194304;
                    } else {
                        i14 = 8388608;
                    }
                    i4 |= i14;
                }
                i7 = i3 & Fields.SpotShadowColor;
                if (i7 != 0) {
                    i4 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                        i8 = 67108864;
                    } else {
                        i8 = 33554432;
                    }
                    i4 |= i8;
                }
                i9 = i3 & Fields.RotationX;
                if (i9 != 0) {
                    i4 |= 805306368;
                } else if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function2)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i12 = 4;
                    } else {
                        i12 = 2;
                    }
                    i11 = i2 | i12;
                } else {
                    i11 = i2;
                }
                if ((i4 & 306783379) == 306783378 || (i11 & 3) != 2 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i16 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i5 != 0) {
                            z3 = true;
                        }
                        if ((i3 & 32) != 0) {
                            segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        } else {
                            segmentedButtonColorsColors = segmentedButtonColors;
                        }
                        if ((i3 & 64) != 0) {
                            borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                            i4 &= -29360129;
                        } else {
                            borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                        }
                        if (i7 != 0) {
                            mutableInteractionSource2 = null;
                        } else {
                            mutableInteractionSource2 = mutableInteractionSource;
                        }
                        if (i9 != 0) {
                            composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer3, int i17) {
                                    ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                    if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                        composer3.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                    }
                                    SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composerStartRestartGroup, 54);
                            i13 = i4;
                        } else {
                            i13 = i4;
                            composableLambdaRememberComposableLambda = function2;
                        }
                        mutableInteractionSource3 = mutableInteractionSource2;
                        modifier2 = companion;
                        segmentedButtonColors2 = segmentedButtonColorsColors;
                        borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                        z4 = z3;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 32) != 0) {
                            i4 &= -3670017;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -29360129;
                        }
                        modifier2 = modifier;
                        borderStroke2 = borderStroke;
                        mutableInteractionSource3 = mutableInteractionSource;
                        composableLambdaRememberComposableLambda = function2;
                        i13 = i4;
                        z4 = z3;
                        segmentedButtonColors2 = segmentedButtonColors;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
                    }
                    composerStartRestartGroup.startReplaceGroup(1788214045);
                    ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
                    if (mutableInteractionSource3 == null) {
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                    } else {
                        mutableInteractionSource4 = mutableInteractionSource3;
                    }
                    composerStartRestartGroup.endReplaceGroup();
                    SegmentedButtonColors segmentedButtonColors4 = segmentedButtonColors2;
                    Function2<? super Composer, ? super Integer, Unit> function5 = composableLambdaRememberComposableLambda;
                    composer2 = composerStartRestartGroup;
                    boolean z6 = z4;
                    SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((SemanticsPropertyReceiver) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                            SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                        }
                    }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                            }
                            SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    function4 = function5;
                    segmentedButtonColors3 = segmentedButtonColors4;
                    z5 = z6;
                    modifier3 = modifier2;
                    borderStroke3 = borderStroke2;
                    mutableInteractionSource5 = mutableInteractionSource3;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    segmentedButtonColors3 = segmentedButtonColors;
                    borderStroke3 = borderStroke;
                    mutableInteractionSource5 = mutableInteractionSource;
                    function4 = function2;
                    composer2 = composerStartRestartGroup;
                    z5 = z3;
                    modifier3 = modifier;
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

                        public final void invoke(Composer composer3, int i17) {
                            SegmentedButtonKt.SegmentedButton(singleChoiceSegmentedButtonRowScope, z, function0, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 196608;
            z3 = z2;
            if ((i & 1572864) != 0) {
                if ((i3 & 32) == 0) {
                    i15 = 524288;
                } else {
                    i15 = 524288;
                }
                i4 |= i15;
            }
            if ((i & 12582912) != 0) {
                if ((i3 & 64) == 0) {
                    i14 = 4194304;
                } else {
                    i14 = 4194304;
                }
                i4 |= i14;
            }
            i7 = i3 & Fields.SpotShadowColor;
            if (i7 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i8 = 67108864;
                } else {
                    i8 = 33554432;
                }
                i4 |= i8;
            }
            i9 = i3 & Fields.RotationX;
            if (i9 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i10 = 536870912;
                } else {
                    i10 = 268435456;
                }
                i4 |= i10;
            }
            if ((i3 & Fields.RotationY) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i12 = 4;
                } else {
                    i12 = 2;
                }
                i11 = i2 | i12;
            } else {
                i11 = i2;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
                }
                composerStartRestartGroup.startReplaceGroup(1788214045);
                ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                SegmentedButtonColors segmentedButtonColors5 = segmentedButtonColors2;
                Function2<? super Composer, ? super Integer, Unit> function6 = composableLambdaRememberComposableLambda;
                composer2 = composerStartRestartGroup;
                boolean z7 = z4;
                SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                    }
                }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function6;
                segmentedButtonColors3 = segmentedButtonColors5;
                z5 = z7;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
                }
                composerStartRestartGroup.startReplaceGroup(1788214045);
                ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                SegmentedButtonColors segmentedButtonColors6 = segmentedButtonColors2;
                Function2<? super Composer, ? super Integer, Unit> function7 = composableLambdaRememberComposableLambda;
                composer2 = composerStartRestartGroup;
                boolean z8 = z4;
                SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                    }
                }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function7;
                segmentedButtonColors3 = segmentedButtonColors6;
                z5 = z8;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
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

                    public final void invoke(Composer composer3, int i17) {
                        SegmentedButtonKt.SegmentedButton(singleChoiceSegmentedButtonRowScope, z, function0, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((196608 & i) == 0) {
                z3 = z2;
                if (composerStartRestartGroup.changed(z3)) {
                    i6 = Fields.RenderEffect;
                } else {
                    i6 = 65536;
                }
                i4 |= i6;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 32) == 0) {
                    i15 = 524288;
                } else {
                    i15 = 524288;
                }
                i4 |= i15;
            }
            if ((i & 12582912) != 0) {
                if ((i3 & 64) == 0) {
                    i14 = 4194304;
                } else {
                    i14 = 4194304;
                }
                i4 |= i14;
            }
            i7 = i3 & Fields.SpotShadowColor;
            if (i7 != 0) {
                i4 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                    i8 = 67108864;
                } else {
                    i8 = 33554432;
                }
                i4 |= i8;
            }
            i9 = i3 & Fields.RotationX;
            if (i9 != 0) {
                i4 |= 805306368;
            } else if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function2)) {
                    i10 = 536870912;
                } else {
                    i10 = 268435456;
                }
                i4 |= i10;
            }
            if ((i3 & Fields.RotationY) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i12 = 4;
                } else {
                    i12 = 2;
                }
                i11 = i2 | i12;
            } else {
                i11 = i2;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
                }
                composerStartRestartGroup.startReplaceGroup(1788214045);
                ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                SegmentedButtonColors segmentedButtonColors7 = segmentedButtonColors2;
                Function2<? super Composer, ? super Integer, Unit> function8 = composableLambdaRememberComposableLambda;
                composer2 = composerStartRestartGroup;
                boolean z9 = z4;
                SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                    }
                }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function8;
                segmentedButtonColors3 = segmentedButtonColors7;
                z5 = z9;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                } else {
                    if (i16 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        z3 = true;
                    }
                    if ((i3 & 32) != 0) {
                        segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        segmentedButtonColorsColors = segmentedButtonColors;
                    }
                    if ((i3 & 64) != 0) {
                        borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                        i4 &= -29360129;
                    } else {
                        borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                    }
                    if (i7 != 0) {
                        mutableInteractionSource2 = null;
                    } else {
                        mutableInteractionSource2 = mutableInteractionSource;
                    }
                    if (i9 != 0) {
                        composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer3, int i17) {
                                ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                                if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                    composer3.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                                }
                                SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54);
                        i13 = i4;
                    } else {
                        i13 = i4;
                        composableLambdaRememberComposableLambda = function2;
                    }
                    mutableInteractionSource3 = mutableInteractionSource2;
                    modifier2 = companion;
                    segmentedButtonColors2 = segmentedButtonColorsColors;
                    borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                    z4 = z3;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
                }
                composerStartRestartGroup.startReplaceGroup(1788214045);
                ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
                if (mutableInteractionSource3 == null) {
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
                } else {
                    mutableInteractionSource4 = mutableInteractionSource3;
                }
                composerStartRestartGroup.endReplaceGroup();
                SegmentedButtonColors segmentedButtonColors8 = segmentedButtonColors2;
                Function2<? super Composer, ? super Integer, Unit> function9 = composableLambdaRememberComposableLambda;
                composer2 = composerStartRestartGroup;
                boolean z10 = z4;
                SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((SemanticsPropertyReceiver) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                        SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                    }
                }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer3, int i17) {
                        ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                        if ((i17 & 3) == 2 && composer3.getSkipping()) {
                            composer3.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                        }
                        SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                function4 = function9;
                segmentedButtonColors3 = segmentedButtonColors8;
                z5 = z10;
                modifier3 = modifier2;
                borderStroke3 = borderStroke2;
                mutableInteractionSource5 = mutableInteractionSource3;
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

                    public final void invoke(Composer composer3, int i17) {
                        SegmentedButtonKt.SegmentedButton(singleChoiceSegmentedButtonRowScope, z, function0, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 196608;
        z3 = z2;
        if ((i & 1572864) != 0) {
            if ((i3 & 32) == 0) {
                i15 = 524288;
            } else {
                i15 = 524288;
            }
            i4 |= i15;
        }
        if ((i & 12582912) != 0) {
            if ((i3 & 64) == 0) {
                i14 = 4194304;
            } else {
                i14 = 4194304;
            }
            i4 |= i14;
        }
        i7 = i3 & Fields.SpotShadowColor;
        if (i7 != 0) {
            i4 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(mutableInteractionSource)) {
                i8 = 67108864;
            } else {
                i8 = 33554432;
            }
            i4 |= i8;
        }
        i9 = i3 & Fields.RotationX;
        if (i9 != 0) {
            i4 |= 805306368;
        } else if ((i & 805306368) == 0) {
            if (composerStartRestartGroup.changedInstance(function2)) {
                i10 = 536870912;
            } else {
                i10 = 268435456;
            }
            i4 |= i10;
        }
        if ((i3 & Fields.RotationY) != 0) {
            i11 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i12 = 4;
            } else {
                i12 = 2;
            }
            i11 = i2 | i12;
        } else {
            i11 = i2;
        }
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
            }
            composerStartRestartGroup.startReplaceGroup(1788214045);
            ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
            if (mutableInteractionSource3 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            composerStartRestartGroup.endReplaceGroup();
            SegmentedButtonColors segmentedButtonColors9 = segmentedButtonColors2;
            Function2<? super Composer, ? super Integer, Unit> function10 = composableLambdaRememberComposableLambda;
            composer2 = composerStartRestartGroup;
            boolean z11 = z4;
            SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                public Object invoke(Object obj) {
                    invoke((SemanticsPropertyReceiver) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                }
            }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i17) {
                    ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                    if ((i17 & 3) == 2 && composer3.getSkipping()) {
                        composer3.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                    }
                    SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function4 = function10;
            segmentedButtonColors3 = segmentedButtonColors9;
            z5 = z11;
            modifier3 = modifier2;
            borderStroke3 = borderStroke2;
            mutableInteractionSource5 = mutableInteractionSource3;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            } else {
                if (i16 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    z3 = true;
                }
                if ((i3 & 32) != 0) {
                    segmentedButtonColorsColors = SegmentedButtonDefaults.INSTANCE.colors(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    segmentedButtonColorsColors = segmentedButtonColors;
                }
                if ((i3 & 64) != 0) {
                    borderStrokeM2766borderStrokel07J4OM$default = SegmentedButtonDefaults.m2766borderStrokel07J4OM$default(SegmentedButtonDefaults.INSTANCE, segmentedButtonColorsColors.m2750borderColorWaAFU9c$material3_release(z3, z), 0.0f, 2, null);
                    i4 &= -29360129;
                } else {
                    borderStrokeM2766borderStrokel07J4OM$default = borderStroke;
                }
                if (i7 != 0) {
                    mutableInteractionSource2 = null;
                } else {
                    mutableInteractionSource2 = mutableInteractionSource;
                }
                if (i9 != 0) {
                    composableLambdaRememberComposableLambda = ComposableLambdaKt.rememberComposableLambda(1235063168, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer3, int i17) {
                            ComposerKt.sourceInformation(composer3, "C215@10495L14:SegmentedButton.kt#uh7d8r");
                            if ((i17 & 3) == 2 && composer3.getSkipping()) {
                                composer3.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1235063168, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:215)");
                            }
                            SegmentedButtonDefaults.INSTANCE.Icon(z, null, null, composer3, 3072, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54);
                    i13 = i4;
                } else {
                    i13 = i4;
                    composableLambdaRememberComposableLambda = function2;
                }
                mutableInteractionSource3 = mutableInteractionSource2;
                modifier2 = companion;
                segmentedButtonColors2 = segmentedButtonColorsColors;
                borderStroke2 = borderStrokeM2766borderStrokel07J4OM$default;
                z4 = z3;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1016574361, i13, i11, "androidx.compose.material3.SegmentedButton (SegmentedButton.kt:217)");
            }
            composerStartRestartGroup.startReplaceGroup(1788214045);
            ComposerKt.sourceInformation(composerStartRestartGroup, "219@10633L39");
            if (mutableInteractionSource3 == null) {
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1788214696, "CC(remember):SegmentedButton.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    objRememberedValue = InteractionSourceKt.MutableInteractionSource();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                mutableInteractionSource4 = (MutableInteractionSource) objRememberedValue;
            } else {
                mutableInteractionSource4 = mutableInteractionSource3;
            }
            composerStartRestartGroup.endReplaceGroup();
            SegmentedButtonColors segmentedButtonColors10 = segmentedButtonColors2;
            Function2<? super Composer, ? super Integer, Unit> function11 = composableLambdaRememberComposableLambda;
            composer2 = composerStartRestartGroup;
            boolean z12 = z4;
            SurfaceKt.m2869Surfaced85dljk(z, function0, SemanticsModifierKt.semantics$default(SizeKt.m1064defaultMinSizeVpY3zN4(interactionZIndex(RowScope.CC.weight$default(singleChoiceSegmentedButtonRowScope, modifier2, 1.0f, false, 2, null), z, interactionCountAsState(mutableInteractionSource4, composerStartRestartGroup, 0)), ButtonDefaults.INSTANCE.m2059getMinWidthD9Ej5fM(), ButtonDefaults.INSTANCE.m2058getMinHeightD9Ej5fM()), false, new Function1<SemanticsPropertyReceiver, Unit>() {
                public Object invoke(Object obj) {
                    invoke((SemanticsPropertyReceiver) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(SemanticsPropertyReceiver semanticsPropertyReceiver) {
                    SemanticsPropertiesKt.m6630setRolekuIjeqM(semanticsPropertyReceiver, Role.INSTANCE.m6615getRadioButtono7Vup1c());
                }
            }, 1, null), z4, shape, segmentedButtonColors2.m2751containerColorWaAFU9c$material3_release(z4, z), segmentedButtonColors2.m2752contentColorWaAFU9c$material3_release(z4, z), 0.0f, 0.0f, borderStroke2, mutableInteractionSource4, ComposableLambdaKt.rememberComposableLambda(383378045, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer3, int i17) {
                    ComposerKt.sourceInformation(composer3, "C243@11499L35:SegmentedButton.kt#uh7d8r");
                    if ((i17 & 3) == 2 && composer3.getSkipping()) {
                        composer3.skipToGroupEnd();
                        return;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(383378045, i17, -1, "androidx.compose.material3.SegmentedButton.<anonymous> (SegmentedButton.kt:243)");
                    }
                    SegmentedButtonKt.SegmentedButtonContent(composableLambdaRememberComposableLambda, function3, composer3, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composer2, ((i13 >> 3) & 126) | ((i13 >> 6) & 7168) | (57344 & (i13 << 3)) | (1879048192 & (i13 << 6)), 48, 384);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            function4 = function11;
            segmentedButtonColors3 = segmentedButtonColors10;
            z5 = z12;
            modifier3 = modifier2;
            borderStroke3 = borderStroke2;
            mutableInteractionSource5 = mutableInteractionSource3;
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

                public final void invoke(Composer composer3, int i17) {
                    SegmentedButtonKt.SegmentedButton(singleChoiceSegmentedButtonRowScope, z, function0, shape, modifier3, z5, segmentedButtonColors3, borderStroke3, mutableInteractionSource5, function4, function3, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    public static final void m2772SingleChoiceSegmentedButtonRowuFdPcIQ(Modifier modifier, float f, final Function3<? super SingleChoiceSegmentedButtonRowScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1520863498);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SingleChoiceSegmentedButtonRow)P(1,2:c#ui.unit.Dp)269@12565L447:SegmentedButton.kt#uh7d8r");
        int i4 = i2 & 1;
        if (i4 != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i5 = i2 & 2;
        if (i5 != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(f) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 147) == 146 && composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.skipToGroupEnd();
        } else {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (i5 != 0) {
                f = SegmentedButtonDefaults.INSTANCE.m2769getBorderWidthD9Ej5fM();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1520863498, i3, -1, "androidx.compose.material3.SingleChoiceSegmentedButtonRow (SegmentedButton.kt:268)");
            }
            Modifier modifierWidth = IntrinsicKt.width(SizeKt.m1065defaultMinSizeVpY3zN4$default(SelectableGroupKt.selectableGroup(modifier), 0.0f, OutlinedSegmentedButtonTokens.INSTANCE.m3721getContainerHeightD9Ej5fM(), 1, null), IntrinsicSize.Min);
            Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(-f));
            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composerStartRestartGroup, 48);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierWidth);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407918630, "C100@5047L9:Row.kt#2w3rfo");
            RowScopeInstance rowScopeInstance = RowScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1586778660, "C278@12924L58,279@12997L9:SegmentedButton.kt#uh7d8r");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1334286565, "CC(remember):SegmentedButton.kt#9igjgp");
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new SingleChoiceSegmentedButtonScopeWrapper(rowScopeInstance);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            function3.invoke((SingleChoiceSegmentedButtonScopeWrapper) objRememberedValue, composerStartRestartGroup, Integer.valueOf(((i3 >> 3) & 112) | 6));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        final Modifier modifier2 = modifier;
        final float f2 = f;
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

                public final void invoke(Composer composer2, int i6) {
                    SegmentedButtonKt.m2772SingleChoiceSegmentedButtonRowuFdPcIQ(modifier2, f2, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void m2771MultiChoiceSegmentedButtonRowuFdPcIQ(Modifier modifier, float f, final Function3<? super MultiChoiceSegmentedButtonRowScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i, final int i2) {
        int i3;
        Composer composerStartRestartGroup = composer.startRestartGroup(155922315);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(MultiChoiceSegmentedButtonRow)P(1,2:c#ui.unit.Dp)307@14058L411:SegmentedButton.kt#uh7d8r");
        int i4 = i2 & 1;
        if (i4 != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i5 = i2 & 2;
        if (i5 != 0) {
            i3 |= 48;
        } else if ((i & 48) == 0) {
            i3 |= composerStartRestartGroup.changed(f) ? 32 : 16;
        }
        if ((i2 & 4) != 0) {
            i3 |= 384;
        } else if ((i & 384) == 0) {
            i3 |= composerStartRestartGroup.changedInstance(function3) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        if ((i3 & 147) == 146 && composerStartRestartGroup.getSkipping()) {
            composerStartRestartGroup.skipToGroupEnd();
        } else {
            if (i4 != 0) {
                modifier = Modifier.INSTANCE;
            }
            if (i5 != 0) {
                f = SegmentedButtonDefaults.INSTANCE.m2769getBorderWidthD9Ej5fM();
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(155922315, i3, -1, "androidx.compose.material3.MultiChoiceSegmentedButtonRow (SegmentedButton.kt:306)");
            }
            Modifier modifierWidth = IntrinsicKt.width(SizeKt.m1065defaultMinSizeVpY3zN4$default(modifier, 0.0f, OutlinedSegmentedButtonTokens.INSTANCE.m3721getContainerHeightD9Ej5fM(), 1, null), IntrinsicSize.Min);
            Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(-f));
            Alignment.Vertical centerVertically = Alignment.INSTANCE.getCenterVertically();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 693286680, "CC(Row)P(2,1,3)98@4939L58,99@5002L130:Row.kt#2w3rfo");
            MeasurePolicy measurePolicyRowMeasurePolicy = RowKt.rowMeasurePolicy(horizontalOrVerticalM911spacedBy0680j_4, centerVertically, composerStartRestartGroup, 48);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierWidth);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyRowMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -407918630, "C100@5047L9:Row.kt#2w3rfo");
            RowScopeInstance rowScopeInstance = RowScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1297400858, "C315@14382L57,316@14454L9:SegmentedButton.kt#uh7d8r");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 596041317, "CC(remember):SegmentedButton.kt#9igjgp");
            Object objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                objRememberedValue = new MultiChoiceSegmentedButtonScopeWrapper(rowScopeInstance);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            function3.invoke((MultiChoiceSegmentedButtonScopeWrapper) objRememberedValue, composerStartRestartGroup, Integer.valueOf(((i3 >> 3) & 112) | 6));
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
        final Modifier modifier2 = modifier;
        final float f2 = f;
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

                public final void invoke(Composer composer2, int i6) {
                    SegmentedButtonKt.m2771MultiChoiceSegmentedButtonRowuFdPcIQ(modifier2, f2, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void SegmentedButtonContent(final Function2<? super Composer, ? super Integer, Unit> function2, final Function2<? super Composer, ? super Integer, Unit> function3, Composer composer, final int i) {
        int i2;
        Composer composerStartRestartGroup = composer.startRestartGroup(1464121570);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(SegmentedButtonContent)P(1)325@14600L595:SegmentedButton.kt#uh7d8r");
        if ((i & 6) == 0) {
            i2 = (composerStartRestartGroup.changedInstance(function2) ? 4 : 2) | i;
        } else {
            i2 = i;
        }
        if ((i & 48) == 0) {
            i2 |= composerStartRestartGroup.changedInstance(function3) ? 32 : 16;
        }
        if ((i2 & 19) != 18 || !composerStartRestartGroup.getSkipping()) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1464121570, i2, -1, "androidx.compose.material3.SegmentedButtonContent (SegmentedButton.kt:324)");
            }
            Alignment center = Alignment.INSTANCE.getCenter();
            Modifier modifierPadding = PaddingKt.padding(Modifier.INSTANCE, ButtonDefaults.INSTANCE.getTextButtonContentPadding());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 733328855, "CC(Box)P(2,1,3)72@3384L130:Box.kt#2w3rfo");
            MeasurePolicy measurePolicyMaybeCachedBoxMeasurePolicy = BoxKt.maybeCachedBoxMeasurePolicy(center, false);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
            int currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, modifierPadding);
            Function0<ComposeUiNode> constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            Composer composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicyMaybeCachedBoxMeasurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -2146769399, "C73@3429L9:Box.kt#2w3rfo");
            BoxScopeInstance boxScopeInstance = BoxScopeInstance.INSTANCE;
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1425737070, "C329@14804L5,330@14847L342,330@14818L371:SegmentedButton.kt#uh7d8r");
            TextKt.ProvideTextStyle(TypographyKt.getValue(OutlinedSegmentedButtonTokens.INSTANCE.getLabelTextFont(), composerStartRestartGroup, 6), ComposableLambdaKt.rememberComposableLambda(1420592651, true, new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i3) {
                    ComposerKt.sourceInformation(composer2, "C331@14873L24,332@14930L55,334@14999L180:SegmentedButton.kt#uh7d8r");
                    if ((i3 & 3) != 2 || !composer2.getSkipping()) {
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1420592651, i3, -1, "androidx.compose.material3.SegmentedButtonContent.<anonymous>.<anonymous> (SegmentedButton.kt:331)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composer2, 773894976, "CC(rememberCoroutineScope)489@20472L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composer2, -954363344, "CC(remember):Effects.kt#9igjgp");
                        Object objRememberedValue = composer2.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composer2));
                            composer2.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerStart(composer2, 1708740237, "CC(remember):SegmentedButton.kt#9igjgp");
                        Object objRememberedValue2 = composer2.rememberedValue();
                        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue2 = new SegmentedButtonContentMeasurePolicy(coroutineScope);
                            composer2.updateRememberedValue(objRememberedValue2);
                        }
                        SegmentedButtonContentMeasurePolicy segmentedButtonContentMeasurePolicy = (SegmentedButtonContentMeasurePolicy) objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        Modifier modifierHeight = IntrinsicKt.height(Modifier.INSTANCE, IntrinsicSize.Min);
                        List listListOf = CollectionsKt.listOf(new Function2[]{function2, function3});
                        ComposerKt.sourceInformationMarkerStart(composer2, 1399185516, "CC(Layout)P(!1,2)173@6976L62,170@6862L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts = LayoutKt.combineAsVirtualLayouts(listListOf);
                        ComposerKt.sourceInformationMarkerStart(composer2, -290761997, "CC(remember):Layout.kt#9igjgp");
                        Object objRememberedValue3 = composer2.rememberedValue();
                        if (objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(segmentedButtonContentMeasurePolicy);
                            composer2.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        ComposerKt.sourceInformationMarkerStart(composer2, -1323940314, "CC(Layout)P(!1,2)78@3182L23,81@3333L411:Layout.kt#80mrfh");
                        int currentCompositeKeyHash2 = ComposablesKt.getCurrentCompositeKeyHash(composer2, 0);
                        CompositionLocalMap currentCompositionLocalMap2 = composer2.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composer2, modifierHeight);
                        Function0<ComposeUiNode> constructor2 = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composer2, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composer2.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composer2.startReusableNode();
                        if (composer2.getInserting()) {
                            composer2.createNode(constructor2);
                        } else {
                            composer2.useNode();
                        }
                        Composer composerM4037constructorimpl2 = Updater.m4037constructorimpl(composer2);
                        Updater.m4044setimpl(composerM4037constructorimpl2, measurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl2, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash2 = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (composerM4037constructorimpl2.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl2.rememberedValue(), Integer.valueOf(currentCompositeKeyHash2))) {
                            composerM4037constructorimpl2.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash2));
                            composerM4037constructorimpl2.apply(Integer.valueOf(currentCompositeKeyHash2), setCompositeKeyHash2);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl2, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts.invoke(composer2, 0);
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
            }, composerStartRestartGroup, 54), composerStartRestartGroup, 48);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
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

                public final void invoke(Composer composer2, int i3) {
                    SegmentedButtonKt.SegmentedButtonContent(function2, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1));
                }
            });
        }
    }

    private static final State<Integer> interactionCountAsState(InteractionSource interactionSource, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 281890131, "C(interactionCountAsState)397@17381L33,398@17440L499,398@17419L520:SegmentedButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(281890131, i, -1, "androidx.compose.material3.interactionCountAsState (SegmentedButton.kt:396)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 408875648, "CC(remember):SegmentedButton.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = SnapshotIntStateKt.mutableIntStateOf(0);
            composer.updateRememberedValue(objRememberedValue);
        }
        MutableIntState mutableIntState = (MutableIntState) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerStart(composer, 408878002, "CC(remember):SegmentedButton.kt#9igjgp");
        int i2 = i & 14;
        boolean z = ((i2 ^ 6) > 4 && composer.changed(interactionSource)) || (i & 6) == 4;
        SegmentedButtonKt$interactionCountAsState$1$1 segmentedButtonKt$interactionCountAsState$1$1RememberedValue = composer.rememberedValue();
        if (z || segmentedButtonKt$interactionCountAsState$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
            segmentedButtonKt$interactionCountAsState$1$1RememberedValue = new SegmentedButtonKt$interactionCountAsState$1$1(interactionSource, mutableIntState, null);
            composer.updateRememberedValue(segmentedButtonKt$interactionCountAsState$1$1RememberedValue);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        EffectsKt.LaunchedEffect(interactionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) segmentedButtonKt$interactionCountAsState$1$1RememberedValue, composer, i2);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return mutableIntState;
    }

    private static final Modifier interactionZIndex(Modifier modifier, final boolean z, final State<Integer> state) {
        return LayoutModifierKt.layout(modifier, new Function3<MeasureScope, Measurable, Constraints, MeasureResult>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return m2773invoke3p2s80s((MeasureScope) obj, (Measurable) obj2, ((Constraints) obj3).unbox-impl());
            }

            public final MeasureResult m2773invoke3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
                int width = placeableMo6026measureBRTryo0.getWidth();
                int height = placeableMo6026measureBRTryo0.getHeight();
                final State<Integer> state2 = state;
                final boolean z2 = z;
                return MeasureScope.CC.layout$default(measureScope, width, height, null, new Function1<Placeable.PlacementScope, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable.PlacementScope) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Placeable.PlacementScope placementScope) {
                        placementScope.place(placeableMo6026measureBRTryo0, 0, 0, state2.getValue().floatValue() + (z2 ? SegmentedButtonKt.CheckedZIndexFactor : 0.0f));
                    }
                }, 4, null);
            }
        });
    }
}
