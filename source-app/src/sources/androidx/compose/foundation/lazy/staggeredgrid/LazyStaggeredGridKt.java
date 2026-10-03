package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.compose.foundation.ScrollingContainerKt;
import androidx.compose.foundation.gestures.FlingBehavior;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.gestures.ScrollableDefaults;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsInfo;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsModifierLocalKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutBeyondBoundsState;
import androidx.compose.foundation.lazy.layout.LazyLayoutKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutMeasureScope;
import androidx.compose.foundation.lazy.layout.LazyLayoutSemanticsKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionScopedCoroutineScopeCanceller;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.EmptyCoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000L\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u0089\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\r2\b\b\u0002\u0010\u0011\u001a\u00020\u00122\b\b\u0002\u0010\u0013\u001a\u00020\u00122\u0017\u0010\u0014\u001a\u0013\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00010\u0015¢\u0006\u0002\b\u0017H\u0001ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001a"}, d2 = {"LazyStaggeredGrid", "", "state", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "slots", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyGridStaggeredGridSlotsProvider;", "modifier", "Landroidx/compose/ui/Modifier;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "reverseLayout", "", "flingBehavior", "Landroidx/compose/foundation/gestures/FlingBehavior;", "userScrollEnabled", "mainAxisSpacing", "Landroidx/compose/ui/unit/Dp;", "crossAxisSpacing", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;", "Lkotlin/ExtensionFunctionType;", "LazyStaggeredGrid-LJWHXA8", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;Landroidx/compose/foundation/gestures/Orientation;Landroidx/compose/foundation/lazy/staggeredgrid/LazyGridStaggeredGridSlotsProvider;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/layout/PaddingValues;ZLandroidx/compose/foundation/gestures/FlingBehavior;ZFFLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;III)V", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridKt {
    public static final void m1282LazyStaggeredGridLJWHXA8(final LazyStaggeredGridState lazyStaggeredGridState, final Orientation orientation, final LazyGridStaggeredGridSlotsProvider lazyGridStaggeredGridSlotsProvider, Modifier modifier, PaddingValues paddingValues, boolean z, FlingBehavior flingBehavior, boolean z2, float f, float f2, final Function1<? super LazyStaggeredGridScope, Unit> function1, Composer composer, final int i, final int i2, final int i3) {
        int i4;
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
        Modifier.Companion companion;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        boolean z3;
        FlingBehavior flingBehavior2;
        boolean z4;
        int i17;
        float f3;
        float f4;
        boolean z5;
        PaddingValues paddingValues2;
        FlingBehavior flingBehavior3;
        float f5;
        int i18;
        Modifier modifier2;
        Object objRememberedValue;
        Composer composer2;
        final boolean z6;
        final Modifier modifier3;
        final PaddingValues paddingValues3;
        final FlingBehavior flingBehavior4;
        final boolean z7;
        final float f6;
        final float f7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        int i19;
        Composer composerStartRestartGroup = composer.startRestartGroup(288295126);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyStaggeredGrid)P(9,6,8,5,1,7,3,10,4:c#ui.unit.Dp,2:c#ui.unit.Dp)51@2370L15,61@2769L55,62@2850L24,63@2922L7,64@2954L266,76@3245L60,82@3456L278,90@3804L57,93@4024L7,89@3748L385,98@4194L316,78@3311L1332:LazyStaggeredGrid.kt#fzvcnm");
        if ((i3 & 1) != 0) {
            i4 = i | 6;
        } else if ((i & 6) == 0) {
            i4 = (composerStartRestartGroup.changedInstance(lazyStaggeredGridState) ? 4 : 2) | i;
        } else {
            i4 = i;
        }
        if ((i3 & 2) != 0) {
            i4 |= 48;
        } else if ((i & 48) == 0) {
            i4 |= composerStartRestartGroup.changed(orientation) ? 32 : 16;
        }
        if ((i3 & 4) != 0) {
            i4 |= 384;
        } else if ((i & 384) == 0) {
            i4 |= (i & Fields.RotationY) == 0 ? composerStartRestartGroup.changed(lazyGridStaggeredGridSlotsProvider) : composerStartRestartGroup.changedInstance(lazyGridStaggeredGridSlotsProvider) ? Fields.RotationX : Fields.SpotShadowColor;
        }
        int i20 = i3 & 8;
        if (i20 == 0) {
            if ((i & 3072) == 0) {
                i4 |= composerStartRestartGroup.changed(modifier) ? Fields.CameraDistance : Fields.RotationZ;
            }
            i5 = i3 & 16;
            if (i5 != 0) {
                if ((i & 24576) == 0) {
                    if (composerStartRestartGroup.changed(paddingValues)) {
                        i6 = Fields.Clip;
                    } else {
                        i6 = Fields.Shape;
                    }
                    i4 |= i6;
                }
                i7 = i3 & 32;
                if (i7 != 0) {
                    i4 |= 196608;
                } else if ((i & 196608) == 0) {
                    if (composerStartRestartGroup.changed(z)) {
                        i8 = Fields.RenderEffect;
                    } else {
                        i8 = 65536;
                    }
                    i4 |= i8;
                }
                if ((i & 1572864) != 0) {
                    if ((i3 & 64) == 0 || !composerStartRestartGroup.changed(flingBehavior)) {
                        i19 = 524288;
                    } else {
                        i19 = 1048576;
                    }
                    i4 |= i19;
                }
                i9 = i3 & Fields.SpotShadowColor;
                if (i9 != 0) {
                    i4 |= 12582912;
                } else if ((i & 12582912) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
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
                if ((i3 & Fields.RotationZ) != 0) {
                    i15 = i2 | 6;
                } else if ((i2 & 6) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i16 = 4;
                    } else {
                        i16 = 2;
                    }
                    i15 = i2 | i16;
                } else {
                    i15 = i2;
                }
                if ((i4 & 306783379) == 306783378 || (i15 & 3) != 2 || !composerStartRestartGroup.getSkipping()) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                        if (i20 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i5 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                        }
                        if (i7 != 0) {
                            z3 = false;
                        } else {
                            z3 = z;
                        }
                        if ((i3 & 64) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i4 &= -3670017;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i9 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                        if (i11 != 0) {
                            i17 = 0;
                            f3 = Dp.constructor-impl(0);
                        } else {
                            i17 = 0;
                            f3 = f;
                        }
                        if (i13 != 0) {
                            f4 = Dp.constructor-impl(i17);
                        } else {
                            f4 = f2;
                        }
                        z5 = z4;
                        paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                        flingBehavior3 = flingBehavior2;
                        f5 = f3;
                        i18 = i4;
                        modifier2 = companion;
                    } else {
                        composerStartRestartGroup.skipToGroupEnd();
                        if ((i3 & 64) != 0) {
                            i4 &= -3670017;
                        }
                        modifier2 = modifier;
                        paddingValues2 = paddingValues;
                        z3 = z;
                        flingBehavior3 = flingBehavior;
                        z5 = z2;
                        f5 = f;
                        f4 = f2;
                        i18 = i4;
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
                    }
                    int i21 = i18 & 14;
                    Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i21);
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
                    int i22 = i18 >> 6;
                    int i23 = i22 & 7168;
                    int i24 = i18 >> 9;
                    int i25 = i18;
                    boolean z8 = z3;
                    Modifier modifier4 = modifier2;
                    Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda, paddingValues2, z3, orientation, f5, f4, coroutineScope, lazyGridStaggeredGridSlotsProvider, graphicsContext, composerStartRestartGroup, (i22 & 896) | i21 | i23 | ((i18 << 9) & 57344) | (i24 & 458752) | (i24 & 3670016) | ((i18 << 18) & 234881024));
                    int i26 = i25 >> 12;
                    Modifier modifierLazyLayoutSemantics = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier4.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z8, composerStartRestartGroup, (i26 & 112) | i21), orientation, z5, z8, composerStartRestartGroup, ((i25 << 6) & 7168) | (i24 & 57344) | (i25 & 458752));
                    LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i21);
                    LazyLayoutBeyondBoundsInfo beyondBoundsInfo = lazyStaggeredGridState.getBeyondBoundsInfo();
                    ProvidableCompositionLocal<LayoutDirection> localLayoutDirection = CompositionLocalsKt.getLocalLayoutDirection();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                    Object objConsume2 = composerStartRestartGroup.consume(localLayoutDirection);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i27 = i25 >> 3;
                    composer2 = composerStartRestartGroup;
                    LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState, beyondBoundsInfo, z8, (LayoutDirection) objConsume2, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i23 | ((i25 << 12) & 458752) | (3670016 & i27)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z8, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i25 << 3) & 1008) | (i26 & 7168) | (i27 & 57344) | (i27 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE, composer2, 0, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    z6 = z8;
                    modifier3 = modifier4;
                    paddingValues3 = paddingValues2;
                    flingBehavior4 = flingBehavior3;
                    z7 = z5;
                    f6 = f5;
                    f7 = f4;
                } else {
                    composerStartRestartGroup.skipToGroupEnd();
                    modifier3 = modifier;
                    paddingValues3 = paddingValues;
                    z6 = z;
                    flingBehavior4 = flingBehavior;
                    z7 = z2;
                    f6 = f;
                    composer2 = composerStartRestartGroup;
                    f7 = f2;
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

                        public final void invoke(Composer composer3, int i28) {
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridState, orientation, lazyGridStaggeredGridSlotsProvider, modifier3, paddingValues3, z6, flingBehavior4, z7, f6, f7, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                        }
                    });
                }
            }
            i4 |= 24576;
            i7 = i3 & 32;
            if (i7 != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i4 |= i8;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i19 = 524288;
                } else {
                    i19 = 524288;
                }
                i4 |= i19;
            }
            i9 = i3 & Fields.SpotShadowColor;
            if (i9 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
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
            if ((i3 & Fields.RotationZ) != 0) {
                i15 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i16 = 4;
                } else {
                    i16 = 2;
                }
                i15 = i2 | i16;
            } else {
                i15 = i2;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                } else {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
                }
                int i28 = i18 & 14;
                Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda2 = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i28);
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
                GraphicsContext graphicsContext2 = (GraphicsContext) objConsume3;
                int i29 = i18 >> 6;
                int i210 = i29 & 7168;
                int i211 = i18 >> 9;
                int i212 = i18;
                boolean z9 = z3;
                Modifier modifier5 = modifier2;
                Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE2 = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda2, paddingValues2, z3, orientation, f5, f4, coroutineScope2, lazyGridStaggeredGridSlotsProvider, graphicsContext2, composerStartRestartGroup, (i29 & 896) | i28 | i210 | ((i18 << 9) & 57344) | (i211 & 458752) | (i211 & 3670016) | ((i18 << 18) & 234881024));
                int i213 = i212 >> 12;
                Modifier modifierLazyLayoutSemantics2 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier5.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda2, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z9, composerStartRestartGroup, (i213 & 112) | i28), orientation, z5, z9, composerStartRestartGroup, ((i212 << 6) & 7168) | (i211 & 57344) | (i212 & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState2 = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i28);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo2 = lazyStaggeredGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection2 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume4 = composerStartRestartGroup.consume(localLayoutDirection2);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i214 = i212 >> 3;
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda2, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics2, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState2, beyondBoundsInfo2, z9, (LayoutDirection) objConsume4, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i210 | ((i212 << 12) & 458752) | (3670016 & i214)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z9, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i212 << 3) & 1008) | (i213 & 7168) | (i214 & 57344) | (i214 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE2, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z9;
                modifier3 = modifier5;
                paddingValues3 = paddingValues2;
                flingBehavior4 = flingBehavior3;
                z7 = z5;
                f6 = f5;
                f7 = f4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                } else {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
                }
                int i215 = i18 & 14;
                Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda3 = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i215);
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
                GraphicsContext graphicsContext3 = (GraphicsContext) objConsume5;
                int i216 = i18 >> 6;
                int i217 = i216 & 7168;
                int i218 = i18 >> 9;
                int i219 = i18;
                boolean z10 = z3;
                Modifier modifier6 = modifier2;
                Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE3 = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda3, paddingValues2, z3, orientation, f5, f4, coroutineScope3, lazyGridStaggeredGridSlotsProvider, graphicsContext3, composerStartRestartGroup, (i216 & 896) | i215 | i217 | ((i18 << 9) & 57344) | (i218 & 458752) | (i218 & 3670016) | ((i18 << 18) & 234881024));
                int i2110 = i219 >> 12;
                Modifier modifierLazyLayoutSemantics3 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier6.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda3, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z10, composerStartRestartGroup, (i2110 & 112) | i215), orientation, z5, z10, composerStartRestartGroup, ((i219 << 6) & 7168) | (i218 & 57344) | (i219 & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState3 = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i215);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo3 = lazyStaggeredGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection3 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume6 = composerStartRestartGroup.consume(localLayoutDirection3);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2111 = i219 >> 3;
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda3, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics3, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState3, beyondBoundsInfo3, z10, (LayoutDirection) objConsume6, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i217 | ((i219 << 12) & 458752) | (3670016 & i2111)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z10, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i219 << 3) & 1008) | (i2110 & 7168) | (i2111 & 57344) | (i2111 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE3, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z10;
                modifier3 = modifier6;
                paddingValues3 = paddingValues2;
                flingBehavior4 = flingBehavior3;
                z7 = z5;
                f6 = f5;
                f7 = f4;
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

                    public final void invoke(Composer composer3, int i220) {
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridState, orientation, lazyGridStaggeredGridSlotsProvider, modifier3, paddingValues3, z6, flingBehavior4, z7, f6, f7, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 3072;
        i5 = i3 & 16;
        if (i5 != 0) {
            if ((i & 24576) == 0) {
                if (composerStartRestartGroup.changed(paddingValues)) {
                    i6 = Fields.Clip;
                } else {
                    i6 = Fields.Shape;
                }
                i4 |= i6;
            }
            i7 = i3 & 32;
            if (i7 != 0) {
                i4 |= 196608;
            } else if ((i & 196608) == 0) {
                if (composerStartRestartGroup.changed(z)) {
                    i8 = Fields.RenderEffect;
                } else {
                    i8 = 65536;
                }
                i4 |= i8;
            }
            if ((i & 1572864) != 0) {
                if ((i3 & 64) == 0) {
                    i19 = 524288;
                } else {
                    i19 = 524288;
                }
                i4 |= i19;
            }
            i9 = i3 & Fields.SpotShadowColor;
            if (i9 != 0) {
                i4 |= 12582912;
            } else if ((i & 12582912) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
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
            if ((i3 & Fields.RotationZ) != 0) {
                i15 = i2 | 6;
            } else if ((i2 & 6) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i16 = 4;
                } else {
                    i16 = 2;
                }
                i15 = i2 | i16;
            } else {
                i15 = i2;
            }
            if ((i4 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                } else {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
                }
                int i2112 = i18 & 14;
                Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda4 = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i2112);
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
                GraphicsContext graphicsContext4 = (GraphicsContext) objConsume7;
                int i2113 = i18 >> 6;
                int i2114 = i2113 & 7168;
                int i2115 = i18 >> 9;
                int i2116 = i18;
                boolean z11 = z3;
                Modifier modifier7 = modifier2;
                Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE4 = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda4, paddingValues2, z3, orientation, f5, f4, coroutineScope4, lazyGridStaggeredGridSlotsProvider, graphicsContext4, composerStartRestartGroup, (i2113 & 896) | i2112 | i2114 | ((i18 << 9) & 57344) | (i2115 & 458752) | (i2115 & 3670016) | ((i18 << 18) & 234881024));
                int i2117 = i2116 >> 12;
                Modifier modifierLazyLayoutSemantics4 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier7.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda4, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z11, composerStartRestartGroup, (i2117 & 112) | i2112), orientation, z5, z11, composerStartRestartGroup, ((i2116 << 6) & 7168) | (i2115 & 57344) | (i2116 & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState4 = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i2112);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo4 = lazyStaggeredGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection4 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume8 = composerStartRestartGroup.consume(localLayoutDirection4);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2118 = i2116 >> 3;
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda4, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics4, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState4, beyondBoundsInfo4, z11, (LayoutDirection) objConsume8, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i2114 | ((i2116 << 12) & 458752) | (3670016 & i2118)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z11, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i2116 << 3) & 1008) | (i2117 & 7168) | (i2118 & 57344) | (i2118 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE4, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z11;
                modifier3 = modifier7;
                paddingValues3 = paddingValues2;
                flingBehavior4 = flingBehavior3;
                z7 = z5;
                f6 = f5;
                f7 = f4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                } else {
                    if (i20 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i5 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                    }
                    if (i7 != 0) {
                        z3 = false;
                    } else {
                        z3 = z;
                    }
                    if ((i3 & 64) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i4 &= -3670017;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i9 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                    if (i11 != 0) {
                        i17 = 0;
                        f3 = Dp.constructor-impl(0);
                    } else {
                        i17 = 0;
                        f3 = f;
                    }
                    if (i13 != 0) {
                        f4 = Dp.constructor-impl(i17);
                    } else {
                        f4 = f2;
                    }
                    z5 = z4;
                    paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                    flingBehavior3 = flingBehavior2;
                    f5 = f3;
                    i18 = i4;
                    modifier2 = companion;
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
                }
                int i2119 = i18 & 14;
                Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda5 = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i2119);
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
                GraphicsContext graphicsContext5 = (GraphicsContext) objConsume9;
                int i21110 = i18 >> 6;
                int i21111 = i21110 & 7168;
                int i21112 = i18 >> 9;
                int i21113 = i18;
                boolean z12 = z3;
                Modifier modifier8 = modifier2;
                Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE5 = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda5, paddingValues2, z3, orientation, f5, f4, coroutineScope5, lazyGridStaggeredGridSlotsProvider, graphicsContext5, composerStartRestartGroup, (i21110 & 896) | i2119 | i21111 | ((i18 << 9) & 57344) | (i21112 & 458752) | (i21112 & 3670016) | ((i18 << 18) & 234881024));
                int i21114 = i21113 >> 12;
                Modifier modifierLazyLayoutSemantics5 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier8.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda5, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z12, composerStartRestartGroup, (i21114 & 112) | i2119), orientation, z5, z12, composerStartRestartGroup, ((i21113 << 6) & 7168) | (i21112 & 57344) | (i21113 & 458752));
                LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState5 = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i2119);
                LazyLayoutBeyondBoundsInfo beyondBoundsInfo5 = lazyStaggeredGridState.getBeyondBoundsInfo();
                ProvidableCompositionLocal<LayoutDirection> localLayoutDirection5 = CompositionLocalsKt.getLocalLayoutDirection();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
                Object objConsume10 = composerStartRestartGroup.consume(localLayoutDirection5);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21115 = i21113 >> 3;
                composer2 = composerStartRestartGroup;
                LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda5, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics5, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState5, beyondBoundsInfo5, z12, (LayoutDirection) objConsume10, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i21111 | ((i21113 << 12) & 458752) | (3670016 & i21115)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z12, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i21113 << 3) & 1008) | (i21114 & 7168) | (i21115 & 57344) | (i21115 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE5, composer2, 0, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                z6 = z12;
                modifier3 = modifier8;
                paddingValues3 = paddingValues2;
                flingBehavior4 = flingBehavior3;
                z7 = z5;
                f6 = f5;
                f7 = f4;
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

                    public final void invoke(Composer composer3, int i220) {
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridState, orientation, lazyGridStaggeredGridSlotsProvider, modifier3, paddingValues3, z6, flingBehavior4, z7, f6, f7, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                    }
                });
            }
        }
        i4 |= 24576;
        i7 = i3 & 32;
        if (i7 != 0) {
            i4 |= 196608;
        } else if ((i & 196608) == 0) {
            if (composerStartRestartGroup.changed(z)) {
                i8 = Fields.RenderEffect;
            } else {
                i8 = 65536;
            }
            i4 |= i8;
        }
        if ((i & 1572864) != 0) {
            if ((i3 & 64) == 0) {
                i19 = 524288;
            } else {
                i19 = 524288;
            }
            i4 |= i19;
        }
        i9 = i3 & Fields.SpotShadowColor;
        if (i9 != 0) {
            i4 |= 12582912;
        } else if ((i & 12582912) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
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
        if ((i3 & Fields.RotationZ) != 0) {
            i15 = i2 | 6;
        } else if ((i2 & 6) == 0) {
            if (composerStartRestartGroup.changedInstance(function1)) {
                i16 = 4;
            } else {
                i16 = 2;
            }
            i15 = i2 | i16;
        } else {
            i15 = i2;
        }
        if ((i4 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i20 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                }
                if (i7 != 0) {
                    z3 = false;
                } else {
                    z3 = z;
                }
                if ((i3 & 64) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i9 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i11 != 0) {
                    i17 = 0;
                    f3 = Dp.constructor-impl(0);
                } else {
                    i17 = 0;
                    f3 = f;
                }
                if (i13 != 0) {
                    f4 = Dp.constructor-impl(i17);
                } else {
                    f4 = f2;
                }
                z5 = z4;
                paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                f5 = f3;
                i18 = i4;
                modifier2 = companion;
            } else {
                if (i20 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                }
                if (i7 != 0) {
                    z3 = false;
                } else {
                    z3 = z;
                }
                if ((i3 & 64) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i9 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i11 != 0) {
                    i17 = 0;
                    f3 = Dp.constructor-impl(0);
                } else {
                    i17 = 0;
                    f3 = f;
                }
                if (i13 != 0) {
                    f4 = Dp.constructor-impl(i17);
                } else {
                    f4 = f2;
                }
                z5 = z4;
                paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                f5 = f3;
                i18 = i4;
                modifier2 = companion;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
            }
            int i21116 = i18 & 14;
            Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda6 = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i21116);
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
            GraphicsContext graphicsContext6 = (GraphicsContext) objConsume11;
            int i21117 = i18 >> 6;
            int i21118 = i21117 & 7168;
            int i21119 = i18 >> 9;
            int i211110 = i18;
            boolean z13 = z3;
            Modifier modifier9 = modifier2;
            Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE6 = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda6, paddingValues2, z3, orientation, f5, f4, coroutineScope6, lazyGridStaggeredGridSlotsProvider, graphicsContext6, composerStartRestartGroup, (i21117 & 896) | i21116 | i21118 | ((i18 << 9) & 57344) | (i21119 & 458752) | (i21119 & 3670016) | ((i18 << 18) & 234881024));
            int i211111 = i211110 >> 12;
            Modifier modifierLazyLayoutSemantics6 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier9.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda6, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z13, composerStartRestartGroup, (i211111 & 112) | i21116), orientation, z5, z13, composerStartRestartGroup, ((i211110 << 6) & 7168) | (i21119 & 57344) | (i211110 & 458752));
            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState6 = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i21116);
            LazyLayoutBeyondBoundsInfo beyondBoundsInfo6 = lazyStaggeredGridState.getBeyondBoundsInfo();
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection6 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume12 = composerStartRestartGroup.consume(localLayoutDirection6);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i211112 = i211110 >> 3;
            composer2 = composerStartRestartGroup;
            LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda6, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics6, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState6, beyondBoundsInfo6, z13, (LayoutDirection) objConsume12, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i21118 | ((i211110 << 12) & 458752) | (3670016 & i211112)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z13, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i211110 << 3) & 1008) | (i211111 & 7168) | (i211112 & 57344) | (i211112 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE6, composer2, 0, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z6 = z13;
            modifier3 = modifier9;
            paddingValues3 = paddingValues2;
            flingBehavior4 = flingBehavior3;
            z7 = z5;
            f6 = f5;
            f7 = f4;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i20 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                }
                if (i7 != 0) {
                    z3 = false;
                } else {
                    z3 = z;
                }
                if ((i3 & 64) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i9 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i11 != 0) {
                    i17 = 0;
                    f3 = Dp.constructor-impl(0);
                } else {
                    i17 = 0;
                    f3 = f;
                }
                if (i13 != 0) {
                    f4 = Dp.constructor-impl(i17);
                } else {
                    f4 = f2;
                }
                z5 = z4;
                paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                f5 = f3;
                i18 = i4;
                modifier2 = companion;
            } else {
                if (i20 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i5 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues;
                }
                if (i7 != 0) {
                    z3 = false;
                } else {
                    z3 = z;
                }
                if ((i3 & 64) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i4 &= -3670017;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i9 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
                if (i11 != 0) {
                    i17 = 0;
                    f3 = Dp.constructor-impl(0);
                } else {
                    i17 = 0;
                    f3 = f;
                }
                if (i13 != 0) {
                    f4 = Dp.constructor-impl(i17);
                } else {
                    f4 = f2;
                }
                z5 = z4;
                paddingValues2 = paddingValuesM1028PaddingValues0680j_4;
                flingBehavior3 = flingBehavior2;
                f5 = f3;
                i18 = i4;
                modifier2 = companion;
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(288295126, i18, i15, "androidx.compose.foundation.lazy.staggeredgrid.LazyStaggeredGrid (LazyStaggeredGrid.kt:60)");
            }
            int i211113 = i18 & 14;
            Function0<LazyStaggeredGridItemProvider> function0RememberStaggeredGridItemProviderLambda7 = LazyStaggeredGridItemProviderKt.rememberStaggeredGridItemProviderLambda(lazyStaggeredGridState, function1, composerStartRestartGroup, ((i15 << 3) & 112) | i211113);
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
            GraphicsContext graphicsContext7 = (GraphicsContext) objConsume13;
            int i211114 = i18 >> 6;
            int i211115 = i211114 & 7168;
            int i211116 = i18 >> 9;
            int i211117 = i18;
            boolean z14 = z3;
            Modifier modifier10 = modifier2;
            Function2<LazyLayoutMeasureScope, Constraints, LazyStaggeredGridMeasureResult> function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE7 = LazyStaggeredGridMeasurePolicyKt.m1295rememberStaggeredGridMeasurePolicyqKj4JfE(lazyStaggeredGridState, function0RememberStaggeredGridItemProviderLambda7, paddingValues2, z3, orientation, f5, f4, coroutineScope7, lazyGridStaggeredGridSlotsProvider, graphicsContext7, composerStartRestartGroup, (i211114 & 896) | i211113 | i211115 | ((i18 << 9) & 57344) | (i211116 & 458752) | (i211116 & 3670016) | ((i18 << 18) & 234881024));
            int i211118 = i211117 >> 12;
            Modifier modifierLazyLayoutSemantics7 = LazyLayoutSemanticsKt.lazyLayoutSemantics(modifier10.then(lazyStaggeredGridState.getRemeasurementModifier()).then(lazyStaggeredGridState.getAwaitLayoutModifier()), function0RememberStaggeredGridItemProviderLambda7, LazyStaggeredGridSemanticsKt.rememberLazyStaggeredGridSemanticState(lazyStaggeredGridState, z14, composerStartRestartGroup, (i211118 & 112) | i211113), orientation, z5, z14, composerStartRestartGroup, ((i211117 << 6) & 7168) | (i211116 & 57344) | (i211117 & 458752));
            LazyLayoutBeyondBoundsState lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState7 = LazyStaggeredGridBeyondBoundsModifierKt.rememberLazyStaggeredGridBeyondBoundsState(lazyStaggeredGridState, composerStartRestartGroup, i211113);
            LazyLayoutBeyondBoundsInfo beyondBoundsInfo7 = lazyStaggeredGridState.getBeyondBoundsInfo();
            ProvidableCompositionLocal<LayoutDirection> localLayoutDirection7 = CompositionLocalsKt.getLocalLayoutDirection();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume14 = composerStartRestartGroup.consume(localLayoutDirection7);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i211119 = i211117 >> 3;
            composer2 = composerStartRestartGroup;
            LazyLayoutKt.LazyLayout(function0RememberStaggeredGridItemProviderLambda7, ScrollingContainerKt.scrollingContainer(LazyLayoutBeyondBoundsModifierLocalKt.lazyLayoutBeyondBoundsModifier(modifierLazyLayoutSemantics7, lazyLayoutBeyondBoundsStateRememberLazyStaggeredGridBeyondBoundsState7, beyondBoundsInfo7, z14, (LayoutDirection) objConsume14, orientation, z5, composerStartRestartGroup, (MutableVector.$stable << 6) | i211115 | ((i211117 << 12) & 458752) | (3670016 & i211119)).then(lazyStaggeredGridState.getItemAnimator$foundation_release().getModifier()), lazyStaggeredGridState, orientation, z5, z14, flingBehavior3, lazyStaggeredGridState.getMutableInteractionSource(), null, composerStartRestartGroup, ((i211117 << 3) & 1008) | (i211118 & 7168) | (i211119 & 57344) | (i211119 & 458752), 64), lazyStaggeredGridState.getPrefetchState(), function2M1295rememberStaggeredGridMeasurePolicyqKj4JfE7, composer2, 0, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            z6 = z14;
            modifier3 = modifier10;
            paddingValues3 = paddingValues2;
            flingBehavior4 = flingBehavior3;
            z7 = z5;
            f6 = f5;
            f7 = f4;
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

                public final void invoke(Composer composer3, int i220) {
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridState, orientation, lazyGridStaggeredGridSlotsProvider, modifier3, paddingValues3, z6, flingBehavior4, z7, f6, f7, function1, composer3, RecomposeScopeImplKt.updateChangedFlags(i | 1), RecomposeScopeImplKt.updateChangedFlags(i2), i3);
                }
            });
        }
    }
}
