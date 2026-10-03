package androidx.compose.foundation.lazy;

import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.VisibilityThresholdsKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.ui.unit.IntOffset;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;

@LazyScopeMarker
@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\bg\u0018\u00002\u00020\u0001JB\u0010\u0002\u001a\u00020\u0003*\u00020\u00032\u0010\b\u0002\u0010\u0004\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u00052\u0010\b\u0002\u0010\u0007\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u00052\u0010\b\u0002\u0010\t\u001a\n\u0012\u0004\u0012\u00020\u0006\u0018\u00010\u0005H\u0016J\u001c\u0010\n\u001a\u00020\u0003*\u00020\u00032\u000e\b\u0002\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\u0005H\u0017J\u0016\u0010\f\u001a\u00020\u0003*\u00020\u00032\b\b\u0003\u0010\r\u001a\u00020\u0006H&J\u0016\u0010\u000e\u001a\u00020\u0003*\u00020\u00032\b\b\u0003\u0010\r\u001a\u00020\u0006H&J\u0016\u0010\u000f\u001a\u00020\u0003*\u00020\u00032\b\b\u0003\u0010\r\u001a\u00020\u0006H&ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0010À\u0006\u0003"}, d2 = {"Landroidx/compose/foundation/lazy/LazyItemScope;", "", "animateItem", "Landroidx/compose/ui/Modifier;", "fadeInSpec", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "", "placementSpec", "Landroidx/compose/ui/unit/IntOffset;", "fadeOutSpec", "animateItemPlacement", "animationSpec", "fillParentMaxHeight", "fraction", "fillParentMaxSize", "fillParentMaxWidth", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface LazyItemScope {
    Modifier animateItem(Modifier modifier, FiniteAnimationSpec<Float> finiteAnimationSpec, FiniteAnimationSpec<IntOffset> finiteAnimationSpec2, FiniteAnimationSpec<Float> finiteAnimationSpec3);

    @Deprecated(message = "Use Modifier.animateItem() instead", replaceWith = @ReplaceWith(expression = "Modifier.animateItem(fadeInSpec = null, fadeOutSpec = null, placementSpec = animationSpec)", imports = {}))
    Modifier animateItemPlacement(Modifier modifier, FiniteAnimationSpec<IntOffset> finiteAnimationSpec);

    Modifier fillParentMaxHeight(Modifier modifier, float f);

    Modifier fillParentMaxSize(Modifier modifier, float f);

    Modifier fillParentMaxWidth(Modifier modifier, float f);

    public final class CC {
        public static Modifier $default$animateItem(LazyItemScope _this, Modifier modifier, FiniteAnimationSpec finiteAnimationSpec, FiniteAnimationSpec finiteAnimationSpec2, FiniteAnimationSpec finiteAnimationSpec3) {
            return modifier;
        }

        public static Modifier fillParentMaxSize$default(LazyItemScope lazyItemScope, Modifier modifier, float f, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: fillParentMaxSize");
            }
            if ((i & 1) != 0) {
                f = 1.0f;
            }
            return lazyItemScope.fillParentMaxSize(modifier, f);
        }

        public static Modifier fillParentMaxWidth$default(LazyItemScope lazyItemScope, Modifier modifier, float f, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: fillParentMaxWidth");
            }
            if ((i & 1) != 0) {
                f = 1.0f;
            }
            return lazyItemScope.fillParentMaxWidth(modifier, f);
        }

        public static Modifier fillParentMaxHeight$default(LazyItemScope lazyItemScope, Modifier modifier, float f, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: fillParentMaxHeight");
            }
            if ((i & 1) != 0) {
                f = 1.0f;
            }
            return lazyItemScope.fillParentMaxHeight(modifier, f);
        }

        public static Modifier animateItem$default(LazyItemScope lazyItemScope, Modifier modifier, FiniteAnimationSpec finiteAnimationSpec, FiniteAnimationSpec finiteAnimationSpec2, FiniteAnimationSpec finiteAnimationSpec3, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: animateItem");
            }
            if ((i & 1) != 0) {
                finiteAnimationSpec = AnimationSpecKt.spring$default(0.0f, 400.0f, null, 5, null);
            }
            if ((i & 2) != 0) {
                finiteAnimationSpec2 = AnimationSpecKt.spring$default(0.0f, 400.0f, IntOffset.box-impl(VisibilityThresholdsKt.getVisibilityThreshold(IntOffset.Companion)), 1, null);
            }
            if ((i & 4) != 0) {
                finiteAnimationSpec3 = AnimationSpecKt.spring$default(0.0f, 400.0f, null, 5, null);
            }
            return lazyItemScope.animateItem(modifier, finiteAnimationSpec, finiteAnimationSpec2, finiteAnimationSpec3);
        }

        public static Modifier animateItemPlacement$default(LazyItemScope lazyItemScope, Modifier modifier, FiniteAnimationSpec finiteAnimationSpec, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: animateItemPlacement");
            }
            if ((i & 1) != 0) {
                finiteAnimationSpec = AnimationSpecKt.spring$default(0.0f, 400.0f, IntOffset.box-impl(VisibilityThresholdsKt.getVisibilityThreshold(IntOffset.Companion)), 1, null);
            }
            return lazyItemScope.animateItemPlacement(modifier, finiteAnimationSpec);
        }

        @Deprecated(message = "Use Modifier.animateItem() instead", replaceWith = @ReplaceWith(expression = "Modifier.animateItem(fadeInSpec = null, fadeOutSpec = null, placementSpec = animationSpec)", imports = {}))
        public static Modifier $default$animateItemPlacement(LazyItemScope _this, Modifier modifier, FiniteAnimationSpec finiteAnimationSpec) {
            return _this.animateItem(modifier, null, finiteAnimationSpec, null);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        @Deprecated
        public static Modifier animateItem(LazyItemScope lazyItemScope, Modifier modifier, FiniteAnimationSpec<Float> finiteAnimationSpec, FiniteAnimationSpec<IntOffset> finiteAnimationSpec2, FiniteAnimationSpec<Float> finiteAnimationSpec3) {
            return CC.$default$animateItem(lazyItemScope, modifier, finiteAnimationSpec, finiteAnimationSpec2, finiteAnimationSpec3);
        }

        @Deprecated(message = "Use Modifier.animateItem() instead", replaceWith = @ReplaceWith(expression = "Modifier.animateItem(fadeInSpec = null, fadeOutSpec = null, placementSpec = animationSpec)", imports = {}))
        @Deprecated
        public static Modifier animateItemPlacement(LazyItemScope lazyItemScope, Modifier modifier, FiniteAnimationSpec<IntOffset> finiteAnimationSpec) {
            return CC.$default$animateItemPlacement(lazyItemScope, modifier, finiteAnimationSpec);
        }
    }
}
