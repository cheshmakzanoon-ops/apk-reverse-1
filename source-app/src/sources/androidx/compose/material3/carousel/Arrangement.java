package androidx.compose.material3.carousel;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0011\n\u0002\u0010\u000b\n\u0002\b\u0003\b\u0000\u0018\u0000 \u00192\u00020\u0001:\u0001\u0019B=\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0005\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u0003¢\u0006\u0002\u0010\u000bJ\u0010\u0010\u0014\u001a\u00020\u00052\u0006\u0010\u0015\u001a\u00020\u0005H\u0002J\b\u0010\u0016\u001a\u00020\u0017H\u0002J\u0006\u0010\u0018\u001a\u00020\u0003R\u0011\u0010\n\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\rR\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000f¨\u0006\u001a"}, d2 = {"Landroidx/compose/material3/carousel/Arrangement;", "", "priority", "", "smallSize", "", "smallCount", "mediumSize", "mediumCount", "largeSize", "largeCount", "(IFIFIFI)V", "getLargeCount", "()I", "getLargeSize", "()F", "getMediumCount", "getMediumSize", "getSmallCount", "getSmallSize", "cost", "targetLargeSize", "isValid", "", "itemCount", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class Arrangement {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private static final float MediumItemFlexPercentage = 0.1f;
    private final int largeCount;
    private final float largeSize;
    private final int mediumCount;
    private final float mediumSize;
    private final int priority;
    private final int smallCount;
    private final float smallSize;

    public Arrangement(int i, float f, int i2, float f2, int i3, float f3, int i4) {
        this.priority = i;
        this.smallSize = f;
        this.smallCount = i2;
        this.mediumSize = f2;
        this.mediumCount = i3;
        this.largeSize = f3;
        this.largeCount = i4;
    }

    public final float getSmallSize() {
        return this.smallSize;
    }

    public final int getSmallCount() {
        return this.smallCount;
    }

    public final float getMediumSize() {
        return this.mediumSize;
    }

    public final int getMediumCount() {
        return this.mediumCount;
    }

    public final float getLargeSize() {
        return this.largeSize;
    }

    public final int getLargeCount() {
        return this.largeCount;
    }

    private final boolean isValid() {
        int i = this.largeCount;
        if (i <= 0 || this.smallCount <= 0 || this.mediumCount <= 0) {
            return i <= 0 || this.smallCount <= 0 || this.largeSize > this.smallSize;
        }
        float f = this.largeSize;
        float f2 = this.mediumSize;
        return f > f2 && f2 > this.smallSize;
    }

    public final float cost(float targetLargeSize) {
        if (isValid()) {
            return Math.abs(targetLargeSize - this.largeSize) * this.priority;
        }
        return Float.MAX_VALUE;
    }

    public final int itemCount() {
        return this.largeCount + this.mediumCount + this.smallCount;
    }

    @Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0015\n\u0002\b\t\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J0\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\bH\u0002JX\u0010\f\u001a\u0004\u0018\u00010\r2\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u00042\u0006\u0010\u000f\u001a\u00020\u00042\u0006\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0015\u001a\u00020\u00132\u0006\u0010\u0016\u001a\u00020\u00042\u0006\u0010\u0017\u001a\u00020\u0013J`\u0010\u0018\u001a\u00020\r2\u0006\u0010\u0019\u001a\u00020\b2\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u000e\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u00042\u0006\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\b2\u0006\u0010\u001a\u001a\u00020\u00042\u0006\u0010\u000b\u001a\u00020\b2\u0006\u0010\u001b\u001a\u00020\u0004H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u001c"}, d2 = {"Landroidx/compose/material3/carousel/Arrangement$Companion;", "", "()V", "MediumItemFlexPercentage", "", "calculateLargeSize", "availableSpace", "smallCount", "", "smallSize", "mediumCount", "largeCount", "findLowestCostArrangement", "Landroidx/compose/material3/carousel/Arrangement;", "itemSpacing", "targetSmallSize", "minSmallSize", "maxSmallSize", "smallCounts", "", "targetMediumSize", "mediumCounts", "targetLargeSize", "largeCounts", "fit", "priority", "mediumSize", "largeSize", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private final float calculateLargeSize(float availableSpace, int smallCount, float smallSize, int mediumCount, int largeCount) {
            float f = mediumCount / 2.0f;
            return (availableSpace - ((smallCount + f) * smallSize)) / (largeCount + f);
        }

        private Companion() {
        }

        public final Arrangement findLowestCostArrangement(float availableSpace, float itemSpacing, float targetSmallSize, float minSmallSize, float maxSmallSize, int[] smallCounts, float targetMediumSize, int[] mediumCounts, float targetLargeSize, int[] largeCounts) {
            int length = largeCounts.length;
            Arrangement arrangement = null;
            int i = 1;
            int i2 = 0;
            while (i2 < length) {
                int i3 = largeCounts[i2];
                int length2 = mediumCounts.length;
                int i4 = 0;
                while (i4 < length2) {
                    int i5 = mediumCounts[i4];
                    int length3 = smallCounts.length;
                    Arrangement arrangement2 = arrangement;
                    int i6 = i;
                    int i7 = 0;
                    while (i7 < length3) {
                        int i8 = smallCounts[i7];
                        int i9 = i7;
                        Arrangement arrangement3 = arrangement2;
                        int i10 = length3;
                        int i11 = i4;
                        int i12 = length2;
                        int i13 = i2;
                        int i14 = length;
                        Arrangement arrangementFit = fit(i6, availableSpace, itemSpacing, i8, targetSmallSize, minSmallSize, maxSmallSize, i5, targetMediumSize, i3, targetLargeSize);
                        if (arrangement3 != null && arrangementFit.cost(targetLargeSize) >= arrangement3.cost(targetLargeSize)) {
                            arrangement2 = arrangement3;
                        } else {
                            if (arrangementFit.cost(targetLargeSize) == 0.0f) {
                                return arrangementFit;
                            }
                            arrangement2 = arrangementFit;
                        }
                        i6++;
                        i7 = i9 + 1;
                        smallCounts = smallCounts;
                        length3 = i10;
                        i4 = i11;
                        length2 = i12;
                        i2 = i13;
                        length = i14;
                    }
                    i4++;
                    arrangement = arrangement2;
                    i = i6;
                    smallCounts = smallCounts;
                }
                i2++;
            }
            return arrangement;
        }

        private final Arrangement fit(int priority, float availableSpace, float itemSpacing, int smallCount, float smallSize, float minSmallSize, float maxSmallSize, int mediumCount, float mediumSize, int largeCount, float largeSize) {
            float fMax;
            float f;
            float fCalculateLargeSize;
            float f2;
            float f3;
            float fMin;
            float f4 = availableSpace - ((((largeCount + mediumCount) + smallCount) - 1) * itemSpacing);
            float fCoerceIn = RangesKt.coerceIn(smallSize, minSmallSize, maxSmallSize);
            float f5 = largeCount;
            float f6 = mediumCount;
            float f7 = smallCount;
            float f8 = f4 - (((largeSize * f5) + (mediumSize * f6)) + (fCoerceIn * f7));
            if (smallCount > 0 && f8 > 0.0f) {
                fMax = Math.min(f8 / f7, maxSmallSize - fCoerceIn);
            } else {
                if (smallCount > 0 && f8 < 0.0f) {
                    fMax = Math.max(f8 / f7, minSmallSize - fCoerceIn);
                }
                if (smallCount > 0) {
                    f = fCoerceIn;
                } else {
                    f = 0.0f;
                }
                fCalculateLargeSize = calculateLargeSize(f4, smallCount, f, mediumCount, largeCount);
                f2 = (fCalculateLargeSize + f) / 2.0f;
                if (mediumCount > 0 && fCalculateLargeSize != largeSize) {
                    f3 = (largeSize - fCalculateLargeSize) * f5;
                    fMin = Math.min(Math.abs(f3), 0.1f * f2 * f6);
                    if (f3 > 0.0f) {
                        f2 -= fMin / f6;
                        fCalculateLargeSize += fMin / f5;
                    } else {
                        f2 += fMin / f6;
                        fCalculateLargeSize -= fMin / f5;
                    }
                }
                return new Arrangement(priority, f, smallCount, f2, mediumCount, fCalculateLargeSize, largeCount);
            }
            fCoerceIn += fMax;
            if (smallCount > 0) {
                f = fCoerceIn;
            } else {
                f = 0.0f;
            }
            fCalculateLargeSize = calculateLargeSize(f4, smallCount, f, mediumCount, largeCount);
            f2 = (fCalculateLargeSize + f) / 2.0f;
            if (mediumCount > 0) {
                f3 = (largeSize - fCalculateLargeSize) * f5;
                fMin = Math.min(Math.abs(f3), 0.1f * f2 * f6);
                if (f3 > 0.0f) {
                    f2 -= fMin / f6;
                    fCalculateLargeSize += fMin / f5;
                } else {
                    f2 += fMin / f6;
                    fCalculateLargeSize -= fMin / f5;
                }
            }
            return new Arrangement(priority, f, smallCount, f2, mediumCount, fCalculateLargeSize, largeCount);
        }
    }
}
