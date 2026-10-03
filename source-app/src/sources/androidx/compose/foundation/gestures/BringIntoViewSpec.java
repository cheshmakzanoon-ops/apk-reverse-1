package androidx.compose.foundation.gestures;

import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\b\bg\u0018\u0000 \u000b2\u00020\u0001:\u0001\u000bJ \u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u0004H\u0016R\u001a\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\fÀ\u0006\u0001"}, d2 = {"Landroidx/compose/foundation/gestures/BringIntoViewSpec;", "", "scrollAnimationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "", "getScrollAnimationSpec", "()Landroidx/compose/animation/core/AnimationSpec;", "calculateScrollDistance", "offset", "size", "containerSize", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface BringIntoViewSpec {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    float calculateScrollDistance(float offset, float size, float containerSize);

    AnimationSpec<Float> getScrollAnimationSpec();

    public final class CC {
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\b\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J%\u0010\f\u001a\u00020\t2\u0006\u0010\r\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\t2\u0006\u0010\u000f\u001a\u00020\tH\u0000¢\u0006\u0002\b\u0010R\u0014\u0010\u0003\u001a\u00020\u0004X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0017\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\b¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0011"}, d2 = {"Landroidx/compose/foundation/gestures/BringIntoViewSpec$Companion;", "", "()V", "DefaultBringIntoViewSpec", "Landroidx/compose/foundation/gestures/BringIntoViewSpec;", "getDefaultBringIntoViewSpec$foundation_release", "()Landroidx/compose/foundation/gestures/BringIntoViewSpec;", "DefaultScrollAnimationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "", "getDefaultScrollAnimationSpec", "()Landroidx/compose/animation/core/AnimationSpec;", "defaultCalculateScrollDistance", "offset", "size", "containerSize", "defaultCalculateScrollDistance$foundation_release", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        private static final AnimationSpec<Float> DefaultScrollAnimationSpec = AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null);
        private static final BringIntoViewSpec DefaultBringIntoViewSpec = new BringIntoViewSpec() {
            @Override
            public float calculateScrollDistance(float f, float f2, float f3) {
                return BringIntoViewSpec.INSTANCE.defaultCalculateScrollDistance$foundation_release(f, f2, f3);
            }

            @Override
            public AnimationSpec getScrollAnimationSpec() {
                return BringIntoViewSpec.INSTANCE.getDefaultScrollAnimationSpec();
            }
        };

        private Companion() {
        }

        public final AnimationSpec<Float> getDefaultScrollAnimationSpec() {
            return DefaultScrollAnimationSpec;
        }

        public final BringIntoViewSpec getDefaultBringIntoViewSpec$foundation_release() {
            return DefaultBringIntoViewSpec;
        }

        public final float defaultCalculateScrollDistance$foundation_release(float offset, float size, float containerSize) {
            float f = size + offset;
            if ((offset >= 0.0f && f <= containerSize) || (offset < 0.0f && f > containerSize)) {
                return 0.0f;
            }
            float f2 = f - containerSize;
            return Math.abs(offset) < Math.abs(f2) ? offset : f2;
        }
    }
}
