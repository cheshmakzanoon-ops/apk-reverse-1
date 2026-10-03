package androidx.compose.p002ui.node;

import android.view.KeyEvent;
import android.view.View;
import androidx.autofill.HintConstants;
import androidx.compose.p002ui.autofill.Autofill;
import androidx.compose.p002ui.autofill.AutofillTree;
import androidx.compose.p002ui.draganddrop.DragAndDropManager;
import androidx.compose.p002ui.focus.FocusDirection;
import androidx.compose.p002ui.focus.FocusOwner;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.hapticfeedback.HapticFeedback;
import androidx.compose.p002ui.input.InputModeManager;
import androidx.compose.p002ui.input.pointer.PointerIconService;
import androidx.compose.p002ui.input.pointer.PositionCalculator;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.modifier.ModifierLocalManager;
import androidx.compose.p002ui.platform.AccessibilityManager;
import androidx.compose.p002ui.platform.ClipboardManager;
import androidx.compose.p002ui.platform.PlatformTextInputSessionScope;
import androidx.compose.p002ui.platform.SoftwareKeyboardController;
import androidx.compose.p002ui.platform.TextToolbar;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.p002ui.platform.WindowInfo;
import androidx.compose.ui.text.font.Font;
import androidx.compose.ui.text.font.FontFamily;
import androidx.compose.ui.text.input.TextInputService;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000à\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b`\u0018\u0000 º\u00012\u00020\u0001:\u0004º\u0001»\u0001J\u001a\u0010y\u001a\u00020z2\u0006\u0010{\u001a\u00020zH&ø\u0001\u0000¢\u0006\u0004\b|\u0010}J\u001b\u0010~\u001a\u00020z2\u0006\u0010\u007f\u001a\u00020zH&ø\u0001\u0000¢\u0006\u0005\b\u0080\u0001\u0010}Jn\u0010\u0081\u0001\u001a\u00030\u0082\u00012C\u0010\u0083\u0001\u001a>\u0012\u0017\u0012\u00150\u0085\u0001¢\u0006\u000f\b\u0086\u0001\u0012\n\b\u0087\u0001\u0012\u0005\b\b(\u0088\u0001\u0012\u0019\u0012\u0017\u0018\u00010\u0089\u0001¢\u0006\u000f\b\u0086\u0001\u0012\n\b\u0087\u0001\u0012\u0005\b\b(\u008a\u0001\u0012\u0005\u0012\u00030\u008b\u00010\u0084\u00012\u000f\u0010\u008c\u0001\u001a\n\u0012\u0005\u0012\u00030\u008b\u00010\u008d\u00012\f\b\u0002\u0010\u008e\u0001\u001a\u0005\u0018\u00010\u0089\u0001H&J\u001e\u0010\u008f\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u0090\u0001\u001a\u00020O2\t\b\u0002\u0010\u0091\u0001\u001a\u00020[H&J\"\u0010\u0092\u0001\u001a\u0005\u0018\u00010\u0093\u00012\b\u0010\u0094\u0001\u001a\u00030\u0095\u0001H&ø\u0001\u0000¢\u0006\u0006\b\u0096\u0001\u0010\u0097\u0001J)\u0010\u0098\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u0090\u0001\u001a\u00020O2\b\u0010\u0099\u0001\u001a\u00030\u009a\u0001H&ø\u0001\u0000¢\u0006\u0006\b\u009b\u0001\u0010\u009c\u0001J\u0015\u0010\u0098\u0001\u001a\u00030\u008b\u00012\t\b\u0002\u0010\u009d\u0001\u001a\u00020[H&J\u0013\u0010\u009e\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u009f\u0001\u001a\u00020OH&J\u0013\u0010 \u0001\u001a\u00030\u008b\u00012\u0007\u0010\u009f\u0001\u001a\u00020OH&J\n\u0010¡\u0001\u001a\u00030\u008b\u0001H&J\u0019\u0010¢\u0001\u001a\u00030\u008b\u00012\r\u0010£\u0001\u001a\b0¤\u0001j\u0003`¥\u0001H'J\u0013\u0010¦\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u0090\u0001\u001a\u00020OH&J4\u0010§\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u0090\u0001\u001a\u00020O2\t\b\u0002\u0010\u0091\u0001\u001a\u00020[2\t\b\u0002\u0010¨\u0001\u001a\u00020[2\t\b\u0002\u0010©\u0001\u001a\u00020[H&J)\u0010ª\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u0090\u0001\u001a\u00020O2\t\b\u0002\u0010\u0091\u0001\u001a\u00020[2\t\b\u0002\u0010¨\u0001\u001a\u00020[H&J\n\u0010«\u0001\u001a\u00030\u008b\u0001H&J\u001b\u0010¬\u0001\u001a\u00030\u008b\u00012\u000f\u0010\u00ad\u0001\u001a\n\u0012\u0005\u0012\u00030\u008b\u00010\u008d\u0001H&J\u0014\u0010®\u0001\u001a\u00030\u008b\u00012\b\u0010\u00ad\u0001\u001a\u00030¯\u0001H&J\t\u0010°\u0001\u001a\u00020[H&J\u0013\u0010±\u0001\u001a\u00030\u008b\u00012\u0007\u0010\u0090\u0001\u001a\u00020OH&JA\u0010²\u0001\u001a\u00030³\u00012.\u0010´\u0001\u001a)\b\u0001\u0012\u0005\u0012\u00030µ\u0001\u0012\f\u0012\n\u0012\u0005\u0012\u00030³\u00010¶\u0001\u0012\u0007\u0012\u0005\u0018\u00010·\u00010\u0084\u0001¢\u0006\u0003\b¸\u0001H¦@¢\u0006\u0003\u0010¹\u0001R\u0012\u0010\u0002\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u001c\u0010\u0006\u001a\u0004\u0018\u00010\u00078gX§\u0004¢\u0006\f\u0012\u0004\b\b\u0010\t\u001a\u0004\b\n\u0010\u000bR\u001a\u0010\f\u001a\u00020\r8gX§\u0004¢\u0006\f\u0012\u0004\b\u000e\u0010\t\u001a\u0004\b\u000f\u0010\u0010R\u0012\u0010\u0011\u001a\u00020\u0012X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R\u0012\u0010\u0015\u001a\u00020\u0016X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0017\u0010\u0018R\u0012\u0010\u0019\u001a\u00020\u001aX¦\u0004¢\u0006\u0006\u001a\u0004\b\u001b\u0010\u001cR\u0012\u0010\u001d\u001a\u00020\u001eX¦\u0004¢\u0006\u0006\u001a\u0004\b\u001f\u0010 R\u0012\u0010!\u001a\u00020\"X¦\u0004¢\u0006\u0006\u001a\u0004\b#\u0010$R\u0012\u0010%\u001a\u00020&X¦\u0004¢\u0006\u0006\u001a\u0004\b'\u0010(R\u001a\u0010)\u001a\u00020*8&X§\u0004¢\u0006\f\u0012\u0004\b+\u0010\t\u001a\u0004\b,\u0010-R\u0012\u0010.\u001a\u00020/X¦\u0004¢\u0006\u0006\u001a\u0004\b0\u00101R\u0012\u00102\u001a\u000203X¦\u0004¢\u0006\u0006\u001a\u0004\b4\u00105R\u0012\u00106\u001a\u000207X¦\u0004¢\u0006\u0006\u001a\u0004\b8\u00109R\u0012\u0010:\u001a\u00020;X¦\u0004¢\u0006\u0006\u001a\u0004\b<\u0010=R\u0012\u0010>\u001a\u00020?X¦\u0004¢\u0006\u0006\u001a\u0004\b@\u0010AR\u0012\u0010B\u001a\u00020CX¦\u0004¢\u0006\u0006\u001a\u0004\bD\u0010ER\u0014\u0010F\u001a\u00020G8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bH\u0010IR\u0012\u0010J\u001a\u00020KX¦\u0004¢\u0006\u0006\u001a\u0004\bL\u0010MR\u0012\u0010N\u001a\u00020OX¦\u0004¢\u0006\u0006\u001a\u0004\bP\u0010QR\u0012\u0010R\u001a\u00020SX¦\u0004¢\u0006\u0006\u001a\u0004\bT\u0010UR\u0012\u0010V\u001a\u00020WX¦\u0004¢\u0006\u0006\u001a\u0004\bX\u0010YR\"\u0010\\\u001a\u00020[2\u0006\u0010Z\u001a\u00020[@gX¦\u000e¢\u0006\f\u001a\u0004\b]\u0010^\"\u0004\b_\u0010`R\u0012\u0010a\u001a\u00020bX¦\u0004¢\u0006\u0006\u001a\u0004\bc\u0010dR\u0012\u0010e\u001a\u00020fX¦\u0004¢\u0006\u0006\u001a\u0004\bg\u0010hR\u0012\u0010i\u001a\u00020jX¦\u0004¢\u0006\u0006\u001a\u0004\bk\u0010lR\u0012\u0010m\u001a\u00020nX¦\u0004¢\u0006\u0006\u001a\u0004\bo\u0010pR\u0012\u0010q\u001a\u00020rX¦\u0004¢\u0006\u0006\u001a\u0004\bs\u0010tR\u0012\u0010u\u001a\u00020vX¦\u0004¢\u0006\u0006\u001a\u0004\bw\u0010xø\u0001\u0001\u0082\u0002\r\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u0006¼\u0001À\u0006\u0001"}, d2 = {"Landroidx/compose/ui/node/Owner;", "Landroidx/compose/ui/input/pointer/PositionCalculator;", "accessibilityManager", "Landroidx/compose/ui/platform/AccessibilityManager;", "getAccessibilityManager", "()Landroidx/compose/ui/platform/AccessibilityManager;", "autofill", "Landroidx/compose/ui/autofill/Autofill;", "getAutofill$annotations", "()V", "getAutofill", "()Landroidx/compose/ui/autofill/Autofill;", "autofillTree", "Landroidx/compose/ui/autofill/AutofillTree;", "getAutofillTree$annotations", "getAutofillTree", "()Landroidx/compose/ui/autofill/AutofillTree;", "clipboardManager", "Landroidx/compose/ui/platform/ClipboardManager;", "getClipboardManager", "()Landroidx/compose/ui/platform/ClipboardManager;", "coroutineContext", "Lkotlin/coroutines/CoroutineContext;", "getCoroutineContext", "()Lkotlin/coroutines/CoroutineContext;", "density", "Landroidx/compose/ui/unit/Density;", "getDensity", "()Landroidx/compose/ui/unit/Density;", "dragAndDropManager", "Landroidx/compose/ui/draganddrop/DragAndDropManager;", "getDragAndDropManager", "()Landroidx/compose/ui/draganddrop/DragAndDropManager;", "focusOwner", "Landroidx/compose/ui/focus/FocusOwner;", "getFocusOwner", "()Landroidx/compose/ui/focus/FocusOwner;", "fontFamilyResolver", "Landroidx/compose/ui/text/font/FontFamily$Resolver;", "getFontFamilyResolver", "()Landroidx/compose/ui/text/font/FontFamily$Resolver;", "fontLoader", "Landroidx/compose/ui/text/font/Font$ResourceLoader;", "getFontLoader$annotations", "getFontLoader", "()Landroidx/compose/ui/text/font/Font$ResourceLoader;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "getGraphicsContext", "()Landroidx/compose/ui/graphics/GraphicsContext;", "hapticFeedBack", "Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "getHapticFeedBack", "()Landroidx/compose/ui/hapticfeedback/HapticFeedback;", "inputModeManager", "Landroidx/compose/ui/input/InputModeManager;", "getInputModeManager", "()Landroidx/compose/ui/input/InputModeManager;", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "measureIteration", "", "getMeasureIteration", "()J", "modifierLocalManager", "Landroidx/compose/ui/modifier/ModifierLocalManager;", "getModifierLocalManager", "()Landroidx/compose/ui/modifier/ModifierLocalManager;", "placementScope", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "getPlacementScope", "()Landroidx/compose/ui/layout/Placeable$PlacementScope;", "pointerIconService", "Landroidx/compose/ui/input/pointer/PointerIconService;", "getPointerIconService", "()Landroidx/compose/ui/input/pointer/PointerIconService;", "root", "Landroidx/compose/ui/node/LayoutNode;", "getRoot", "()Landroidx/compose/ui/node/LayoutNode;", "rootForTest", "Landroidx/compose/ui/node/RootForTest;", "getRootForTest", "()Landroidx/compose/ui/node/RootForTest;", "sharedDrawScope", "Landroidx/compose/ui/node/LayoutNodeDrawScope;", "getSharedDrawScope", "()Landroidx/compose/ui/node/LayoutNodeDrawScope;", "<set-?>", "", "showLayoutBounds", "getShowLayoutBounds", "()Z", "setShowLayoutBounds", "(Z)V", "snapshotObserver", "Landroidx/compose/ui/node/OwnerSnapshotObserver;", "getSnapshotObserver", "()Landroidx/compose/ui/node/OwnerSnapshotObserver;", "softwareKeyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "getSoftwareKeyboardController", "()Landroidx/compose/ui/platform/SoftwareKeyboardController;", "textInputService", "Landroidx/compose/ui/text/input/TextInputService;", "getTextInputService", "()Landroidx/compose/ui/text/input/TextInputService;", "textToolbar", "Landroidx/compose/ui/platform/TextToolbar;", "getTextToolbar", "()Landroidx/compose/ui/platform/TextToolbar;", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "getViewConfiguration", "()Landroidx/compose/ui/platform/ViewConfiguration;", "windowInfo", "Landroidx/compose/ui/platform/WindowInfo;", "getWindowInfo", "()Landroidx/compose/ui/platform/WindowInfo;", "calculateLocalPosition", "Landroidx/compose/ui/geometry/Offset;", "positionInWindow", "calculateLocalPosition-MK-Hz9U", "(J)J", "calculatePositionInWindow", "localPosition", "calculatePositionInWindow-MK-Hz9U", "createLayer", "Landroidx/compose/ui/node/OwnedLayer;", "drawBlock", "Lkotlin/Function2;", "Landroidx/compose/ui/graphics/Canvas;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "canvas", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "parentLayer", "", "invalidateParentLayer", "Lkotlin/Function0;", "explicitLayer", "forceMeasureTheSubtree", "layoutNode", "affectsLookahead", "getFocusDirection", "Landroidx/compose/ui/focus/FocusDirection;", "keyEvent", "Landroidx/compose/ui/input/key/KeyEvent;", "getFocusDirection-P8AzH3I", "(Landroid/view/KeyEvent;)Landroidx/compose/ui/focus/FocusDirection;", "measureAndLayout", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measureAndLayout-0kLqBqw", "(Landroidx/compose/ui/node/LayoutNode;J)V", "sendPointerUpdate", "onAttach", "node", "onDetach", "onEndApplyChanges", "onInteropViewLayoutChange", "view", "Landroid/view/View;", "Landroidx/compose/ui/viewinterop/InteropView;", "onLayoutChange", "onRequestMeasure", "forceRequest", "scheduleMeasureAndLayout", "onRequestRelayout", "onSemanticsChange", "registerOnEndApplyChangesListener", "listener", "registerOnLayoutCompletedListener", "Landroidx/compose/ui/node/Owner$OnLayoutCompletedListener;", "requestFocus", "requestOnPositionedCallback", "textInputSession", "", "session", "Landroidx/compose/ui/platform/PlatformTextInputSessionScope;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "OnLayoutCompletedListener", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface Owner extends PositionCalculator {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    @Metadata(d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\bf\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H&ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0004À\u0006\u0001"}, d2 = {"Landroidx/compose/ui/node/Owner$OnLayoutCompletedListener;", "", "onLayoutComplete", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public interface OnLayoutCompletedListener {
        void onLayoutComplete();
    }

    long mo6420calculateLocalPositionMKHz9U(long positionInWindow);

    long mo6421calculatePositionInWindowMKHz9U(long localPosition);

    OwnedLayer createLayer(Function2<? super Canvas, ? super GraphicsLayer, Unit> drawBlock, Function0<Unit> invalidateParentLayer, GraphicsLayer explicitLayer);

    void forceMeasureTheSubtree(LayoutNode layoutNode, boolean affectsLookahead);

    AccessibilityManager getAccessibilityManager();

    Autofill getAutofill();

    AutofillTree getAutofillTree();

    ClipboardManager getClipboardManager();

    CoroutineContext getCoroutineContext();

    Density getDensity();

    DragAndDropManager getDragAndDropManager();

    FocusDirection mo6422getFocusDirectionP8AzH3I(KeyEvent keyEvent);

    FocusOwner getFocusOwner();

    FontFamily.Resolver getFontFamilyResolver();

    Font.ResourceLoader getFontLoader();

    GraphicsContext getGraphicsContext();

    HapticFeedback getHapticFeedBack();

    InputModeManager getInputModeManager();

    LayoutDirection getLayoutDirection();

    long getMeasureIteration();

    ModifierLocalManager getModifierLocalManager();

    Placeable.PlacementScope getPlacementScope();

    PointerIconService getPointerIconService();

    LayoutNode getRoot();

    RootForTest getRootForTest();

    LayoutNodeDrawScope getSharedDrawScope();

    boolean getShowLayoutBounds();

    OwnerSnapshotObserver getSnapshotObserver();

    SoftwareKeyboardController getSoftwareKeyboardController();

    TextInputService getTextInputService();

    TextToolbar getTextToolbar();

    ViewConfiguration getViewConfiguration();

    WindowInfo getWindowInfo();

    void measureAndLayout(boolean sendPointerUpdate);

    void mo6423measureAndLayout0kLqBqw(LayoutNode layoutNode, long constraints);

    void onAttach(LayoutNode node);

    void onDetach(LayoutNode node);

    void onEndApplyChanges();

    void onInteropViewLayoutChange(View view);

    void onLayoutChange(LayoutNode layoutNode);

    void onRequestMeasure(LayoutNode layoutNode, boolean affectsLookahead, boolean forceRequest, boolean scheduleMeasureAndLayout);

    void onRequestRelayout(LayoutNode layoutNode, boolean affectsLookahead, boolean forceRequest);

    void onSemanticsChange();

    void registerOnEndApplyChangesListener(Function0<Unit> listener);

    void registerOnLayoutCompletedListener(OnLayoutCompletedListener listener);

    boolean requestFocus();

    void requestOnPositionedCallback(LayoutNode layoutNode);

    void setShowLayoutBounds(boolean z);

    Object textInputSession(Function2<? super PlatformTextInputSessionScope, ? super Continuation<?>, ? extends Object> function2, Continuation<?> continuation);

    public final class CC {
        static {
            Companion companion = Owner.INSTANCE;
        }

        public static void getAutofill$annotations() {
        }

        public static void getAutofillTree$annotations() {
        }

        @Deprecated(message = "fontLoader is deprecated, use fontFamilyResolver", replaceWith = @ReplaceWith(expression = "fontFamilyResolver", imports = {}))
        public static void getFontLoader$annotations() {
        }

        public static void onRequestMeasure$default(Owner owner, LayoutNode layoutNode, boolean z, boolean z2, boolean z3, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: onRequestMeasure");
            }
            if ((i & 2) != 0) {
                z = false;
            }
            if ((i & 4) != 0) {
                z2 = false;
            }
            if ((i & 8) != 0) {
                z3 = true;
            }
            owner.onRequestMeasure(layoutNode, z, z2, z3);
        }

        public static void onRequestRelayout$default(Owner owner, LayoutNode layoutNode, boolean z, boolean z2, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: onRequestRelayout");
            }
            if ((i & 2) != 0) {
                z = false;
            }
            if ((i & 4) != 0) {
                z2 = false;
            }
            owner.onRequestRelayout(layoutNode, z, z2);
        }

        public static void measureAndLayout$default(Owner owner, boolean z, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: measureAndLayout");
            }
            if ((i & 1) != 0) {
                z = true;
            }
            owner.measureAndLayout(z);
        }

        public static void forceMeasureTheSubtree$default(Owner owner, LayoutNode layoutNode, boolean z, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: forceMeasureTheSubtree");
            }
            if ((i & 2) != 0) {
                z = false;
            }
            owner.forceMeasureTheSubtree(layoutNode, z);
        }

        public static OwnedLayer createLayer$default(Owner owner, Function2 function2, Function0 function0, GraphicsLayer graphicsLayer, int i, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: createLayer");
            }
            if ((i & 4) != 0) {
                graphicsLayer = null;
            }
            return owner.createLayer(function2, function0, graphicsLayer);
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\b¨\u0006\t"}, d2 = {"Landroidx/compose/ui/node/Owner$Companion;", "", "()V", "enableExtraAssertions", "", "getEnableExtraAssertions", "()Z", "setEnableExtraAssertions", "(Z)V", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        static final Companion $$INSTANCE = new Companion();
        private static boolean enableExtraAssertions;

        private Companion() {
        }

        public final boolean getEnableExtraAssertions() {
            return enableExtraAssertions;
        }

        public final void setEnableExtraAssertions(boolean z) {
            enableExtraAssertions = z;
        }
    }
}
