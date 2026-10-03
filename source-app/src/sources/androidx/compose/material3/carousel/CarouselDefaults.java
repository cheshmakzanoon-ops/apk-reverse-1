package androidx.compose.material3.carousel;

import androidx.compose.animation.SplineBasedFloatDecayAnimationSpec_androidKt;
import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.DecayAnimationSpec;
import androidx.compose.foundation.gestures.TargetedFlingBehavior;
import androidx.compose.foundation.gestures.snapping.SnapFlingBehaviorKt;
import androidx.compose.foundation.gestures.snapping.SnapLayoutInfoProvider;
import androidx.compose.foundation.pager.PagerDefaults;
import androidx.compose.foundation.pager.PagerSnapDistance;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J5\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u000e\b\u0002\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u000b0\u00132\u000e\b\u0002\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0015H\u0007¢\u0006\u0002\u0010\u0016J\r\u0010\u0017\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010\u0018J%\u0010\u0019\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u000e\b\u0002\u0010\u0014\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0015H\u0007¢\u0006\u0002\u0010\u001aR\u001c\u0010\u0003\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u001c\u0010\b\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u000e\u0010\n\u001a\u00020\u000bX\u0080T¢\u0006\u0002\n\u0000R\u001c\u0010\f\u001a\u00020\u0004X\u0080\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\r\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001b"}, d2 = {"Landroidx/compose/material3/carousel/CarouselDefaults;", "", "()V", "AnchorSize", "Landroidx/compose/ui/unit/Dp;", "getAnchorSize-D9Ej5fM$material3_release", "()F", "F", "MaxSmallItemSize", "getMaxSmallItemSize-D9Ej5fM$material3_release", "MediumLargeItemDiffThreshold", "", "MinSmallItemSize", "getMinSmallItemSize-D9Ej5fM$material3_release", "multiBrowseFlingBehavior", "Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "state", "Landroidx/compose/material3/carousel/CarouselState;", "decayAnimationSpec", "Landroidx/compose/animation/core/DecayAnimationSpec;", "snapAnimationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "(Landroidx/compose/material3/carousel/CarouselState;Landroidx/compose/animation/core/DecayAnimationSpec;Landroidx/compose/animation/core/AnimationSpec;Landroidx/compose/runtime/Composer;II)Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "noSnapFlingBehavior", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "singleAdvanceFlingBehavior", "(Landroidx/compose/material3/carousel/CarouselState;Landroidx/compose/animation/core/AnimationSpec;Landroidx/compose/runtime/Composer;II)Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class CarouselDefaults {
    public static final int $stable = 0;
    public static final float MediumLargeItemDiffThreshold = 0.85f;
    public static final CarouselDefaults INSTANCE = new CarouselDefaults();
    private static final float MinSmallItemSize = Dp.constructor-impl(40);
    private static final float MaxSmallItemSize = Dp.constructor-impl(56);
    private static final float AnchorSize = Dp.constructor-impl(10);

    private CarouselDefaults() {
    }

    public final TargetedFlingBehavior singleAdvanceFlingBehavior(CarouselState carouselState, AnimationSpec<Float> animationSpec, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, 1701587199, "C(singleAdvanceFlingBehavior)P(1)612@27409L174:Carousel.kt#dcf9yb");
        AnimationSpec<Float> animationSpecSpring$default = (i2 & 2) != 0 ? AnimationSpecKt.spring$default(0.0f, 400.0f, null, 5, null) : animationSpec;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1701587199, i, -1, "androidx.compose.material3.carousel.CarouselDefaults.singleAdvanceFlingBehavior (Carousel.kt:611)");
        }
        TargetedFlingBehavior targetedFlingBehaviorFlingBehavior = PagerDefaults.INSTANCE.flingBehavior(carouselState.getPagerState(), PagerSnapDistance.INSTANCE.atMost(1), null, animationSpecSpring$default, 0.0f, composer, ((i << 6) & 7168) | (PagerDefaults.$stable << 15), 20);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return targetedFlingBehaviorFlingBehavior;
    }

    public final TargetedFlingBehavior multiBrowseFlingBehavior(CarouselState carouselState, DecayAnimationSpec<Float> decayAnimationSpec, AnimationSpec<Float> animationSpec, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -1105043293, "C(multiBrowseFlingBehavior)P(2)642@29119L26,657@29722L217:Carousel.kt#dcf9yb");
        DecayAnimationSpec<Float> decayAnimationSpecRememberSplineBasedDecay = (i2 & 2) != 0 ? SplineBasedFloatDecayAnimationSpec_androidKt.rememberSplineBasedDecay(composer, 0) : decayAnimationSpec;
        AnimationSpec<Float> animationSpecSpring$default = (i2 & 4) != 0 ? AnimationSpecKt.spring$default(0.0f, 400.0f, null, 5, null) : animationSpec;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1105043293, i, -1, "androidx.compose.material3.carousel.CarouselDefaults.multiBrowseFlingBehavior (Carousel.kt:644)");
        }
        TargetedFlingBehavior targetedFlingBehaviorFlingBehavior = PagerDefaults.INSTANCE.flingBehavior(carouselState.getPagerState(), new PagerSnapDistance() {
            @Override
            public int calculateTargetPage(int startPage, int suggestedTargetPage, float velocity, int pageSize, int pageSpacing) {
                return suggestedTargetPage;
            }
        }, decayAnimationSpecRememberSplineBasedDecay, animationSpecSpring$default, 0.0f, composer, ((i << 3) & 8064) | (PagerDefaults.$stable << 15), 16);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return targetedFlingBehaviorFlingBehavior;
    }

    public final TargetedFlingBehavior noSnapFlingBehavior(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -418415756, "C(noSnapFlingBehavior)674@30353L158,680@30528L75:Carousel.kt#dcf9yb");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-418415756, i, -1, "androidx.compose.material3.carousel.CarouselDefaults.noSnapFlingBehavior (Carousel.kt:673)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 1269150096, "CC(remember):Carousel.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new SnapLayoutInfoProvider() {
                @Override
                public float calculateApproachOffset(float f, float f2) {
                    return SnapLayoutInfoProvider.CC.$default$calculateApproachOffset(this, f, f2);
                }

                @Override
                public float calculateSnapOffset(float velocity) {
                    return 0.0f;
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        TargetedFlingBehavior targetedFlingBehaviorRememberSnapFlingBehavior = SnapFlingBehaviorKt.rememberSnapFlingBehavior((CarouselDefaults$noSnapFlingBehavior$decayLayoutInfoProvider$1$1) objRememberedValue, composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return targetedFlingBehaviorRememberSnapFlingBehavior;
    }

    public final float m3224getMinSmallItemSizeD9Ej5fM$material3_release() {
        return MinSmallItemSize;
    }

    public final float m3223getMaxSmallItemSizeD9Ej5fM$material3_release() {
        return MaxSmallItemSize;
    }

    public final float m3222getAnchorSizeD9Ej5fM$material3_release() {
        return AnchorSize;
    }
}
