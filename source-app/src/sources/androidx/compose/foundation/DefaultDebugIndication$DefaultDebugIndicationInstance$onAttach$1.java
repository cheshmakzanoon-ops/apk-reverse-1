package androidx.compose.foundation;

import androidx.compose.foundation.interaction.FocusInteraction;
import androidx.compose.foundation.interaction.HoverInteraction;
import androidx.compose.foundation.interaction.Interaction;
import androidx.compose.foundation.interaction.PressInteraction;
import androidx.compose.p002ui.node.DrawModifierNodeKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.DefaultDebugIndication$DefaultDebugIndicationInstance$onAttach$1", f = "Indication.kt", i = {}, l = {240}, m = "invokeSuspend", n = {}, s = {})
final class DefaultDebugIndication$DefaultDebugIndicationInstance$onAttach$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    int label;
    final DefaultDebugIndication.DefaultDebugIndicationInstance this$0;

    DefaultDebugIndication$DefaultDebugIndicationInstance$onAttach$1(DefaultDebugIndication.DefaultDebugIndicationInstance defaultDebugIndicationInstance, Continuation<? super DefaultDebugIndication$DefaultDebugIndicationInstance$onAttach$1> continuation) {
        super(2, continuation);
        this.this$0 = defaultDebugIndicationInstance;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new DefaultDebugIndication$DefaultDebugIndicationInstance$onAttach$1(this.this$0, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final Ref.IntRef intRef = new Ref.IntRef();
            final Ref.IntRef intRef2 = new Ref.IntRef();
            final Ref.IntRef intRef3 = new Ref.IntRef();
            Flow<Interaction> interactions = this.this$0.interactionSource.getInteractions();
            final DefaultDebugIndication.DefaultDebugIndicationInstance defaultDebugIndicationInstance = this.this$0;
            this.label = 1;
            if (interactions.collect(new FlowCollector() {
                public Object emit(Object obj2, Continuation continuation) {
                    return emit((Interaction) obj2, (Continuation<? super Unit>) continuation);
                }

                public final Object emit(Interaction interaction, Continuation<? super Unit> continuation) {
                    boolean z = true;
                    if (interaction instanceof PressInteraction.Press) {
                        intRef.element++;
                    } else if (interaction instanceof PressInteraction.Release) {
                        intRef.element--;
                    } else if (interaction instanceof PressInteraction.Cancel) {
                        intRef.element--;
                    } else if (interaction instanceof HoverInteraction.Enter) {
                        intRef2.element++;
                    } else if (interaction instanceof HoverInteraction.Exit) {
                        intRef2.element--;
                    } else if (interaction instanceof FocusInteraction.Focus) {
                        intRef3.element++;
                    } else if (interaction instanceof FocusInteraction.Unfocus) {
                        intRef3.element--;
                    }
                    boolean z2 = false;
                    boolean z3 = intRef.element > 0;
                    boolean z4 = intRef2.element > 0;
                    boolean z5 = intRef3.element > 0;
                    if (defaultDebugIndicationInstance.isPressed != z3) {
                        defaultDebugIndicationInstance.isPressed = z3;
                        z2 = true;
                    }
                    if (defaultDebugIndicationInstance.isHovered != z4) {
                        defaultDebugIndicationInstance.isHovered = z4;
                        z2 = true;
                    }
                    if (defaultDebugIndicationInstance.isFocused != z5) {
                        defaultDebugIndicationInstance.isFocused = z5;
                    } else {
                        z = z2;
                    }
                    if (z) {
                        DrawModifierNodeKt.invalidateDraw(defaultDebugIndicationInstance);
                    }
                    return Unit.INSTANCE;
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
