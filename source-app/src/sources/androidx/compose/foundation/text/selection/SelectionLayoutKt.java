package androidx.compose.foundation.text.selection;

import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.style.ResolvedTextDirection;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000<\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\u001aJ\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00012\u0006\u0010\u0007\u001a\u00020\u00012\u0006\u0010\b\u001a\u00020\u00012\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\fH\u0000ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000f\u001a\u0018\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u0011H\u0000\u001a\u0014\u0010\u0014\u001a\u00020\u0015*\u00020\u00052\u0006\u0010\u0016\u001a\u00020\u0001H\u0002\u001a\u0018\u0010\u0017\u001a\u00020\f*\u0004\u0018\u00010\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\u0003H\u0000\u001a\u0014\u0010\u001a\u001a\u00020\f*\u00020\u00052\u0006\u0010\u0016\u001a\u00020\u0001H\u0002\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001b"}, d2 = {"UNASSIGNED_SLOT", "", "getTextFieldSelectionLayout", "Landroidx/compose/foundation/text/selection/SelectionLayout;", "layoutResult", "Landroidx/compose/ui/text/TextLayoutResult;", "rawStartHandleOffset", "rawEndHandleOffset", "rawPreviousHandleOffset", "previousSelectionRange", "Landroidx/compose/ui/text/TextRange;", "isStartOfSelection", "", "isStartHandle", "getTextFieldSelectionLayout-RcvT-LA", "(Landroidx/compose/ui/text/TextLayoutResult;IIIJZZ)Landroidx/compose/foundation/text/selection/SelectionLayout;", "resolve2dDirection", "Landroidx/compose/foundation/text/selection/Direction;", "x", "y", "getTextDirectionForOffset", "Landroidx/compose/ui/text/style/ResolvedTextDirection;", "offset", "isCollapsed", "Landroidx/compose/foundation/text/selection/Selection;", "layout", "isOffsetAnEmptyLine", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SelectionLayoutKt {
    public static final int UNASSIGNED_SLOT = -1;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[Direction.values().length];
            try {
                iArr[Direction.BEFORE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[Direction.ON.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[Direction.AFTER.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final SelectionLayout m1878getTextFieldSelectionLayoutRcvTLA(TextLayoutResult textLayoutResult, int i, int i2, int i3, long j, boolean z, boolean z2) {
        return new SingleSelectionLayout(z2, 1, 1, z ? null : new Selection(new Selection.AnchorInfo(getTextDirectionForOffset(textLayoutResult, TextRange.getStart-impl(j)), TextRange.getStart-impl(j), 1L), new Selection.AnchorInfo(getTextDirectionForOffset(textLayoutResult, TextRange.getEnd-impl(j)), TextRange.getEnd-impl(j), 1L), TextRange.getReversed-impl(j)), new SelectableInfo(1L, 1, i, i2, i3, textLayoutResult));
    }

    public static final Direction resolve2dDirection(Direction direction, Direction direction2) throws NoWhenBranchMatchedException {
        int i = WhenMappings.$EnumSwitchMapping$0[direction2.ordinal()];
        if (i == 1) {
            return Direction.BEFORE;
        }
        if (i != 2) {
            if (i == 3) {
                return Direction.AFTER;
            }
            throw new NoWhenBranchMatchedException();
        }
        int i2 = WhenMappings.$EnumSwitchMapping$0[direction.ordinal()];
        if (i2 == 1) {
            return Direction.BEFORE;
        }
        if (i2 == 2) {
            return Direction.ON;
        }
        if (i2 == 3) {
            return Direction.AFTER;
        }
        throw new NoWhenBranchMatchedException();
    }

    public static final ResolvedTextDirection getTextDirectionForOffset(TextLayoutResult textLayoutResult, int i) {
        return isOffsetAnEmptyLine(textLayoutResult, i) ? textLayoutResult.getParagraphDirection(i) : textLayoutResult.getBidiRunDirection(i);
    }

    private static final boolean isOffsetAnEmptyLine(TextLayoutResult textLayoutResult, int i) {
        if (textLayoutResult.getLayoutInput().getText().length() == 0) {
            return true;
        }
        int lineForOffset = textLayoutResult.getLineForOffset(i);
        return (i == 0 || lineForOffset != textLayoutResult.getLineForOffset(i + (-1))) && (i == textLayoutResult.getLayoutInput().getText().length() || lineForOffset != textLayoutResult.getLineForOffset(i + 1));
    }

    public static final boolean isCollapsed(Selection selection, SelectionLayout selectionLayout) {
        if (selection == null || selectionLayout == null) {
            return true;
        }
        if (selection.getStart().getSelectableId() == selection.getEnd().getSelectableId()) {
            return selection.getStart().getOffset() == selection.getEnd().getOffset();
        }
        if ((selection.getHandlesCrossed() ? selection.getStart() : selection.getEnd()).getOffset() != 0) {
            return false;
        }
        if (selectionLayout.getFirstInfo().getTextLength() != (selection.getHandlesCrossed() ? selection.getEnd() : selection.getStart()).getOffset()) {
            return false;
        }
        final Ref.BooleanRef booleanRef = new Ref.BooleanRef();
        booleanRef.element = true;
        selectionLayout.forEachMiddleInfo(new Function1<SelectableInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((SelectableInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(SelectableInfo selectableInfo) {
                if (selectableInfo.getInputText().length() > 0) {
                    booleanRef.element = false;
                }
            }
        });
        return booleanRef.element;
    }
}
