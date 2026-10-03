package androidx.compose.foundation.text.input.internal;

import android.view.KeyEvent;
import androidx.compose.foundation.text.DeadKeyCombiner;
import androidx.compose.foundation.text.KeyCommand;
import androidx.compose.foundation.text.KeyEventHelpers_androidKt;
import androidx.compose.foundation.text.KeyMapping;
import androidx.compose.foundation.text.KeyMapping_androidKt;
import androidx.compose.foundation.text.StringHelpers_jvmKt;
import androidx.compose.foundation.text.TextFieldKeyInput_androidKt;
import androidx.compose.foundation.text.input.InputTransformation;
import androidx.compose.foundation.text.input.TextFieldState;
import androidx.compose.foundation.text.input.internal.selection.TextFieldPreparedSelection;
import androidx.compose.foundation.text.input.internal.selection.TextFieldPreparedSelectionState;
import androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState;
import androidx.compose.foundation.text.input.internal.undo.TextFieldEditUndoBehavior;
import androidx.compose.p002ui.focus.FocusManager;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.Matrix;
import androidx.compose.p002ui.input.key.KeyEventType;
import androidx.compose.p002ui.input.key.KeyEvent_androidKt;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.platform.SoftwareKeyboardController;
import androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableList.UtilsKt;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000l\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\b \u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002JP\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\n2\u0006\u0010\u0014\u001a\u00020\n2\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00170\u0016H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019J:\u0010\u001a\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001eH\u0016ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 J:\u0010!\u001a\u00020\u00172\u0006\u0010\"\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010#\u001a\u00020\n2\u0017\u0010$\u001a\u0013\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020\u00170%¢\u0006\u0002\b'H\u0082\bJ\f\u0010(\u001a\u00020)*\u00020\u0010H\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006*"}, d2 = {"Landroidx/compose/foundation/text/input/internal/TextFieldKeyEventHandler;", "", "()V", "deadKeyCombiner", "Landroidx/compose/foundation/text/DeadKeyCombiner;", "keyMapping", "Landroidx/compose/foundation/text/KeyMapping;", "preparedSelectionState", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldPreparedSelectionState;", "onKeyEvent", "", "event", "Landroidx/compose/ui/input/key/KeyEvent;", "textFieldState", "Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "textLayoutState", "Landroidx/compose/foundation/text/input/internal/TextLayoutState;", "textFieldSelectionState", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;", "editable", "singleLine", "onSubmit", "Lkotlin/Function0;", "", "onKeyEvent-6ptp14s", "(Landroid/view/KeyEvent;Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;Landroidx/compose/foundation/text/input/internal/TextLayoutState;Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;ZZLkotlin/jvm/functions/Function0;)Z", "onPreKeyEvent", "focusManager", "Landroidx/compose/ui/focus/FocusManager;", "keyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "onPreKeyEvent-MyFupTE", "(Landroid/view/KeyEvent;Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;Landroidx/compose/ui/focus/FocusManager;Landroidx/compose/ui/platform/SoftwareKeyboardController;)Z", "preparedSelectionContext", "state", "isFromSoftKeyboard", "block", "Lkotlin/Function1;", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldPreparedSelection;", "Lkotlin/ExtensionFunctionType;", "getVisibleTextLayoutHeight", "", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class TextFieldKeyEventHandler {
    public static final int $stable = 8;
    private final TextFieldPreparedSelectionState preparedSelectionState = new TextFieldPreparedSelectionState();
    private final DeadKeyCombiner deadKeyCombiner = new DeadKeyCombiner();
    private final KeyMapping keyMapping = KeyMapping_androidKt.getPlatformDefaultKeyMapping();

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[KeyCommand.values().length];
            try {
                iArr[KeyCommand.COPY.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[KeyCommand.PASTE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[KeyCommand.CUT.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[KeyCommand.LEFT_CHAR.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[KeyCommand.RIGHT_CHAR.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[KeyCommand.LEFT_WORD.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[KeyCommand.RIGHT_WORD.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                iArr[KeyCommand.PREV_PARAGRAPH.ordinal()] = 8;
            } catch (NoSuchFieldError unused8) {
            }
            try {
                iArr[KeyCommand.NEXT_PARAGRAPH.ordinal()] = 9;
            } catch (NoSuchFieldError unused9) {
            }
            try {
                iArr[KeyCommand.UP.ordinal()] = 10;
            } catch (NoSuchFieldError unused10) {
            }
            try {
                iArr[KeyCommand.DOWN.ordinal()] = 11;
            } catch (NoSuchFieldError unused11) {
            }
            try {
                iArr[KeyCommand.PAGE_UP.ordinal()] = 12;
            } catch (NoSuchFieldError unused12) {
            }
            try {
                iArr[KeyCommand.PAGE_DOWN.ordinal()] = 13;
            } catch (NoSuchFieldError unused13) {
            }
            try {
                iArr[KeyCommand.LINE_START.ordinal()] = 14;
            } catch (NoSuchFieldError unused14) {
            }
            try {
                iArr[KeyCommand.LINE_END.ordinal()] = 15;
            } catch (NoSuchFieldError unused15) {
            }
            try {
                iArr[KeyCommand.LINE_LEFT.ordinal()] = 16;
            } catch (NoSuchFieldError unused16) {
            }
            try {
                iArr[KeyCommand.LINE_RIGHT.ordinal()] = 17;
            } catch (NoSuchFieldError unused17) {
            }
            try {
                iArr[KeyCommand.HOME.ordinal()] = 18;
            } catch (NoSuchFieldError unused18) {
            }
            try {
                iArr[KeyCommand.END.ordinal()] = 19;
            } catch (NoSuchFieldError unused19) {
            }
            try {
                iArr[KeyCommand.DELETE_PREV_CHAR.ordinal()] = 20;
            } catch (NoSuchFieldError unused20) {
            }
            try {
                iArr[KeyCommand.DELETE_NEXT_CHAR.ordinal()] = 21;
            } catch (NoSuchFieldError unused21) {
            }
            try {
                iArr[KeyCommand.DELETE_PREV_WORD.ordinal()] = 22;
            } catch (NoSuchFieldError unused22) {
            }
            try {
                iArr[KeyCommand.DELETE_NEXT_WORD.ordinal()] = 23;
            } catch (NoSuchFieldError unused23) {
            }
            try {
                iArr[KeyCommand.DELETE_FROM_LINE_START.ordinal()] = 24;
            } catch (NoSuchFieldError unused24) {
            }
            try {
                iArr[KeyCommand.DELETE_TO_LINE_END.ordinal()] = 25;
            } catch (NoSuchFieldError unused25) {
            }
            try {
                iArr[KeyCommand.NEW_LINE.ordinal()] = 26;
            } catch (NoSuchFieldError unused26) {
            }
            try {
                iArr[KeyCommand.TAB.ordinal()] = 27;
            } catch (NoSuchFieldError unused27) {
            }
            try {
                iArr[KeyCommand.SELECT_ALL.ordinal()] = 28;
            } catch (NoSuchFieldError unused28) {
            }
            try {
                iArr[KeyCommand.SELECT_LEFT_CHAR.ordinal()] = 29;
            } catch (NoSuchFieldError unused29) {
            }
            try {
                iArr[KeyCommand.SELECT_RIGHT_CHAR.ordinal()] = 30;
            } catch (NoSuchFieldError unused30) {
            }
            try {
                iArr[KeyCommand.SELECT_LEFT_WORD.ordinal()] = 31;
            } catch (NoSuchFieldError unused31) {
            }
            try {
                iArr[KeyCommand.SELECT_RIGHT_WORD.ordinal()] = 32;
            } catch (NoSuchFieldError unused32) {
            }
            try {
                iArr[KeyCommand.SELECT_PREV_PARAGRAPH.ordinal()] = 33;
            } catch (NoSuchFieldError unused33) {
            }
            try {
                iArr[KeyCommand.SELECT_NEXT_PARAGRAPH.ordinal()] = 34;
            } catch (NoSuchFieldError unused34) {
            }
            try {
                iArr[KeyCommand.SELECT_LINE_START.ordinal()] = 35;
            } catch (NoSuchFieldError unused35) {
            }
            try {
                iArr[KeyCommand.SELECT_LINE_END.ordinal()] = 36;
            } catch (NoSuchFieldError unused36) {
            }
            try {
                iArr[KeyCommand.SELECT_LINE_LEFT.ordinal()] = 37;
            } catch (NoSuchFieldError unused37) {
            }
            try {
                iArr[KeyCommand.SELECT_LINE_RIGHT.ordinal()] = 38;
            } catch (NoSuchFieldError unused38) {
            }
            try {
                iArr[KeyCommand.SELECT_UP.ordinal()] = 39;
            } catch (NoSuchFieldError unused39) {
            }
            try {
                iArr[KeyCommand.SELECT_DOWN.ordinal()] = 40;
            } catch (NoSuchFieldError unused40) {
            }
            try {
                iArr[KeyCommand.SELECT_PAGE_UP.ordinal()] = 41;
            } catch (NoSuchFieldError unused41) {
            }
            try {
                iArr[KeyCommand.SELECT_PAGE_DOWN.ordinal()] = 42;
            } catch (NoSuchFieldError unused42) {
            }
            try {
                iArr[KeyCommand.SELECT_HOME.ordinal()] = 43;
            } catch (NoSuchFieldError unused43) {
            }
            try {
                iArr[KeyCommand.SELECT_END.ordinal()] = 44;
            } catch (NoSuchFieldError unused44) {
            }
            try {
                iArr[KeyCommand.DESELECT.ordinal()] = 45;
            } catch (NoSuchFieldError unused45) {
            }
            try {
                iArr[KeyCommand.UNDO.ordinal()] = 46;
            } catch (NoSuchFieldError unused46) {
            }
            try {
                iArr[KeyCommand.REDO.ordinal()] = 47;
            } catch (NoSuchFieldError unused47) {
            }
            try {
                iArr[KeyCommand.CHARACTER_PALETTE.ordinal()] = 48;
            } catch (NoSuchFieldError unused48) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public boolean mo1607onPreKeyEventMyFupTE(KeyEvent event, TransformedTextFieldState textFieldState, TextFieldSelectionState textFieldSelectionState, FocusManager focusManager, SoftwareKeyboardController keyboardController) {
        if (TextRange.getCollapsed-impl(textFieldState.getVisualText().getSelection()) || !KeyEventHelpers_androidKt.m1456cancelsTextSelectionZmokQxo(event)) {
            return false;
        }
        textFieldSelectionState.deselect();
        return true;
    }

    public boolean mo1606onKeyEvent6ptp14s(KeyEvent event, TransformedTextFieldState textFieldState, TextLayoutState textLayoutState, TextFieldSelectionState textFieldSelectionState, boolean editable, boolean singleLine, Function0<Unit> onSubmit) {
        TextRange textRange;
        Integer numM1455consumeZmokQxo;
        boolean z = false;
        if (!KeyEventType.m5690equalsimpl0(KeyEvent_androidKt.m5698getTypeZmokQxo(event), KeyEventType.INSTANCE.m5694getKeyDownCS__XNY())) {
            return false;
        }
        if (TextFieldKeyInput_androidKt.m1544isTypedEventZmokQxo(event) && (numM1455consumeZmokQxo = this.deadKeyCombiner.m1455consumeZmokQxo(event)) != null) {
            String string = StringHelpers_jvmKt.appendCodePointX(new StringBuilder(2), numM1455consumeZmokQxo.intValue()).toString();
            if (!editable) {
                return false;
            }
            boolean z2 = !TextFieldKeyEventHandler_androidKt.m1697isFromSoftKeyboardZmokQxo(event);
            TextFieldState textFieldState2 = textFieldState.textFieldState;
            InputTransformation inputTransformation = textFieldState.inputTransformation;
            TextFieldEditUndoBehavior textFieldEditUndoBehavior = TextFieldEditUndoBehavior.MergeIfPossible;
            textFieldState2.getMainBuffer().getChangeTracker().clearChanges();
            EditingBuffer mainBuffer = textFieldState2.getMainBuffer();
            mainBuffer.commitComposition();
            EditCommandKt.commitText(mainBuffer, string, 1);
            textFieldState2.commitEditAsUser(inputTransformation, z2, textFieldEditUndoBehavior);
            this.preparedSelectionState.resetCachedX();
            return true;
        }
        KeyCommand keyCommandMo1457mapZmokQxo = this.keyMapping.mo1457mapZmokQxo(event);
        if (keyCommandMo1457mapZmokQxo != null && (!keyCommandMo1457mapZmokQxo.getEditsText() || editable)) {
            TextFieldPreparedSelection textFieldPreparedSelection = new TextFieldPreparedSelection(textFieldState, textLayoutState.getLayoutResult(), TextFieldKeyEventHandler_androidKt.m1697isFromSoftKeyboardZmokQxo(event), getVisibleTextLayoutHeight(textLayoutState), this.preparedSelectionState);
            switch (WhenMappings.$EnumSwitchMapping$0[keyCommandMo1457mapZmokQxo.ordinal()]) {
                case 1:
                    textFieldSelectionState.copy(false);
                    z = true;
                    break;
                case 2:
                    textFieldSelectionState.paste();
                    z = true;
                    break;
                case 3:
                    textFieldSelectionState.cut();
                    z = true;
                    break;
                case 4:
                    textFieldPreparedSelection.collapseLeftOr(new Function1<TextFieldPreparedSelection, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((TextFieldPreparedSelection) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextFieldPreparedSelection textFieldPreparedSelection2) {
                            textFieldPreparedSelection2.moveCursorLeft();
                        }
                    });
                    z = true;
                    break;
                case 5:
                    textFieldPreparedSelection.collapseRightOr(new Function1<TextFieldPreparedSelection, Unit>() {
                        public Object invoke(Object obj) {
                            invoke((TextFieldPreparedSelection) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(TextFieldPreparedSelection textFieldPreparedSelection2) {
                            textFieldPreparedSelection2.moveCursorRight();
                        }
                    });
                    z = true;
                    break;
                case 6:
                    textFieldPreparedSelection.moveCursorLeftByWord();
                    z = true;
                    break;
                case 7:
                    textFieldPreparedSelection.moveCursorRightByWord();
                    z = true;
                    break;
                case 8:
                    textFieldPreparedSelection.moveCursorPrevByParagraph();
                    z = true;
                    break;
                case 9:
                    textFieldPreparedSelection.moveCursorNextByParagraph();
                    z = true;
                    break;
                case 10:
                    textFieldPreparedSelection.moveCursorUpByLine();
                    z = true;
                    break;
                case 11:
                    textFieldPreparedSelection.moveCursorDownByLine();
                    z = true;
                    break;
                case Matrix.TranslateX:
                    textFieldPreparedSelection.moveCursorUpByPage();
                    z = true;
                    break;
                case Matrix.TranslateY:
                    textFieldPreparedSelection.moveCursorDownByPage();
                    z = true;
                    break;
                case Matrix.TranslateZ:
                    textFieldPreparedSelection.moveCursorToLineStart();
                    z = true;
                    break;
                case 15:
                    textFieldPreparedSelection.moveCursorToLineEnd();
                    z = true;
                    break;
                case 16:
                    textFieldPreparedSelection.moveCursorToLineLeftSide();
                    z = true;
                    break;
                case 17:
                    textFieldPreparedSelection.moveCursorToLineRightSide();
                    z = true;
                    break;
                case 18:
                    textFieldPreparedSelection.moveCursorToHome();
                    z = true;
                    break;
                case 19:
                    textFieldPreparedSelection.moveCursorToEnd();
                    z = true;
                    break;
                case 20:
                    if (TextRange.getCollapsed-impl(textFieldPreparedSelection.getSelection())) {
                        Integer numValueOf = Integer.valueOf(textFieldPreparedSelection.getPrecedingCharacterIndex());
                        if (numValueOf.intValue() == -1) {
                            numValueOf = null;
                        }
                        textRange = numValueOf != null ? TextRange.box-impl(TextRangeKt.TextRange(numValueOf.intValue(), TextRange.getEnd-impl(textFieldPreparedSelection.getSelection()))) : null;
                        if (textRange != null) {
                            TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textRange.unbox-impl(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                        }
                    } else {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textFieldPreparedSelection.getSelection(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    }
                    z = true;
                    break;
                case 21:
                    if (TextRange.getCollapsed-impl(textFieldPreparedSelection.getSelection())) {
                        Integer numValueOf2 = Integer.valueOf(textFieldPreparedSelection.getNextCharacterIndex());
                        if (numValueOf2.intValue() == -1) {
                            numValueOf2 = null;
                        }
                        textRange = numValueOf2 != null ? TextRange.box-impl(TextRangeKt.TextRange(TextRange.getStart-impl(textFieldPreparedSelection.getSelection()), numValueOf2.intValue())) : null;
                        if (textRange != null) {
                            TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textRange.unbox-impl(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                        }
                    } else {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textFieldPreparedSelection.getSelection(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    }
                    z = true;
                    break;
                case 22:
                    if (!TextRange.getCollapsed-impl(textFieldPreparedSelection.getSelection())) {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textFieldPreparedSelection.getSelection(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    } else {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", TextRangeKt.TextRange(textFieldPreparedSelection.getPreviousWordOffset(), TextRange.getEnd-impl(textFieldPreparedSelection.getSelection())), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    }
                    z = true;
                    break;
                case 23:
                    if (!TextRange.getCollapsed-impl(textFieldPreparedSelection.getSelection())) {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textFieldPreparedSelection.getSelection(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    } else {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", TextRangeKt.TextRange(TextRange.getStart-impl(textFieldPreparedSelection.getSelection()), textFieldPreparedSelection.getNextWordOffset()), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    }
                    z = true;
                    break;
                case 24:
                    if (!TextRange.getCollapsed-impl(textFieldPreparedSelection.getSelection())) {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textFieldPreparedSelection.getSelection(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    } else {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", TextRangeKt.TextRange(textFieldPreparedSelection.getLineStartByOffset(), TextRange.getEnd-impl(textFieldPreparedSelection.getSelection())), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    }
                    z = true;
                    break;
                case 25:
                    if (!TextRange.getCollapsed-impl(textFieldPreparedSelection.getSelection())) {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", textFieldPreparedSelection.getSelection(), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    } else {
                        TransformedTextFieldState.m1719replaceTextM8tDOmk$default(textFieldPreparedSelection.state, "", TextRangeKt.TextRange(TextRange.getStart-impl(textFieldPreparedSelection.getSelection()), textFieldPreparedSelection.getLineEndByOffset()), null, !textFieldPreparedSelection.isFromSoftKeyboard, 4, null);
                    }
                    z = true;
                    break;
                case 26:
                    if (!singleLine) {
                        TextFieldState textFieldState3 = textFieldState.textFieldState;
                        InputTransformation inputTransformation2 = textFieldState.inputTransformation;
                        TextFieldEditUndoBehavior textFieldEditUndoBehavior2 = TextFieldEditUndoBehavior.MergeIfPossible;
                        textFieldState3.getMainBuffer().getChangeTracker().clearChanges();
                        EditingBuffer mainBuffer2 = textFieldState3.getMainBuffer();
                        mainBuffer2.commitComposition();
                        EditCommandKt.commitText(mainBuffer2, "\n", 1);
                        textFieldState3.commitEditAsUser(inputTransformation2, true, textFieldEditUndoBehavior2);
                    } else {
                        onSubmit.invoke();
                    }
                    z = true;
                    break;
                case 27:
                    if (!singleLine) {
                        TextFieldState textFieldState4 = textFieldState.textFieldState;
                        InputTransformation inputTransformation3 = textFieldState.inputTransformation;
                        TextFieldEditUndoBehavior textFieldEditUndoBehavior3 = TextFieldEditUndoBehavior.MergeIfPossible;
                        textFieldState4.getMainBuffer().getChangeTracker().clearChanges();
                        EditingBuffer mainBuffer3 = textFieldState4.getMainBuffer();
                        mainBuffer3.commitComposition();
                        EditCommandKt.commitText(mainBuffer3, "\t", 1);
                        textFieldState4.commitEditAsUser(inputTransformation3, true, textFieldEditUndoBehavior3);
                        z = true;
                    }
                    break;
                case 28:
                    textFieldPreparedSelection.selectAll();
                    z = true;
                    break;
                case 29:
                    textFieldPreparedSelection.moveCursorLeft().selectMovement();
                    z = true;
                    break;
                case 30:
                    textFieldPreparedSelection.moveCursorRight().selectMovement();
                    z = true;
                    break;
                case 31:
                    textFieldPreparedSelection.moveCursorLeftByWord().selectMovement();
                    z = true;
                    break;
                case 32:
                    textFieldPreparedSelection.moveCursorRightByWord().selectMovement();
                    z = true;
                    break;
                case UtilsKt.MUTABLE_BUFFER_SIZE:
                    textFieldPreparedSelection.moveCursorPrevByParagraph().selectMovement();
                    z = true;
                    break;
                case 34:
                    textFieldPreparedSelection.moveCursorNextByParagraph().selectMovement();
                    z = true;
                    break;
                case 35:
                    textFieldPreparedSelection.moveCursorToLineStart().selectMovement();
                    z = true;
                    break;
                case 36:
                    textFieldPreparedSelection.moveCursorToLineEnd().selectMovement();
                    z = true;
                    break;
                case 37:
                    textFieldPreparedSelection.moveCursorToLineLeftSide().selectMovement();
                    z = true;
                    break;
                case 38:
                    textFieldPreparedSelection.moveCursorToLineRightSide().selectMovement();
                    z = true;
                    break;
                case 39:
                    textFieldPreparedSelection.moveCursorUpByLine().selectMovement();
                    z = true;
                    break;
                case 40:
                    textFieldPreparedSelection.moveCursorDownByLine().selectMovement();
                    z = true;
                    break;
                case 41:
                    textFieldPreparedSelection.moveCursorUpByPage().selectMovement();
                    z = true;
                    break;
                case 42:
                    textFieldPreparedSelection.moveCursorDownByPage().selectMovement();
                    z = true;
                    break;
                case 43:
                    textFieldPreparedSelection.moveCursorToHome().selectMovement();
                    z = true;
                    break;
                case 44:
                    textFieldPreparedSelection.moveCursorToEnd().selectMovement();
                    z = true;
                    break;
                case 45:
                    textFieldPreparedSelection.deselect();
                    z = true;
                    break;
                case 46:
                    textFieldState.undo();
                    z = true;
                    break;
                case 47:
                    textFieldState.redo();
                    z = true;
                    break;
                case 48:
                    KeyEventHelpers_androidKt.showCharacterPalette();
                    z = true;
                    break;
                default:
                    z = true;
                    break;
            }
            if (!TextRange.equals-impl0(textFieldPreparedSelection.getSelection(), textFieldPreparedSelection.getInitialValue().getSelection())) {
                textFieldState.m1726selectCharsIn5zctL8(textFieldPreparedSelection.getSelection());
            }
        }
        return z;
    }

    private final void preparedSelectionContext(TransformedTextFieldState state, TextLayoutState textLayoutState, boolean isFromSoftKeyboard, Function1<? super TextFieldPreparedSelection, Unit> block) {
        TextFieldPreparedSelection textFieldPreparedSelection = new TextFieldPreparedSelection(state, textLayoutState.getLayoutResult(), isFromSoftKeyboard, getVisibleTextLayoutHeight(textLayoutState), this.preparedSelectionState);
        block.invoke(textFieldPreparedSelection);
        if (TextRange.equals-impl0(textFieldPreparedSelection.getSelection(), textFieldPreparedSelection.getInitialValue().getSelection())) {
            return;
        }
        state.m1726selectCharsIn5zctL8(textFieldPreparedSelection.getSelection());
    }

    private final float getVisibleTextLayoutHeight(TextLayoutState textLayoutState) {
        LayoutCoordinates textLayoutNodeCoordinates = textLayoutState.getTextLayoutNodeCoordinates();
        if (textLayoutNodeCoordinates != null) {
            Rect rectLocalBoundingBoxOf$default = null;
            if (!textLayoutNodeCoordinates.isAttached()) {
                textLayoutNodeCoordinates = null;
            }
            if (textLayoutNodeCoordinates != null) {
                LayoutCoordinates decoratorNodeCoordinates = textLayoutState.getDecoratorNodeCoordinates();
                if (decoratorNodeCoordinates != null) {
                    if (!decoratorNodeCoordinates.isAttached()) {
                        decoratorNodeCoordinates = null;
                    }
                    if (decoratorNodeCoordinates != null) {
                        rectLocalBoundingBoxOf$default = LayoutCoordinates.CC.localBoundingBoxOf$default(decoratorNodeCoordinates, textLayoutNodeCoordinates, false, 2, null);
                    }
                }
                if (rectLocalBoundingBoxOf$default != null) {
                    return Size.m4412getHeightimpl(rectLocalBoundingBoxOf$default.m4379getSizeNHjbRc());
                }
            }
        }
        return Float.NaN;
    }
}
