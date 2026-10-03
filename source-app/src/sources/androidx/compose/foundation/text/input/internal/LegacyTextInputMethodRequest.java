package androidx.compose.foundation.text.input.internal;

import android.graphics.Rect;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.EditorInfo;
import androidx.compose.foundation.text.LegacyTextFieldState;
import androidx.compose.foundation.text.selection.TextFieldSelectionManager;
import androidx.compose.p002ui.graphics.Matrix;
import androidx.compose.p002ui.platform.PlatformTextInputMethodRequest;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.input.EditCommand;
import androidx.compose.ui.text.input.ImeAction;
import androidx.compose.ui.text.input.ImeOptions;
import androidx.compose.ui.text.input.OffsetMapping;
import androidx.compose.ui.text.input.TextFieldValue;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u0000¤\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B)\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0012\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u0010\u00101\u001a\u00020\u001c2\u0006\u00102\u001a\u000203H\u0016J\u000e\u00104\u001a\u00020\u00072\u0006\u00105\u001a\u000206J\b\u00107\u001a\u00020\u0007H\u0002JN\u00108\u001a\u00020\u00072\u0006\u00109\u001a\u00020'2\b\u0010:\u001a\u0004\u0018\u00010;2\u0006\u0010\u001d\u001a\u00020\u001e2\u0018\u0010!\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020#0\"\u0012\u0004\u0012\u00020\u00070\u00052\u0012\u0010$\u001a\u000e\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u00070\u0005J\u0018\u0010<\u001a\u00020\u00072\b\u0010=\u001a\u0004\u0018\u00010'2\u0006\u0010>\u001a\u00020'J.\u0010?\u001a\u00020\u00072\u0006\u0010@\u001a\u00020'2\u0006\u0010A\u001a\u00020B2\u0006\u0010C\u001a\u00020D2\u0006\u0010E\u001a\u0002062\u0006\u0010F\u001a\u000206R\u001b\u0010\u000b\u001a\u00020\f8BX\u0082\u0084\u0002¢\u0006\f\n\u0004\b\u000f\u0010\u0010\u001a\u0004\b\r\u0010\u000eR\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010\u0013\u001a\u0004\u0018\u00010\u0014X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R\u001a\u0010\u0019\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001c0\u001b0\u001aX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u001eX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u001f\u001a\u0004\u0018\u00010 X\u0082\u000e¢\u0006\u0002\n\u0000R \u0010!\u001a\u0014\u0012\n\u0012\b\u0012\u0004\u0012\u00020#0\"\u0012\u0004\u0012\u00020\u00070\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010$\u001a\u000e\u0012\u0004\u0012\u00020%\u0012\u0004\u0012\u00020\u00070\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010(\u001a\u00020'2\u0006\u0010&\u001a\u00020'@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b)\u0010*R\u0010\u0010+\u001a\u0004\u0018\u00010,X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b-\u0010.R\u0010\u0010/\u001a\u0004\u0018\u000100X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006G"}, d2 = {"Landroidx/compose/foundation/text/input/internal/LegacyTextInputMethodRequest;", "Landroidx/compose/ui/platform/PlatformTextInputMethodRequest;", "view", "Landroid/view/View;", "localToScreen", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/Matrix;", "", "inputMethodManager", "Landroidx/compose/foundation/text/input/internal/InputMethodManager;", "(Landroid/view/View;Lkotlin/jvm/functions/Function1;Landroidx/compose/foundation/text/input/internal/InputMethodManager;)V", "baseInputConnection", "Landroid/view/inputmethod/BaseInputConnection;", "getBaseInputConnection", "()Landroid/view/inputmethod/BaseInputConnection;", "baseInputConnection$delegate", "Lkotlin/Lazy;", "cursorAnchorInfoController", "Landroidx/compose/foundation/text/input/internal/LegacyCursorAnchorInfoController;", "focusedRect", "Landroid/graphics/Rect;", "getFocusedRect$foundation_release", "()Landroid/graphics/Rect;", "setFocusedRect$foundation_release", "(Landroid/graphics/Rect;)V", "ics", "", "Ljava/lang/ref/WeakReference;", "Landroidx/compose/foundation/text/input/internal/RecordingInputConnection;", "imeOptions", "Landroidx/compose/ui/text/input/ImeOptions;", "legacyTextFieldState", "Landroidx/compose/foundation/text/LegacyTextFieldState;", "onEditCommand", "", "Landroidx/compose/ui/text/input/EditCommand;", "onImeActionPerformed", "Landroidx/compose/ui/text/input/ImeAction;", "<set-?>", "Landroidx/compose/ui/text/input/TextFieldValue;", "state", "getState", "()Landroidx/compose/ui/text/input/TextFieldValue;", "textFieldSelectionManager", "Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;", "getView", "()Landroid/view/View;", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "createInputConnection", "outAttributes", "Landroid/view/inputmethod/EditorInfo;", "notifyFocusedRect", "rect", "Landroidx/compose/ui/geometry/Rect;", "restartInputImmediately", "startInput", "value", "textInputNode", "Landroidx/compose/foundation/text/input/internal/LegacyPlatformTextInputServiceAdapter$LegacyPlatformTextInputNode;", "updateState", "oldValue", "newValue", "updateTextLayoutResult", "textFieldValue", "offsetMapping", "Landroidx/compose/ui/text/input/OffsetMapping;", "textLayoutResult", "Landroidx/compose/ui/text/TextLayoutResult;", "innerTextFieldBounds", "decorationBoxBounds", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LegacyTextInputMethodRequest implements PlatformTextInputMethodRequest {
    public static final int $stable = 8;
    private final LegacyCursorAnchorInfoController cursorAnchorInfoController;
    private Rect focusedRect;
    private final InputMethodManager inputMethodManager;
    private LegacyTextFieldState legacyTextFieldState;
    private TextFieldSelectionManager textFieldSelectionManager;
    private final View view;
    private ViewConfiguration viewConfiguration;
    private Function1<? super List<? extends EditCommand>, Unit> onEditCommand = new Function1<List<? extends EditCommand>, Unit>() {
        public final void invoke(List<? extends EditCommand> list) {
        }

        public Object invoke(Object obj) {
            invoke((List<? extends EditCommand>) obj);
            return Unit.INSTANCE;
        }
    };
    private Function1<? super ImeAction, Unit> onImeActionPerformed = new Function1<ImeAction, Unit>() {
        public final void m1651invokeKlQnJC8(int i) {
        }

        public Object invoke(Object obj) {
            m1651invokeKlQnJC8(((ImeAction) obj).unbox-impl());
            return Unit.INSTANCE;
        }
    };
    private TextFieldValue state = new TextFieldValue("", TextRange.Companion.getZero-d9O1mEE(), (TextRange) null, 4, (DefaultConstructorMarker) null);
    private ImeOptions imeOptions = ImeOptions.Companion.getDefault();
    private List<WeakReference<RecordingInputConnection>> ics = new ArrayList();

    private final Lazy baseInputConnection = LazyKt.lazy(LazyThreadSafetyMode.NONE, new Function0<BaseInputConnection>() {
        {
            super(0);
        }

        public final BaseInputConnection m1650invoke() {
            return new BaseInputConnection(this.this$0.getView(), false);
        }
    });

    public LegacyTextInputMethodRequest(View view, Function1<? super Matrix, Unit> function1, InputMethodManager inputMethodManager) {
        this.view = view;
        this.inputMethodManager = inputMethodManager;
        this.cursorAnchorInfoController = new LegacyCursorAnchorInfoController(function1, inputMethodManager);
    }

    public final View getView() {
        return this.view;
    }

    public final TextFieldValue getState() {
        return this.state;
    }

    public final BaseInputConnection getBaseInputConnection() {
        return (BaseInputConnection) this.baseInputConnection.getValue();
    }

    public final Rect getFocusedRect() {
        return this.focusedRect;
    }

    public final void setFocusedRect$foundation_release(Rect rect) {
        this.focusedRect = rect;
    }

    public final void startInput(TextFieldValue value, LegacyPlatformTextInputServiceAdapter.LegacyPlatformTextInputNode textInputNode, ImeOptions imeOptions, Function1<? super List<? extends EditCommand>, Unit> onEditCommand, Function1<? super ImeAction, Unit> onImeActionPerformed) {
        this.state = value;
        this.imeOptions = imeOptions;
        this.onEditCommand = onEditCommand;
        this.onImeActionPerformed = onImeActionPerformed;
        this.legacyTextFieldState = textInputNode != null ? textInputNode.getLegacyTextFieldState() : null;
        this.textFieldSelectionManager = textInputNode != null ? textInputNode.getTextFieldSelectionManager() : null;
        this.viewConfiguration = textInputNode != null ? textInputNode.getViewConfiguration() : null;
    }

    @Override
    public RecordingInputConnection createInputConnection(EditorInfo outAttributes) {
        EditorInfo_androidKt.m1621updatepLxbY9I$default(outAttributes, this.state.getText(), this.state.getSelection-d9O1mEE(), this.imeOptions, null, 8, null);
        LegacyPlatformTextInputServiceAdapter_androidKt.updateWithEmojiCompat(outAttributes);
        TextFieldValue textFieldValue = this.state;
        boolean autoCorrect = this.imeOptions.getAutoCorrect();
        RecordingInputConnection recordingInputConnection = new RecordingInputConnection(textFieldValue, new InputEventCallback2() {
            @Override
            public void onEditCommands(List<? extends EditCommand> editCommands) {
                LegacyTextInputMethodRequest.this.onEditCommand.invoke(editCommands);
            }

            @Override
            public void mo1648onImeActionKlQnJC8(int imeAction) {
                LegacyTextInputMethodRequest.this.onImeActionPerformed.invoke(ImeAction.box-impl(imeAction));
            }

            @Override
            public void onKeyEvent(KeyEvent event) {
                LegacyTextInputMethodRequest.this.getBaseInputConnection().sendKeyEvent(event);
            }

            @Override
            public void onRequestCursorAnchorInfo(boolean immediate, boolean monitor, boolean includeInsertionMarker, boolean includeCharacterBounds, boolean includeEditorBounds, boolean includeLineBounds) {
                LegacyTextInputMethodRequest.this.cursorAnchorInfoController.requestUpdate(immediate, monitor, includeInsertionMarker, includeCharacterBounds, includeEditorBounds, includeLineBounds);
            }

            @Override
            public void onConnectionClosed(RecordingInputConnection inputConnection) {
                int size = LegacyTextInputMethodRequest.this.ics.size();
                for (int i = 0; i < size; i++) {
                    if (Intrinsics.areEqual(((WeakReference) LegacyTextInputMethodRequest.this.ics.get(i)).get(), inputConnection)) {
                        LegacyTextInputMethodRequest.this.ics.remove(i);
                        return;
                    }
                }
            }
        }, autoCorrect, this.legacyTextFieldState, this.textFieldSelectionManager, this.viewConfiguration);
        this.ics.add(new WeakReference<>(recordingInputConnection));
        return recordingInputConnection;
    }

    public final void updateState(TextFieldValue oldValue, TextFieldValue newValue) {
        boolean z = (TextRange.equals-impl0(this.state.getSelection-d9O1mEE(), newValue.getSelection-d9O1mEE()) && Intrinsics.areEqual(this.state.getComposition-MzsxiRA(), newValue.getComposition-MzsxiRA())) ? false : true;
        this.state = newValue;
        int size = this.ics.size();
        for (int i = 0; i < size; i++) {
            RecordingInputConnection recordingInputConnection = this.ics.get(i).get();
            if (recordingInputConnection != null) {
                recordingInputConnection.setTextFieldValue$foundation_release(newValue);
            }
        }
        this.cursorAnchorInfoController.invalidate();
        if (Intrinsics.areEqual(oldValue, newValue)) {
            if (z) {
                InputMethodManager inputMethodManager = this.inputMethodManager;
                int i2 = TextRange.getMin-impl(newValue.getSelection-d9O1mEE());
                int i3 = TextRange.getMax-impl(newValue.getSelection-d9O1mEE());
                TextRange textRange = this.state.getComposition-MzsxiRA();
                int i4 = textRange != null ? TextRange.getMin-impl(textRange.unbox-impl()) : -1;
                TextRange textRange2 = this.state.getComposition-MzsxiRA();
                inputMethodManager.updateSelection(i2, i3, i4, textRange2 != null ? TextRange.getMax-impl(textRange2.unbox-impl()) : -1);
                return;
            }
            return;
        }
        if (oldValue != null && (!Intrinsics.areEqual(oldValue.getText(), newValue.getText()) || (TextRange.equals-impl0(oldValue.getSelection-d9O1mEE(), newValue.getSelection-d9O1mEE()) && !Intrinsics.areEqual(oldValue.getComposition-MzsxiRA(), newValue.getComposition-MzsxiRA())))) {
            restartInputImmediately();
            return;
        }
        int size2 = this.ics.size();
        for (int i5 = 0; i5 < size2; i5++) {
            RecordingInputConnection recordingInputConnection2 = this.ics.get(i5).get();
            if (recordingInputConnection2 != null) {
                recordingInputConnection2.updateInputState(this.state, this.inputMethodManager);
            }
        }
    }

    public final void notifyFocusedRect(androidx.compose.p002ui.geometry.Rect rect) {
        Rect rect2;
        this.focusedRect = new Rect(MathKt.roundToInt(rect.getLeft()), MathKt.roundToInt(rect.getTop()), MathKt.roundToInt(rect.getRight()), MathKt.roundToInt(rect.getBottom()));
        if (!this.ics.isEmpty() || (rect2 = this.focusedRect) == null) {
            return;
        }
        this.view.requestRectangleOnScreen(new Rect(rect2));
    }

    public final void updateTextLayoutResult(TextFieldValue textFieldValue, OffsetMapping offsetMapping, TextLayoutResult textLayoutResult, androidx.compose.p002ui.geometry.Rect innerTextFieldBounds, androidx.compose.p002ui.geometry.Rect decorationBoxBounds) {
        this.cursorAnchorInfoController.updateTextLayoutResult(textFieldValue, offsetMapping, textLayoutResult, innerTextFieldBounds, decorationBoxBounds);
    }

    private final void restartInputImmediately() {
        this.inputMethodManager.restartInput();
    }
}
