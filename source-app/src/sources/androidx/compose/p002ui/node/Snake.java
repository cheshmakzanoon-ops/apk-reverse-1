package androidx.compose.p002ui.node;

import java.util.Arrays;
import kotlin.Metadata;
import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0015\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000e\n\u0002\b\u0003\b\u0083@\u0018\u00002\u00020\u0001B\u000f\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0004\b\u0004\u0010\u0005J\u0015\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u001f¢\u0006\u0004\b \u0010!J\u001a\u0010\"\u001a\u00020\u00112\b\u0010#\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b$\u0010%J\u0010\u0010&\u001a\u00020\tHÖ\u0001¢\u0006\u0004\b'\u0010\u000bJ\u000f\u0010(\u001a\u00020)H\u0016¢\u0006\u0004\b*\u0010+R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\b\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\f\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\r\u0010\u000bR\u0011\u0010\u000e\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u000bR\u0014\u0010\u0010\u001a\u00020\u00118BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0014\u001a\u00020\u00118BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0013R\u0011\u0010\u0016\u001a\u00020\u00118F¢\u0006\u0006\u001a\u0004\b\u0017\u0010\u0013R\u0011\u0010\u0018\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\u0019\u0010\u000bR\u0011\u0010\u001a\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u000b\u0088\u0001\u0002¨\u0006,"}, d2 = {"Landroidx/compose/ui/node/Snake;", "", "data", "", "constructor-impl", "([I)[I", "getData", "()[I", "diagonalSize", "", "getDiagonalSize-impl", "([I)I", "endX", "getEndX-impl", "endY", "getEndY-impl", "hasAdditionOrRemoval", "", "getHasAdditionOrRemoval-impl", "([I)Z", "isAddition", "isAddition-impl", "reverse", "getReverse-impl", "startX", "getStartX-impl", "startY", "getStartY-impl", "addDiagonalToStack", "", "diagonals", "Landroidx/compose/ui/node/IntStack;", "addDiagonalToStack-impl", "([ILandroidx/compose/ui/node/IntStack;)V", "equals", "other", "equals-impl", "([ILjava/lang/Object;)Z", "hashCode", "hashCode-impl", "toString", "", "toString-impl", "([I)Ljava/lang/String;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
@JvmInline
final class Snake {
    private final int[] data;

    public static final Snake m6427boximpl(int[] iArr) {
        return new Snake(iArr);
    }

    public static int[] m6428constructorimpl(int[] iArr) {
        return iArr;
    }

    public static boolean m6429equalsimpl(int[] iArr, Object obj) {
        return (obj instanceof Snake) && Intrinsics.areEqual(iArr, ((Snake) obj).m6441unboximpl());
    }

    public static final boolean m6430equalsimpl0(int[] iArr, int[] iArr2) {
        return Intrinsics.areEqual(iArr, iArr2);
    }

    public static int m6438hashCodeimpl(int[] iArr) {
        return Arrays.hashCode(iArr);
    }

    public boolean equals(Object obj) {
        return m6429equalsimpl(this.data, obj);
    }

    public int hashCode() {
        return m6438hashCodeimpl(this.data);
    }

    public final int[] m6441unboximpl() {
        return this.data;
    }

    private Snake(int[] iArr) {
        this.data = iArr;
    }

    public final int[] getData() {
        return this.data;
    }

    public static final int m6436getStartXimpl(int[] iArr) {
        return iArr[0];
    }

    public static final int m6437getStartYimpl(int[] iArr) {
        return iArr[1];
    }

    public static final int m6432getEndXimpl(int[] iArr) {
        return iArr[2];
    }

    public static final int m6433getEndYimpl(int[] iArr) {
        return iArr[3];
    }

    public static final boolean m6435getReverseimpl(int[] iArr) {
        return iArr[4] != 0;
    }

    public static final int m6431getDiagonalSizeimpl(int[] iArr) {
        return Math.min(m6432getEndXimpl(iArr) - m6436getStartXimpl(iArr), m6433getEndYimpl(iArr) - m6437getStartYimpl(iArr));
    }

    private static final boolean m6434getHasAdditionOrRemovalimpl(int[] iArr) {
        return m6433getEndYimpl(iArr) - m6437getStartYimpl(iArr) != m6432getEndXimpl(iArr) - m6436getStartXimpl(iArr);
    }

    private static final boolean m6439isAdditionimpl(int[] iArr) {
        return m6433getEndYimpl(iArr) - m6437getStartYimpl(iArr) > m6432getEndXimpl(iArr) - m6436getStartXimpl(iArr);
    }

    public static final void m6426addDiagonalToStackimpl(int[] iArr, IntStack intStack) {
        if (m6434getHasAdditionOrRemovalimpl(iArr)) {
            if (m6435getReverseimpl(iArr)) {
                intStack.pushDiagonal(m6436getStartXimpl(iArr), m6437getStartYimpl(iArr), m6431getDiagonalSizeimpl(iArr));
                return;
            } else if (m6439isAdditionimpl(iArr)) {
                intStack.pushDiagonal(m6436getStartXimpl(iArr), m6437getStartYimpl(iArr) + 1, m6431getDiagonalSizeimpl(iArr));
                return;
            } else {
                intStack.pushDiagonal(m6436getStartXimpl(iArr) + 1, m6437getStartYimpl(iArr), m6431getDiagonalSizeimpl(iArr));
                return;
            }
        }
        intStack.pushDiagonal(m6436getStartXimpl(iArr), m6437getStartYimpl(iArr), m6432getEndXimpl(iArr) - m6436getStartXimpl(iArr));
    }

    public static String m6440toStringimpl(int[] iArr) {
        return "Snake(" + m6436getStartXimpl(iArr) + ',' + m6437getStartYimpl(iArr) + ',' + m6432getEndXimpl(iArr) + ',' + m6433getEndYimpl(iArr) + ',' + m6435getReverseimpl(iArr) + ')';
    }

    public String toString() {
        return m6440toStringimpl(this.data);
    }
}
