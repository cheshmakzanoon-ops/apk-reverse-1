package androidx.compose.foundation.lazy;

import androidx.compose.foundation.CheckScrollableContainerConstraintsKt;
import androidx.compose.foundation.ScrollingContainerKt;
import androidx.compose.foundation.gestures.FlingBehavior;
import androidx.compose.foundation.gestures.Orientation;
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
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.IntOffsetKt;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.collections.MapsKt;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\u0082\u0001\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u0098\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\t2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\t2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00132\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u00152\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\u00172\u0017\u0010\u0018\u001a\u0013\u0012\u0004\u0012\u00020\u001a\u0012\u0004\u0012\u00020\u00010\u0019¢\u0006\u0002\b\u001bH\u0001¢\u0006\u0002\u0010\u001c\u001a\u009a\u0001\u0010\u001d\u001a\u0019\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020 \u0012\u0004\u0012\u00020!0\u001e¢\u0006\u0002\b\u001b2\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020$0#2\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u00112\b\u0010\u0014\u001a\u0004\u0018\u00010\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u00172\b\u0010\u0012\u001a\u0004\u0018\u00010\u00132\u0006\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020\tH\u0003¢\u0006\u0002\u0010*¨\u0006+"}, d2 = {"LazyList", "", "modifier", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/lazy/LazyListState;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "reverseLayout", "", "isVertical", "flingBehavior", "Landroidx/compose/foundation/gestures/FlingBehavior;", "userScrollEnabled", "beyondBoundsItemCount", "", "horizontalAlignment", "Landroidx/compose/ui/Alignment$Horizontal;", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "verticalAlignment", "Landroidx/compose/ui/Alignment$Vertical;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/lazy/LazyListScope;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/LazyListState;Landroidx/compose/foundation/layout/PaddingValues;ZZLandroidx/compose/foundation/gestures/FlingBehavior;ZILandroidx/compose/ui/Alignment$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/ui/Alignment$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;III)V", "rememberLazyListMeasurePolicy", "Lkotlin/Function2;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;", "Landroidx/compose/ui/unit/Constraints;", "Landroidx/compose/ui/layout/MeasureResult;", "itemProviderLambda", "Lkotlin/Function0;", "Landroidx/compose/foundation/lazy/LazyListItemProvider;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "stickyHeadersEnabled", "(Lkotlin/jvm/functions/Function0;Landroidx/compose/foundation/lazy/LazyListState;Landroidx/compose/foundation/layout/PaddingValues;ZZILandroidx/compose/ui/Alignment$Horizontal;Landroidx/compose/ui/Alignment$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;Lkotlinx/coroutines/CoroutineScope;Landroidx/compose/ui/graphics/GraphicsContext;ZLandroidx/compose/runtime/Composer;II)Lkotlin/jvm/functions/Function2;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyListKt {
    public static final void LazyList(final Modifier modifier, final LazyListState lazyListState, final PaddingValues paddingValues, final boolean z, final boolean z2, final FlingBehavior flingBehavior, final boolean z3, int i, Alignment.Horizontal horizontal, Arrangement.Vertical vertical, Alignment.Vertical vertical2, Arrangement.Horizontal horizontal2, final Function1<? super LazyListScope, Unit> function1, Composer composer, final int i2, final int i3, final int i4) {
        int i5;
        int i6;
        int i7;
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
        int i19;
        int i20;
        int i21;
        int i22;
        Alignment.Horizontal horizontal3;
        Arrangement.Vertical vertical3;
        Alignment.Vertical vertical4;
        Arrangement.Horizontal horizontal4;
        Object objRememberedValue;
        Orientation orientation;
        Composer composer2;
        final int i23;
        final Alignment.Horizontal horizontal5;
        final Arrangement.Vertical vertical5;
        final Alignment.Vertical vertical6;
        final Arrangement.Horizontal horizontal6;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(620764179);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyList)P(7,9,2,8,6,3,10!1,4,12,11,5)81@3859L50,83@3935L48,84@4009L24,85@4081L7,86@4150L7,88@4183L395,109@4816L278,117@5164L153,123@5480L7,116@5108L481,128@5650L317,105@4671L1429:LazyList.kt#428nma");
        if ((i4 & 1) != 0) {
            i5 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            i5 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i2;
        } else {
            i5 = i2;
        }
        if ((i4 & 2) != 0) {
            i5 |= 48;
        } else if ((i2 & 48) == 0) {
            i5 |= composerStartRestartGroup.changed(lazyListState) ? 32 : 16;
        }
        int i24 = i4 & 4;
        int i25 = Fields.SpotShadowColor;
        if (i24 == 0) {
            if ((i2 & 384) == 0) {
                i5 |= composerStartRestartGroup.changed(paddingValues) ? Fields.RotationX : 128;
            }
            if ((i4 & 8) != 0) {
                if ((i2 & 3072) == 0) {
                    if (composerStartRestartGroup.changed(z)) {
                        i6 = Fields.CameraDistance;
                    } else {
                        i6 = Fields.RotationZ;
                    }
                    i5 |= i6;
                }
                if ((i4 & 16) != 0) {
                    i5 |= 24576;
                } else if ((i2 & 24576) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i5 |= i7;
                }
                if ((i4 & 32) != 0) {
                    if ((i2 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flingBehavior)) {
                            i8 = Fields.RenderEffect;
                        } else {
                            i8 = 65536;
                        }
                        i5 |= i8;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i2 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(z3)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i5 |= i9;
                    }
                    i10 = i4 & Fields.SpotShadowColor;
                    if (i10 != 0) {
                        i5 |= 12582912;
                    } else if ((i2 & 12582912) == 0) {
                        if (composerStartRestartGroup.changed(i)) {
                            i11 = 8388608;
                        } else {
                            i11 = 4194304;
                        }
                        i5 |= i11;
                    }
                    i12 = i4 & Fields.RotationX;
                    if (i12 != 0) {
                        i5 |= 100663296;
                    } else if ((i2 & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & Fields.RotationY;
                    if (i14 != 0) {
                        i5 |= 805306368;
                    } else if ((i2 & 805306368) == 0) {
                        if (composerStartRestartGroup.changed(vertical)) {
                            i15 = 536870912;
                        } else {
                            i15 = 268435456;
                        }
                        i5 |= i15;
                    }
                    i16 = i4 & Fields.RotationZ;
                    if (i16 != 0) {
                        i17 = i3 | 6;
                    } else if ((i3 & 6) == 0) {
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i18 = 4;
                        } else {
                            i18 = 2;
                        }
                        i17 = i3 | i18;
                    } else {
                        i17 = i3;
                    }
                    i19 = i4 & Fields.CameraDistance;
                    if (i19 != 0) {
                        i17 |= 48;
                    } else if ((i3 & 48) == 0) {
                        if (composerStartRestartGroup.changed(horizontal2)) {
                            i20 = 32;
                        } else {
                            i20 = 16;
                        }
                        i17 |= i20;
                    }
                    i21 = i17;
                    if ((i4 & Fields.TransformOrigin) != 0) {
                        i21 |= 384;
                    } else if ((i3 & 384) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i25 = Fields.RotationX;
                        }
                        i21 |= i25;
                    }
                    if ((306783379 & i5) == 306783378 || (i21 & 147) != 146 || !composerStartRestartGroup.getSkipping()) {
                        if (i10 != 0) {
                            i22 = 0;
                        } else {
                            i22 = i;
                        }
                        if (i12 != 0) {
                            horizontal3 = null;
                        } else {
                            horizontal3 = horizontal;
                        }
                        if (i14 != 0) {
                            vertical3 = null;
                        } else {
                            vertical3 = vertical;
                        }
                        if (i16 != 0) {
                            vertical4 = null;
                        } else {
                            vertical4 = vertical2;
                        }
                        if (i19 != 0) {
                            horizontal4 = null;
                        } else {
                            horizontal4 = horizontal2;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                        }
                        int i26 = (i5 >> 3) & 14;
                        Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i26 | ((i21 >> 3) & 112));
                        int i27 = i5 >> 9;
                        LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i26 | (i27 & 112));
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
                        GraphicsContext graphicsContext = (GraphicsContext) objConsume;
                        CompositionLocal<Boolean> localScrollCaptureInProgress = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume2 = composerStartRestartGroup.consume(localScrollCaptureInProgress);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i28 = i5 & 112;
                        int i29 = i5 & 7168;
                        int i30 = i5 >> 6;
                        int i31 = i21 << 21;
                        int i32 = i5;
                        int i33 = i22;
                        Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope, graphicsContext, !((Boolean) objConsume2).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i30 & 458752) | (i30 & 3670016) | (29360128 & i31) | (i31 & 234881024) | (1879048192 & i5), 0);
                        if (z2) {
                            orientation = Orientation.Vertical;
                        } else {
                            orientation = Orientation.Horizontal;
                        }
                        Orientation orientation2 = orientation;
                        Modifier modifierLazyLayoutSemantics = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda, lazyLayoutSemanticStateRememberLazyListSemanticState, orientation2, z3, z, composerStartRestartGroup, (i30 & 57344) | ((i32 << 6) & 458752));
                        composer2 = composerStartRestartGroup;
                        LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i33, composer2, i26 | ((i32 >> 18) & 112));
                        LazyLayoutBeyondBoundsInfo beyondBoundsInfo = lazyListState.getBeyondBoundsInfo();
                        ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                        ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                        Object objConsume3 = composer2.consume(localLayoutDirection);
                        ComposerKt.sourceInformationMarkerEnd(composer2);
                        LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState, beyondBoundsInfo, z, (LayoutDirection) objConsume3, orientation2, z3, composer2, (MutableVector.$stable << 6) | i29 | (i32 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation2, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i28 | (i27 & 7168) | (57344 & (i32 << 3)) | (i32 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy, composer2, 0, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        i23 = i33;
                        horizontal5 = horizontal3;
                        vertical5 = vertical3;
                        vertical6 = vertical4;
                        horizontal6 = horizontal4;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        i23 = i;
                        horizontal5 = horizontal;
                        vertical6 = vertical2;
                        horizontal6 = horizontal2;
                        composer2 = composerStartRestartGroup;
                        vertical5 = vertical;
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

                            public final void invoke(Composer composer3, int i34) {
                                LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                            }
                        });
                    }
                }
                i5 |= 196608;
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i5 |= i9;
                }
                i10 = i4 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i5 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i5 |= i11;
                }
                i12 = i4 & Fields.RotationX;
                if (i12 != 0) {
                    i5 |= 100663296;
                } else if ((i2 & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i5 |= i13;
                }
                i14 = i4 & Fields.RotationY;
                if (i14 != 0) {
                    i5 |= 805306368;
                } else if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(vertical)) {
                        i15 = 536870912;
                    } else {
                        i15 = 268435456;
                    }
                    i5 |= i15;
                }
                i16 = i4 & Fields.RotationZ;
                if (i16 != 0) {
                    i17 = i3 | 6;
                } else if ((i3 & 6) == 0) {
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i18 = 4;
                    } else {
                        i18 = 2;
                    }
                    i17 = i3 | i18;
                } else {
                    i17 = i3;
                }
                i19 = i4 & Fields.CameraDistance;
                if (i19 != 0) {
                    i17 |= 48;
                } else if ((i3 & 48) == 0) {
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i20 = 32;
                    } else {
                        i20 = 16;
                    }
                    i17 |= i20;
                }
                i21 = i17;
                if ((i4 & Fields.TransformOrigin) != 0) {
                    i21 |= 384;
                } else if ((i3 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i25 = Fields.RotationX;
                    }
                    i21 |= i25;
                }
                if ((306783379 & i5) == 306783378) {
                    if (i10 != 0) {
                        i22 = 0;
                    } else {
                        i22 = i;
                    }
                    if (i12 != 0) {
                        horizontal3 = null;
                    } else {
                        horizontal3 = horizontal;
                    }
                    if (i14 != 0) {
                        vertical3 = null;
                    } else {
                        vertical3 = vertical;
                    }
                    if (i16 != 0) {
                        vertical4 = null;
                    } else {
                        vertical4 = vertical2;
                    }
                    if (i19 != 0) {
                        horizontal4 = null;
                    } else {
                        horizontal4 = horizontal2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                    }
                    int i210 = (i5 >> 3) & 14;
                    Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda2 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i210 | ((i21 >> 3) & 112));
                    int i211 = i5 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState2 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i210 | (i211 & 112));
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
                    Object objConsume4 = composerStartRestartGroup.consume(localGraphicsContext2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    GraphicsContext graphicsContext2 = (GraphicsContext) objConsume4;
                    CompositionLocal<Boolean> localScrollCaptureInProgress2 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume5 = composerStartRestartGroup.consume(localScrollCaptureInProgress2);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i212 = i5 & 112;
                    int i213 = i5 & 7168;
                    int i34 = i5 >> 6;
                    int i35 = i21 << 21;
                    int i36 = i5;
                    int i37 = i22;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy2 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda2, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope2, graphicsContext2, !((Boolean) objConsume5).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i34 & 458752) | (i34 & 3670016) | (29360128 & i35) | (i35 & 234881024) | (1879048192 & i5), 0);
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation3 = orientation;
                    Modifier modifierLazyLayoutSemantics2 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda2, lazyLayoutSemanticStateRememberLazyListSemanticState2, orientation3, z3, z, composerStartRestartGroup, (i34 & 57344) | ((i36 << 6) & 458752));
                    composer2 = composerStartRestartGroup;
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState2 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i37, composer2, i210 | ((i36 >> 18) & 112));
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo2 = lazyListState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume6 = composer2.consume(localLayoutDirection2);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda2, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics2, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState2, beyondBoundsInfo2, z, (LayoutDirection) objConsume6, orientation3, z3, composer2, (MutableVector.$stable << 6) | i213 | (i36 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation3, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i212 | (i211 & 7168) | (57344 & (i36 << 3)) | (i36 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy2, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i23 = i37;
                    horizontal5 = horizontal3;
                    vertical5 = vertical3;
                    vertical6 = vertical4;
                    horizontal6 = horizontal4;
                } else {
                    if (i10 != 0) {
                        i22 = 0;
                    } else {
                        i22 = i;
                    }
                    if (i12 != 0) {
                        horizontal3 = null;
                    } else {
                        horizontal3 = horizontal;
                    }
                    if (i14 != 0) {
                        vertical3 = null;
                    } else {
                        vertical3 = vertical;
                    }
                    if (i16 != 0) {
                        vertical4 = null;
                    } else {
                        vertical4 = vertical2;
                    }
                    if (i19 != 0) {
                        horizontal4 = null;
                    } else {
                        horizontal4 = horizontal2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                    }
                    int i214 = (i5 >> 3) & 14;
                    Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda3 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i214 | ((i21 >> 3) & 112));
                    int i215 = i5 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState3 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i214 | (i215 & 112));
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
                    Object objConsume7 = composerStartRestartGroup.consume(localGraphicsContext3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    GraphicsContext graphicsContext3 = (GraphicsContext) objConsume7;
                    CompositionLocal<Boolean> localScrollCaptureInProgress3 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume8 = composerStartRestartGroup.consume(localScrollCaptureInProgress3);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i216 = i5 & 112;
                    int i217 = i5 & 7168;
                    int i38 = i5 >> 6;
                    int i39 = i21 << 21;
                    int i310 = i5;
                    int i311 = i22;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy3 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda3, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope3, graphicsContext3, !((Boolean) objConsume8).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i38 & 458752) | (i38 & 3670016) | (29360128 & i39) | (i39 & 234881024) | (1879048192 & i5), 0);
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation4 = orientation;
                    Modifier modifierLazyLayoutSemantics3 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda3, lazyLayoutSemanticStateRememberLazyListSemanticState3, orientation4, z3, z, composerStartRestartGroup, (i38 & 57344) | ((i310 << 6) & 458752));
                    composer2 = composerStartRestartGroup;
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState3 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i311, composer2, i214 | ((i310 >> 18) & 112));
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo3 = lazyListState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume9 = composer2.consume(localLayoutDirection3);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda3, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics3, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState3, beyondBoundsInfo3, z, (LayoutDirection) objConsume9, orientation4, z3, composer2, (MutableVector.$stable << 6) | i217 | (i310 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation4, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i216 | (i215 & 7168) | (57344 & (i310 << 3)) | (i310 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy3, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i23 = i311;
                    horizontal5 = horizontal3;
                    vertical5 = vertical3;
                    vertical6 = vertical4;
                    horizontal6 = horizontal4;
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

                        public final void invoke(Composer composer3, int i312) {
                            LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            if ((i4 & 16) != 0) {
                i5 |= 24576;
            } else if ((i2 & 24576) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i5 |= i7;
            }
            if ((i4 & 32) != 0) {
                if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flingBehavior)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i5 |= i8;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i5 |= i9;
                }
                i10 = i4 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i5 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i5 |= i11;
                }
                i12 = i4 & Fields.RotationX;
                if (i12 != 0) {
                    i5 |= 100663296;
                } else if ((i2 & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i5 |= i13;
                }
                i14 = i4 & Fields.RotationY;
                if (i14 != 0) {
                    i5 |= 805306368;
                } else if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(vertical)) {
                        i15 = 536870912;
                    } else {
                        i15 = 268435456;
                    }
                    i5 |= i15;
                }
                i16 = i4 & Fields.RotationZ;
                if (i16 != 0) {
                    i17 = i3 | 6;
                } else if ((i3 & 6) == 0) {
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i18 = 4;
                    } else {
                        i18 = 2;
                    }
                    i17 = i3 | i18;
                } else {
                    i17 = i3;
                }
                i19 = i4 & Fields.CameraDistance;
                if (i19 != 0) {
                    i17 |= 48;
                } else if ((i3 & 48) == 0) {
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i20 = 32;
                    } else {
                        i20 = 16;
                    }
                    i17 |= i20;
                }
                i21 = i17;
                if ((i4 & Fields.TransformOrigin) != 0) {
                    i21 |= 384;
                } else if ((i3 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i25 = Fields.RotationX;
                    }
                    i21 |= i25;
                }
                if ((306783379 & i5) == 306783378) {
                    if (i10 != 0) {
                        i22 = 0;
                    } else {
                        i22 = i;
                    }
                    if (i12 != 0) {
                        horizontal3 = null;
                    } else {
                        horizontal3 = horizontal;
                    }
                    if (i14 != 0) {
                        vertical3 = null;
                    } else {
                        vertical3 = vertical;
                    }
                    if (i16 != 0) {
                        vertical4 = null;
                    } else {
                        vertical4 = vertical2;
                    }
                    if (i19 != 0) {
                        horizontal4 = null;
                    } else {
                        horizontal4 = horizontal2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                    }
                    int i218 = (i5 >> 3) & 14;
                    Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda4 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i218 | ((i21 >> 3) & 112));
                    int i219 = i5 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState4 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i218 | (i219 & 112));
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
                    Object objConsume10 = composerStartRestartGroup.consume(localGraphicsContext4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    GraphicsContext graphicsContext4 = (GraphicsContext) objConsume10;
                    CompositionLocal<Boolean> localScrollCaptureInProgress4 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume11 = composerStartRestartGroup.consume(localScrollCaptureInProgress4);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2110 = i5 & 112;
                    int i2111 = i5 & 7168;
                    int i312 = i5 >> 6;
                    int i313 = i21 << 21;
                    int i314 = i5;
                    int i315 = i22;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy4 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda4, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope4, graphicsContext4, !((Boolean) objConsume11).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i312 & 458752) | (i312 & 3670016) | (29360128 & i313) | (i313 & 234881024) | (1879048192 & i5), 0);
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation5 = orientation;
                    Modifier modifierLazyLayoutSemantics4 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda4, lazyLayoutSemanticStateRememberLazyListSemanticState4, orientation5, z3, z, composerStartRestartGroup, (i312 & 57344) | ((i314 << 6) & 458752));
                    composer2 = composerStartRestartGroup;
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState4 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i315, composer2, i218 | ((i314 >> 18) & 112));
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo4 = lazyListState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume12 = composer2.consume(localLayoutDirection4);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda4, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics4, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState4, beyondBoundsInfo4, z, (LayoutDirection) objConsume12, orientation5, z3, composer2, (MutableVector.$stable << 6) | i2111 | (i314 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation5, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i2110 | (i219 & 7168) | (57344 & (i314 << 3)) | (i314 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy4, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i23 = i315;
                    horizontal5 = horizontal3;
                    vertical5 = vertical3;
                    vertical6 = vertical4;
                    horizontal6 = horizontal4;
                } else {
                    if (i10 != 0) {
                        i22 = 0;
                    } else {
                        i22 = i;
                    }
                    if (i12 != 0) {
                        horizontal3 = null;
                    } else {
                        horizontal3 = horizontal;
                    }
                    if (i14 != 0) {
                        vertical3 = null;
                    } else {
                        vertical3 = vertical;
                    }
                    if (i16 != 0) {
                        vertical4 = null;
                    } else {
                        vertical4 = vertical2;
                    }
                    if (i19 != 0) {
                        horizontal4 = null;
                    } else {
                        horizontal4 = horizontal2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                    }
                    int i2112 = (i5 >> 3) & 14;
                    Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda5 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i2112 | ((i21 >> 3) & 112));
                    int i2113 = i5 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState5 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i2112 | (i2113 & 112));
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
                    Object objConsume13 = composerStartRestartGroup.consume(localGraphicsContext5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    GraphicsContext graphicsContext5 = (GraphicsContext) objConsume13;
                    CompositionLocal<Boolean> localScrollCaptureInProgress5 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume14 = composerStartRestartGroup.consume(localScrollCaptureInProgress5);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2114 = i5 & 112;
                    int i2115 = i5 & 7168;
                    int i316 = i5 >> 6;
                    int i317 = i21 << 21;
                    int i318 = i5;
                    int i319 = i22;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy5 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda5, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope5, graphicsContext5, !((Boolean) objConsume14).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i316 & 458752) | (i316 & 3670016) | (29360128 & i317) | (i317 & 234881024) | (1879048192 & i5), 0);
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation6 = orientation;
                    Modifier modifierLazyLayoutSemantics5 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda5, lazyLayoutSemanticStateRememberLazyListSemanticState5, orientation6, z3, z, composerStartRestartGroup, (i316 & 57344) | ((i318 << 6) & 458752));
                    composer2 = composerStartRestartGroup;
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState5 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i319, composer2, i2112 | ((i318 >> 18) & 112));
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo5 = lazyListState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume15 = composer2.consume(localLayoutDirection5);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda5, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics5, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState5, beyondBoundsInfo5, z, (LayoutDirection) objConsume15, orientation6, z3, composer2, (MutableVector.$stable << 6) | i2115 | (i318 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation6, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i2114 | (i2113 & 7168) | (57344 & (i318 << 3)) | (i318 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy5, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i23 = i319;
                    horizontal5 = horizontal3;
                    vertical5 = vertical3;
                    vertical6 = vertical4;
                    horizontal6 = horizontal4;
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

                        public final void invoke(Composer composer3, int i3110) {
                            LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                        }
                    });
                }
            }
            i5 |= 196608;
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i5 |= i9;
            }
            i10 = i4 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i5 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i11 = 8388608;
                } else {
                    i11 = 4194304;
                }
                i5 |= i11;
            }
            i12 = i4 & Fields.RotationX;
            if (i12 != 0) {
                i5 |= 100663296;
            } else if ((i2 & 100663296) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i5 |= i13;
            }
            i14 = i4 & Fields.RotationY;
            if (i14 != 0) {
                i5 |= 805306368;
            } else if ((i2 & 805306368) == 0) {
                if (composerStartRestartGroup.changed(vertical)) {
                    i15 = 536870912;
                } else {
                    i15 = 268435456;
                }
                i5 |= i15;
            }
            i16 = i4 & Fields.RotationZ;
            if (i16 != 0) {
                i17 = i3 | 6;
            } else if ((i3 & 6) == 0) {
                if (composerStartRestartGroup.changed(vertical2)) {
                    i18 = 4;
                } else {
                    i18 = 2;
                }
                i17 = i3 | i18;
            } else {
                i17 = i3;
            }
            i19 = i4 & Fields.CameraDistance;
            if (i19 != 0) {
                i17 |= 48;
            } else if ((i3 & 48) == 0) {
                if (composerStartRestartGroup.changed(horizontal2)) {
                    i20 = 32;
                } else {
                    i20 = 16;
                }
                i17 |= i20;
            }
            i21 = i17;
            if ((i4 & Fields.TransformOrigin) != 0) {
                i21 |= 384;
            } else if ((i3 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i25 = Fields.RotationX;
                }
                i21 |= i25;
            }
            if ((306783379 & i5) == 306783378) {
                if (i10 != 0) {
                    i22 = 0;
                } else {
                    i22 = i;
                }
                if (i12 != 0) {
                    horizontal3 = null;
                } else {
                    horizontal3 = horizontal;
                }
                if (i14 != 0) {
                    vertical3 = null;
                } else {
                    vertical3 = vertical;
                }
                if (i16 != 0) {
                    vertical4 = null;
                } else {
                    vertical4 = vertical2;
                }
                if (i19 != 0) {
                    horizontal4 = null;
                } else {
                    horizontal4 = horizontal2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                }
                int i2116 = (i5 >> 3) & 14;
                Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda6 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i2116 | ((i21 >> 3) & 112));
                int i2117 = i5 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState6 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i2116 | (i2117 & 112));
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
                Object objConsume16 = composerStartRestartGroup.consume(localGraphicsContext6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                GraphicsContext graphicsContext6 = (GraphicsContext) objConsume16;
                CompositionLocal<Boolean> localScrollCaptureInProgress6 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume17 = composerStartRestartGroup.consume(localScrollCaptureInProgress6);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2118 = i5 & 112;
                int i2119 = i5 & 7168;
                int i3110 = i5 >> 6;
                int i3111 = i21 << 21;
                int i3112 = i5;
                int i3113 = i22;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy6 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda6, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope6, graphicsContext6, !((Boolean) objConsume17).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i3110 & 458752) | (i3110 & 3670016) | (29360128 & i3111) | (i3111 & 234881024) | (1879048192 & i5), 0);
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation7 = orientation;
                Modifier modifierLazyLayoutSemantics6 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda6, lazyLayoutSemanticStateRememberLazyListSemanticState6, orientation7, z3, z, composerStartRestartGroup, (i3110 & 57344) | ((i3112 << 6) & 458752));
                composer2 = composerStartRestartGroup;
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState6 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i3113, composer2, i2116 | ((i3112 >> 18) & 112));
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo6 = lazyListState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume18 = composer2.consume(localLayoutDirection6);
                ComposerKt.sourceInformationMarkerEnd(composer2);
                LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda6, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics6, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState6, beyondBoundsInfo6, z, (LayoutDirection) objConsume18, orientation7, z3, composer2, (MutableVector.$stable << 6) | i2119 | (i3112 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation7, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i2118 | (i2117 & 7168) | (57344 & (i3112 << 3)) | (i3112 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy6, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i23 = i3113;
                horizontal5 = horizontal3;
                vertical5 = vertical3;
                vertical6 = vertical4;
                horizontal6 = horizontal4;
            } else {
                if (i10 != 0) {
                    i22 = 0;
                } else {
                    i22 = i;
                }
                if (i12 != 0) {
                    horizontal3 = null;
                } else {
                    horizontal3 = horizontal;
                }
                if (i14 != 0) {
                    vertical3 = null;
                } else {
                    vertical3 = vertical;
                }
                if (i16 != 0) {
                    vertical4 = null;
                } else {
                    vertical4 = vertical2;
                }
                if (i19 != 0) {
                    horizontal4 = null;
                } else {
                    horizontal4 = horizontal2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                }
                int i21110 = (i5 >> 3) & 14;
                Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda7 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i21110 | ((i21 >> 3) & 112));
                int i21111 = i5 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState7 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i21110 | (i21111 & 112));
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
                Object objConsume19 = composerStartRestartGroup.consume(localGraphicsContext7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                GraphicsContext graphicsContext7 = (GraphicsContext) objConsume19;
                CompositionLocal<Boolean> localScrollCaptureInProgress7 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume110 = composerStartRestartGroup.consume(localScrollCaptureInProgress7);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21112 = i5 & 112;
                int i21113 = i5 & 7168;
                int i3114 = i5 >> 6;
                int i3115 = i21 << 21;
                int i3116 = i5;
                int i3117 = i22;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy7 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda7, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope7, graphicsContext7, !((Boolean) objConsume110).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i3114 & 458752) | (i3114 & 3670016) | (29360128 & i3115) | (i3115 & 234881024) | (1879048192 & i5), 0);
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation8 = orientation;
                Modifier modifierLazyLayoutSemantics7 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda7, lazyLayoutSemanticStateRememberLazyListSemanticState7, orientation8, z3, z, composerStartRestartGroup, (i3114 & 57344) | ((i3116 << 6) & 458752));
                composer2 = composerStartRestartGroup;
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState7 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i3117, composer2, i21110 | ((i3116 >> 18) & 112));
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo7 = lazyListState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume111 = composer2.consume(localLayoutDirection7);
                ComposerKt.sourceInformationMarkerEnd(composer2);
                LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda7, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics7, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState7, beyondBoundsInfo7, z, (LayoutDirection) objConsume111, orientation8, z3, composer2, (MutableVector.$stable << 6) | i21113 | (i3116 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation8, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i21112 | (i21111 & 7168) | (57344 & (i3116 << 3)) | (i3116 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy7, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i23 = i3117;
                horizontal5 = horizontal3;
                vertical5 = vertical3;
                vertical6 = vertical4;
                horizontal6 = horizontal4;
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

                    public final void invoke(Composer composer3, int i3118) {
                        LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                    }
                });
            }
        }
        i5 |= 384;
        if ((i4 & 8) != 0) {
            if ((i2 & 3072) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i6 = Fields.CameraDistance;
                } else {
                    i6 = Fields.RotationZ;
                }
                i5 |= i6;
            }
            if ((i4 & 16) != 0) {
                i5 |= 24576;
            } else if ((i2 & 24576) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i5 |= i7;
            }
            if ((i4 & 32) != 0) {
                if ((i2 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flingBehavior)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i5 |= i8;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i2 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(z3)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i5 |= i9;
                }
                i10 = i4 & Fields.SpotShadowColor;
                if (i10 != 0) {
                    i5 |= 12582912;
                } else if ((i2 & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(i)) {
                        i11 = 8388608;
                    } else {
                        i11 = 4194304;
                    }
                    i5 |= i11;
                }
                i12 = i4 & Fields.RotationX;
                if (i12 != 0) {
                    i5 |= 100663296;
                } else if ((i2 & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i5 |= i13;
                }
                i14 = i4 & Fields.RotationY;
                if (i14 != 0) {
                    i5 |= 805306368;
                } else if ((i2 & 805306368) == 0) {
                    if (composerStartRestartGroup.changed(vertical)) {
                        i15 = 536870912;
                    } else {
                        i15 = 268435456;
                    }
                    i5 |= i15;
                }
                i16 = i4 & Fields.RotationZ;
                if (i16 != 0) {
                    i17 = i3 | 6;
                } else if ((i3 & 6) == 0) {
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i18 = 4;
                    } else {
                        i18 = 2;
                    }
                    i17 = i3 | i18;
                } else {
                    i17 = i3;
                }
                i19 = i4 & Fields.CameraDistance;
                if (i19 != 0) {
                    i17 |= 48;
                } else if ((i3 & 48) == 0) {
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i20 = 32;
                    } else {
                        i20 = 16;
                    }
                    i17 |= i20;
                }
                i21 = i17;
                if ((i4 & Fields.TransformOrigin) != 0) {
                    i21 |= 384;
                } else if ((i3 & 384) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i25 = Fields.RotationX;
                    }
                    i21 |= i25;
                }
                if ((306783379 & i5) == 306783378) {
                    if (i10 != 0) {
                        i22 = 0;
                    } else {
                        i22 = i;
                    }
                    if (i12 != 0) {
                        horizontal3 = null;
                    } else {
                        horizontal3 = horizontal;
                    }
                    if (i14 != 0) {
                        vertical3 = null;
                    } else {
                        vertical3 = vertical;
                    }
                    if (i16 != 0) {
                        vertical4 = null;
                    } else {
                        vertical4 = vertical2;
                    }
                    if (i19 != 0) {
                        horizontal4 = null;
                    } else {
                        horizontal4 = horizontal2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                    }
                    int i21114 = (i5 >> 3) & 14;
                    Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda8 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i21114 | ((i21 >> 3) & 112));
                    int i21115 = i5 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState8 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i21114 | (i21115 & 112));
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
                    Object objConsume112 = composerStartRestartGroup.consume(localGraphicsContext8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    GraphicsContext graphicsContext8 = (GraphicsContext) objConsume112;
                    CompositionLocal<Boolean> localScrollCaptureInProgress8 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume113 = composerStartRestartGroup.consume(localScrollCaptureInProgress8);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i21116 = i5 & 112;
                    int i21117 = i5 & 7168;
                    int i3118 = i5 >> 6;
                    int i3119 = i21 << 21;
                    int i31110 = i5;
                    int i31111 = i22;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy8 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda8, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope8, graphicsContext8, !((Boolean) objConsume113).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i3118 & 458752) | (i3118 & 3670016) | (29360128 & i3119) | (i3119 & 234881024) | (1879048192 & i5), 0);
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation9 = orientation;
                    Modifier modifierLazyLayoutSemantics8 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda8, lazyLayoutSemanticStateRememberLazyListSemanticState8, orientation9, z3, z, composerStartRestartGroup, (i3118 & 57344) | ((i31110 << 6) & 458752));
                    composer2 = composerStartRestartGroup;
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState8 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i31111, composer2, i21114 | ((i31110 >> 18) & 112));
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo8 = lazyListState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection8 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume114 = composer2.consume(localLayoutDirection8);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda8, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics8, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState8, beyondBoundsInfo8, z, (LayoutDirection) objConsume114, orientation9, z3, composer2, (MutableVector.$stable << 6) | i21117 | (i31110 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation9, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i21116 | (i21115 & 7168) | (57344 & (i31110 << 3)) | (i31110 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy8, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i23 = i31111;
                    horizontal5 = horizontal3;
                    vertical5 = vertical3;
                    vertical6 = vertical4;
                    horizontal6 = horizontal4;
                } else {
                    if (i10 != 0) {
                        i22 = 0;
                    } else {
                        i22 = i;
                    }
                    if (i12 != 0) {
                        horizontal3 = null;
                    } else {
                        horizontal3 = horizontal;
                    }
                    if (i14 != 0) {
                        vertical3 = null;
                    } else {
                        vertical3 = vertical;
                    }
                    if (i16 != 0) {
                        vertical4 = null;
                    } else {
                        vertical4 = vertical2;
                    }
                    if (i19 != 0) {
                        horizontal4 = null;
                    } else {
                        horizontal4 = horizontal2;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                    }
                    int i21118 = (i5 >> 3) & 14;
                    Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda9 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i21118 | ((i21 >> 3) & 112));
                    int i21119 = i5 >> 9;
                    LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState9 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i21118 | (i21119 & 112));
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
                    Object objConsume115 = composerStartRestartGroup.consume(localGraphicsContext9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    GraphicsContext graphicsContext9 = (GraphicsContext) objConsume115;
                    CompositionLocal<Boolean> localScrollCaptureInProgress9 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume116 = composerStartRestartGroup.consume(localScrollCaptureInProgress9);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211110 = i5 & 112;
                    int i211111 = i5 & 7168;
                    int i31112 = i5 >> 6;
                    int i31113 = i21 << 21;
                    int i31114 = i5;
                    int i31115 = i22;
                    Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy9 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda9, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope9, graphicsContext9, !((Boolean) objConsume116).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i31112 & 458752) | (i31112 & 3670016) | (29360128 & i31113) | (i31113 & 234881024) | (1879048192 & i5), 0);
                    if (z2) {
                        orientation = Orientation.Vertical;
                    } else {
                        orientation = Orientation.Horizontal;
                    }
                    Orientation orientation10 = orientation;
                    Modifier modifierLazyLayoutSemantics9 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda9, lazyLayoutSemanticStateRememberLazyListSemanticState9, orientation10, z3, z, composerStartRestartGroup, (i31112 & 57344) | ((i31114 << 6) & 458752));
                    composer2 = composerStartRestartGroup;
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState9 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i31115, composer2, i21118 | ((i31114 >> 18) & 112));
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo9 = lazyListState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection9 = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume117 = composer2.consume(localLayoutDirection9);
                    ComposerKt.sourceInformationMarkerEnd(composer2);
                    LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda9, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics9, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState9, beyondBoundsInfo9, z, (LayoutDirection) objConsume117, orientation10, z3, composer2, (MutableVector.$stable << 6) | i211111 | (i31114 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation10, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i211110 | (i21119 & 7168) | (57344 & (i31114 << 3)) | (i31114 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy9, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    i23 = i31115;
                    horizontal5 = horizontal3;
                    vertical5 = vertical3;
                    vertical6 = vertical4;
                    horizontal6 = horizontal4;
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

                        public final void invoke(Composer composer3, int i31116) {
                            LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                        }
                    });
                }
            }
            i5 |= 196608;
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i5 |= i9;
            }
            i10 = i4 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i5 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i11 = 8388608;
                } else {
                    i11 = 4194304;
                }
                i5 |= i11;
            }
            i12 = i4 & Fields.RotationX;
            if (i12 != 0) {
                i5 |= 100663296;
            } else if ((i2 & 100663296) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i5 |= i13;
            }
            i14 = i4 & Fields.RotationY;
            if (i14 != 0) {
                i5 |= 805306368;
            } else if ((i2 & 805306368) == 0) {
                if (composerStartRestartGroup.changed(vertical)) {
                    i15 = 536870912;
                } else {
                    i15 = 268435456;
                }
                i5 |= i15;
            }
            i16 = i4 & Fields.RotationZ;
            if (i16 != 0) {
                i17 = i3 | 6;
            } else if ((i3 & 6) == 0) {
                if (composerStartRestartGroup.changed(vertical2)) {
                    i18 = 4;
                } else {
                    i18 = 2;
                }
                i17 = i3 | i18;
            } else {
                i17 = i3;
            }
            i19 = i4 & Fields.CameraDistance;
            if (i19 != 0) {
                i17 |= 48;
            } else if ((i3 & 48) == 0) {
                if (composerStartRestartGroup.changed(horizontal2)) {
                    i20 = 32;
                } else {
                    i20 = 16;
                }
                i17 |= i20;
            }
            i21 = i17;
            if ((i4 & Fields.TransformOrigin) != 0) {
                i21 |= 384;
            } else if ((i3 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i25 = Fields.RotationX;
                }
                i21 |= i25;
            }
            if ((306783379 & i5) == 306783378) {
                if (i10 != 0) {
                    i22 = 0;
                } else {
                    i22 = i;
                }
                if (i12 != 0) {
                    horizontal3 = null;
                } else {
                    horizontal3 = horizontal;
                }
                if (i14 != 0) {
                    vertical3 = null;
                } else {
                    vertical3 = vertical;
                }
                if (i16 != 0) {
                    vertical4 = null;
                } else {
                    vertical4 = vertical2;
                }
                if (i19 != 0) {
                    horizontal4 = null;
                } else {
                    horizontal4 = horizontal2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                }
                int i211112 = (i5 >> 3) & 14;
                Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda10 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i211112 | ((i21 >> 3) & 112));
                int i211113 = i5 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState10 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i211112 | (i211113 & 112));
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
                Object objConsume118 = composerStartRestartGroup.consume(localGraphicsContext10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                GraphicsContext graphicsContext10 = (GraphicsContext) objConsume118;
                CompositionLocal<Boolean> localScrollCaptureInProgress10 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume119 = composerStartRestartGroup.consume(localScrollCaptureInProgress10);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211114 = i5 & 112;
                int i211115 = i5 & 7168;
                int i31116 = i5 >> 6;
                int i31117 = i21 << 21;
                int i31118 = i5;
                int i31119 = i22;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy10 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda10, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope10, graphicsContext10, !((Boolean) objConsume119).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i31116 & 458752) | (i31116 & 3670016) | (29360128 & i31117) | (i31117 & 234881024) | (1879048192 & i5), 0);
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation11 = orientation;
                Modifier modifierLazyLayoutSemantics10 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda10, lazyLayoutSemanticStateRememberLazyListSemanticState10, orientation11, z3, z, composerStartRestartGroup, (i31116 & 57344) | ((i31118 << 6) & 458752));
                composer2 = composerStartRestartGroup;
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState10 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i31119, composer2, i211112 | ((i31118 >> 18) & 112));
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo10 = lazyListState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection10 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1110 = composer2.consume(localLayoutDirection10);
                ComposerKt.sourceInformationMarkerEnd(composer2);
                LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda10, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics10, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState10, beyondBoundsInfo10, z, (LayoutDirection) objConsume1110, orientation11, z3, composer2, (MutableVector.$stable << 6) | i211115 | (i31118 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation11, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i211114 | (i211113 & 7168) | (57344 & (i31118 << 3)) | (i31118 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy10, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i23 = i31119;
                horizontal5 = horizontal3;
                vertical5 = vertical3;
                vertical6 = vertical4;
                horizontal6 = horizontal4;
            } else {
                if (i10 != 0) {
                    i22 = 0;
                } else {
                    i22 = i;
                }
                if (i12 != 0) {
                    horizontal3 = null;
                } else {
                    horizontal3 = horizontal;
                }
                if (i14 != 0) {
                    vertical3 = null;
                } else {
                    vertical3 = vertical;
                }
                if (i16 != 0) {
                    vertical4 = null;
                } else {
                    vertical4 = vertical2;
                }
                if (i19 != 0) {
                    horizontal4 = null;
                } else {
                    horizontal4 = horizontal2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                }
                int i211116 = (i5 >> 3) & 14;
                Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda11 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i211116 | ((i21 >> 3) & 112));
                int i211117 = i5 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState11 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i211116 | (i211117 & 112));
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
                Object objConsume1111 = composerStartRestartGroup.consume(localGraphicsContext11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                GraphicsContext graphicsContext11 = (GraphicsContext) objConsume1111;
                CompositionLocal<Boolean> localScrollCaptureInProgress11 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1112 = composerStartRestartGroup.consume(localScrollCaptureInProgress11);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i211118 = i5 & 112;
                int i211119 = i5 & 7168;
                int i311110 = i5 >> 6;
                int i311111 = i21 << 21;
                int i311112 = i5;
                int i311113 = i22;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy11 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda11, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope11, graphicsContext11, !((Boolean) objConsume1112).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i311110 & 458752) | (i311110 & 3670016) | (29360128 & i311111) | (i311111 & 234881024) | (1879048192 & i5), 0);
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation12 = orientation;
                Modifier modifierLazyLayoutSemantics11 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda11, lazyLayoutSemanticStateRememberLazyListSemanticState11, orientation12, z3, z, composerStartRestartGroup, (i311110 & 57344) | ((i311112 << 6) & 458752));
                composer2 = composerStartRestartGroup;
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState11 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i311113, composer2, i211116 | ((i311112 >> 18) & 112));
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo11 = lazyListState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection11 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1113 = composer2.consume(localLayoutDirection11);
                ComposerKt.sourceInformationMarkerEnd(composer2);
                LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda11, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics11, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState11, beyondBoundsInfo11, z, (LayoutDirection) objConsume1113, orientation12, z3, composer2, (MutableVector.$stable << 6) | i211119 | (i311112 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation12, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i211118 | (i211117 & 7168) | (57344 & (i311112 << 3)) | (i311112 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy11, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i23 = i311113;
                horizontal5 = horizontal3;
                vertical5 = vertical3;
                vertical6 = vertical4;
                horizontal6 = horizontal4;
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

                    public final void invoke(Composer composer3, int i311114) {
                        LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                    }
                });
            }
        }
        i5 |= 3072;
        if ((i4 & 16) != 0) {
            i5 |= 24576;
        } else if ((i2 & 24576) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i7 = Fields.Clip;
            } else {
                i7 = Fields.Shape;
            }
            i5 |= i7;
        }
        if ((i4 & 32) != 0) {
            if ((i2 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flingBehavior)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i5 |= i8;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i2 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(z3)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i5 |= i9;
            }
            i10 = i4 & Fields.SpotShadowColor;
            if (i10 != 0) {
                i5 |= 12582912;
            } else if ((i2 & 12582912) == 0) {
                if (composerStartRestartGroup.changed(i)) {
                    i11 = 8388608;
                } else {
                    i11 = 4194304;
                }
                i5 |= i11;
            }
            i12 = i4 & Fields.RotationX;
            if (i12 != 0) {
                i5 |= 100663296;
            } else if ((i2 & 100663296) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i5 |= i13;
            }
            i14 = i4 & Fields.RotationY;
            if (i14 != 0) {
                i5 |= 805306368;
            } else if ((i2 & 805306368) == 0) {
                if (composerStartRestartGroup.changed(vertical)) {
                    i15 = 536870912;
                } else {
                    i15 = 268435456;
                }
                i5 |= i15;
            }
            i16 = i4 & Fields.RotationZ;
            if (i16 != 0) {
                i17 = i3 | 6;
            } else if ((i3 & 6) == 0) {
                if (composerStartRestartGroup.changed(vertical2)) {
                    i18 = 4;
                } else {
                    i18 = 2;
                }
                i17 = i3 | i18;
            } else {
                i17 = i3;
            }
            i19 = i4 & Fields.CameraDistance;
            if (i19 != 0) {
                i17 |= 48;
            } else if ((i3 & 48) == 0) {
                if (composerStartRestartGroup.changed(horizontal2)) {
                    i20 = 32;
                } else {
                    i20 = 16;
                }
                i17 |= i20;
            }
            i21 = i17;
            if ((i4 & Fields.TransformOrigin) != 0) {
                i21 |= 384;
            } else if ((i3 & 384) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i25 = Fields.RotationX;
                }
                i21 |= i25;
            }
            if ((306783379 & i5) == 306783378) {
                if (i10 != 0) {
                    i22 = 0;
                } else {
                    i22 = i;
                }
                if (i12 != 0) {
                    horizontal3 = null;
                } else {
                    horizontal3 = horizontal;
                }
                if (i14 != 0) {
                    vertical3 = null;
                } else {
                    vertical3 = vertical;
                }
                if (i16 != 0) {
                    vertical4 = null;
                } else {
                    vertical4 = vertical2;
                }
                if (i19 != 0) {
                    horizontal4 = null;
                } else {
                    horizontal4 = horizontal2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                }
                int i2111110 = (i5 >> 3) & 14;
                Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda12 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i2111110 | ((i21 >> 3) & 112));
                int i2111111 = i5 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState12 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i2111110 | (i2111111 & 112));
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
                Object objConsume1114 = composerStartRestartGroup.consume(localGraphicsContext12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                GraphicsContext graphicsContext12 = (GraphicsContext) objConsume1114;
                CompositionLocal<Boolean> localScrollCaptureInProgress12 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1115 = composerStartRestartGroup.consume(localScrollCaptureInProgress12);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111112 = i5 & 112;
                int i2111113 = i5 & 7168;
                int i311114 = i5 >> 6;
                int i311115 = i21 << 21;
                int i311116 = i5;
                int i311117 = i22;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy12 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda12, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope12, graphicsContext12, !((Boolean) objConsume1115).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i311114 & 458752) | (i311114 & 3670016) | (29360128 & i311115) | (i311115 & 234881024) | (1879048192 & i5), 0);
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation13 = orientation;
                Modifier modifierLazyLayoutSemantics12 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda12, lazyLayoutSemanticStateRememberLazyListSemanticState12, orientation13, z3, z, composerStartRestartGroup, (i311114 & 57344) | ((i311116 << 6) & 458752));
                composer2 = composerStartRestartGroup;
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState12 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i311117, composer2, i2111110 | ((i311116 >> 18) & 112));
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo12 = lazyListState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection12 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1116 = composer2.consume(localLayoutDirection12);
                ComposerKt.sourceInformationMarkerEnd(composer2);
                LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda12, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics12, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState12, beyondBoundsInfo12, z, (LayoutDirection) objConsume1116, orientation13, z3, composer2, (MutableVector.$stable << 6) | i2111113 | (i311116 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation13, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i2111112 | (i2111111 & 7168) | (57344 & (i311116 << 3)) | (i311116 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy12, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i23 = i311117;
                horizontal5 = horizontal3;
                vertical5 = vertical3;
                vertical6 = vertical4;
                horizontal6 = horizontal4;
            } else {
                if (i10 != 0) {
                    i22 = 0;
                } else {
                    i22 = i;
                }
                if (i12 != 0) {
                    horizontal3 = null;
                } else {
                    horizontal3 = horizontal;
                }
                if (i14 != 0) {
                    vertical3 = null;
                } else {
                    vertical3 = vertical;
                }
                if (i16 != 0) {
                    vertical4 = null;
                } else {
                    vertical4 = vertical2;
                }
                if (i19 != 0) {
                    horizontal4 = null;
                } else {
                    horizontal4 = horizontal2;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
                }
                int i2111114 = (i5 >> 3) & 14;
                Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda13 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i2111114 | ((i21 >> 3) & 112));
                int i2111115 = i5 >> 9;
                LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState13 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i2111114 | (i2111115 & 112));
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
                Object objConsume1117 = composerStartRestartGroup.consume(localGraphicsContext13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                GraphicsContext graphicsContext13 = (GraphicsContext) objConsume1117;
                CompositionLocal<Boolean> localScrollCaptureInProgress13 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1118 = composerStartRestartGroup.consume(localScrollCaptureInProgress13);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111116 = i5 & 112;
                int i2111117 = i5 & 7168;
                int i311118 = i5 >> 6;
                int i311119 = i21 << 21;
                int i3111110 = i5;
                int i3111111 = i22;
                Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy13 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda13, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope13, graphicsContext13, !((Boolean) objConsume1118).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i311118 & 458752) | (i311118 & 3670016) | (29360128 & i311119) | (i311119 & 234881024) | (1879048192 & i5), 0);
                if (z2) {
                    orientation = Orientation.Vertical;
                } else {
                    orientation = Orientation.Horizontal;
                }
                Orientation orientation14 = orientation;
                Modifier modifierLazyLayoutSemantics13 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda13, lazyLayoutSemanticStateRememberLazyListSemanticState13, orientation14, z3, z, composerStartRestartGroup, (i311118 & 57344) | ((i3111110 << 6) & 458752));
                composer2 = composerStartRestartGroup;
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState13 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i3111111, composer2, i2111114 | ((i3111110 >> 18) & 112));
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo13 = lazyListState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection13 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume1119 = composer2.consume(localLayoutDirection13);
                ComposerKt.sourceInformationMarkerEnd(composer2);
                LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda13, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics13, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState13, beyondBoundsInfo13, z, (LayoutDirection) objConsume1119, orientation14, z3, composer2, (MutableVector.$stable << 6) | i2111117 | (i3111110 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation14, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i2111116 | (i2111115 & 7168) | (57344 & (i3111110 << 3)) | (i3111110 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy13, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                i23 = i3111111;
                horizontal5 = horizontal3;
                vertical5 = vertical3;
                vertical6 = vertical4;
                horizontal6 = horizontal4;
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

                    public final void invoke(Composer composer3, int i3111112) {
                        LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                    }
                });
            }
        }
        i5 |= 196608;
        if ((i4 & 64) != 0) {
            i5 |= 1572864;
        } else if ((i2 & 1572864) == 0) {
            if (composerStartRestartGroup.changed(z3)) {
                i9 = 1048576;
            } else {
                i9 = 524288;
            }
            i5 |= i9;
        }
        i10 = i4 & Fields.SpotShadowColor;
        if (i10 != 0) {
            i5 |= 12582912;
        } else if ((i2 & 12582912) == 0) {
            if (composerStartRestartGroup.changed(i)) {
                i11 = 8388608;
            } else {
                i11 = 4194304;
            }
            i5 |= i11;
        }
        i12 = i4 & Fields.RotationX;
        if (i12 != 0) {
            i5 |= 100663296;
        } else if ((i2 & 100663296) == 0) {
            if (composerStartRestartGroup.changed(horizontal)) {
                i13 = 67108864;
            } else {
                i13 = 33554432;
            }
            i5 |= i13;
        }
        i14 = i4 & Fields.RotationY;
        if (i14 != 0) {
            i5 |= 805306368;
        } else if ((i2 & 805306368) == 0) {
            if (composerStartRestartGroup.changed(vertical)) {
                i15 = 536870912;
            } else {
                i15 = 268435456;
            }
            i5 |= i15;
        }
        i16 = i4 & Fields.RotationZ;
        if (i16 != 0) {
            i17 = i3 | 6;
        } else if ((i3 & 6) == 0) {
            if (composerStartRestartGroup.changed(vertical2)) {
                i18 = 4;
            } else {
                i18 = 2;
            }
            i17 = i3 | i18;
        } else {
            i17 = i3;
        }
        i19 = i4 & Fields.CameraDistance;
        if (i19 != 0) {
            i17 |= 48;
        } else if ((i3 & 48) == 0) {
            if (composerStartRestartGroup.changed(horizontal2)) {
                i20 = 32;
            } else {
                i20 = 16;
            }
            i17 |= i20;
        }
        i21 = i17;
        if ((i4 & Fields.TransformOrigin) != 0) {
            i21 |= 384;
        } else if ((i3 & 384) == 0) {
            if (composerStartRestartGroup.changedInstance(function1)) {
                i25 = Fields.RotationX;
            }
            i21 |= i25;
        }
        if ((306783379 & i5) == 306783378) {
            if (i10 != 0) {
                i22 = 0;
            } else {
                i22 = i;
            }
            if (i12 != 0) {
                horizontal3 = null;
            } else {
                horizontal3 = horizontal;
            }
            if (i14 != 0) {
                vertical3 = null;
            } else {
                vertical3 = vertical;
            }
            if (i16 != 0) {
                vertical4 = null;
            } else {
                vertical4 = vertical2;
            }
            if (i19 != 0) {
                horizontal4 = null;
            } else {
                horizontal4 = horizontal2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
            }
            int i2111118 = (i5 >> 3) & 14;
            Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda14 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i2111118 | ((i21 >> 3) & 112));
            int i2111119 = i5 >> 9;
            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState14 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i2111118 | (i2111119 & 112));
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
            Object objConsume11110 = composerStartRestartGroup.consume(localGraphicsContext14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            GraphicsContext graphicsContext14 = (GraphicsContext) objConsume11110;
            CompositionLocal<Boolean> localScrollCaptureInProgress14 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume11111 = composerStartRestartGroup.consume(localScrollCaptureInProgress14);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21111110 = i5 & 112;
            int i21111111 = i5 & 7168;
            int i3111112 = i5 >> 6;
            int i3111113 = i21 << 21;
            int i3111114 = i5;
            int i3111115 = i22;
            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy14 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda14, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope14, graphicsContext14, !((Boolean) objConsume11111).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i3111112 & 458752) | (i3111112 & 3670016) | (29360128 & i3111113) | (i3111113 & 234881024) | (1879048192 & i5), 0);
            if (z2) {
                orientation = Orientation.Vertical;
            } else {
                orientation = Orientation.Horizontal;
            }
            Orientation orientation15 = orientation;
            Modifier modifierLazyLayoutSemantics14 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda14, lazyLayoutSemanticStateRememberLazyListSemanticState14, orientation15, z3, z, composerStartRestartGroup, (i3111112 & 57344) | ((i3111114 << 6) & 458752));
            composer2 = composerStartRestartGroup;
            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState14 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i3111115, composer2, i2111118 | ((i3111114 >> 18) & 112));
            LazyLayoutBeyondBoundsInfo beyondBoundsInfo14 = lazyListState.getBeyondBoundsInfo();
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection14 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume11112 = composer2.consume(localLayoutDirection14);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda14, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics14, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState14, beyondBoundsInfo14, z, (LayoutDirection) objConsume11112, orientation15, z3, composer2, (MutableVector.$stable << 6) | i21111111 | (i3111114 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation15, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i21111110 | (i2111119 & 7168) | (57344 & (i3111114 << 3)) | (i3111114 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy14, composer2, 0, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i23 = i3111115;
            horizontal5 = horizontal3;
            vertical5 = vertical3;
            vertical6 = vertical4;
            horizontal6 = horizontal4;
        } else {
            if (i10 != 0) {
                i22 = 0;
            } else {
                i22 = i;
            }
            if (i12 != 0) {
                horizontal3 = null;
            } else {
                horizontal3 = horizontal;
            }
            if (i14 != 0) {
                vertical3 = null;
            } else {
                vertical3 = vertical;
            }
            if (i16 != 0) {
                vertical4 = null;
            } else {
                vertical4 = vertical2;
            }
            if (i19 != 0) {
                horizontal4 = null;
            } else {
                horizontal4 = horizontal2;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(620764179, i5, i21, "androidx.compose.foundation.lazy.LazyList (LazyList.kt:80)");
            }
            int i21111112 = (i5 >> 3) & 14;
            Function0<LazyListItemProvider> function0RememberLazyListItemProviderLambda15 = LazyListItemProviderKt.rememberLazyListItemProviderLambda(lazyListState, function1, composerStartRestartGroup, i21111112 | ((i21 >> 3) & 112));
            int i21111113 = i5 >> 9;
            LazyLayoutSemanticState lazyLayoutSemanticStateRememberLazyListSemanticState15 = LazyListSemanticsKt.rememberLazyListSemanticState(lazyListState, z2, composerStartRestartGroup, i21111112 | (i21111113 & 112));
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
            Object objConsume11113 = composerStartRestartGroup.consume(localGraphicsContext15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            GraphicsContext graphicsContext15 = (GraphicsContext) objConsume11113;
            CompositionLocal<Boolean> localScrollCaptureInProgress15 = CompositionLocalsKt.getLocalScrollCaptureInProgress();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume11114 = composerStartRestartGroup.consume(localScrollCaptureInProgress15);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21111114 = i5 & 112;
            int i21111115 = i5 & 7168;
            int i3111116 = i5 >> 6;
            int i3111117 = i21 << 21;
            int i3111118 = i5;
            int i3111119 = i22;
            Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> function2RememberLazyListMeasurePolicy15 = rememberLazyListMeasurePolicy(function0RememberLazyListItemProviderLambda15, lazyListState, paddingValues, z, z2, i22, horizontal3, vertical4, horizontal4, vertical3, coroutineScope15, graphicsContext15, !((Boolean) objConsume11114).booleanValue(), composerStartRestartGroup, (65520 & i5) | (i3111116 & 458752) | (i3111116 & 3670016) | (29360128 & i3111117) | (i3111117 & 234881024) | (1879048192 & i5), 0);
            if (z2) {
                orientation = Orientation.Vertical;
            } else {
                orientation = Orientation.Horizontal;
            }
            Orientation orientation16 = orientation;
            Modifier modifierLazyLayoutSemantics15 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier.then(lazyListState.getRemeasurementModifier()).then(lazyListState.getAwaitLayoutModifier()), function0RememberLazyListItemProviderLambda15, lazyLayoutSemanticStateRememberLazyListSemanticState15, orientation16, z3, z, composerStartRestartGroup, (i3111116 & 57344) | ((i3111118 << 6) & 458752));
            composer2 = composerStartRestartGroup;
            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState15 = LazyListBeyondBoundsModifierKt.rememberLazyListBeyondBoundsState(lazyListState, i3111119, composer2, i21111112 | ((i3111118 >> 18) & 112));
            LazyLayoutBeyondBoundsInfo beyondBoundsInfo15 = lazyListState.getBeyondBoundsInfo();
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection15 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composer2, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume11115 = composer2.consume(localLayoutDirection15);
            ComposerKt.sourceInformationMarkerEnd(composer2);
            LazyLayoutKt.LazyLayout(function0RememberLazyListItemProviderLambda15, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics15, lazyLayoutBeyondBoundsStateRememberLazyListBeyondBoundsState15, beyondBoundsInfo15, z, (LayoutDirection) objConsume11115, orientation16, z3, composer2, (MutableVector.$stable << 6) | i21111115 | (i3111118 & 3670016)).then(lazyListState.getItemAnimator$foundation_release().getModifier()), lazyListState, orientation16, z3, z, flingBehavior, lazyListState.getInternalInteractionSource(), null, composer2, i21111114 | (i21111113 & 7168) | (57344 & (i3111118 << 3)) | (i3111118 & 458752), 64), lazyListState.getPrefetchState(), function2RememberLazyListMeasurePolicy15, composer2, 0, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            i23 = i3111119;
            horizontal5 = horizontal3;
            vertical5 = vertical3;
            vertical6 = vertical4;
            horizontal6 = horizontal4;
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

                public final void invoke(Composer composer3, int i31111110) {
                    LazyListKt.LazyList(modifier, lazyListState, paddingValues, z, z2, flingBehavior, z3, i23, horizontal5, vertical5, vertical6, horizontal6, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i2 | 1), RecomposeScopeImplKt.updateChangedFlags(i3), i4);
                }
            });
        }
    }

    private static final Function2<LazyLayoutMeasureScope, Constraints, MeasureResult> rememberLazyListMeasurePolicy(final Function0<? extends LazyListItemProvider> function0, final LazyListState lazyListState, final PaddingValues paddingValues, final boolean z, final boolean z2, final int i, final Alignment.Horizontal horizontal, final Alignment.Vertical vertical, final Arrangement.Horizontal horizontal2, final Arrangement.Vertical vertical2, final CoroutineScope coroutineScope, final GraphicsContext graphicsContext, final boolean z3, Composer composer, int i2, int i3) {
        boolean z4;
        boolean z5;
        boolean z6;
        boolean z7;
        ComposerKt.sourceInformationMarkerStart(composer, 1972347046, "C(rememberLazyListMeasurePolicy)P(7,9,1,8,6!1,4,11,5,12)170@7305L8413:LazyList.kt#428nma");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1972347046, i2, i3, "androidx.compose.foundation.lazy.rememberLazyListMeasurePolicy (LazyList.kt:170)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 581121742, "CC(remember):LazyList.kt#9igjgp");
        if (((i2 & 112) ^ 48) > 32 && composer.changed(lazyListState)) {
            z4 = true;
        } else if ((i2 & 48) == 32) {
            z4 = true;
        } else {
            z4 = false;
        }
        boolean z8 = z4 | ((((i2 & 896) ^ 384) > 256 && composer.changed(paddingValues)) || (i2 & 384) == 256) | ((((i2 & 7168) ^ 3072) > 2048 && composer.changed(z)) || (i2 & 3072) == 2048) | ((((57344 & i2) ^ 24576) > 16384 && composer.changed(z2)) || (i2 & 24576) == 16384) | ((((3670016 & i2) ^ 1572864) > 1048576 && composer.changed(horizontal)) || (i2 & 1572864) == 1048576) | ((((29360128 & i2) ^ 12582912) > 8388608 && composer.changed(vertical)) || (i2 & 12582912) == 8388608);
        if (((234881024 & i2) ^ 100663296) > 67108864 && composer.changed(horizontal2)) {
            z5 = true;
        } else if ((100663296 & i2) == 67108864) {
            z5 = true;
        } else {
            z5 = false;
        }
        boolean z9 = z8 | z5;
        if (((1879048192 & i2) ^ 805306368) > 536870912 && composer.changed(vertical2)) {
            z6 = true;
        } else if ((i2 & 805306368) == 536870912) {
            z6 = true;
        } else {
            z6 = false;
        }
        boolean zChanged = z6 | z9 | composer.changed(graphicsContext);
        if (((i3 & 896) ^ 384) > 256 && composer.changed(z3)) {
            z7 = true;
        } else if ((i3 & 384) == 256) {
            z7 = true;
        } else {
            z7 = false;
        }
        boolean z10 = zChanged | z7;
        Object objRememberedValue = composer.rememberedValue();
        if (z10 || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = (Function2) new Function2<LazyLayoutMeasureScope, Constraints, LazyListMeasureResult>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1140invoke0kLqBqw((LazyLayoutMeasureScope) obj, ((Constraints) obj2).unbox-impl());
                }

                public final LazyListMeasureResult m1140invoke0kLqBqw(final LazyLayoutMeasureScope lazyLayoutMeasureScope, final long j) {
                    int i4;
                    int i5;
                    int i6;
                    float spacing;
                    int i7;
                    long jIntOffset;
                    float scrollToBeConsumed;
                    List<Integer> listEmptyList;
                    ObservableScopeInvalidator.m1251attachToScopeimpl(lazyListState.m1156getMeasurementScopeInvalidatorzYiylxw$foundation_release());
                    boolean z11 = lazyListState.getHasLookaheadPassOccurred() || lazyLayoutMeasureScope.isLookingAhead();
                    CheckScrollableContainerConstraintsKt.m550checkScrollableContainerConstraintsK40F9xA(j, z2 ? Orientation.Vertical : Orientation.Horizontal);
                    if (z2) {
                        i4 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.mo986calculateLeftPaddingu2uoSUM(lazyLayoutMeasureScope.getLayoutDirection()));
                    } else {
                        i4 = lazyLayoutMeasureScope.roundToPx-0680j_4(PaddingKt.calculateStartPadding(paddingValues, lazyLayoutMeasureScope.getLayoutDirection()));
                    }
                    if (z2) {
                        i5 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.mo987calculateRightPaddingu2uoSUM(lazyLayoutMeasureScope.getLayoutDirection()));
                    } else {
                        i5 = lazyLayoutMeasureScope.roundToPx-0680j_4(PaddingKt.calculateEndPadding(paddingValues, lazyLayoutMeasureScope.getLayoutDirection()));
                    }
                    int i8 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.getTop());
                    int i9 = lazyLayoutMeasureScope.roundToPx-0680j_4(paddingValues.getBottom());
                    final int i10 = i8 + i9;
                    final int i11 = i4 + i5;
                    boolean z12 = z2;
                    int i12 = z12 ? i10 : i11;
                    if (z12 && !z) {
                        i6 = i8;
                    } else if (z12 && z) {
                        i6 = i9;
                    } else {
                        i6 = (z12 || z) ? i5 : i4;
                    }
                    final int i13 = i12 - i6;
                    final long j2 = ConstraintsKt.offset-NN6Ew-U(j, -i11, -i10);
                    final LazyListItemProvider lazyListItemProvider = (LazyListItemProvider) function0.invoke();
                    lazyListItemProvider.getItemScope().setMaxSize(Constraints.getMaxWidth-impl(j2), Constraints.getMaxHeight-impl(j2));
                    if (z2) {
                        Arrangement.Vertical vertical3 = vertical2;
                        if (vertical3 == null) {
                            throw new IllegalArgumentException("null verticalArrangement when isVertical == true".toString());
                        }
                        spacing = vertical3.getSpacing();
                    } else {
                        Arrangement.Horizontal horizontal3 = horizontal2;
                        if (horizontal3 == null) {
                            throw new IllegalArgumentException("null horizontalAlignment when isVertical == false".toString());
                        }
                        spacing = horizontal3.getSpacing();
                    }
                    final int i14 = lazyLayoutMeasureScope.roundToPx-0680j_4(spacing);
                    final int itemCount = lazyListItemProvider.getItemCount();
                    if (z2) {
                        i7 = Constraints.getMaxHeight-impl(j) - i10;
                    } else {
                        i7 = Constraints.getMaxWidth-impl(j) - i11;
                    }
                    int i15 = i7;
                    if (!z || i15 > 0) {
                        jIntOffset = IntOffsetKt.IntOffset(i4, i8);
                    } else {
                        boolean z13 = z2;
                        if (!z13) {
                            i4 += i15;
                        }
                        if (z13) {
                            i8 += i15;
                        }
                        jIntOffset = IntOffsetKt.IntOffset(i4, i8);
                    }
                    final long j3 = jIntOffset;
                    final boolean z14 = z2;
                    final Alignment.Horizontal horizontal4 = horizontal;
                    final Alignment.Vertical vertical4 = vertical;
                    final boolean z15 = z;
                    final LazyListState lazyListState2 = lazyListState;
                    final int i16 = i6;
                    LazyListMeasuredItemProvider lazyListMeasuredItemProvider = new LazyListMeasuredItemProvider(j2, z14, lazyListItemProvider, lazyLayoutMeasureScope, itemCount, i14, horizontal4, vertical4, z15, i16, i13, j3, lazyListState2) {
                        final int $afterContentPadding;
                        final int $beforeContentPadding;
                        final Alignment.Horizontal $horizontalAlignment;
                        final boolean $isVertical;
                        final int $itemsCount;
                        final boolean $reverseLayout;
                        final int $spaceBetweenItems;
                        final LazyListState $state;
                        final LazyLayoutMeasureScope $this_null;
                        final Alignment.Vertical $verticalAlignment;
                        final long $visualItemOffset;

                        {
                            this.$isVertical = z14;
                            this.$this_null = lazyLayoutMeasureScope;
                            this.$itemsCount = itemCount;
                            this.$spaceBetweenItems = i14;
                            this.$horizontalAlignment = horizontal4;
                            this.$verticalAlignment = vertical4;
                            this.$reverseLayout = z15;
                            this.$beforeContentPadding = i16;
                            this.$afterContentPadding = i13;
                            this.$visualItemOffset = j3;
                            this.$state = lazyListState2;
                        }

                        @Override
                        public LazyListMeasuredItem mo1141createItemX9ElhV4(int index, Object key, Object contentType, List<? extends Placeable> placeables, long constraints) {
                            return new LazyListMeasuredItem(index, placeables, this.$isVertical, this.$horizontalAlignment, this.$verticalAlignment, this.$this_null.getLayoutDirection(), this.$reverseLayout, this.$beforeContentPadding, this.$afterContentPadding, index == this.$itemsCount + (-1) ? 0 : this.$spaceBetweenItems, this.$visualItemOffset, key, contentType, this.$state.getItemAnimator$foundation_release(), constraints, null);
                        }
                    };
                    Snapshot.Companion companion = Snapshot.INSTANCE;
                    LazyListState lazyListState3 = lazyListState;
                    Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
                    Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
                    Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
                    try {
                        int iUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release = lazyListState3.updateScrollPositionIfTheFirstItemWasMoved$foundation_release(lazyListItemProvider, lazyListState3.getFirstVisibleItemIndex());
                        int firstVisibleItemScrollOffset = lazyListState3.getFirstVisibleItemScrollOffset();
                        Unit unit = Unit.INSTANCE;
                        companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
                        List<Integer> listCalculateLazyLayoutPinnedIndices = LazyLayoutBeyondBoundsStateKt.calculateLazyLayoutPinnedIndices(lazyListItemProvider, lazyListState.getPinnedItems(), lazyListState.getBeyondBoundsInfo());
                        if (lazyLayoutMeasureScope.isLookingAhead() || !z11) {
                            scrollToBeConsumed = lazyListState.getScrollToBeConsumed();
                        } else {
                            scrollToBeConsumed = lazyListState.getScrollDeltaBetweenPasses$foundation_release();
                        }
                        float f = scrollToBeConsumed;
                        if (z3) {
                            listEmptyList = lazyListItemProvider.getHeaderIndexes();
                        } else {
                            listEmptyList = CollectionsKt.emptyList();
                        }
                        LazyListMeasureResult lazyListMeasureResultM1146measureLazyListx0Ok8Vo = LazyListMeasureKt.m1146measureLazyListx0Ok8Vo(itemCount, lazyListMeasuredItemProvider, i15, i6, i13, i14, iUpdateScrollPositionIfTheFirstItemWasMoved$foundation_release, firstVisibleItemScrollOffset, f, j2, z2, listEmptyList, vertical2, horizontal2, z, lazyLayoutMeasureScope, lazyListState.getItemAnimator$foundation_release(), i, listCalculateLazyLayoutPinnedIndices, z11, lazyLayoutMeasureScope.isLookingAhead(), lazyListState.getPostLookaheadLayoutInfo(), coroutineScope, lazyListState.m1157getPlacementScopeInvalidatorzYiylxw$foundation_release(), graphicsContext, new Function3<Integer, Integer, Function1<? super Placeable.PlacementScope, ? extends Unit>, MeasureResult>() {
                            {
                                super(3);
                            }

                            public Object invoke(Object obj, Object obj2, Object obj3) {
                                return invoke(((Number) obj).intValue(), ((Number) obj2).intValue(), (Function1<? super Placeable.PlacementScope, Unit>) obj3);
                            }

                            public final MeasureResult invoke(int i17, int i18, Function1<? super Placeable.PlacementScope, Unit> function1) {
                                return lazyLayoutMeasureScope.layout(ConstraintsKt.constrainWidth-K40F9xA(j, i17 + i11), ConstraintsKt.constrainHeight-K40F9xA(j, i18 + i10), MapsKt.emptyMap(), function1);
                            }
                        });
                        LazyListState.applyMeasureResult$foundation_release$default(lazyListState, lazyListMeasureResultM1146measureLazyListx0Ok8Vo, lazyLayoutMeasureScope.isLookingAhead(), false, 4, null);
                        return lazyListMeasureResultM1146measureLazyListx0Ok8Vo;
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
