package androidx.compose.foundation.text.input.internal;

import androidx.compose.foundation.text.input.TextHighlightType;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import java.util.List;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0010\f\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\r\n\u0002\b\t\b\u0000\u0018\u0000 D2\u00020\u0001:\u0001DB\u0017\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0007\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\bJ\u0018\u0010/\u001a\u0002002\u0006\u00101\u001a\u00020\u00112\u0006\u00102\u001a\u00020\u0011H\u0002J\u0006\u00103\u001a\u000200J\u0006\u00104\u001a\u000200J\u0016\u00105\u001a\u0002002\u0006\u00101\u001a\u00020\u00112\u0006\u00102\u001a\u00020\u0011J\u0011\u00106\u001a\u0002072\u0006\u00108\u001a\u00020\u0011H\u0086\u0002J\u0006\u00109\u001a\u00020:J\u001e\u0010;\u001a\u0002002\u0006\u00101\u001a\u00020\u00112\u0006\u00102\u001a\u00020\u00112\u0006\u0010\u0002\u001a\u00020<J\u0016\u0010=\u001a\u0002002\u0006\u00101\u001a\u00020\u00112\u0006\u00102\u001a\u00020\u0011J(\u0010\"\u001a\u0002002\u0006\u0010>\u001a\u00020\u001f2\u0006\u00101\u001a\u00020\u00112\u0006\u00102\u001a\u00020\u0011ø\u0001\u0000¢\u0006\u0004\b?\u0010@J\u0016\u0010A\u001a\u0002002\u0006\u00101\u001a\u00020\u00112\u0006\u00102\u001a\u00020\u0011J\u0006\u0010B\u001a\u00020\u0007J\b\u0010C\u001a\u00020\u0003H\u0016R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0019\u0010\r\u001a\u0004\u0018\u00010\u00058Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000fR\u001e\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0010\u001a\u00020\u0011@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u001e\u0010\u0015\u001a\u00020\u00112\u0006\u0010\u0010\u001a\u00020\u0011@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0014R$\u0010\u0017\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u00118F@FX\u0086\u000e¢\u0006\f\u001a\u0004\b\u0018\u0010\u0014\"\u0004\b\u0019\u0010\u001aR\u000e\u0010\u001b\u001a\u00020\u001cX\u0082\u0004¢\u0006\u0002\n\u0000R(\u0010\u001d\u001a\u0010\u0012\u0004\u0012\u00020\u001f\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u001eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R\u0011\u0010$\u001a\u00020\u00118F¢\u0006\u0006\u001a\u0004\b%\u0010\u0014R\u0017\u0010\u0004\u001a\u00020\u00058Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b&\u0010'R$\u0010)\u001a\u00020\u00112\u0006\u0010(\u001a\u00020\u0011@BX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b*\u0010\u0014\"\u0004\b+\u0010\u001aR$\u0010,\u001a\u00020\u00112\u0006\u0010(\u001a\u00020\u0011@BX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b-\u0010\u0014\"\u0004\b.\u0010\u001a\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006E"}, d2 = {"Landroidx/compose/foundation/text/input/internal/EditingBuffer;", "", "text", "", "selection", "Landroidx/compose/ui/text/TextRange;", "(Ljava/lang/String;JLkotlin/jvm/internal/DefaultConstructorMarker;)V", "Landroidx/compose/ui/text/AnnotatedString;", "(Landroidx/compose/ui/text/AnnotatedString;JLkotlin/jvm/internal/DefaultConstructorMarker;)V", "changeTracker", "Landroidx/compose/foundation/text/input/internal/ChangeTracker;", "getChangeTracker", "()Landroidx/compose/foundation/text/input/internal/ChangeTracker;", "composition", "getComposition-MzsxiRA", "()Landroidx/compose/ui/text/TextRange;", "<set-?>", "", "compositionEnd", "getCompositionEnd", "()I", "compositionStart", "getCompositionStart", "cursor", "getCursor", "setCursor", "(I)V", "gapBuffer", "Landroidx/compose/foundation/text/input/internal/PartialGapBuffer;", "highlight", "Lkotlin/Pair;", "Landroidx/compose/foundation/text/input/TextHighlightType;", "getHighlight", "()Lkotlin/Pair;", "setHighlight", "(Lkotlin/Pair;)V", "length", "getLength", "getSelection-d9O1mEE", "()J", "value", "selectionEnd", "getSelectionEnd", "setSelectionEnd", "selectionStart", "getSelectionStart", "setSelectionStart", "checkRange", "", "start", "end", "clearHighlight", "commitComposition", "delete", "get", "", "index", "hasComposition", "", "replace", "", "setComposition", "type", "setHighlight-K7f2yys", "(III)V", "setSelection", "toAnnotatedString", "toString", "Companion", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class EditingBuffer {
    public static final int NOWHERE = -1;
    private final ChangeTracker changeTracker;
    private int compositionEnd;
    private int compositionStart;
    private final PartialGapBuffer gapBuffer;
    private Pair<TextHighlightType, TextRange> highlight;
    private int selectionEnd;
    private int selectionStart;
    public static final int $stable = 8;

    public EditingBuffer(AnnotatedString annotatedString, long j, DefaultConstructorMarker defaultConstructorMarker) {
        this(annotatedString, j);
    }

    public EditingBuffer(String str, long j, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, j);
    }

    private EditingBuffer(AnnotatedString annotatedString, long j) {
        this.gapBuffer = new PartialGapBuffer(annotatedString.getText());
        this.changeTracker = new ChangeTracker(null, 1, null);
        this.selectionStart = TextRange.getStart-impl(j);
        this.selectionEnd = TextRange.getEnd-impl(j);
        this.compositionStart = -1;
        this.compositionEnd = -1;
        checkRange(TextRange.getStart-impl(j), TextRange.getEnd-impl(j));
    }

    public final ChangeTracker getChangeTracker() {
        return this.changeTracker;
    }

    public final int getSelectionStart() {
        return this.selectionStart;
    }

    private final void setSelectionStart(int i) {
        if (i < 0) {
            throw new IllegalArgumentException(("Cannot set selectionStart to a negative value: " + i).toString());
        }
        this.selectionStart = i;
        this.highlight = null;
    }

    public final int getSelectionEnd() {
        return this.selectionEnd;
    }

    private final void setSelectionEnd(int i) {
        if (i < 0) {
            throw new IllegalArgumentException(("Cannot set selectionEnd to a negative value: " + i).toString());
        }
        this.selectionEnd = i;
        this.highlight = null;
    }

    public final Pair<TextHighlightType, TextRange> getHighlight() {
        return this.highlight;
    }

    public final void setHighlight(Pair<TextHighlightType, TextRange> pair) {
        this.highlight = pair;
    }

    public final int getCompositionStart() {
        return this.compositionStart;
    }

    public final int getCompositionEnd() {
        return this.compositionEnd;
    }

    public final boolean hasComposition() {
        return this.compositionStart != -1;
    }

    public final TextRange m1616getCompositionMzsxiRA() {
        if (hasComposition()) {
            return TextRange.box-impl(TextRangeKt.TextRange(this.compositionStart, this.compositionEnd));
        }
        return null;
    }

    public final long m1617getSelectiond9O1mEE() {
        return TextRangeKt.TextRange(this.selectionStart, this.selectionEnd);
    }

    public final int getCursor() {
        int i = this.selectionStart;
        int i2 = this.selectionEnd;
        if (i == i2) {
            return i2;
        }
        return -1;
    }

    public final void setCursor(int i) {
        setSelection(i, i);
    }

    public final char get(int index) {
        return this.gapBuffer.charAt(index);
    }

    public final int getLength() {
        return this.gapBuffer.length();
    }

    private EditingBuffer(String str, long j) {
        this(new AnnotatedString(str, (List) null, (List) null, 6, (DefaultConstructorMarker) null), j, (DefaultConstructorMarker) null);
    }

    public final void replace(int start, int end, CharSequence text) {
        checkRange(start, end);
        int iMin = Math.min(start, end);
        int iMax = Math.max(start, end);
        int i = 0;
        int i2 = iMin;
        while (i2 < iMax && i < text.length() && text.charAt(i) == this.gapBuffer.charAt(i2)) {
            i++;
            i2++;
        }
        int length = text.length();
        int i3 = iMax;
        while (i3 > iMin && length > i && text.charAt(length - 1) == this.gapBuffer.charAt(i3 - 1)) {
            length--;
            i3--;
        }
        this.changeTracker.trackChange(i2, i3, length - i);
        PartialGapBuffer.replace$default(this.gapBuffer, iMin, iMax, text, 0, 0, 24, null);
        setSelectionStart(text.length() + iMin);
        setSelectionEnd(iMin + text.length());
        this.compositionStart = -1;
        this.compositionEnd = -1;
        this.highlight = null;
    }

    public final void delete(int start, int end) {
        checkRange(start, end);
        long jTextRange = TextRangeKt.TextRange(start, end);
        this.changeTracker.trackChange(start, end, 0);
        PartialGapBuffer.replace$default(this.gapBuffer, TextRange.getMin-impl(jTextRange), TextRange.getMax-impl(jTextRange), "", 0, 0, 24, null);
        long jM1619updateRangeAfterDeletepWDy79M = EditingBufferKt.m1619updateRangeAfterDeletepWDy79M(TextRangeKt.TextRange(this.selectionStart, this.selectionEnd), jTextRange);
        setSelectionStart(TextRange.getStart-impl(jM1619updateRangeAfterDeletepWDy79M));
        setSelectionEnd(TextRange.getEnd-impl(jM1619updateRangeAfterDeletepWDy79M));
        if (hasComposition()) {
            long jM1619updateRangeAfterDeletepWDy79M2 = EditingBufferKt.m1619updateRangeAfterDeletepWDy79M(TextRangeKt.TextRange(this.compositionStart, this.compositionEnd), jTextRange);
            if (TextRange.getCollapsed-impl(jM1619updateRangeAfterDeletepWDy79M2)) {
                commitComposition();
            } else {
                this.compositionStart = TextRange.getMin-impl(jM1619updateRangeAfterDeletepWDy79M2);
                this.compositionEnd = TextRange.getMax-impl(jM1619updateRangeAfterDeletepWDy79M2);
            }
        }
        this.highlight = null;
    }

    public final void setSelection(int start, int end) {
        int iCoerceIn = RangesKt.coerceIn(start, 0, getLength());
        int iCoerceIn2 = RangesKt.coerceIn(end, 0, getLength());
        setSelectionStart(iCoerceIn);
        setSelectionEnd(iCoerceIn2);
    }

    public final void m1618setHighlightK7f2yys(int type, int start, int end) {
        if (start >= end) {
            throw new IllegalArgumentException("Do not set reversed or empty range: " + start + " > " + end);
        }
        this.highlight = new Pair<>(TextHighlightType.m1586boximpl(type), TextRange.box-impl(TextRangeKt.TextRange(RangesKt.coerceIn(start, 0, getLength()), RangesKt.coerceIn(end, 0, getLength()))));
    }

    public final void clearHighlight() {
        this.highlight = null;
    }

    public final void setComposition(int start, int end) {
        if (start < 0 || start > this.gapBuffer.length()) {
            throw new IndexOutOfBoundsException("start (" + start + ") offset is outside of text region " + this.gapBuffer.length());
        }
        if (end < 0 || end > this.gapBuffer.length()) {
            throw new IndexOutOfBoundsException("end (" + end + ") offset is outside of text region " + this.gapBuffer.length());
        }
        if (start >= end) {
            throw new IllegalArgumentException("Do not set reversed or empty range: " + start + " > " + end);
        }
        this.compositionStart = start;
        this.compositionEnd = end;
    }

    public final void commitComposition() {
        this.compositionStart = -1;
        this.compositionEnd = -1;
    }

    public String toString() {
        return this.gapBuffer.toString();
    }

    public final AnnotatedString toAnnotatedString() {
        return new AnnotatedString(toString(), (List) null, (List) null, 6, (DefaultConstructorMarker) null);
    }

    private final void checkRange(int start, int end) {
        if (start < 0 || start > this.gapBuffer.length()) {
            throw new IndexOutOfBoundsException("start (" + start + ") offset is outside of text region " + this.gapBuffer.length());
        }
        if (end < 0 || end > this.gapBuffer.length()) {
            throw new IndexOutOfBoundsException("end (" + end + ") offset is outside of text region " + this.gapBuffer.length());
        }
    }
}
