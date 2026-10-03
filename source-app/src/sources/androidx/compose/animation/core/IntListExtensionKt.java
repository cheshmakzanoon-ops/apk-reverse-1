package androidx.compose.animation.core;

import androidx.collection.IntList;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a(\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00012\b\b\u0002\u0010\u0004\u001a\u00020\u00012\b\b\u0002\u0010\u0005\u001a\u00020\u0001H\u0001¨\u0006\u0006"}, d2 = {"binarySearch", "", "Landroidx/collection/IntList;", "element", "fromIndex", "toIndex", "animation-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class IntListExtensionKt {
    public static final int binarySearch(IntList intList, int i) {
        return binarySearch$default(intList, i, 0, 0, 6, null);
    }

    public static final int binarySearch(IntList intList, int i, int i2) {
        return binarySearch$default(intList, i, i2, 0, 4, null);
    }

    public static int binarySearch$default(IntList intList, int i, int i2, int i3, int i4, Object obj) {
        if ((i4 & 2) != 0) {
            i2 = 0;
        }
        if ((i4 & 4) != 0) {
            i3 = intList.getSize();
        }
        return binarySearch(intList, i, i2, i3);
    }

    public static final int binarySearch(IntList intList, int i, int i2, int i3) {
        if (!(i2 <= i3)) {
            PreconditionsKt.throwIllegalArgumentException("fromIndex(" + i2 + ") > toIndex(" + i3 + ')');
        }
        if (i2 < 0) {
            throw new IndexOutOfBoundsException("Index out of range: " + i2);
        }
        if (i3 > intList.getSize()) {
            throw new IndexOutOfBoundsException("Index out of range: " + i3);
        }
        int i4 = i3 - 1;
        while (i2 <= i4) {
            int i5 = (i2 + i4) >>> 1;
            int i6 = intList.get(i5);
            if (i6 < i) {
                i2 = i5 + 1;
            } else {
                if (i6 <= i) {
                    return i5;
                }
                i4 = i5 - 1;
            }
        }
        return -(i2 + 1);
    }
}
