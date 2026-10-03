package androidx.compose.foundation.text.input.internal;

import android.R;
import android.os.Build;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.Handler;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.inputmethod.CompletionInfo;
import android.view.inputmethod.CorrectionInfo;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.ExtractedText;
import android.view.inputmethod.ExtractedTextRequest;
import android.view.inputmethod.HandwritingGesture;
import android.view.inputmethod.InputConnection;
import android.view.inputmethod.InputConnectionWrapper;
import android.view.inputmethod.InputContentInfo;
import android.view.inputmethod.PreviewableHandwritingGesture;
import androidx.compose.foundation.text.input.TextFieldCharSequence;
import androidx.compose.foundation.text.input.TextFieldCharSequenceKt;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.input.ImeAction;
import androidx.core.view.inputmethod.InputConnectionCompat;
import androidx.core.view.inputmethod.InputContentInfoCompat;
import java.util.concurrent.Executor;
import java.util.function.IntConsumer;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000¹\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\r\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\b*\u0001\u0013\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J!\u0010\u0019\u001a\u00020\u00102\u0017\u0010\u001a\u001a\u0013\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u00100\u000e¢\u0006\u0002\b\u0011H\u0002J\b\u0010\u001b\u001a\u00020\u001cH\u0016J\b\u0010\u001d\u001a\u00020\u001cH\u0002J\u0010\u0010\u001e\u001a\u00020\u001c2\u0006\u0010\u001f\u001a\u00020\bH\u0016J\b\u0010 \u001a\u00020\u0010H\u0016J\u0012\u0010!\u001a\u00020\u001c2\b\u0010\u0015\u001a\u0004\u0018\u00010\"H\u0016J\"\u0010#\u001a\u00020\u001c2\u0006\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\b2\b\u0010'\u001a\u0004\u0018\u00010(H\u0016J\u0012\u0010)\u001a\u00020\u001c2\b\u0010*\u001a\u0004\u0018\u00010+H\u0016J\u001a\u0010,\u001a\u00020\u001c2\b\u0010\u0015\u001a\u0004\u0018\u00010-2\u0006\u0010.\u001a\u00020\bH\u0016J\u0018\u0010/\u001a\u00020\u001c2\u0006\u00100\u001a\u00020\b2\u0006\u00101\u001a\u00020\bH\u0016J\u0018\u00102\u001a\u00020\u001c2\u0006\u00100\u001a\u00020\b2\u0006\u00101\u001a\u00020\bH\u0016J\b\u00103\u001a\u00020\u001cH\u0016J\b\u00104\u001a\u00020\u001cH\u0002J\b\u00105\u001a\u00020\u001cH\u0016J\u0010\u00106\u001a\u00020\b2\u0006\u00107\u001a\u00020\bH\u0016J\u001a\u00108\u001a\u0002092\b\u0010:\u001a\u0004\u0018\u00010;2\u0006\u0010&\u001a\u00020\bH\u0016J\n\u0010<\u001a\u0004\u0018\u00010=H\u0016J\u0012\u0010>\u001a\u0004\u0018\u00010-2\u0006\u0010&\u001a\u00020\bH\u0016J\u0018\u0010?\u001a\u00020-2\u0006\u0010@\u001a\u00020\b2\u0006\u0010&\u001a\u00020\bH\u0016J\u0018\u0010A\u001a\u00020-2\u0006\u0010@\u001a\u00020\b2\u0006\u0010&\u001a\u00020\bH\u0016J\u0010\u0010B\u001a\u00020\u00102\u0006\u0010C\u001a\u00020DH\u0002J\u0010\u0010E\u001a\u00020\u001c2\u0006\u0010F\u001a\u00020\bH\u0016J\u0010\u0010G\u001a\u00020\u001c2\u0006\u0010H\u001a\u00020\bH\u0016J$\u0010I\u001a\u00020\u00102\u0006\u0010J\u001a\u00020K2\b\u0010L\u001a\u0004\u0018\u00010M2\b\u0010N\u001a\u0004\u0018\u00010OH\u0016J\u001c\u0010P\u001a\u00020\u001c2\b\u0010Q\u001a\u0004\u0018\u00010D2\b\u0010R\u001a\u0004\u0018\u00010(H\u0016J\u001a\u0010S\u001a\u00020\u001c2\u0006\u0010J\u001a\u00020T2\b\u0010U\u001a\u0004\u0018\u00010VH\u0016J\u0010\u0010W\u001a\u00020\u001c2\u0006\u0010X\u001a\u00020\u001cH\u0016J\u0010\u0010Y\u001a\u00020\u001c2\u0006\u0010Z\u001a\u00020\bH\u0016J\u0010\u0010[\u001a\u00020\u001c2\u0006\u0010\\\u001a\u00020]H\u0016J\u0010\u0010^\u001a\u00020\u00102\u0006\u0010_\u001a\u00020\bH\u0002J\u0018\u0010`\u001a\u00020\u001c2\u0006\u0010a\u001a\u00020\b2\u0006\u0010b\u001a\u00020\bH\u0016J\u001a\u0010c\u001a\u00020\u001c2\b\u0010\u0015\u001a\u0004\u0018\u00010-2\u0006\u0010.\u001a\u00020\bH\u0016J\u0018\u0010d\u001a\u00020\u001c2\u0006\u0010a\u001a\u00020\b2\u0006\u0010b\u001a\u00020\bH\u0016R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\u00020\u0001X\u0082\u0004¢\u0006\b\n\u0000\u0012\u0004\b\n\u0010\u000bR%\u0010\f\u001a\u0019\u0012\u0015\u0012\u0013\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u00100\u000e¢\u0006\u0002\b\u00110\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0014R\u0014\u0010\u0015\u001a\u00020\u00168BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0017\u0010\u0018¨\u0006e"}, d2 = {"Landroidx/compose/foundation/text/input/internal/StatelessInputConnection;", "Landroid/view/inputmethod/InputConnection;", "session", "Landroidx/compose/foundation/text/input/internal/TextInputSession;", "editorInfo", "Landroid/view/inputmethod/EditorInfo;", "(Landroidx/compose/foundation/text/input/internal/TextInputSession;Landroid/view/inputmethod/EditorInfo;)V", "batchDepth", "", "commitContentDelegateInputConnection", "getCommitContentDelegateInputConnection$annotations", "()V", "editCommands", "Landroidx/compose/runtime/collection/MutableVector;", "Lkotlin/Function1;", "Landroidx/compose/foundation/text/input/internal/EditingBuffer;", "", "Lkotlin/ExtensionFunctionType;", "terminalInputConnection", "androidx/compose/foundation/text/input/internal/StatelessInputConnection$terminalInputConnection$1", "Landroidx/compose/foundation/text/input/internal/StatelessInputConnection$terminalInputConnection$1;", "text", "Landroidx/compose/foundation/text/input/TextFieldCharSequence;", "getText", "()Landroidx/compose/foundation/text/input/TextFieldCharSequence;", "addEditCommandWithBatch", "editCommand", "beginBatchEdit", "", "beginBatchEditInternal", "clearMetaKeyStates", "states", "closeConnection", "commitCompletion", "Landroid/view/inputmethod/CompletionInfo;", "commitContent", "inputContentInfo", "Landroid/view/inputmethod/InputContentInfo;", "flags", "opts", "Landroid/os/Bundle;", "commitCorrection", "correctionInfo", "Landroid/view/inputmethod/CorrectionInfo;", "commitText", "", "newCursorPosition", "deleteSurroundingText", "beforeLength", "afterLength", "deleteSurroundingTextInCodePoints", "endBatchEdit", "endBatchEditInternal", "finishComposingText", "getCursorCapsMode", "reqModes", "getExtractedText", "Landroid/view/inputmethod/ExtractedText;", "request", "Landroid/view/inputmethod/ExtractedTextRequest;", "getHandler", "Landroid/os/Handler;", "getSelectedText", "getTextAfterCursor", "maxChars", "getTextBeforeCursor", "logDebug", "message", "", "performContextMenuAction", "id", "performEditorAction", "editorAction", "performHandwritingGesture", "gesture", "Landroid/view/inputmethod/HandwritingGesture;", "executor", "Ljava/util/concurrent/Executor;", "consumer", "Ljava/util/function/IntConsumer;", "performPrivateCommand", "action", "data", "previewHandwritingGesture", "Landroid/view/inputmethod/PreviewableHandwritingGesture;", "cancellationSignal", "Landroid/os/CancellationSignal;", "reportFullscreenMode", "enabled", "requestCursorUpdates", "cursorUpdateMode", "sendKeyEvent", "event", "Landroid/view/KeyEvent;", "sendSynthesizedKeyEvent", "code", "setComposingRegion", "start", "end", "setComposingText", "setSelection", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class StatelessInputConnection implements InputConnection {
    public static final int $stable = 8;
    private int batchDepth;
    private final InputConnection commitContentDelegateInputConnection;
    private final MutableVector<Function1<EditingBuffer, Unit>> editCommands = new MutableVector<>(new Function1[16], 0);
    private final TextInputSession session;
    private final StatelessInputConnection$terminalInputConnection$1 terminalInputConnection;

    private static void getCommitContentDelegateInputConnection$annotations() {
    }

    public final void logDebug(String message) {
    }

    @Override
    public boolean commitCorrection(CorrectionInfo correctionInfo) {
        return true;
    }

    public StatelessInputConnection(TextInputSession textInputSession, EditorInfo editorInfo) {
        this.session = textInputSession;
        ?? r3 = new InputConnectionWrapper(this) {
            @Override
            public boolean commitContent(InputContentInfo inputContentInfo, int flags, Bundle opts) {
                return false;
            }

            @Override
            public boolean performPrivateCommand(String action, Bundle data) {
                return true;
            }

            {
                super(this, false);
            }
        };
        this.terminalInputConnection = r3;
        this.commitContentDelegateInputConnection = InputConnectionCompat.createWrapper((InputConnection) r3, editorInfo, new InputConnectionCompat.OnCommitContentListener() {
            public boolean onCommitContent(InputContentInfoCompat inputContentInfo, int flags, Bundle opts) {
                if (Build.VERSION.SDK_INT >= 25 && (flags & 1) != 0) {
                    try {
                        inputContentInfo.requestPermission();
                        Object objUnwrap = inputContentInfo.unwrap();
                        Intrinsics.checkNotNull(objUnwrap, "null cannot be cast to non-null type android.os.Parcelable");
                        Parcelable parcelable = (Parcelable) objUnwrap;
                        opts = opts == null ? new Bundle() : new Bundle(opts);
                        opts.putParcelable("EXTRA_INPUT_CONTENT_INFO", parcelable);
                    } catch (Exception e) {
                        this.this$0.logDebug("Can't insert content from IME; requestPermission() failed, " + e);
                        return false;
                    }
                }
                return this.this$0.session.onCommitContent(StatelessInputConnection_androidKt.toTransferableContent(inputContentInfo, opts));
            }
        });
    }

    public final TextFieldCharSequence getText() {
        return this.session.getText();
    }

    private final void addEditCommandWithBatch(Function1<? super EditingBuffer, Unit> editCommand) {
        beginBatchEditInternal();
        try {
            this.editCommands.add(editCommand);
        } finally {
            endBatchEditInternal();
        }
    }

    @Override
    public boolean beginBatchEdit() {
        logDebug("beginBatchEdit()");
        return beginBatchEditInternal();
    }

    private final boolean beginBatchEditInternal() {
        this.batchDepth++;
        return true;
    }

    @Override
    public boolean endBatchEdit() {
        logDebug("endBatchEdit()");
        return endBatchEditInternal();
    }

    private final boolean endBatchEditInternal() {
        int i = this.batchDepth - 1;
        this.batchDepth = i;
        if (i == 0 && this.editCommands.isNotEmpty()) {
            this.session.requestEdit(new Function1<EditingBuffer, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((EditingBuffer) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(EditingBuffer editingBuffer) {
                    MutableVector mutableVector = StatelessInputConnection.this.editCommands;
                    int size = mutableVector.getSize();
                    if (size > 0) {
                        Object[] content = mutableVector.getContent();
                        int i2 = 0;
                        do {
                            ((Function1) content[i2]).invoke(editingBuffer);
                            i2++;
                        } while (i2 < size);
                    }
                }
            });
            this.editCommands.clear();
        }
        return this.batchDepth > 0;
    }

    @Override
    public void closeConnection() {
        logDebug("closeConnection()");
        this.editCommands.clear();
        this.batchDepth = 0;
    }

    @Override
    public boolean commitText(final CharSequence text, final int newCursorPosition) {
        logDebug("commitText(\"" + ((Object) text) + "\", " + newCursorPosition + ')');
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                EditCommandKt.commitText(editingBuffer, String.valueOf(text), newCursorPosition);
            }
        });
        return true;
    }

    @Override
    public boolean setComposingRegion(final int start, final int end) {
        logDebug("setComposingRegion(" + start + ", " + end + ')');
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                EditCommandKt.setComposingRegion(editingBuffer, start, end);
            }
        });
        return true;
    }

    @Override
    public boolean setComposingText(final CharSequence text, final int newCursorPosition) {
        logDebug("setComposingText(\"" + ((Object) text) + "\", " + newCursorPosition + ')');
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                EditCommandKt.setComposingText(editingBuffer, String.valueOf(text), newCursorPosition);
            }
        });
        return true;
    }

    @Override
    public boolean deleteSurroundingTextInCodePoints(final int beforeLength, final int afterLength) {
        logDebug("deleteSurroundingTextInCodePoints(" + beforeLength + ", " + afterLength + ')');
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                EditCommandKt.deleteSurroundingTextInCodePoints(editingBuffer, beforeLength, afterLength);
            }
        });
        return true;
    }

    @Override
    public boolean deleteSurroundingText(final int beforeLength, final int afterLength) {
        logDebug("deleteSurroundingText(" + beforeLength + ", " + afterLength + ')');
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                EditCommandKt.deleteSurroundingText(editingBuffer, beforeLength, afterLength);
            }
        });
        return true;
    }

    @Override
    public boolean setSelection(final int start, final int end) {
        logDebug("setSelection(" + start + ", " + end + ')');
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                editingBuffer.setSelection(start, end);
            }
        });
        return true;
    }

    @Override
    public boolean finishComposingText() {
        logDebug("finishComposingText()");
        addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
            public Object invoke(Object obj) {
                invoke((EditingBuffer) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(EditingBuffer editingBuffer) {
                EditCommandKt.finishComposingText(editingBuffer);
            }
        });
        return true;
    }

    @Override
    public boolean sendKeyEvent(KeyEvent event) {
        logDebug("sendKeyEvent(" + event + ')');
        this.session.sendKeyEvent(event);
        return true;
    }

    @Override
    public CharSequence getTextBeforeCursor(int maxChars, int flags) {
        String string = TextFieldCharSequenceKt.getTextBeforeSelection(getText(), maxChars).toString();
        logDebug("getTextBeforeCursor(" + maxChars + ", " + flags + "): " + string);
        return string;
    }

    @Override
    public CharSequence getTextAfterCursor(int maxChars, int flags) {
        String string = TextFieldCharSequenceKt.getTextAfterSelection(getText(), maxChars).toString();
        logDebug("getTextAfterCursor(" + maxChars + ", " + flags + "): " + string);
        return string;
    }

    @Override
    public CharSequence getSelectedText(int flags) {
        String string = TextRange.getCollapsed-impl(getText().getSelection()) ? null : TextFieldCharSequenceKt.getSelectedText(getText()).toString();
        logDebug("getSelectedText(" + flags + "): " + ((Object) string));
        return string;
    }

    @Override
    public boolean requestCursorUpdates(int cursorUpdateMode) {
        logDebug("requestCursorUpdates(" + cursorUpdateMode + ')');
        this.session.requestCursorUpdates(cursorUpdateMode);
        return true;
    }

    @Override
    public void performHandwritingGesture(HandwritingGesture gesture, Executor executor, IntConsumer consumer) {
        logDebug("performHandwritingGesture(" + gesture + ", " + executor + ", " + consumer + ')');
        if (Build.VERSION.SDK_INT < 34) {
            return;
        }
        Api34PerformHandwritingGestureImpl.INSTANCE.performHandwritingGesture(this.session, gesture, executor, consumer);
    }

    @Override
    public boolean previewHandwritingGesture(PreviewableHandwritingGesture gesture, CancellationSignal cancellationSignal) {
        logDebug("previewHandwritingGesture(" + gesture + ", " + cancellationSignal + ')');
        if (Build.VERSION.SDK_INT < 34) {
            return false;
        }
        return Api34PerformHandwritingGestureImpl.INSTANCE.previewHandwritingGesture(this.session, gesture, cancellationSignal);
    }

    @Override
    public ExtractedText getExtractedText(ExtractedTextRequest request, int flags) {
        logDebug("getExtractedText(" + request + ", " + flags + ')');
        return StatelessInputConnection_androidKt.toExtractedText(getText());
    }

    @Override
    public int getCursorCapsMode(int reqModes) {
        logDebug("getCursorCapsMode(" + reqModes + ')');
        return TextUtils.getCapsMode(getText(), TextRange.getMin-impl(getText().getSelection()), reqModes);
    }

    @Override
    public boolean performContextMenuAction(int id) {
        logDebug("performContextMenuAction(" + id + ')');
        switch (id) {
            case R.id.selectAll:
                addEditCommandWithBatch(new Function1<EditingBuffer, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((EditingBuffer) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(EditingBuffer editingBuffer) {
                        editingBuffer.setSelection(0, StatelessInputConnection.this.getText().length());
                    }
                });
                break;
            case R.id.cut:
                sendSynthesizedKeyEvent(277);
                break;
            case R.id.copy:
                sendSynthesizedKeyEvent(278);
                break;
            case R.id.paste:
                sendSynthesizedKeyEvent(279);
                break;
        }
        return false;
    }

    private final void sendSynthesizedKeyEvent(int code) {
        sendKeyEvent(new KeyEvent(0, code));
        sendKeyEvent(new KeyEvent(1, code));
    }

    @Override
    public boolean performEditorAction(int editorAction) {
        int i;
        logDebug("performEditorAction(" + editorAction + ')');
        if (editorAction == 0) {
            i = ImeAction.Companion.getDefault-eUduSuo();
        } else {
            switch (editorAction) {
                case 2:
                    i = ImeAction.Companion.getGo-eUduSuo();
                    break;
                case 3:
                    i = ImeAction.Companion.getSearch-eUduSuo();
                    break;
                case 4:
                    i = ImeAction.Companion.getSend-eUduSuo();
                    break;
                case 5:
                    i = ImeAction.Companion.getNext-eUduSuo();
                    break;
                case 6:
                    i = ImeAction.Companion.getDone-eUduSuo();
                    break;
                case 7:
                    i = ImeAction.Companion.getPrevious-eUduSuo();
                    break;
                default:
                    logDebug("IME sent an unrecognized editor action: " + editorAction);
                    i = ImeAction.Companion.getDefault-eUduSuo();
                    break;
            }
        }
        this.session.mo1610onImeActionKlQnJC8(i);
        return true;
    }

    @Override
    public boolean commitCompletion(CompletionInfo text) {
        StringBuilder sb = new StringBuilder("commitCompletion(");
        sb.append((Object) (text != null ? text.getText() : null));
        sb.append(')');
        logDebug(sb.toString());
        return false;
    }

    @Override
    public Handler getHandler() {
        logDebug("getHandler()");
        return null;
    }

    @Override
    public boolean clearMetaKeyStates(int states) {
        logDebug("clearMetaKeyStates(" + states + ')');
        return false;
    }

    @Override
    public boolean reportFullscreenMode(boolean enabled) {
        logDebug("reportFullscreenMode(" + enabled + ')');
        return false;
    }

    @Override
    public boolean performPrivateCommand(String action, Bundle data) {
        logDebug("performPrivateCommand(" + action + ", " + data + ')');
        return this.commitContentDelegateInputConnection.performPrivateCommand(action, data);
    }

    @Override
    public boolean commitContent(InputContentInfo inputContentInfo, int flags, Bundle opts) {
        logDebug("commitContent(" + inputContentInfo + ", " + flags + ", " + opts + ')');
        if (Build.VERSION.SDK_INT >= 25) {
            return Api25CommitContentImpl.INSTANCE.commitContent(this.commitContentDelegateInputConnection, inputContentInfo, flags, opts);
        }
        return false;
    }
}
