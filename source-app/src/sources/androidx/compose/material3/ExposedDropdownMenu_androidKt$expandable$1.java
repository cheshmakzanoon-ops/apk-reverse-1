package androidx.compose.material3;

import androidx.compose.foundation.gestures.ForEachGestureKt;
import androidx.compose.foundation.gestures.TapGestureDetectorKt;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.ExposedDropdownMenu_androidKt$expandable$1", f = "ExposedDropdownMenu.android.kt", i = {}, l = {1426}, m = "invokeSuspend", n = {}, s = {})
final class ExposedDropdownMenu_androidKt$expandable$1 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
    final String $anchorType;
    final Function0<Unit> $onExpandedChange;
    private Object L$0;
    int label;

    ExposedDropdownMenu_androidKt$expandable$1(String str, Function0<Unit> function0, Continuation<? super ExposedDropdownMenu_androidKt$expandable$1> continuation) {
        super(2, continuation);
        this.$anchorType = str;
        this.$onExpandedChange = function0;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> exposedDropdownMenu_androidKt$expandable$1 = new ExposedDropdownMenu_androidKt$expandable$1(this.$anchorType, this.$onExpandedChange, continuation);
        exposedDropdownMenu_androidKt$expandable$1.L$0 = obj;
        return exposedDropdownMenu_androidKt$expandable$1;
    }

    public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
        return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.ExposedDropdownMenu_androidKt$expandable$1$1", f = "ExposedDropdownMenu.android.kt", i = {0}, l = {1430, 1434}, m = "invokeSuspend", n = {"$this$awaitEachGesture"}, s = {"L$0"})
    static final class C11881 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final String $anchorType;
        final Function0<Unit> $onExpandedChange;
        private Object L$0;
        int label;

        C11881(String str, Function0<Unit> function0, Continuation<? super C11881> continuation) {
            super(2, continuation);
            this.$anchorType = str;
            this.$onExpandedChange = function0;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c11881 = new C11881(this.$anchorType, this.$onExpandedChange, continuation);
            c11881.L$0 = obj;
            return c11881;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AwaitPointerEventScope awaitPointerEventScope;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i != 0) {
                if (i == 1) {
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                if (((PointerInputChange) obj) != null) {
                    this.$onExpandedChange.invoke();
                }
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
            this.L$0 = awaitPointerEventScope;
            this.label = 1;
            obj = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope, false, PointerEventPass.Initial, (Continuation) this, 1, null);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            PointerInputChange pointerInputChange = (PointerInputChange) obj;
            if (MenuAnchorType.m2506equalsimpl0(this.$anchorType, MenuAnchorType.INSTANCE.m2512getSecondaryEditableMg6Rgbw())) {
                pointerInputChange.consume();
            }
            this.L$0 = null;
            this.label = 2;
            obj = TapGestureDetectorKt.waitForUpOrCancellation(awaitPointerEventScope, PointerEventPass.Initial, (Continuation) this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            if (((PointerInputChange) obj) != null) {
                this.$onExpandedChange.invoke();
            }
            return Unit.INSTANCE;
        }
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (ForEachGestureKt.awaitEachGesture((PointerInputScope) this.L$0, new C11881(this.$anchorType, this.$onExpandedChange, null), (Continuation) this) == coroutine_suspended) {
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
