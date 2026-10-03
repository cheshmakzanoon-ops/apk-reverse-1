package androidx.compose.foundation.lazy.grid;

import androidx.compose.foundation.CheckScrollableContainerConstraintsKt;
import androidx.compose.foundation.ScrollingContainerKt;
import androidx.compose.foundation.gestures.FlingBehavior;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.gestures.ScrollableDefaults;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsInfo;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsModifierLocalKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsState;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsStateKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutMeasureScope;
import androidx.compose.foundation.lazy.layout.LazyLayoutSemanticState;
import androidx.compose.foundation.lazy.layout.LazyLayoutSemanticsKt;
import androidx.compose.foundation.lazy.layout.ObservableScopeInvalidator;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.IntOffsetKt;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.TuplesKt;
import kotlin.Unit;
import kotlin.collections.MapsKt;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000v\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a~\u0010\u0000\u001a\u00020\u00012\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u000b2\b\b\u0002\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u000b2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0017\u0010\u0014\u001a\u0013\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00010\u0015¢\u0006\u0002\b\u0017H\u0001¢\u0006\u0002\u0010\u0018\u001a~\u0010\u0019\u001a\u0019\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u001d0\u001a¢\u0006\u0002\b\u00172\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020 0\u001f2\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\u000b2\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\b\u0010\u0010\u001a\u0004\u0018\u00010\u00112\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$H\u0003¢\u0006\u0002\u0010%¨\u0006&"}, d2 = {"LazyGrid", "", "modifier", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/lazy/grid/LazyGridState;", "slots", "Landroidx/compose/foundation/lazy/grid/LazyGridSlotsProvider;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "reverseLayout", "", "isVertical", "flingBehavior", "Landroidx/compose/foundation/gestures/FlingBehavior;", "userScrollEnabled", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/lazy/grid/LazyGridScope;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/grid/LazyGridState;Landroidx/compose/foundation/lazy/grid/LazyGridSlotsProvider;Landroidx/compose/foundation/layout/PaddingValues;ZZLandroidx/compose/foundation/gestures/FlingBehavior;ZLandroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;III)V", "rememberLazyGridMeasurePolicy", "Lkotlin/Function2;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;", "Landroidx/compose/ui/unit/Constraints;", "Landroidx/compose/ui/layout/MeasureResult;", "itemProviderLambda", "Lkotlin/Function0;", "Landroidx/compose/foundation/lazy/grid/LazyGridItemProvider;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/foundation/lazy/grid/LazyGridState;Landroidx/compose/foundation/lazy/grid/LazyGridSlotsProvider;Landroidx/compose/foundation/layout/PaddingValues;ZZLandroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;Lkotlinx/coroutines/CoroutineScope;Landroidx/compose/ui/graphics/GraphicsContext;Landroidx/compose/runtime/Composer;I)Lkotlin/jvm/functions/Function2;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyGridKt {
    public static final void LazyGrid(Modifier modifier, final LazyGridState lazyGridState, final LazyGridSlotsProvider lazyGridSlotsProvider, PaddingValues paddingValues, boolean z, final boolean z2, FlingBehavior flingBehavior, final boolean z3, final Arrangement.Vertical vertical, final Arrangement.Horizontal horizontal, final Function1<? super LazyGridScope, Unit> function1, Composer composer, final int i, final int i2, final int i3) {
        Modifier modifier2;
        int i4;
        PaddingValues paddingValues2;
        int i5;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        Modifier.Companion companion;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        boolean z4;
        FlingBehavior flingBehavior2;
        int i13;
        Object objRememberedValue;
        Orientation orientation;
        Composer composer2;
        final Modifier modifier3;
        final PaddingValues paddingValues3;
        final FlingBehavior flingBehavior3;
        final boolean z5;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i14;
        Composer composerStartRestartGroup = composer.startRestartGroup(-649686062);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyGrid)P(5,8,7,1,6,4,2,9,10,3)68@3233L15,78@3657L50,80@3733L51,82@3811L24,83@3883L7,84@3915L269,102@4422L278,110@4770L48,113@4981L7,109@4714L376,118@5151L317,98@4277L1324:LazyGrid.kt#7791vq");
        int i15 = i3 & 1;
        if (i15 != 0) {
            i4 = i | 6;
            modifier2 = modifier;
        } else if ((i & 6) == 0) {
            modifier2 = modifier;
            i4 = (composerStartRestartGroup.changed(modifier2) ? 4 : 2) | i;
        } else {
            modifier2 = modifier;
            i4 = i;
        }
        if ((i3 & 2) != 0) {
            i4 |= 48;
        } else if ((i & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(lazyGridState) ? 32 : 16;
        }
        if ((i3 & 4) != 0) {
            i4 |= 384;
        } else if ((i & 384) == 0) {
            i4 |= (i & Fields.RotationY) == 0 ? composerStartRestartGroup.changed(lazyGridSlotsProvider) : composerStartRestartGroup.changedInstance(lazyGridSlotsProvider) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        int i16 = i3 & 8;
        if (i16 == 0) {
            if ((i & 3072) == 0) {
                paddingValues2 = paddingValues;
                i4 |= composerStartRestartGroup.changed(paddingValues2) ? Fields.CameraDistance : Fields.RotationZ;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(z)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i4 |= i6;
                }
                if ((i3 & 32) != 0) {
                    i4 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i7 = Fields.RenderEffect;
                    } else {
                        i7 = 65536;
                    }
                    i4 |= i7;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(flingBehavior)) {
                        i14 = 524288;
                    } else {
                        i14 = 1048576;
                    }
                    i4 |= i14;
                }
                if ((i3 & Fields.SpotShadowColor) != 0) {
                    if ((i & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(z3)) {
                            i8 = 8388608;
                        } else {
                            i8 = 4194304;
                        }
                        i4 |= i8;
                    }
                    if ((i3 & Fields.RotationX) != 0) {
                        if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(vertical)) {
                                i9 = 67108864;
                            } else {
                                i9 = 33554432;
                            }
                            i4 |= i9;
                        }
                        if ((i3 & Fields.RotationY) != 0) {
                            if ((i & 805306368) == 0) {
                                if (composerStartRestartGroup.changed(horizontal)) {
                                    i10 = 536870912;
                                } else {
                                    i10 = 268435456;
                                }
                                i4 |= i10;
                            }
                            if ((i3 & Fields.RotationZ) != 0) {
                                i11 = i2 | 6;
                            } else if ((i2 & 6) == 0) {
                                if (composerStartRestartGroup.changedInstance(function1)) {
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
                                    if (i15 != 0) {
                                        companion = Modifier.INSTANCE;
                                    } else {
                                        companion = modifier2;
                                    }
                                    if (i16 != 0) {
                                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                    } else {
                                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                    }
                                    if (i5 != 0) {
                                        z4 = false;
                                    } else {
                                        z4 = z;
                                    }
                                    if ((i3 & 64) != 0) {
                                        i4 &= -3670017;
                                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    } else {
                                        flingBehavior2 = flingBehavior;
                                    }
                                    i13 = i4;
                                } else {
                                    composerStartRestartGroup.skipToGroupEnd();
                                    if ((i3 & 64) != 0) {
                                        i4 &= -3670017;
                                    }
                                    flingBehavior2 = flingBehavior;
                                    companion = modifier2;
                                    i13 = i4;
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                    z4 = z;
                                }
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                                }
                                int i17 = i13 >> 3;
                                int i18 = i17 & 14;
                                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i18);
                                int i19 = i13 >> 9;
                                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i19 & 112) | i18);
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                                objRememberedValue = composerStartRestartGroup.rememberedValue();
                                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller);
                                    objRememberedValue = compositionScopedCoroutineScopeCanceller;
                                }
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                CoroutineScope coroutineScope = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext = CompositionLocalsKt.getLocalGraphicsContext();
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                                Object objConsume = composerStartRestartGroup.consume(localGraphicsContext);
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                int i20 = i13 & 112;
                                int i21 = i13 & 57344;
                                int i22 = i13;
                                boolean z6 = z4;
                                Modifier modifier4 = companion;
                                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope, (GraphicsContext) objConsume, composerStartRestartGroup, (524272 & i13) | (i19 & 3670016) | (29360128 & i17));
                                if (z2) {
                                    orientation = Orientation.Vertical;
                                } else {
                                    orientation = Orientation.Horizontal;
                                }
                                Orientation orientation2 = orientation;
                                Modifier modifierLazyLayoutSemantics = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier4.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda, lazyLayoutSemanticStateRememberLazyGridSemanticState, orientation2, z3, z6, composerStartRestartGroup, (i19 & 57344) | ((i22 << 3) & 458752));
                                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i18);
                                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release = lazyGridState.getBeyondBoundsInfo();
                                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                                Object objConsume2 = composerStartRestartGroup.consume(localLayoutDirection);
                                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                                composer2 = composerStartRestartGroup;
                                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState, beyondBoundsInfo$foundation_release, z6, (LayoutDirection) objConsume2, orientation2, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i17 & 7168) | (3670016 & i17)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation2, z3, z6, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i20 | ((i22 >> 12) & 7168) | i21 | (458752 & i17), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy, composer2, 0, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                modifier3 = modifier4;
                                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                                flingBehavior3 = flingBehavior2;
                                z5 = z6;
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                z5 = z;
                                modifier3 = modifier2;
                                paddingValues3 = paddingValues2;
                                composer2 = composerStartRestartGroup;
                                flingBehavior3 = flingBehavior;
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
                                        LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                    }
                                });
                            }
                        }
                        i4 |= 805306368;
                        if ((i3 & Fields.RotationZ) != 0) {
                            i11 = i2 | 6;
                        } else if ((i2 & 6) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
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
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i110 = i13 >> 3;
                            int i111 = i110 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda2 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111);
                            int i112 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState2 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i112 & 112) | i111);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller2 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller2);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller2;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope2 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext2 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume3 = composerStartRestartGroup.consume(localGraphicsContext2);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i23 = i13 & 112;
                            int i24 = i13 & 57344;
                            int i25 = i13;
                            boolean z7 = z4;
                            Modifier modifier5 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy2 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda2, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope2, (GraphicsContext) objConsume3, composerStartRestartGroup, (524272 & i13) | (i112 & 3670016) | (29360128 & i110));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation3 = orientation;
                            Modifier modifierLazyLayoutSemantics2 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier5.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda2, lazyLayoutSemanticStateRememberLazyGridSemanticState2, orientation3, z3, z7, composerStartRestartGroup, (i112 & 57344) | ((i25 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState2 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release2 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume4 = composerStartRestartGroup.consume(localLayoutDirection2);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda2, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics2, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState2, beyondBoundsInfo$foundation_release2, z7, (LayoutDirection) objConsume4, orientation3, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i110 & 7168) | (3670016 & i110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation3, z3, z7, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i23 | ((i25 >> 12) & 7168) | i24 | (458752 & i110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy2, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier5;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z7;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i113 = i13 >> 3;
                            int i114 = i113 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda3 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i114);
                            int i115 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState3 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i115 & 112) | i114);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller3 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller3);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller3;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope3 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext3 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume5 = composerStartRestartGroup.consume(localGraphicsContext3);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i26 = i13 & 112;
                            int i27 = i13 & 57344;
                            int i28 = i13;
                            boolean z8 = z4;
                            Modifier modifier6 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy3 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda3, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope3, (GraphicsContext) objConsume5, composerStartRestartGroup, (524272 & i13) | (i115 & 3670016) | (29360128 & i113));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation4 = orientation;
                            Modifier modifierLazyLayoutSemantics3 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier6.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda3, lazyLayoutSemanticStateRememberLazyGridSemanticState3, orientation4, z3, z8, composerStartRestartGroup, (i115 & 57344) | ((i28 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState3 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i114);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release3 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume6 = composerStartRestartGroup.consume(localLayoutDirection3);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda3, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics3, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState3, beyondBoundsInfo$foundation_release3, z8, (LayoutDirection) objConsume6, orientation4, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i113 & 7168) | (3670016 & i113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation4, z3, z8, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i26 | ((i28 >> 12) & 7168) | i27 | (458752 & i113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy3, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier6;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z8;
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

                                public final void invoke(Composer composer3, int i29) {
                                    LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i4 |= 100663296;
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changed(horizontal)) {
                                i10 = 536870912;
                            } else {
                                i10 = 268435456;
                            }
                            i4 |= i10;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            i11 = i2 | 6;
                        } else if ((i2 & 6) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
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
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i116 = i13 >> 3;
                            int i117 = i116 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda4 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i117);
                            int i118 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState4 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i118 & 112) | i117);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller4 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller4);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller4;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope4 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext4 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume7 = composerStartRestartGroup.consume(localGraphicsContext4);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i29 = i13 & 112;
                            int i210 = i13 & 57344;
                            int i211 = i13;
                            boolean z9 = z4;
                            Modifier modifier7 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy4 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda4, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope4, (GraphicsContext) objConsume7, composerStartRestartGroup, (524272 & i13) | (i118 & 3670016) | (29360128 & i116));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation5 = orientation;
                            Modifier modifierLazyLayoutSemantics4 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier7.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda4, lazyLayoutSemanticStateRememberLazyGridSemanticState4, orientation5, z3, z9, composerStartRestartGroup, (i118 & 57344) | ((i211 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState4 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i117);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release4 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume8 = composerStartRestartGroup.consume(localLayoutDirection4);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda4, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics4, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState4, beyondBoundsInfo$foundation_release4, z9, (LayoutDirection) objConsume8, orientation5, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i116 & 7168) | (3670016 & i116)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation5, z3, z9, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i29 | ((i211 >> 12) & 7168) | i210 | (458752 & i116), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy4, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier7;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z9;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i119 = i13 >> 3;
                            int i1110 = i119 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda5 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1110);
                            int i1111 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState5 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111 & 112) | i1110);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller5 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller5);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller5;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope5 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext5 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume9 = composerStartRestartGroup.consume(localGraphicsContext5);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i212 = i13 & 112;
                            int i213 = i13 & 57344;
                            int i214 = i13;
                            boolean z10 = z4;
                            Modifier modifier8 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy5 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda5, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope5, (GraphicsContext) objConsume9, composerStartRestartGroup, (524272 & i13) | (i1111 & 3670016) | (29360128 & i119));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation6 = orientation;
                            Modifier modifierLazyLayoutSemantics5 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier8.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda5, lazyLayoutSemanticStateRememberLazyGridSemanticState5, orientation6, z3, z10, composerStartRestartGroup, (i1111 & 57344) | ((i214 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState5 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1110);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release5 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume10 = composerStartRestartGroup.consume(localLayoutDirection5);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda5, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics5, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState5, beyondBoundsInfo$foundation_release5, z10, (LayoutDirection) objConsume10, orientation6, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i119 & 7168) | (3670016 & i119)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation6, z3, z10, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i212 | ((i214 >> 12) & 7168) | i213 | (458752 & i119), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy5, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier8;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z10;
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

                                public final void invoke(Composer composer3, int i215) {
                                    LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i1112 = i13 >> 3;
                        int i1113 = i1112 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda6 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1113);
                        int i1114 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState6 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1114 & 112) | i1113);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller6 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller6);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller6;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope6 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext6 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11 = composerStartRestartGroup.consume(localGraphicsContext6);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i215 = i13 & 112;
                        int i216 = i13 & 57344;
                        int i217 = i13;
                        boolean z11 = z4;
                        Modifier modifier9 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy6 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda6, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope6, (GraphicsContext) objConsume11, composerStartRestartGroup, (524272 & i13) | (i1114 & 3670016) | (29360128 & i1112));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation7 = orientation;
                        Modifier modifierLazyLayoutSemantics6 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier9.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda6, lazyLayoutSemanticStateRememberLazyGridSemanticState6, orientation7, z3, z11, composerStartRestartGroup, (i1114 & 57344) | ((i217 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState6 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1113);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release6 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume12 = composerStartRestartGroup.consume(localLayoutDirection6);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda6, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics6, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState6, beyondBoundsInfo$foundation_release6, z11, (LayoutDirection) objConsume12, orientation7, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1112 & 7168) | (3670016 & i1112)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation7, z3, z11, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i215 | ((i217 >> 12) & 7168) | i216 | (458752 & i1112), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy6, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier9;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z11;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i1115 = i13 >> 3;
                        int i1116 = i1115 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda7 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1116);
                        int i1117 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState7 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1117 & 112) | i1116);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller7 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller7);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller7;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope7 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext7 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume13 = composerStartRestartGroup.consume(localGraphicsContext7);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i218 = i13 & 112;
                        int i219 = i13 & 57344;
                        int i2110 = i13;
                        boolean z12 = z4;
                        Modifier modifier10 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy7 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda7, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope7, (GraphicsContext) objConsume13, composerStartRestartGroup, (524272 & i13) | (i1117 & 3670016) | (29360128 & i1115));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation8 = orientation;
                        Modifier modifierLazyLayoutSemantics7 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier10.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda7, lazyLayoutSemanticStateRememberLazyGridSemanticState7, orientation8, z3, z12, composerStartRestartGroup, (i1117 & 57344) | ((i2110 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState7 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1116);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release7 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume14 = composerStartRestartGroup.consume(localLayoutDirection7);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda7, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics7, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState7, beyondBoundsInfo$foundation_release7, z12, (LayoutDirection) objConsume14, orientation8, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1115 & 7168) | (3670016 & i1115)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation8, z3, z12, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i218 | ((i2110 >> 12) & 7168) | i219 | (458752 & i1115), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy7, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier10;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z12;
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

                            public final void invoke(Composer composer3, int i2111) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 12582912;
                if ((i3 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(vertical)) {
                            i9 = 67108864;
                        } else {
                            i9 = 33554432;
                        }
                        i4 |= i9;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changed(horizontal)) {
                                i10 = 536870912;
                            } else {
                                i10 = 268435456;
                            }
                            i4 |= i10;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            i11 = i2 | 6;
                        } else if ((i2 & 6) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
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
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i1118 = i13 >> 3;
                            int i1119 = i1118 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda8 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1119);
                            int i11110 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState8 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11110 & 112) | i1119);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller8 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller8);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller8;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope8 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext8 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume15 = composerStartRestartGroup.consume(localGraphicsContext8);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i2111 = i13 & 112;
                            int i2112 = i13 & 57344;
                            int i2113 = i13;
                            boolean z13 = z4;
                            Modifier modifier11 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy8 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda8, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope8, (GraphicsContext) objConsume15, composerStartRestartGroup, (524272 & i13) | (i11110 & 3670016) | (29360128 & i1118));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation9 = orientation;
                            Modifier modifierLazyLayoutSemantics8 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda8, lazyLayoutSemanticStateRememberLazyGridSemanticState8, orientation9, z3, z13, composerStartRestartGroup, (i11110 & 57344) | ((i2113 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState8 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1119);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release8 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection8 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume16 = composerStartRestartGroup.consume(localLayoutDirection8);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda8, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics8, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState8, beyondBoundsInfo$foundation_release8, z13, (LayoutDirection) objConsume16, orientation9, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1118 & 7168) | (3670016 & i1118)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation9, z3, z13, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111 | ((i2113 >> 12) & 7168) | i2112 | (458752 & i1118), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy8, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier11;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z13;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i11111 = i13 >> 3;
                            int i11112 = i11111 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda9 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11112);
                            int i11113 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState9 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11113 & 112) | i11112);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller9 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller9);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller9;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope9 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext9 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume17 = composerStartRestartGroup.consume(localGraphicsContext9);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i2114 = i13 & 112;
                            int i2115 = i13 & 57344;
                            int i2116 = i13;
                            boolean z14 = z4;
                            Modifier modifier12 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy9 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda9, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope9, (GraphicsContext) objConsume17, composerStartRestartGroup, (524272 & i13) | (i11113 & 3670016) | (29360128 & i11111));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation10 = orientation;
                            Modifier modifierLazyLayoutSemantics9 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier12.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda9, lazyLayoutSemanticStateRememberLazyGridSemanticState9, orientation10, z3, z14, composerStartRestartGroup, (i11113 & 57344) | ((i2116 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState9 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11112);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release9 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection9 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume18 = composerStartRestartGroup.consume(localLayoutDirection9);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda9, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics9, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState9, beyondBoundsInfo$foundation_release9, z14, (LayoutDirection) objConsume18, orientation10, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111 & 7168) | (3670016 & i11111)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation10, z3, z14, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2114 | ((i2116 >> 12) & 7168) | i2115 | (458752 & i11111), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy9, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier12;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z14;
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

                                public final void invoke(Composer composer3, int i2117) {
                                    LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11114 = i13 >> 3;
                        int i11115 = i11114 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda10 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11115);
                        int i11116 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState10 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11116 & 112) | i11115);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller10 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller10);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller10;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope10 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext10 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume19 = composerStartRestartGroup.consume(localGraphicsContext10);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2117 = i13 & 112;
                        int i2118 = i13 & 57344;
                        int i2119 = i13;
                        boolean z15 = z4;
                        Modifier modifier13 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy10 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda10, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope10, (GraphicsContext) objConsume19, composerStartRestartGroup, (524272 & i13) | (i11116 & 3670016) | (29360128 & i11114));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation11 = orientation;
                        Modifier modifierLazyLayoutSemantics10 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier13.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda10, lazyLayoutSemanticStateRememberLazyGridSemanticState10, orientation11, z3, z15, composerStartRestartGroup, (i11116 & 57344) | ((i2119 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState10 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11115);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release10 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection10 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume110 = composerStartRestartGroup.consume(localLayoutDirection10);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda10, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics10, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState10, beyondBoundsInfo$foundation_release10, z15, (LayoutDirection) objConsume110, orientation11, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11114 & 7168) | (3670016 & i11114)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11, z3, z15, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2117 | ((i2119 >> 12) & 7168) | i2118 | (458752 & i11114), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy10, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier13;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z15;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11117 = i13 >> 3;
                        int i11118 = i11117 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11118);
                        int i11119 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11119 & 112) | i11118);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller11;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope11 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume111 = composerStartRestartGroup.consume(localGraphicsContext11);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21110 = i13 & 112;
                        int i21111 = i13 & 57344;
                        int i21112 = i13;
                        boolean z16 = z4;
                        Modifier modifier14 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11, (GraphicsContext) objConsume111, composerStartRestartGroup, (524272 & i13) | (i11119 & 3670016) | (29360128 & i11117));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation12 = orientation;
                        Modifier modifierLazyLayoutSemantics11 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier14.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11, lazyLayoutSemanticStateRememberLazyGridSemanticState11, orientation12, z3, z16, composerStartRestartGroup, (i11119 & 57344) | ((i21112 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11118);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume112 = composerStartRestartGroup.consume(localLayoutDirection11);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11, beyondBoundsInfo$foundation_release11, z16, (LayoutDirection) objConsume112, orientation12, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11117 & 7168) | (3670016 & i11117)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation12, z3, z16, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21110 | ((i21112 >> 12) & 7168) | i21111 | (458752 & i11117), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier14;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z16;
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

                            public final void invoke(Composer composer3, int i21113) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 100663296;
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i111110 = i13 >> 3;
                        int i111111 = i111110 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda12 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111);
                        int i111112 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState12 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111112 & 112) | i111111);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller12 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller12);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller12;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope12 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext12 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume113 = composerStartRestartGroup.consume(localGraphicsContext12);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21113 = i13 & 112;
                        int i21114 = i13 & 57344;
                        int i21115 = i13;
                        boolean z17 = z4;
                        Modifier modifier15 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy12 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda12, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope12, (GraphicsContext) objConsume113, composerStartRestartGroup, (524272 & i13) | (i111112 & 3670016) | (29360128 & i111110));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation13 = orientation;
                        Modifier modifierLazyLayoutSemantics12 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier15.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda12, lazyLayoutSemanticStateRememberLazyGridSemanticState12, orientation13, z3, z17, composerStartRestartGroup, (i111112 & 57344) | ((i21115 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState12 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release12 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection12 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume114 = composerStartRestartGroup.consume(localLayoutDirection12);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda12, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics12, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState12, beyondBoundsInfo$foundation_release12, z17, (LayoutDirection) objConsume114, orientation13, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111110 & 7168) | (3670016 & i111110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation13, z3, z17, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21113 | ((i21115 >> 12) & 7168) | i21114 | (458752 & i111110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy12, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier15;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z17;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i111113 = i13 >> 3;
                        int i111114 = i111113 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda13 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111114);
                        int i111115 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState13 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111115 & 112) | i111114);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller13 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller13);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller13;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope13 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext13 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume115 = composerStartRestartGroup.consume(localGraphicsContext13);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21116 = i13 & 112;
                        int i21117 = i13 & 57344;
                        int i21118 = i13;
                        boolean z18 = z4;
                        Modifier modifier16 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy13 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda13, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope13, (GraphicsContext) objConsume115, composerStartRestartGroup, (524272 & i13) | (i111115 & 3670016) | (29360128 & i111113));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation14 = orientation;
                        Modifier modifierLazyLayoutSemantics13 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier16.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda13, lazyLayoutSemanticStateRememberLazyGridSemanticState13, orientation14, z3, z18, composerStartRestartGroup, (i111115 & 57344) | ((i21118 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState13 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111114);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release13 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection13 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume116 = composerStartRestartGroup.consume(localLayoutDirection13);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda13, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics13, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState13, beyondBoundsInfo$foundation_release13, z18, (LayoutDirection) objConsume116, orientation14, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111113 & 7168) | (3670016 & i111113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation14, z3, z18, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21116 | ((i21118 >> 12) & 7168) | i21117 | (458752 & i111113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy13, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier16;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z18;
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

                            public final void invoke(Composer composer3, int i21119) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111116 = i13 >> 3;
                    int i111117 = i111116 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda14 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111117);
                    int i111118 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState14 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111118 & 112) | i111117);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller14 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller14);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller14;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope14 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext14 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume117 = composerStartRestartGroup.consume(localGraphicsContext14);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21119 = i13 & 112;
                    int i211110 = i13 & 57344;
                    int i211111 = i13;
                    boolean z19 = z4;
                    Modifier modifier17 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy14 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda14, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope14, (GraphicsContext) objConsume117, composerStartRestartGroup, (524272 & i13) | (i111118 & 3670016) | (29360128 & i111116));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation15 = orientation;
                    Modifier modifierLazyLayoutSemantics14 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier17.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda14, lazyLayoutSemanticStateRememberLazyGridSemanticState14, orientation15, z3, z19, composerStartRestartGroup, (i111118 & 57344) | ((i211111 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState14 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111117);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release14 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection14 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume118 = composerStartRestartGroup.consume(localLayoutDirection14);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda14, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics14, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState14, beyondBoundsInfo$foundation_release14, z19, (LayoutDirection) objConsume118, orientation15, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111116 & 7168) | (3670016 & i111116)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation15, z3, z19, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21119 | ((i211111 >> 12) & 7168) | i211110 | (458752 & i111116), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy14, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier17;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z19;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111119 = i13 >> 3;
                    int i1111110 = i111119 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda15 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111110);
                    int i1111111 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState15 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111 & 112) | i1111110);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller15 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller15);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller15;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope15 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext15 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume119 = composerStartRestartGroup.consume(localGraphicsContext15);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211112 = i13 & 112;
                    int i211113 = i13 & 57344;
                    int i211114 = i13;
                    boolean z110 = z4;
                    Modifier modifier18 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy15 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda15, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope15, (GraphicsContext) objConsume119, composerStartRestartGroup, (524272 & i13) | (i1111111 & 3670016) | (29360128 & i111119));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation16 = orientation;
                    Modifier modifierLazyLayoutSemantics15 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier18.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda15, lazyLayoutSemanticStateRememberLazyGridSemanticState15, orientation16, z3, z110, composerStartRestartGroup, (i1111111 & 57344) | ((i211114 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState15 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111110);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release15 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection15 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1110 = composerStartRestartGroup.consume(localLayoutDirection15);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda15, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics15, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState15, beyondBoundsInfo$foundation_release15, z110, (LayoutDirection) objConsume1110, orientation16, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111119 & 7168) | (3670016 & i111119)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation16, z3, z110, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211112 | ((i211114 >> 12) & 7168) | i211113 | (458752 & i111119), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy15, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier18;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z110;
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

                        public final void invoke(Composer composer3, int i211115) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i4 |= i7;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i14 = 524288;
                } else {
                    i14 = 524288;
                }
                i4 |= i14;
            }
            if ((i3 & Fields.SpotShadowColor) != 0) {
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i8 = 8388608;
                    } else {
                        i8 = 4194304;
                    }
                    i4 |= i8;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(vertical)) {
                            i9 = 67108864;
                        } else {
                            i9 = 33554432;
                        }
                        i4 |= i9;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changed(horizontal)) {
                                i10 = 536870912;
                            } else {
                                i10 = 268435456;
                            }
                            i4 |= i10;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            i11 = i2 | 6;
                        } else if ((i2 & 6) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
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
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i1111112 = i13 >> 3;
                            int i1111113 = i1111112 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda16 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111113);
                            int i1111114 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState16 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111114 & 112) | i1111113);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller16 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller16);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller16;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope16 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext16 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1111 = composerStartRestartGroup.consume(localGraphicsContext16);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i211115 = i13 & 112;
                            int i211116 = i13 & 57344;
                            int i211117 = i13;
                            boolean z111 = z4;
                            Modifier modifier19 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy16 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda16, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope16, (GraphicsContext) objConsume1111, composerStartRestartGroup, (524272 & i13) | (i1111114 & 3670016) | (29360128 & i1111112));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation17 = orientation;
                            Modifier modifierLazyLayoutSemantics16 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier19.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda16, lazyLayoutSemanticStateRememberLazyGridSemanticState16, orientation17, z3, z111, composerStartRestartGroup, (i1111114 & 57344) | ((i211117 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState16 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111113);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release16 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection16 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1112 = composerStartRestartGroup.consume(localLayoutDirection16);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda16, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics16, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState16, beyondBoundsInfo$foundation_release16, z111, (LayoutDirection) objConsume1112, orientation17, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111112 & 7168) | (3670016 & i1111112)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation17, z3, z111, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211115 | ((i211117 >> 12) & 7168) | i211116 | (458752 & i1111112), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy16, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier19;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z111;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i1111115 = i13 >> 3;
                            int i1111116 = i1111115 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda17 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111116);
                            int i1111117 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState17 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111117 & 112) | i1111116);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller17 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller17);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller17;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope17 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext17 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1113 = composerStartRestartGroup.consume(localGraphicsContext17);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i211118 = i13 & 112;
                            int i211119 = i13 & 57344;
                            int i2111110 = i13;
                            boolean z112 = z4;
                            Modifier modifier110 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy17 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda17, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope17, (GraphicsContext) objConsume1113, composerStartRestartGroup, (524272 & i13) | (i1111117 & 3670016) | (29360128 & i1111115));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation18 = orientation;
                            Modifier modifierLazyLayoutSemantics17 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier110.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda17, lazyLayoutSemanticStateRememberLazyGridSemanticState17, orientation18, z3, z112, composerStartRestartGroup, (i1111117 & 57344) | ((i2111110 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState17 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111116);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release17 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection17 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1114 = composerStartRestartGroup.consume(localLayoutDirection17);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda17, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics17, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState17, beyondBoundsInfo$foundation_release17, z112, (LayoutDirection) objConsume1114, orientation18, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111115 & 7168) | (3670016 & i1111115)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation18, z3, z112, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211118 | ((i2111110 >> 12) & 7168) | i211119 | (458752 & i1111115), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy17, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier110;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z112;
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

                                public final void invoke(Composer composer3, int i2111111) {
                                    LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i1111118 = i13 >> 3;
                        int i1111119 = i1111118 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda18 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111119);
                        int i11111110 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState18 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111110 & 112) | i1111119);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller18 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller18);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller18;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope18 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext18 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1115 = composerStartRestartGroup.consume(localGraphicsContext18);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111111 = i13 & 112;
                        int i2111112 = i13 & 57344;
                        int i2111113 = i13;
                        boolean z113 = z4;
                        Modifier modifier111 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy18 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda18, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope18, (GraphicsContext) objConsume1115, composerStartRestartGroup, (524272 & i13) | (i11111110 & 3670016) | (29360128 & i1111118));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation19 = orientation;
                        Modifier modifierLazyLayoutSemantics18 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda18, lazyLayoutSemanticStateRememberLazyGridSemanticState18, orientation19, z3, z113, composerStartRestartGroup, (i11111110 & 57344) | ((i2111113 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState18 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111119);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release18 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection18 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1116 = composerStartRestartGroup.consume(localLayoutDirection18);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda18, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics18, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState18, beyondBoundsInfo$foundation_release18, z113, (LayoutDirection) objConsume1116, orientation19, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111118 & 7168) | (3670016 & i1111118)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation19, z3, z113, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111 | ((i2111113 >> 12) & 7168) | i2111112 | (458752 & i1111118), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy18, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier111;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z113;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11111111 = i13 >> 3;
                        int i11111112 = i11111111 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda19 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111112);
                        int i11111113 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState19 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111113 & 112) | i11111112);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller19 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller19);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller19;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope19 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext19 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1117 = composerStartRestartGroup.consume(localGraphicsContext19);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111114 = i13 & 112;
                        int i2111115 = i13 & 57344;
                        int i2111116 = i13;
                        boolean z114 = z4;
                        Modifier modifier112 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy19 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda19, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope19, (GraphicsContext) objConsume1117, composerStartRestartGroup, (524272 & i13) | (i11111113 & 3670016) | (29360128 & i11111111));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation110 = orientation;
                        Modifier modifierLazyLayoutSemantics19 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier112.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda19, lazyLayoutSemanticStateRememberLazyGridSemanticState19, orientation110, z3, z114, composerStartRestartGroup, (i11111113 & 57344) | ((i2111116 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState19 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111112);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release19 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection19 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1118 = composerStartRestartGroup.consume(localLayoutDirection19);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda19, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics19, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState19, beyondBoundsInfo$foundation_release19, z114, (LayoutDirection) objConsume1118, orientation110, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111 & 7168) | (3670016 & i11111111)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation110, z3, z114, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111114 | ((i2111116 >> 12) & 7168) | i2111115 | (458752 & i11111111), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy19, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier112;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z114;
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

                            public final void invoke(Composer composer3, int i2111117) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 100663296;
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11111114 = i13 >> 3;
                        int i11111115 = i11111114 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda110 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111115);
                        int i11111116 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState110 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111116 & 112) | i11111115);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller110);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller110;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope110 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext110 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1119 = composerStartRestartGroup.consume(localGraphicsContext110);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111117 = i13 & 112;
                        int i2111118 = i13 & 57344;
                        int i2111119 = i13;
                        boolean z115 = z4;
                        Modifier modifier113 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy110 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda110, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope110, (GraphicsContext) objConsume1119, composerStartRestartGroup, (524272 & i13) | (i11111116 & 3670016) | (29360128 & i11111114));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation111 = orientation;
                        Modifier modifierLazyLayoutSemantics110 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier113.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda110, lazyLayoutSemanticStateRememberLazyGridSemanticState110, orientation111, z3, z115, composerStartRestartGroup, (i11111116 & 57344) | ((i2111119 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState110 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111115);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release110 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection110 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11110 = composerStartRestartGroup.consume(localLayoutDirection110);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda110, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics110, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState110, beyondBoundsInfo$foundation_release110, z115, (LayoutDirection) objConsume11110, orientation111, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111114 & 7168) | (3670016 & i11111114)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111, z3, z115, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111117 | ((i2111119 >> 12) & 7168) | i2111118 | (458752 & i11111114), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy110, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier113;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z115;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11111117 = i13 >> 3;
                        int i11111118 = i11111117 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111118);
                        int i11111119 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111119 & 112) | i11111118);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller111;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope111 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111 = composerStartRestartGroup.consume(localGraphicsContext111);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21111110 = i13 & 112;
                        int i21111111 = i13 & 57344;
                        int i21111112 = i13;
                        boolean z116 = z4;
                        Modifier modifier114 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111, (GraphicsContext) objConsume11111, composerStartRestartGroup, (524272 & i13) | (i11111119 & 3670016) | (29360128 & i11111117));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation112 = orientation;
                        Modifier modifierLazyLayoutSemantics111 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier114.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111, lazyLayoutSemanticStateRememberLazyGridSemanticState111, orientation112, z3, z116, composerStartRestartGroup, (i11111119 & 57344) | ((i21111112 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111118);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11112 = composerStartRestartGroup.consume(localLayoutDirection111);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111, beyondBoundsInfo$foundation_release111, z116, (LayoutDirection) objConsume11112, orientation112, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111117 & 7168) | (3670016 & i11111117)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation112, z3, z116, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111110 | ((i21111112 >> 12) & 7168) | i21111111 | (458752 & i11111117), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier114;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z116;
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

                            public final void invoke(Composer composer3, int i21111113) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111110 = i13 >> 3;
                    int i111111111 = i111111110 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda112 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111);
                    int i111111112 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState112 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111112 & 112) | i111111111);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller112 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller112);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller112;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope112 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext112 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11113 = composerStartRestartGroup.consume(localGraphicsContext112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111113 = i13 & 112;
                    int i21111114 = i13 & 57344;
                    int i21111115 = i13;
                    boolean z117 = z4;
                    Modifier modifier115 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy112 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda112, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope112, (GraphicsContext) objConsume11113, composerStartRestartGroup, (524272 & i13) | (i111111112 & 3670016) | (29360128 & i111111110));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation113 = orientation;
                    Modifier modifierLazyLayoutSemantics112 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier115.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda112, lazyLayoutSemanticStateRememberLazyGridSemanticState112, orientation113, z3, z117, composerStartRestartGroup, (i111111112 & 57344) | ((i21111115 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState112 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release112 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection112 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11114 = composerStartRestartGroup.consume(localLayoutDirection112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda112, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics112, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState112, beyondBoundsInfo$foundation_release112, z117, (LayoutDirection) objConsume11114, orientation113, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111110 & 7168) | (3670016 & i111111110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation113, z3, z117, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111113 | ((i21111115 >> 12) & 7168) | i21111114 | (458752 & i111111110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy112, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier115;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z117;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111113 = i13 >> 3;
                    int i111111114 = i111111113 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda113 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111114);
                    int i111111115 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState113 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111115 & 112) | i111111114);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller113 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller113);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller113;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope113 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext113 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11115 = composerStartRestartGroup.consume(localGraphicsContext113);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111116 = i13 & 112;
                    int i21111117 = i13 & 57344;
                    int i21111118 = i13;
                    boolean z118 = z4;
                    Modifier modifier116 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy113 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda113, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope113, (GraphicsContext) objConsume11115, composerStartRestartGroup, (524272 & i13) | (i111111115 & 3670016) | (29360128 & i111111113));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation114 = orientation;
                    Modifier modifierLazyLayoutSemantics113 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier116.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda113, lazyLayoutSemanticStateRememberLazyGridSemanticState113, orientation114, z3, z118, composerStartRestartGroup, (i111111115 & 57344) | ((i21111118 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState113 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111114);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release113 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection113 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11116 = composerStartRestartGroup.consume(localLayoutDirection113);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda113, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics113, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState113, beyondBoundsInfo$foundation_release113, z118, (LayoutDirection) objConsume11116, orientation114, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111113 & 7168) | (3670016 & i111111113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation114, z3, z118, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111116 | ((i21111118 >> 12) & 7168) | i21111117 | (458752 & i111111113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy113, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier116;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z118;
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

                        public final void invoke(Composer composer3, int i21111119) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 12582912;
            if ((i3 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(vertical)) {
                        i9 = 67108864;
                    } else {
                        i9 = 33554432;
                    }
                    i4 |= i9;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i111111116 = i13 >> 3;
                        int i111111117 = i111111116 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda114 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111117);
                        int i111111118 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState114 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111118 & 112) | i111111117);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller114 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller114);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller114;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope114 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext114 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11117 = composerStartRestartGroup.consume(localGraphicsContext114);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21111119 = i13 & 112;
                        int i211111110 = i13 & 57344;
                        int i211111111 = i13;
                        boolean z119 = z4;
                        Modifier modifier117 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy114 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda114, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope114, (GraphicsContext) objConsume11117, composerStartRestartGroup, (524272 & i13) | (i111111118 & 3670016) | (29360128 & i111111116));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation115 = orientation;
                        Modifier modifierLazyLayoutSemantics114 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier117.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda114, lazyLayoutSemanticStateRememberLazyGridSemanticState114, orientation115, z3, z119, composerStartRestartGroup, (i111111118 & 57344) | ((i211111111 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState114 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111117);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release114 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection114 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11118 = composerStartRestartGroup.consume(localLayoutDirection114);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda114, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics114, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState114, beyondBoundsInfo$foundation_release114, z119, (LayoutDirection) objConsume11118, orientation115, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111116 & 7168) | (3670016 & i111111116)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation115, z3, z119, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111119 | ((i211111111 >> 12) & 7168) | i211111110 | (458752 & i111111116), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy114, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier117;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z119;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i111111119 = i13 >> 3;
                        int i1111111110 = i111111119 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda115 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111110);
                        int i1111111111 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState115 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111 & 112) | i1111111110);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller115 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller115);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller115;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope115 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext115 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11119 = composerStartRestartGroup.consume(localGraphicsContext115);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i211111112 = i13 & 112;
                        int i211111113 = i13 & 57344;
                        int i211111114 = i13;
                        boolean z1110 = z4;
                        Modifier modifier118 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy115 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda115, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope115, (GraphicsContext) objConsume11119, composerStartRestartGroup, (524272 & i13) | (i1111111111 & 3670016) | (29360128 & i111111119));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation116 = orientation;
                        Modifier modifierLazyLayoutSemantics115 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier118.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda115, lazyLayoutSemanticStateRememberLazyGridSemanticState115, orientation116, z3, z1110, composerStartRestartGroup, (i1111111111 & 57344) | ((i211111114 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState115 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111110);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release115 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection115 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume111110 = composerStartRestartGroup.consume(localLayoutDirection115);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda115, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics115, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState115, beyondBoundsInfo$foundation_release115, z1110, (LayoutDirection) objConsume111110, orientation116, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111119 & 7168) | (3670016 & i111111119)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation116, z3, z1110, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111112 | ((i211111114 >> 12) & 7168) | i211111113 | (458752 & i111111119), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy115, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier118;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z1110;
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

                            public final void invoke(Composer composer3, int i211111115) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i1111111112 = i13 >> 3;
                    int i1111111113 = i1111111112 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda116 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111113);
                    int i1111111114 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState116 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111114 & 112) | i1111111113);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller116 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller116);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller116;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope116 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext116 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111 = composerStartRestartGroup.consume(localGraphicsContext116);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211111115 = i13 & 112;
                    int i211111116 = i13 & 57344;
                    int i211111117 = i13;
                    boolean z1111 = z4;
                    Modifier modifier119 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy116 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda116, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope116, (GraphicsContext) objConsume111111, composerStartRestartGroup, (524272 & i13) | (i1111111114 & 3670016) | (29360128 & i1111111112));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation117 = orientation;
                    Modifier modifierLazyLayoutSemantics116 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier119.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda116, lazyLayoutSemanticStateRememberLazyGridSemanticState116, orientation117, z3, z1111, composerStartRestartGroup, (i1111111114 & 57344) | ((i211111117 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState116 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111113);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release116 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection116 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111112 = composerStartRestartGroup.consume(localLayoutDirection116);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda116, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics116, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState116, beyondBoundsInfo$foundation_release116, z1111, (LayoutDirection) objConsume111112, orientation117, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111112 & 7168) | (3670016 & i1111111112)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation117, z3, z1111, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111115 | ((i211111117 >> 12) & 7168) | i211111116 | (458752 & i1111111112), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy116, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier119;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z1111;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i1111111115 = i13 >> 3;
                    int i1111111116 = i1111111115 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda117 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111116);
                    int i1111111117 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState117 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111117 & 112) | i1111111116);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller117 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller117);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller117;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope117 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext117 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111113 = composerStartRestartGroup.consume(localGraphicsContext117);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211111118 = i13 & 112;
                    int i211111119 = i13 & 57344;
                    int i2111111110 = i13;
                    boolean z1112 = z4;
                    Modifier modifier1110 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy117 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda117, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope117, (GraphicsContext) objConsume111113, composerStartRestartGroup, (524272 & i13) | (i1111111117 & 3670016) | (29360128 & i1111111115));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation118 = orientation;
                    Modifier modifierLazyLayoutSemantics117 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1110.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda117, lazyLayoutSemanticStateRememberLazyGridSemanticState117, orientation118, z3, z1112, composerStartRestartGroup, (i1111111117 & 57344) | ((i2111111110 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState117 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111116);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release117 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection117 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111114 = composerStartRestartGroup.consume(localLayoutDirection117);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda117, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics117, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState117, beyondBoundsInfo$foundation_release117, z1112, (LayoutDirection) objConsume111114, orientation118, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111115 & 7168) | (3670016 & i1111111115)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation118, z3, z1112, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111118 | ((i2111111110 >> 12) & 7168) | i211111119 | (458752 & i1111111115), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy117, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier1110;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z1112;
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

                        public final void invoke(Composer composer3, int i2111111111) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 100663296;
            if ((i3 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i1111111118 = i13 >> 3;
                    int i1111111119 = i1111111118 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda118 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111119);
                    int i11111111110 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState118 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111110 & 112) | i1111111119);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller118 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller118);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller118;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope118 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext118 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111115 = composerStartRestartGroup.consume(localGraphicsContext118);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2111111111 = i13 & 112;
                    int i2111111112 = i13 & 57344;
                    int i2111111113 = i13;
                    boolean z1113 = z4;
                    Modifier modifier1111 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy118 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda118, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope118, (GraphicsContext) objConsume111115, composerStartRestartGroup, (524272 & i13) | (i11111111110 & 3670016) | (29360128 & i1111111118));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation119 = orientation;
                    Modifier modifierLazyLayoutSemantics118 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda118, lazyLayoutSemanticStateRememberLazyGridSemanticState118, orientation119, z3, z1113, composerStartRestartGroup, (i11111111110 & 57344) | ((i2111111113 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState118 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111119);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release118 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection118 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111116 = composerStartRestartGroup.consume(localLayoutDirection118);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda118, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics118, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState118, beyondBoundsInfo$foundation_release118, z1113, (LayoutDirection) objConsume111116, orientation119, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111118 & 7168) | (3670016 & i1111111118)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation119, z3, z1113, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111 | ((i2111111113 >> 12) & 7168) | i2111111112 | (458752 & i1111111118), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy118, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier1111;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z1113;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i11111111111 = i13 >> 3;
                    int i11111111112 = i11111111111 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda119 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111112);
                    int i11111111113 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState119 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111113 & 112) | i11111111112);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller119 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller119);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller119;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope119 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext119 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111117 = composerStartRestartGroup.consume(localGraphicsContext119);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2111111114 = i13 & 112;
                    int i2111111115 = i13 & 57344;
                    int i2111111116 = i13;
                    boolean z1114 = z4;
                    Modifier modifier1112 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy119 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda119, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope119, (GraphicsContext) objConsume111117, composerStartRestartGroup, (524272 & i13) | (i11111111113 & 3670016) | (29360128 & i11111111111));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation1110 = orientation;
                    Modifier modifierLazyLayoutSemantics119 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1112.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda119, lazyLayoutSemanticStateRememberLazyGridSemanticState119, orientation1110, z3, z1114, composerStartRestartGroup, (i11111111113 & 57344) | ((i2111111116 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState119 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111112);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release119 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection119 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111118 = composerStartRestartGroup.consume(localLayoutDirection119);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda119, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics119, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState119, beyondBoundsInfo$foundation_release119, z1114, (LayoutDirection) objConsume111118, orientation1110, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111 & 7168) | (3670016 & i11111111111)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1110, z3, z1114, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111114 | ((i2111111116 >> 12) & 7168) | i2111111115 | (458752 & i11111111111), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy119, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier1112;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z1114;
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

                        public final void invoke(Composer composer3, int i2111111117) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i3 & Fields.RotationZ) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
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
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i11111111114 = i13 >> 3;
                int i11111111115 = i11111111114 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1110 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111115);
                int i11111111116 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1110 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111116 & 112) | i11111111115);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1110);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller1110;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope1110 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1110 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111119 = composerStartRestartGroup.consume(localGraphicsContext1110);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111111117 = i13 & 112;
                int i2111111118 = i13 & 57344;
                int i2111111119 = i13;
                boolean z1115 = z4;
                Modifier modifier1113 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1110 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1110, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1110, (GraphicsContext) objConsume111119, composerStartRestartGroup, (524272 & i13) | (i11111111116 & 3670016) | (29360128 & i11111111114));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation1111 = orientation;
                Modifier modifierLazyLayoutSemantics1110 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1113.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1110, lazyLayoutSemanticStateRememberLazyGridSemanticState1110, orientation1111, z3, z1115, composerStartRestartGroup, (i11111111116 & 57344) | ((i2111111119 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1110 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111115);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1110 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1110 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111110 = composerStartRestartGroup.consume(localLayoutDirection1110);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1110, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1110, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1110, beyondBoundsInfo$foundation_release1110, z1115, (LayoutDirection) objConsume1111110, orientation1111, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111114 & 7168) | (3670016 & i11111111114)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1111, z3, z1115, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111117 | ((i2111111119 >> 12) & 7168) | i2111111118 | (458752 & i11111111114), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1110, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier1113;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1115;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i11111111117 = i13 >> 3;
                int i11111111118 = i11111111117 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1111 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111118);
                int i11111111119 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1111 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111119 & 112) | i11111111118);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1111);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller1111;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope1111 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1111 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111 = composerStartRestartGroup.consume(localGraphicsContext1111);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21111111110 = i13 & 112;
                int i21111111111 = i13 & 57344;
                int i21111111112 = i13;
                boolean z1116 = z4;
                Modifier modifier1114 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1111 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1111, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1111, (GraphicsContext) objConsume1111111, composerStartRestartGroup, (524272 & i13) | (i11111111119 & 3670016) | (29360128 & i11111111117));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation1112 = orientation;
                Modifier modifierLazyLayoutSemantics1111 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1114.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1111, lazyLayoutSemanticStateRememberLazyGridSemanticState1111, orientation1112, z3, z1116, composerStartRestartGroup, (i11111111119 & 57344) | ((i21111111112 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111118);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1111 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1111 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111112 = composerStartRestartGroup.consume(localLayoutDirection1111);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1111, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1111, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111, beyondBoundsInfo$foundation_release1111, z1116, (LayoutDirection) objConsume1111112, orientation1112, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111117 & 7168) | (3670016 & i11111111117)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1112, z3, z1116, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111110 | ((i21111111112 >> 12) & 7168) | i21111111111 | (458752 & i11111111117), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1111, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier1114;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1116;
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

                    public final void invoke(Composer composer3, int i21111111113) {
                        LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        paddingValues2 = paddingValues;
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i4 |= i6;
            }
            if ((i3 & 32) != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i7 = Fields.RenderEffect;
                } else {
                    i7 = 65536;
                }
                i4 |= i7;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i14 = 524288;
                } else {
                    i14 = 524288;
                }
                i4 |= i14;
            }
            if ((i3 & Fields.SpotShadowColor) != 0) {
                if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i8 = 8388608;
                    } else {
                        i8 = 4194304;
                    }
                    i4 |= i8;
                }
                if ((i3 & Fields.RotationX) != 0) {
                    if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(vertical)) {
                            i9 = 67108864;
                        } else {
                            i9 = 33554432;
                        }
                        i4 |= i9;
                    }
                    if ((i3 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changed(horizontal)) {
                                i10 = 536870912;
                            } else {
                                i10 = 268435456;
                            }
                            i4 |= i10;
                        }
                        if ((i3 & Fields.RotationZ) != 0) {
                            i11 = i2 | 6;
                        } else if ((i2 & 6) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
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
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i111111111110 = i13 >> 3;
                            int i111111111111 = i111111111110 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1112 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111);
                            int i111111111112 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1112 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111112 & 112) | i111111111111);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1112 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1112);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller1112;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope1112 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1112 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1111113 = composerStartRestartGroup.consume(localGraphicsContext1112);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i21111111113 = i13 & 112;
                            int i21111111114 = i13 & 57344;
                            int i21111111115 = i13;
                            boolean z1117 = z4;
                            Modifier modifier1115 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1112 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1112, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1112, (GraphicsContext) objConsume1111113, composerStartRestartGroup, (524272 & i13) | (i111111111112 & 3670016) | (29360128 & i111111111110));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation1113 = orientation;
                            Modifier modifierLazyLayoutSemantics1112 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1115.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1112, lazyLayoutSemanticStateRememberLazyGridSemanticState1112, orientation1113, z3, z1117, composerStartRestartGroup, (i111111111112 & 57344) | ((i21111111115 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1112 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1112 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1112 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1111114 = composerStartRestartGroup.consume(localLayoutDirection1112);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1112, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1112, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1112, beyondBoundsInfo$foundation_release1112, z1117, (LayoutDirection) objConsume1111114, orientation1113, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111110 & 7168) | (3670016 & i111111111110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1113, z3, z1117, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111113 | ((i21111111115 >> 12) & 7168) | i21111111114 | (458752 & i111111111110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1112, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier1115;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z1117;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier2;
                                }
                                if (i16 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i5 != 0) {
                                    z4 = false;
                                } else {
                                    z4 = z;
                                }
                                if ((i3 & 64) != 0) {
                                    i4 &= -3670017;
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                i13 = i4;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                            }
                            int i111111111113 = i13 >> 3;
                            int i111111111114 = i111111111113 & 14;
                            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1113 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111114);
                            int i111111111115 = i13 >> 9;
                            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1113 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111115 & 112) | i111111111114);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1113 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1113);
                                objRememberedValue = compositionScopedCoroutineScopeCanceller1113;
                            }
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            CoroutineScope coroutineScope1113 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1113 = CompositionLocalsKt.getLocalGraphicsContext();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1111115 = composerStartRestartGroup.consume(localGraphicsContext1113);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i21111111116 = i13 & 112;
                            int i21111111117 = i13 & 57344;
                            int i21111111118 = i13;
                            boolean z1118 = z4;
                            Modifier modifier1116 = companion;
                            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1113 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1113, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1113, (GraphicsContext) objConsume1111115, composerStartRestartGroup, (524272 & i13) | (i111111111115 & 3670016) | (29360128 & i111111111113));
                            if (z2) {
                                orientation = Orientation.Vertical;
                            } else {
                                orientation = Orientation.Horizontal;
                            }
                            Orientation orientation1114 = orientation;
                            Modifier modifierLazyLayoutSemantics1113 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1116.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1113, lazyLayoutSemanticStateRememberLazyGridSemanticState1113, orientation1114, z3, z1118, composerStartRestartGroup, (i111111111115 & 57344) | ((i21111111118 << 3) & 458752));
                            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1113 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111114);
                            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1113 = lazyGridState.getBeyondBoundsInfo();
                            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1113 = CompositionLocalsKt.getLocalLayoutDirection();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                            Object objConsume1111116 = composerStartRestartGroup.consume(localLayoutDirection1113);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            composer2 = composerStartRestartGroup;
                            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1113, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1113, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1113, beyondBoundsInfo$foundation_release1113, z1118, (LayoutDirection) objConsume1111116, orientation1114, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111113 & 7168) | (3670016 & i111111111113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1114, z3, z1118, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111116 | ((i21111111118 >> 12) & 7168) | i21111111117 | (458752 & i111111111113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1113, composer2, 0, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            modifier3 = modifier1116;
                            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            flingBehavior3 = flingBehavior2;
                            z5 = z1118;
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

                                public final void invoke(Composer composer3, int i21111111119) {
                                    LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                                }
                            });
                        }
                    }
                    i4 |= 805306368;
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i111111111116 = i13 >> 3;
                        int i111111111117 = i111111111116 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1114 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111117);
                        int i111111111118 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1114 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111118 & 112) | i111111111117);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1114 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1114);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller1114;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope1114 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1114 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111117 = composerStartRestartGroup.consume(localGraphicsContext1114);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21111111119 = i13 & 112;
                        int i211111111110 = i13 & 57344;
                        int i211111111111 = i13;
                        boolean z1119 = z4;
                        Modifier modifier1117 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1114 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1114, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1114, (GraphicsContext) objConsume1111117, composerStartRestartGroup, (524272 & i13) | (i111111111118 & 3670016) | (29360128 & i111111111116));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation1115 = orientation;
                        Modifier modifierLazyLayoutSemantics1114 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1117.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1114, lazyLayoutSemanticStateRememberLazyGridSemanticState1114, orientation1115, z3, z1119, composerStartRestartGroup, (i111111111118 & 57344) | ((i211111111111 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1114 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111117);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1114 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1114 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111118 = composerStartRestartGroup.consume(localLayoutDirection1114);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1114, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1114, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1114, beyondBoundsInfo$foundation_release1114, z1119, (LayoutDirection) objConsume1111118, orientation1115, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111116 & 7168) | (3670016 & i111111111116)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1115, z3, z1119, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111119 | ((i211111111111 >> 12) & 7168) | i211111111110 | (458752 & i111111111116), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1114, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier1117;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z1119;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i111111111119 = i13 >> 3;
                        int i1111111111110 = i111111111119 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1115 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111110);
                        int i1111111111111 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1115 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111 & 112) | i1111111111110);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1115 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1115);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller1115;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope1115 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1115 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111119 = composerStartRestartGroup.consume(localGraphicsContext1115);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i211111111112 = i13 & 112;
                        int i211111111113 = i13 & 57344;
                        int i211111111114 = i13;
                        boolean z11110 = z4;
                        Modifier modifier1118 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1115 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1115, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1115, (GraphicsContext) objConsume1111119, composerStartRestartGroup, (524272 & i13) | (i1111111111111 & 3670016) | (29360128 & i111111111119));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation1116 = orientation;
                        Modifier modifierLazyLayoutSemantics1115 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1118.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1115, lazyLayoutSemanticStateRememberLazyGridSemanticState1115, orientation1116, z3, z11110, composerStartRestartGroup, (i1111111111111 & 57344) | ((i211111111114 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1115 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111110);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1115 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1115 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111110 = composerStartRestartGroup.consume(localLayoutDirection1115);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1115, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1115, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1115, beyondBoundsInfo$foundation_release1115, z11110, (LayoutDirection) objConsume11111110, orientation1116, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111119 & 7168) | (3670016 & i111111111119)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1116, z3, z11110, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111112 | ((i211111111114 >> 12) & 7168) | i211111111113 | (458752 & i111111111119), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1115, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier1118;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z11110;
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

                            public final void invoke(Composer composer3, int i211111111115) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 100663296;
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i1111111111112 = i13 >> 3;
                        int i1111111111113 = i1111111111112 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1116 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111113);
                        int i1111111111114 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1116 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111114 & 112) | i1111111111113);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1116 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1116);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller1116;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope1116 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1116 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111111 = composerStartRestartGroup.consume(localGraphicsContext1116);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i211111111115 = i13 & 112;
                        int i211111111116 = i13 & 57344;
                        int i211111111117 = i13;
                        boolean z11111 = z4;
                        Modifier modifier1119 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1116 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1116, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1116, (GraphicsContext) objConsume11111111, composerStartRestartGroup, (524272 & i13) | (i1111111111114 & 3670016) | (29360128 & i1111111111112));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation1117 = orientation;
                        Modifier modifierLazyLayoutSemantics1116 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1119.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1116, lazyLayoutSemanticStateRememberLazyGridSemanticState1116, orientation1117, z3, z11111, composerStartRestartGroup, (i1111111111114 & 57344) | ((i211111111117 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1116 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111113);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1116 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1116 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111112 = composerStartRestartGroup.consume(localLayoutDirection1116);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1116, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1116, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1116, beyondBoundsInfo$foundation_release1116, z11111, (LayoutDirection) objConsume11111112, orientation1117, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111112 & 7168) | (3670016 & i1111111111112)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1117, z3, z11111, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111115 | ((i211111111117 >> 12) & 7168) | i211111111116 | (458752 & i1111111111112), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1116, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier1119;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z11111;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i1111111111115 = i13 >> 3;
                        int i1111111111116 = i1111111111115 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1117 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111116);
                        int i1111111111117 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1117 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111117 & 112) | i1111111111116);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1117 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1117);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller1117;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope1117 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1117 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111113 = composerStartRestartGroup.consume(localGraphicsContext1117);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i211111111118 = i13 & 112;
                        int i211111111119 = i13 & 57344;
                        int i2111111111110 = i13;
                        boolean z11112 = z4;
                        Modifier modifier11110 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1117 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1117, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1117, (GraphicsContext) objConsume11111113, composerStartRestartGroup, (524272 & i13) | (i1111111111117 & 3670016) | (29360128 & i1111111111115));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation1118 = orientation;
                        Modifier modifierLazyLayoutSemantics1117 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11110.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1117, lazyLayoutSemanticStateRememberLazyGridSemanticState1117, orientation1118, z3, z11112, composerStartRestartGroup, (i1111111111117 & 57344) | ((i2111111111110 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1117 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111116);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1117 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1117 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111114 = composerStartRestartGroup.consume(localLayoutDirection1117);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1117, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1117, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1117, beyondBoundsInfo$foundation_release1117, z11112, (LayoutDirection) objConsume11111114, orientation1118, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111115 & 7168) | (3670016 & i1111111111115)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1118, z3, z11112, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111118 | ((i2111111111110 >> 12) & 7168) | i211111111119 | (458752 & i1111111111115), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1117, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier11110;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z11112;
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

                            public final void invoke(Composer composer3, int i2111111111111) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i1111111111118 = i13 >> 3;
                    int i1111111111119 = i1111111111118 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1118 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111119);
                    int i11111111111110 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1118 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111110 & 112) | i1111111111119);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1118 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1118);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller1118;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope1118 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1118 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111115 = composerStartRestartGroup.consume(localGraphicsContext1118);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2111111111111 = i13 & 112;
                    int i2111111111112 = i13 & 57344;
                    int i2111111111113 = i13;
                    boolean z11113 = z4;
                    Modifier modifier11111 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1118 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1118, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1118, (GraphicsContext) objConsume11111115, composerStartRestartGroup, (524272 & i13) | (i11111111111110 & 3670016) | (29360128 & i1111111111118));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation1119 = orientation;
                    Modifier modifierLazyLayoutSemantics1118 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11111.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1118, lazyLayoutSemanticStateRememberLazyGridSemanticState1118, orientation1119, z3, z11113, composerStartRestartGroup, (i11111111111110 & 57344) | ((i2111111111113 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1118 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111119);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1118 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1118 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111116 = composerStartRestartGroup.consume(localLayoutDirection1118);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1118, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1118, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1118, beyondBoundsInfo$foundation_release1118, z11113, (LayoutDirection) objConsume11111116, orientation1119, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111118 & 7168) | (3670016 & i1111111111118)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1119, z3, z11113, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111 | ((i2111111111113 >> 12) & 7168) | i2111111111112 | (458752 & i1111111111118), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1118, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier11111;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z11113;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i11111111111111 = i13 >> 3;
                    int i11111111111112 = i11111111111111 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1119 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111112);
                    int i11111111111113 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1119 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111113 & 112) | i11111111111112);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1119 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1119);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller1119;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope1119 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1119 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111117 = composerStartRestartGroup.consume(localGraphicsContext1119);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2111111111114 = i13 & 112;
                    int i2111111111115 = i13 & 57344;
                    int i2111111111116 = i13;
                    boolean z11114 = z4;
                    Modifier modifier11112 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1119 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1119, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1119, (GraphicsContext) objConsume11111117, composerStartRestartGroup, (524272 & i13) | (i11111111111113 & 3670016) | (29360128 & i11111111111111));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation11110 = orientation;
                    Modifier modifierLazyLayoutSemantics1119 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11112.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1119, lazyLayoutSemanticStateRememberLazyGridSemanticState1119, orientation11110, z3, z11114, composerStartRestartGroup, (i11111111111113 & 57344) | ((i2111111111116 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1119 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111112);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1119 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1119 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111118 = composerStartRestartGroup.consume(localLayoutDirection1119);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1119, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1119, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1119, beyondBoundsInfo$foundation_release1119, z11114, (LayoutDirection) objConsume11111118, orientation11110, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111 & 7168) | (3670016 & i11111111111111)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11110, z3, z11114, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111114 | ((i2111111111116 >> 12) & 7168) | i2111111111115 | (458752 & i11111111111111), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1119, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier11112;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z11114;
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

                        public final void invoke(Composer composer3, int i2111111111117) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 12582912;
            if ((i3 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(vertical)) {
                        i9 = 67108864;
                    } else {
                        i9 = 33554432;
                    }
                    i4 |= i9;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11111111111114 = i13 >> 3;
                        int i11111111111115 = i11111111111114 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11110 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111115);
                        int i11111111111116 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11110 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111116 & 112) | i11111111111115);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11110);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller11110;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope11110 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11110 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume11111119 = composerStartRestartGroup.consume(localGraphicsContext11110);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111111111117 = i13 & 112;
                        int i2111111111118 = i13 & 57344;
                        int i2111111111119 = i13;
                        boolean z11115 = z4;
                        Modifier modifier11113 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11110 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11110, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11110, (GraphicsContext) objConsume11111119, composerStartRestartGroup, (524272 & i13) | (i11111111111116 & 3670016) | (29360128 & i11111111111114));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation11111 = orientation;
                        Modifier modifierLazyLayoutSemantics11110 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11113.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11110, lazyLayoutSemanticStateRememberLazyGridSemanticState11110, orientation11111, z3, z11115, composerStartRestartGroup, (i11111111111116 & 57344) | ((i2111111111119 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11110 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111115);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11110 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11110 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume111111110 = composerStartRestartGroup.consume(localLayoutDirection11110);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11110, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11110, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11110, beyondBoundsInfo$foundation_release11110, z11115, (LayoutDirection) objConsume111111110, orientation11111, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111114 & 7168) | (3670016 & i11111111111114)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11111, z3, z11115, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111117 | ((i2111111111119 >> 12) & 7168) | i2111111111118 | (458752 & i11111111111114), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11110, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier11113;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z11115;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11111111111117 = i13 >> 3;
                        int i11111111111118 = i11111111111117 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11111 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111118);
                        int i11111111111119 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11111 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111119 & 112) | i11111111111118);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11111);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller11111;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope11111 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11111 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume111111111 = composerStartRestartGroup.consume(localGraphicsContext11111);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i21111111111110 = i13 & 112;
                        int i21111111111111 = i13 & 57344;
                        int i21111111111112 = i13;
                        boolean z11116 = z4;
                        Modifier modifier11114 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11111 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11111, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11111, (GraphicsContext) objConsume111111111, composerStartRestartGroup, (524272 & i13) | (i11111111111119 & 3670016) | (29360128 & i11111111111117));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation11112 = orientation;
                        Modifier modifierLazyLayoutSemantics11111 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11114.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11111, lazyLayoutSemanticStateRememberLazyGridSemanticState11111, orientation11112, z3, z11116, composerStartRestartGroup, (i11111111111119 & 57344) | ((i21111111111112 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11111 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111118);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11111 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11111 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume111111112 = composerStartRestartGroup.consume(localLayoutDirection11111);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11111, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11111, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11111, beyondBoundsInfo$foundation_release11111, z11116, (LayoutDirection) objConsume111111112, orientation11112, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111117 & 7168) | (3670016 & i11111111111117)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11112, z3, z11116, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111110 | ((i21111111111112 >> 12) & 7168) | i21111111111111 | (458752 & i11111111111117), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11111, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier11114;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z11116;
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

                            public final void invoke(Composer composer3, int i21111111111113) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111111111110 = i13 >> 3;
                    int i111111111111111 = i111111111111110 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11112 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111111);
                    int i111111111111112 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11112 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111112 & 112) | i111111111111111);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11112 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11112);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller11112;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope11112 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11112 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111113 = composerStartRestartGroup.consume(localGraphicsContext11112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111111111113 = i13 & 112;
                    int i21111111111114 = i13 & 57344;
                    int i21111111111115 = i13;
                    boolean z11117 = z4;
                    Modifier modifier11115 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11112 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11112, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11112, (GraphicsContext) objConsume111111113, composerStartRestartGroup, (524272 & i13) | (i111111111111112 & 3670016) | (29360128 & i111111111111110));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation11113 = orientation;
                    Modifier modifierLazyLayoutSemantics11112 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11115.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11112, lazyLayoutSemanticStateRememberLazyGridSemanticState11112, orientation11113, z3, z11117, composerStartRestartGroup, (i111111111111112 & 57344) | ((i21111111111115 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11112 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111111);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11112 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11112 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111114 = composerStartRestartGroup.consume(localLayoutDirection11112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11112, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11112, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11112, beyondBoundsInfo$foundation_release11112, z11117, (LayoutDirection) objConsume111111114, orientation11113, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111110 & 7168) | (3670016 & i111111111111110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11113, z3, z11117, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111113 | ((i21111111111115 >> 12) & 7168) | i21111111111114 | (458752 & i111111111111110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11112, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier11115;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z11117;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111111111113 = i13 >> 3;
                    int i111111111111114 = i111111111111113 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11113 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111114);
                    int i111111111111115 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11113 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111115 & 112) | i111111111111114);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11113 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11113);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller11113;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope11113 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11113 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111115 = composerStartRestartGroup.consume(localGraphicsContext11113);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111111111116 = i13 & 112;
                    int i21111111111117 = i13 & 57344;
                    int i21111111111118 = i13;
                    boolean z11118 = z4;
                    Modifier modifier11116 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11113 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11113, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11113, (GraphicsContext) objConsume111111115, composerStartRestartGroup, (524272 & i13) | (i111111111111115 & 3670016) | (29360128 & i111111111111113));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation11114 = orientation;
                    Modifier modifierLazyLayoutSemantics11113 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11116.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11113, lazyLayoutSemanticStateRememberLazyGridSemanticState11113, orientation11114, z3, z11118, composerStartRestartGroup, (i111111111111115 & 57344) | ((i21111111111118 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11113 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111114);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11113 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11113 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111116 = composerStartRestartGroup.consume(localLayoutDirection11113);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11113, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11113, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11113, beyondBoundsInfo$foundation_release11113, z11118, (LayoutDirection) objConsume111111116, orientation11114, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111113 & 7168) | (3670016 & i111111111111113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11114, z3, z11118, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111116 | ((i21111111111118 >> 12) & 7168) | i21111111111117 | (458752 & i111111111111113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11113, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier11116;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z11118;
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

                        public final void invoke(Composer composer3, int i21111111111119) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 100663296;
            if ((i3 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111111111116 = i13 >> 3;
                    int i111111111111117 = i111111111111116 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11114 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111117);
                    int i111111111111118 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11114 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111118 & 112) | i111111111111117);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11114 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11114);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller11114;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope11114 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11114 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111117 = composerStartRestartGroup.consume(localGraphicsContext11114);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111111111119 = i13 & 112;
                    int i211111111111110 = i13 & 57344;
                    int i211111111111111 = i13;
                    boolean z11119 = z4;
                    Modifier modifier11117 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11114 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11114, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11114, (GraphicsContext) objConsume111111117, composerStartRestartGroup, (524272 & i13) | (i111111111111118 & 3670016) | (29360128 & i111111111111116));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation11115 = orientation;
                    Modifier modifierLazyLayoutSemantics11114 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11117.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11114, lazyLayoutSemanticStateRememberLazyGridSemanticState11114, orientation11115, z3, z11119, composerStartRestartGroup, (i111111111111118 & 57344) | ((i211111111111111 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11114 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111117);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11114 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11114 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111118 = composerStartRestartGroup.consume(localLayoutDirection11114);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11114, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11114, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11114, beyondBoundsInfo$foundation_release11114, z11119, (LayoutDirection) objConsume111111118, orientation11115, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111116 & 7168) | (3670016 & i111111111111116)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11115, z3, z11119, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111119 | ((i211111111111111 >> 12) & 7168) | i211111111111110 | (458752 & i111111111111116), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11114, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier11117;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z11119;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111111111119 = i13 >> 3;
                    int i1111111111111110 = i111111111111119 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11115 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111110);
                    int i1111111111111111 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11115 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111111 & 112) | i1111111111111110);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11115 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11115);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller11115;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope11115 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11115 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111119 = composerStartRestartGroup.consume(localGraphicsContext11115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211111111111112 = i13 & 112;
                    int i211111111111113 = i13 & 57344;
                    int i211111111111114 = i13;
                    boolean z111110 = z4;
                    Modifier modifier11118 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11115 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11115, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11115, (GraphicsContext) objConsume111111119, composerStartRestartGroup, (524272 & i13) | (i1111111111111111 & 3670016) | (29360128 & i111111111111119));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation11116 = orientation;
                    Modifier modifierLazyLayoutSemantics11115 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11118.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11115, lazyLayoutSemanticStateRememberLazyGridSemanticState11115, orientation11116, z3, z111110, composerStartRestartGroup, (i1111111111111111 & 57344) | ((i211111111111114 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11115 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111110);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11115 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11115 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111110 = composerStartRestartGroup.consume(localLayoutDirection11115);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11115, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11115, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11115, beyondBoundsInfo$foundation_release11115, z111110, (LayoutDirection) objConsume1111111110, orientation11116, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111119 & 7168) | (3670016 & i111111111111119)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11116, z3, z111110, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111111112 | ((i211111111111114 >> 12) & 7168) | i211111111111113 | (458752 & i111111111111119), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11115, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier11118;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z111110;
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

                        public final void invoke(Composer composer3, int i211111111111115) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i3 & Fields.RotationZ) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
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
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i1111111111111112 = i13 >> 3;
                int i1111111111111113 = i1111111111111112 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11116 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111113);
                int i1111111111111114 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11116 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111114 & 112) | i1111111111111113);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11116 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11116);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller11116;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope11116 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11116 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111111 = composerStartRestartGroup.consume(localGraphicsContext11116);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211111111111115 = i13 & 112;
                int i211111111111116 = i13 & 57344;
                int i211111111111117 = i13;
                boolean z111111 = z4;
                Modifier modifier11119 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11116 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11116, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11116, (GraphicsContext) objConsume1111111111, composerStartRestartGroup, (524272 & i13) | (i1111111111111114 & 3670016) | (29360128 & i1111111111111112));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation11117 = orientation;
                Modifier modifierLazyLayoutSemantics11116 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier11119.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11116, lazyLayoutSemanticStateRememberLazyGridSemanticState11116, orientation11117, z3, z111111, composerStartRestartGroup, (i1111111111111114 & 57344) | ((i211111111111117 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11116 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111113);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11116 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11116 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111112 = composerStartRestartGroup.consume(localLayoutDirection11116);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11116, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11116, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11116, beyondBoundsInfo$foundation_release11116, z111111, (LayoutDirection) objConsume1111111112, orientation11117, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111111112 & 7168) | (3670016 & i1111111111111112)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11117, z3, z111111, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111111115 | ((i211111111111117 >> 12) & 7168) | i211111111111116 | (458752 & i1111111111111112), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11116, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier11119;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z111111;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i1111111111111115 = i13 >> 3;
                int i1111111111111116 = i1111111111111115 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11117 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111116);
                int i1111111111111117 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11117 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111117 & 112) | i1111111111111116);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11117 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11117);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller11117;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope11117 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11117 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111113 = composerStartRestartGroup.consume(localGraphicsContext11117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211111111111118 = i13 & 112;
                int i211111111111119 = i13 & 57344;
                int i2111111111111110 = i13;
                boolean z111112 = z4;
                Modifier modifier111110 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11117 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11117, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11117, (GraphicsContext) objConsume1111111113, composerStartRestartGroup, (524272 & i13) | (i1111111111111117 & 3670016) | (29360128 & i1111111111111115));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation11118 = orientation;
                Modifier modifierLazyLayoutSemantics11117 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111110.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11117, lazyLayoutSemanticStateRememberLazyGridSemanticState11117, orientation11118, z3, z111112, composerStartRestartGroup, (i1111111111111117 & 57344) | ((i2111111111111110 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11117 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111116);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11117 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11117 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111114 = composerStartRestartGroup.consume(localLayoutDirection11117);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11117, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11117, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11117, beyondBoundsInfo$foundation_release11117, z111112, (LayoutDirection) objConsume1111111114, orientation11118, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111111115 & 7168) | (3670016 & i1111111111111115)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11118, z3, z111112, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111111118 | ((i2111111111111110 >> 12) & 7168) | i211111111111119 | (458752 & i1111111111111115), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11117, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier111110;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z111112;
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

                    public final void invoke(Composer composer3, int i2111111111111111) {
                        LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        if ((i3 & 32) != 0) {
            i4 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i7 = Fields.RenderEffect;
            } else {
                i7 = 65536;
            }
            i4 |= i7;
        }
        if ((i & 1572864) != 0) {
            if ((i3 & 64) == 0) {
                i14 = 524288;
            } else {
                i14 = 524288;
            }
            i4 |= i14;
        }
        if ((i3 & Fields.SpotShadowColor) != 0) {
            if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i8 = 8388608;
                } else {
                    i8 = 4194304;
                }
                i4 |= i8;
            }
            if ((i3 & Fields.RotationX) != 0) {
                if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(vertical)) {
                        i9 = 67108864;
                    } else {
                        i9 = 33554432;
                    }
                    i4 |= i9;
                }
                if ((i3 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i10 = 536870912;
                        } else {
                            i10 = 268435456;
                        }
                        i4 |= i10;
                    }
                    if ((i3 & Fields.RotationZ) != 0) {
                        i11 = i2 | 6;
                    } else if ((i2 & 6) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
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
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i1111111111111118 = i13 >> 3;
                        int i1111111111111119 = i1111111111111118 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11118 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111119);
                        int i11111111111111110 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11118 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111110 & 112) | i1111111111111119);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11118 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11118);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller11118;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope11118 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11118 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111111115 = composerStartRestartGroup.consume(localGraphicsContext11118);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111111111111111 = i13 & 112;
                        int i2111111111111112 = i13 & 57344;
                        int i2111111111111113 = i13;
                        boolean z111113 = z4;
                        Modifier modifier111111 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11118 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11118, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11118, (GraphicsContext) objConsume1111111115, composerStartRestartGroup, (524272 & i13) | (i11111111111111110 & 3670016) | (29360128 & i1111111111111118));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation11119 = orientation;
                        Modifier modifierLazyLayoutSemantics11118 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111111.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11118, lazyLayoutSemanticStateRememberLazyGridSemanticState11118, orientation11119, z3, z111113, composerStartRestartGroup, (i11111111111111110 & 57344) | ((i2111111111111113 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11118 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111119);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11118 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11118 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111111116 = composerStartRestartGroup.consume(localLayoutDirection11118);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11118, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11118, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11118, beyondBoundsInfo$foundation_release11118, z111113, (LayoutDirection) objConsume1111111116, orientation11119, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111111118 & 7168) | (3670016 & i1111111111111118)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation11119, z3, z111113, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111111 | ((i2111111111111113 >> 12) & 7168) | i2111111111111112 | (458752 & i1111111111111118), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11118, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier111111;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z111113;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier2;
                            }
                            if (i16 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i5 != 0) {
                                z4 = false;
                            } else {
                                z4 = z;
                            }
                            if ((i3 & 64) != 0) {
                                i4 &= -3670017;
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            i13 = i4;
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                        }
                        int i11111111111111111 = i13 >> 3;
                        int i11111111111111112 = i11111111111111111 & 14;
                        Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda11119 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111111112);
                        int i11111111111111113 = i13 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState11119 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111113 & 112) | i11111111111111112);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                            CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller11119 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                            composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller11119);
                            objRememberedValue = compositionScopedCoroutineScopeCanceller11119;
                        }
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        CoroutineScope coroutineScope11119 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ProvidableCompositionLocal<GraphicsContext> localGraphicsContext11119 = CompositionLocalsKt.getLocalGraphicsContext();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111111117 = composerStartRestartGroup.consume(localGraphicsContext11119);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111111111111114 = i13 & 112;
                        int i2111111111111115 = i13 & 57344;
                        int i2111111111111116 = i13;
                        boolean z111114 = z4;
                        Modifier modifier111112 = companion;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy11119 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda11119, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope11119, (GraphicsContext) objConsume1111111117, composerStartRestartGroup, (524272 & i13) | (i11111111111111113 & 3670016) | (29360128 & i11111111111111111));
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation111110 = orientation;
                        Modifier modifierLazyLayoutSemantics11119 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111112.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda11119, lazyLayoutSemanticStateRememberLazyGridSemanticState11119, orientation111110, z3, z111114, composerStartRestartGroup, (i11111111111111113 & 57344) | ((i2111111111111116 << 3) & 458752));
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11119 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111111112);
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release11119 = lazyGridState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11119 = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume1111111118 = composerStartRestartGroup.consume(localLayoutDirection11119);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        composer2 = composerStartRestartGroup;
                        LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda11119, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11119, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState11119, beyondBoundsInfo$foundation_release11119, z111114, (LayoutDirection) objConsume1111111118, orientation111110, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111111 & 7168) | (3670016 & i11111111111111111)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111110, z3, z111114, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111114 | ((i2111111111111116 >> 12) & 7168) | i2111111111111115 | (458752 & i11111111111111111), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy11119, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        modifier3 = modifier111112;
                        paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        z5 = z111114;
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

                            public final void invoke(Composer composer3, int i2111111111111117) {
                                LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                            }
                        });
                    }
                }
                i4 |= 805306368;
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i11111111111111114 = i13 >> 3;
                    int i11111111111111115 = i11111111111111114 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111110 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111111115);
                    int i11111111111111116 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111110 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111116 & 112) | i11111111111111115);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111110);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111110;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope111110 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111110 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume1111111119 = composerStartRestartGroup.consume(localGraphicsContext111110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2111111111111117 = i13 & 112;
                    int i2111111111111118 = i13 & 57344;
                    int i2111111111111119 = i13;
                    boolean z111115 = z4;
                    Modifier modifier111113 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111110 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111110, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111110, (GraphicsContext) objConsume1111111119, composerStartRestartGroup, (524272 & i13) | (i11111111111111116 & 3670016) | (29360128 & i11111111111111114));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation111111 = orientation;
                    Modifier modifierLazyLayoutSemantics111110 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111113.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111110, lazyLayoutSemanticStateRememberLazyGridSemanticState111110, orientation111111, z3, z111115, composerStartRestartGroup, (i11111111111111116 & 57344) | ((i2111111111111119 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111110 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111111115);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111110 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111110 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111110 = composerStartRestartGroup.consume(localLayoutDirection111110);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111110, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111110, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111110, beyondBoundsInfo$foundation_release111110, z111115, (LayoutDirection) objConsume11111111110, orientation111111, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111114 & 7168) | (3670016 & i11111111111111114)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111111, z3, z111115, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111117 | ((i2111111111111119 >> 12) & 7168) | i2111111111111118 | (458752 & i11111111111111114), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111110, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier111113;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z111115;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i11111111111111117 = i13 >> 3;
                    int i11111111111111118 = i11111111111111117 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111111 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111111118);
                    int i11111111111111119 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111111 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111119 & 112) | i11111111111111118);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111111);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111111;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope111111 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111111 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111111 = composerStartRestartGroup.consume(localGraphicsContext111111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111111111111110 = i13 & 112;
                    int i21111111111111111 = i13 & 57344;
                    int i21111111111111112 = i13;
                    boolean z111116 = z4;
                    Modifier modifier111114 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111111 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111111, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111111, (GraphicsContext) objConsume11111111111, composerStartRestartGroup, (524272 & i13) | (i11111111111111119 & 3670016) | (29360128 & i11111111111111117));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation111112 = orientation;
                    Modifier modifierLazyLayoutSemantics111111 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111114.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111111, lazyLayoutSemanticStateRememberLazyGridSemanticState111111, orientation111112, z3, z111116, composerStartRestartGroup, (i11111111111111119 & 57344) | ((i21111111111111112 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111111 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111111118);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111111 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111111 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111112 = composerStartRestartGroup.consume(localLayoutDirection111111);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111111, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111111, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111111, beyondBoundsInfo$foundation_release111111, z111116, (LayoutDirection) objConsume11111111112, orientation111112, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111117 & 7168) | (3670016 & i11111111111111117)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111112, z3, z111116, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111110 | ((i21111111111111112 >> 12) & 7168) | i21111111111111111 | (458752 & i11111111111111117), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111111, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier111114;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z111116;
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

                        public final void invoke(Composer composer3, int i21111111111111113) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 100663296;
            if ((i3 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111111111111110 = i13 >> 3;
                    int i111111111111111111 = i111111111111111110 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111112 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111111111);
                    int i111111111111111112 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111112 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111111112 & 112) | i111111111111111111);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111112 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111112);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111112;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope111112 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111112 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111113 = composerStartRestartGroup.consume(localGraphicsContext111112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111111111111113 = i13 & 112;
                    int i21111111111111114 = i13 & 57344;
                    int i21111111111111115 = i13;
                    boolean z111117 = z4;
                    Modifier modifier111115 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111112 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111112, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111112, (GraphicsContext) objConsume11111111113, composerStartRestartGroup, (524272 & i13) | (i111111111111111112 & 3670016) | (29360128 & i111111111111111110));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation111113 = orientation;
                    Modifier modifierLazyLayoutSemantics111112 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111115.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111112, lazyLayoutSemanticStateRememberLazyGridSemanticState111112, orientation111113, z3, z111117, composerStartRestartGroup, (i111111111111111112 & 57344) | ((i21111111111111115 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111112 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111111111);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111112 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111112 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111114 = composerStartRestartGroup.consume(localLayoutDirection111112);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111112, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111112, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111112, beyondBoundsInfo$foundation_release111112, z111117, (LayoutDirection) objConsume11111111114, orientation111113, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111111110 & 7168) | (3670016 & i111111111111111110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111113, z3, z111117, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111113 | ((i21111111111111115 >> 12) & 7168) | i21111111111111114 | (458752 & i111111111111111110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111112, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier111115;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z111117;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i111111111111111113 = i13 >> 3;
                    int i111111111111111114 = i111111111111111113 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111113 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111111114);
                    int i111111111111111115 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111113 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111111115 & 112) | i111111111111111114);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111113 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111113);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111113;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope111113 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111113 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111115 = composerStartRestartGroup.consume(localGraphicsContext111113);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21111111111111116 = i13 & 112;
                    int i21111111111111117 = i13 & 57344;
                    int i21111111111111118 = i13;
                    boolean z111118 = z4;
                    Modifier modifier111116 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111113 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111113, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111113, (GraphicsContext) objConsume11111111115, composerStartRestartGroup, (524272 & i13) | (i111111111111111115 & 3670016) | (29360128 & i111111111111111113));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation111114 = orientation;
                    Modifier modifierLazyLayoutSemantics111113 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111116.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111113, lazyLayoutSemanticStateRememberLazyGridSemanticState111113, orientation111114, z3, z111118, composerStartRestartGroup, (i111111111111111115 & 57344) | ((i21111111111111118 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111113 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111111114);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111113 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111113 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11111111116 = composerStartRestartGroup.consume(localLayoutDirection111113);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111113, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111113, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111113, beyondBoundsInfo$foundation_release111113, z111118, (LayoutDirection) objConsume11111111116, orientation111114, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111111113 & 7168) | (3670016 & i111111111111111113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111114, z3, z111118, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111116 | ((i21111111111111118 >> 12) & 7168) | i21111111111111117 | (458752 & i111111111111111113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111113, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier111116;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z111118;
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

                        public final void invoke(Composer composer3, int i21111111111111119) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i3 & Fields.RotationZ) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
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
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i111111111111111116 = i13 >> 3;
                int i111111111111111117 = i111111111111111116 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111114 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111111117);
                int i111111111111111118 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111114 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111111118 & 112) | i111111111111111117);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111114 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111114);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller111114;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope111114 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111114 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111117 = composerStartRestartGroup.consume(localGraphicsContext111114);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21111111111111119 = i13 & 112;
                int i211111111111111110 = i13 & 57344;
                int i211111111111111111 = i13;
                boolean z111119 = z4;
                Modifier modifier111117 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111114 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111114, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111114, (GraphicsContext) objConsume11111111117, composerStartRestartGroup, (524272 & i13) | (i111111111111111118 & 3670016) | (29360128 & i111111111111111116));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation111115 = orientation;
                Modifier modifierLazyLayoutSemantics111114 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111117.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111114, lazyLayoutSemanticStateRememberLazyGridSemanticState111114, orientation111115, z3, z111119, composerStartRestartGroup, (i111111111111111118 & 57344) | ((i211111111111111111 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111114 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111111117);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111114 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111114 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111118 = composerStartRestartGroup.consume(localLayoutDirection111114);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111114, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111114, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111114, beyondBoundsInfo$foundation_release111114, z111119, (LayoutDirection) objConsume11111111118, orientation111115, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111111116 & 7168) | (3670016 & i111111111111111116)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111115, z3, z111119, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111119 | ((i211111111111111111 >> 12) & 7168) | i211111111111111110 | (458752 & i111111111111111116), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111114, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier111117;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z111119;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i111111111111111119 = i13 >> 3;
                int i1111111111111111110 = i111111111111111119 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111115 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111111110);
                int i1111111111111111111 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111115 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111111111 & 112) | i1111111111111111110);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111115 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111115);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller111115;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope111115 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111115 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume11111111119 = composerStartRestartGroup.consume(localGraphicsContext111115);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211111111111111112 = i13 & 112;
                int i211111111111111113 = i13 & 57344;
                int i211111111111111114 = i13;
                boolean z1111110 = z4;
                Modifier modifier111118 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111115 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111115, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111115, (GraphicsContext) objConsume11111111119, composerStartRestartGroup, (524272 & i13) | (i1111111111111111111 & 3670016) | (29360128 & i111111111111111119));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation111116 = orientation;
                Modifier modifierLazyLayoutSemantics111115 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111118.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111115, lazyLayoutSemanticStateRememberLazyGridSemanticState111115, orientation111116, z3, z1111110, composerStartRestartGroup, (i1111111111111111111 & 57344) | ((i211111111111111114 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111115 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111111110);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111115 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111115 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111110 = composerStartRestartGroup.consume(localLayoutDirection111115);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111115, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111115, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111115, beyondBoundsInfo$foundation_release111115, z1111110, (LayoutDirection) objConsume111111111110, orientation111116, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111111119 & 7168) | (3670016 & i111111111111111119)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111116, z3, z1111110, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111111111112 | ((i211111111111111114 >> 12) & 7168) | i211111111111111113 | (458752 & i111111111111111119), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111115, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier111118;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1111110;
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

                    public final void invoke(Composer composer3, int i211111111111111115) {
                        LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 12582912;
        if ((i3 & Fields.RotationX) != 0) {
            if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(vertical)) {
                    i9 = 67108864;
                } else {
                    i9 = 33554432;
                }
                i4 |= i9;
            }
            if ((i3 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i10 = 536870912;
                    } else {
                        i10 = 268435456;
                    }
                    i4 |= i10;
                }
                if ((i3 & Fields.RotationZ) != 0) {
                    i11 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
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
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i1111111111111111112 = i13 >> 3;
                    int i1111111111111111113 = i1111111111111111112 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111116 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111111113);
                    int i1111111111111111114 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111116 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111111114 & 112) | i1111111111111111113);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111116 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111116);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111116;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope111116 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111116 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111111111 = composerStartRestartGroup.consume(localGraphicsContext111116);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211111111111111115 = i13 & 112;
                    int i211111111111111116 = i13 & 57344;
                    int i211111111111111117 = i13;
                    boolean z1111111 = z4;
                    Modifier modifier111119 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111116 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111116, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111116, (GraphicsContext) objConsume111111111111, composerStartRestartGroup, (524272 & i13) | (i1111111111111111114 & 3670016) | (29360128 & i1111111111111111112));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation111117 = orientation;
                    Modifier modifierLazyLayoutSemantics111116 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier111119.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111116, lazyLayoutSemanticStateRememberLazyGridSemanticState111116, orientation111117, z3, z1111111, composerStartRestartGroup, (i1111111111111111114 & 57344) | ((i211111111111111117 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111116 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111111113);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111116 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111116 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111111112 = composerStartRestartGroup.consume(localLayoutDirection111116);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111116, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111116, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111116, beyondBoundsInfo$foundation_release111116, z1111111, (LayoutDirection) objConsume111111111112, orientation111117, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111111111112 & 7168) | (3670016 & i1111111111111111112)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111117, z3, z1111111, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111111111115 | ((i211111111111111117 >> 12) & 7168) | i211111111111111116 | (458752 & i1111111111111111112), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111116, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier111119;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z1111111;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier2;
                        }
                        if (i16 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i5 != 0) {
                            z4 = false;
                        } else {
                            z4 = z;
                        }
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        i13 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                    }
                    int i1111111111111111115 = i13 >> 3;
                    int i1111111111111111116 = i1111111111111111115 & 14;
                    Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111117 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111111116);
                    int i1111111111111111117 = i13 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111117 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i1111111111111111117 & 112) | i1111111111111111116);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                        CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111117 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                        composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111117);
                        objRememberedValue = compositionScopedCoroutineScopeCanceller111117;
                    }
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    CoroutineScope coroutineScope111117 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111117 = CompositionLocalsKt.getLocalGraphicsContext();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111111113 = composerStartRestartGroup.consume(localGraphicsContext111117);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211111111111111118 = i13 & 112;
                    int i211111111111111119 = i13 & 57344;
                    int i2111111111111111110 = i13;
                    boolean z1111112 = z4;
                    Modifier modifier1111110 = companion;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111117 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111117, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111117, (GraphicsContext) objConsume111111111113, composerStartRestartGroup, (524272 & i13) | (i1111111111111111117 & 3670016) | (29360128 & i1111111111111111115));
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation111118 = orientation;
                    Modifier modifierLazyLayoutSemantics111117 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111110.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111117, lazyLayoutSemanticStateRememberLazyGridSemanticState111117, orientation111118, z3, z1111112, composerStartRestartGroup, (i1111111111111111117 & 57344) | ((i2111111111111111110 << 3) & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111117 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111111116);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111117 = lazyGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111117 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume111111111114 = composerStartRestartGroup.consume(localLayoutDirection111117);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111117, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111117, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111117, beyondBoundsInfo$foundation_release111117, z1111112, (LayoutDirection) objConsume111111111114, orientation111118, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111111111115 & 7168) | (3670016 & i1111111111111111115)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111118, z3, z1111112, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i211111111111111118 | ((i2111111111111111110 >> 12) & 7168) | i211111111111111119 | (458752 & i1111111111111111115), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111117, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    modifier3 = modifier1111110;
                    paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    z5 = z1111112;
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

                        public final void invoke(Composer composer3, int i2111111111111111111) {
                            LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 805306368;
            if ((i3 & Fields.RotationZ) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
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
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i1111111111111111118 = i13 >> 3;
                int i1111111111111111119 = i1111111111111111118 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111118 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i1111111111111111119);
                int i11111111111111111110 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111118 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111111110 & 112) | i1111111111111111119);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111118 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111118);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller111118;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope111118 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111118 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111115 = composerStartRestartGroup.consume(localGraphicsContext111118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111111111111111111 = i13 & 112;
                int i2111111111111111112 = i13 & 57344;
                int i2111111111111111113 = i13;
                boolean z1111113 = z4;
                Modifier modifier1111111 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111118 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111118, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111118, (GraphicsContext) objConsume111111111115, composerStartRestartGroup, (524272 & i13) | (i11111111111111111110 & 3670016) | (29360128 & i1111111111111111118));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation111119 = orientation;
                Modifier modifierLazyLayoutSemantics111118 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111111.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111118, lazyLayoutSemanticStateRememberLazyGridSemanticState111118, orientation111119, z3, z1111113, composerStartRestartGroup, (i11111111111111111110 & 57344) | ((i2111111111111111113 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111118 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i1111111111111111119);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111118 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111118 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111116 = composerStartRestartGroup.consume(localLayoutDirection111118);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111118, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111118, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111118, beyondBoundsInfo$foundation_release111118, z1111113, (LayoutDirection) objConsume111111111116, orientation111119, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i1111111111111111118 & 7168) | (3670016 & i1111111111111111118)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation111119, z3, z1111113, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111111111 | ((i2111111111111111113 >> 12) & 7168) | i2111111111111111112 | (458752 & i1111111111111111118), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111118, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier1111111;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1111113;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i11111111111111111111 = i13 >> 3;
                int i11111111111111111112 = i11111111111111111111 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda111119 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111111111112);
                int i11111111111111111113 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState111119 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111111113 & 112) | i11111111111111111112);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller111119 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller111119);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller111119;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope111119 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext111119 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111117 = composerStartRestartGroup.consume(localGraphicsContext111119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111111111111111114 = i13 & 112;
                int i2111111111111111115 = i13 & 57344;
                int i2111111111111111116 = i13;
                boolean z1111114 = z4;
                Modifier modifier1111112 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy111119 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda111119, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope111119, (GraphicsContext) objConsume111111111117, composerStartRestartGroup, (524272 & i13) | (i11111111111111111113 & 3670016) | (29360128 & i11111111111111111111));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation1111110 = orientation;
                Modifier modifierLazyLayoutSemantics111119 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111112.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda111119, lazyLayoutSemanticStateRememberLazyGridSemanticState111119, orientation1111110, z3, z1111114, composerStartRestartGroup, (i11111111111111111113 & 57344) | ((i2111111111111111116 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111119 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111111111112);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release111119 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection111119 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111118 = composerStartRestartGroup.consume(localLayoutDirection111119);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda111119, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics111119, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState111119, beyondBoundsInfo$foundation_release111119, z1111114, (LayoutDirection) objConsume111111111118, orientation1111110, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111111111 & 7168) | (3670016 & i11111111111111111111)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1111110, z3, z1111114, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111111114 | ((i2111111111111111116 >> 12) & 7168) | i2111111111111111115 | (458752 & i11111111111111111111), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy111119, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier1111112;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1111114;
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

                    public final void invoke(Composer composer3, int i2111111111111111117) {
                        LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 100663296;
        if ((i3 & Fields.RotationY) != 0) {
            if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i10 = 536870912;
                } else {
                    i10 = 268435456;
                }
                i4 |= i10;
            }
            if ((i3 & Fields.RotationZ) != 0) {
                i11 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
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
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i11111111111111111114 = i13 >> 3;
                int i11111111111111111115 = i11111111111111111114 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1111110 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111111111115);
                int i11111111111111111116 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1111110 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111111116 & 112) | i11111111111111111115);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1111110 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1111110);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller1111110;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope1111110 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1111110 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111111111119 = composerStartRestartGroup.consume(localGraphicsContext1111110);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111111111111111117 = i13 & 112;
                int i2111111111111111118 = i13 & 57344;
                int i2111111111111111119 = i13;
                boolean z1111115 = z4;
                Modifier modifier1111113 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1111110 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1111110, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1111110, (GraphicsContext) objConsume111111111119, composerStartRestartGroup, (524272 & i13) | (i11111111111111111116 & 3670016) | (29360128 & i11111111111111111114));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation1111111 = orientation;
                Modifier modifierLazyLayoutSemantics1111110 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111113.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1111110, lazyLayoutSemanticStateRememberLazyGridSemanticState1111110, orientation1111111, z3, z1111115, composerStartRestartGroup, (i11111111111111111116 & 57344) | ((i2111111111111111119 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111110 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111111111115);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1111110 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1111110 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111111110 = composerStartRestartGroup.consume(localLayoutDirection1111110);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1111110, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1111110, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111110, beyondBoundsInfo$foundation_release1111110, z1111115, (LayoutDirection) objConsume1111111111110, orientation1111111, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111111114 & 7168) | (3670016 & i11111111111111111114)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1111111, z3, z1111115, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i2111111111111111117 | ((i2111111111111111119 >> 12) & 7168) | i2111111111111111118 | (458752 & i11111111111111111114), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1111110, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier1111113;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1111115;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier2;
                    }
                    if (i16 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i5 != 0) {
                        z4 = false;
                    } else {
                        z4 = z;
                    }
                    if ((i3 & 64) != 0) {
                        i4 &= -3670017;
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    i13 = i4;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
                }
                int i11111111111111111117 = i13 >> 3;
                int i11111111111111111118 = i11111111111111111117 & 14;
                Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1111111 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i11111111111111111118);
                int i11111111111111111119 = i13 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1111111 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i11111111111111111119 & 112) | i11111111111111111118);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                    CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1111111 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                    composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1111111);
                    objRememberedValue = compositionScopedCoroutineScopeCanceller1111111;
                }
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                CoroutineScope coroutineScope1111111 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1111111 = CompositionLocalsKt.getLocalGraphicsContext();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111111111 = composerStartRestartGroup.consume(localGraphicsContext1111111);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21111111111111111110 = i13 & 112;
                int i21111111111111111111 = i13 & 57344;
                int i21111111111111111112 = i13;
                boolean z1111116 = z4;
                Modifier modifier1111114 = companion;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1111111 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1111111, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1111111, (GraphicsContext) objConsume1111111111111, composerStartRestartGroup, (524272 & i13) | (i11111111111111111119 & 3670016) | (29360128 & i11111111111111111117));
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation1111112 = orientation;
                Modifier modifierLazyLayoutSemantics1111111 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111114.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1111111, lazyLayoutSemanticStateRememberLazyGridSemanticState1111111, orientation1111112, z3, z1111116, composerStartRestartGroup, (i11111111111111111119 & 57344) | ((i21111111111111111112 << 3) & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111111 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i11111111111111111118);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1111111 = lazyGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1111111 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1111111111112 = composerStartRestartGroup.consume(localLayoutDirection1111111);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1111111, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1111111, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111111, beyondBoundsInfo$foundation_release1111111, z1111116, (LayoutDirection) objConsume1111111111112, orientation1111112, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i11111111111111111117 & 7168) | (3670016 & i11111111111111111117)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1111112, z3, z1111116, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111111110 | ((i21111111111111111112 >> 12) & 7168) | i21111111111111111111 | (458752 & i11111111111111111117), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1111111, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                modifier3 = modifier1111114;
                paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                z5 = z1111116;
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

                    public final void invoke(Composer composer3, int i21111111111111111113) {
                        LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 805306368;
        if ((i3 & Fields.RotationZ) != 0) {
            i11 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changedInstance(function1)) {
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
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i16 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i5 != 0) {
                    z4 = false;
                } else {
                    z4 = z;
                }
                if ((i3 & 64) != 0) {
                    i4 &= -3670017;
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                } else {
                    flingBehavior2 = flingBehavior;
                }
                i13 = i4;
            } else {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i16 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i5 != 0) {
                    z4 = false;
                } else {
                    z4 = z;
                }
                if ((i3 & 64) != 0) {
                    i4 &= -3670017;
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                } else {
                    flingBehavior2 = flingBehavior;
                }
                i13 = i4;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
            }
            int i111111111111111111110 = i13 >> 3;
            int i111111111111111111111 = i111111111111111111110 & 14;
            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1111112 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111111111111);
            int i111111111111111111112 = i13 >> 9;
            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1111112 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111111111112 & 112) | i111111111111111111111);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1111112 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1111112);
                objRememberedValue = compositionScopedCoroutineScopeCanceller1111112;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CoroutineScope coroutineScope1111112 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1111112 = CompositionLocalsKt.getLocalGraphicsContext();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111113 = composerStartRestartGroup.consume(localGraphicsContext1111112);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21111111111111111113 = i13 & 112;
            int i21111111111111111114 = i13 & 57344;
            int i21111111111111111115 = i13;
            boolean z1111117 = z4;
            Modifier modifier1111115 = companion;
            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1111112 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1111112, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1111112, (GraphicsContext) objConsume1111111111113, composerStartRestartGroup, (524272 & i13) | (i111111111111111111112 & 3670016) | (29360128 & i111111111111111111110));
            if (z2) {
                orientation = Orientation.Vertical;
            } else {
                orientation = Orientation.Horizontal;
            }
            Orientation orientation1111113 = orientation;
            Modifier modifierLazyLayoutSemantics1111112 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111115.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1111112, lazyLayoutSemanticStateRememberLazyGridSemanticState1111112, orientation1111113, z3, z1111117, composerStartRestartGroup, (i111111111111111111112 & 57344) | ((i21111111111111111115 << 3) & 458752));
            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111112 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111111111111);
            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1111112 = lazyGridState.getBeyondBoundsInfo();
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1111112 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111114 = composerStartRestartGroup.consume(localLayoutDirection1111112);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composer2 = composerStartRestartGroup;
            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1111112, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1111112, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111112, beyondBoundsInfo$foundation_release1111112, z1111117, (LayoutDirection) objConsume1111111111114, orientation1111113, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111111111110 & 7168) | (3670016 & i111111111111111111110)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1111113, z3, z1111117, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111111113 | ((i21111111111111111115 >> 12) & 7168) | i21111111111111111114 | (458752 & i111111111111111111110), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1111112, composer2, 0, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = modifier1111115;
            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            flingBehavior3 = flingBehavior2;
            z5 = z1111117;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i16 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i5 != 0) {
                    z4 = false;
                } else {
                    z4 = z;
                }
                if ((i3 & 64) != 0) {
                    i4 &= -3670017;
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                } else {
                    flingBehavior2 = flingBehavior;
                }
                i13 = i4;
            } else {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier2;
                }
                if (i16 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i5 != 0) {
                    z4 = false;
                } else {
                    z4 = z;
                }
                if ((i3 & 64) != 0) {
                    i4 &= -3670017;
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                } else {
                    flingBehavior2 = flingBehavior;
                }
                i13 = i4;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-649686062, i13, i11, "androidx.compose.foundation.lazy.grid.LazyGrid (LazyGrid.kt:77)");
            }
            int i111111111111111111113 = i13 >> 3;
            int i111111111111111111114 = i111111111111111111113 & 14;
            Function0<LazyGridItemProvider> function0RememberLazyGridItemProviderLambda1111113 = LazyGridItemProviderKt.rememberLazyGridItemProviderLambda(lazyGridState, function1, composerStartRestartGroup, ((i11 << 3) & 112) | i111111111111111111114);
            int i111111111111111111115 = i13 >> 9;
            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyGridSemanticState1111113 = LazySemanticsKt.rememberLazyGridSemanticState(lazyGridState, z4, composerStartRestartGroup, (i111111111111111111115 & 112) | i111111111111111111114);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 773894976, "CC(rememberCoroutineScope)482@20332L144:Effects.kt#9igjgp");
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -954367824, "CC(remember):Effects.kt#9igjgp");
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
                CompositionScopedCoroutineScopeCanceller compositionScopedCoroutineScopeCanceller1111113 = new CompositionScopedCoroutineScopeCanceller(EffectsKt.createCompositionCoroutineScope(EmptyCoroutineContext.INSTANCE, composerStartRestartGroup));
                composerStartRestartGroup.updateRememberedValue(compositionScopedCoroutineScopeCanceller1111113);
                objRememberedValue = compositionScopedCoroutineScopeCanceller1111113;
            }
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            CoroutineScope coroutineScope1111113 = ((CompositionScopedCoroutineScopeCanceller) objRememberedValue).getCoroutineScope();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ProvidableCompositionLocal<GraphicsContext> localGraphicsContext1111113 = CompositionLocalsKt.getLocalGraphicsContext();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111115 = composerStartRestartGroup.consume(localGraphicsContext1111113);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21111111111111111116 = i13 & 112;
            int i21111111111111111117 = i13 & 57344;
            int i21111111111111111118 = i13;
            boolean z1111118 = z4;
            Modifier modifier1111116 = companion;
            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyGridMeasurePolicy1111113 = rememberLazyGridMeasurePolicy(function0RememberLazyGridItemProviderLambda1111113, lazyGridState, lazyGridSlotsProvider, paddingValuesM1028PaddingValues0680j_4, z4, z2, horizontal, vertical, coroutineScope1111113, (GraphicsContext) objConsume1111111111115, composerStartRestartGroup, (524272 & i13) | (i111111111111111111115 & 3670016) | (29360128 & i111111111111111111113));
            if (z2) {
                orientation = Orientation.Vertical;
            } else {
                orientation = Orientation.Horizontal;
            }
            Orientation orientation1111114 = orientation;
            Modifier modifierLazyLayoutSemantics1111113 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier1111116.then(lazyGridState.getRemeasurementModifier()).then(lazyGridState.getAwaitLayoutModifier()), function0RememberLazyGridItemProviderLambda1111113, lazyLayoutSemanticStateRememberLazyGridSemanticState1111113, orientation1111114, z3, z1111118, composerStartRestartGroup, (i111111111111111111115 & 57344) | ((i21111111111111111118 << 3) & 458752));
            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111113 = LazyGridBeyondBoundsModifierKt.rememberLazyGridBeyondBoundsState(lazyGridState, composerStartRestartGroup, i111111111111111111114);
            LazyLayoutBeyondBoundsInfo beyondBoundsInfo$foundation_release1111113 = lazyGridState.getBeyondBoundsInfo();
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection1111113 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume1111111111116 = composerStartRestartGroup.consume(localLayoutDirection1111113);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            composer2 = composerStartRestartGroup;
            LazyLayoutKt.LazyLayout(function0RememberLazyGridItemProviderLambda1111113, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics1111113, lazyLayoutBeyondBoundsStateRememberLazyGridBeyondBoundsState1111113, beyondBoundsInfo$foundation_release1111113, z1111118, (LayoutDirection) objConsume1111111111116, orientation1111114, z3, composerStartRestartGroup, (MutableVector.$stable << 6) | (i111111111111111111113 & 7168) | (3670016 & i111111111111111111113)).then(lazyGridState.getItemAnimator$foundation_release().getModifier()), lazyGridState, orientation1111114, z3, z1111118, flingBehavior2, lazyGridState.getInternalInteractionSource(), null, composerStartRestartGroup, i21111111111111111116 | ((i21111111111111111118 >> 12) & 7168) | i21111111111111111117 | (458752 & i111111111111111111113), 64), lazyGridState.getPrefetchState(), function2RememberLazyGridMeasurePolicy1111113, composer2, 0, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            modifier3 = modifier1111116;
            paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
            flingBehavior3 = flingBehavior2;
            z5 = z1111118;
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

                public final void invoke(Composer composer3, int i21111111111111111119) {
                    LazyGridKt.LazyGrid(modifier3, lazyGridState, lazyGridSlotsProvider, paddingValues3, z5, z2, flingBehavior3, z3, vertical, horizontal, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }

    private static final Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> rememberLazyGridMeasurePolicy(final Function0<? extends LazyGridItemProvider> function0, final LazyGridState lazyGridState, final LazyGridSlotsProvider lazyGridSlotsProvider, final PaddingValues paddingValues, final boolean z, final boolean z2, final Arrangement.Horizontal horizontal, final Arrangement.Vertical vertical, final CoroutineScope coroutineScope, final GraphicsContext graphicsContext, Composer composer, int i) {
        boolean z3;
        ComposerKt.sourceInformationMarkerStart(composer, -1585069765, "C(rememberLazyGridMeasurePolicy)P(5,8,7!1,6,4,3,9)161@6721L9334:LazyGrid.kt#7791vq");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1585069765, i, -1, "androidx.compose.foundation.lazy.grid.rememberLazyGridMeasurePolicy (LazyGrid.kt:161)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 1026581015, "CC(remember):LazyGrid.kt#9igjgp");
        if (((i & 112) ^ 48) > 32 && composer.changed(lazyGridState)) {
            z3 = true;
        } else if ((i & 48) == 32) {
            z3 = true;
        } else {
            z3 = false;
        }
        boolean zChanged = z3 | ((((i & 896) ^ 384) > 256 && composer.changed(lazyGridSlotsProvider)) || (i & 384) == 256) | ((((i & 7168) ^ 3072) > 2048 && composer.changed(paddingValues)) || (i & 3072) == 2048) | ((((57344 & i) ^ 24576) > 16384 && composer.changed(z)) || (i & 24576) == 16384) | ((((458752 & i) ^ 196608) > 131072 && composer.changed(z2)) || (i & 196608) == 131072) | ((((3670016 & i) ^ 1572864) > 1048576 && composer.changed(horizontal)) || (i & 1572864) == 1048576) | ((((29360128 & i) ^ 12582912) > 8388608 && composer.changed(vertical)) || (i & 12582912) == 8388608) | composer.changed(graphicsContext);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = (Function2) new Function2<LazyLayoutMeasureScope, Constraints, LazyGridMeasureResult>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1183invoke0kLqBqw((LazyLayoutMeasureScope) obj, ((Constraints) obj2).unbox-impl());
                }

                public final LazyGridMeasureResult m1183invoke0kLqBqw(final LazyLayoutMeasureScope lazyLayoutMeasureScope, final long j) {
                    int i2;
                    int i3;
                    int i4;
                    float spacing;
                    int i5;
                    long jIntOffset;
                    int lineIndexOfItem;
                    int firstVisibleItemScrollOffset;
                    ObservableScopeInvalidator.m1251attachToScopeimpl(lazyGridState.m1191getMeasurementScopeInvalidatorzYiylxw$foundation_release());
                    CheckScrollableContainerConstraintsKt.m550checkScrollableContainerConstraintsK40F9xA(j, z2 ? Orientation.Vertical : Orientation.Horizontal);
                    if (z2) {
                        i2 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.mo986calculateLeftPaddingu2uoSUM(lazyLayoutMeasureScope.getLayoutDirection()));
                    } else {
                        i2 = lazyLayoutMeasureScope.roundToPx-0680j_4(PaddingKt.calculateStartPadding(paddingValues, lazyLayoutMeasureScope.getLayoutDirection()));
                    }
                    if (z2) {
                        i3 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.mo987calculateRightPaddingu2uoSUM(lazyLayoutMeasureScope.getLayoutDirection()));
                    } else {
                        i3 = lazyLayoutMeasureScope.roundToPx-0680j_4(PaddingKt.calculateEndPadding(paddingValues, lazyLayoutMeasureScope.getLayoutDirection()));
                    }
                    int i6 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.getTop());
                    int i7 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.getBottom());
                    final int i8 = i6 + i7;
                    final int i9 = i2 + i3;
                    boolean z4 = z2;
                    int i10 = z4 ? i8 : i9;
                    if (z4 && !z) {
                        i4 = i6;
                    } else if (z4 && z) {
                        i4 = i7;
                    } else {
                        i4 = (z4 || z) ? i3 : i2;
                    }
                    final int i11 = i10 - i4;
                    long j2 = ConstraintsKt.offset-NN6Ew-U(j, -i9, -i8);
                    final LazyGridItemProvider lazyGridItemProvider = (LazyGridItemProvider) function0.invoke();
                    final LazyGridSpanLayoutProvider spanLayoutProvider = lazyGridItemProvider.getSpanLayoutProvider();
                    LazyLayoutMeasureScope lazyLayoutMeasureScope2 = lazyLayoutMeasureScope;
                    final LazyGridSlots lazyGridSlotsMo1168invoke0kLqBqw = lazyGridSlotsProvider.mo1168invoke0kLqBqw(lazyLayoutMeasureScope2, j);
                    int length = lazyGridSlotsMo1168invoke0kLqBqw.getSizes().length;
                    spanLayoutProvider.setSlotsPerLine(length);
                    if (z2) {
                        Arrangement.Vertical vertical2 = vertical;
                        if (vertical2 == null) {
                            throw new IllegalArgumentException("null verticalArrangement when isVertical == true".toString());
                        }
                        spacing = vertical2.getSpacing();
                    } else {
                        Arrangement.Horizontal horizontal2 = horizontal;
                        if (horizontal2 == null) {
                            throw new IllegalArgumentException("null horizontalArrangement when isVertical == false".toString());
                        }
                        spacing = horizontal2.getSpacing();
                    }
                    final int i12 = lazyLayoutMeasureScope.roundToPx-0680j_4(spacing);
                    final int itemCount = lazyGridItemProvider.getItemCount();
                    if (z2) {
                        i5 = Constraints.getMaxHeight-impl(j) - i8;
                    } else {
                        i5 = Constraints.getMaxWidth-impl(j) - i9;
                    }
                    int i13 = i5;
                    if (!z || i13 > 0) {
                        jIntOffset = IntOffsetKt.IntOffset(i2, i6);
                    } else {
                        boolean z5 = z2;
                        if (!z5) {
                            i2 += i13;
                        }
                        if (z5) {
                            i6 += i13;
                        }
                        jIntOffset = IntOffsetKt.IntOffset(i2, i6);
                    }
                    final long j3 = jIntOffset;
                    final LazyGridState lazyGridState2 = lazyGridState;
                    final boolean z6 = z2;
                    final boolean z7 = z;
                    final int i14 = i4;
                    final ?? r23 = new LazyGridMeasuredItemProvider(lazyGridItemProvider, lazyLayoutMeasureScope, i12, lazyGridState2, z6, z7, i14, i11, j3) {
                        final int $afterContentPadding;
                        final int $beforeContentPadding;
                        final boolean $isVertical;
                        final boolean $reverseLayout;
                        final LazyGridState $state;
                        final LazyLayoutMeasureScope $this_null;
                        final long $visualItemOffset;

                        {
                            this.$this_null = lazyLayoutMeasureScope;
                            this.$state = lazyGridState2;
                            this.$isVertical = z6;
                            this.$reverseLayout = z7;
                            this.$beforeContentPadding = i14;
                            this.$afterContentPadding = i11;
                            this.$visualItemOffset = j3;
                        }

                        @Override
                        public LazyGridMeasuredItem mo1184createItemO3s9Psw(int index, Object key, Object contentType, int crossAxisSize, int mainAxisSpacing, List<? extends Placeable> placeables, long constraints, int lane, int span) {
                            return new LazyGridMeasuredItem(index, key, this.$isVertical, crossAxisSize, mainAxisSpacing, this.$reverseLayout, this.$this_null.getLayoutDirection(), this.$beforeContentPadding, this.$afterContentPadding, placeables, this.$visualItemOffset, contentType, this.$state.getItemAnimator$foundation_release(), constraints, lane, span, null);
                        }
                    };
                    final boolean z8 = z2;
                    final ?? r2 = new LazyGridMeasuredLineProvider(z8, lazyGridSlotsMo1168invoke0kLqBqw, itemCount, i12, r23, spanLayoutProvider) {
                        final boolean $isVertical;
                        final LazyGridSlots $resolvedSlots;

                        {
                            super(z8, lazyGridSlotsMo1168invoke0kLqBqw, itemCount, i12, r23, spanLayoutProvider);
                            this.$isVertical = z8;
                            this.$resolvedSlots = lazyGridSlotsMo1168invoke0kLqBqw;
                        }

                        @Override
                        public LazyGridMeasuredLine createLine(int index, LazyGridMeasuredItem[] items, List<GridItemSpan> spans, int mainAxisSpacing) {
                            return new LazyGridMeasuredLine(index, items, this.$resolvedSlots, spans, this.$isVertical, mainAxisSpacing);
                        }
                    };
                    Function1<Integer, ArrayList<Pair<? extends Integer, ? extends Constraints>>> function1 = new Function1<Integer, ArrayList<Pair<? extends Integer, ? extends Constraints>>>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            return invoke(((Number) obj).intValue());
                        }

                        public final ArrayList<Pair<Integer, Constraints>> invoke(int i15) {
                            LazyGridSpanLayoutProvider.LineConfiguration lineConfiguration = spanLayoutProvider.getLineConfiguration(i15);
                            int firstItemIndex = lineConfiguration.getFirstItemIndex();
                            ArrayList<Pair<Integer, Constraints>> arrayList = new ArrayList<>(lineConfiguration.getSpans().size());
                            List<GridItemSpan> spans = lineConfiguration.getSpans();
                            C0680xaa796ba c0680xaa796ba = r2;
                            int size = spans.size();
                            int i16 = 0;
                            for (int i17 = 0; i17 < size; i17++) {
                                int iM1164getCurrentLineSpanimpl = GridItemSpan.m1164getCurrentLineSpanimpl(spans.get(i17).getPackedValue());
                                arrayList.add(TuplesKt.to(Integer.valueOf(firstItemIndex), Constraints.box-impl(c0680xaa796ba.m1190childConstraintsJhjzzOo$foundation_release(i16, iM1164getCurrentLineSpanimpl))));
                                firstItemIndex++;
                                i16 += iM1164getCurrentLineSpanimpl;
                            }
                            return arrayList;
                        }
                    };
                    Snapshot.Companion companion = Snapshot.INSTANCE;
                    LazyGridState lazyGridState3 = lazyGridState;
                    Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
                    Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
                    Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
                    try {
                        int iUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release = lazyGridState3.updateScrollPositionIfTheFirstItemWasMoved$foundation_release(lazyGridItemProvider, lazyGridState3.getFirstVisibleItemIndex());
                        if (iUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release < itemCount || itemCount <= 0) {
                            lineIndexOfItem = spanLayoutProvider.getLineIndexOfItem(iUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release);
                            firstVisibleItemScrollOffset = lazyGridState3.getFirstVisibleItemScrollOffset();
                        } else {
                            lineIndexOfItem = spanLayoutProvider.getLineIndexOfItem(itemCount - 1);
                            firstVisibleItemScrollOffset = 0;
                        }
                        Unit unit = Unit.INSTANCE;
                        companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                        LazyGridMeasureResult lazyGridMeasureResultM1186measureLazyGridOZKpZRA = LazyGridMeasureKt.m1186measureLazyGridOZKpZRA(itemCount, (LazyGridMeasuredLineProvider) r2, (LazyGridMeasuredItemProvider) r23, i13, i4, i11, i12, lineIndexOfItem, firstVisibleItemScrollOffset, lazyGridState.getScrollToBeConsumed(), j2, z2, vertical, horizontal, z, lazyLayoutMeasureScope2, lazyGridState.getItemAnimator$foundation_release(), length, LazyLayoutBeyondBoundsStateKt.calculateLazyLayoutPinnedIndices(lazyGridItemProvider, lazyGridState.getPinnedItems(), lazyGridState.getBeyondBoundsInfo()), coroutineScope, lazyGridState.m1192getPlacementScopeInvalidatorzYiylxw$foundation_release(), graphicsContext, function1, new Function3<Integer, Integer, Function1<? super Placeable.PlacementScope, ? extends Unit>, MeasureResult>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                return invoke(((Number) obj).intValue(), ((Number) obj2).intValue(), (Function1<? super Placeable.PlacementScope, Unit>) obj3);
                            }

                            public final MeasureResult invoke(int i15, int i16, Function1<? super Placeable.PlacementScope, Unit> function2) {
                                return lazyLayoutMeasureScope.layout(ConstraintsKt.constrainWidth-K40F9xA(j, i15 + i9), ConstraintsKt.constrainHeight-K40F9xA(j, i16 + i8), MapsKt.emptyMap(), function2);
                            }
                        });
                        LazyGridState.applyMeasureResult$foundation_release$default(lazyGridState, lazyGridMeasureResultM1186measureLazyGridOZKpZRA, false, 2, null);
                        return lazyGridMeasureResultM1186measureLazyGridOZKpZRA;
                    } catch (Throwable th) {
                        companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                        throw th;
                    }
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2 = (Function2) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return function2;
    }
}
