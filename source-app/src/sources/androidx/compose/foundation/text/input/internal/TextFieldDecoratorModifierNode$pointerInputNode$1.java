package androidx.compose.foundation.text.input.internal;

import androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState;
import androidx.compose.p002ui.focus.FocusRequesterModifierNodeKt;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.runtime.ComposerKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.input.internal.TextFieldDecoratorModifierNode$pointerInputNode$1", f = "TextFieldDecoratorModifier.kt", i = {}, l = {ComposerKt.providerKey}, m = "invokeSuspend", n = {}, s = {})
final class TextFieldDecoratorModifierNode$pointerInputNode$1 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
    private Object L$0;
    int label;
    final TextFieldDecoratorModifierNode this$0;

    TextFieldDecoratorModifierNode$pointerInputNode$1(TextFieldDecoratorModifierNode textFieldDecoratorModifierNode, Continuation<? super TextFieldDecoratorModifierNode$pointerInputNode$1> continuation) {
        super(2, continuation);
        this.this$0 = textFieldDecoratorModifierNode;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> textFieldDecoratorModifierNode$pointerInputNode$1 = new TextFieldDecoratorModifierNode$pointerInputNode$1(this.this$0, continuation);
        textFieldDecoratorModifierNode$pointerInputNode$1.L$0 = obj;
        return textFieldDecoratorModifierNode$pointerInputNode$1;
    }

    public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
        return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.TextFieldDecoratorModifierNode$pointerInputNode$1$1", f = "TextFieldDecoratorModifier.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C09081 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final PointerInputScope $$this$SuspendingPointerInputModifierNode;
        private Object L$0;
        int label;
        final TextFieldDecoratorModifierNode this$0;

        C09081(TextFieldDecoratorModifierNode textFieldDecoratorModifierNode, PointerInputScope pointerInputScope, Continuation<? super C09081> continuation) {
            super(2, continuation);
            this.this$0 = textFieldDecoratorModifierNode;
            this.$$this$SuspendingPointerInputModifierNode = pointerInputScope;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09081 = new C09081(this.this$0, this.$$this$SuspendingPointerInputModifierNode, continuation);
            c09081.L$0 = obj;
            return c09081;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            final TextFieldSelectionState textFieldSelectionState = this.this$0.getTextFieldSelectionState();
            final TextFieldDecoratorModifierNode textFieldDecoratorModifierNode = this.this$0;
            PointerInputScope pointerInputScope = this.$$this$SuspendingPointerInputModifierNode;
            Function0<Unit> function0 = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m1692invoke();
                    return Unit.INSTANCE;
                }

                public final void m1692invoke() {
                    if (textFieldSelectionState.getIsFocused()) {
                        return;
                    }
                    FocusRequesterModifierNodeKt.requestFocus(textFieldDecoratorModifierNode);
                }
            };
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new TextFieldDecoratorModifierNode$pointerInputNode$1$1$1$1(textFieldSelectionState, pointerInputScope, null), 1, (Object) null);
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new TextFieldDecoratorModifierNode$pointerInputNode$1$1$1$2(textFieldDecoratorModifierNode, textFieldSelectionState, pointerInputScope, function0, null), 1, (Object) null);
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new TextFieldDecoratorModifierNode$pointerInputNode$1$1$1$3(textFieldSelectionState, pointerInputScope, function0, null), 1, (Object) null);
            return Unit.INSTANCE;
        }
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            PointerInputScope pointerInputScope = (PointerInputScope) this.L$0;
            this.label = 1;
            if (CoroutineScopeKt.coroutineScope(new C09081(this.this$0, pointerInputScope, null), (Continuation) this) == coroutine_suspended) {
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
