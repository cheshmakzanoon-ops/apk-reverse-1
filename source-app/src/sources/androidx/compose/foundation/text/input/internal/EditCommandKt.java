package androidx.compose.foundation.text.input.internal;

import androidx.compose.foundation.text.StringHelpers_androidKt;
import kotlin.Metadata;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000*\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\f\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\r\u001a\u0018\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0002\u001a\f\u0010\u0005\u001a\u00020\u0006*\u00020\u0007H\u0000\u001a\u001c\u0010\b\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0000\u001a\f\u0010\r\u001a\u00020\u0006*\u00020\u0007H\u0000\u001a\u001c\u0010\u000e\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\u000f\u001a\u00020\f2\u0006\u0010\u0010\u001a\u00020\fH\u0000\u001a\u001c\u0010\u0011\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\u000f\u001a\u00020\f2\u0006\u0010\u0010\u001a\u00020\fH\u0000\u001a\f\u0010\u0012\u001a\u00020\u0006*\u00020\u0007H\u0000\u001a\u0014\u0010\u0013\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\u0014\u001a\u00020\fH\u0000\u001a\u001c\u0010\u0015\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\u0016\u001a\u00020\f2\u0006\u0010\u0017\u001a\u00020\fH\u0000\u001a\u001c\u0010\u0018\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0000¨\u0006\u0019"}, d2 = {"isSurrogatePair", "", "high", "", "low", "backspace", "", "Landroidx/compose/foundation/text/input/internal/EditingBuffer;", "commitText", "text", "", "newCursorPosition", "", "deleteAll", "deleteSurroundingText", "lengthBeforeCursor", "lengthAfterCursor", "deleteSurroundingTextInCodePoints", "finishComposingText", "moveCursor", "amount", "setComposingRegion", "start", "end", "setComposingText", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class EditCommandKt {
    public static final void commitText(EditingBuffer editingBuffer, String str, int i) {
        if (editingBuffer.hasComposition()) {
            editingBuffer.replace(editingBuffer.getCompositionStart(), editingBuffer.getCompositionEnd(), str);
        } else {
            editingBuffer.replace(editingBuffer.getSelectionStart(), editingBuffer.getSelectionEnd(), str);
        }
        int cursor = editingBuffer.getCursor();
        editingBuffer.setCursor(RangesKt.coerceIn(i > 0 ? (cursor + i) - 1 : (cursor + i) - str.length(), 0, editingBuffer.getLength()));
    }

    public static final void setComposingRegion(EditingBuffer editingBuffer, int i, int i2) {
        if (editingBuffer.hasComposition()) {
            editingBuffer.commitComposition();
        }
        int iCoerceIn = RangesKt.coerceIn(i, 0, editingBuffer.getLength());
        int iCoerceIn2 = RangesKt.coerceIn(i2, 0, editingBuffer.getLength());
        if (iCoerceIn != iCoerceIn2) {
            if (iCoerceIn < iCoerceIn2) {
                editingBuffer.setComposition(iCoerceIn, iCoerceIn2);
            } else {
                editingBuffer.setComposition(iCoerceIn2, iCoerceIn);
            }
        }
    }

    public static final void setComposingText(EditingBuffer editingBuffer, String str, int i) {
        if (editingBuffer.hasComposition()) {
            int compositionStart = editingBuffer.getCompositionStart();
            String str2 = str;
            editingBuffer.replace(compositionStart, editingBuffer.getCompositionEnd(), str2);
            if (str2.length() > 0) {
                editingBuffer.setComposition(compositionStart, str.length() + compositionStart);
            }
        } else {
            int selectionStart = editingBuffer.getSelectionStart();
            String str3 = str;
            editingBuffer.replace(selectionStart, editingBuffer.getSelectionEnd(), str3);
            if (str3.length() > 0) {
                editingBuffer.setComposition(selectionStart, str.length() + selectionStart);
            }
        }
        int cursor = editingBuffer.getCursor();
        editingBuffer.setCursor(RangesKt.coerceIn(i > 0 ? (cursor + i) - 1 : (cursor + i) - str.length(), 0, editingBuffer.getLength()));
    }

    public static final void deleteSurroundingText(EditingBuffer editingBuffer, int i, int i2) {
        if (i < 0 || i2 < 0) {
            throw new IllegalArgumentException(("Expected lengthBeforeCursor and lengthAfterCursor to be non-negative, were " + i + " and " + i2 + " respectively.").toString());
        }
        int selectionEnd = editingBuffer.getSelectionEnd();
        int length = selectionEnd + i2;
        if (((i2 ^ length) & (selectionEnd ^ length)) < 0) {
            length = editingBuffer.getLength();
        }
        editingBuffer.delete(editingBuffer.getSelectionEnd(), Math.min(length, editingBuffer.getLength()));
        int selectionStart = editingBuffer.getSelectionStart();
        int i3 = selectionStart - i;
        if (((i ^ selectionStart) & (selectionStart ^ i3)) < 0) {
            i3 = 0;
        }
        editingBuffer.delete(Math.max(0, i3), editingBuffer.getSelectionStart());
    }

    public static final void deleteSurroundingTextInCodePoints(EditingBuffer editingBuffer, int i, int i2) {
        if (i < 0 || i2 < 0) {
            throw new IllegalArgumentException(("Expected lengthBeforeCursor and lengthAfterCursor to be non-negative, were " + i + " and " + i2 + " respectively.").toString());
        }
        int selectionStart = 0;
        for (int i3 = 0; i3 < i; i3++) {
            int i4 = selectionStart + 1;
            if (editingBuffer.getSelectionStart() > i4) {
                selectionStart = isSurrogatePair(editingBuffer.get((editingBuffer.getSelectionStart() - i4) + (-1)), editingBuffer.get(editingBuffer.getSelectionStart() - i4)) ? selectionStart + 2 : i4;
            } else {
                selectionStart = editingBuffer.getSelectionStart();
                break;
            }
        }
        int length = 0;
        for (int i5 = 0; i5 < i2; i5++) {
            int i6 = length + 1;
            if (editingBuffer.getSelectionEnd() + i6 < editingBuffer.getLength()) {
                length = isSurrogatePair(editingBuffer.get((editingBuffer.getSelectionEnd() + i6) + (-1)), editingBuffer.get(editingBuffer.getSelectionEnd() + i6)) ? length + 2 : i6;
            } else {
                length = editingBuffer.getLength() - editingBuffer.getSelectionEnd();
                break;
            }
        }
        editingBuffer.delete(editingBuffer.getSelectionEnd(), editingBuffer.getSelectionEnd() + length);
        editingBuffer.delete(editingBuffer.getSelectionStart() - selectionStart, editingBuffer.getSelectionStart());
    }

    public static final void finishComposingText(EditingBuffer editingBuffer) {
        editingBuffer.commitComposition();
    }

    public static final void backspace(EditingBuffer editingBuffer) {
        if (editingBuffer.hasComposition()) {
            editingBuffer.delete(editingBuffer.getCompositionStart(), editingBuffer.getCompositionEnd());
            return;
        }
        if (editingBuffer.getCursor() == -1) {
            int selectionStart = editingBuffer.getSelectionStart();
            int selectionEnd = editingBuffer.getSelectionEnd();
            editingBuffer.setCursor(editingBuffer.getSelectionStart());
            editingBuffer.delete(selectionStart, selectionEnd);
            return;
        }
        if (editingBuffer.getCursor() != 0) {
            editingBuffer.delete(StringHelpers_androidKt.findPrecedingBreak(editingBuffer.toString(), editingBuffer.getCursor()), editingBuffer.getCursor());
        }
    }

    public static final void moveCursor(EditingBuffer editingBuffer, int i) {
        if (editingBuffer.getCursor() == -1) {
            editingBuffer.setCursor(editingBuffer.getSelectionStart());
        }
        int selectionStart = editingBuffer.getSelectionStart();
        String string = editingBuffer.toString();
        int i2 = 0;
        if (i <= 0) {
            int i3 = -i;
            while (i2 < i3) {
                int iFindPrecedingBreak = StringHelpers_androidKt.findPrecedingBreak(string, selectionStart);
                if (iFindPrecedingBreak == -1) {
                    break;
                }
                i2++;
                selectionStart = iFindPrecedingBreak;
            }
        } else {
            while (i2 < i) {
                int iFindFollowingBreak = StringHelpers_androidKt.findFollowingBreak(string, selectionStart);
                if (iFindFollowingBreak == -1) {
                    break;
                }
                i2++;
                selectionStart = iFindFollowingBreak;
            }
        }
        editingBuffer.setCursor(selectionStart);
    }

    public static final void deleteAll(EditingBuffer editingBuffer) {
        editingBuffer.replace(0, editingBuffer.getLength(), "");
    }

    private static final boolean isSurrogatePair(char c, char c2) {
        return Character.isHighSurrogate(c) && Character.isLowSurrogate(c2);
    }
}
