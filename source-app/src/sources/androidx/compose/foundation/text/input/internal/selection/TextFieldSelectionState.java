package androidx.compose.foundation.text.input.internal.selection;

import androidx.compose.foundation.content.TransferableContent;
import androidx.compose.foundation.content.TransferableContent_androidKt;
import androidx.compose.foundation.content.internal.ReceiveContentConfiguration;
import androidx.compose.foundation.gestures.DragGestureDetectorKt;
import androidx.compose.foundation.gestures.PressGestureScope;
import androidx.compose.foundation.gestures.TapGestureDetectorKt;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.interaction.PressInteraction;
import androidx.compose.foundation.text.Handle;
import androidx.compose.foundation.text.TextDragObserver;
import androidx.compose.foundation.text.TextFieldCursorKt;
import androidx.compose.foundation.text.input.TextFieldCharSequence;
import androidx.compose.foundation.text.input.TextFieldCharSequenceKt;
import androidx.compose.foundation.text.input.internal.IndexTransformationType;
import androidx.compose.foundation.text.input.internal.MathUtilsKt;
import androidx.compose.foundation.text.input.internal.SelectionWedgeAffinity;
import androidx.compose.foundation.text.input.internal.TextLayoutState;
import androidx.compose.foundation.text.input.internal.TextLayoutStateKt;
import androidx.compose.foundation.text.input.internal.TransformedTextFieldState;
import androidx.compose.foundation.text.input.internal.WedgeAffinity;
import androidx.compose.foundation.text.input.internal.undo.TextFieldEditUndoBehavior;
import androidx.compose.foundation.text.selection.MouseSelectionObserver;
import androidx.compose.foundation.text.selection.SelectionAdjustment;
import androidx.compose.foundation.text.selection.SelectionGesturesKt;
import androidx.compose.foundation.text.selection.SelectionHandlesKt;
import androidx.compose.foundation.text.selection.SelectionLayout;
import androidx.compose.foundation.text.selection.SelectionLayoutKt;
import androidx.compose.foundation.text.selection.SelectionManagerKt;
import androidx.compose.foundation.text.selection.TextSelectionDelegateKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.RectKt;
import androidx.compose.p002ui.hapticfeedback.HapticFeedback;
import androidx.compose.p002ui.hapticfeedback.HapticFeedbackType;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.LayoutCoordinatesKt;
import androidx.compose.p002ui.platform.ClipEntry;
import androidx.compose.p002ui.platform.ClipboardManager;
import androidx.compose.p002ui.platform.TextToolbar;
import androidx.compose.p002ui.platform.TextToolbarStatus;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.snapshots.Snapshot;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import androidx.compose.ui.text.style.ResolvedTextDirection;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.FunctionReferenceImpl;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.FlowKt;

@Metadata(d1 = {"\u0000¼\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u001d\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0000\u0018\u00002\u00020\u0001:\u0006«\u0001¬\u0001\u00ad\u0001B=\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\t\u0012\u0006\u0010\u000b\u001a\u00020\t\u0012\u0006\u0010\f\u001a\u00020\t¢\u0006\u0002\u0010\rJ\u0006\u0010W\u001a\u00020\tJ\u0006\u0010X\u001a\u00020\tJ\u0006\u0010Y\u001a\u00020\tJ\u0006\u0010Z\u001a\u00020\tJ\u0006\u0010[\u001a\u00020\\J\u0010\u0010]\u001a\u00020\\2\b\b\u0002\u0010^\u001a\u00020\tJ\u0006\u0010_\u001a\u00020\\J\u0006\u0010`\u001a\u00020\\J\u0006\u0010a\u001a\u00020\\J\b\u0010b\u001a\u00020cH\u0002J\u0015\u0010d\u001a\u00020e2\u0006\u0010f\u001a\u00020\tH\u0000¢\u0006\u0002\bgJ\u0006\u0010h\u001a\u00020cJ\u001d\u0010i\u001a\u00020\u00112\u0006\u0010j\u001a\u00020\tH\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bk\u0010lJ\u001d\u0010m\u001a\u00020e2\u0006\u0010j\u001a\u00020\t2\u0006\u0010f\u001a\u00020\tH\u0000¢\u0006\u0002\bnJ<\u0010o\u001a\u00020p2\u0006\u0010q\u001a\u0002032\u0006\u0010r\u001a\u0002032\b\u0010s\u001a\u0004\u0018\u00010p2\u0006\u0010j\u001a\u00020\t2\u0006\u0010t\u001a\u00020uH\u0002ø\u0001\u0000¢\u0006\u0004\bv\u0010wJ\b\u0010x\u001a\u00020\\H\u0002J\b\u0010y\u001a\u00020\tH\u0002J\b\u0010z\u001a\u00020\\H\u0002J1\u0010{\u001a\n\u0012\u0004\u0012\u00020\\\u0018\u00010<2\u0006\u0010\b\u001a\u00020\t2\u0006\u0010|\u001a\u00020P2\u000e\b\u0004\u0010}\u001a\b\u0012\u0004\u0012\u00020\\0<H\u0082\bJ\u000e\u0010~\u001a\u00020\\H\u0086@¢\u0006\u0002\u0010\u007fJ\u000f\u0010\u0080\u0001\u001a\u00020\\H\u0082@¢\u0006\u0002\u0010\u007fJ\u000f\u0010\u0081\u0001\u001a\u00020\\H\u0082@¢\u0006\u0002\u0010\u007fJ\u0007\u0010\u0082\u0001\u001a\u00020\\J\t\u0010\u0083\u0001\u001a\u00020\\H\u0002J\u001e\u0010\u0084\u0001\u001a\u00020\t2\u0007\u0010\u0085\u0001\u001a\u00020\u0011H\u0002ø\u0001\u0000¢\u0006\u0006\b\u0086\u0001\u0010\u0087\u0001J\u0007\u0010\u0088\u0001\u001a\u00020\\J\u0012\u0010\u0089\u0001\u001a\u00020\\2\u0007\u0010\u008a\u0001\u001a\u00020cH\u0002J?\u0010\u008b\u0001\u001a\u00020\\2\u0006\u0010)\u001a\u00020*2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010N\u001a\u00020O2\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\t2\u0006\u0010\f\u001a\u00020\tJ%\u0010\u008c\u0001\u001a\u00020\\2\u0007\u0010\u008d\u0001\u001a\u00020\u001d2\u0007\u0010\u008e\u0001\u001a\u00020\u0011ø\u0001\u0000¢\u0006\u0006\b\u008f\u0001\u0010\u0090\u0001JZ\u0010\u0091\u0001\u001a\u00020p2\b\u0010\u0092\u0001\u001a\u00030\u0093\u00012\u0007\u0010\u0094\u0001\u001a\u0002032\u0007\u0010\u0095\u0001\u001a\u0002032\u0006\u0010j\u001a\u00020\t2\u0006\u0010t\u001a\u00020u2\t\b\u0002\u0010\u0096\u0001\u001a\u00020\t2\t\b\u0002\u0010\u0097\u0001\u001a\u00020\tH\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0006\b\u0098\u0001\u0010\u0099\u0001J\u000f\u0010\u009a\u0001\u001a\u00020\\2\u0006\u0010Q\u001a\u00020PJ\u0015\u0010\u009b\u0001\u001a\u00020\\*\u00030\u009c\u0001H\u0086@¢\u0006\u0003\u0010\u009d\u0001J\u0015\u0010\u009e\u0001\u001a\u00020\\*\u00030\u009c\u0001H\u0082@¢\u0006\u0003\u0010\u009d\u0001J\u001d\u0010\u009f\u0001\u001a\u00020\\*\u00030\u009c\u00012\u0006\u0010j\u001a\u00020\tH\u0082@¢\u0006\u0003\u0010 \u0001J?\u0010¡\u0001\u001a\u00020\\*\u00030\u009c\u00012\n\u0010¢\u0001\u001a\u0005\u0018\u00010£\u00012\r\u0010¤\u0001\u001a\b\u0012\u0004\u0012\u00020\\0<2\r\u0010¥\u0001\u001a\b\u0012\u0004\u0012\u00020\\0<H\u0086@¢\u0006\u0003\u0010¦\u0001J\u0015\u0010§\u0001\u001a\u00020\\*\u00030\u009c\u0001H\u0086@¢\u0006\u0003\u0010\u009d\u0001J\u001d\u0010¨\u0001\u001a\u00020\\*\u00030\u009c\u00012\u0006\u0010j\u001a\u00020\tH\u0086@¢\u0006\u0003\u0010 \u0001J$\u0010©\u0001\u001a\u00020\\*\u00030\u009c\u00012\r\u0010¤\u0001\u001a\b\u0012\u0004\u0012\u00020\\0<H\u0086@¢\u0006\u0003\u0010ª\u0001R\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0010\u001a\u00020\u00118BX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R+\u0010\u0016\u001a\u00020\u00152\u0006\u0010\u0014\u001a\u00020\u00158F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u001b\u0010\u001c\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR/\u0010\u001e\u001a\u0004\u0018\u00010\u001d2\b\u0010\u0014\u001a\u0004\u0018\u00010\u001d8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b#\u0010\u001c\u001a\u0004\b\u001f\u0010 \"\u0004\b!\u0010\"R\u0014\u0010$\u001a\u00020\t8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b%\u0010&R\u000e\u0010\b\u001a\u00020\tX\u0082\u000e¢\u0006\u0002\n\u0000R\u0017\u0010'\u001a\u00020\u00118Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b(\u0010\u0013R\u0010\u0010)\u001a\u0004\u0018\u00010*X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u000b\u001a\u00020\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010&\"\u0004\b+\u0010,R+\u0010-\u001a\u00020\t2\u0006\u0010\u0014\u001a\u00020\t8F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b/\u0010\u001c\u001a\u0004\b-\u0010&\"\u0004\b.\u0010,R\u000e\u0010\f\u001a\u00020\tX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u00100\u001a\u0004\u0018\u000101X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u00102\u001a\u000203X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u00104\u001a\u0004\u0018\u000105X\u0082\u000e¢\u0006\u0002\n\u0000R1\u00106\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u00118B@BX\u0082\u008e\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0012\n\u0004\b:\u0010\u001c\u001a\u0004\b7\u0010\u0013\"\u0004\b8\u00109R\u000e\u0010\n\u001a\u00020\tX\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010;\u001a\f\u0012\u0006\u0012\u0004\u0018\u00010=\u0018\u00010<X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b>\u0010?\"\u0004\b@\u0010AR+\u0010B\u001a\u00020\t2\u0006\u0010\u0014\u001a\u00020\t8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\bE\u0010\u001c\u001a\u0004\bC\u0010&\"\u0004\bD\u0010,R1\u0010F\u001a\u00020\u00112\u0006\u0010\u0014\u001a\u00020\u00118B@BX\u0082\u008e\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0012\n\u0004\bI\u0010\u001c\u001a\u0004\bG\u0010\u0013\"\u0004\bH\u00109R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010J\u001a\u0004\u0018\u00010K8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\bL\u0010MR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010N\u001a\u0004\u0018\u00010OX\u0082\u000e¢\u0006\u0002\n\u0000R+\u0010Q\u001a\u00020P2\u0006\u0010\u0014\u001a\u00020P8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\bV\u0010\u001c\u001a\u0004\bR\u0010S\"\u0004\bT\u0010U\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006®\u0001"}, d2 = {"Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;", "", "textFieldState", "Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "textLayoutState", "Landroidx/compose/foundation/text/input/internal/TextLayoutState;", "density", "Landroidx/compose/ui/unit/Density;", "enabled", "", "readOnly", "isFocused", "isPassword", "(Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;Landroidx/compose/foundation/text/input/internal/TextLayoutState;Landroidx/compose/ui/unit/Density;ZZZZ)V", "clipboardManager", "Landroidx/compose/ui/platform/ClipboardManager;", "currentTextLayoutPositionInWindow", "Landroidx/compose/ui/geometry/Offset;", "getCurrentTextLayoutPositionInWindow-F1C5BW0", "()J", "<set-?>", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState$InputType;", "directDragGestureInitiator", "getDirectDragGestureInitiator", "()Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState$InputType;", "setDirectDragGestureInitiator", "(Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState$InputType;)V", "directDragGestureInitiator$delegate", "Landroidx/compose/runtime/MutableState;", "Landroidx/compose/foundation/text/Handle;", "draggingHandle", "getDraggingHandle", "()Landroidx/compose/foundation/text/Handle;", "setDraggingHandle", "(Landroidx/compose/foundation/text/Handle;)V", "draggingHandle$delegate", "editable", "getEditable", "()Z", "handleDragPosition", "getHandleDragPosition-F1C5BW0", "hapticFeedBack", "Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "setFocused", "(Z)V", "isInTouchMode", "setInTouchMode", "isInTouchMode$delegate", "pressInteraction", "Landroidx/compose/foundation/interaction/PressInteraction$Press;", "previousRawDragOffset", "", "previousSelectionLayout", "Landroidx/compose/foundation/text/selection/SelectionLayout;", "rawHandleDragPosition", "getRawHandleDragPosition-F1C5BW0", "setRawHandleDragPosition-k-4lQ0M", "(J)V", "rawHandleDragPosition$delegate", "receiveContentConfiguration", "Lkotlin/Function0;", "Landroidx/compose/foundation/content/internal/ReceiveContentConfiguration;", "getReceiveContentConfiguration", "()Lkotlin/jvm/functions/Function0;", "setReceiveContentConfiguration", "(Lkotlin/jvm/functions/Function0;)V", "showCursorHandle", "getShowCursorHandle", "setShowCursorHandle", "showCursorHandle$delegate", "startTextLayoutPositionInWindow", "getStartTextLayoutPositionInWindow-F1C5BW0", "setStartTextLayoutPositionInWindow-k-4lQ0M", "startTextLayoutPositionInWindow$delegate", "textLayoutCoordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "getTextLayoutCoordinates", "()Landroidx/compose/ui/layout/LayoutCoordinates;", "textToolbar", "Landroidx/compose/ui/platform/TextToolbar;", "Landroidx/compose/foundation/text/input/internal/selection/TextToolbarState;", "textToolbarState", "getTextToolbarState", "()Landroidx/compose/foundation/text/input/internal/selection/TextToolbarState;", "setTextToolbarState", "(Landroidx/compose/foundation/text/input/internal/selection/TextToolbarState;)V", "textToolbarState$delegate", "canCopy", "canCut", "canPaste", "canSelectAll", "clearHandleDragging", "", "copy", "cancelSelection", "cut", "deselect", "dispose", "getContentRect", "Landroidx/compose/ui/geometry/Rect;", "getCursorHandleState", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldHandleState;", "includePosition", "getCursorHandleState$foundation_release", "getCursorRect", "getHandlePosition", "isStartHandle", "getHandlePosition-tuRUvjQ", "(Z)J", "getSelectionHandleState", "getSelectionHandleState$foundation_release", "getTextFieldSelection", "Landroidx/compose/ui/text/TextRange;", "rawStartOffset", "rawEndOffset", "previousSelection", "adjustment", "Landroidx/compose/foundation/text/selection/SelectionAdjustment;", "getTextFieldSelection-qeG_v_k", "(IILandroidx/compose/ui/text/TextRange;ZLandroidx/compose/foundation/text/selection/SelectionAdjustment;)J", "hideTextToolbar", "isCursorHandleInVisibleBounds", "markStartContentVisibleOffset", "menuItem", "desiredState", "operation", "observeChanges", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "observeTextChanges", "observeTextToolbarVisibility", "paste", "pasteAsPlainText", "placeCursorAtNearestOffset", "offset", "placeCursorAtNearestOffset-k-4lQ0M", "(J)Z", "selectAll", "showTextToolbar", "contentRect", "update", "updateHandleDragging", "handle", "position", "updateHandleDragging-Uv8p0NA", "(Landroidx/compose/foundation/text/Handle;J)V", "updateSelection", "textFieldCharSequence", "Landroidx/compose/foundation/text/input/TextFieldCharSequence;", "startOffset", "endOffset", "allowPreviousSelectionCollapsed", "isStartOfSelection", "updateSelection-SsL-Rf8", "(Landroidx/compose/foundation/text/input/TextFieldCharSequence;IIZLandroidx/compose/foundation/text/selection/SelectionAdjustment;ZZ)J", "updateTextToolbarState", "cursorHandleGestures", "Landroidx/compose/ui/input/pointer/PointerInputScope;", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectCursorHandleDragGestures", "detectSelectionHandleDragGestures", "(Landroidx/compose/ui/input/pointer/PointerInputScope;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectTextFieldTapGestures", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "requestFocus", "showKeyboard", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Landroidx/compose/foundation/interaction/MutableInteractionSource;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectTouchMode", "selectionHandleGestures", "textFieldSelectionGestures", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/jvm/functions/Function0;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "InputType", "TextFieldMouseSelectionObserver", "TextFieldTextDragObserver", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TextFieldSelectionState {
    public static final int $stable = 8;
    private ClipboardManager clipboardManager;
    private Density density;
    private boolean enabled;
    private HapticFeedback hapticFeedBack;
    private boolean isFocused;
    private boolean isPassword;
    private PressInteraction.Press pressInteraction;
    private SelectionLayout previousSelectionLayout;
    private boolean readOnly;
    private Function0<? extends ReceiveContentConfiguration> receiveContentConfiguration;
    private final TransformedTextFieldState textFieldState;
    private final TextLayoutState textLayoutState;
    private TextToolbar textToolbar;

    private final MutableState isInTouchMode = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(true, null, 2, null);

    private final MutableState startTextLayoutPositionInWindow = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(Offset.m4335boximpl(Offset.INSTANCE.m4361getUnspecifiedF1C5BW0()), null, 2, null);

    private final MutableState rawHandleDragPosition = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(Offset.m4335boximpl(Offset.INSTANCE.m4361getUnspecifiedF1C5BW0()), null, 2, null);

    private final MutableState draggingHandle = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);

    private final MutableState directDragGestureInitiator = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(InputType.None, null, 2, null);

    private final MutableState showCursorHandle = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);

    private final MutableState textToolbarState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(TextToolbarState.None, null, 2, null);
    private int previousRawDragOffset = -1;

    @Metadata(d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0005\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005¨\u0006\u0006"}, d2 = {"Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState$InputType;", "", "(Ljava/lang/String;I)V", "None", "Touch", "Mouse", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public enum InputType {
        None,
        Touch,
        Mouse
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[IndexTransformationType.values().length];
            try {
                iArr[IndexTransformationType.Untransformed.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[IndexTransformationType.Deletion.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[IndexTransformationType.Insertion.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[IndexTransformationType.Replacement.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState", f = "TextFieldSelectionState.kt", i = {0, 0, 0}, l = {614}, m = "detectCursorHandleDragGestures", n = {"this", "cursorDragStart", "cursorDragDelta"}, s = {"L$0", "L$1", "L$2"})
    static final class C09271 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09271(Continuation<? super C09271> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TextFieldSelectionState.this.detectCursorHandleDragGestures(null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState", f = "TextFieldSelectionState.kt", i = {0, 0, 0, 0}, l = {980}, m = "detectSelectionHandleDragGestures", n = {"this", "dragBeginPosition", "dragTotalDistance", "handle"}, s = {"L$0", "L$1", "L$2", "L$3"})
    static final class C09321 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C09321(Continuation<? super C09321> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TextFieldSelectionState.this.detectSelectionHandleDragGestures(null, false, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState", f = "TextFieldSelectionState.kt", i = {0}, l = {423}, m = "observeChanges", n = {"this"}, s = {"L$0"})
    static final class C09431 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C09431(Continuation<? super C09431> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TextFieldSelectionState.this.observeChanges((Continuation) this);
        }
    }

    public TextFieldSelectionState(TransformedTextFieldState transformedTextFieldState, TextLayoutState textLayoutState, Density density, boolean z, boolean z2, boolean z3, boolean z4) {
        this.textFieldState = transformedTextFieldState;
        this.textLayoutState = textLayoutState;
        this.density = density;
        this.enabled = z;
        this.readOnly = z2;
        this.isFocused = z3;
        this.isPassword = z4;
    }

    public final boolean getIsFocused() {
        return this.isFocused;
    }

    public final void setFocused(boolean z) {
        this.isFocused = z;
    }

    public final boolean isInTouchMode() {
        return ((Boolean) this.isInTouchMode.getValue()).booleanValue();
    }

    public final void setInTouchMode(boolean z) {
        this.isInTouchMode.setValue(Boolean.valueOf(z));
    }

    public final Function0<ReceiveContentConfiguration> getReceiveContentConfiguration() {
        return this.receiveContentConfiguration;
    }

    public final void setReceiveContentConfiguration(Function0<? extends ReceiveContentConfiguration> function0) {
        this.receiveContentConfiguration = function0;
    }

    private final long m1757getStartTextLayoutPositionInWindowF1C5BW0() {
        return ((Offset) this.startTextLayoutPositionInWindow.getValue()).getPackedValue();
    }

    private final void m1761setStartTextLayoutPositionInWindowk4lQ0M(long j) {
        this.startTextLayoutPositionInWindow.setValue(Offset.m4335boximpl(j));
    }

    private final long m1754getCurrentTextLayoutPositionInWindowF1C5BW0() {
        LayoutCoordinates textLayoutCoordinates = getTextLayoutCoordinates();
        return textLayoutCoordinates != null ? LayoutCoordinatesKt.positionInWindow(textLayoutCoordinates) : Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
    }

    private final long m1756getRawHandleDragPositionF1C5BW0() {
        return ((Offset) this.rawHandleDragPosition.getValue()).getPackedValue();
    }

    private final void m1760setRawHandleDragPositionk4lQ0M(long j) {
        this.rawHandleDragPosition.setValue(Offset.m4335boximpl(j));
    }

    public final long m1764getHandleDragPositionF1C5BW0() {
        if (OffsetKt.m4367isUnspecifiedk4lQ0M(m1756getRawHandleDragPositionF1C5BW0())) {
            return Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        }
        if (OffsetKt.m4367isUnspecifiedk4lQ0M(m1757getStartTextLayoutPositionInWindowF1C5BW0())) {
            return TextLayoutStateKt.m1714fromDecorationToTextLayoutUv8p0NA(this.textLayoutState, m1756getRawHandleDragPositionF1C5BW0());
        }
        return Offset.m4351plusMKHz9U(m1756getRawHandleDragPositionF1C5BW0(), Offset.m4350minusMKHz9U(m1757getStartTextLayoutPositionInWindowF1C5BW0(), m1754getCurrentTextLayoutPositionInWindowF1C5BW0()));
    }

    public final Handle getDraggingHandle() {
        return (Handle) this.draggingHandle.getValue();
    }

    public final void setDraggingHandle(Handle handle) {
        this.draggingHandle.setValue(handle);
    }

    public final InputType getDirectDragGestureInitiator() {
        return (InputType) this.directDragGestureInitiator.getValue();
    }

    public final void setDirectDragGestureInitiator(InputType inputType) {
        this.directDragGestureInitiator.setValue(inputType);
    }

    private final boolean getShowCursorHandle() {
        return ((Boolean) this.showCursorHandle.getValue()).booleanValue();
    }

    public final void setShowCursorHandle(boolean z) {
        this.showCursorHandle.setValue(Boolean.valueOf(z));
    }

    public final TextToolbarState getTextToolbarState() {
        return (TextToolbarState) this.textToolbarState.getValue();
    }

    public final void setTextToolbarState(TextToolbarState textToolbarState) {
        this.textToolbarState.setValue(textToolbarState);
    }

    public final LayoutCoordinates getTextLayoutCoordinates() {
        LayoutCoordinates textLayoutNodeCoordinates = this.textLayoutState.getTextLayoutNodeCoordinates();
        if (textLayoutNodeCoordinates == null || !textLayoutNodeCoordinates.isAttached()) {
            return null;
        }
        return textLayoutNodeCoordinates;
    }

    private final boolean getEditable() {
        return this.enabled && !this.readOnly;
    }

    public final TextFieldHandleState getCursorHandleState$foundation_release(boolean includePosition) {
        TextFieldCharSequence visualText = this.textFieldState.getVisualText();
        boolean showCursorHandle = getShowCursorHandle();
        boolean z = getDirectDragGestureInitiator() == InputType.None;
        Handle draggingHandle = getDraggingHandle();
        if (!showCursorHandle || !z || !TextRange.getCollapsed-impl(visualText.getSelection()) || !visualText.shouldShowSelection() || visualText.length() <= 0 || (draggingHandle != Handle.Cursor && !isCursorHandleInVisibleBounds())) {
            return TextFieldHandleState.INSTANCE.getHidden();
        }
        return new TextFieldHandleState(true, includePosition ? getCursorRect().m4373getBottomCenterF1C5BW0() : Offset.INSTANCE.m4361getUnspecifiedF1C5BW0(), ResolvedTextDirection.Ltr, false, null);
    }

    private final boolean isCursorHandleInVisibleBounds() {
        Rect rectVisibleBounds;
        Snapshot.Companion companion = Snapshot.INSTANCE;
        Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
        Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
        Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
        try {
            long jM4373getBottomCenterF1C5BW0 = getCursorRect().m4373getBottomCenterF1C5BW0();
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
            LayoutCoordinates textLayoutCoordinates = getTextLayoutCoordinates();
            if (textLayoutCoordinates == null || (rectVisibleBounds = SelectionManagerKt.visibleBounds(textLayoutCoordinates)) == null) {
                return false;
            }
            return SelectionManagerKt.m1916containsInclusiveUv8p0NA(rectVisibleBounds, jM4373getBottomCenterF1C5BW0);
        } catch (Throwable th) {
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
            throw th;
        }
    }

    public final Rect getCursorRect() {
        float right;
        TextLayoutResult layoutResult = this.textLayoutState.getLayoutResult();
        if (layoutResult == null) {
            return Rect.INSTANCE.getZero();
        }
        TextFieldCharSequence visualText = this.textFieldState.getVisualText();
        if (!TextRange.getCollapsed-impl(visualText.getSelection())) {
            return Rect.INSTANCE.getZero();
        }
        Rect cursorRect = layoutResult.getCursorRect(TextRange.getStart-impl(visualText.getSelection()));
        float f = this.density.toPx-0680j_4(TextFieldCursorKt.getDefaultCursorThickness());
        if (layoutResult.getLayoutInput().getLayoutDirection() == LayoutDirection.Ltr) {
            right = cursorRect.getLeft() + (f / 2);
        } else {
            right = cursorRect.getRight() - (f / 2);
        }
        float f2 = f / 2;
        float fCoerceAtLeast = RangesKt.coerceAtLeast(RangesKt.coerceAtMost(right, IntSize.getWidth-impl(layoutResult.getSize-YbymL2g()) - f2), f2);
        return new Rect(fCoerceAtLeast - f2, cursorRect.getTop(), fCoerceAtLeast + f2, cursorRect.getBottom());
    }

    public final void update(HapticFeedback hapticFeedBack, ClipboardManager clipboardManager, TextToolbar textToolbar, Density density, boolean enabled, boolean readOnly, boolean isPassword) {
        if (!enabled) {
            hideTextToolbar();
        }
        this.hapticFeedBack = hapticFeedBack;
        this.clipboardManager = clipboardManager;
        this.textToolbar = textToolbar;
        this.density = density;
        this.enabled = enabled;
        this.readOnly = readOnly;
        this.isPassword = isPassword;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lkotlinx/coroutines/Job;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$cursorHandleGestures$2", f = "TextFieldSelectionState.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C09262 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Job>, Object> {
        final PointerInputScope $this_cursorHandleGestures;
        private Object L$0;
        int label;

        C09262(PointerInputScope pointerInputScope, Continuation<? super C09262> continuation) {
            super(2, continuation);
            this.$this_cursorHandleGestures = pointerInputScope;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09262 = TextFieldSelectionState.this.new C09262(this.$this_cursorHandleGestures, continuation);
            c09262.L$0 = obj;
            return c09262;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Job> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$cursorHandleGestures$2$1", f = "TextFieldSelectionState.kt", i = {}, l = {368}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final PointerInputScope $this_cursorHandleGestures;
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass1(TextFieldSelectionState textFieldSelectionState, PointerInputScope pointerInputScope, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = textFieldSelectionState;
                this.$this_cursorHandleGestures = pointerInputScope;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.this$0, this.$this_cursorHandleGestures, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.detectTouchMode(this.$this_cursorHandleGestures, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass1(TextFieldSelectionState.this, this.$this_cursorHandleGestures, null), 1, (Object) null);
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass2(TextFieldSelectionState.this, this.$this_cursorHandleGestures, null), 1, (Object) null);
            return BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass3(this.$this_cursorHandleGestures, TextFieldSelectionState.this, null), 1, (Object) null);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$cursorHandleGestures$2$2", f = "TextFieldSelectionState.kt", i = {}, l = {371}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final PointerInputScope $this_cursorHandleGestures;
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass2(TextFieldSelectionState textFieldSelectionState, PointerInputScope pointerInputScope, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.this$0 = textFieldSelectionState;
                this.$this_cursorHandleGestures = pointerInputScope;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass2(this.this$0, this.$this_cursorHandleGestures, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.detectCursorHandleDragGestures(this.$this_cursorHandleGestures, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$cursorHandleGestures$2$3", f = "TextFieldSelectionState.kt", i = {}, l = {374}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass3 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final PointerInputScope $this_cursorHandleGestures;
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass3(PointerInputScope pointerInputScope, TextFieldSelectionState textFieldSelectionState, Continuation<? super AnonymousClass3> continuation) {
                super(2, continuation);
                this.$this_cursorHandleGestures = pointerInputScope;
                this.this$0 = textFieldSelectionState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass3(this.$this_cursorHandleGestures, this.this$0, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    PointerInputScope pointerInputScope = this.$this_cursorHandleGestures;
                    final TextFieldSelectionState textFieldSelectionState = this.this$0;
                    this.label = 1;
                    if (TapGestureDetectorKt.detectTapGestures$default(pointerInputScope, null, null, null, new Function1<Offset, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj2) {
                            m1779invokek4lQ0M(((Offset) obj2).getPackedValue());
                            return Unit.INSTANCE;
                        }

                        public final void m1779invokek4lQ0M(long j) {
                            TextToolbarState textToolbarState;
                            TextFieldSelectionState textFieldSelectionState2 = textFieldSelectionState;
                            if (textFieldSelectionState2.getTextToolbarState() == TextToolbarState.Cursor) {
                                textToolbarState = TextToolbarState.None;
                            } else {
                                textToolbarState = TextToolbarState.Cursor;
                            }
                            textFieldSelectionState2.setTextToolbarState(textToolbarState);
                        }
                    }, (Continuation) this, 7, null) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }
    }

    public final Object cursorHandleGestures(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C09262(pointerInputScope, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lkotlinx/coroutines/Job;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$selectionHandleGestures$2", f = "TextFieldSelectionState.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C09502 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Job>, Object> {
        final boolean $isStartHandle;
        final PointerInputScope $this_selectionHandleGestures;
        private Object L$0;
        int label;

        C09502(PointerInputScope pointerInputScope, boolean z, Continuation<? super C09502> continuation) {
            super(2, continuation);
            this.$this_selectionHandleGestures = pointerInputScope;
            this.$isStartHandle = z;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09502 = TextFieldSelectionState.this.new C09502(this.$this_selectionHandleGestures, this.$isStartHandle, continuation);
            c09502.L$0 = obj;
            return c09502;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Job> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$selectionHandleGestures$2$1", f = "TextFieldSelectionState.kt", i = {}, l = {391}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final PointerInputScope $this_selectionHandleGestures;
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass1(TextFieldSelectionState textFieldSelectionState, PointerInputScope pointerInputScope, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = textFieldSelectionState;
                this.$this_selectionHandleGestures = pointerInputScope;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.this$0, this.$this_selectionHandleGestures, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.detectTouchMode(this.$this_selectionHandleGestures, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass1(TextFieldSelectionState.this, this.$this_selectionHandleGestures, null), 1, (Object) null);
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass2(this.$this_selectionHandleGestures, TextFieldSelectionState.this, this.$isStartHandle, null), 1, (Object) null);
            return BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass3(TextFieldSelectionState.this, this.$this_selectionHandleGestures, this.$isStartHandle, null), 1, (Object) null);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$selectionHandleGestures$2$2", f = "TextFieldSelectionState.kt", i = {}, l = {394}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final boolean $isStartHandle;
            final PointerInputScope $this_selectionHandleGestures;
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass2(PointerInputScope pointerInputScope, TextFieldSelectionState textFieldSelectionState, boolean z, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.$this_selectionHandleGestures = pointerInputScope;
                this.this$0 = textFieldSelectionState;
                this.$isStartHandle = z;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass2(this.$this_selectionHandleGestures, this.this$0, this.$isStartHandle, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    PointerInputScope pointerInputScope = this.$this_selectionHandleGestures;
                    final TextFieldSelectionState textFieldSelectionState = this.this$0;
                    final boolean z = this.$isStartHandle;
                    TapOnPosition tapOnPosition = new TapOnPosition() {
                        @Override
                        public final void mo1735onEventk4lQ0M(long j) {
                            Handle handle;
                            textFieldSelectionState.markStartContentVisibleOffset();
                            TextFieldSelectionState textFieldSelectionState2 = textFieldSelectionState;
                            if (z) {
                                handle = Handle.SelectionStart;
                            } else {
                                handle = Handle.SelectionEnd;
                            }
                            textFieldSelectionState2.m1765updateHandleDraggingUv8p0NA(handle, SelectionHandlesKt.m1875getAdjustedCoordinatesk4lQ0M(textFieldSelectionState.m1755getHandlePositiontuRUvjQ(z)));
                        }
                    };
                    final TextFieldSelectionState textFieldSelectionState2 = this.this$0;
                    this.label = 1;
                    if (PressDownGestureKt.detectPressDownGesture(pointerInputScope, tapOnPosition, new Function0<Unit>() {
                        {
                            super(0);
                        }

                        public Object invoke() {
                            m1795invoke();
                            return Unit.INSTANCE;
                        }

                        public final void m1795invoke() {
                            textFieldSelectionState2.clearHandleDragging();
                        }
                    }, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$selectionHandleGestures$2$3", f = "TextFieldSelectionState.kt", i = {}, l = {412}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass3 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final boolean $isStartHandle;
            final PointerInputScope $this_selectionHandleGestures;
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass3(TextFieldSelectionState textFieldSelectionState, PointerInputScope pointerInputScope, boolean z, Continuation<? super AnonymousClass3> continuation) {
                super(2, continuation);
                this.this$0 = textFieldSelectionState;
                this.$this_selectionHandleGestures = pointerInputScope;
                this.$isStartHandle = z;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass3(this.this$0, this.$this_selectionHandleGestures, this.$isStartHandle, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.detectSelectionHandleDragGestures(this.$this_selectionHandleGestures, this.$isStartHandle, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }
    }

    public final Object selectionHandleGestures(PointerInputScope pointerInputScope, boolean z, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C09502(pointerInputScope, z, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    public final Object observeChanges(Continuation<? super Unit> continuation) throws Throwable {
        C09431 c09431;
        TextFieldSelectionState textFieldSelectionState;
        if (continuation instanceof C09431) {
            c09431 = (C09431) continuation;
            if ((c09431.label & Integer.MIN_VALUE) != 0) {
                c09431.label -= Integer.MIN_VALUE;
            } else {
                c09431 = new C09431(continuation);
            }
        } else {
            c09431 = new C09431(continuation);
        }
        Object obj = c09431.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09431.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            textFieldSelectionState = (TextFieldSelectionState) c09431.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                textFieldSelectionState.setShowCursorHandle(false);
                if (textFieldSelectionState.getTextToolbarState() != TextToolbarState.None) {
                    textFieldSelectionState.hideTextToolbar();
                }
                return Unit.INSTANCE;
            } catch (Throwable th) {
                th = th;
                textFieldSelectionState.setShowCursorHandle(false);
                if (textFieldSelectionState.getTextToolbarState() != TextToolbarState.None) {
                    textFieldSelectionState.hideTextToolbar();
                }
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        try {
            C09442 c09442 = new C09442(null);
            c09431.L$0 = this;
            c09431.label = 1;
            if (CoroutineScopeKt.coroutineScope(c09442, c09431) == coroutine_suspended) {
                return coroutine_suspended;
            }
            textFieldSelectionState = this;
            textFieldSelectionState.setShowCursorHandle(false);
            if (textFieldSelectionState.getTextToolbarState() != TextToolbarState.None) {
                textFieldSelectionState.hideTextToolbar();
            }
            return Unit.INSTANCE;
        } catch (Throwable th2) {
            th = th2;
            textFieldSelectionState = this;
            textFieldSelectionState.setShowCursorHandle(false);
            if (textFieldSelectionState.getTextToolbarState() != TextToolbarState.None) {
                textFieldSelectionState.hideTextToolbar();
            }
            throw th;
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lkotlinx/coroutines/Job;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$observeChanges$2", f = "TextFieldSelectionState.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C09442 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Job>, Object> {
        private Object L$0;
        int label;

        C09442(Continuation<? super C09442> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09442 = TextFieldSelectionState.this.new C09442(continuation);
            c09442.L$0 = obj;
            return c09442;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Job> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$observeChanges$2$1", f = "TextFieldSelectionState.kt", i = {}, l = {424}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass1(TextFieldSelectionState textFieldSelectionState, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = textFieldSelectionState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.this$0, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.observeTextChanges((Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass1(TextFieldSelectionState.this, null), 3, (Object) null);
            return BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass2(TextFieldSelectionState.this, null), 3, (Object) null);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$observeChanges$2$2", f = "TextFieldSelectionState.kt", i = {}, l = {425}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final TextFieldSelectionState this$0;

            AnonymousClass2(TextFieldSelectionState textFieldSelectionState, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.this$0 = textFieldSelectionState;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass2(this.this$0, continuation);
            }

            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0.observeTextToolbarVisibility((Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
        }
    }

    public final void updateTextToolbarState(TextToolbarState textToolbarState) {
        setTextToolbarState(textToolbarState);
    }

    public final void dispose() {
        hideTextToolbar();
        this.textToolbar = null;
        this.clipboardManager = null;
        this.hapticFeedBack = null;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$detectTouchMode$2", f = "TextFieldSelectionState.kt", i = {0}, l = {455}, m = "invokeSuspend", n = {"$this$awaitPointerEventScope"}, s = {"L$0"})
    static final class C09412 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        private Object L$0;
        int label;

        C09412(Continuation<? super C09412> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09412 = TextFieldSelectionState.this.new C09412(continuation);
            c09412.L$0 = obj;
            return c09412;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final java.lang.Object invokeSuspend(java.lang.Object r5) {
            throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState.C09412.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public final Object detectTouchMode(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
        Object objAwaitPointerEventScope = pointerInputScope.awaitPointerEventScope(new C09412(null), continuation);
        return objAwaitPointerEventScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitPointerEventScope : Unit.INSTANCE;
    }

    public final Object detectTextFieldTapGestures(PointerInputScope pointerInputScope, MutableInteractionSource mutableInteractionSource, final Function0<Unit> function0, final Function0<Unit> function1, Continuation<? super Unit> continuation) {
        Object objDetectTapAndPress = TapGestureDetectorKt.detectTapAndPress(pointerInputScope, new C09382(mutableInteractionSource, this, null), new Function1<Offset, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) throws NoWhenBranchMatchedException {
                m1790invokek4lQ0M(((Offset) obj).getPackedValue());
                return Unit.INSTANCE;
            }

            public final void m1790invokek4lQ0M(long j) throws NoWhenBranchMatchedException {
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    public final String invoke() {
                        return "onTapTextField";
                    }
                });
                function0.invoke();
                if (this.enabled && this.getIsFocused()) {
                    if (!this.readOnly) {
                        function1.invoke();
                        if (this.textFieldState.getVisualText().length() > 0) {
                            this.setShowCursorHandle(true);
                        }
                    }
                    this.updateTextToolbarState(TextToolbarState.None);
                    long jM1706coercedInVisibleBoundsOfInputTextMKHz9U$foundation_release = this.textLayoutState.m1706coercedInVisibleBoundsOfInputTextMKHz9U$foundation_release(j);
                    TextFieldSelectionState textFieldSelectionState = this;
                    textFieldSelectionState.m1759placeCursorAtNearestOffsetk4lQ0M(TextLayoutStateKt.m1714fromDecorationToTextLayoutUv8p0NA(textFieldSelectionState.textLayoutState, jM1706coercedInVisibleBoundsOfInputTextMKHz9U$foundation_release));
                }
            }
        }, continuation);
        return objDetectTapAndPress == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDetectTapAndPress : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/PressGestureScope;", "offset", "Landroidx/compose/ui/geometry/Offset;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$detectTextFieldTapGestures$2", f = "TextFieldSelectionState.kt", i = {}, l = {491}, m = "invokeSuspend", n = {}, s = {})
    static final class C09382 extends SuspendLambda implements Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> {
        final MutableInteractionSource $interactionSource;
        long J$0;
        private Object L$0;
        int label;
        final TextFieldSelectionState this$0;

        C09382(MutableInteractionSource mutableInteractionSource, TextFieldSelectionState textFieldSelectionState, Continuation<? super C09382> continuation) {
            super(3, continuation);
            this.$interactionSource = mutableInteractionSource;
            this.this$0 = textFieldSelectionState;
        }

        public Object invoke(Object obj, Object obj2, Object obj3) {
            return m1789invoked4ec7I((PressGestureScope) obj, ((Offset) obj2).getPackedValue(), (Continuation) obj3);
        }

        public final Object m1789invoked4ec7I(PressGestureScope pressGestureScope, long j, Continuation<? super Unit> continuation) {
            C09382 c09382 = new C09382(this.$interactionSource, this.this$0, continuation);
            c09382.L$0 = pressGestureScope;
            c09382.J$0 = j;
            return c09382.invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                PressGestureScope pressGestureScope = (PressGestureScope) this.L$0;
                long j = this.J$0;
                MutableInteractionSource mutableInteractionSource = this.$interactionSource;
                if (mutableInteractionSource != null) {
                    TextFieldSelectionState$detectTextFieldTapGestures$2$1$1 textFieldSelectionState$detectTextFieldTapGestures$2$1$1 = new TextFieldSelectionState$detectTextFieldTapGestures$2$1$1(pressGestureScope, this.this$0, j, mutableInteractionSource, null);
                    this.label = 1;
                    if (CoroutineScopeKt.coroutineScope(textFieldSelectionState$detectTextFieldTapGestures$2$1$1, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public final boolean m1759placeCursorAtNearestOffsetk4lQ0M(long offset) throws NoWhenBranchMatchedException {
        int i;
        IndexTransformationType indexTransformationType;
        int i2;
        SelectionWedgeAffinity selectionWedgeAffinity;
        TextLayoutResult layoutResult = this.textLayoutState.getLayoutResult();
        if (layoutResult == null || (i = layoutResult.getOffsetForPosition-k-4lQ0M(offset)) == -1) {
            return false;
        }
        TransformedTextFieldState transformedTextFieldState = this.textFieldState;
        long jM1721mapFromTransformedjx7JFs = transformedTextFieldState.m1721mapFromTransformedjx7JFs(i);
        long jM1724mapToTransformedGEjPoXI = transformedTextFieldState.m1724mapToTransformedGEjPoXI(jM1721mapFromTransformedjx7JFs);
        if (TextRange.getCollapsed-impl(jM1721mapFromTransformedjx7JFs) && TextRange.getCollapsed-impl(jM1724mapToTransformedGEjPoXI)) {
            indexTransformationType = IndexTransformationType.Untransformed;
        } else if (!TextRange.getCollapsed-impl(jM1721mapFromTransformedjx7JFs) && !TextRange.getCollapsed-impl(jM1724mapToTransformedGEjPoXI)) {
            indexTransformationType = IndexTransformationType.Replacement;
        } else if (TextRange.getCollapsed-impl(jM1721mapFromTransformedjx7JFs) && !TextRange.getCollapsed-impl(jM1724mapToTransformedGEjPoXI)) {
            indexTransformationType = IndexTransformationType.Insertion;
        } else {
            indexTransformationType = IndexTransformationType.Deletion;
        }
        int i3 = WhenMappings.$EnumSwitchMapping$0[indexTransformationType.ordinal()];
        SelectionWedgeAffinity selectionWedgeAffinity2 = null;
        if (i3 == 1 || i3 == 2) {
            i2 = TextRange.getStart-impl(jM1721mapFromTransformedjx7JFs);
        } else if (i3 == 3) {
            if (MathUtilsKt.m1653findClosestRect9KIMszo(offset, layoutResult.getCursorRect(TextRange.getStart-impl(jM1724mapToTransformedGEjPoXI)), layoutResult.getCursorRect(TextRange.getEnd-impl(jM1724mapToTransformedGEjPoXI))) < 0) {
                selectionWedgeAffinity = new SelectionWedgeAffinity(WedgeAffinity.Start);
            } else {
                selectionWedgeAffinity = new SelectionWedgeAffinity(WedgeAffinity.End);
            }
            selectionWedgeAffinity2 = selectionWedgeAffinity;
            i2 = TextRange.getStart-impl(jM1721mapFromTransformedjx7JFs);
        } else {
            if (i3 != 4) {
                throw new NoWhenBranchMatchedException();
            }
            if (MathUtilsKt.m1653findClosestRect9KIMszo(offset, layoutResult.getCursorRect(TextRange.getStart-impl(jM1724mapToTransformedGEjPoXI)), layoutResult.getCursorRect(TextRange.getEnd-impl(jM1724mapToTransformedGEjPoXI))) < 0) {
                i2 = TextRange.getStart-impl(jM1721mapFromTransformedjx7JFs);
            } else {
                i2 = TextRange.getEnd-impl(jM1721mapFromTransformedjx7JFs);
            }
        }
        long jTextRange = TextRangeKt.TextRange(i2);
        if (TextRange.equals-impl0(jTextRange, this.textFieldState.getUntransformedText().getSelection()) && (selectionWedgeAffinity2 == null || Intrinsics.areEqual(selectionWedgeAffinity2, this.textFieldState.getSelectionWedgeAffinity()))) {
            return false;
        }
        this.textFieldState.m1727selectUntransformedCharsIn5zctL8(jTextRange);
        if (selectionWedgeAffinity2 != null) {
            this.textFieldState.setSelectionWedgeAffinity(selectionWedgeAffinity2);
        }
        return true;
    }

    public final Object detectCursorHandleDragGestures(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) throws Throwable {
        C09271 c09271;
        TextFieldSelectionState textFieldSelectionState;
        Ref.LongRef longRef;
        Throwable th;
        Ref.LongRef longRef2;
        if (continuation instanceof C09271) {
            c09271 = (C09271) continuation;
            if ((c09271.label & Integer.MIN_VALUE) != 0) {
                c09271.label -= Integer.MIN_VALUE;
            } else {
                c09271 = new C09271(continuation);
            }
        } else {
            c09271 = new C09271(continuation);
        }
        C09271 c09272 = c09271;
        Object obj = c09272.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09272.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            longRef2 = (Ref.LongRef) c09272.L$2;
            longRef = (Ref.LongRef) c09272.L$1;
            textFieldSelectionState = (TextFieldSelectionState) c09272.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                detectCursorHandleDragGestures$onDragStop(longRef, longRef2, textFieldSelectionState);
                return Unit.INSTANCE;
            } catch (Throwable th2) {
                th = th2;
                detectCursorHandleDragGestures$onDragStop(longRef, longRef2, textFieldSelectionState);
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        final Ref.LongRef longRef3 = new Ref.LongRef();
        longRef3.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        final Ref.LongRef longRef4 = new Ref.LongRef();
        longRef4.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        try {
            Function1<Offset, Unit> function1 = new Function1<Offset, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    m1780invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m1780invokek4lQ0M(long j) {
                    longRef3.element = SelectionHandlesKt.m1875getAdjustedCoordinatesk4lQ0M(this.getCursorRect().m4373getBottomCenterF1C5BW0());
                    longRef4.element = Offset.INSTANCE.m4362getZeroF1C5BW0();
                    this.setInTouchMode(true);
                    this.markStartContentVisibleOffset();
                    this.m1765updateHandleDraggingUv8p0NA(Handle.Cursor, longRef3.element);
                }
            };
            Function0<Unit> function0 = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1781invoke();
                    return Unit.INSTANCE;
                }

                public final void m1781invoke() {
                    TextFieldSelectionState.detectCursorHandleDragGestures$onDragStop(longRef3, longRef4, this);
                }
            };
            Function0<Unit> function2 = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1782invoke();
                    return Unit.INSTANCE;
                }

                public final void m1782invoke() {
                    TextFieldSelectionState.detectCursorHandleDragGestures$onDragStop(longRef3, longRef4, this);
                }
            };
            Function2<PointerInputChange, Offset, Unit> function3 = new Function2<PointerInputChange, Offset, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    m1783invokeUv8p0NA((PointerInputChange) obj2, ((Offset) obj3).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m1783invokeUv8p0NA(PointerInputChange pointerInputChange, long j) {
                    Ref.LongRef longRef5 = longRef4;
                    longRef5.element = Offset.m4351plusMKHz9U(longRef5.element, j);
                    this.m1765updateHandleDraggingUv8p0NA(Handle.Cursor, Offset.m4351plusMKHz9U(longRef3.element, longRef4.element));
                    TextFieldSelectionState textFieldSelectionState2 = this;
                    if (textFieldSelectionState2.m1759placeCursorAtNearestOffsetk4lQ0M(textFieldSelectionState2.m1764getHandleDragPositionF1C5BW0())) {
                        pointerInputChange.consume();
                        HapticFeedback hapticFeedback = this.hapticFeedBack;
                        if (hapticFeedback != null) {
                            hapticFeedback.mo5360performHapticFeedbackCdsT49E(HapticFeedbackType.INSTANCE.m5369getTextHandleMove5zf0vsI());
                        }
                    }
                }
            };
            c09272.L$0 = this;
            c09272.L$1 = longRef3;
            c09272.L$2 = longRef4;
            c09272.label = 1;
            if (DragGestureDetectorKt.detectDragGestures(pointerInputScope, function1, function0, function2, function3, c09272) == coroutine_suspended) {
                return coroutine_suspended;
            }
            textFieldSelectionState = this;
            longRef = longRef3;
            longRef2 = longRef4;
            detectCursorHandleDragGestures$onDragStop(longRef, longRef2, textFieldSelectionState);
            return Unit.INSTANCE;
        } catch (Throwable th3) {
            textFieldSelectionState = this;
            longRef = longRef3;
            th = th3;
            longRef2 = longRef4;
            detectCursorHandleDragGestures$onDragStop(longRef, longRef2, textFieldSelectionState);
            throw th;
        }
    }

    public static final void detectCursorHandleDragGestures$onDragStop(Ref.LongRef longRef, Ref.LongRef longRef2, TextFieldSelectionState textFieldSelectionState) {
        if (OffsetKt.m4365isSpecifiedk4lQ0M(longRef.element)) {
            longRef.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
            longRef2.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
            textFieldSelectionState.clearHandleDragging();
        }
    }

    public final Object textFieldSelectionGestures(PointerInputScope pointerInputScope, Function0<Unit> function0, Continuation<? super Unit> continuation) {
        Object objSelectionGesturePointerInputBtf2 = SelectionGesturesKt.selectionGesturePointerInputBtf2(pointerInputScope, new TextFieldMouseSelectionObserver(function0), new TextFieldTextDragObserver(function0), continuation);
        return objSelectionGesturePointerInputBtf2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSelectionGesturePointerInputBtf2 : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0082\u0004\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\"\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\u000fH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0010\u0010\u0011J\b\u0010\u0012\u001a\u00020\u0004H\u0016J\u001a\u0010\u0013\u001a\u00020\f2\u0006\u0010\u0014\u001a\u00020\tH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016J\u001a\u0010\u0017\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\tH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0016J\"\u0010\u0019\u001a\u00020\f2\u0006\u0010\u0014\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\u000fH\u0016ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u0011J*\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\r\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u001d\u001a\u00020\fH\u0002ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001fR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\b\u001a\u00020\tX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\nR\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006 "}, d2 = {"Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState$TextFieldMouseSelectionObserver;", "Landroidx/compose/foundation/text/selection/MouseSelectionObserver;", "requestFocus", "Lkotlin/Function0;", "", "(Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;Lkotlin/jvm/functions/Function0;)V", "dragBeginOffsetInText", "", "dragBeginPosition", "Landroidx/compose/ui/geometry/Offset;", "J", "onDrag", "", "dragPosition", "adjustment", "Landroidx/compose/foundation/text/selection/SelectionAdjustment;", "onDrag-3MmeM6k", "(JLandroidx/compose/foundation/text/selection/SelectionAdjustment;)Z", "onDragDone", "onExtend", "downPosition", "onExtend-k-4lQ0M", "(J)Z", "onExtendDrag", "onExtendDrag-k-4lQ0M", "onStart", "onStart-3MmeM6k", "updateSelection", "Landroidx/compose/ui/text/TextRange;", "isStartOfSelection", "updateSelection-r1Wruf4", "(JLandroidx/compose/foundation/text/selection/SelectionAdjustment;Z)J", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private final class TextFieldMouseSelectionObserver implements MouseSelectionObserver {
        private int dragBeginOffsetInText = -1;
        private long dragBeginPosition = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        private final Function0<Unit> requestFocus;

        public TextFieldMouseSelectionObserver(Function0<Unit> function0) {
            this.requestFocus = function0;
        }

        @Override
        public boolean mo1770onStart3MmeM6k(long downPosition, SelectionAdjustment adjustment) {
            if (!TextFieldSelectionState.this.enabled || TextFieldSelectionState.this.textFieldState.getVisualText().length() == 0) {
                return false;
            }
            TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                public final String invoke() {
                    return "Mouse.onStart";
                }
            });
            TextFieldSelectionState.this.setDirectDragGestureInitiator(InputType.Mouse);
            this.requestFocus.invoke();
            TextFieldSelectionState.this.previousRawDragOffset = -1;
            this.dragBeginOffsetInText = -1;
            this.dragBeginPosition = downPosition;
            this.dragBeginOffsetInText = TextRange.getStart-impl(m1766updateSelectionr1Wruf4(downPosition, adjustment, true));
            return true;
        }

        @Override
        public boolean mo1767onDrag3MmeM6k(final long dragPosition, SelectionAdjustment adjustment) {
            if (!TextFieldSelectionState.this.enabled || TextFieldSelectionState.this.textFieldState.getVisualText().length() == 0) {
                return false;
            }
            TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                {
                    super(0);
                }

                public final String invoke() {
                    return "Mouse.onDrag " + ((Object) Offset.m4354toStringimpl(dragPosition));
                }
            });
            m1766updateSelectionr1Wruf4(dragPosition, adjustment, false);
            return true;
        }

        private final long m1766updateSelectionr1Wruf4(long dragPosition, SelectionAdjustment adjustment, boolean isStartOfSelection) {
            Integer numValueOf = Integer.valueOf(this.dragBeginOffsetInText);
            if (numValueOf.intValue() < 0) {
                numValueOf = null;
            }
            int iIntValue = numValueOf != null ? numValueOf.intValue() : TextFieldSelectionState.this.textLayoutState.m1708getOffsetForPosition3MmeM6k(this.dragBeginPosition, false);
            int iM1708getOffsetForPosition3MmeM6k = TextFieldSelectionState.this.textLayoutState.m1708getOffsetForPosition3MmeM6k(dragPosition, false);
            TextFieldSelectionState textFieldSelectionState = TextFieldSelectionState.this;
            long jM1762updateSelectionSsLRf8 = textFieldSelectionState.m1762updateSelectionSsLRf8(textFieldSelectionState.textFieldState.getVisualText(), iIntValue, iM1708getOffsetForPosition3MmeM6k, false, adjustment, false, isStartOfSelection);
            if (this.dragBeginOffsetInText == -1 && !TextRange.getCollapsed-impl(jM1762updateSelectionSsLRf8)) {
                this.dragBeginOffsetInText = TextRange.getStart-impl(jM1762updateSelectionSsLRf8);
            }
            if (TextRange.getReversed-impl(jM1762updateSelectionSsLRf8)) {
                jM1762updateSelectionSsLRf8 = TextFieldSelectionStateKt.m1801reverse5zctL8(jM1762updateSelectionSsLRf8);
            }
            TextFieldSelectionState.this.textFieldState.m1726selectCharsIn5zctL8(jM1762updateSelectionSsLRf8);
            TextFieldSelectionState.this.updateTextToolbarState(TextToolbarState.Selection);
            return jM1762updateSelectionSsLRf8;
        }

        @Override
        public void onDragDone() {
            TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                public final String invoke() {
                    return "Mouse.onDragDone";
                }
            });
            TextFieldSelectionState.this.setDirectDragGestureInitiator(InputType.None);
        }

        @Override
        public boolean mo1768onExtendk4lQ0M(long downPosition) {
            TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                public final String invoke() {
                    return "Mouse.onExtend";
                }
            });
            return true;
        }

        @Override
        public boolean mo1769onExtendDragk4lQ0M(long dragPosition) {
            TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                public final String invoke() {
                    return "Mouse.onExtendDrag";
                }
            });
            return true;
        }
    }

    @Metadata(d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0011\b\u0082\u0004\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\b\u0010\u000e\u001a\u00020\u0004H\u0016J\u001a\u0010\u000f\u001a\u00020\u00042\u0006\u0010\u0010\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u001a\u0010\u0013\u001a\u00020\u00042\u0006\u0010\u0014\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0012J\b\u0010\u0016\u001a\u00020\u0004H\u0002J\u001a\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u000bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u0012J\b\u0010\u001a\u001a\u00020\u0004H\u0016J\b\u0010\u001b\u001a\u00020\u0004H\u0016R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\n\u001a\u00020\u000bX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\fR\u0016\u0010\r\u001a\u00020\u000bX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\fR\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001c"}, d2 = {"Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState$TextFieldTextDragObserver;", "Landroidx/compose/foundation/text/TextDragObserver;", "requestFocus", "Lkotlin/Function0;", "", "(Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;Lkotlin/jvm/functions/Function0;)V", "actingHandle", "Landroidx/compose/foundation/text/Handle;", "dragBeginOffsetInText", "", "dragBeginPosition", "Landroidx/compose/ui/geometry/Offset;", "J", "dragTotalDistance", "onCancel", "onDown", "point", "onDown-k-4lQ0M", "(J)V", "onDrag", "delta", "onDrag-k-4lQ0M", "onDragStop", "onStart", "startPoint", "onStart-k-4lQ0M", "onStop", "onUp", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private final class TextFieldTextDragObserver implements TextDragObserver {
        private final Function0<Unit> requestFocus;
        private int dragBeginOffsetInText = -1;
        private long dragBeginPosition = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        private long dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
        private Handle actingHandle = Handle.SelectionEnd;

        @Override
        public void mo1523onDownk4lQ0M(long point) {
        }

        @Override
        public void onUp() {
        }

        public TextFieldTextDragObserver(Function0<Unit> function0) {
            this.requestFocus = function0;
        }

        private final void onDragStop() {
            if (OffsetKt.m4365isSpecifiedk4lQ0M(this.dragBeginPosition)) {
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    public final String invoke() {
                        return "Touch.onDragStop";
                    }
                });
                TextFieldSelectionState.this.clearHandleDragging();
                this.dragBeginOffsetInText = -1;
                this.dragBeginPosition = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
                this.dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
                TextFieldSelectionState.this.previousRawDragOffset = -1;
                TextFieldSelectionState.this.setDirectDragGestureInitiator(InputType.None);
                this.requestFocus.invoke();
            }
        }

        @Override
        public void onStop() {
            onDragStop();
        }

        @Override
        public void onCancel() {
            onDragStop();
        }

        @Override
        public void mo1525onStartk4lQ0M(final long startPoint) {
            if (TextFieldSelectionState.this.enabled) {
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    {
                        super(0);
                    }

                    public final String invoke() {
                        return "Touch.onDragStart after longPress at " + ((Object) Offset.m4354toStringimpl(startPoint));
                    }
                });
                TextFieldSelectionState.this.m1765updateHandleDraggingUv8p0NA(this.actingHandle, startPoint);
                TextFieldSelectionState.this.setShowCursorHandle(false);
                TextFieldSelectionState.this.setDirectDragGestureInitiator(InputType.Touch);
                this.dragBeginPosition = startPoint;
                this.dragTotalDistance = Offset.INSTANCE.m4362getZeroF1C5BW0();
                TextFieldSelectionState.this.previousRawDragOffset = -1;
                if (!TextFieldSelectionState.this.textLayoutState.m1709isPositionOnTextk4lQ0M(startPoint)) {
                    int iM1705getOffsetForPosition3MmeM6k$default = TextLayoutState.m1705getOffsetForPosition3MmeM6k$default(TextFieldSelectionState.this.textLayoutState, startPoint, false, 2, null);
                    HapticFeedback hapticFeedback = TextFieldSelectionState.this.hapticFeedBack;
                    if (hapticFeedback != null) {
                        hapticFeedback.mo5360performHapticFeedbackCdsT49E(HapticFeedbackType.INSTANCE.m5369getTextHandleMove5zf0vsI());
                    }
                    TextFieldSelectionState.this.textFieldState.placeCursorBeforeCharAt(iM1705getOffsetForPosition3MmeM6k$default);
                    TextFieldSelectionState.this.setShowCursorHandle(true);
                    TextFieldSelectionState.this.updateTextToolbarState(TextToolbarState.Cursor);
                    return;
                }
                if (TextFieldSelectionState.this.textFieldState.getVisualText().length() == 0) {
                    return;
                }
                int iM1705getOffsetForPosition3MmeM6k$default2 = TextLayoutState.m1705getOffsetForPosition3MmeM6k$default(TextFieldSelectionState.this.textLayoutState, startPoint, false, 2, null);
                long jM1763updateSelectionSsLRf8$default = TextFieldSelectionState.m1763updateSelectionSsLRf8$default(TextFieldSelectionState.this, new TextFieldCharSequence(TextFieldSelectionState.this.textFieldState.getVisualText(), TextRange.Companion.getZero-d9O1mEE(), null, null, 12, null), iM1705getOffsetForPosition3MmeM6k$default2, iM1705getOffsetForPosition3MmeM6k$default2, false, SelectionAdjustment.INSTANCE.getWord(), false, false, 96, null);
                TextFieldSelectionState.this.textFieldState.m1726selectCharsIn5zctL8(jM1763updateSelectionSsLRf8$default);
                TextFieldSelectionState.this.updateTextToolbarState(TextToolbarState.Selection);
                this.dragBeginOffsetInText = TextRange.getStart-impl(jM1763updateSelectionSsLRf8$default);
            }
        }

        @Override
        public void mo1524onDragk4lQ0M(long delta) {
            int iIntValue;
            int iM1708getOffsetForPosition3MmeM6k;
            SelectionAdjustment word;
            Handle handle;
            if (!TextFieldSelectionState.this.enabled || TextFieldSelectionState.this.textFieldState.getVisualText().length() == 0) {
                return;
            }
            long jM4351plusMKHz9U = Offset.m4351plusMKHz9U(this.dragTotalDistance, delta);
            this.dragTotalDistance = jM4351plusMKHz9U;
            final long jM4351plusMKHz9U2 = Offset.m4351plusMKHz9U(this.dragBeginPosition, jM4351plusMKHz9U);
            TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                {
                    super(0);
                }

                public final String invoke() {
                    return "Touch.onDrag at " + ((Object) Offset.m4354toStringimpl(jM4351plusMKHz9U2));
                }
            });
            if (this.dragBeginOffsetInText < 0 && !TextFieldSelectionState.this.textLayoutState.m1709isPositionOnTextk4lQ0M(jM4351plusMKHz9U2)) {
                iIntValue = TextLayoutState.m1705getOffsetForPosition3MmeM6k$default(TextFieldSelectionState.this.textLayoutState, this.dragBeginPosition, false, 2, null);
                iM1708getOffsetForPosition3MmeM6k = TextLayoutState.m1705getOffsetForPosition3MmeM6k$default(TextFieldSelectionState.this.textLayoutState, jM4351plusMKHz9U2, false, 2, null);
                if (iIntValue == iM1708getOffsetForPosition3MmeM6k) {
                    word = SelectionAdjustment.INSTANCE.getNone();
                } else {
                    word = SelectionAdjustment.INSTANCE.getWord();
                }
            } else {
                Integer numValueOf = Integer.valueOf(this.dragBeginOffsetInText);
                if (numValueOf.intValue() < 0) {
                    numValueOf = null;
                }
                iIntValue = numValueOf != null ? numValueOf.intValue() : TextFieldSelectionState.this.textLayoutState.m1708getOffsetForPosition3MmeM6k(this.dragBeginPosition, false);
                iM1708getOffsetForPosition3MmeM6k = TextFieldSelectionState.this.textLayoutState.m1708getOffsetForPosition3MmeM6k(jM4351plusMKHz9U2, false);
                if (this.dragBeginOffsetInText < 0 && iIntValue == iM1708getOffsetForPosition3MmeM6k) {
                    return;
                }
                word = SelectionAdjustment.INSTANCE.getWord();
                TextFieldSelectionState.this.updateTextToolbarState(TextToolbarState.Selection);
            }
            int i = iIntValue;
            int i2 = iM1708getOffsetForPosition3MmeM6k;
            SelectionAdjustment selectionAdjustment = word;
            long selection = TextFieldSelectionState.this.textFieldState.getVisualText().getSelection();
            TextFieldSelectionState textFieldSelectionState = TextFieldSelectionState.this;
            long jM1763updateSelectionSsLRf8$default = TextFieldSelectionState.m1763updateSelectionSsLRf8$default(textFieldSelectionState, textFieldSelectionState.textFieldState.getVisualText(), i, i2, false, selectionAdjustment, false, false, 64, null);
            if (this.dragBeginOffsetInText == -1 && !TextRange.getCollapsed-impl(jM1763updateSelectionSsLRf8$default)) {
                this.dragBeginOffsetInText = TextRange.getStart-impl(jM1763updateSelectionSsLRf8$default);
            }
            if (TextRange.getReversed-impl(jM1763updateSelectionSsLRf8$default)) {
                jM1763updateSelectionSsLRf8$default = TextFieldSelectionStateKt.m1801reverse5zctL8(jM1763updateSelectionSsLRf8$default);
            }
            if (!TextRange.equals-impl0(jM1763updateSelectionSsLRf8$default, selection)) {
                if (TextRange.getStart-impl(jM1763updateSelectionSsLRf8$default) != TextRange.getStart-impl(selection) && TextRange.getEnd-impl(jM1763updateSelectionSsLRf8$default) == TextRange.getEnd-impl(selection)) {
                    handle = Handle.SelectionStart;
                } else if ((TextRange.getStart-impl(jM1763updateSelectionSsLRf8$default) == TextRange.getStart-impl(selection) && TextRange.getEnd-impl(jM1763updateSelectionSsLRf8$default) != TextRange.getEnd-impl(selection)) || (TextRange.getStart-impl(jM1763updateSelectionSsLRf8$default) + TextRange.getEnd-impl(jM1763updateSelectionSsLRf8$default)) / 2.0f > (TextRange.getStart-impl(selection) + TextRange.getEnd-impl(selection)) / 2.0f) {
                    handle = Handle.SelectionEnd;
                } else {
                    handle = Handle.SelectionStart;
                }
                this.actingHandle = handle;
            }
            if (TextRange.getCollapsed-impl(selection) || !TextRange.getCollapsed-impl(jM1763updateSelectionSsLRf8$default)) {
                TextFieldSelectionState.this.textFieldState.m1726selectCharsIn5zctL8(jM1763updateSelectionSsLRf8$default);
            }
            TextFieldSelectionState.this.m1765updateHandleDraggingUv8p0NA(this.actingHandle, jM4351plusMKHz9U2);
        }
    }

    public final Object detectSelectionHandleDragGestures(PointerInputScope pointerInputScope, final boolean z, Continuation<? super Unit> continuation) throws Throwable {
        C09321 c09321;
        Handle handle;
        Ref.LongRef longRef;
        final Handle handle2;
        Ref.LongRef longRef2;
        TextFieldSelectionState textFieldSelectionState;
        Ref.LongRef longRef3;
        if (continuation instanceof C09321) {
            c09321 = (C09321) continuation;
            if ((c09321.label & Integer.MIN_VALUE) != 0) {
                c09321.label -= Integer.MIN_VALUE;
            } else {
                c09321 = new C09321(continuation);
            }
        } else {
            c09321 = new C09321(continuation);
        }
        C09321 c09322 = c09321;
        Object obj = c09322.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09322.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            handle2 = (Handle) c09322.L$3;
            longRef2 = (Ref.LongRef) c09322.L$2;
            longRef3 = (Ref.LongRef) c09322.L$1;
            textFieldSelectionState = (TextFieldSelectionState) c09322.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    {
                        super(0);
                    }

                    public final String invoke() {
                        return "Selection Handle drag cancelled for draggingHandle: " + TextFieldSelectionState.this.getDraggingHandle() + " definedOn: " + handle2;
                    }
                });
                if (textFieldSelectionState.getDraggingHandle() == handle2) {
                    detectSelectionHandleDragGestures$onDragStop$5(longRef3, textFieldSelectionState, longRef2);
                }
                return Unit.INSTANCE;
            } catch (Throwable th) {
                th = th;
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    {
                        super(0);
                    }

                    public final String invoke() {
                        return "Selection Handle drag cancelled for draggingHandle: " + TextFieldSelectionState.this.getDraggingHandle() + " definedOn: " + handle2;
                    }
                });
                if (textFieldSelectionState.getDraggingHandle() == handle2) {
                    detectSelectionHandleDragGestures$onDragStop$5(longRef3, textFieldSelectionState, longRef2);
                }
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        final Ref.LongRef longRef4 = new Ref.LongRef();
        longRef4.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        final Ref.LongRef longRef5 = new Ref.LongRef();
        longRef5.element = Offset.INSTANCE.m4362getZeroF1C5BW0();
        final Handle handle3 = z ? Handle.SelectionStart : Handle.SelectionEnd;
        try {
            Function1<Offset, Unit> function1 = new Function1<Offset, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    m1784invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m1784invokek4lQ0M(long j) {
                    longRef4.element = SelectionHandlesKt.m1875getAdjustedCoordinatesk4lQ0M(this.m1755getHandlePositiontuRUvjQ(z));
                    this.m1765updateHandleDraggingUv8p0NA(handle3, longRef4.element);
                    longRef5.element = Offset.INSTANCE.m4362getZeroF1C5BW0();
                    this.previousRawDragOffset = -1;
                }
            };
            Function0<Unit> function0 = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1785invoke();
                    return Unit.INSTANCE;
                }

                public final void m1785invoke() {
                    TextFieldSelectionState.detectSelectionHandleDragGestures$onDragStop$5(longRef4, this, longRef5);
                }
            };
            Function0<Unit> function2 = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1786invoke();
                    return Unit.INSTANCE;
                }

                public final void m1786invoke() {
                    TextFieldSelectionState.detectSelectionHandleDragGestures$onDragStop$5(longRef4, this, longRef5);
                }
            };
            Function2<PointerInputChange, Offset, Unit> function3 = new Function2<PointerInputChange, Offset, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    m1787invokeUv8p0NA((PointerInputChange) obj2, ((Offset) obj3).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m1787invokeUv8p0NA(PointerInputChange pointerInputChange, long j) {
                    int i2;
                    int i3;
                    Ref.LongRef longRef6 = longRef5;
                    longRef6.element = Offset.m4351plusMKHz9U(longRef6.element, j);
                    TextLayoutResult layoutResult = this.textLayoutState.getLayoutResult();
                    if (layoutResult == null) {
                        return;
                    }
                    this.m1765updateHandleDraggingUv8p0NA(handle3, Offset.m4351plusMKHz9U(longRef4.element, longRef5.element));
                    if (!z) {
                        i2 = TextRange.getStart-impl(this.textFieldState.getVisualText().getSelection());
                    } else {
                        i2 = layoutResult.getOffsetForPosition-k-4lQ0M(this.m1764getHandleDragPositionF1C5BW0());
                    }
                    int i4 = i2;
                    if (z) {
                        i3 = TextRange.getEnd-impl(this.textFieldState.getVisualText().getSelection());
                    } else {
                        i3 = layoutResult.getOffsetForPosition-k-4lQ0M(this.m1764getHandleDragPositionF1C5BW0());
                    }
                    int i5 = i3;
                    long selection = this.textFieldState.getVisualText().getSelection();
                    TextFieldSelectionState textFieldSelectionState2 = this;
                    long jM1763updateSelectionSsLRf8$default = TextFieldSelectionState.m1763updateSelectionSsLRf8$default(textFieldSelectionState2, textFieldSelectionState2.textFieldState.getVisualText(), i4, i5, z, SelectionAdjustment.INSTANCE.getCharacterWithWordAccelerate(), false, false, 96, null);
                    if (TextRange.getCollapsed-impl(selection) || !TextRange.getCollapsed-impl(jM1763updateSelectionSsLRf8$default)) {
                        this.textFieldState.m1726selectCharsIn5zctL8(jM1763updateSelectionSsLRf8$default);
                    }
                }
            };
            c09322.L$0 = this;
            c09322.L$1 = longRef4;
            c09322.L$2 = longRef5;
            c09322.L$3 = handle3;
            c09322.label = 1;
            handle = handle3;
            longRef = longRef5;
            try {
                if (DragGestureDetectorKt.detectDragGestures(pointerInputScope, function1, function0, function2, function3, c09322) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                handle2 = handle;
                longRef2 = longRef;
                textFieldSelectionState = this;
                longRef3 = longRef4;
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    {
                        super(0);
                    }

                    public final String invoke() {
                        return "Selection Handle drag cancelled for draggingHandle: " + TextFieldSelectionState.this.getDraggingHandle() + " definedOn: " + handle2;
                    }
                });
                if (textFieldSelectionState.getDraggingHandle() == handle2) {
                    detectSelectionHandleDragGestures$onDragStop$5(longRef3, textFieldSelectionState, longRef2);
                }
                return Unit.INSTANCE;
            } catch (Throwable th2) {
                th = th2;
                handle2 = handle;
                longRef2 = longRef;
                textFieldSelectionState = this;
                longRef3 = longRef4;
                TextFieldSelectionStateKt.logDebug(new Function0<String>() {
                    {
                        super(0);
                    }

                    public final String invoke() {
                        return "Selection Handle drag cancelled for draggingHandle: " + TextFieldSelectionState.this.getDraggingHandle() + " definedOn: " + handle2;
                    }
                });
                if (textFieldSelectionState.getDraggingHandle() == handle2) {
                    detectSelectionHandleDragGestures$onDragStop$5(longRef3, textFieldSelectionState, longRef2);
                }
                throw th;
            }
        } catch (Throwable th3) {
            th = th3;
            handle = handle3;
            longRef = longRef5;
        }
    }

    public static final void detectSelectionHandleDragGestures$onDragStop$5(Ref.LongRef longRef, TextFieldSelectionState textFieldSelectionState, Ref.LongRef longRef2) {
        if (OffsetKt.m4365isSpecifiedk4lQ0M(longRef.element)) {
            textFieldSelectionState.clearHandleDragging();
            longRef.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
            longRef2.element = Offset.INSTANCE.m4362getZeroF1C5BW0();
            textFieldSelectionState.previousRawDragOffset = -1;
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    class C09463 extends FunctionReferenceImpl implements Function2<TextFieldCharSequence, CharSequence, Boolean> {
        public static final C09463 INSTANCE = new C09463();

        C09463() {
            super(2, TextFieldCharSequence.class, "contentEquals", "contentEquals(Ljava/lang/CharSequence;)Z", 0);
        }

        public final Boolean invoke(TextFieldCharSequence textFieldCharSequence, CharSequence charSequence) {
            return Boolean.valueOf(textFieldCharSequence.contentEquals(charSequence));
        }
    }

    public final Object observeTextChanges(Continuation<? super Unit> continuation) {
        Object objCollect = FlowKt.drop(FlowKt.distinctUntilChanged(SnapshotStateKt.snapshotFlow(new Function0<TextFieldCharSequence>() {
            {
                super(0);
            }

            public final TextFieldCharSequence m1793invoke() {
                return TextFieldSelectionState.this.textFieldState.getVisualText();
            }
        }), C09463.INSTANCE), 1).collect(new FlowCollector() {
            public Object emit(Object obj, Continuation continuation2) {
                return emit((TextFieldCharSequence) obj, (Continuation<? super Unit>) continuation2);
            }

            public final Object emit(TextFieldCharSequence textFieldCharSequence, Continuation<? super Unit> continuation2) {
                TextFieldSelectionState.this.setShowCursorHandle(false);
                TextFieldSelectionState.this.updateTextToolbarState(TextToolbarState.None);
                return Unit.INSTANCE;
            }
        }, continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    public final Object observeTextToolbarVisibility(Continuation<? super Unit> continuation) {
        Object objCollect = SnapshotStateKt.snapshotFlow(new Function0<Rect>() {
            {
                super(0);
            }

            public final Rect m1794invoke() {
                Rect rectIntersect;
                boolean z = TextRange.getCollapsed-impl(TextFieldSelectionState.this.textFieldState.getVisualText().getSelection());
                if (((z && TextFieldSelectionState.this.getTextToolbarState() == TextToolbarState.Cursor) || (!z && TextFieldSelectionState.this.getTextToolbarState() == TextToolbarState.Selection)) && TextFieldSelectionState.this.getDraggingHandle() == null && TextFieldSelectionState.this.isInTouchMode()) {
                    LayoutCoordinates textLayoutCoordinates = TextFieldSelectionState.this.getTextLayoutCoordinates();
                    Rect rectVisibleBounds = textLayoutCoordinates != null ? SelectionManagerKt.visibleBounds(textLayoutCoordinates) : null;
                    if (rectVisibleBounds != null) {
                        LayoutCoordinates textLayoutCoordinates2 = TextFieldSelectionState.this.getTextLayoutCoordinates();
                        Offset offsetM4335boximpl = textLayoutCoordinates2 != null ? Offset.m4335boximpl(textLayoutCoordinates2.mo6043localToRootMKHz9U(rectVisibleBounds.m4381getTopLeftF1C5BW0())) : null;
                        Intrinsics.checkNotNull(offsetM4335boximpl);
                        Rect rectM4386Recttz77jQw = RectKt.m4386Recttz77jQw(offsetM4335boximpl.getPackedValue(), rectVisibleBounds.m4379getSizeNHjbRc());
                        Rect contentRect = TextFieldSelectionState.this.getContentRect();
                        Rect rect = rectM4386Recttz77jQw.overlaps(contentRect) ? contentRect : null;
                        return (rect == null || (rectIntersect = rect.intersect(rectM4386Recttz77jQw)) == null) ? Rect.INSTANCE.getZero() : rectIntersect;
                    }
                    return Rect.INSTANCE.getZero();
                }
                return Rect.INSTANCE.getZero();
            }
        }).collect(new FlowCollector() {
            public Object emit(Object obj, Continuation continuation2) {
                return emit((Rect) obj, (Continuation<? super Unit>) continuation2);
            }

            public final Object emit(Rect rect, Continuation<? super Unit> continuation2) {
                if (Intrinsics.areEqual(rect, Rect.INSTANCE.getZero())) {
                    TextFieldSelectionState.this.hideTextToolbar();
                } else {
                    TextFieldSelectionState.this.showTextToolbar(rect);
                }
                return Unit.INSTANCE;
            }
        }, continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    public final Rect getContentRect() {
        float fM4347getYimpl;
        Rect cursorRect;
        Rect cursorRect2;
        TextFieldCharSequence visualText = this.textFieldState.getVisualText();
        if (TextRange.getCollapsed-impl(visualText.getSelection())) {
            Rect cursorRect3 = getCursorRect();
            LayoutCoordinates textLayoutCoordinates = getTextLayoutCoordinates();
            return RectKt.m4386Recttz77jQw(textLayoutCoordinates != null ? textLayoutCoordinates.mo6043localToRootMKHz9U(cursorRect3.m4381getTopLeftF1C5BW0()) : Offset.INSTANCE.m4362getZeroF1C5BW0(), cursorRect3.m4379getSizeNHjbRc());
        }
        LayoutCoordinates textLayoutCoordinates2 = getTextLayoutCoordinates();
        long jMo6043localToRootMKHz9U = textLayoutCoordinates2 != null ? textLayoutCoordinates2.mo6043localToRootMKHz9U(m1755getHandlePositiontuRUvjQ(true)) : Offset.INSTANCE.m4362getZeroF1C5BW0();
        LayoutCoordinates textLayoutCoordinates3 = getTextLayoutCoordinates();
        long jMo6043localToRootMKHz9U2 = textLayoutCoordinates3 != null ? textLayoutCoordinates3.mo6043localToRootMKHz9U(m1755getHandlePositiontuRUvjQ(false)) : Offset.INSTANCE.m4362getZeroF1C5BW0();
        LayoutCoordinates textLayoutCoordinates4 = getTextLayoutCoordinates();
        float fM4347getYimpl2 = 0.0f;
        if (textLayoutCoordinates4 != null) {
            TextLayoutResult layoutResult = this.textLayoutState.getLayoutResult();
            fM4347getYimpl = Offset.m4347getYimpl(textLayoutCoordinates4.mo6043localToRootMKHz9U(OffsetKt.Offset(0.0f, (layoutResult == null || (cursorRect2 = layoutResult.getCursorRect(TextRange.getStart-impl(visualText.getSelection()))) == null) ? 0.0f : cursorRect2.getTop())));
        } else {
            fM4347getYimpl = 0.0f;
        }
        LayoutCoordinates textLayoutCoordinates5 = getTextLayoutCoordinates();
        if (textLayoutCoordinates5 != null) {
            TextLayoutResult layoutResult2 = this.textLayoutState.getLayoutResult();
            fM4347getYimpl2 = Offset.m4347getYimpl(textLayoutCoordinates5.mo6043localToRootMKHz9U(OffsetKt.Offset(0.0f, (layoutResult2 == null || (cursorRect = layoutResult2.getCursorRect(TextRange.getEnd-impl(visualText.getSelection()))) == null) ? 0.0f : cursorRect.getTop())));
        }
        return new Rect(Math.min(Offset.m4346getXimpl(jMo6043localToRootMKHz9U), Offset.m4346getXimpl(jMo6043localToRootMKHz9U2)), Math.min(fM4347getYimpl, fM4347getYimpl2), Math.max(Offset.m4346getXimpl(jMo6043localToRootMKHz9U), Offset.m4346getXimpl(jMo6043localToRootMKHz9U2)), Math.max(Offset.m4347getYimpl(jMo6043localToRootMKHz9U), Offset.m4347getYimpl(jMo6043localToRootMKHz9U2)));
    }

    public final androidx.compose.foundation.text.input.internal.selection.TextFieldHandleState getSelectionHandleState$foundation_release(boolean r14, boolean r15) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState.getSelectionHandleState$foundation_release(boolean, boolean):androidx.compose.foundation.text.input.internal.selection.TextFieldHandleState");
    }

    public final long m1755getHandlePositiontuRUvjQ(boolean isStartHandle) {
        int i;
        TextLayoutResult layoutResult = this.textLayoutState.getLayoutResult();
        if (layoutResult == null) {
            return Offset.INSTANCE.m4362getZeroF1C5BW0();
        }
        long selection = this.textFieldState.getVisualText().getSelection();
        if (isStartHandle) {
            i = TextRange.getStart-impl(selection);
        } else {
            i = TextRange.getEnd-impl(selection);
        }
        return TextSelectionDelegateKt.getSelectionHandleCoordinates(layoutResult, i, isStartHandle, TextRange.getReversed-impl(selection));
    }

    public final void m1765updateHandleDraggingUv8p0NA(Handle handle, long position) {
        setDraggingHandle(handle);
        m1760setRawHandleDragPositionk4lQ0M(position);
    }

    public final void markStartContentVisibleOffset() {
        m1761setStartTextLayoutPositionInWindowk4lQ0M(m1754getCurrentTextLayoutPositionInWindowF1C5BW0());
    }

    public final void clearHandleDragging() {
        setDraggingHandle(null);
        m1760setRawHandleDragPositionk4lQ0M(Offset.INSTANCE.m4361getUnspecifiedF1C5BW0());
        m1761setStartTextLayoutPositionInWindowk4lQ0M(Offset.INSTANCE.m4361getUnspecifiedF1C5BW0());
    }

    public final boolean canCut() {
        return (TextRange.getCollapsed-impl(this.textFieldState.getVisualText().getSelection()) || !getEditable() || this.isPassword) ? false : true;
    }

    public final void cut() {
        TextFieldCharSequence visualText = this.textFieldState.getVisualText();
        if (TextRange.getCollapsed-impl(visualText.getSelection())) {
            return;
        }
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager != null) {
            clipboardManager.setText(new AnnotatedString(TextFieldCharSequenceKt.getSelectedText(visualText).toString(), (List) null, (List) null, 6, (DefaultConstructorMarker) null));
        }
        this.textFieldState.deleteSelectedText();
    }

    public final boolean canCopy() {
        return (TextRange.getCollapsed-impl(this.textFieldState.getVisualText().getSelection()) || this.isPassword) ? false : true;
    }

    public static void copy$default(TextFieldSelectionState textFieldSelectionState, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        textFieldSelectionState.copy(z);
    }

    public final void copy(boolean cancelSelection) {
        TextFieldCharSequence visualText = this.textFieldState.getVisualText();
        if (TextRange.getCollapsed-impl(visualText.getSelection())) {
            return;
        }
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager != null) {
            clipboardManager.setText(new AnnotatedString(TextFieldCharSequenceKt.getSelectedText(visualText).toString(), (List) null, (List) null, 6, (DefaultConstructorMarker) null));
        }
        if (cancelSelection) {
            this.textFieldState.collapseSelectionToMax();
        }
    }

    public final boolean canPaste() {
        if (!getEditable()) {
            return false;
        }
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager != null && clipboardManager.hasText()) {
            return true;
        }
        Function0<? extends ReceiveContentConfiguration> function0 = this.receiveContentConfiguration;
        if ((function0 != null ? (ReceiveContentConfiguration) function0.invoke() : null) == null) {
            return false;
        }
        ClipboardManager clipboardManager2 = this.clipboardManager;
        return (clipboardManager2 != null ? clipboardManager2.getClip() : null) != null;
    }

    public final void paste() {
        ReceiveContentConfiguration receiveContentConfiguration;
        ClipEntry clip;
        ClipEntry clipEntry;
        String plainText;
        Function0<? extends ReceiveContentConfiguration> function0 = this.receiveContentConfiguration;
        if (function0 == null || (receiveContentConfiguration = (ReceiveContentConfiguration) function0.invoke()) == null) {
            pasteAsPlainText();
            return;
        }
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager == null || (clip = clipboardManager.getClip()) == null) {
            pasteAsPlainText();
            return;
        }
        TransferableContent transferableContentOnReceive = receiveContentConfiguration.getReceiveContentListener().onReceive(new TransferableContent(clip, clip.getClipMetadata(), TransferableContent.Source.INSTANCE.m637getClipboardkB6V9T0(), null, 8, null));
        if (transferableContentOnReceive == null || (clipEntry = transferableContentOnReceive.getClipEntry()) == null || (plainText = TransferableContent_androidKt.readPlainText(clipEntry)) == null) {
            return;
        }
        TransformedTextFieldState.replaceSelectedText$default(this.textFieldState, plainText, false, TextFieldEditUndoBehavior.NeverMerge, 2, null);
    }

    private final void pasteAsPlainText() {
        AnnotatedString text;
        String text2;
        ClipboardManager clipboardManager = this.clipboardManager;
        if (clipboardManager == null || (text = clipboardManager.getText()) == null || (text2 = text.getText()) == null) {
            return;
        }
        TransformedTextFieldState.replaceSelectedText$default(this.textFieldState, text2, false, TextFieldEditUndoBehavior.NeverMerge, 2, null);
    }

    public final boolean canSelectAll() {
        return TextRange.getLength-impl(this.textFieldState.getVisualText().getSelection()) != this.textFieldState.getVisualText().length();
    }

    public final void selectAll() {
        this.textFieldState.selectAll();
    }

    public final void showTextToolbar(Rect contentRect) {
        TextToolbar textToolbar = this.textToolbar;
        if (textToolbar != null) {
            boolean zCanCopy = canCopy();
            final TextToolbarState textToolbarState = TextToolbarState.None;
            Function0<Unit> function0 = !zCanCopy ? null : new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1796invoke();
                    return Unit.INSTANCE;
                }

                public final void m1796invoke() {
                    TextFieldSelectionState.copy$default(this, false, 1, null);
                    this.this$0$inline_fun.updateTextToolbarState(textToolbarState);
                }
            };
            boolean zCanPaste = canPaste();
            final TextToolbarState textToolbarState2 = TextToolbarState.None;
            Function0<Unit> function1 = !zCanPaste ? null : new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1797invoke();
                    return Unit.INSTANCE;
                }

                public final void m1797invoke() {
                    this.paste();
                    this.this$0$inline_fun.updateTextToolbarState(textToolbarState2);
                }
            };
            boolean zCanCut = canCut();
            final TextToolbarState textToolbarState3 = TextToolbarState.None;
            Function0<Unit> function2 = !zCanCut ? null : new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1798invoke();
                    return Unit.INSTANCE;
                }

                public final void m1798invoke() {
                    this.cut();
                    this.this$0$inline_fun.updateTextToolbarState(textToolbarState3);
                }
            };
            boolean zCanSelectAll = canSelectAll();
            final TextToolbarState textToolbarState4 = TextToolbarState.Selection;
            textToolbar.showMenu(contentRect, function0, function1, function2, !zCanSelectAll ? null : new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1799invoke();
                    return Unit.INSTANCE;
                }

                public final void m1799invoke() {
                    this.selectAll();
                    this.this$0$inline_fun.updateTextToolbarState(textToolbarState4);
                }
            });
        }
    }

    private final Function0<Unit> menuItem(boolean enabled, final TextToolbarState desiredState, final Function0<Unit> operation) {
        if (enabled) {
            return new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1792invoke();
                    return Unit.INSTANCE;
                }

                public final void m1792invoke() {
                    operation.invoke();
                    this.updateTextToolbarState(desiredState);
                }
            };
        }
        return null;
    }

    public final void deselect() {
        if (!TextRange.getCollapsed-impl(this.textFieldState.getVisualText().getSelection())) {
            this.textFieldState.collapseSelectionToEnd();
        }
        setShowCursorHandle(false);
        updateTextToolbarState(TextToolbarState.None);
    }

    public final void hideTextToolbar() {
        TextToolbar textToolbar;
        TextToolbar textToolbar2 = this.textToolbar;
        if ((textToolbar2 != null ? textToolbar2.getStatus() : null) != TextToolbarStatus.Shown || (textToolbar = this.textToolbar) == null) {
            return;
        }
        textToolbar.hide();
    }

    static long m1763updateSelectionSsLRf8$default(TextFieldSelectionState textFieldSelectionState, TextFieldCharSequence textFieldCharSequence, int i, int i2, boolean z, SelectionAdjustment selectionAdjustment, boolean z2, boolean z3, int i3, Object obj) {
        return textFieldSelectionState.m1762updateSelectionSsLRf8(textFieldCharSequence, i, i2, z, selectionAdjustment, (i3 & 32) != 0 ? false : z2, (i3 & 64) != 0 ? false : z3);
    }

    public final long m1762updateSelectionSsLRf8(TextFieldCharSequence textFieldCharSequence, int startOffset, int endOffset, boolean isStartHandle, SelectionAdjustment adjustment, boolean allowPreviousSelectionCollapsed, boolean isStartOfSelection) {
        HapticFeedback hapticFeedback;
        TextRange textRange = TextRange.box-impl(textFieldCharSequence.getSelection());
        long j = textRange.unbox-impl();
        if (isStartOfSelection || (!allowPreviousSelectionCollapsed && TextRange.getCollapsed-impl(j))) {
            textRange = null;
        }
        long jM1758getTextFieldSelectionqeG_v_k = m1758getTextFieldSelectionqeG_v_k(startOffset, endOffset, textRange, isStartHandle, adjustment);
        if (TextRange.equals-impl0(jM1758getTextFieldSelectionqeG_v_k, textFieldCharSequence.getSelection())) {
            return jM1758getTextFieldSelectionqeG_v_k;
        }
        boolean z = TextRange.getReversed-impl(jM1758getTextFieldSelectionqeG_v_k) != TextRange.getReversed-impl(textFieldCharSequence.getSelection()) && TextRange.equals-impl0(TextRangeKt.TextRange(TextRange.getEnd-impl(jM1758getTextFieldSelectionqeG_v_k), TextRange.getStart-impl(jM1758getTextFieldSelectionqeG_v_k)), textFieldCharSequence.getSelection());
        if (isInTouchMode() && !z && (hapticFeedback = this.hapticFeedBack) != null) {
            hapticFeedback.mo5360performHapticFeedbackCdsT49E(HapticFeedbackType.INSTANCE.m5369getTextHandleMove5zf0vsI());
        }
        return jM1758getTextFieldSelectionqeG_v_k;
    }

    private final long m1758getTextFieldSelectionqeG_v_k(int rawStartOffset, int rawEndOffset, TextRange previousSelection, boolean isStartHandle, SelectionAdjustment adjustment) {
        TextLayoutResult layoutResult = this.textLayoutState.getLayoutResult();
        if (layoutResult == null) {
            return TextRange.Companion.getZero-d9O1mEE();
        }
        if (previousSelection == null && Intrinsics.areEqual(adjustment, SelectionAdjustment.INSTANCE.getCharacter())) {
            return TextRangeKt.TextRange(rawStartOffset, rawEndOffset);
        }
        SelectionLayout selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA = SelectionLayoutKt.m1878getTextFieldSelectionLayoutRcvTLA(layoutResult, rawStartOffset, rawEndOffset, this.previousRawDragOffset, previousSelection != null ? previousSelection.unbox-impl() : TextRange.Companion.getZero-d9O1mEE(), previousSelection == null, isStartHandle);
        if (previousSelection != null && !selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA.shouldRecomputeSelection(this.previousSelectionLayout)) {
            return previousSelection.unbox-impl();
        }
        long jM1863toTextRanged9O1mEE = adjustment.adjust(selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA).m1863toTextRanged9O1mEE();
        this.previousSelectionLayout = selectionLayoutM1878getTextFieldSelectionLayoutRcvTLA;
        if (!isStartHandle) {
            rawStartOffset = rawEndOffset;
        }
        this.previousRawDragOffset = rawStartOffset;
        return jM1863toTextRanged9O1mEE;
    }
}
