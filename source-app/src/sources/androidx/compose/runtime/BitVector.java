package androidx.compose.runtime;

import androidx.compose.p002ui.graphics.Fields;
import java.util.Arrays;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0016\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0011\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\tH\u0086\u0002J\u000e\u0010\u000f\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\tJ\u000e\u0010\u0010\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\tJ\u0019\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u000e\u001a\u00020\t2\u0006\u0010\u0013\u001a\u00020\rH\u0086\u0002J\u0016\u0010\u0014\u001a\u00020\u00122\u0006\u0010\u0015\u001a\u00020\t2\u0006\u0010\u0016\u001a\u00020\tJ\b\u0010\u0017\u001a\u00020\u0018H\u0016R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\b\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\n\u0010\u000b¨\u0006\u0019"}, d2 = {"Landroidx/compose/runtime/BitVector;", "", "()V", "first", "", "others", "", "second", "size", "", "getSize", "()I", "get", "", "index", "nextClear", "nextSet", "set", "", "value", "setRange", "start", "end", "toString", "", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class BitVector {
    public static final int $stable = 8;
    private long first;
    private long[] others;
    private long second;

    public final int getSize() {
        long[] jArr = this.others;
        return jArr != null ? (jArr.length + 2) * 64 : Fields.SpotShadowColor;
    }

    public final boolean get(int index) {
        int i;
        if (index < 0 || index >= getSize()) {
            throw new IllegalStateException(("Index " + index + " out of bound").toString());
        }
        if (index < 64) {
            return ((1 << index) & this.first) != 0;
        }
        if (index < 128) {
            return ((1 << (index - 64)) & this.second) != 0;
        }
        long[] jArr = this.others;
        if (jArr != null && (i = (index / 64) - 2) < jArr.length) {
            return ((1 << (index % 64)) & jArr[i]) != 0;
        }
        return false;
    }

    public final void set(int index, boolean value) {
        if (index < 64) {
            long j = 1 << index;
            this.first = value ? this.first | j : this.first & (~j);
            return;
        }
        if (index < 128) {
            long j2 = 1 << (index - 64);
            this.second = value ? this.second | j2 : this.second & (~j2);
            return;
        }
        int i = index / 64;
        int i2 = i - 2;
        long j3 = 1 << (index % 64);
        long[] jArrCopyOf = this.others;
        if (jArrCopyOf == null) {
            jArrCopyOf = new long[i - 1];
            this.others = jArrCopyOf;
        }
        if (i2 >= jArrCopyOf.length) {
            jArrCopyOf = Arrays.copyOf(jArrCopyOf, i - 1);
            Intrinsics.checkNotNullExpressionValue(jArrCopyOf, "copyOf(this, newSize)");
            this.others = jArrCopyOf;
        }
        long j4 = jArrCopyOf[i2];
        jArrCopyOf[i2] = value ? j3 | j4 : (~j3) & j4;
    }

    public final int nextSet(int index) {
        int size = getSize();
        while (index < size) {
            if (get(index)) {
                return index;
            }
            index++;
        }
        return Integer.MAX_VALUE;
    }

    public final int nextClear(int index) {
        int size = getSize();
        while (index < size) {
            if (!get(index)) {
                return index;
            }
            index++;
        }
        return Integer.MAX_VALUE;
    }

    public final void setRange(int start, int end) {
        while (start < end) {
            set(start, true);
            start++;
        }
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("BitVector [");
        int size = getSize();
        boolean z = true;
        for (int i = 0; i < size; i++) {
            if (get(i)) {
                if (!z) {
                    sb.append(", ");
                }
                sb.append(i);
                z = false;
            }
        }
        sb.append(']');
        String string = sb.toString();
        Intrinsics.checkNotNullExpressionValue(string, "StringBuilder().apply(builderAction).toString()");
        return string;
    }
}
