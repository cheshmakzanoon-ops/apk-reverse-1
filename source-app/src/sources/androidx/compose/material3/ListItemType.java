package androidx.compose.material3;

import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u000f\n\u0000\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\u0010\u0000\n\u0002\b\u0005\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0083@\u0018\u0000 \u00152\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001\u0015B\u0011\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u001b\u0010\u0006\u001a\u00020\u00032\u0006\u0010\u0007\u001a\u00020\u0000H\u0096\u0002ø\u0001\u0000¢\u0006\u0004\b\b\u0010\tJ\u001a\u0010\n\u001a\u00020\u000b2\b\u0010\u0007\u001a\u0004\u0018\u00010\fHÖ\u0003¢\u0006\u0004\b\r\u0010\u000eJ\u0010\u0010\u000f\u001a\u00020\u0003HÖ\u0001¢\u0006\u0004\b\u0010\u0010\u0005J\u0010\u0010\u0011\u001a\u00020\u0012HÖ\u0001¢\u0006\u0004\b\u0013\u0010\u0014R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0088\u0001\u0002\u0092\u0001\u00020\u0003\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0016"}, d2 = {"Landroidx/compose/material3/ListItemType;", "", "lines", "", "constructor-impl", "(I)I", "compareTo", "other", "compareTo-yh95HIg", "(II)I", "equals", "", "", "equals-impl", "(ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "(I)Ljava/lang/String;", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
final class ListItemType implements Comparable<ListItemType> {
    private final int lines;

    public static final Companion INSTANCE = new Companion(null);
    private static final int OneLine = m2491constructorimpl(1);
    private static final int TwoLine = m2491constructorimpl(2);
    private static final int ThreeLine = m2491constructorimpl(3);

    public static final ListItemType m2489boximpl(int i) {
        return new ListItemType(i);
    }

    private static int m2491constructorimpl(int i) {
        return i;
    }

    public static boolean m2492equalsimpl(int i, Object obj) {
        return (obj instanceof ListItemType) && i == ((ListItemType) obj).getLines();
    }

    public static final boolean m2493equalsimpl0(int i, int i2) {
        return i == i2;
    }

    public static int m2494hashCodeimpl(int i) {
        return i;
    }

    public static String m2495toStringimpl(int i) {
        return "ListItemType(lines=" + i + ')';
    }

    public boolean equals(Object obj) {
        return m2492equalsimpl(this.lines, obj);
    }

    public int hashCode() {
        return m2494hashCodeimpl(this.lines);
    }

    public String toString() {
        return m2495toStringimpl(this.lines);
    }

    public final int getLines() {
        return this.lines;
    }

    @Override
    public int compareTo(ListItemType listItemType) {
        return m2496compareToyh95HIg(listItemType.getLines());
    }

    private ListItemType(int i) {
        this.lines = i;
    }

    public static int m2490compareToyh95HIg(int i, int i2) {
        return Intrinsics.compare(i, i2);
    }

    public int m2496compareToyh95HIg(int i) {
        return m2490compareToyh95HIg(this.lines, i);
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0005\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J.\u0010\f\u001a\u00020\u00042\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0010\u001a\u00020\u000eH\u0080\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012R\u0019\u0010\u0003\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006R\u0019\u0010\b\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\t\u0010\u0006R\u0019\u0010\n\u001a\u00020\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u000b\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0013"}, d2 = {"Landroidx/compose/material3/ListItemType$Companion;", "", "()V", "OneLine", "Landroidx/compose/material3/ListItemType;", "getOneLine-AlXitO8", "()I", "I", "ThreeLine", "getThreeLine-AlXitO8", "TwoLine", "getTwoLine-AlXitO8", "invoke", "hasOverline", "", "hasSupporting", "isSupportingMultiline", "invoke-Z-LSjz4$material3_release", "(ZZZ)I", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final int m2498getOneLineAlXitO8() {
            return ListItemType.OneLine;
        }

        public final int m2500getTwoLineAlXitO8() {
            return ListItemType.TwoLine;
        }

        public final int m2499getThreeLineAlXitO8() {
            return ListItemType.ThreeLine;
        }

        public final int m2501invokeZLSjz4$material3_release(boolean hasOverline, boolean hasSupporting, boolean isSupportingMultiline) {
            if ((hasOverline && hasSupporting) || isSupportingMultiline) {
                return m2499getThreeLineAlXitO8();
            }
            if (hasOverline || hasSupporting) {
                return m2500getTwoLineAlXitO8();
            }
            return m2498getOneLineAlXitO8();
        }
    }
}
