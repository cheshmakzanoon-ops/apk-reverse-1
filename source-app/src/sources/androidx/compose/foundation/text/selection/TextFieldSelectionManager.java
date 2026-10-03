package androidx.compose.foundation.text.selection;

import androidx.compose.foundation.text.Handle;
import androidx.compose.foundation.text.HandleState;
import androidx.compose.foundation.text.LegacyTextFieldState;
import androidx.compose.foundation.text.TextDelegate;
import androidx.compose.foundation.text.TextDragObserver;
import androidx.compose.foundation.text.TextFieldCursorKt;
import androidx.compose.foundation.text.TextLayoutResultProxy;
import androidx.compose.foundation.text.UndoManager;
import androidx.compose.foundation.text.ValidatingOffsetMappingKt;
import androidx.compose.p002ui.focus.FocusRequester;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.hapticfeedback.HapticFeedback;
import androidx.compose.p002ui.hapticfeedback.HapticFeedbackType;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.platform.ClipboardManager;
import androidx.compose.p002ui.platform.TextToolbar;
import androidx.compose.p002ui.platform.TextToolbarStatus;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import androidx.compose.ui.text.input.OffsetMapping;
import androidx.compose.ui.text.input.PasswordVisualTransformation;
import androidx.compose.ui.text.input.TextFieldValue;
import androidx.compose.ui.text.input.TextFieldValueKt;
import androidx.compose.ui.text.input.VisualTransformation;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000Â\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B\u0011\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\r\u0010p\u001a\u00020FH\u0000¢\u0006\u0002\bqJ\u0018\u0010r\u001a\u00020F2\u0006\u0010s\u001a\u00020\fø\u0001\u0000¢\u0006\u0004\bt\u0010uJ\u0017\u0010v\u001a\u00020F2\b\b\u0002\u0010w\u001a\u00020!H\u0000¢\u0006\u0002\bxJ\"\u0010y\u001a\u00020C2\u0006\u0010z\u001a\u00020_2\u0006\u0010{\u001a\u00020|H\u0002ø\u0001\u0000¢\u0006\u0004\b}\u0010~J\u000e\u0010\u007f\u001a\u00020[H\u0000¢\u0006\u0003\b\u0080\u0001J\u000f\u0010\u0081\u0001\u001a\u00020FH\u0000¢\u0006\u0003\b\u0082\u0001J\u001e\u0010\u0083\u0001\u001a\u00020F2\n\b\u0002\u0010s\u001a\u0004\u0018\u00010\fH\u0000ø\u0001\u0000¢\u0006\u0003\b\u0084\u0001J\u001a\u0010\u0085\u0001\u001a\u00020F2\t\b\u0002\u0010\u0086\u0001\u001a\u00020!H\u0000¢\u0006\u0003\b\u0087\u0001J\u000f\u0010\u0088\u0001\u001a\u00020FH\u0000¢\u0006\u0003\b\u0089\u0001J\n\u0010\u008a\u0001\u001a\u00030\u008b\u0001H\u0002J\"\u0010\u008c\u0001\u001a\u00020\f2\b\u0010\u008d\u0001\u001a\u00030\u008e\u0001H\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\b\u008f\u0001\u0010\u0090\u0001J!\u0010\u0091\u0001\u001a\u00020\f2\u0007\u0010\u0092\u0001\u001a\u00020!H\u0000ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\b\u0093\u0001\u0010\u0094\u0001J\u0018\u0010\u0095\u0001\u001a\u00020[2\u0007\u0010\u0092\u0001\u001a\u00020!H\u0000¢\u0006\u0003\b\u0096\u0001J\u000f\u0010\u0097\u0001\u001a\u00020FH\u0000¢\u0006\u0003\b\u0098\u0001J\u000f\u0010\u0099\u0001\u001a\u00020!H\u0000¢\u0006\u0003\b\u009a\u0001J\u000f\u0010\u009b\u0001\u001a\u00020FH\u0000¢\u0006\u0003\b\u009c\u0001J\u000f\u0010\u009d\u0001\u001a\u00020FH\u0000¢\u0006\u0003\b\u009e\u0001J\u001d\u0010\u009f\u0001\u001a\u00020F2\u0007\u0010 \u0001\u001a\u00020|H\u0000ø\u0001\u0000¢\u0006\u0005\b¡\u0001\u0010uJ\u0013\u0010¢\u0001\u001a\u00020F2\b\u0010£\u0001\u001a\u00030¤\u0001H\u0002J\u001d\u0010¥\u0001\u001a\u00020F2\u0007\u0010 \u0001\u001a\u00020|H\u0000ø\u0001\u0000¢\u0006\u0005\b¦\u0001\u0010uJ\u000f\u0010§\u0001\u001a\u00020FH\u0000¢\u0006\u0003\b¨\u0001J\u0012\u0010©\u0001\u001a\u00020F2\u0007\u0010ª\u0001\u001a\u00020!H\u0002JK\u0010«\u0001\u001a\u00020|2\u0006\u0010d\u001a\u00020C2\u0007\u0010¬\u0001\u001a\u00020\f2\u0007\u0010\u00ad\u0001\u001a\u00020!2\u0007\u0010\u0092\u0001\u001a\u00020!2\b\u0010®\u0001\u001a\u00030¯\u00012\u0007\u0010°\u0001\u001a\u00020!H\u0002ø\u0001\u0000¢\u0006\u0006\b±\u0001\u0010²\u0001R\u001c\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR5\u0010\r\u001a\u0004\u0018\u00010\f2\b\u0010\u000b\u001a\u0004\u0018\u00010\f8F@BX\u0086\u008e\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0012\n\u0004\b\u0012\u0010\u0013\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011R\u0012\u0010\u0014\u001a\u0004\u0018\u00010\u0015X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u0016R\u0016\u0010\u0017\u001a\u00020\fX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0018R\u0016\u0010\u0019\u001a\u00020\fX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0018R/\u0010\u001b\u001a\u0004\u0018\u00010\u001a2\b\u0010\u000b\u001a\u0004\u0018\u00010\u001a8F@BX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b \u0010\u0013\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fR+\u0010\"\u001a\u00020!2\u0006\u0010\u000b\u001a\u00020!8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b'\u0010\u0013\u001a\u0004\b#\u0010$\"\u0004\b%\u0010&R+\u0010(\u001a\u00020!2\u0006\u0010\u000b\u001a\u00020!8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b+\u0010\u0013\u001a\u0004\b)\u0010$\"\u0004\b*\u0010&R\u001c\u0010,\u001a\u0004\u0018\u00010-X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b.\u0010/\"\u0004\b0\u00101R\u001c\u00102\u001a\u0004\u0018\u000103X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b4\u00105\"\u0004\b6\u00107R\u0014\u00108\u001a\u000209X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b:\u0010;R\u001a\u0010<\u001a\u00020=X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b>\u0010?\"\u0004\b@\u0010AR\u000e\u0010B\u001a\u00020CX\u0082\u000e¢\u0006\u0002\n\u0000R&\u0010D\u001a\u000e\u0012\u0004\u0012\u00020C\u0012\u0004\u0012\u00020F0EX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bG\u0010H\"\u0004\bI\u0010JR\u000e\u0010K\u001a\u00020\u0015X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010L\u001a\u0004\u0018\u00010MX\u0082\u000e¢\u0006\u0002\n\u0000R\u001c\u0010N\u001a\u0004\u0018\u00010OX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bP\u0010Q\"\u0004\bR\u0010SR\u001c\u0010T\u001a\u0004\u0018\u00010UX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bV\u0010W\"\u0004\bX\u0010YR\u0014\u0010Z\u001a\u00020[X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\\\u0010]R\u0016\u0010^\u001a\u0004\u0018\u00010_8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b`\u0010aR\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\bb\u0010cR+\u0010d\u001a\u00020C2\u0006\u0010\u000b\u001a\u00020C8@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\bi\u0010\u0013\u001a\u0004\be\u0010f\"\u0004\bg\u0010hR\u001a\u0010j\u001a\u00020kX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bl\u0010m\"\u0004\bn\u0010o\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006³\u0001"}, d2 = {"Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;", "", "undoManager", "Landroidx/compose/foundation/text/UndoManager;", "(Landroidx/compose/foundation/text/UndoManager;)V", "clipboardManager", "Landroidx/compose/ui/platform/ClipboardManager;", "getClipboardManager$foundation_release", "()Landroidx/compose/ui/platform/ClipboardManager;", "setClipboardManager$foundation_release", "(Landroidx/compose/ui/platform/ClipboardManager;)V", "<set-?>", "Landroidx/compose/ui/geometry/Offset;", "currentDragPosition", "getCurrentDragPosition-_m7T9-E", "()Landroidx/compose/ui/geometry/Offset;", "setCurrentDragPosition-_kEHs6E", "(Landroidx/compose/ui/geometry/Offset;)V", "currentDragPosition$delegate", "Landroidx/compose/runtime/MutableState;", "dragBeginOffsetInText", "", "Ljava/lang/Integer;", "dragBeginPosition", "J", "dragTotalDistance", "Landroidx/compose/foundation/text/Handle;", "draggingHandle", "getDraggingHandle", "()Landroidx/compose/foundation/text/Handle;", "setDraggingHandle", "(Landroidx/compose/foundation/text/Handle;)V", "draggingHandle$delegate", "", "editable", "getEditable", "()Z", "setEditable", "(Z)V", "editable$delegate", "enabled", "getEnabled", "setEnabled", "enabled$delegate", "focusRequester", "Landroidx/compose/ui/focus/FocusRequester;", "getFocusRequester", "()Landroidx/compose/ui/focus/FocusRequester;", "setFocusRequester", "(Landroidx/compose/ui/focus/FocusRequester;)V", "hapticFeedBack", "Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "getHapticFeedBack", "()Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "setHapticFeedBack", "(Landroidx/compose/ui/hapticfeedback/HapticFeedback;)V", "mouseSelectionObserver", "Landroidx/compose/foundation/text/selection/MouseSelectionObserver;", "getMouseSelectionObserver$foundation_release", "()Landroidx/compose/foundation/text/selection/MouseSelectionObserver;", "offsetMapping", "Landroidx/compose/ui/text/input/OffsetMapping;", "getOffsetMapping$foundation_release", "()Landroidx/compose/ui/text/input/OffsetMapping;", "setOffsetMapping$foundation_release", "(Landroidx/compose/ui/text/input/OffsetMapping;)V", "oldValue", "Landroidx/compose/ui/text/input/TextFieldValue;", "onValueChange", "Lkotlin/Function1;", "", "getOnValueChange$foundation_release", "()Lkotlin/jvm/functions/Function1;", "setOnValueChange$foundation_release", "(Lkotlin/jvm/functions/Function1;)V", "previousRawDragOffset", "previousSelectionLayout", "Landroidx/compose/foundation/text/selection/SelectionLayout;", "state", "Landroidx/compose/foundation/text/LegacyTextFieldState;", "getState$foundation_release", "()Landroidx/compose/foundation/text/LegacyTextFieldState;", "setState$foundation_release", "(Landroidx/compose/foundation/text/LegacyTextFieldState;)V", "textToolbar", "Landroidx/compose/ui/platform/TextToolbar;", "getTextToolbar", "()Landroidx/compose/ui/platform/TextToolbar;", "setTextToolbar", "(Landroidx/compose/ui/platform/TextToolbar;)V", "touchSelectionObserver", "Landroidx/compose/foundation/text/TextDragObserver;", "getTouchSelectionObserver$foundation_release", "()Landroidx/compose/foundation/text/TextDragObserver;", "transformedText", "Landroidx/compose/ui/text/AnnotatedString;", "getTransformedText$foundation_release", "()Landroidx/compose/ui/text/AnnotatedString;", "getUndoManager", "()Landroidx/compose/foundation/text/UndoManager;", "value", "getValue$foundation_release", "()Landroidx/compose/ui/text/input/TextFieldValue;", "setValue$foundation_release", "(Landroidx/compose/ui/text/input/TextFieldValue;)V", "value$delegate", "visualTransformation", "Landroidx/compose/ui/text/input/VisualTransformation;", "getVisualTransformation$foundation_release", "()Landroidx/compose/ui/text/input/VisualTransformation;", "setVisualTransformation$foundation_release", "(Landroidx/compose/ui/text/input/VisualTransformation;)V", "clearPreviewHighlight", "clearPreviewHighlight$foundation_release", "contextMenuOpenAdjustment", "position", "contextMenuOpenAdjustment-k-4lQ0M", "(J)V", "copy", "cancelSelection", "copy$foundation_release", "createTextFieldValue", "annotatedString", "selection", "Landroidx/compose/ui/text/TextRange;", "createTextFieldValue-FDrldGo", "(Landroidx/compose/ui/text/AnnotatedString;J)Landroidx/compose/ui/text/input/TextFieldValue;", "cursorDragObserver", "cursorDragObserver$foundation_release", "cut", "cut$foundation_release", "deselect", "deselect-_kEHs6E$foundation_release", "enterSelectionMode", "showFloatingToolbar", "enterSelectionMode$foundation_release", "exitSelectionMode", "exitSelectionMode$foundation_release", "getContentRect", "Landroidx/compose/ui/geometry/Rect;", "getCursorPosition", "density", "Landroidx/compose/ui/unit/Density;", "getCursorPosition-tuRUvjQ$foundation_release", "(Landroidx/compose/ui/unit/Density;)J", "getHandlePosition", "isStartHandle", "getHandlePosition-tuRUvjQ$foundation_release", "(Z)J", "handleDragObserver", "handleDragObserver$foundation_release", "hideSelectionToolbar", "hideSelectionToolbar$foundation_release", "isTextChanged", "isTextChanged$foundation_release", "paste", "paste$foundation_release", "selectAll", "selectAll$foundation_release", "setDeletionPreviewHighlight", "range", "setDeletionPreviewHighlight-5zc-tL8$foundation_release", "setHandleState", "handleState", "Landroidx/compose/foundation/text/HandleState;", "setSelectionPreviewHighlight", "setSelectionPreviewHighlight-5zc-tL8$foundation_release", "showSelectionToolbar", "showSelectionToolbar$foundation_release", "updateFloatingToolbar", "show", "updateSelection", "currentPosition", "isStartOfSelection", "adjustment", "Landroidx/compose/foundation/text/selection/SelectionAdjustment;", "isTouchBasedSelection", "updateSelection-8UEBfa8", "(Landroidx/compose/ui/text/input/TextFieldValue;JZZLandroidx/compose/foundation/text/selection/SelectionAdjustment;Z)J", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TextFieldSelectionManager {
    public static final int $stable = 8;
    private ClipboardManager clipboardManager;

    private final MutableState currentDragPosition;
    private Integer dragBeginOffsetInText;
    private long dragBeginPosition;
    private long dragTotalDistance;

    private final MutableState draggingHandle;

    private final MutableState editable;

    private final MutableState enabled;
    private FocusRequester focusRequester;
    private HapticFeedback hapticFeedBack;
    private final MouseSelectionObserver mouseSelectionObserver;
    private OffsetMapping offsetMapping;
    private TextFieldValue oldValue;
    private Function1<? super TextFieldValue, Unit> onValueChange;
    private int previousRawDragOffset;
    private SelectionLayout previousSelectionLayout;
    private LegacyTextFieldState state;
    private TextToolbar textToolbar;
    private final TextDragObserver touchSelectionObserver;
    private final UndoManager undoManager;

    private final MutableState value;
    private VisualTransformation visualTransformation;

    public TextFieldSelectionManager() {
        UndoManager undoManager = null;
        this(undoManager, 1, undoManager);
    }

    public TextFieldSelectionManager(UndoManager undoManager) {
        this.undoManager = undoManager;
        this.offsetMapping = ValidatingOffsetMappingKt.getValidatingEmptyOffsetMappingIdentity();
        this.onValueChange = new Function1<TextFieldValue, Unit>() {
            public final void invoke(TextFieldValue textFieldValue) {
            }

            public Object invoke(Object obj) {
                invoke((TextFieldValue) obj);
                return Unit.INSTANCE;
            }
        };
        this.value = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(new TextFieldValue((String) null, 0L, (TextRange) null, 7, (DefaultConstructorMarker) null), null, 2, null);
        this.visualTransformation = VisualTransformation.Companion.getNone();
        this.editable = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null);
        this.enabled = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null);
        this.dragBeginPosition = Offset.INSTANCE.m4362getZeroF1C5BW0();
        this.dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
        this.draggingHandle = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
        this.currentDragPosition = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
        this.previousRawDragOffset = -1;
        this.oldValue = new TextFieldValue((String) null, 0L, (TextRange) null, 7, (DefaultConstructorMarker) null);
        this.touchSelectionObserver = new TextDragObserver() {
            @Override
            public void mo1523onDownk4lQ0M(long point) {
            }

            @Override
            public void onUp() {
            }

            @Override
            public void mo1525onStartk4lQ0M(long startPoint) {
                TextLayoutResultProxy layoutResult;
                TextLayoutResultProxy layoutResult2;
                if (this.this$0.getEnabled() && this.this$0.getDraggingHandle() == null) {
                    this.this$0.setDraggingHandle(Handle.SelectionEnd);
                    this.this$0.previousRawDragOffset = -1;
                    this.this$0.hideSelectionToolbar$foundation_release();
                    LegacyTextFieldState state = this.this$0.getState();
                    if (state == null || (layoutResult2 = state.getLayoutResult()) == null || !layoutResult2.m1559isPositionOnTextk4lQ0M(startPoint)) {
                        LegacyTextFieldState state2 = this.this$0.getState();
                        if (state2 != null && (layoutResult = state2.getLayoutResult()) != null) {
                            TextFieldSelectionManager textFieldSelectionManager = this.this$0;
                            int iTransformedToOriginal = textFieldSelectionManager.getOffsetMapping().transformedToOriginal(TextLayoutResultProxy.m1557getOffsetForPosition3MmeM6k$default(layoutResult, startPoint, false, 2, null));
                            TextFieldValue textFieldValueM1933createTextFieldValueFDrldGo = textFieldSelectionManager.m1933createTextFieldValueFDrldGo(textFieldSelectionManager.getValue$foundation_release().getAnnotatedString(), TextRangeKt.TextRange(iTransformedToOriginal, iTransformedToOriginal));
                            textFieldSelectionManager.enterSelectionMode$foundation_release(false);
                            HapticFeedback hapticFeedBack = textFieldSelectionManager.getHapticFeedBack();
                            if (hapticFeedBack != null) {
                                hapticFeedBack.mo5360performHapticFeedbackCdsT49E(HapticFeedbackType.INSTANCE.m5369getTextHandleMove5zf0vsI());
                            }
                            textFieldSelectionManager.getOnValueChange$foundation_release().invoke(textFieldValueM1933createTextFieldValueFDrldGo);
                        }
                    } else {
                        if (this.this$0.getValue$foundation_release().getText().length() == 0) {
                            return;
                        }
                        this.this$0.enterSelectionMode$foundation_release(false);
                        TextFieldSelectionManager textFieldSelectionManager2 = this.this$0;
                        this.this$0.dragBeginOffsetInText = Integer.valueOf(TextRange.getStart-impl(textFieldSelectionManager2.m1936updateSelection8UEBfa8(TextFieldValue.copy-3r_uNRQ$default(textFieldSelectionManager2.getValue$foundation_release(), (AnnotatedString) null, TextRange.Companion.getZero-d9O1mEE(), (TextRange) null, 5, (Object) null), startPoint, true, false, SelectionAdjustment.INSTANCE.getWord(), true)));
                    }
                    this.this$0.setHandleState(HandleState.None);
                    this.this$0.dragBeginPosition = startPoint;
                    TextFieldSelectionManager textFieldSelectionManager3 = this.this$0;
                    textFieldSelectionManager3.m1935setCurrentDragPosition_kEHs6E(Offset.m4335boximpl(textFieldSelectionManager3.dragBeginPosition));
                    this.this$0.dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
                }
            }

            @Override
            public void mo1524onDragk4lQ0M(long delta) {
                TextLayoutResultProxy layoutResult;
                Integer num;
                int iM1558getOffsetForPosition3MmeM6k;
                long jM1936updateSelection8UEBfa8;
                SelectionAdjustment word;
                if (!this.this$0.getEnabled() || this.this$0.getValue$foundation_release().getText().length() == 0) {
                    return;
                }
                TextFieldSelectionManager textFieldSelectionManager = this.this$0;
                textFieldSelectionManager.dragTotalDistance = Offset.m4351plusMKHz9U(textFieldSelectionManager.dragTotalDistance, delta);
                LegacyTextFieldState state = this.this$0.getState();
                if (state != null && (layoutResult = state.getLayoutResult()) != null) {
                    TextFieldSelectionManager textFieldSelectionManager2 = this.this$0;
                    textFieldSelectionManager2.m1935setCurrentDragPosition_kEHs6E(Offset.m4335boximpl(Offset.m4351plusMKHz9U(textFieldSelectionManager2.dragBeginPosition, textFieldSelectionManager2.dragTotalDistance)));
                    if (textFieldSelectionManager2.dragBeginOffsetInText != null) {
                        num = textFieldSelectionManager2.dragBeginOffsetInText;
                        if (num != null) {
                            iM1558getOffsetForPosition3MmeM6k = num.intValue();
                        } else {
                            iM1558getOffsetForPosition3MmeM6k = layoutResult.m1558getOffsetForPosition3MmeM6k(textFieldSelectionManager2.dragBeginPosition, false);
                        }
                        Offset offsetM1939getCurrentDragPosition_m7T9E = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                        Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E);
                        int iM1558getOffsetForPosition3MmeM6k2 = layoutResult.m1558getOffsetForPosition3MmeM6k(offsetM1939getCurrentDragPosition_m7T9E.getPackedValue(), false);
                        if (textFieldSelectionManager2.dragBeginOffsetInText != null) {
                        }
                        TextFieldValue value$foundation_release = textFieldSelectionManager2.getValue$foundation_release();
                        Offset offsetM1939getCurrentDragPosition_m7T9E2 = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                        Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E2);
                        jM1936updateSelection8UEBfa8 = textFieldSelectionManager2.m1936updateSelection8UEBfa8(value$foundation_release, offsetM1939getCurrentDragPosition_m7T9E2.getPackedValue(), false, false, SelectionAdjustment.INSTANCE.getWord(), true);
                    } else {
                        Offset offsetM1939getCurrentDragPosition_m7T9E3 = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                        Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E3);
                        if (layoutResult.m1559isPositionOnTextk4lQ0M(offsetM1939getCurrentDragPosition_m7T9E3.getPackedValue())) {
                            num = textFieldSelectionManager2.dragBeginOffsetInText;
                            if (num != null) {
                                iM1558getOffsetForPosition3MmeM6k = num.intValue();
                            } else {
                                iM1558getOffsetForPosition3MmeM6k = layoutResult.m1558getOffsetForPosition3MmeM6k(textFieldSelectionManager2.dragBeginPosition, false);
                            }
                            Offset offsetM1939getCurrentDragPosition_m7T9E4 = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                            Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E4);
                            int iM1558getOffsetForPosition3MmeM6k3 = layoutResult.m1558getOffsetForPosition3MmeM6k(offsetM1939getCurrentDragPosition_m7T9E4.getPackedValue(), false);
                            if (textFieldSelectionManager2.dragBeginOffsetInText != null && iM1558getOffsetForPosition3MmeM6k == iM1558getOffsetForPosition3MmeM6k3) {
                                return;
                            }
                            TextFieldValue value$foundation_release2 = textFieldSelectionManager2.getValue$foundation_release();
                            Offset offsetM1939getCurrentDragPosition_m7T9E5 = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                            Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E5);
                            jM1936updateSelection8UEBfa8 = textFieldSelectionManager2.m1936updateSelection8UEBfa8(value$foundation_release2, offsetM1939getCurrentDragPosition_m7T9E5.getPackedValue(), false, false, SelectionAdjustment.INSTANCE.getWord(), true);
                        } else {
                            int iTransformedToOriginal = textFieldSelectionManager2.getOffsetMapping().transformedToOriginal(TextLayoutResultProxy.m1557getOffsetForPosition3MmeM6k$default(layoutResult, textFieldSelectionManager2.dragBeginPosition, false, 2, null));
                            OffsetMapping offsetMapping = textFieldSelectionManager2.getOffsetMapping();
                            Offset offsetM1939getCurrentDragPosition_m7T9E6 = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                            Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E6);
                            if (iTransformedToOriginal == offsetMapping.transformedToOriginal(TextLayoutResultProxy.m1557getOffsetForPosition3MmeM6k$default(layoutResult, offsetM1939getCurrentDragPosition_m7T9E6.getPackedValue(), false, 2, null))) {
                                word = SelectionAdjustment.INSTANCE.getNone();
                            } else {
                                word = SelectionAdjustment.INSTANCE.getWord();
                            }
                            TextFieldValue value$foundation_release3 = textFieldSelectionManager2.getValue$foundation_release();
                            Offset offsetM1939getCurrentDragPosition_m7T9E7 = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                            Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E7);
                            jM1936updateSelection8UEBfa8 = textFieldSelectionManager2.m1936updateSelection8UEBfa8(value$foundation_release3, offsetM1939getCurrentDragPosition_m7T9E7.getPackedValue(), false, false, word, true);
                        }
                    }
                    TextRange.box-impl(jM1936updateSelection8UEBfa8);
                }
                this.this$0.updateFloatingToolbar(false);
            }

            @Override
            public void onStop() {
                onEnd();
            }

            @Override
            public void onCancel() {
                onEnd();
            }

            private final void onEnd() {
                this.this$0.setDraggingHandle(null);
                this.this$0.m1935setCurrentDragPosition_kEHs6E(null);
                this.this$0.updateFloatingToolbar(true);
                this.this$0.dragBeginOffsetInText = null;
                boolean z = TextRange.getCollapsed-impl(this.this$0.getValue$foundation_release().getSelection-d9O1mEE());
                this.this$0.setHandleState(z ? HandleState.Cursor : HandleState.Selection);
                LegacyTextFieldState state = this.this$0.getState();
                if (state != null) {
                    state.setShowSelectionHandleStart(!z && TextFieldSelectionManagerKt.isSelectionHandleInVisibleBound(this.this$0, true));
                }
                LegacyTextFieldState state2 = this.this$0.getState();
                if (state2 != null) {
                    state2.setShowSelectionHandleEnd(!z && TextFieldSelectionManagerKt.isSelectionHandleInVisibleBound(this.this$0, false));
                }
                LegacyTextFieldState state3 = this.this$0.getState();
                if (state3 == null) {
                    return;
                }
                state3.setShowCursorHandle(z && TextFieldSelectionManagerKt.isSelectionHandleInVisibleBound(this.this$0, true));
            }
        };
        this.mouseSelectionObserver = new MouseSelectionObserver() {
            @Override
            public void onDragDone() {
            }

            @Override
            public boolean mo1768onExtendk4lQ0M(long downPosition) {
                LegacyTextFieldState state = this.this$0.getState();
                if (state == null || state.getLayoutResult() == null || !this.this$0.getEnabled()) {
                    return false;
                }
                this.this$0.previousRawDragOffset = -1;
                updateMouseSelection(this.this$0.getValue$foundation_release(), downPosition, false, SelectionAdjustment.INSTANCE.getNone());
                return true;
            }

            @Override
            public boolean mo1769onExtendDragk4lQ0M(long dragPosition) {
                LegacyTextFieldState state;
                if (!this.this$0.getEnabled() || this.this$0.getValue$foundation_release().getText().length() == 0 || (state = this.this$0.getState()) == null || state.getLayoutResult() == null) {
                    return false;
                }
                updateMouseSelection(this.this$0.getValue$foundation_release(), dragPosition, false, SelectionAdjustment.INSTANCE.getNone());
                return true;
            }

            @Override
            public boolean mo1770onStart3MmeM6k(long downPosition, SelectionAdjustment adjustment) {
                LegacyTextFieldState state;
                if (!this.this$0.getEnabled() || this.this$0.getValue$foundation_release().getText().length() == 0 || (state = this.this$0.getState()) == null || state.getLayoutResult() == null) {
                    return false;
                }
                FocusRequester focusRequester = this.this$0.getFocusRequester();
                if (focusRequester != null) {
                    focusRequester.requestFocus();
                }
                this.this$0.dragBeginPosition = downPosition;
                this.this$0.previousRawDragOffset = -1;
                TextFieldSelectionManager.enterSelectionMode$foundation_release$default(this.this$0, false, 1, null);
                updateMouseSelection(this.this$0.getValue$foundation_release(), this.this$0.dragBeginPosition, true, adjustment);
                return true;
            }

            @Override
            public boolean mo1767onDrag3MmeM6k(long dragPosition, SelectionAdjustment adjustment) {
                LegacyTextFieldState state;
                if (!this.this$0.getEnabled() || this.this$0.getValue$foundation_release().getText().length() == 0 || (state = this.this$0.getState()) == null || state.getLayoutResult() == null) {
                    return false;
                }
                updateMouseSelection(this.this$0.getValue$foundation_release(), dragPosition, false, adjustment);
                return true;
            }

            public final void updateMouseSelection(TextFieldValue value, long currentPosition, boolean isStartOfSelection, SelectionAdjustment adjustment) {
                this.this$0.setHandleState(TextRange.getCollapsed-impl(this.this$0.m1936updateSelection8UEBfa8(value, currentPosition, isStartOfSelection, false, adjustment, false)) ? HandleState.Cursor : HandleState.Selection);
            }
        };
    }

    public TextFieldSelectionManager(UndoManager undoManager, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : undoManager);
    }

    public final UndoManager getUndoManager() {
        return this.undoManager;
    }

    public final OffsetMapping getOffsetMapping() {
        return this.offsetMapping;
    }

    public final void setOffsetMapping$foundation_release(OffsetMapping offsetMapping) {
        this.offsetMapping = offsetMapping;
    }

    public final Function1<TextFieldValue, Unit> getOnValueChange$foundation_release() {
        return this.onValueChange;
    }

    public final void setOnValueChange$foundation_release(Function1<? super TextFieldValue, Unit> function1) {
        this.onValueChange = function1;
    }

    public final LegacyTextFieldState getState() {
        return this.state;
    }

    public final void setState$foundation_release(LegacyTextFieldState legacyTextFieldState) {
        this.state = legacyTextFieldState;
    }

    public final TextFieldValue getValue$foundation_release() {
        return (TextFieldValue) this.value.getValue();
    }

    public final void setValue$foundation_release(TextFieldValue textFieldValue) {
        this.value.setValue(textFieldValue);
    }

    public final AnnotatedString getTransformedText$foundation_release() {
        TextDelegate textDelegate;
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState == null || (textDelegate = legacyTextFieldState.getTextDelegate()) == null) {
            return null;
        }
        return textDelegate.getText();
    }

    public final VisualTransformation getVisualTransformation() {
        return this.visualTransformation;
    }

    public final void setVisualTransformation$foundation_release(VisualTransformation visualTransformation) {
        this.visualTransformation = visualTransformation;
    }

    public final ClipboardManager getClipboardManager() {
        return this.clipboardManager;
    }

    public final void setClipboardManager$foundation_release(ClipboardManager clipboardManager) {
        this.clipboardManager = clipboardManager;
    }

    public final TextToolbar getTextToolbar() {
        return this.textToolbar;
    }

    public final void setTextToolbar(TextToolbar textToolbar) {
        this.textToolbar = textToolbar;
    }

    public final HapticFeedback getHapticFeedBack() {
        return this.hapticFeedBack;
    }

    public final void setHapticFeedBack(HapticFeedback hapticFeedback) {
        this.hapticFeedBack = hapticFeedback;
    }

    public final FocusRequester getFocusRequester() {
        return this.focusRequester;
    }

    public final void setFocusRequester(FocusRequester focusRequester) {
        this.focusRequester = focusRequester;
    }

    public final boolean getEditable() {
        return ((Boolean) this.editable.getValue()).booleanValue();
    }

    public final void setEditable(boolean z) {
        this.editable.setValue(Boolean.valueOf(z));
    }

    public final boolean getEnabled() {
        return ((Boolean) this.enabled.getValue()).booleanValue();
    }

    public final void setEnabled(boolean z) {
        this.enabled.setValue(Boolean.valueOf(z));
    }

    public final void setDraggingHandle(Handle handle) {
        this.draggingHandle.setValue(handle);
    }

    public final Handle getDraggingHandle() {
        return (Handle) this.draggingHandle.getValue();
    }

    public final void m1935setCurrentDragPosition_kEHs6E(Offset offset) {
        this.currentDragPosition.setValue(offset);
    }

    public final Offset m1939getCurrentDragPosition_m7T9E() {
        return (Offset) this.currentDragPosition.getValue();
    }

    public final TextDragObserver getTouchSelectionObserver() {
        return this.touchSelectionObserver;
    }

    public final MouseSelectionObserver getMouseSelectionObserver() {
        return this.mouseSelectionObserver;
    }

    public final TextDragObserver handleDragObserver$foundation_release(final boolean isStartHandle) {
        return new TextDragObserver() {
            @Override
            public void onCancel() {
            }

            @Override
            public void mo1525onStartk4lQ0M(long startPoint) {
            }

            @Override
            public void mo1523onDownk4lQ0M(long point) {
                TextLayoutResultProxy layoutResult;
                this.this$0.setDraggingHandle(isStartHandle ? Handle.SelectionStart : Handle.SelectionEnd);
                long jM1875getAdjustedCoordinatesk4lQ0M = SelectionHandlesKt.m1875getAdjustedCoordinatesk4lQ0M(this.this$0.m1941getHandlePositiontuRUvjQ$foundation_release(isStartHandle));
                LegacyTextFieldState state = this.this$0.getState();
                if (state == null || (layoutResult = state.getLayoutResult()) == null) {
                    return;
                }
                long jM1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release = layoutResult.m1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release(jM1875getAdjustedCoordinatesk4lQ0M);
                this.this$0.dragBeginPosition = jM1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release;
                this.this$0.m1935setCurrentDragPosition_kEHs6E(Offset.m4335boximpl(jM1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release));
                this.this$0.dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
                this.this$0.previousRawDragOffset = -1;
                LegacyTextFieldState state2 = this.this$0.getState();
                if (state2 != null) {
                    state2.setInTouchMode(true);
                }
                this.this$0.updateFloatingToolbar(false);
            }

            @Override
            public void onUp() {
                this.this$0.setDraggingHandle(null);
                this.this$0.m1935setCurrentDragPosition_kEHs6E(null);
                this.this$0.updateFloatingToolbar(true);
            }

            @Override
            public void mo1524onDragk4lQ0M(long delta) {
                TextFieldSelectionManager textFieldSelectionManager = this.this$0;
                textFieldSelectionManager.dragTotalDistance = Offset.m4351plusMKHz9U(textFieldSelectionManager.dragTotalDistance, delta);
                TextFieldSelectionManager textFieldSelectionManager2 = this.this$0;
                textFieldSelectionManager2.m1935setCurrentDragPosition_kEHs6E(Offset.m4335boximpl(Offset.m4351plusMKHz9U(textFieldSelectionManager2.dragBeginPosition, this.this$0.dragTotalDistance)));
                TextFieldSelectionManager textFieldSelectionManager3 = this.this$0;
                TextFieldValue value$foundation_release = textFieldSelectionManager3.getValue$foundation_release();
                Offset offsetM1939getCurrentDragPosition_m7T9E = this.this$0.m1939getCurrentDragPosition_m7T9E();
                Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E);
                textFieldSelectionManager3.m1936updateSelection8UEBfa8(value$foundation_release, offsetM1939getCurrentDragPosition_m7T9E.getPackedValue(), false, isStartHandle, SelectionAdjustment.INSTANCE.getCharacterWithWordAccelerate(), true);
                this.this$0.updateFloatingToolbar(false);
            }

            @Override
            public void onStop() {
                this.this$0.setDraggingHandle(null);
                this.this$0.m1935setCurrentDragPosition_kEHs6E(null);
                this.this$0.updateFloatingToolbar(true);
            }
        };
    }

    public final TextDragObserver cursorDragObserver$foundation_release() {
        return new TextDragObserver() {
            @Override
            public void onCancel() {
            }

            @Override
            public void mo1523onDownk4lQ0M(long point) {
            }

            @Override
            public void onUp() {
                this.this$0.setDraggingHandle(null);
                this.this$0.m1935setCurrentDragPosition_kEHs6E(null);
            }

            @Override
            public void mo1525onStartk4lQ0M(long startPoint) {
                TextLayoutResultProxy layoutResult;
                long jM1875getAdjustedCoordinatesk4lQ0M = SelectionHandlesKt.m1875getAdjustedCoordinatesk4lQ0M(this.this$0.m1941getHandlePositiontuRUvjQ$foundation_release(true));
                LegacyTextFieldState state = this.this$0.getState();
                if (state == null || (layoutResult = state.getLayoutResult()) == null) {
                    return;
                }
                long jM1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release = layoutResult.m1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release(jM1875getAdjustedCoordinatesk4lQ0M);
                this.this$0.dragBeginPosition = jM1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release;
                this.this$0.m1935setCurrentDragPosition_kEHs6E(Offset.m4335boximpl(jM1561translateInnerToDecorationCoordinatesMKHz9U$foundation_release));
                this.this$0.dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
                this.this$0.setDraggingHandle(Handle.Cursor);
                this.this$0.updateFloatingToolbar(false);
            }

            @Override
            public void mo1524onDragk4lQ0M(long delta) {
                TextLayoutResultProxy layoutResult;
                HapticFeedback hapticFeedBack;
                TextFieldSelectionManager textFieldSelectionManager = this.this$0;
                textFieldSelectionManager.dragTotalDistance = Offset.m4351plusMKHz9U(textFieldSelectionManager.dragTotalDistance, delta);
                LegacyTextFieldState state = this.this$0.getState();
                if (state == null || (layoutResult = state.getLayoutResult()) == null) {
                    return;
                }
                TextFieldSelectionManager textFieldSelectionManager2 = this.this$0;
                textFieldSelectionManager2.m1935setCurrentDragPosition_kEHs6E(Offset.m4335boximpl(Offset.m4351plusMKHz9U(textFieldSelectionManager2.dragBeginPosition, textFieldSelectionManager2.dragTotalDistance)));
                OffsetMapping offsetMapping = textFieldSelectionManager2.getOffsetMapping();
                Offset offsetM1939getCurrentDragPosition_m7T9E = textFieldSelectionManager2.m1939getCurrentDragPosition_m7T9E();
                Intrinsics.checkNotNull(offsetM1939getCurrentDragPosition_m7T9E);
                int iTransformedToOriginal = offsetMapping.transformedToOriginal(TextLayoutResultProxy.m1557getOffsetForPosition3MmeM6k$default(layoutResult, offsetM1939getCurrentDragPosition_m7T9E.getPackedValue(), false, 2, null));
                long jTextRange = TextRangeKt.TextRange(iTransformedToOriginal, iTransformedToOriginal);
                if (TextRange.equals-impl0(jTextRange, textFieldSelectionManager2.getValue$foundation_release().getSelection-d9O1mEE())) {
                    return;
                }
                LegacyTextFieldState state2 = textFieldSelectionManager2.getState();
                if ((state2 == null || state2.isInTouchMode()) && (hapticFeedBack = textFieldSelectionManager2.getHapticFeedBack()) != null) {
                    hapticFeedBack.mo5360performHapticFeedbackCdsT49E(HapticFeedbackType.INSTANCE.m5369getTextHandleMove5zf0vsI());
                }
                textFieldSelectionManager2.getOnValueChange$foundation_release().invoke(textFieldSelectionManager2.m1933createTextFieldValueFDrldGo(textFieldSelectionManager2.getValue$foundation_release().getAnnotatedString(), jTextRange));
            }

            @Override
            public void onStop() {
                this.this$0.setDraggingHandle(null);
                this.this$0.m1935setCurrentDragPosition_kEHs6E(null);
            }
        };
    }

    public static void enterSelectionMode$foundation_release$default(TextFieldSelectionManager textFieldSelectionManager, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        textFieldSelectionManager.enterSelectionMode$foundation_release(z);
    }

    public final void enterSelectionMode$foundation_release(boolean showFloatingToolbar) {
        FocusRequester focusRequester;
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null && !legacyTextFieldState.getHasFocus() && (focusRequester = this.focusRequester) != null) {
            focusRequester.requestFocus();
        }
        this.oldValue = getValue$foundation_release();
        updateFloatingToolbar(showFloatingToolbar);
        setHandleState(HandleState.Selection);
    }

    public final void exitSelectionMode$foundation_release() {
        updateFloatingToolbar(false);
        setHandleState(HandleState.None);
    }

    public static void m1934deselect_kEHs6E$foundation_release$default(TextFieldSelectionManager textFieldSelectionManager, Offset offset, int i, Object obj) {
        if ((i & 1) != 0) {
            offset = null;
        }
        textFieldSelectionManager.m1938deselect_kEHs6E$foundation_release(offset);
    }

    public final void m1938deselect_kEHs6E$foundation_release(Offset position) {
        int iTransformedToOriginal;
        if (!TextRange.getCollapsed-impl(getValue$foundation_release().getSelection-d9O1mEE())) {
            LegacyTextFieldState legacyTextFieldState = this.state;
            TextLayoutResultProxy layoutResult = legacyTextFieldState != null ? legacyTextFieldState.getLayoutResult() : null;
            if (position != null && layoutResult != null) {
                iTransformedToOriginal = this.offsetMapping.transformedToOriginal(TextLayoutResultProxy.m1557getOffsetForPosition3MmeM6k$default(layoutResult, position.getPackedValue(), false, 2, null));
            } else {
                iTransformedToOriginal = TextRange.getMax-impl(getValue$foundation_release().getSelection-d9O1mEE());
            }
            this.onValueChange.invoke(TextFieldValue.copy-3r_uNRQ$default(getValue$foundation_release(), (AnnotatedString) null, TextRangeKt.TextRange(iTransformedToOriginal), (TextRange) null, 5, (Object) null));
        }
        setHandleState((position == null || getValue$foundation_release().getText().length() <= 0) ? HandleState.None : HandleState.Cursor);
        updateFloatingToolbar(false);
    }

    public final void m1943setSelectionPreviewHighlight5zctL8$foundation_release(long range) {
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null) {
            legacyTextFieldState.m1481setSelectionPreviewHighlightRange5zctL8(range);
        }
        LegacyTextFieldState legacyTextFieldState2 = this.state;
        if (legacyTextFieldState2 != null) {
            legacyTextFieldState2.m1478setDeletionPreviewHighlightRange5zctL8(TextRange.Companion.getZero-d9O1mEE());
        }
        if (TextRange.getCollapsed-impl(range)) {
            return;
        }
        exitSelectionMode$foundation_release();
    }

    public final void m1942setDeletionPreviewHighlight5zctL8$foundation_release(long range) {
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null) {
            legacyTextFieldState.m1478setDeletionPreviewHighlightRange5zctL8(range);
        }
        LegacyTextFieldState legacyTextFieldState2 = this.state;
        if (legacyTextFieldState2 != null) {
            legacyTextFieldState2.m1481setSelectionPreviewHighlightRange5zctL8(TextRange.Companion.getZero-d9O1mEE());
        }
        if (TextRange.getCollapsed-impl(range)) {
            return;
        }
        exitSelectionMode$foundation_release();
    }

    public final void clearPreviewHighlight$foundation_release() {
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null) {
            legacyTextFieldState.m1478setDeletionPreviewHighlightRange5zctL8(TextRange.Companion.getZero-d9O1mEE());
        }
        LegacyTextFieldState legacyTextFieldState2 = this.state;
        if (legacyTextFieldState2 == null) {
            return;
        }
        legacyTextFieldState2.m1481setSelectionPreviewHighlightRange5zctL8(TextRange.Companion.getZero-d9O1mEE());
    }

    public static void copy$foundation_release$default(TextFieldSelectionManager textFieldSelectionManager, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        textFieldSelectionManager.copy$foundation_release(z);
    }

    public final void copy$foundation_release(boolean cancelSelection) {
        if (TextRange.getCollapsed-impl(getValue$foundation_release().getSelection-d9O1mEE())) {
            return;
        }
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager != null) {
            clipboardManager.setText(TextFieldValueKt.getSelectedText(getValue$foundation_release()));
        }
        if (cancelSelection) {
            int i = TextRange.getMax-impl(getValue$foundation_release().getSelection-d9O1mEE());
            this.onValueChange.invoke(m1933createTextFieldValueFDrldGo(getValue$foundation_release().getAnnotatedString(), TextRangeKt.TextRange(i, i)));
            setHandleState(HandleState.None);
        }
    }

    public final void paste$foundation_release() {
        AnnotatedString text;
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager == null || (text = clipboardManager.getText()) == null) {
            return;
        }
        AnnotatedString annotatedStringPlus = TextFieldValueKt.getTextBeforeSelection(getValue$foundation_release(), getValue$foundation_release().getText().length()).plus(text).plus(TextFieldValueKt.getTextAfterSelection(getValue$foundation_release(), getValue$foundation_release().getText().length()));
        int i = TextRange.getMin-impl(getValue$foundation_release().getSelection-d9O1mEE()) + text.length();
        this.onValueChange.invoke(m1933createTextFieldValueFDrldGo(annotatedStringPlus, TextRangeKt.TextRange(i, i)));
        setHandleState(HandleState.None);
        UndoManager undoManager = this.undoManager;
        if (undoManager != null) {
            undoManager.forceNextSnapshot();
        }
    }

    public final void cut$foundation_release() {
        if (TextRange.getCollapsed-impl(getValue$foundation_release().getSelection-d9O1mEE())) {
            return;
        }
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager != null) {
            clipboardManager.setText(TextFieldValueKt.getSelectedText(getValue$foundation_release()));
        }
        AnnotatedString annotatedStringPlus = TextFieldValueKt.getTextBeforeSelection(getValue$foundation_release(), getValue$foundation_release().getText().length()).plus(TextFieldValueKt.getTextAfterSelection(getValue$foundation_release(), getValue$foundation_release().getText().length()));
        int i = TextRange.getMin-impl(getValue$foundation_release().getSelection-d9O1mEE());
        this.onValueChange.invoke(m1933createTextFieldValueFDrldGo(annotatedStringPlus, TextRangeKt.TextRange(i, i)));
        setHandleState(HandleState.None);
        UndoManager undoManager = this.undoManager;
        if (undoManager != null) {
            undoManager.forceNextSnapshot();
        }
    }

    public final void selectAll$foundation_release() {
        TextFieldValue textFieldValueM1933createTextFieldValueFDrldGo = m1933createTextFieldValueFDrldGo(getValue$foundation_release().getAnnotatedString(), TextRangeKt.TextRange(0, getValue$foundation_release().getText().length()));
        this.onValueChange.invoke(textFieldValueM1933createTextFieldValueFDrldGo);
        this.oldValue = TextFieldValue.copy-3r_uNRQ$default(this.oldValue, (AnnotatedString) null, textFieldValueM1933createTextFieldValueFDrldGo.getSelection-d9O1mEE(), (TextRange) null, 5, (Object) null);
        enterSelectionMode$foundation_release(true);
    }

    public final long m1941getHandlePositiontuRUvjQ$foundation_release(boolean isStartHandle) {
        TextLayoutResultProxy layoutResult;
        TextLayoutResult value;
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState == null || (layoutResult = legacyTextFieldState.getLayoutResult()) == null || (value = layoutResult.getValue()) == null) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        AnnotatedString transformedText$foundation_release = getTransformedText$foundation_release();
        if (transformedText$foundation_release == null) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        if (!Intrinsics.areEqual(transformedText$foundation_release.getText(), value.getLayoutInput().getText().getText())) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        long j = getValue$foundation_release().getSelection-d9O1mEE();
        return TextSelectionDelegateKt.getSelectionHandleCoordinates(value, this.offsetMapping.originalToTransformed(isStartHandle ? TextRange.getStart-impl(j) : TextRange.getEnd-impl(j)), isStartHandle, TextRange.getReversed-impl(getValue$foundation_release().getSelection-d9O1mEE()));
    }

    public final long m1940getCursorPositiontuRUvjQ$foundation_release(Density density) {
        int iOriginalToTransformed = this.offsetMapping.originalToTransformed(TextRange.getStart-impl(getValue$foundation_release().getSelection-d9O1mEE()));
        LegacyTextFieldState legacyTextFieldState = this.state;
        TextLayoutResultProxy layoutResult = legacyTextFieldState != null ? legacyTextFieldState.getLayoutResult() : null;
        Intrinsics.checkNotNull(layoutResult);
        TextLayoutResult value = layoutResult.getValue();
        Rect cursorRect = value.getCursorRect(RangesKt.coerceIn(iOriginalToTransformed, 0, value.getLayoutInput().getText().length()));
        return OffsetKt.Offset(cursorRect.getLeft() + (density.toPx-0680j_4(TextFieldCursorKt.getDefaultCursorThickness()) / 2), cursorRect.getBottom());
    }

    public final void updateFloatingToolbar(boolean show) {
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null) {
            legacyTextFieldState.setShowFloatingToolbar(show);
        }
        if (show) {
            showSelectionToolbar$foundation_release();
        } else {
            hideSelectionToolbar$foundation_release();
        }
    }

    public final void showSelectionToolbar$foundation_release() {
        ClipboardManager clipboardManager;
        if (getEnabled()) {
            LegacyTextFieldState legacyTextFieldState = this.state;
            if (legacyTextFieldState == null || legacyTextFieldState.isInTouchMode()) {
                boolean z = this.visualTransformation instanceof PasswordVisualTransformation;
                Function0<Unit> function0 = (TextRange.getCollapsed-impl(getValue$foundation_release().getSelection-d9O1mEE()) || z) ? null : new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1944invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1944invoke() {
                        TextFieldSelectionManager.copy$foundation_release$default(this.this$0, false, 1, null);
                        this.this$0.hideSelectionToolbar$foundation_release();
                    }
                };
                Function0<Unit> function1 = (TextRange.getCollapsed-impl(getValue$foundation_release().getSelection-d9O1mEE()) || !getEditable() || z) ? null : new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1945invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1945invoke() {
                        this.this$0.cut$foundation_release();
                        this.this$0.hideSelectionToolbar$foundation_release();
                    }
                };
                Function0<Unit> function2 = (getEditable() && (clipboardManager = this.clipboardManager) != null && clipboardManager.hasText()) ? new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1946invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1946invoke() {
                        this.this$0.paste$foundation_release();
                        this.this$0.hideSelectionToolbar$foundation_release();
                    }
                } : null;
                Function0<Unit> function3 = TextRange.getLength-impl(getValue$foundation_release().getSelection-d9O1mEE()) != getValue$foundation_release().getText().length() ? new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m1947invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m1947invoke() {
                        this.this$0.selectAll$foundation_release();
                    }
                } : null;
                TextToolbar textToolbar = this.textToolbar;
                if (textToolbar != null) {
                    textToolbar.showMenu(getContentRect(), function0, function2, function1, function3);
                }
            }
        }
    }

    public final void hideSelectionToolbar$foundation_release() {
        TextToolbar textToolbar;
        TextToolbar textToolbar2 = this.textToolbar;
        if ((textToolbar2 != null ? textToolbar2.getStatus() : null) != TextToolbarStatus.Shown || (textToolbar = this.textToolbar) == null) {
            return;
        }
        textToolbar.hide();
    }

    public final void m1937contextMenuOpenAdjustmentk4lQ0M(long position) {
        TextLayoutResultProxy layoutResult;
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState == null || (layoutResult = legacyTextFieldState.getLayoutResult()) == null) {
            return;
        }
        if (TextRange.contains-impl(getValue$foundation_release().getSelection-d9O1mEE(), TextLayoutResultProxy.m1557getOffsetForPosition3MmeM6k$default(layoutResult, position, false, 2, null))) {
            return;
        }
        this.previousRawDragOffset = -1;
        m1936updateSelection8UEBfa8(getValue$foundation_release(), position, true, false, SelectionAdjustment.INSTANCE.getWord(), false);
    }

    public final boolean isTextChanged$foundation_release() {
        return !Intrinsics.areEqual(this.oldValue.getText(), getValue$foundation_release().getText());
    }

    private final Rect getContentRect() {
        float fM4347getYimpl;
        LayoutCoordinates layoutCoordinates;
        TextLayoutResult value;
        Rect cursorRect;
        LayoutCoordinates layoutCoordinates2;
        TextLayoutResult value2;
        Rect cursorRect2;
        LayoutCoordinates layoutCoordinates3;
        LayoutCoordinates layoutCoordinates4;
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null) {
            if (legacyTextFieldState.getIsLayoutResultStale()) {
                legacyTextFieldState = null;
            }
            if (legacyTextFieldState != null) {
                int iOriginalToTransformed = this.offsetMapping.originalToTransformed(TextRange.getStart-impl(getValue$foundation_release().getSelection-d9O1mEE()));
                int iOriginalToTransformed2 = this.offsetMapping.originalToTransformed(TextRange.getEnd-impl(getValue$foundation_release().getSelection-d9O1mEE()));
                LegacyTextFieldState legacyTextFieldState2 = this.state;
                long jM4362getZeroF1C5BW0 = (legacyTextFieldState2 == null || (layoutCoordinates4 = legacyTextFieldState2.getLayoutCoordinates()) == null) ? Offset.INSTANCE.m4362getZeroF1C5BW0() : layoutCoordinates4.mo6043localToRootMKHz9U(m1941getHandlePositiontuRUvjQ$foundation_release(true));
                LegacyTextFieldState legacyTextFieldState3 = this.state;
                long jM4362getZeroF1C5BW1 = (legacyTextFieldState3 == null || (layoutCoordinates3 = legacyTextFieldState3.getLayoutCoordinates()) == null) ? Offset.INSTANCE.m4362getZeroF1C5BW0() : layoutCoordinates3.mo6043localToRootMKHz9U(m1941getHandlePositiontuRUvjQ$foundation_release(false));
                LegacyTextFieldState legacyTextFieldState4 = this.state;
                float fM4347getYimpl2 = 0.0f;
                if (legacyTextFieldState4 == null || (layoutCoordinates2 = legacyTextFieldState4.getLayoutCoordinates()) == null) {
                    fM4347getYimpl = 0.0f;
                } else {
                    TextLayoutResultProxy layoutResult = legacyTextFieldState.getLayoutResult();
                    fM4347getYimpl = Offset.m4347getYimpl(layoutCoordinates2.mo6043localToRootMKHz9U(OffsetKt.Offset(0.0f, (layoutResult == null || (value2 = layoutResult.getValue()) == null || (cursorRect2 = value2.getCursorRect(iOriginalToTransformed)) == null) ? 0.0f : cursorRect2.getTop())));
                }
                LegacyTextFieldState legacyTextFieldState5 = this.state;
                if (legacyTextFieldState5 != null && (layoutCoordinates = legacyTextFieldState5.getLayoutCoordinates()) != null) {
                    TextLayoutResultProxy layoutResult2 = legacyTextFieldState.getLayoutResult();
                    fM4347getYimpl2 = Offset.m4347getYimpl(layoutCoordinates.mo6043localToRootMKHz9U(OffsetKt.Offset(0.0f, (layoutResult2 == null || (value = layoutResult2.getValue()) == null || (cursorRect = value.getCursorRect(iOriginalToTransformed2)) == null) ? 0.0f : cursorRect.getTop())));
                }
                return new Rect(Math.min(Offset.m4346getXimpl(jM4362getZeroF1C5BW0), Offset.m4346getXimpl(jM4362getZeroF1C5BW1)), Math.min(fM4347getYimpl, fM4347getYimpl2), Math.max(Offset.m4346getXimpl(jM4362getZeroF1C5BW0), Offset.m4346getXimpl(jM4362getZeroF1C5BW1)), Math.max(Offset.m4347getYimpl(jM4362getZeroF1C5BW0), Offset.m4347getYimpl(jM4362getZeroF1C5BW1)) + (Dp.constructor-impl(25) * legacyTextFieldState.getTextDelegate().getDensity().getDensity()));
            }
        }
        return Rect.INSTANCE.getZero();
    }

    public final long m1936updateSelection8UEBfa8(TextFieldValue value, long currentPosition, boolean isStartOfSelection, boolean isStartHandle, SelectionAdjustment adjustment, boolean isTouchBasedSelection) {
        TextLayoutResultProxy layoutResult;
        int i;
        HapticFeedback hapticFeedback;
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState == null || (layoutResult = legacyTextFieldState.getLayoutResult()) == null) {
            return TextRange.Companion.getZero-d9O1mEE();
        }
        long jTextRange = TextRangeKt.TextRange(this.offsetMapping.originalToTransformed(TextRange.getStart-impl(value.getSelection-d9O1mEE())), this.offsetMapping.originalToTransformed(TextRange.getEnd-impl(value.getSelection-d9O1mEE())));
        boolean z = false;
        int iM1558getOffsetForPosition3MmeM6k = layoutResult.m1558getOffsetForPosition3MmeM6k(currentPosition, false);
        int i2 = (isStartHandle || isStartOfSelection) ? iM1558getOffsetForPosition3MmeM6k : TextRange.getStart-impl(jTextRange);
        int i3 = (!isStartHandle || isStartOfSelection) ? iM1558getOffsetForPosition3MmeM6k : TextRange.getEnd-impl(jTextRange);
        SelectionLayout selectionLayout = this.previousSelectionLayout;
        if (isStartOfSelection || selectionLayout == null || (i = this.previousRawDragOffset) == -1) {
            i = -1;
        }
        SelectionLayout selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA = SelectionLayoutKt.m1878getTextFieldSelectionLayoutRcvTLA(layoutResult.getValue(), i2, i3, i, jTextRange, isStartOfSelection, isStartHandle);
        if (!selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA.shouldRecomputeSelection(selectionLayout)) {
            return value.getSelection-d9O1mEE();
        }
        this.previousSelectionLayout = selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA;
        this.previousRawDragOffset = iM1558getOffsetForPosition3MmeM6k;
        Selection selectionAdjust = adjustment.adjust(selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA);
        long jTextRange2 = TextRangeKt.TextRange(this.offsetMapping.transformedToOriginal(selectionAdjust.getStart().getOffset()), this.offsetMapping.transformedToOriginal(selectionAdjust.getEnd().getOffset()));
        if (TextRange.equals-impl0(jTextRange2, value.getSelection-d9O1mEE())) {
            return value.getSelection-d9O1mEE();
        }
        boolean z2 = TextRange.getReversed-impl(jTextRange2) != TextRange.getReversed-impl(value.getSelection-d9O1mEE()) && TextRange.equals-impl0(TextRangeKt.TextRange(TextRange.getEnd-impl(jTextRange2), TextRange.getStart-impl(jTextRange2)), value.getSelection-d9O1mEE());
        boolean z3 = TextRange.getCollapsed-impl(jTextRange2) && TextRange.getCollapsed-impl(value.getSelection-d9O1mEE());
        if (isTouchBasedSelection && value.getText().length() > 0 && !z2 && !z3 && (hapticFeedback = this.hapticFeedBack) != null) {
            hapticFeedback.mo5360performHapticFeedbackCdsT49E(HapticFeedbackType.INSTANCE.m5369getTextHandleMove5zf0vsI());
        }
        this.onValueChange.invoke(m1933createTextFieldValueFDrldGo(value.getAnnotatedString(), jTextRange2));
        if (!isTouchBasedSelection) {
            updateFloatingToolbar(!TextRange.getCollapsed-impl(jTextRange2));
        }
        LegacyTextFieldState legacyTextFieldState2 = this.state;
        if (legacyTextFieldState2 != null) {
            legacyTextFieldState2.setInTouchMode(isTouchBasedSelection);
        }
        LegacyTextFieldState legacyTextFieldState3 = this.state;
        if (legacyTextFieldState3 != null) {
            legacyTextFieldState3.setShowSelectionHandleStart(!TextRange.getCollapsed-impl(jTextRange2) && TextFieldSelectionManagerKt.isSelectionHandleInVisibleBound(this, true));
        }
        LegacyTextFieldState legacyTextFieldState4 = this.state;
        if (legacyTextFieldState4 != null) {
            legacyTextFieldState4.setShowSelectionHandleEnd(!TextRange.getCollapsed-impl(jTextRange2) && TextFieldSelectionManagerKt.isSelectionHandleInVisibleBound(this, false));
        }
        LegacyTextFieldState legacyTextFieldState5 = this.state;
        if (legacyTextFieldState5 != null) {
            if (TextRange.getCollapsed-impl(jTextRange2) && TextFieldSelectionManagerKt.isSelectionHandleInVisibleBound(this, true)) {
                z = true;
            }
            legacyTextFieldState5.setShowCursorHandle(z);
        }
        return jTextRange2;
    }

    public final void setHandleState(HandleState handleState) {
        LegacyTextFieldState legacyTextFieldState = this.state;
        if (legacyTextFieldState != null) {
            if (legacyTextFieldState.getHandleState() == handleState) {
                legacyTextFieldState = null;
            }
            if (legacyTextFieldState != null) {
                legacyTextFieldState.setHandleState(handleState);
            }
        }
    }

    public final TextFieldValue m1933createTextFieldValueFDrldGo(AnnotatedString annotatedString, long selection) {
        return new TextFieldValue(annotatedString, selection, (TextRange) null, 4, (DefaultConstructorMarker) null);
    }
}
