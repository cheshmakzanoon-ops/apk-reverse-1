package androidx.compose.foundation.lazy.grid;

import androidx.compose.foundation.lazy.layout.IntervalList;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0006\b\u0000\u0018\u00002\u00020\u0001:\u0003()*B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0016\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00150\u00142\u0006\u0010\u001e\u001a\u00020\u0006H\u0002J\u000e\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\u0006J\u000e\u0010\"\u001a\u00020\u00062\u0006\u0010#\u001a\u00020\u0006J\b\u0010$\u001a\u00020%H\u0002J\u0016\u0010&\u001a\u00020\u00062\u0006\u0010#\u001a\u00020\u00062\u0006\u0010'\u001a\u00020\u0006R\u0014\u0010\u0005\u001a\u00020\u00068BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\bR\u001e\u0010\t\u001a\u0012\u0012\u0004\u0012\u00020\u000b0\nj\b\u0012\u0004\u0012\u00020\u000b`\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00150\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010\u0017\u001a\u00020\u00062\u0006\u0010\u0016\u001a\u00020\u0006@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\b\"\u0004\b\u0019\u0010\u001aR\u0011\u0010\u001b\u001a\u00020\u00068F¢\u0006\u0006\u001a\u0004\b\u001c\u0010\b¨\u0006+"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider;", "", "gridContent", "Landroidx/compose/foundation/lazy/grid/LazyGridIntervalContent;", "(Landroidx/compose/foundation/lazy/grid/LazyGridIntervalContent;)V", "bucketSize", "", "getBucketSize", "()I", "buckets", "Ljava/util/ArrayList;", "Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider$Bucket;", "Lkotlin/collections/ArrayList;", "cachedBucket", "", "cachedBucketIndex", "lastLineIndex", "lastLineStartItemIndex", "lastLineStartKnownSpan", "previousDefaultSpans", "", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "value", "slotsPerLine", "getSlotsPerLine", "setSlotsPerLine", "(I)V", "totalSize", "getTotalSize", "getDefaultSpans", "currentSlotsPerLine", "getLineConfiguration", "Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider$LineConfiguration;", "lineIndex", "getLineIndexOfItem", "itemIndex", "invalidateCache", "", "spanOf", "maxSpan", "Bucket", "LazyGridItemSpanScopeImpl", "LineConfiguration", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LazyGridSpanLayoutProvider {
    public static final int $stable = 8;
    private final ArrayList<Bucket> buckets;
    private final List<Integer> cachedBucket;
    private int cachedBucketIndex;
    private final LazyGridIntervalContent gridContent;
    private int lastLineIndex;
    private int lastLineStartItemIndex;
    private int lastLineStartKnownSpan;
    private List<GridItemSpan> previousDefaultSpans;
    private int slotsPerLine;

    public LazyGridSpanLayoutProvider(LazyGridIntervalContent lazyGridIntervalContent) {
        this.gridContent = lazyGridIntervalContent;
        ArrayList<Bucket> arrayList = new ArrayList<>();
        int i = 0;
        arrayList.add(new Bucket(i, i, 2, null));
        this.buckets = arrayList;
        this.cachedBucketIndex = -1;
        this.cachedBucket = new ArrayList();
        this.previousDefaultSpans = CollectionsKt.emptyList();
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u00020\u0001B\u001b\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\u0002\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\f"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider$LineConfiguration;", "", "firstItemIndex", "", "spans", "", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "(ILjava/util/List;)V", "getFirstItemIndex", "()I", "getSpans", "()Ljava/util/List;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class LineConfiguration {
        public static final int $stable = 8;
        private final int firstItemIndex;
        private final List<GridItemSpan> spans;

        public LineConfiguration(int i, List<GridItemSpan> list) {
            this.firstItemIndex = i;
            this.spans = list;
        }

        public final int getFirstItemIndex() {
            return this.firstItemIndex;
        }

        public final List<GridItemSpan> getSpans() {
            return this.spans;
        }
    }

    private final int getBucketSize() {
        return ((int) Math.sqrt((((double) getTotalSize()) * 1.0d) / ((double) this.slotsPerLine))) + 1;
    }

    private final List<GridItemSpan> getDefaultSpans(int currentSlotsPerLine) {
        if (currentSlotsPerLine == this.previousDefaultSpans.size()) {
            return this.previousDefaultSpans;
        }
        ArrayList arrayList = new ArrayList(currentSlotsPerLine);
        for (int i = 0; i < currentSlotsPerLine; i++) {
            arrayList.add(GridItemSpan.m1160boximpl(LazyGridSpanKt.GridItemSpan(1)));
        }
        ArrayList arrayList2 = arrayList;
        this.previousDefaultSpans = arrayList2;
        return arrayList2;
    }

    public final int getTotalSize() {
        return this.gridContent.getIntervals().getSize();
    }

    public final int getSlotsPerLine() {
        return this.slotsPerLine;
    }

    public final void setSlotsPerLine(int i) {
        if (i != this.slotsPerLine) {
            this.slotsPerLine = i;
            invalidateCache();
        }
    }

    public final LineConfiguration getLineConfiguration(int lineIndex) {
        int i;
        boolean z;
        int i2;
        int i3;
        if (!this.gridContent.getHasCustomSpans()) {
            int i4 = lineIndex * this.slotsPerLine;
            return new LineConfiguration(i4, getDefaultSpans(RangesKt.coerceAtLeast(RangesKt.coerceAtMost(this.slotsPerLine, getTotalSize() - i4), 0)));
        }
        int iMin = Math.min(lineIndex / getBucketSize(), this.buckets.size() - 1);
        int bucketSize = getBucketSize() * iMin;
        int firstItemIndex = this.buckets.get(iMin).getFirstItemIndex();
        int firstItemKnownSpan = this.buckets.get(iMin).getFirstItemKnownSpan();
        int i5 = this.lastLineIndex;
        if (bucketSize <= i5 && i5 <= lineIndex) {
            firstItemIndex = this.lastLineStartItemIndex;
            firstItemKnownSpan = this.lastLineStartKnownSpan;
            bucketSize = i5;
        } else if (iMin == this.cachedBucketIndex && (i = lineIndex - bucketSize) < this.cachedBucket.size()) {
            firstItemIndex = this.cachedBucket.get(i).intValue();
            bucketSize = lineIndex;
            firstItemKnownSpan = 0;
        }
        if (bucketSize % getBucketSize() == 0) {
            int i6 = lineIndex - bucketSize;
            z = 2 <= i6 && i6 < getBucketSize();
        }
        if (z) {
            this.cachedBucketIndex = iMin;
            this.cachedBucket.clear();
        }
        if (bucketSize > lineIndex) {
            throw new IllegalStateException("currentLine > lineIndex".toString());
        }
        while (bucketSize < lineIndex && firstItemIndex < getTotalSize()) {
            if (z) {
                this.cachedBucket.add(Integer.valueOf(firstItemIndex));
            }
            int i7 = 0;
            while (i7 < this.slotsPerLine && firstItemIndex < getTotalSize()) {
                if (firstItemKnownSpan == 0) {
                    i3 = firstItemKnownSpan;
                    firstItemKnownSpan = spanOf(firstItemIndex, this.slotsPerLine - i7);
                } else {
                    i3 = 0;
                }
                i7 += firstItemKnownSpan;
                if (i7 > this.slotsPerLine) {
                    break;
                }
                firstItemIndex++;
                firstItemKnownSpan = i3;
            }
            bucketSize++;
            if (bucketSize % getBucketSize() == 0 && firstItemIndex < getTotalSize()) {
                if (this.buckets.size() != bucketSize / getBucketSize()) {
                    throw new IllegalStateException("invalid starting point".toString());
                }
                this.buckets.add(new Bucket(firstItemIndex, firstItemKnownSpan));
            }
        }
        this.lastLineIndex = lineIndex;
        this.lastLineStartItemIndex = firstItemIndex;
        this.lastLineStartKnownSpan = firstItemKnownSpan;
        ArrayList arrayList = new ArrayList();
        int i8 = 0;
        int i9 = firstItemIndex;
        while (i8 < this.slotsPerLine && i9 < getTotalSize()) {
            if (firstItemKnownSpan == 0) {
                int i10 = firstItemKnownSpan;
                firstItemKnownSpan = spanOf(i9, this.slotsPerLine - i8);
                i2 = i10;
            } else {
                i2 = 0;
            }
            i8 += firstItemKnownSpan;
            if (i8 > this.slotsPerLine) {
                break;
            }
            i9++;
            arrayList.add(GridItemSpan.m1160boximpl(LazyGridSpanKt.GridItemSpan(firstItemKnownSpan)));
            firstItemKnownSpan = i2;
        }
        return new LineConfiguration(firstItemIndex, arrayList);
    }

    public final int getLineIndexOfItem(final int itemIndex) {
        int i = 0;
        if (getTotalSize() <= 0) {
            return 0;
        }
        if (itemIndex >= getTotalSize()) {
            throw new IllegalArgumentException("ItemIndex > total count".toString());
        }
        if (!this.gridContent.getHasCustomSpans()) {
            return itemIndex / this.slotsPerLine;
        }
        int iBinarySearch$default = CollectionsKt.binarySearch$default(this.buckets, 0, 0, new Function1<Bucket, Integer>() {
            {
                super(1);
            }

            public final Integer invoke(LazyGridSpanLayoutProvider.Bucket bucket) {
                return Integer.valueOf(bucket.getFirstItemIndex() - itemIndex);
            }
        }, 3, (Object) null);
        int i2 = 2;
        if (iBinarySearch$default < 0) {
            iBinarySearch$default = (-iBinarySearch$default) - 2;
        }
        int bucketSize = getBucketSize() * iBinarySearch$default;
        int firstItemIndex = this.buckets.get(iBinarySearch$default).getFirstItemIndex();
        if (firstItemIndex > itemIndex) {
            throw new IllegalArgumentException("currentItemIndex > itemIndex".toString());
        }
        int i3 = 0;
        while (firstItemIndex < itemIndex) {
            int i4 = firstItemIndex + 1;
            int iSpanOf = spanOf(firstItemIndex, this.slotsPerLine - i3);
            i3 += iSpanOf;
            int i5 = this.slotsPerLine;
            if (i3 >= i5) {
                if (i3 == i5) {
                    bucketSize++;
                    i3 = 0;
                } else {
                    bucketSize++;
                    i3 = iSpanOf;
                }
            }
            if (bucketSize % getBucketSize() == 0 && bucketSize / getBucketSize() >= this.buckets.size()) {
                this.buckets.add(new Bucket(i4 - (i3 > 0 ? 1 : 0), i, i2, null));
            }
            firstItemIndex = i4;
        }
        return i3 + spanOf(itemIndex, this.slotsPerLine - i3) > this.slotsPerLine ? bucketSize + 1 : bucketSize;
    }

    public final int spanOf(int itemIndex, int maxSpan) {
        LazyGridItemSpanScopeImpl lazyGridItemSpanScopeImpl = LazyGridItemSpanScopeImpl.INSTANCE;
        lazyGridItemSpanScopeImpl.setMaxCurrentLineSpan(maxSpan);
        lazyGridItemSpanScopeImpl.setMaxLineSpan(this.slotsPerLine);
        IntervalList.Interval<LazyGridInterval> interval = this.gridContent.getIntervals().get(itemIndex);
        return GridItemSpan.m1164getCurrentLineSpanimpl(((GridItemSpan) interval.getValue().getSpan().invoke(lazyGridItemSpanScopeImpl, Integer.valueOf(itemIndex - interval.getStartIndex()))).getPackedValue());
    }

    private final void invalidateCache() {
        this.buckets.clear();
        int i = 0;
        this.buckets.add(new Bucket(i, i, 2, null));
        this.lastLineIndex = 0;
        this.lastLineStartItemIndex = 0;
        this.lastLineStartKnownSpan = 0;
        this.cachedBucketIndex = -1;
        this.cachedBucket.clear();
    }

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\b\u0002\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\t"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider$Bucket;", "", "firstItemIndex", "", "firstItemKnownSpan", "(II)V", "getFirstItemIndex", "()I", "getFirstItemKnownSpan", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    static final class Bucket {
        private final int firstItemIndex;
        private final int firstItemKnownSpan;

        public Bucket(int i, int i2) {
            this.firstItemIndex = i;
            this.firstItemKnownSpan = i2;
        }

        public Bucket(int i, int i2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
            this(i, (i3 & 2) != 0 ? 0 : i2);
        }

        public final int getFirstItemIndex() {
            return this.firstItemIndex;
        }

        public final int getFirstItemKnownSpan() {
            return this.firstItemKnownSpan;
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\b\bÂ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001a\u0010\u0003\u001a\u00020\u0004X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001a\u0010\t\u001a\u00020\u0004X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\n\u0010\u0006\"\u0004\b\u000b\u0010\b¨\u0006\f"}, d2 = {"Landroidx/compose/foundation/lazy/grid/LazyGridSpanLayoutProvider$LazyGridItemSpanScopeImpl;", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "()V", "maxCurrentLineSpan", "", "getMaxCurrentLineSpan", "()I", "setMaxCurrentLineSpan", "(I)V", "maxLineSpan", "getMaxLineSpan", "setMaxLineSpan", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class LazyGridItemSpanScopeImpl implements LazyGridItemSpanScope {
        public static final LazyGridItemSpanScopeImpl INSTANCE = new LazyGridItemSpanScopeImpl();
        private static int maxCurrentLineSpan;
        private static int maxLineSpan;

        private LazyGridItemSpanScopeImpl() {
        }

        @Override
        public int getMaxCurrentLineSpan() {
            return maxCurrentLineSpan;
        }

        public void setMaxCurrentLineSpan(int i) {
            maxCurrentLineSpan = i;
        }

        @Override
        public int getMaxLineSpan() {
            return maxLineSpan;
        }

        public void setMaxLineSpan(int i) {
            maxLineSpan = i;
        }
    }
}
