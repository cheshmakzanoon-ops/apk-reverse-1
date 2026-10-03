package androidx.compose.foundation.text.input.internal;

import android.view.KeyEvent;
import androidx.compose.foundation.content.MediaType;
import androidx.compose.foundation.content.ReceiveContentListener;
import androidx.compose.foundation.content.TransferableContent;
import androidx.compose.foundation.content.TransferableContent_androidKt;
import androidx.compose.foundation.content.internal.DragAndDropRequestPermission_androidKt;
import androidx.compose.foundation.content.internal.ReceiveContentConfiguration;
import androidx.compose.foundation.content.internal.ReceiveContentConfigurationKt;
import androidx.compose.foundation.interaction.HoverInteraction;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.text.Handle;
import androidx.compose.foundation.text.KeyboardOptions;
import androidx.compose.foundation.text.handwriting.StylusHandwritingNode;
import androidx.compose.foundation.text.handwriting.StylusHandwriting_androidKt;
import androidx.compose.foundation.text.input.InputTransformation;
import androidx.compose.foundation.text.input.KeyboardActionHandler;
import androidx.compose.foundation.text.input.TextFieldCharSequence;
import androidx.compose.foundation.text.input.TextFieldState;
import androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState;
import androidx.compose.foundation.text.input.internal.selection.TextToolbarState;
import androidx.compose.foundation.text.input.internal.undo.TextFieldEditUndoBehavior;
import androidx.compose.p002ui.draganddrop.DragAndDropEvent;
import androidx.compose.p002ui.draganddrop.DragAndDropModifierNode;
import androidx.compose.p002ui.focus.FocusEventModifierNode;
import androidx.compose.p002ui.focus.FocusManager;
import androidx.compose.p002ui.focus.FocusRequesterModifierNode;
import androidx.compose.p002ui.focus.FocusRequesterModifierNodeKt;
import androidx.compose.p002ui.focus.FocusState;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.input.key.KeyInputModifierNode;
import androidx.compose.p002ui.input.pointer.PointerEvent;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputModifierNode;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.modifier.EmptyMap;
import androidx.compose.p002ui.modifier.ModifierLocal;
import androidx.compose.p002ui.modifier.ModifierLocalMap;
import androidx.compose.p002ui.modifier.ModifierLocalModifierNode;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNode;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNodeKt;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.p002ui.node.GlobalPositionAwareModifierNode;
import androidx.compose.p002ui.node.LayoutAwareModifierNode;
import androidx.compose.p002ui.node.ObserverModifierNode;
import androidx.compose.p002ui.node.ObserverModifierNodeKt;
import androidx.compose.p002ui.node.PointerInputModifierNode;
import androidx.compose.p002ui.node.SemanticsModifierNode;
import androidx.compose.p002ui.node.SemanticsModifierNodeKt;
import androidx.compose.p002ui.platform.ClipEntry;
import androidx.compose.p002ui.platform.ClipMetadata;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.platform.PlatformTextInputModifierNode;
import androidx.compose.p002ui.platform.PlatformTextInputModifierNodeKt;
import androidx.compose.p002ui.platform.PlatformTextInputSessionScope;
import androidx.compose.p002ui.platform.SoftwareKeyboardController;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.p002ui.platform.WindowInfo;
import androidx.compose.p002ui.semantics.SemanticsPropertiesKt;
import androidx.compose.p002ui.semantics.SemanticsPropertyReceiver;
import androidx.compose.ui.text.AnnotatedString;
import androidx.compose.ui.text.TextLayoutResult;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import androidx.compose.ui.text.input.ImeAction;
import androidx.compose.ui.text.input.KeyboardType;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CancellationException;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.FunctionReferenceImpl;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.channels.BufferOverflow;
import kotlinx.coroutines.flow.MutableSharedFlow;
import kotlinx.coroutines.flow.SharedFlowKt;

@Metadata(d1 = {"\u0000\u0081\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000*\u0001>\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u00042\u00020\u00052\u00020\u00062\u00020\u00072\u00020\b2\u00020\t2\u00020\n2\u00020\u000b2\u00020\fBY\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0012\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014\u0012\u0006\u0010\u0015\u001a\u00020\u0016\u0012\u0006\u0010\u0017\u001a\u00020\u0016\u0012\u0006\u0010\u0018\u001a\u00020\u0019\u0012\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b\u0012\u0006\u0010\u001c\u001a\u00020\u0016\u0012\u0006\u0010\u001d\u001a\u00020\u001e¢\u0006\u0002\u0010\u001fJ\b\u0010d\u001a\u00020\"H\u0002J\b\u0010e\u001a\u00020\"H\u0002J\b\u0010f\u001a\u00020\"H\u0016J\b\u0010g\u001a\u00020\"H\u0016J\b\u0010h\u001a\u00020\"H\u0016J\b\u0010i\u001a\u00020\"H\u0002J\u0010\u0010j\u001a\u00020\"2\u0006\u0010k\u001a\u00020lH\u0016J\u0010\u0010m\u001a\u00020\"2\u0006\u0010n\u001a\u00020oH\u0016J\u001a\u0010p\u001a\u00020\"2\u0006\u0010q\u001a\u00020rH\u0002ø\u0001\u0000¢\u0006\u0004\bs\u0010tJ\u001a\u0010u\u001a\u00020\u00162\u0006\u0010v\u001a\u00020wH\u0016ø\u0001\u0000¢\u0006\u0004\bx\u0010yJ\b\u0010z\u001a\u00020\"H\u0016J.\u0010{\u001a\u00020\"2\u0006\u0010|\u001a\u00020}2\u0006\u0010~\u001a\u00020\u007f2\b\u0010\u0080\u0001\u001a\u00030\u0081\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\b\u0082\u0001\u0010\u0083\u0001J\u001c\u0010\u0084\u0001\u001a\u00020\u00162\u0006\u0010v\u001a\u00020wH\u0016ø\u0001\u0000¢\u0006\u0005\b\u0085\u0001\u0010yJ\n\u0010\u0086\u0001\u001a\u00030\u0087\u0001H\u0002J\u0012\u0010\u0088\u0001\u001a\u00020\"2\u0007\u0010\u0089\u0001\u001a\u00020\u0016H\u0002J[\u0010\u008a\u0001\u001a\u00020\"2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00162\u0006\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001b2\u0006\u0010\u001c\u001a\u00020\u00162\u0006\u0010\u001d\u001a\u00020\u001eJ\u000e\u0010\u008b\u0001\u001a\u00020\"*\u00030\u008c\u0001H\u0016R\u0016\u0010 \u001a\n\u0012\u0004\u0012\u00020\"\u0018\u00010!X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010#\u001a\u00020$X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010%\u001a\u0004\u0018\u00010&X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010'\u001a\u00020\u00168BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b(\u0010)R\u001a\u0010\u0015\u001a\u00020\u0016X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b*\u0010)\"\u0004\b+\u0010,R\u001c\u0010\u0013\u001a\u0004\u0018\u00010\u0014X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b-\u0010.\"\u0004\b/\u00100R\u0010\u00101\u001a\u0004\u0018\u000102X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u001d\u001a\u00020\u001eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b3\u00104\"\u0004\b5\u00106R\u000e\u00107\u001a\u00020\u0016X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u00108\u001a\u00020\u00168BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b8\u0010)R\u001c\u0010\u001a\u001a\u0004\u0018\u00010\u001bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b9\u0010:\"\u0004\b;\u0010<R\u0010\u0010=\u001a\u00020>X\u0082\u0004¢\u0006\u0004\n\u0002\u0010?R\u001e\u0010\u0018\u001a\u00020\u00192\u0006\u0010@\u001a\u00020\u0019@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\bA\u0010BR\u0010\u0010C\u001a\u0004\u0018\u000102X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010D\u001a\u00020EX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0017\u001a\u00020\u0016X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bF\u0010)\"\u0004\bG\u0010,R\u0016\u0010H\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010J0IX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010K\u001a\u00020\u00168VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bL\u0010)R\u001a\u0010\u001c\u001a\u00020\u0016X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bM\u0010)\"\u0004\bN\u0010,R\u000e\u0010O\u001a\u00020PX\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010Q\u001a\n\u0012\u0004\u0012\u00020\"\u0018\u00010!8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\bR\u0010SR\u000e\u0010T\u001a\u00020UX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0011\u001a\u00020\u0012X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bV\u0010W\"\u0004\bX\u0010YR\u001a\u0010\r\u001a\u00020\u000eX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bZ\u0010[\"\u0004\b\\\u0010]R\u001a\u0010\u000f\u001a\u00020\u0010X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b^\u0010_\"\u0004\b`\u0010aR\u0010\u0010b\u001a\u0004\u0018\u00010cX\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u008d\u0001"}, d2 = {"Landroidx/compose/foundation/text/input/internal/TextFieldDecoratorModifierNode;", "Landroidx/compose/ui/node/DelegatingNode;", "Landroidx/compose/ui/platform/PlatformTextInputModifierNode;", "Landroidx/compose/ui/node/SemanticsModifierNode;", "Landroidx/compose/ui/focus/FocusRequesterModifierNode;", "Landroidx/compose/ui/focus/FocusEventModifierNode;", "Landroidx/compose/ui/node/GlobalPositionAwareModifierNode;", "Landroidx/compose/ui/node/PointerInputModifierNode;", "Landroidx/compose/ui/input/key/KeyInputModifierNode;", "Landroidx/compose/ui/node/CompositionLocalConsumerModifierNode;", "Landroidx/compose/ui/modifier/ModifierLocalModifierNode;", "Landroidx/compose/ui/node/ObserverModifierNode;", "Landroidx/compose/ui/node/LayoutAwareModifierNode;", "textFieldState", "Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "textLayoutState", "Landroidx/compose/foundation/text/input/internal/TextLayoutState;", "textFieldSelectionState", "Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;", "filter", "Landroidx/compose/foundation/text/input/InputTransformation;", "enabled", "", "readOnly", "keyboardOptions", "Landroidx/compose/foundation/text/KeyboardOptions;", "keyboardActionHandler", "Landroidx/compose/foundation/text/input/KeyboardActionHandler;", "singleLine", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;Landroidx/compose/foundation/text/input/internal/TextLayoutState;Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;Landroidx/compose/foundation/text/input/InputTransformation;ZZLandroidx/compose/foundation/text/KeyboardOptions;Landroidx/compose/foundation/text/input/KeyboardActionHandler;ZLandroidx/compose/foundation/interaction/MutableInteractionSource;)V", "backingStylusHandwritingTrigger", "Lkotlinx/coroutines/flow/MutableSharedFlow;", "", "dragAndDropNode", "Landroidx/compose/ui/draganddrop/DragAndDropModifierNode;", "dragEnterEvent", "Landroidx/compose/foundation/interaction/HoverInteraction$Enter;", "editable", "getEditable", "()Z", "getEnabled", "setEnabled", "(Z)V", "getFilter", "()Landroidx/compose/foundation/text/input/InputTransformation;", "setFilter", "(Landroidx/compose/foundation/text/input/InputTransformation;)V", "inputSessionJob", "Lkotlinx/coroutines/Job;", "getInteractionSource", "()Landroidx/compose/foundation/interaction/MutableInteractionSource;", "setInteractionSource", "(Landroidx/compose/foundation/interaction/MutableInteractionSource;)V", "isElementFocused", "isFocused", "getKeyboardActionHandler", "()Landroidx/compose/foundation/text/input/KeyboardActionHandler;", "setKeyboardActionHandler", "(Landroidx/compose/foundation/text/input/KeyboardActionHandler;)V", "keyboardActionScope", "androidx/compose/foundation/text/input/internal/TextFieldDecoratorModifierNode$keyboardActionScope$1", "Landroidx/compose/foundation/text/input/internal/TextFieldDecoratorModifierNode$keyboardActionScope$1;", "<set-?>", "getKeyboardOptions", "()Landroidx/compose/foundation/text/KeyboardOptions;", "observeChangesJob", "pointerInputNode", "Landroidx/compose/ui/input/pointer/SuspendingPointerInputModifierNode;", "getReadOnly", "setReadOnly", "receiveContentConfigurationProvider", "Lkotlin/Function0;", "Landroidx/compose/foundation/content/internal/ReceiveContentConfiguration;", "shouldMergeDescendantSemantics", "getShouldMergeDescendantSemantics", "getSingleLine", "setSingleLine", "stylusHandwritingNode", "Landroidx/compose/foundation/text/handwriting/StylusHandwritingNode;", "stylusHandwritingTrigger", "getStylusHandwritingTrigger", "()Lkotlinx/coroutines/flow/MutableSharedFlow;", "textFieldKeyEventHandler", "Landroidx/compose/foundation/text/input/internal/TextFieldKeyEventHandler;", "getTextFieldSelectionState", "()Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;", "setTextFieldSelectionState", "(Landroidx/compose/foundation/text/input/internal/selection/TextFieldSelectionState;)V", "getTextFieldState", "()Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "setTextFieldState", "(Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;)V", "getTextLayoutState", "()Landroidx/compose/foundation/text/input/internal/TextLayoutState;", "setTextLayoutState", "(Landroidx/compose/foundation/text/input/internal/TextLayoutState;)V", "windowInfo", "Landroidx/compose/ui/platform/WindowInfo;", "disposeInputSession", "emitDragExitEvent", "onAttach", "onCancelPointerInput", "onDetach", "onFocusChange", "onFocusEvent", "focusState", "Landroidx/compose/ui/focus/FocusState;", "onGloballyPositioned", "coordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "onImeActionPerformed", "imeAction", "Landroidx/compose/ui/text/input/ImeAction;", "onImeActionPerformed-KlQnJC8", "(I)V", "onKeyEvent", "event", "Landroidx/compose/ui/input/key/KeyEvent;", "onKeyEvent-ZmokQxo", "(Landroid/view/KeyEvent;)Z", "onObservedReadsChanged", "onPointerEvent", "pointerEvent", "Landroidx/compose/ui/input/pointer/PointerEvent;", "pass", "Landroidx/compose/ui/input/pointer/PointerEventPass;", "bounds", "Landroidx/compose/ui/unit/IntSize;", "onPointerEvent-H0pRuoY", "(Landroidx/compose/ui/input/pointer/PointerEvent;Landroidx/compose/ui/input/pointer/PointerEventPass;J)V", "onPreKeyEvent", "onPreKeyEvent-ZmokQxo", "requireKeyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "startInputSession", "fromTap", "updateNode", "applySemantics", "Landroidx/compose/ui/semantics/SemanticsPropertyReceiver;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TextFieldDecoratorModifierNode extends DelegatingNode implements PlatformTextInputModifierNode, SemanticsModifierNode, FocusRequesterModifierNode, FocusEventModifierNode, GlobalPositionAwareModifierNode, PointerInputModifierNode, KeyInputModifierNode, CompositionLocalConsumerModifierNode, ModifierLocalModifierNode, ObserverModifierNode, LayoutAwareModifierNode {
    public static final int $stable = 8;
    private MutableSharedFlow<Unit> backingStylusHandwritingTrigger;
    private HoverInteraction.Enter dragEnterEvent;
    private boolean enabled;
    private InputTransformation filter;
    private Job inputSessionJob;
    private MutableInteractionSource interactionSource;
    private boolean isElementFocused;
    private KeyboardActionHandler keyboardActionHandler;
    private final TextFieldDecoratorModifierNode$keyboardActionScope$1 keyboardActionScope;
    private KeyboardOptions keyboardOptions;
    private Job observeChangesJob;
    private boolean readOnly;
    private final Function0<ReceiveContentConfiguration> receiveContentConfigurationProvider;
    private boolean singleLine;
    private final StylusHandwritingNode stylusHandwritingNode;
    private final TextFieldKeyEventHandler textFieldKeyEventHandler;
    private TextFieldSelectionState textFieldSelectionState;
    private TransformedTextFieldState textFieldState;
    private TextLayoutState textLayoutState;
    private WindowInfo windowInfo;
    private final SuspendingPointerInputModifierNode pointerInputNode = (SuspendingPointerInputModifierNode) delegate(SuspendingPointerInputFilterKt.SuspendingPointerInputModifierNode(new TextFieldDecoratorModifierNode$pointerInputNode$1(this, null)));
    private final DragAndDropModifierNode dragAndDropNode = (DragAndDropModifierNode) delegate(TextFieldDragAndDropNode_androidKt.textFieldDragAndDropNode(new Function0<Set<? extends MediaType>>() {
        {
            super(0);
        }

        public final Set<MediaType> invoke() {
            return ReceiveContentConfigurationKt.getReceiveContentConfiguration(this.this$0) != null ? TextFieldDecoratorModifierKt.MediaTypesAll : TextFieldDecoratorModifierKt.MediaTypesText;
        }
    }, new Function2<ClipEntry, ClipMetadata, Boolean>() {
        {
            super(2);
        }

        public final Boolean invoke(ClipEntry clipEntry, ClipMetadata clipMetadata) {
            ClipEntry clipEntry2;
            this.this$0.emitDragExitEvent();
            this.this$0.getTextFieldSelectionState().clearHandleDragging();
            String plainText = TransferableContent_androidKt.readPlainText(clipEntry);
            ReceiveContentConfiguration receiveContentConfiguration = ReceiveContentConfigurationKt.getReceiveContentConfiguration(this.this$0);
            if (receiveContentConfiguration != null) {
                TransferableContent transferableContentOnReceive = receiveContentConfiguration.getReceiveContentListener().onReceive(new TransferableContent(clipEntry, clipMetadata, TransferableContent.Source.INSTANCE.m638getDragAndDropkB6V9T0(), null, 8, null));
                plainText = (transferableContentOnReceive == null || (clipEntry2 = transferableContentOnReceive.getClipEntry()) == null) ? null : TransferableContent_androidKt.readPlainText(clipEntry2);
            }
            if (plainText != null) {
                TransformedTextFieldState.replaceSelectedText$default(this.this$0.getTextFieldState(), plainText, false, null, 6, null);
            }
            return true;
        }
    }, new Function1<DragAndDropEvent, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((DragAndDropEvent) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(DragAndDropEvent dragAndDropEvent) {
            if (ReceiveContentConfigurationKt.getReceiveContentConfiguration(this.this$0) != null) {
                DragAndDropRequestPermission_androidKt.dragAndDropRequestPermission(this.this$0, dragAndDropEvent);
            }
        }
    }, (72 & 8) != 0 ? null : null, (72 & 16) != 0 ? null : new Function1<DragAndDropEvent, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((DragAndDropEvent) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(DragAndDropEvent dragAndDropEvent) {
            ReceiveContentListener receiveContentListener;
            TextFieldDecoratorModifierNode textFieldDecoratorModifierNode = this.this$0;
            HoverInteraction.Enter enter = new HoverInteraction.Enter();
            this.this$0.getInteractionSource().tryEmit(enter);
            textFieldDecoratorModifierNode.dragEnterEvent = enter;
            ReceiveContentConfiguration receiveContentConfiguration = ReceiveContentConfigurationKt.getReceiveContentConfiguration(this.this$0);
            if (receiveContentConfiguration == null || (receiveContentListener = receiveContentConfiguration.getReceiveContentListener()) == null) {
                return;
            }
            receiveContentListener.onDragEnter();
        }
    }, (72 & 32) != 0 ? null : new Function1<Offset, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            m1687invokek4lQ0M(((Offset) obj).getPackedValue());
            return Unit.INSTANCE;
        }

        public final void m1687invokek4lQ0M(long j) {
            long jM1716fromWindowToDecorationUv8p0NA = TextLayoutStateKt.m1716fromWindowToDecorationUv8p0NA(this.this$0.getTextLayoutState(), j);
            this.this$0.getTextFieldState().m1726selectCharsIn5zctL8(TextRangeKt.TextRange(TextLayoutState.m1705getOffsetForPosition3MmeM6k$default(this.this$0.getTextLayoutState(), jM1716fromWindowToDecorationUv8p0NA, false, 2, null)));
            this.this$0.getTextFieldSelectionState().m1765updateHandleDraggingUv8p0NA(Handle.Cursor, jM1716fromWindowToDecorationUv8p0NA);
        }
    }, (72 & 64) != 0 ? null : null, (72 & Fields.SpotShadowColor) != 0 ? null : new Function1<DragAndDropEvent, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((DragAndDropEvent) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(DragAndDropEvent dragAndDropEvent) {
            ReceiveContentListener receiveContentListener;
            this.this$0.emitDragExitEvent();
            this.this$0.getTextFieldSelectionState().clearHandleDragging();
            ReceiveContentConfiguration receiveContentConfiguration = ReceiveContentConfigurationKt.getReceiveContentConfiguration(this.this$0);
            if (receiveContentConfiguration == null || (receiveContentListener = receiveContentConfiguration.getReceiveContentListener()) == null) {
                return;
            }
            receiveContentListener.onDragExit();
        }
    }, (72 & Fields.RotationX) != 0 ? null : new Function1<DragAndDropEvent, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((DragAndDropEvent) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(DragAndDropEvent dragAndDropEvent) {
            this.this$0.emitDragExitEvent();
        }
    }));

    @Override
    public Object getCurrent(ModifierLocal modifierLocal) {
        return ModifierLocalModifierNode.CC.$default$getCurrent(this, modifierLocal);
    }

    @Override
    public ModifierLocalMap getProvidedValues() {
        return EmptyMap.INSTANCE;
    }

    @Override
    public boolean getIsClearingSemantics() {
        return SemanticsModifierNode.CC.$default$getShouldClearDescendantSemantics(this);
    }

    @Override
    public boolean getShouldMergeDescendantSemantics() {
        return true;
    }

    @Override
    public boolean interceptOutOfBoundsChildEvents() {
        return PointerInputModifierNode.CC.$default$interceptOutOfBoundsChildEvents(this);
    }

    @Override
    public void onDensityChange() {
        onCancelPointerInput();
    }

    @Override
    public void onPlaced(LayoutCoordinates layoutCoordinates) {
        LayoutAwareModifierNode.CC.$default$onPlaced(this, layoutCoordinates);
    }

    @Override
    public void mo666onRemeasuredozmzZPI(long j) {
        LayoutAwareModifierNode.CC.m6224$default$onRemeasuredozmzZPI(this, j);
    }

    @Override
    public void onViewConfigurationChange() {
        onCancelPointerInput();
    }

    @Override
    public void provide(ModifierLocal modifierLocal, Object obj) {
        ModifierLocalModifierNode.CC.$default$provide(this, modifierLocal, obj);
    }

    @Override
    public boolean sharePointerInputWithSiblings() {
        return PointerInputModifierNode.CC.$default$sharePointerInputWithSiblings(this);
    }

    public final TransformedTextFieldState getTextFieldState() {
        return this.textFieldState;
    }

    public final void setTextFieldState(TransformedTextFieldState transformedTextFieldState) {
        this.textFieldState = transformedTextFieldState;
    }

    public final TextLayoutState getTextLayoutState() {
        return this.textLayoutState;
    }

    public final void setTextLayoutState(TextLayoutState textLayoutState) {
        this.textLayoutState = textLayoutState;
    }

    public final TextFieldSelectionState getTextFieldSelectionState() {
        return this.textFieldSelectionState;
    }

    public final void setTextFieldSelectionState(TextFieldSelectionState textFieldSelectionState) {
        this.textFieldSelectionState = textFieldSelectionState;
    }

    public final InputTransformation getFilter() {
        return this.filter;
    }

    public final void setFilter(InputTransformation inputTransformation) {
        this.filter = inputTransformation;
    }

    public final boolean getEnabled() {
        return this.enabled;
    }

    public final void setEnabled(boolean z) {
        this.enabled = z;
    }

    public final boolean getReadOnly() {
        return this.readOnly;
    }

    public final void setReadOnly(boolean z) {
        this.readOnly = z;
    }

    public final KeyboardActionHandler getKeyboardActionHandler() {
        return this.keyboardActionHandler;
    }

    public final void setKeyboardActionHandler(KeyboardActionHandler keyboardActionHandler) {
        this.keyboardActionHandler = keyboardActionHandler;
    }

    public final boolean getSingleLine() {
        return this.singleLine;
    }

    public final void setSingleLine(boolean z) {
        this.singleLine = z;
    }

    public final MutableInteractionSource getInteractionSource() {
        return this.interactionSource;
    }

    public final void setInteractionSource(MutableInteractionSource mutableInteractionSource) {
        this.interactionSource = mutableInteractionSource;
    }

    public TextFieldDecoratorModifierNode(TransformedTextFieldState transformedTextFieldState, TextLayoutState textLayoutState, TextFieldSelectionState textFieldSelectionState, InputTransformation inputTransformation, boolean z, boolean z2, final KeyboardOptions keyboardOptions, KeyboardActionHandler keyboardActionHandler, boolean z3, MutableInteractionSource mutableInteractionSource) {
        this.textFieldState = transformedTextFieldState;
        this.textLayoutState = textLayoutState;
        this.textFieldSelectionState = textFieldSelectionState;
        this.filter = inputTransformation;
        this.enabled = z;
        this.readOnly = z2;
        this.keyboardActionHandler = keyboardActionHandler;
        this.singleLine = z3;
        this.interactionSource = mutableInteractionSource;
        this.stylusHandwritingNode = (StylusHandwritingNode) delegate(new StylusHandwritingNode(new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m1695invoke() {
                MutableSharedFlow stylusHandwritingTrigger;
                if (!this.this$0.isFocused()) {
                    FocusRequesterModifierNodeKt.requestFocus(this.this$0);
                }
                if (!KeyboardType.equals-impl0(keyboardOptions.getKeyboardType(), KeyboardType.Companion.getPassword-PjHm6EE()) && !KeyboardType.equals-impl0(keyboardOptions.getKeyboardType(), KeyboardType.Companion.getNumberPassword-PjHm6EE()) && (stylusHandwritingTrigger = this.this$0.getStylusHandwritingTrigger()) != null) {
                    stylusHandwritingTrigger.tryEmit(Unit.INSTANCE);
                }
                return true;
            }
        }));
        InputTransformation inputTransformation2 = this.filter;
        this.keyboardOptions = keyboardOptions.fillUnspecifiedValuesWith$foundation_release(inputTransformation2 != null ? inputTransformation2.getKeyboardOptions() : null);
        this.textFieldKeyEventHandler = TextFieldKeyEventHandler_androidKt.createTextFieldKeyEventHandler();
        this.keyboardActionScope = new TextFieldDecoratorModifierNode$keyboardActionScope$1(this);
        this.receiveContentConfigurationProvider = new Function0<ReceiveContentConfiguration>() {
            {
                super(0);
            }

            public final ReceiveContentConfiguration m1693invoke() {
                return ReceiveContentConfigurationKt.getReceiveContentConfiguration(this.this$0);
            }
        };
    }

    public final boolean getEditable() {
        return this.enabled && !this.readOnly;
    }

    public final MutableSharedFlow<Unit> getStylusHandwritingTrigger() {
        MutableSharedFlow<Unit> mutableSharedFlow = this.backingStylusHandwritingTrigger;
        if (mutableSharedFlow != null) {
            return mutableSharedFlow;
        }
        if (!StylusHandwriting_androidKt.isStylusHandwritingSupported()) {
            return null;
        }
        MutableSharedFlow<Unit> mutableSharedFlowMutableSharedFlow$default = SharedFlowKt.MutableSharedFlow$default(1, 0, BufferOverflow.DROP_LATEST, 2, (Object) null);
        this.backingStylusHandwritingTrigger = mutableSharedFlowMutableSharedFlow$default;
        return mutableSharedFlowMutableSharedFlow$default;
    }

    public final KeyboardOptions getKeyboardOptions() {
        return this.keyboardOptions;
    }

    public final boolean isFocused() {
        WindowInfo windowInfo = this.windowInfo;
        return this.isElementFocused && (windowInfo != null && windowInfo.isWindowFocused());
    }

    public final void updateNode(TransformedTextFieldState textFieldState, TextLayoutState textLayoutState, TextFieldSelectionState textFieldSelectionState, InputTransformation filter, boolean enabled, boolean readOnly, KeyboardOptions keyboardOptions, KeyboardActionHandler keyboardActionHandler, boolean singleLine, MutableInteractionSource interactionSource) {
        boolean z = this.enabled;
        boolean z2 = z && !this.readOnly;
        boolean z3 = enabled && !readOnly;
        TransformedTextFieldState transformedTextFieldState = this.textFieldState;
        KeyboardOptions keyboardOptions2 = this.keyboardOptions;
        TextFieldSelectionState textFieldSelectionState2 = this.textFieldSelectionState;
        MutableInteractionSource mutableInteractionSource = this.interactionSource;
        this.textFieldState = textFieldState;
        this.textLayoutState = textLayoutState;
        this.textFieldSelectionState = textFieldSelectionState;
        this.filter = filter;
        this.enabled = enabled;
        this.readOnly = readOnly;
        this.keyboardOptions = keyboardOptions.fillUnspecifiedValuesWith$foundation_release(filter != null ? filter.getKeyboardOptions() : null);
        this.keyboardActionHandler = keyboardActionHandler;
        this.singleLine = singleLine;
        this.interactionSource = interactionSource;
        if (z3 != z2 || !Intrinsics.areEqual(textFieldState, transformedTextFieldState) || !Intrinsics.areEqual(this.keyboardOptions, keyboardOptions2)) {
            if (z3 && isFocused()) {
                startInputSession(false);
            } else if (!z3) {
                disposeInputSession();
            }
        }
        if (z != enabled) {
            SemanticsModifierNodeKt.invalidateSemantics(this);
        }
        if (!Intrinsics.areEqual(textFieldSelectionState, textFieldSelectionState2)) {
            this.pointerInputNode.resetPointerInputHandler();
            this.stylusHandwritingNode.resetPointerInputHandler();
            if (getIsAttached()) {
                textFieldSelectionState.setReceiveContentConfiguration(this.receiveContentConfigurationProvider);
            }
        }
        if (Intrinsics.areEqual(interactionSource, mutableInteractionSource)) {
            return;
        }
        this.pointerInputNode.resetPointerInputHandler();
        this.stylusHandwritingNode.resetPointerInputHandler();
    }

    @Override
    public void applySemantics(SemanticsPropertyReceiver semanticsPropertyReceiver) {
        TextFieldCharSequence outputText = this.textFieldState.getOutputText();
        long selection = outputText.getSelection();
        SemanticsPropertiesKt.setEditableText(semanticsPropertyReceiver, new AnnotatedString(outputText.toString(), (List) null, (List) null, 6, (DefaultConstructorMarker) null));
        SemanticsPropertiesKt.m6631setTextSelectionRangeFDrldGo(semanticsPropertyReceiver, selection);
        if (!this.enabled) {
            SemanticsPropertiesKt.disabled(semanticsPropertyReceiver);
        }
        SemanticsPropertiesKt.setEditable(semanticsPropertyReceiver, getEditable());
        SemanticsPropertiesKt.getTextLayoutResult$default(semanticsPropertyReceiver, null, new Function1<List<TextLayoutResult>, Boolean>() {
            {
                super(1);
            }

            public final Boolean invoke(List<TextLayoutResult> list) {
                TextLayoutResult layoutResult = TextFieldDecoratorModifierNode.this.getTextLayoutState().getLayoutResult();
                return Boolean.valueOf(layoutResult != null ? list.add(layoutResult) : false);
            }
        }, 1, null);
        if (getEditable()) {
            SemanticsPropertiesKt.setText$default(semanticsPropertyReceiver, null, new Function1<AnnotatedString, Boolean>() {
                {
                    super(1);
                }

                public final Boolean invoke(AnnotatedString annotatedString) {
                    if (!TextFieldDecoratorModifierNode.this.getEditable()) {
                        return false;
                    }
                    TextFieldDecoratorModifierNode.this.getTextFieldState().replaceAll((CharSequence) annotatedString);
                    return true;
                }
            }, 1, null);
            SemanticsPropertiesKt.insertTextAtCursor$default(semanticsPropertyReceiver, null, new Function1<AnnotatedString, Boolean>() {
                {
                    super(1);
                }

                public final Boolean invoke(AnnotatedString annotatedString) {
                    if (!TextFieldDecoratorModifierNode.this.getEditable()) {
                        return false;
                    }
                    TransformedTextFieldState.replaceSelectedText$default(TextFieldDecoratorModifierNode.this.getTextFieldState(), (CharSequence) annotatedString, true, null, 4, null);
                    return true;
                }
            }, 1, null);
        }
        SemanticsPropertiesKt.setSelection$default(semanticsPropertyReceiver, null, new Function3<Integer, Integer, Boolean, Boolean>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke(((Number) obj).intValue(), ((Number) obj2).intValue(), ((Boolean) obj3).booleanValue());
            }

            public final Boolean invoke(int i, int i2, boolean z) {
                TextFieldCharSequence visualText;
                if (z) {
                    visualText = TextFieldDecoratorModifierNode.this.getTextFieldState().getUntransformedText();
                } else {
                    visualText = TextFieldDecoratorModifierNode.this.getTextFieldState().getVisualText();
                }
                long selection2 = visualText.getSelection();
                if (!TextFieldDecoratorModifierNode.this.getEnabled() || Math.min(i, i2) < 0 || Math.max(i, i2) > visualText.length()) {
                    return false;
                }
                if (i == TextRange.getStart-impl(selection2) && i2 == TextRange.getEnd-impl(selection2)) {
                    return true;
                }
                long jTextRange = TextRangeKt.TextRange(i, i2);
                if (z || i == i2) {
                    TextFieldDecoratorModifierNode.this.getTextFieldSelectionState().updateTextToolbarState(TextToolbarState.None);
                } else {
                    TextFieldDecoratorModifierNode.this.getTextFieldSelectionState().updateTextToolbarState(TextToolbarState.Selection);
                }
                if (z) {
                    TextFieldDecoratorModifierNode.this.getTextFieldState().m1727selectUntransformedCharsIn5zctL8(jTextRange);
                } else {
                    TextFieldDecoratorModifierNode.this.getTextFieldState().m1726selectCharsIn5zctL8(jTextRange);
                }
                return true;
            }
        }, 1, null);
        final int iM1472getImeActionOrDefaulteUduSuo$foundation_release = this.keyboardOptions.m1472getImeActionOrDefaulteUduSuo$foundation_release();
        SemanticsPropertiesKt.m6626onImeAction9UiTYpY$default(semanticsPropertyReceiver, iM1472getImeActionOrDefaulteUduSuo$foundation_release, null, new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m1681invoke() {
                TextFieldDecoratorModifierNode.this.m1679onImeActionPerformedKlQnJC8(iM1472getImeActionOrDefaulteUduSuo$foundation_release);
                return true;
            }
        }, 2, null);
        SemanticsPropertiesKt.onClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m1682invoke() {
                if (!TextFieldDecoratorModifierNode.this.isFocused()) {
                    FocusRequesterModifierNodeKt.requestFocus(TextFieldDecoratorModifierNode.this);
                } else if (!TextFieldDecoratorModifierNode.this.getReadOnly()) {
                    TextFieldDecoratorModifierNode.this.requireKeyboardController().show();
                }
                return true;
            }
        }, 1, null);
        SemanticsPropertiesKt.onLongClick$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
            {
                super(0);
            }

            public final Boolean m1683invoke() {
                if (!TextFieldDecoratorModifierNode.this.isFocused()) {
                    FocusRequesterModifierNodeKt.requestFocus(TextFieldDecoratorModifierNode.this);
                }
                TextFieldDecoratorModifierNode.this.getTextFieldSelectionState().updateTextToolbarState(TextToolbarState.Selection);
                return true;
            }
        }, 1, null);
        if (!TextRange.getCollapsed-impl(selection)) {
            SemanticsPropertiesKt.copyText$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                {
                    super(0);
                }

                public final Boolean m1684invoke() {
                    TextFieldSelectionState.copy$default(TextFieldDecoratorModifierNode.this.getTextFieldSelectionState(), false, 1, null);
                    return true;
                }
            }, 1, null);
            if (this.enabled && !this.readOnly) {
                SemanticsPropertiesKt.cutText$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                    {
                        super(0);
                    }

                    public final Boolean m1685invoke() {
                        TextFieldDecoratorModifierNode.this.getTextFieldSelectionState().cut();
                        return true;
                    }
                }, 1, null);
            }
        }
        if (getEditable()) {
            SemanticsPropertiesKt.pasteText$default(semanticsPropertyReceiver, null, new Function0<Boolean>() {
                {
                    super(0);
                }

                public final Boolean m1680invoke() {
                    TextFieldDecoratorModifierNode.this.getTextFieldSelectionState().paste();
                    return true;
                }
            }, 1, null);
        }
        InputTransformation inputTransformation = this.filter;
        if (inputTransformation != null) {
            inputTransformation.applySemantics(semanticsPropertyReceiver);
        }
    }

    @Override
    public void onFocusEvent(FocusState focusState) {
        if (this.isElementFocused == focusState.isFocused()) {
            return;
        }
        this.isElementFocused = focusState.isFocused();
        onFocusChange();
        if (focusState.isFocused()) {
            if (getEditable()) {
                startInputSession(false);
            }
        } else {
            disposeInputSession();
            TransformedTextFieldState transformedTextFieldState = this.textFieldState;
            TextFieldState textFieldState = transformedTextFieldState.textFieldState;
            InputTransformation inputTransformation = transformedTextFieldState.inputTransformation;
            TextFieldEditUndoBehavior textFieldEditUndoBehavior = TextFieldEditUndoBehavior.MergeIfPossible;
            textFieldState.getMainBuffer().getChangeTracker().clearChanges();
            EditCommandKt.finishComposingText(textFieldState.getMainBuffer());
            textFieldState.commitEditAsUser(inputTransformation, true, textFieldEditUndoBehavior);
            this.textFieldState.collapseSelectionToMax();
        }
        this.stylusHandwritingNode.onFocusEvent(focusState);
    }

    public final void onFocusChange() {
        this.textFieldSelectionState.setFocused(isFocused());
        if (isFocused() && this.observeChangesJob == null) {
            this.observeChangesJob = BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C09061(null), 3, (Object) null);
        } else {
            if (isFocused()) {
                return;
            }
            Job job = this.observeChangesJob;
            if (job != null) {
                Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
            }
            this.observeChangesJob = null;
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.TextFieldDecoratorModifierNode$onFocusChange$1", f = "TextFieldDecoratorModifier.kt", i = {}, l = {634}, m = "invokeSuspend", n = {}, s = {})
    static final class C09061 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C09061(Continuation<? super C09061> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return TextFieldDecoratorModifierNode.this.new C09061(continuation);
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
                if (TextFieldDecoratorModifierNode.this.getTextFieldSelectionState().observeChanges((Continuation) this) == coroutine_suspended) {
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

    @Override
    public void onAttach() {
        onObservedReadsChanged();
        this.textFieldSelectionState.setReceiveContentConfiguration(this.receiveContentConfigurationProvider);
    }

    @Override
    public void onDetach() {
        disposeInputSession();
        this.textFieldSelectionState.setReceiveContentConfiguration(null);
    }

    @Override
    public void onGloballyPositioned(LayoutCoordinates coordinates) {
        this.textLayoutState.setDecoratorNodeCoordinates(coordinates);
    }

    @Override
    public void mo491onPointerEventH0pRuoY(PointerEvent pointerEvent, PointerEventPass pass, long bounds) {
        this.stylusHandwritingNode.mo491onPointerEventH0pRuoY(pointerEvent, pass, bounds);
        this.pointerInputNode.mo491onPointerEventH0pRuoY(pointerEvent, pass, bounds);
    }

    @Override
    public void onCancelPointerInput() {
        this.stylusHandwritingNode.onCancelPointerInput();
        this.pointerInputNode.onCancelPointerInput();
    }

    @Override
    public boolean mo492onPreKeyEventZmokQxo(KeyEvent event) {
        return this.textFieldKeyEventHandler.mo1607onPreKeyEventMyFupTE(event, this.textFieldState, this.textFieldSelectionState, (FocusManager) CompositionLocalConsumerModifierNodeKt.currentValueOf(this, CompositionLocalsKt.getLocalFocusManager()), requireKeyboardController());
    }

    @Override
    public boolean mo490onKeyEventZmokQxo(KeyEvent event) {
        return this.textFieldKeyEventHandler.mo1606onKeyEvent6ptp14s(event, this.textFieldState, this.textLayoutState, this.textFieldSelectionState, this.enabled && !this.readOnly, this.singleLine, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m1689invoke();
                return Unit.INSTANCE;
            }

            public final void m1689invoke() {
                TextFieldDecoratorModifierNode textFieldDecoratorModifierNode = this.this$0;
                textFieldDecoratorModifierNode.m1679onImeActionPerformedKlQnJC8(textFieldDecoratorModifierNode.getKeyboardOptions().m1472getImeActionOrDefaulteUduSuo$foundation_release());
            }
        });
    }

    @Override
    public void onObservedReadsChanged() {
        ObserverModifierNodeKt.observeReads(this, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m1690invoke();
                return Unit.INSTANCE;
            }

            public final void m1690invoke() {
                TextFieldDecoratorModifierNode textFieldDecoratorModifierNode = TextFieldDecoratorModifierNode.this;
                textFieldDecoratorModifierNode.windowInfo = (WindowInfo) CompositionLocalConsumerModifierNodeKt.currentValueOf(textFieldDecoratorModifierNode, CompositionLocalsKt.getLocalWindowInfo());
                TextFieldDecoratorModifierNode.this.onFocusChange();
            }
        });
    }

    public final void startInputSession(boolean fromTap) {
        if (fromTap || this.keyboardOptions.getShowKeyboardOnFocusOrDefault$foundation_release()) {
            this.inputSessionJob = BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new C09121(ReceiveContentConfigurationKt.getReceiveContentConfiguration(this), null), 3, (Object) null);
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.TextFieldDecoratorModifierNode$startInputSession$1", f = "TextFieldDecoratorModifier.kt", i = {}, l = {707}, m = "invokeSuspend", n = {}, s = {})
    static final class C09121 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ReceiveContentConfiguration $receiveContentConfiguration;
        int label;

        C09121(ReceiveContentConfiguration receiveContentConfiguration, Continuation<? super C09121> continuation) {
            super(2, continuation);
            this.$receiveContentConfiguration = receiveContentConfiguration;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return TextFieldDecoratorModifierNode.this.new C09121(this.$receiveContentConfiguration, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (PlatformTextInputModifierNodeKt.establishTextInputSession(TextFieldDecoratorModifierNode.this, new AnonymousClass1(TextFieldDecoratorModifierNode.this, this.$receiveContentConfiguration, null), (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            throw new KotlinNothingValueException();
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0001\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.TextFieldDecoratorModifierNode$startInputSession$1$1", f = "TextFieldDecoratorModifier.kt", i = {}, l = {708}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<PlatformTextInputSessionScope, Continuation<?>, Object> {
            final ReceiveContentConfiguration $receiveContentConfiguration;
            private Object L$0;
            int label;
            final TextFieldDecoratorModifierNode this$0;

            AnonymousClass1(TextFieldDecoratorModifierNode textFieldDecoratorModifierNode, ReceiveContentConfiguration receiveContentConfiguration, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = textFieldDecoratorModifierNode;
                this.$receiveContentConfiguration = receiveContentConfiguration;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.this$0, this.$receiveContentConfiguration, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(PlatformTextInputSessionScope platformTextInputSessionScope, Continuation<?> continuation) {
                return create(platformTextInputSessionScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (AndroidTextInputSession_androidKt.platformSpecificTextInputSession((PlatformTextInputSessionScope) this.L$0, this.this$0.getTextFieldState(), this.this$0.getTextLayoutState(), this.this$0.getKeyboardOptions().toImeOptions$foundation_release(this.this$0.getSingleLine()), this.$receiveContentConfiguration, new C18011(this.this$0), this.this$0.getStylusHandwritingTrigger(), (ViewConfiguration) CompositionLocalConsumerModifierNodeKt.currentValueOf(this.this$0, CompositionLocalsKt.getLocalViewConfiguration()), (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                throw new KotlinNothingValueException();
            }

            @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
            class C18011 extends FunctionReferenceImpl implements Function1<ImeAction, Unit> {
                C18011(Object obj) {
                    super(1, obj, TextFieldDecoratorModifierNode.class, "onImeActionPerformed", "onImeActionPerformed-KlQnJC8(I)V", 0);
                }

                public Object invoke(Object obj) {
                    m1694invokeKlQnJC8(((ImeAction) obj).unbox-impl());
                    return Unit.INSTANCE;
                }

                public final void m1694invokeKlQnJC8(int i) {
                    ((TextFieldDecoratorModifierNode) this.receiver).m1679onImeActionPerformedKlQnJC8(i);
                }
            }
        }
    }

    private final void disposeInputSession() {
        Job job = this.inputSessionJob;
        if (job != null) {
            Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
        }
        this.inputSessionJob = null;
        MutableSharedFlow<Unit> stylusHandwritingTrigger = getStylusHandwritingTrigger();
        if (stylusHandwritingTrigger != null) {
            stylusHandwritingTrigger.resetReplayCache();
        }
    }

    public final SoftwareKeyboardController requireKeyboardController() {
        SoftwareKeyboardController softwareKeyboardController = (SoftwareKeyboardController) CompositionLocalConsumerModifierNodeKt.currentValueOf(this, CompositionLocalsKt.getLocalSoftwareKeyboardController());
        if (softwareKeyboardController != null) {
            return softwareKeyboardController;
        }
        throw new IllegalStateException("No software keyboard controller".toString());
    }

    public final void emitDragExitEvent() {
        HoverInteraction.Enter enter = this.dragEnterEvent;
        if (enter != null) {
            this.interactionSource.tryEmit(new HoverInteraction.Exit(enter));
            this.dragEnterEvent = null;
        }
    }

    public final void m1679onImeActionPerformedKlQnJC8(final int imeAction) {
        KeyboardActionHandler keyboardActionHandler;
        if (ImeAction.equals-impl0(imeAction, ImeAction.Companion.getNone-eUduSuo()) || ImeAction.equals-impl0(imeAction, ImeAction.Companion.getDefault-eUduSuo()) || (keyboardActionHandler = this.keyboardActionHandler) == null) {
            this.keyboardActionScope.mo1458defaultKeyboardActionKlQnJC8(imeAction);
        } else if (keyboardActionHandler != null) {
            keyboardActionHandler.onKeyboardAction(new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1688invoke();
                    return Unit.INSTANCE;
                }

                public final void m1688invoke() {
                    this.this$0.keyboardActionScope.mo1458defaultKeyboardActionKlQnJC8(imeAction);
                }
            });
        }
    }
}
