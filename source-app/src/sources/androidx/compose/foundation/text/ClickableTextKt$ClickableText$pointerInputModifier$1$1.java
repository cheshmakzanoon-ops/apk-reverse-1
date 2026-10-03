package androidx.compose.foundation.text;

import androidx.compose.foundation.gestures.TapGestureDetectorKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.runtime.MutableState;
import androidx.compose.ui.text.TextLayoutResult;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.ClickableTextKt$ClickableText$pointerInputModifier$1$1", f = "ClickableText.kt", i = {}, l = {184}, m = "invokeSuspend", n = {}, s = {})
final class ClickableTextKt$ClickableText$pointerInputModifier$1$1 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
    final CoroutineScope $coroutineScope;
    final MutableState<TextLayoutResult> $layoutResult;
    final Function1<Integer, Unit> $onClick;
    final Function1<Integer, Unit> $onHover;
    private Object L$0;
    int label;

    ClickableTextKt$ClickableText$pointerInputModifier$1$1(CoroutineScope coroutineScope, Function1<? super Integer, Unit> function1, MutableState<TextLayoutResult> mutableState, Function1<? super Integer, Unit> function2, Continuation<? super ClickableTextKt$ClickableText$pointerInputModifier$1$1> continuation) {
        super(2, continuation);
        this.$coroutineScope = coroutineScope;
        this.$onHover = function1;
        this.$layoutResult = mutableState;
        this.$onClick = function2;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> clickableTextKt$ClickableText$pointerInputModifier$1$1 = new ClickableTextKt$ClickableText$pointerInputModifier$1$1(this.$coroutineScope, this.$onHover, this.$layoutResult, this.$onClick, continuation);
        clickableTextKt$ClickableText$pointerInputModifier$1$1.L$0 = obj;
        return clickableTextKt$ClickableText$pointerInputModifier$1$1;
    }

    public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
        return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.ClickableTextKt$ClickableText$pointerInputModifier$1$1$1", f = "ClickableText.kt", i = {}, l = {175}, m = "invokeSuspend", n = {}, s = {})
    static final class C07961 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final PointerInputScope $$this$pointerInput;
        final MutableState<TextLayoutResult> $layoutResult;
        final Function1<Integer, Unit> $onHover;
        int label;

        C07961(PointerInputScope pointerInputScope, Function1<? super Integer, Unit> function1, MutableState<TextLayoutResult> mutableState, Continuation<? super C07961> continuation) {
            super(2, continuation);
            this.$$this$pointerInput = pointerInputScope;
            this.$onHover = function1;
            this.$layoutResult = mutableState;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C07961(this.$$this$pointerInput, this.$onHover, this.$layoutResult, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                final Ref.ObjectRef objectRef = new Ref.ObjectRef();
                PointerInputScope pointerInputScope = this.$$this$pointerInput;
                PointerEventPass pointerEventPass = PointerEventPass.Main;
                final Function1<Integer, Unit> function1 = this.$onHover;
                final MutableState<TextLayoutResult> mutableState = this.$layoutResult;
                this.label = 1;
                if (PointerMoveDetectorKt.detectMoves(pointerInputScope, pointerEventPass, new Function1<Offset, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj2) {
                        m1430invokek4lQ0M(((Offset) obj2).getPackedValue());
                        return Unit.INSTANCE;
                    }

                    public final void m1430invokek4lQ0M(long j) {
                        Integer numClickableText_03UYbkw$getOffset = ClickableTextKt.ClickableText_03UYbkw$getOffset(mutableState, j);
                        if (Intrinsics.areEqual(objectRef.element, numClickableText_03UYbkw$getOffset)) {
                            return;
                        }
                        objectRef.element = numClickableText_03UYbkw$getOffset;
                        function1.invoke(numClickableText_03UYbkw$getOffset);
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

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            PointerInputScope pointerInputScope = (PointerInputScope) this.L$0;
            BuildersKt.launch$default(this.$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C07961(pointerInputScope, this.$onHover, this.$layoutResult, null), 3, (Object) null);
            final Function1<Integer, Unit> function1 = this.$onClick;
            final MutableState<TextLayoutResult> mutableState = this.$layoutResult;
            this.label = 1;
            if (TapGestureDetectorKt.detectTapGestures$default(pointerInputScope, null, null, null, new Function1<Offset, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    m1431invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m1431invokek4lQ0M(long j) {
                    Integer numClickableText_03UYbkw$getOffset = ClickableTextKt.ClickableText_03UYbkw$getOffset(mutableState, j);
                    if (numClickableText_03UYbkw$getOffset != null) {
                        function1.invoke(numClickableText_03UYbkw$getOffset);
                    }
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
