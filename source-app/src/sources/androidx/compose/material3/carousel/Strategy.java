package androidx.compose.material3.carousel;

import androidx.collection.FloatList;
import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\b\f\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u000f\n\u0002\u0010\b\n\u0002\b\u0002\b\u0000\u0018\u0000 +2\u00020\u0001:\u0001+B/\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005¢\u0006\u0002\u0010\tBK\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u00030\u000b\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00030\u000b\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005¢\u0006\u0002\u0010\rJ\u0013\u0010\"\u001a\u00020\u001a2\b\u0010#\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J'\u0010$\u001a\u00020\u00032\u0006\u0010%\u001a\u00020\u00052\u0006\u0010&\u001a\u00020\u00052\b\b\u0002\u0010'\u001a\u00020\u001aH\u0000¢\u0006\u0002\b(J\b\u0010)\u001a\u00020*H\u0016R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000fR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00030\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u000e\u0010\u0016\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0019\u001a\u00020\u001a¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001bR\u0011\u0010\u001c\u001a\u00020\u00058F¢\u0006\u0006\u001a\u0004\b\u001d\u0010\u000fR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u000fR\u0017\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u00030\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0015R\u000e\u0010 \u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010!\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006,"}, d2 = {"Landroidx/compose/material3/carousel/Strategy;", "", "defaultKeylines", "Landroidx/compose/material3/carousel/KeylineList;", "availableSpace", "", "itemSpacing", "beforeContentPadding", "afterContentPadding", "(Landroidx/compose/material3/carousel/KeylineList;FFFF)V", "startKeylineSteps", "", "endKeylineSteps", "(Landroidx/compose/material3/carousel/KeylineList;Ljava/util/List;Ljava/util/List;FFFF)V", "getAfterContentPadding", "()F", "getAvailableSpace", "getBeforeContentPadding", "getDefaultKeylines", "()Landroidx/compose/material3/carousel/KeylineList;", "getEndKeylineSteps", "()Ljava/util/List;", "endShiftDistance", "endShiftPoints", "Landroidx/collection/FloatList;", "isValid", "", "()Z", "itemMainAxisSize", "getItemMainAxisSize", "getItemSpacing", "getStartKeylineSteps", "startShiftDistance", "startShiftPoints", "equals", "other", "getKeylineListForScrollOffset", "scrollOffset", "maxScrollOffset", "roundToNearestStep", "getKeylineListForScrollOffset$material3_release", "hashCode", "", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class Strategy {
    private final float afterContentPadding;
    private final float availableSpace;
    private final float beforeContentPadding;
    private final KeylineList defaultKeylines;
    private final List<KeylineList> endKeylineSteps;
    private final float endShiftDistance;
    private final FloatList endShiftPoints;
    private final boolean isValid;
    private final float itemSpacing;
    private final List<KeylineList> startKeylineSteps;
    private final float startShiftDistance;
    private final FloatList startShiftPoints;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;
    private static final Strategy Empty = new Strategy(KeylineListKt.emptyKeylineList(), CollectionsKt.emptyList(), CollectionsKt.emptyList(), 0.0f, 0.0f, 0.0f, 0.0f);

    private Strategy(KeylineList keylineList, List<KeylineList> list, List<KeylineList> list2, float f, float f2, float f3, float f4) {
        this.defaultKeylines = keylineList;
        this.startKeylineSteps = list;
        this.endKeylineSteps = list2;
        this.availableSpace = f;
        this.itemSpacing = f2;
        this.beforeContentPadding = f3;
        this.afterContentPadding = f4;
        float startShiftDistance = StrategyKt.getStartShiftDistance(list, f3);
        this.startShiftDistance = startShiftDistance;
        float endShiftDistance = StrategyKt.getEndShiftDistance(list2, f4);
        this.endShiftDistance = endShiftDistance;
        this.startShiftPoints = StrategyKt.getStepInterpolationPoints(startShiftDistance, list, true);
        this.endShiftPoints = StrategyKt.getStepInterpolationPoints(endShiftDistance, list2, false);
        this.isValid = (keylineList.isEmpty() || f == 0.0f || getItemMainAxisSize() == 0.0f) ? false : true;
    }

    public final KeylineList getDefaultKeylines() {
        return this.defaultKeylines;
    }

    public final List<KeylineList> getStartKeylineSteps() {
        return this.startKeylineSteps;
    }

    public final List<KeylineList> getEndKeylineSteps() {
        return this.endKeylineSteps;
    }

    public final float getAvailableSpace() {
        return this.availableSpace;
    }

    public final float getItemSpacing() {
        return this.itemSpacing;
    }

    public final float getBeforeContentPadding() {
        return this.beforeContentPadding;
    }

    public final float getAfterContentPadding() {
        return this.afterContentPadding;
    }

    public Strategy(KeylineList keylineList, float f, float f2, float f3, float f4) {
        this(keylineList, StrategyKt.getStartKeylineSteps(keylineList, f, f2, f3), StrategyKt.getEndKeylineSteps(keylineList, f, f2, f4), f, f2, f3, f4);
    }

    public final float getItemMainAxisSize() {
        return this.defaultKeylines.getFirstFocal().getSize();
    }

    public final boolean getIsValid() {
        return this.isValid;
    }

    public static KeylineList getKeylineListForScrollOffset$material3_release$default(Strategy strategy, float f, float f2, boolean z, int i, Object obj) {
        if ((i & 4) != 0) {
            z = false;
        }
        return strategy.getKeylineListForScrollOffset$material3_release(f, f2, z);
    }

    public final KeylineList getKeylineListForScrollOffset$material3_release(float scrollOffset, float maxScrollOffset, boolean roundToNearestStep) {
        int toStepIndex;
        float fMax = Math.max(0.0f, scrollOffset);
        float f = this.startShiftDistance;
        float fMax2 = Math.max(0.0f, maxScrollOffset - this.endShiftDistance);
        if (f > fMax || fMax > fMax2) {
            float fLerp = StrategyKt.lerp(1.0f, 0.0f, 0.0f, f, fMax);
            FloatList floatList = this.startShiftPoints;
            List<KeylineList> list = this.startKeylineSteps;
            if (fMax > fMax2) {
                fLerp = StrategyKt.lerp(0.0f, 1.0f, fMax2, maxScrollOffset, fMax);
                floatList = this.endShiftPoints;
                list = this.endKeylineSteps;
            }
            ShiftPointRange shiftPointRange = StrategyKt.getShiftPointRange(list.size(), floatList, fLerp);
            if (roundToNearestStep) {
                if (MathKt.roundToInt(shiftPointRange.getSteppedInterpolation()) == 0) {
                    toStepIndex = shiftPointRange.getFromStepIndex();
                } else {
                    toStepIndex = shiftPointRange.getToStepIndex();
                }
                return list.get(toStepIndex);
            }
            return KeylineListKt.lerp(list.get(shiftPointRange.getFromStepIndex()), list.get(shiftPointRange.getToStepIndex()), shiftPointRange.getSteppedInterpolation());
        }
        return this.defaultKeylines;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Strategy)) {
            return false;
        }
        boolean z = this.isValid;
        if (!z && !((Strategy) other).isValid) {
            return true;
        }
        Strategy strategy = (Strategy) other;
        return z == strategy.isValid && this.availableSpace == strategy.availableSpace && this.itemSpacing == strategy.itemSpacing && this.beforeContentPadding == strategy.beforeContentPadding && this.afterContentPadding == strategy.afterContentPadding && getItemMainAxisSize() == strategy.getItemMainAxisSize() && this.startShiftDistance == strategy.startShiftDistance && this.endShiftDistance == strategy.endShiftDistance && Intrinsics.areEqual(this.startShiftPoints, strategy.startShiftPoints) && Intrinsics.areEqual(this.endShiftPoints, strategy.endShiftPoints) && Intrinsics.areEqual(this.defaultKeylines, strategy.defaultKeylines);
    }

    public int hashCode() {
        boolean z = this.isValid;
        return !z ? UByte$.ExternalSyntheticBackport0.m(z) : (((((((((((((((((((UByte$.ExternalSyntheticBackport0.m(z) * 31) + Float.floatToIntBits(this.availableSpace)) * 31) + Float.floatToIntBits(this.itemSpacing)) * 31) + Float.floatToIntBits(this.beforeContentPadding)) * 31) + Float.floatToIntBits(this.afterContentPadding)) * 31) + Float.floatToIntBits(getItemMainAxisSize())) * 31) + Float.floatToIntBits(this.startShiftDistance)) * 31) + Float.floatToIntBits(this.endShiftDistance)) * 31) + this.startShiftPoints.hashCode()) * 31) + this.endShiftPoints.hashCode()) * 31) + this.defaultKeylines.hashCode();
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/material3/carousel/Strategy$Companion;", "", "()V", "Empty", "Landroidx/compose/material3/carousel/Strategy;", "getEmpty", "()Landroidx/compose/material3/carousel/Strategy;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Strategy getEmpty() {
            return Strategy.Empty;
        }
    }
}
