package androidx.compose.animation.core;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.collections.IntIterator;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u00002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\u001a1\u0010\u0002\u001a\u00020\u0003\"\b\b\u0000\u0010\u0004*\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u0001H\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\bH\u0002¢\u0006\u0002\u0010\n\u001a\u0018\u0010\u000b\u001a\u00020\f*\u0006\u0012\u0002\b\u00030\r2\u0006\u0010\u000e\u001a\u00020\fH\u0000\u001a9\u0010\u000f\u001a\u00020\f\"\b\b\u0000\u0010\u0004*\u00020\u0005*\b\u0012\u0004\u0012\u0002H\u00040\u00102\u0006\u0010\u0011\u001a\u0002H\u00042\u0006\u0010\u0012\u001a\u0002H\u00042\u0006\u0010\u0013\u001a\u0002H\u0004H\u0000¢\u0006\u0002\u0010\u0014\u001aA\u0010\u0015\u001a\u0002H\u0004\"\b\b\u0000\u0010\u0004*\u00020\u0005*\b\u0012\u0004\u0012\u0002H\u00040\u00102\u0006\u0010\u0016\u001a\u00020\f2\u0006\u0010\u0017\u001a\u0002H\u00042\u0006\u0010\u0018\u001a\u0002H\u00042\u0006\u0010\u0019\u001a\u0002H\u0004H\u0000¢\u0006\u0002\u0010\u001a\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u001b"}, d2 = {"InfiniteIterations", "", "createSpringAnimations", "Landroidx/compose/animation/core/Animations;", "V", "Landroidx/compose/animation/core/AnimationVector;", "visibilityThreshold", "dampingRatio", "", "stiffness", "(Landroidx/compose/animation/core/AnimationVector;FF)Landroidx/compose/animation/core/Animations;", "clampPlayTime", "", "Landroidx/compose/animation/core/VectorizedDurationBasedAnimationSpec;", "playTime", "getDurationMillis", "Landroidx/compose/animation/core/VectorizedAnimationSpec;", "initialValue", "targetValue", "initialVelocity", "(Landroidx/compose/animation/core/VectorizedAnimationSpec;Landroidx/compose/animation/core/AnimationVector;Landroidx/compose/animation/core/AnimationVector;Landroidx/compose/animation/core/AnimationVector;)J", "getValueFromMillis", "playTimeMillis", "start", "end", "startVelocity", "(Landroidx/compose/animation/core/VectorizedAnimationSpec;JLandroidx/compose/animation/core/AnimationVector;Landroidx/compose/animation/core/AnimationVector;Landroidx/compose/animation/core/AnimationVector;)Landroidx/compose/animation/core/AnimationVector;", "animation-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class VectorizedAnimationSpecKt {
    private static final int InfiniteIterations = Integer.MAX_VALUE;

    public static final <V extends AnimationVector> long getDurationMillis(VectorizedAnimationSpec<V> vectorizedAnimationSpec, V v, V v2, V v3) {
        return vectorizedAnimationSpec.getDurationNanos(v, v2, v3) / AnimationKt.MillisToNanos;
    }

    public static final <V extends AnimationVector> V getValueFromMillis(VectorizedAnimationSpec<V> vectorizedAnimationSpec, long j, V v, V v2, V v3) {
        return (V) vectorizedAnimationSpec.getValueFromNanos(j * AnimationKt.MillisToNanos, v, v2, v3);
    }

    public static final long clampPlayTime(VectorizedDurationBasedAnimationSpec<?> vectorizedDurationBasedAnimationSpec, long j) {
        return RangesKt.coerceIn(j - ((long) vectorizedDurationBasedAnimationSpec.getDelayMillis()), 0L, vectorizedDurationBasedAnimationSpec.getDurationMillis());
    }

    public static final <V extends AnimationVector> Animations createSpringAnimations(V v, float f, float f2) {
        if (v != null) {
            return new Animations(v, f, f2) {
                private final List<FloatSpringSpec> anims;

                {
                    Iterable iterableUntil = RangesKt.until(0, v.getSize());
                    ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterableUntil, 10));
                    IntIterator it = iterableUntil.iterator();
                    while (it.hasNext()) {
                        arrayList.add(new FloatSpringSpec(f, f2, v.get$animation_core_release(it.nextInt())));
                    }
                    this.anims = arrayList;
                }

                @Override
                public FloatSpringSpec get(int index) {
                    return this.anims.get(index);
                }
            };
        }
        return new Animations(f, f2) {
            private final FloatSpringSpec anim;

            {
                this.anim = new FloatSpringSpec(f, f2, 0.0f, 4, null);
            }

            @Override
            public FloatSpringSpec get(int index) {
                return this.anim;
            }
        };
    }
}
