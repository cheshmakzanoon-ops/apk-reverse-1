package androidx.compose.foundation.contextmenu;

import androidx.compose.foundation.gestures.ForEachGestureKt;
import androidx.compose.foundation.gestures.TapGestureDetectorKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u00000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u0012\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0082@¢\u0006\u0002\u0010\u0003\u001a\u0014\u0010\u0004\u001a\u00020\u0005*\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0000\u001a&\u0010\b\u001a\u00020\t*\u00020\n2\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\r\u0012\u0004\u0012\u00020\t0\fH\u0081@¢\u0006\u0002\u0010\u000e¨\u0006\u000f"}, d2 = {"awaitFirstRightClickDown", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "contextMenuGestures", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/contextmenu/ContextMenuState;", "onRightClickDown", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;", "onDown", "Lkotlin/Function1;", "Landroidx/compose/ui/geometry/Offset;", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ContextMenuGestures_androidKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.contextmenu.ContextMenuGestures_androidKt", f = "ContextMenuGestures.android.kt", i = {0}, l = {66}, m = "awaitFirstRightClickDown", n = {"$this$awaitFirstRightClickDown"}, s = {"L$0"})
    static final class C04101 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C04101(Continuation<? super C04101> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ContextMenuGestures_androidKt.awaitFirstRightClickDown(null, (Continuation) this);
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.contextmenu.ContextMenuGestures_androidKt$contextMenuGestures$1", f = "ContextMenuGestures.android.kt", i = {}, l = {44}, m = "invokeSuspend", n = {}, s = {})
    static final class C04111 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
        final ContextMenuState $state;
        private Object L$0;
        int label;

        C04111(ContextMenuState contextMenuState, Continuation<? super C04111> continuation) {
            super(2, continuation);
            this.$state = contextMenuState;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04111 = new C04111(this.$state, continuation);
            c04111.L$0 = obj;
            return c04111;
        }

        public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
            return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                PointerInputScope pointerInputScope = (PointerInputScope) this.L$0;
                final ContextMenuState contextMenuState = this.$state;
                this.label = 1;
                if (ContextMenuGestures_androidKt.onRightClickDown(pointerInputScope, new Function1<Offset, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj2) {
                        m646invokek4lQ0M(((Offset) obj2).getPackedValue());
                        return Unit.INSTANCE;
                    }

                    public final void m646invokek4lQ0M(long j) {
                        contextMenuState.setStatus(new ContextMenuState.Status.Open(j, null));
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

    public static final Modifier contextMenuGestures(Modifier modifier, ContextMenuState contextMenuState) {
        return SuspendingPointerInputFilterKt.pointerInput(modifier, ContextMenuKey.INSTANCE, new C04111(contextMenuState, null));
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.contextmenu.ContextMenuGestures_androidKt$onRightClickDown$2", f = "ContextMenuGestures.android.kt", i = {0}, l = {53, 56}, m = "invokeSuspend", n = {"$this$awaitEachGesture"}, s = {"L$0"})
    static final class C04122 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final Function1<Offset, Unit> $onDown;
        private Object L$0;
        int label;

        C04122(Function1<? super Offset, Unit> function1, Continuation<? super C04122> continuation) {
            super(2, continuation);
            this.$onDown = function1;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04122 = new C04122(this.$onDown, continuation);
            c04122.L$0 = obj;
            return c04122;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AwaitPointerEventScope awaitPointerEventScope;
            PointerInputChange pointerInputChange;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                this.L$0 = awaitPointerEventScope;
                this.label = 1;
                obj = ContextMenuGestures_androidKt.awaitFirstRightClickDown(awaitPointerEventScope, (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                pointerInputChange = (PointerInputChange) obj;
                if (pointerInputChange != null) {
                    pointerInputChange.consume();
                }
                return Unit.INSTANCE;
            }
            PointerInputChange pointerInputChange2 = (PointerInputChange) obj;
            pointerInputChange2.consume();
            this.$onDown.invoke(Offset.m4335boximpl(pointerInputChange2.getPosition()));
            this.L$0 = null;
            this.label = 2;
            obj = TapGestureDetectorKt.waitForUpOrCancellation$default(awaitPointerEventScope, null, (Continuation) this, 1, null);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            pointerInputChange = (PointerInputChange) obj;
            if (pointerInputChange != null) {
                pointerInputChange.consume();
            }
            return Unit.INSTANCE;
        }
    }

    public static final Object onRightClickDown(PointerInputScope pointerInputScope, Function1<? super Offset, Unit> function1, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C04122(function1, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    public static final java.lang.Object awaitFirstRightClickDown(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r8, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r9) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.contextmenu.ContextMenuGestures_androidKt.awaitFirstRightClickDown(androidx.compose.ui.input.pointer.AwaitPointerEventScope, kotlin.coroutines.Continuation):java.lang.Object");
    }
}
