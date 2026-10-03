package androidx.compose.foundation.text.input.internal;

import androidx.compose.foundation.text.LegacyTextFieldState;
import androidx.compose.foundation.text.selection.TextFieldSelectionManager;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNode;
import androidx.compose.p002ui.node.CompositionLocalConsumerModifierNodeKt;
import androidx.compose.p002ui.node.GlobalPositionAwareModifierNode;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.p002ui.platform.PlatformTextInputModifierNode;
import androidx.compose.p002ui.platform.PlatformTextInputModifierNodeKt;
import androidx.compose.p002ui.platform.PlatformTextInputSession;
import androidx.compose.p002ui.platform.SoftwareKeyboardController;
import androidx.compose.p002ui.platform.ViewConfiguration;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;

@Metadata(d1 = {"\u0000p\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u00042\u00020\u0005B\u001d\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ8\u0010&\u001a\u0004\u0018\u00010'2'\u0010(\u001a#\b\u0001\u0012\u0004\u0012\u00020*\u0012\n\u0012\b\u0012\u0004\u0012\u00020,0+\u0012\u0006\u0012\u0004\u0018\u00010-0)¢\u0006\u0002\b.H\u0016¢\u0006\u0002\u0010/J\b\u00100\u001a\u000201H\u0016J\b\u00102\u001a\u000201H\u0016J\u0010\u00103\u001a\u0002012\u0006\u00104\u001a\u00020\u000eH\u0016J\u000e\u00105\u001a\u0002012\u0006\u0010\u0006\u001a\u00020\u0007R/\u0010\u000f\u001a\u0004\u0018\u00010\u000e2\b\u0010\r\u001a\u0004\u0018\u00010\u000e8V@RX\u0096\u008e\u0002¢\u0006\u0012\n\u0004\b\u0014\u0010\u0015\u001a\u0004\b\u0010\u0010\u0011\"\u0004\b\u0012\u0010\u0013R\u001a\u0010\b\u001a\u00020\tX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\u001a\u001a\u0004\u0018\u00010\u001b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u001dR\u001a\u0010\n\u001a\u00020\u000bX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u001f\"\u0004\b \u0010!R\u0014\u0010\"\u001a\u00020#8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b$\u0010%¨\u00066"}, d2 = {"Landroidx/compose/foundation/text/input/internal/LegacyAdaptingPlatformTextInputModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/platform/PlatformTextInputModifierNode;", "Landroidx/compose/ui/node/CompositionLocalConsumerModifierNode;", "Landroidx/compose/ui/node/GlobalPositionAwareModifierNode;", "Landroidx/compose/foundation/text/input/internal/LegacyPlatformTextInputServiceAdapter$LegacyPlatformTextInputNode;", "serviceAdapter", "Landroidx/compose/foundation/text/input/internal/LegacyPlatformTextInputServiceAdapter;", "legacyTextFieldState", "Landroidx/compose/foundation/text/LegacyTextFieldState;", "textFieldSelectionManager", "Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;", "(Landroidx/compose/foundation/text/input/internal/LegacyPlatformTextInputServiceAdapter;Landroidx/compose/foundation/text/LegacyTextFieldState;Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;)V", "<set-?>", "Landroidx/compose/ui/layout/LayoutCoordinates;", "layoutCoordinates", "getLayoutCoordinates", "()Landroidx/compose/ui/layout/LayoutCoordinates;", "setLayoutCoordinates", "(Landroidx/compose/ui/layout/LayoutCoordinates;)V", "layoutCoordinates$delegate", "Landroidx/compose/runtime/MutableState;", "getLegacyTextFieldState", "()Landroidx/compose/foundation/text/LegacyTextFieldState;", "setLegacyTextFieldState", "(Landroidx/compose/foundation/text/LegacyTextFieldState;)V", "softwareKeyboardController", "Landroidx/compose/ui/platform/SoftwareKeyboardController;", "getSoftwareKeyboardController", "()Landroidx/compose/ui/platform/SoftwareKeyboardController;", "getTextFieldSelectionManager", "()Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;", "setTextFieldSelectionManager", "(Landroidx/compose/foundation/text/selection/TextFieldSelectionManager;)V", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "getViewConfiguration", "()Landroidx/compose/ui/platform/ViewConfiguration;", "launchTextInputSession", "Lkotlinx/coroutines/Job;", "block", "Lkotlin/Function2;", "Landroidx/compose/ui/platform/PlatformTextInputSession;", "Lkotlin/coroutines/Continuation;", "", "", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function2;)Lkotlinx/coroutines/Job;", "onAttach", "", "onDetach", "onGloballyPositioned", "coordinates", "setServiceAdapter", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LegacyAdaptingPlatformTextInputModifierNode extends Modifier.Node implements PlatformTextInputModifierNode, CompositionLocalConsumerModifierNode, GlobalPositionAwareModifierNode, LegacyPlatformTextInputServiceAdapter.LegacyPlatformTextInputNode {
    public static final int $stable = 8;

    private final MutableState layoutCoordinates = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
    private LegacyTextFieldState legacyTextFieldState;
    private LegacyPlatformTextInputServiceAdapter serviceAdapter;
    private TextFieldSelectionManager textFieldSelectionManager;

    @Override
    public LegacyTextFieldState getLegacyTextFieldState() {
        return this.legacyTextFieldState;
    }

    public void setLegacyTextFieldState(LegacyTextFieldState legacyTextFieldState) {
        this.legacyTextFieldState = legacyTextFieldState;
    }

    @Override
    public TextFieldSelectionManager getTextFieldSelectionManager() {
        return this.textFieldSelectionManager;
    }

    public void setTextFieldSelectionManager(TextFieldSelectionManager textFieldSelectionManager) {
        this.textFieldSelectionManager = textFieldSelectionManager;
    }

    public LegacyAdaptingPlatformTextInputModifierNode(LegacyPlatformTextInputServiceAdapter legacyPlatformTextInputServiceAdapter, LegacyTextFieldState legacyTextFieldState, TextFieldSelectionManager textFieldSelectionManager) {
        this.serviceAdapter = legacyPlatformTextInputServiceAdapter;
        this.legacyTextFieldState = legacyTextFieldState;
        this.textFieldSelectionManager = textFieldSelectionManager;
    }

    private void setLayoutCoordinates(LayoutCoordinates layoutCoordinates) {
        this.layoutCoordinates.setValue(layoutCoordinates);
    }

    @Override
    public LayoutCoordinates getLayoutCoordinates() {
        return (LayoutCoordinates) this.layoutCoordinates.getValue();
    }

    @Override
    public SoftwareKeyboardController getSoftwareKeyboardController() {
        return (SoftwareKeyboardController) CompositionLocalConsumerModifierNodeKt.currentValueOf(this, CompositionLocalsKt.getLocalSoftwareKeyboardController());
    }

    public final void setServiceAdapter(LegacyPlatformTextInputServiceAdapter serviceAdapter) {
        if (getIsAttached()) {
            this.serviceAdapter.stopInput();
            this.serviceAdapter.unregisterModifier(this);
        }
        this.serviceAdapter = serviceAdapter;
        if (getIsAttached()) {
            this.serviceAdapter.registerModifier(this);
        }
    }

    @Override
    public ViewConfiguration getViewConfiguration() {
        return (ViewConfiguration) CompositionLocalConsumerModifierNodeKt.currentValueOf(this, CompositionLocalsKt.getLocalViewConfiguration());
    }

    @Override
    public void onAttach() {
        this.serviceAdapter.registerModifier(this);
    }

    @Override
    public void onDetach() {
        this.serviceAdapter.unregisterModifier(this);
    }

    @Override
    public void onGloballyPositioned(LayoutCoordinates coordinates) {
        setLayoutCoordinates(coordinates);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.LegacyAdaptingPlatformTextInputModifierNode$launchTextInputSession$1", f = "LegacyAdaptingPlatformTextInputModifierNode.kt", i = {}, l = {135}, m = "invokeSuspend", n = {}, s = {})
    static final class C08821 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function2<PlatformTextInputSession, Continuation<?>, Object> $block;
        int label;

        C08821(Function2<? super PlatformTextInputSession, ? super Continuation<?>, ? extends Object> function2, Continuation<? super C08821> continuation) {
            super(2, continuation);
            this.$block = function2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return LegacyAdaptingPlatformTextInputModifierNode.this.new C08821(this.$block, continuation);
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
                if (PlatformTextInputModifierNodeKt.establishTextInputSession(LegacyAdaptingPlatformTextInputModifierNode.this, this.$block, (Continuation) this) == coroutine_suspended) {
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
    }

    @Override
    public Job launchTextInputSession(Function2<? super PlatformTextInputSession, ? super Continuation<?>, ? extends Object> block) {
        if (getIsAttached()) {
            return BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new C08821(block, null), 1, (Object) null);
        }
        return null;
    }
}
