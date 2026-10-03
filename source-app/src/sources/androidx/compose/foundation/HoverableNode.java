package androidx.compose.foundation;

import androidx.compose.foundation.interaction.HoverInteraction;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.input.pointer.PointerEvent;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.PointerEventType;
import androidx.compose.p002ui.node.PointerInputModifierNode;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\u000e\u0010\b\u001a\u00020\tH\u0082@¢\u0006\u0002\u0010\nJ\u000e\u0010\u000b\u001a\u00020\tH\u0082@¢\u0006\u0002\u0010\nJ\b\u0010\f\u001a\u00020\tH\u0016J\b\u0010\r\u001a\u00020\tH\u0016J*\u0010\u000e\u001a\u00020\t2\u0006\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0014H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016J\b\u0010\u0017\u001a\u00020\tH\u0002J\u000e\u0010\u0018\u001a\u00020\t2\u0006\u0010\u0003\u001a\u00020\u0004R\u0010\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0019"}, d2 = {"Landroidx/compose/foundation/HoverableNode;", "Landroidx/compose/ui/node/PointerInputModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "interactionSource", "Landroidx/compose/foundation/interaction/MutableInteractionSource;", "(Landroidx/compose/foundation/interaction/MutableInteractionSource;)V", "hoverInteraction", "Landroidx/compose/foundation/interaction/HoverInteraction$Enter;", "emitEnter", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "emitExit", "onCancelPointerInput", "onDetach", "onPointerEvent", "pointerEvent", "Landroidx/compose/ui/input/pointer/PointerEvent;", "pass", "Landroidx/compose/ui/input/pointer/PointerEventPass;", "bounds", "Landroidx/compose/ui/unit/IntSize;", "onPointerEvent-H0pRuoY", "(Landroidx/compose/ui/input/pointer/PointerEvent;Landroidx/compose/ui/input/pointer/PointerEventPass;J)V", "tryEmitExit", "updateInteractionSource", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class HoverableNode extends Modifier.Node implements PointerInputModifierNode {
    private HoverInteraction.Enter hoverInteraction;
    private MutableInteractionSource interactionSource;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.HoverableNode", f = "Hoverable.kt", i = {0, 0}, l = {111}, m = "emitEnter", n = {"this", "interaction"}, s = {"L$0", "L$1"})
    static final class C03851 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C03851(Continuation<? super C03851> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return HoverableNode.this.emitEnter((Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.HoverableNode", f = "Hoverable.kt", i = {0}, l = {119}, m = "emitExit", n = {"this"}, s = {"L$0"})
    static final class C03861 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C03861(Continuation<? super C03861> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return HoverableNode.this.emitExit((Continuation) this);
        }
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
    public void onViewConfigurationChange() {
        onCancelPointerInput();
    }

    @Override
    public boolean sharePointerInputWithSiblings() {
        return PointerInputModifierNode.CC.$default$sharePointerInputWithSiblings(this);
    }

    public HoverableNode(MutableInteractionSource mutableInteractionSource) {
        this.interactionSource = mutableInteractionSource;
    }

    public final void updateInteractionSource(MutableInteractionSource interactionSource) {
        if (Intrinsics.areEqual(this.interactionSource, interactionSource)) {
            return;
        }
        tryEmitExit();
        this.interactionSource = interactionSource;
    }

    @Override
    public void mo491onPointerEventH0pRuoY(PointerEvent pointerEvent, PointerEventPass pass, long bounds) {
        if (pass == PointerEventPass.Main) {
            int type = pointerEvent.getType();
            if (PointerEventType.m5795equalsimpl0(type, PointerEventType.INSTANCE.m5799getEnter7fucELk())) {
                BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new HoverableNode$onPointerEvent$1(this, null), 3, (Object) null);
            } else if (PointerEventType.m5795equalsimpl0(type, PointerEventType.INSTANCE.m5800getExit7fucELk())) {
                BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new HoverableNode$onPointerEvent$2(this, null), 3, (Object) null);
            }
        }
    }

    @Override
    public void onCancelPointerInput() {
        tryEmitExit();
    }

    @Override
    public void onDetach() {
        tryEmitExit();
    }

    public final Object emitEnter(Continuation<? super Unit> continuation) {
        C03851 c03851;
        HoverableNode hoverableNode;
        HoverInteraction.Enter enter;
        if (continuation instanceof C03851) {
            c03851 = (C03851) continuation;
            if ((c03851.label & Integer.MIN_VALUE) != 0) {
                c03851.label -= Integer.MIN_VALUE;
            } else {
                c03851 = new C03851(continuation);
            }
        } else {
            c03851 = new C03851(continuation);
        }
        Object obj = c03851.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03851.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (this.hoverInteraction == null) {
                HoverInteraction.Enter enter2 = new HoverInteraction.Enter();
                c03851.L$0 = this;
                c03851.L$1 = enter2;
                c03851.label = 1;
                if (this.interactionSource.emit(enter2, c03851) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                hoverableNode = this;
                enter = enter2;
            }
            return Unit.INSTANCE;
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        enter = (HoverInteraction.Enter) c03851.L$1;
        hoverableNode = (HoverableNode) c03851.L$0;
        ResultKt.throwOnFailure(obj);
        hoverableNode.hoverInteraction = enter;
        return Unit.INSTANCE;
    }

    public final Object emitExit(Continuation<? super Unit> continuation) {
        C03861 c03861;
        HoverableNode hoverableNode;
        if (continuation instanceof C03861) {
            c03861 = (C03861) continuation;
            if ((c03861.label & Integer.MIN_VALUE) != 0) {
                c03861.label -= Integer.MIN_VALUE;
            } else {
                c03861 = new C03861(continuation);
            }
        } else {
            c03861 = new C03861(continuation);
        }
        Object obj = c03861.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03861.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            HoverInteraction.Enter enter = this.hoverInteraction;
            if (enter != null) {
                HoverInteraction.Exit exit = new HoverInteraction.Exit(enter);
                c03861.L$0 = this;
                c03861.label = 1;
                if (this.interactionSource.emit(exit, c03861) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                hoverableNode = this;
            }
            return Unit.INSTANCE;
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        hoverableNode = (HoverableNode) c03861.L$0;
        ResultKt.throwOnFailure(obj);
        hoverableNode.hoverInteraction = null;
        return Unit.INSTANCE;
    }

    private final void tryEmitExit() {
        HoverInteraction.Enter enter = this.hoverInteraction;
        if (enter != null) {
            this.interactionSource.tryEmit(new HoverInteraction.Exit(enter));
            this.hoverInteraction = null;
        }
    }
}
