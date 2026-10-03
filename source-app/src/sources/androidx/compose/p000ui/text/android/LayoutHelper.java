package androidx.compose.p000ui.text.android;

import android.text.Layout;
import android.text.TextUtils;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import java.text.Bidi;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;
import kotlin.text.StringsKt;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0018\n\u0002\b\u0003\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0019\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\f\n\u0002\b\u0006\b\u0000\u0018\u00002\u00020\u0001:\u0001/B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\u0014\u001a\u0004\u0018\u00010\u000b2\u0006\u0010\u0015\u001a\u00020\rJ\u0018\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\r2\u0006\u0010\u0019\u001a\u00020\u001aH\u0002J\u001e\u0010\u001b\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\r2\u0006\u0010\u001c\u001a\u00020\u001a2\u0006\u0010\u001d\u001a\u00020\u001aJ\u001d\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020 0\u001f2\u0006\u0010!\u001a\u00020\rH\u0000¢\u0006\u0004\b\"\u0010#J\u000e\u0010$\u001a\u00020\r2\u0006\u0010!\u001a\u00020\rJ\u0010\u0010%\u001a\u00020\r2\b\b\u0001\u0010\u0015\u001a\u00020\rJ\u001a\u0010&\u001a\u00020\r2\b\b\u0001\u0010\u0018\u001a\u00020\r2\b\b\u0002\u0010\u001d\u001a\u00020\u001aJ\u0010\u0010'\u001a\u00020\r2\b\b\u0001\u0010\u0015\u001a\u00020\rJ\u000e\u0010(\u001a\u00020\u001a2\u0006\u0010)\u001a\u00020*J\u0010\u0010+\u001a\u00020\u001a2\b\b\u0001\u0010\u0015\u001a\u00020\rJ\u0018\u0010,\u001a\u00020\r2\u0006\u0010-\u001a\u00020\r2\u0006\u0010.\u001a\u00020\rH\u0002R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0016\u0010\t\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0014\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\r0\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0012\u001a\u0004\u0018\u00010\u0013X\u0082\u000e¢\u0006\u0002\n\u0000¨\u00060"}, d2 = {"Landroidx/compose/ui/text/android/LayoutHelper;", "", "layout", "Landroid/text/Layout;", "(Landroid/text/Layout;)V", "bidiProcessedParagraphs", "", "getLayout", "()Landroid/text/Layout;", "paragraphBidi", "", "Ljava/text/Bidi;", "paragraphCount", "", "getParagraphCount", "()I", "paragraphEnds", "", "tmpBuffer", "", "analyzeBidi", "paragraphIndex", "getDownstreamHorizontal", "", TypedValues.CycleType.S_WAVE_OFFSET, "primary", "", "getHorizontalPosition", "usePrimaryDirection", "upstream", "getLineBidiRuns", "", "Landroidx/compose/ui/text/android/LayoutHelper$BidiRun;", "lineIndex", "getLineBidiRuns$ui_text_release", "(I)[Landroidx/compose/ui/text/android/LayoutHelper$BidiRun;", "getLineVisibleEnd", "getParagraphEnd", "getParagraphForOffset", "getParagraphStart", "isLineEndSpace", "c", "", "isRtlParagraph", "lineEndToVisibleEnd", "lineEnd", "lineStart", "BidiRun", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class LayoutHelper {
    public static final int $stable = 8;
    private final boolean[] bidiProcessedParagraphs;
    private final Layout layout;
    private final List<Bidi> paragraphBidi;
    private final int paragraphCount;
    private final List<Integer> paragraphEnds;
    private char[] tmpBuffer;

    public LayoutHelper(Layout layout) {
        this.layout = layout;
        ArrayList arrayList = new ArrayList();
        int length = 0;
        do {
            int iIndexOf$default = StringsKt.indexOf$default(this.layout.getText(), '\n', length, false, 4, (Object) null);
            length = iIndexOf$default < 0 ? this.layout.getText().length() : iIndexOf$default + 1;
            arrayList.add(Integer.valueOf(length));
        } while (length < this.layout.getText().length());
        this.paragraphEnds = arrayList;
        int size = arrayList.size();
        ArrayList arrayList2 = new ArrayList(size);
        for (int i = 0; i < size; i++) {
            arrayList2.add(null);
        }
        this.paragraphBidi = arrayList2;
        this.bidiProcessedParagraphs = new boolean[this.paragraphEnds.size()];
        this.paragraphCount = this.paragraphEnds.size();
    }

    public final Layout getLayout() {
        return this.layout;
    }

    public final Bidi analyzeBidi(int paragraphIndex) {
        Bidi bidi;
        if (this.bidiProcessedParagraphs[paragraphIndex]) {
            return this.paragraphBidi.get(paragraphIndex);
        }
        int iIntValue = paragraphIndex == 0 ? 0 : this.paragraphEnds.get(paragraphIndex - 1).intValue();
        int iIntValue2 = this.paragraphEnds.get(paragraphIndex).intValue();
        int i = iIntValue2 - iIntValue;
        char[] cArr = this.tmpBuffer;
        if (cArr == null || cArr.length < i) {
            cArr = new char[i];
        }
        char[] cArr2 = cArr;
        TextUtils.getChars(this.layout.getText(), iIntValue, iIntValue2, cArr2, 0);
        if (Bidi.requiresBidi(cArr2, 0, i)) {
            bidi = new Bidi(cArr2, 0, null, 0, i, isRtlParagraph(paragraphIndex) ? 1 : 0);
            if (bidi.getRunCount() == 1) {
                bidi = null;
            }
        } else {
            bidi = null;
        }
        this.paragraphBidi.set(paragraphIndex, bidi);
        this.bidiProcessedParagraphs[paragraphIndex] = true;
        if (bidi != null) {
            char[] cArr3 = this.tmpBuffer;
            cArr2 = cArr2 == cArr3 ? null : cArr3;
        }
        this.tmpBuffer = cArr2;
        return bidi;
    }

    public final int getParagraphCount() {
        return this.paragraphCount;
    }

    public static int getParagraphForOffset$default(LayoutHelper layoutHelper, int i, boolean z, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            z = false;
        }
        return layoutHelper.getParagraphForOffset(i, z);
    }

    public final int getParagraphForOffset(int offset, boolean upstream) {
        int iBinarySearch$default = CollectionsKt.binarySearch$default(this.paragraphEnds, Integer.valueOf(offset), 0, 0, 6, (Object) null);
        int i = iBinarySearch$default < 0 ? -(iBinarySearch$default + 1) : iBinarySearch$default + 1;
        if (upstream && i > 0) {
            int i2 = i - 1;
            if (offset == this.paragraphEnds.get(i2).intValue()) {
                return i2;
            }
        }
        return i;
    }

    public final int getParagraphStart(int paragraphIndex) {
        if (paragraphIndex == 0) {
            return 0;
        }
        return this.paragraphEnds.get(paragraphIndex - 1).intValue();
    }

    public final int getParagraphEnd(int paragraphIndex) {
        return this.paragraphEnds.get(paragraphIndex).intValue();
    }

    public final boolean isRtlParagraph(int paragraphIndex) {
        return this.layout.getParagraphDirection(this.layout.getLineForOffset(getParagraphStart(paragraphIndex))) == -1;
    }

    public final float getHorizontalPosition(int offset, boolean usePrimaryDirection, boolean upstream) {
        int iLineEndToVisibleEnd = offset;
        if (!upstream) {
            return getDownstreamHorizontal(offset, usePrimaryDirection);
        }
        int lineForOffset = LayoutCompat_androidKt.getLineForOffset(this.layout, iLineEndToVisibleEnd, upstream);
        int lineStart = this.layout.getLineStart(lineForOffset);
        int lineEnd = this.layout.getLineEnd(lineForOffset);
        if (iLineEndToVisibleEnd != lineStart && iLineEndToVisibleEnd != lineEnd) {
            return getDownstreamHorizontal(offset, usePrimaryDirection);
        }
        if (iLineEndToVisibleEnd == 0 || iLineEndToVisibleEnd == this.layout.getText().length()) {
            return getDownstreamHorizontal(offset, usePrimaryDirection);
        }
        int paragraphForOffset = getParagraphForOffset(iLineEndToVisibleEnd, upstream);
        boolean zIsRtlParagraph = isRtlParagraph(paragraphForOffset);
        int iLineEndToVisibleEnd2 = lineEndToVisibleEnd(lineEnd, lineStart);
        int paragraphStart = getParagraphStart(paragraphForOffset);
        int i = lineStart - paragraphStart;
        int i2 = iLineEndToVisibleEnd2 - paragraphStart;
        Bidi bidiAnalyzeBidi = analyzeBidi(paragraphForOffset);
        Bidi bidiCreateLineBidi = bidiAnalyzeBidi != null ? bidiAnalyzeBidi.createLineBidi(i, i2) : null;
        boolean z = false;
        if (bidiCreateLineBidi == null || bidiCreateLineBidi.getRunCount() == 1) {
            boolean zIsRtlCharAt = this.layout.isRtlCharAt(lineStart);
            if (usePrimaryDirection || zIsRtlParagraph == zIsRtlCharAt) {
                zIsRtlParagraph = !zIsRtlParagraph;
            }
            if (iLineEndToVisibleEnd == lineStart) {
                z = zIsRtlParagraph;
            } else if (!zIsRtlParagraph) {
                z = true;
            }
            Layout layout = this.layout;
            return z ? layout.getLineLeft(lineForOffset) : layout.getLineRight(lineForOffset);
        }
        int runCount = bidiCreateLineBidi.getRunCount();
        BidiRun[] bidiRunArr = new BidiRun[runCount];
        for (int i3 = 0; i3 < runCount; i3++) {
            bidiRunArr[i3] = new BidiRun(bidiCreateLineBidi.getRunStart(i3) + lineStart, bidiCreateLineBidi.getRunLimit(i3) + lineStart, bidiCreateLineBidi.getRunLevel(i3) % 2 == 1);
        }
        int runCount2 = bidiCreateLineBidi.getRunCount();
        byte[] bArr = new byte[runCount2];
        for (int i4 = 0; i4 < runCount2; i4++) {
            bArr[i4] = (byte) bidiCreateLineBidi.getRunLevel(i4);
        }
        Bidi.reorderVisually(bArr, 0, bidiRunArr, 0, runCount);
        int i5 = -1;
        if (iLineEndToVisibleEnd == lineStart) {
            for (int i6 = 0; i6 < runCount; i6++) {
                if (bidiRunArr[i6].getStart() == iLineEndToVisibleEnd) {
                    i5 = i6;
                    break;
                }
            }
            BidiRun bidiRun = bidiRunArr[i5];
            if (usePrimaryDirection || zIsRtlParagraph == bidiRun.isRtl()) {
                zIsRtlParagraph = !zIsRtlParagraph;
            }
            if (i5 == 0 && zIsRtlParagraph) {
                return this.layout.getLineLeft(lineForOffset);
            }
            if (i5 == ArraysKt.getLastIndex(bidiRunArr) && !zIsRtlParagraph) {
                return this.layout.getLineRight(lineForOffset);
            }
            if (zIsRtlParagraph) {
                return this.layout.getPrimaryHorizontal(bidiRunArr[i5 - 1].getStart());
            }
            return this.layout.getPrimaryHorizontal(bidiRunArr[i5 + 1].getStart());
        }
        if (iLineEndToVisibleEnd > iLineEndToVisibleEnd2) {
            iLineEndToVisibleEnd = lineEndToVisibleEnd(iLineEndToVisibleEnd, lineStart);
        }
        for (int i7 = 0; i7 < runCount; i7++) {
            if (bidiRunArr[i7].getEnd() == iLineEndToVisibleEnd) {
                i5 = i7;
                break;
            }
        }
        BidiRun bidiRun2 = bidiRunArr[i5];
        if (!usePrimaryDirection && zIsRtlParagraph != bidiRun2.isRtl()) {
            zIsRtlParagraph = !zIsRtlParagraph;
        }
        if (i5 == 0 && zIsRtlParagraph) {
            return this.layout.getLineLeft(lineForOffset);
        }
        if (i5 == ArraysKt.getLastIndex(bidiRunArr) && !zIsRtlParagraph) {
            return this.layout.getLineRight(lineForOffset);
        }
        if (zIsRtlParagraph) {
            return this.layout.getPrimaryHorizontal(bidiRunArr[i5 - 1].getEnd());
        }
        return this.layout.getPrimaryHorizontal(bidiRunArr[i5 + 1].getEnd());
    }

    public final int getLineVisibleEnd(int lineIndex) {
        return lineEndToVisibleEnd(this.layout.getLineEnd(lineIndex), this.layout.getLineStart(lineIndex));
    }

    private final float getDownstreamHorizontal(int offset, boolean primary) {
        int iCoerceAtMost = RangesKt.coerceAtMost(offset, this.layout.getLineEnd(this.layout.getLineForOffset(offset)));
        if (primary) {
            return this.layout.getPrimaryHorizontal(iCoerceAtMost);
        }
        return this.layout.getSecondaryHorizontal(iCoerceAtMost);
    }

    @Metadata(d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\r\n\u0002\u0010\u000e\n\u0000\b\u0080\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000e\u001a\u00020\u0006HÆ\u0003J'\u0010\u000f\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00062\b\u0010\u0011\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\nR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\t¨\u0006\u0015"}, d2 = {"Landroidx/compose/ui/text/android/LayoutHelper$BidiRun;", "", "start", "", "end", "isRtl", "", "(IIZ)V", "getEnd", "()I", "()Z", "getStart", "component1", "component2", "component3", "copy", "equals", "other", "hashCode", "toString", "", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    public static final class BidiRun {
        public static final int $stable = 0;
        private final int end;
        private final boolean isRtl;
        private final int start;

        public static BidiRun copy$default(BidiRun bidiRun, int i, int i2, boolean z, int i3, Object obj) {
            if ((i3 & 1) != 0) {
                i = bidiRun.start;
            }
            if ((i3 & 2) != 0) {
                i2 = bidiRun.end;
            }
            if ((i3 & 4) != 0) {
                z = bidiRun.isRtl;
            }
            return bidiRun.copy(i, i2, z);
        }

        public final int getStart() {
            return this.start;
        }

        public final int getEnd() {
            return this.end;
        }

        public final boolean getIsRtl() {
            return this.isRtl;
        }

        public final BidiRun copy(int start, int end, boolean isRtl) {
            return new BidiRun(start, end, isRtl);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof BidiRun)) {
                return false;
            }
            BidiRun bidiRun = (BidiRun) other;
            return this.start == bidiRun.start && this.end == bidiRun.end && this.isRtl == bidiRun.isRtl;
        }

        public int hashCode() {
            return (((this.start * 31) + this.end) * 31) + UByte$.ExternalSyntheticBackport0.m(this.isRtl);
        }

        public String toString() {
            return "BidiRun(start=" + this.start + ", end=" + this.end + ", isRtl=" + this.isRtl + ')';
        }

        public BidiRun(int i, int i2, boolean z) {
            this.start = i;
            this.end = i2;
            this.isRtl = z;
        }

        public final int getEnd() {
            return this.end;
        }

        public final int getStart() {
            return this.start;
        }

        public final boolean isRtl() {
            return this.isRtl;
        }
    }

    private final int lineEndToVisibleEnd(int lineEnd, int lineStart) {
        while (lineEnd > lineStart && isLineEndSpace(this.layout.getText().charAt(lineEnd - 1))) {
            lineEnd--;
        }
        return lineEnd;
    }

    public final BidiRun[] getLineBidiRuns$ui_text_release(int lineIndex) {
        Bidi bidiCreateLineBidi;
        int lineStart = this.layout.getLineStart(lineIndex);
        int lineEnd = this.layout.getLineEnd(lineIndex);
        int paragraphForOffset$default = getParagraphForOffset$default(this, lineStart, false, 2, null);
        int paragraphStart = getParagraphStart(paragraphForOffset$default);
        int i = lineStart - paragraphStart;
        int i2 = lineEnd - paragraphStart;
        Bidi bidiAnalyzeBidi = analyzeBidi(paragraphForOffset$default);
        if (bidiAnalyzeBidi == null || (bidiCreateLineBidi = bidiAnalyzeBidi.createLineBidi(i, i2)) == null) {
            return new BidiRun[]{new BidiRun(lineStart, lineEnd, this.layout.isRtlCharAt(lineStart))};
        }
        int runCount = bidiCreateLineBidi.getRunCount();
        BidiRun[] bidiRunArr = new BidiRun[runCount];
        for (int i3 = 0; i3 < runCount; i3++) {
            bidiRunArr[i3] = new BidiRun(bidiCreateLineBidi.getRunStart(i3) + lineStart, bidiCreateLineBidi.getRunLimit(i3) + lineStart, bidiCreateLineBidi.getRunLevel(i3) % 2 == 1);
        }
        return bidiRunArr;
    }

    public final boolean isLineEndSpace(char c) {
        return c == ' ' || c == '\n' || c == 5760 || (Intrinsics.compare(c, 8192) >= 0 && Intrinsics.compare(c, 8202) <= 0 && c != 8199) || c == 8287 || c == 12288;
    }
}
