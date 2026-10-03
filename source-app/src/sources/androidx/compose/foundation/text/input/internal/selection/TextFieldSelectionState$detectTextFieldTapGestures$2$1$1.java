package androidx.compose.foundation.text.input.internal.selection;

import androidx.compose.foundation.gestures.PressGestureScope;
import androidx.compose.foundation.interaction.MutableInteractionSource;
import androidx.compose.foundation.interaction.PressInteraction;
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

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$detectTextFieldTapGestures$2$1$1", f = "TextFieldSelectionState.kt", i = {}, l = {504, 511}, m = "invokeSuspend", n = {}, s = {})
final class TextFieldSelectionState$detectTextFieldTapGestures$2$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final PressGestureScope $$this$detectTapAndPress;
    final MutableInteractionSource $interactionSource;
    final long $offset;
    private Object L$0;
    int label;
    final TextFieldSelectionState this$0;

    TextFieldSelectionState$detectTextFieldTapGestures$2$1$1(PressGestureScope pressGestureScope, TextFieldSelectionState textFieldSelectionState, long j, MutableInteractionSource mutableInteractionSource, Continuation<? super TextFieldSelectionState$detectTextFieldTapGestures$2$1$1> continuation) {
        super(2, continuation);
        this.$$this$detectTapAndPress = pressGestureScope;
        this.this$0 = textFieldSelectionState;
        this.$offset = j;
        this.$interactionSource = mutableInteractionSource;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> textFieldSelectionState$detectTextFieldTapGestures$2$1$1 = new TextFieldSelectionState$detectTextFieldTapGestures$2$1$1(this.$$this$detectTapAndPress, this.this$0, this.$offset, this.$interactionSource, continuation);
        textFieldSelectionState$detectTextFieldTapGestures$2$1$1.L$0 = obj;
        return textFieldSelectionState$detectTextFieldTapGestures$2$1$1;
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState$detectTextFieldTapGestures$2$1$1$1", f = "TextFieldSelectionState.kt", i = {1}, l = {496, 501}, m = "invokeSuspend", n = {"press"}, s = {"L$0"})
    static final class C09391 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final MutableInteractionSource $interactionSource;
        final long $offset;
        Object L$0;
        int label;
        final TextFieldSelectionState this$0;

        C09391(TextFieldSelectionState textFieldSelectionState, long j, MutableInteractionSource mutableInteractionSource, Continuation<? super C09391> continuation) {
            super(2, continuation);
            this.this$0 = textFieldSelectionState;
            this.$offset = j;
            this.$interactionSource = mutableInteractionSource;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C09391(this.this$0, this.$offset, this.$interactionSource, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            TextFieldSelectionState textFieldSelectionState;
            PressInteraction.Press press;
            PressInteraction.Press press2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i != 0) {
                if (i == 1) {
                    textFieldSelectionState = (TextFieldSelectionState) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    press2 = (PressInteraction.Press) this.L$0;
                    ResultKt.throwOnFailure(obj);
                }
                this.this$0.pressInteraction = press2;
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            PressInteraction.Press press3 = this.this$0.pressInteraction;
            if (press3 != null) {
                MutableInteractionSource mutableInteractionSource = this.$interactionSource;
                TextFieldSelectionState textFieldSelectionState2 = this.this$0;
                PressInteraction.Cancel cancel = new PressInteraction.Cancel(press3);
                this.L$0 = textFieldSelectionState2;
                this.label = 1;
                if (mutableInteractionSource.emit(cancel, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                textFieldSelectionState = textFieldSelectionState2;
            }
            press = new PressInteraction.Press(this.$offset, null);
            this.L$0 = press;
            this.label = 2;
            if (this.$interactionSource.emit(press, (Continuation) this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            press2 = press;
            this.this$0.pressInteraction = press2;
            return Unit.INSTANCE;
            textFieldSelectionState.pressInteraction = null;
            press = new PressInteraction.Press(this.$offset, null);
            this.L$0 = press;
            this.label = 2;
            if (this.$interactionSource.emit(press, (Continuation) this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            press2 = press;
            this.this$0.pressInteraction = press2;
            return Unit.INSTANCE;
        }
    }

    public final Object invokeSuspend(Object obj) {
        PressInteraction.Cancel cancel;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i != 0) {
            if (i == 1) {
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            this.this$0.pressInteraction = null;
            return Unit.INSTANCE;
        }
        ResultKt.throwOnFailure(obj);
        BuildersKt.launch$default((CoroutineScope) this.L$0, (CoroutineContext) null, (CoroutineStart) null, new C09391(this.this$0, this.$offset, this.$interactionSource, null), 3, (Object) null);
        this.label = 1;
        obj = this.$$this$detectTapAndPress.tryAwaitRelease((Continuation) this);
        if (obj == coroutine_suspended) {
            return coroutine_suspended;
        }
        boolean zBooleanValue = ((Boolean) obj).booleanValue();
        PressInteraction.Press press = this.this$0.pressInteraction;
        if (press != null) {
            MutableInteractionSource mutableInteractionSource = this.$interactionSource;
            if (zBooleanValue) {
                cancel = new PressInteraction.Release(press);
            } else {
                cancel = new PressInteraction.Cancel(press);
            }
            this.label = 2;
            if (mutableInteractionSource.emit(cancel, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        this.this$0.pressInteraction = null;
        return Unit.INSTANCE;
    }
}
