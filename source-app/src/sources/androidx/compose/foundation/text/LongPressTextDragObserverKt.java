package androidx.compose.foundation.text;

import androidx.compose.foundation.gestures.DragGestureDetectorKt;
import androidx.compose.foundation.gestures.ForEachGestureKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Job;

@Metadata(d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\u001a\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0080@¢\u0006\u0002\u0010\u0005\u001a\u001a\u0010\u0006\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0080@¢\u0006\u0002\u0010\u0005\u001a\u001a\u0010\u0007\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010\u0005\u001a\u001a\u0010\b\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010\u0005¨\u0006\t"}, d2 = {"detectDownAndDragGesturesWithObserver", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;", "observer", "Landroidx/compose/foundation/text/TextDragObserver;", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Landroidx/compose/foundation/text/TextDragObserver;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectDragGesturesAfterLongPressWithObserver", "detectDragGesturesWithObserver", "detectPreDragGesturesWithObserver", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LongPressTextDragObserverKt {
    public static final Object detectDragGesturesAfterLongPressWithObserver(PointerInputScope pointerInputScope, final TextDragObserver textDragObserver, Continuation<? super Unit> continuation) {
        Object objDetectDragGesturesAfterLongPress = DragGestureDetectorKt.detectDragGesturesAfterLongPress(pointerInputScope, new Function1<Offset, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                m1484invokek4lQ0M(((Offset) obj).getPackedValue());
                return Unit.INSTANCE;
            }

            public final void m1484invokek4lQ0M(long j) {
                textDragObserver.mo1525onStartk4lQ0M(j);
            }
        }, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m1485invoke();
                return Unit.INSTANCE;
            }

            public final void m1485invoke() {
                textDragObserver.onStop();
            }
        }, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m1486invoke();
                return Unit.INSTANCE;
            }

            public final void m1486invoke() {
                textDragObserver.onCancel();
            }
        }, new Function2<PointerInputChange, Offset, Unit>() {
            {
                super(2);
            }

            public Object invoke(Object obj, Object obj2) {
                m1487invokeUv8p0NA((PointerInputChange) obj, ((Offset) obj2).getPackedValue());
                return Unit.INSTANCE;
            }

            public final void m1487invokeUv8p0NA(PointerInputChange pointerInputChange, long j) {
                textDragObserver.mo1524onDragk4lQ0M(j);
            }
        }, continuation);
        return objDetectDragGesturesAfterLongPress == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDetectDragGesturesAfterLongPress : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Lkotlinx/coroutines/Job;", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.LongPressTextDragObserverKt$detectDownAndDragGesturesWithObserver$2", f = "LongPressTextDragObserver.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C08282 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Job>, Object> {
        final TextDragObserver $observer;
        final PointerInputScope $this_detectDownAndDragGesturesWithObserver;
        private Object L$0;
        int label;

        C08282(PointerInputScope pointerInputScope, TextDragObserver textDragObserver, Continuation<? super C08282> continuation) {
            super(2, continuation);
            this.$this_detectDownAndDragGesturesWithObserver = pointerInputScope;
            this.$observer = textDragObserver;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c08282 = new C08282(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, continuation);
            c08282.L$0 = obj;
            return c08282;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Job> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.LongPressTextDragObserverKt$detectDownAndDragGesturesWithObserver$2$1", f = "LongPressTextDragObserver.kt", i = {}, l = {83}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final TextDragObserver $observer;
            final PointerInputScope $this_detectDownAndDragGesturesWithObserver;
            int label;

            AnonymousClass1(PointerInputScope pointerInputScope, TextDragObserver textDragObserver, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$this_detectDownAndDragGesturesWithObserver = pointerInputScope;
                this.$observer = textDragObserver;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, continuation);
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
                    if (LongPressTextDragObserverKt.detectPreDragGesturesWithObserver(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, (Continuation) this) == coroutine_suspended) {
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
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass1(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, null), 1, (Object) null);
            return BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, CoroutineStart.UNDISPATCHED, new AnonymousClass2(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, null), 1, (Object) null);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.LongPressTextDragObserverKt$detectDownAndDragGesturesWithObserver$2$2", f = "LongPressTextDragObserver.kt", i = {}, l = {86}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final TextDragObserver $observer;
            final PointerInputScope $this_detectDownAndDragGesturesWithObserver;
            int label;

            AnonymousClass2(PointerInputScope pointerInputScope, TextDragObserver textDragObserver, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.$this_detectDownAndDragGesturesWithObserver = pointerInputScope;
                this.$observer = textDragObserver;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass2(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, continuation);
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
                    if (LongPressTextDragObserverKt.detectDragGesturesWithObserver(this.$this_detectDownAndDragGesturesWithObserver, this.$observer, (Continuation) this) == coroutine_suspended) {
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
    }

    public static final Object detectDownAndDragGesturesWithObserver(PointerInputScope pointerInputScope, TextDragObserver textDragObserver, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C08282(pointerInputScope, textDragObserver, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.LongPressTextDragObserverKt$detectPreDragGesturesWithObserver$2", f = "LongPressTextDragObserver.kt", i = {0, 1, 1}, l = {99, 103}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "$this$awaitEachGesture", "down"}, s = {"L$0", "L$0", "L$1"})
    static final class C08372 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final TextDragObserver $observer;
        private Object L$0;
        Object L$1;
        int label;

        C08372(TextDragObserver textDragObserver, Continuation<? super C08372> continuation) {
            super(2, continuation);
            this.$observer = textDragObserver;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c08372 = new C08372(this.$observer, continuation);
            c08372.L$0 = obj;
            return c08372;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final java.lang.Object invokeSuspend(java.lang.Object r13) {
            throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.text.LongPressTextDragObserverKt.C08372.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final Object detectPreDragGesturesWithObserver(PointerInputScope pointerInputScope, TextDragObserver textDragObserver, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C08372(textDragObserver, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    public static final Object detectDragGesturesWithObserver(PointerInputScope pointerInputScope, final TextDragObserver textDragObserver, Continuation<? super Unit> continuation) {
        Object objDetectDragGestures = DragGestureDetectorKt.detectDragGestures(pointerInputScope, new Function1<Offset, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                m1488invokek4lQ0M(((Offset) obj).getPackedValue());
                return Unit.INSTANCE;
            }

            public final void m1488invokek4lQ0M(long j) {
                textDragObserver.mo1525onStartk4lQ0M(j);
            }
        }, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m1489invoke();
                return Unit.INSTANCE;
            }

            public final void m1489invoke() {
                textDragObserver.onStop();
            }
        }, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m1490invoke();
                return Unit.INSTANCE;
            }

            public final void m1490invoke() {
                textDragObserver.onCancel();
            }
        }, new Function2<PointerInputChange, Offset, Unit>() {
            {
                super(2);
            }

            public Object invoke(Object obj, Object obj2) {
                m1491invokeUv8p0NA((PointerInputChange) obj, ((Offset) obj2).getPackedValue());
                return Unit.INSTANCE;
            }

            public final void m1491invokeUv8p0NA(PointerInputChange pointerInputChange, long j) {
                textDragObserver.mo1524onDragk4lQ0M(j);
            }
        }, continuation);
        return objDetectDragGestures == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDetectDragGestures : Unit.INSTANCE;
    }
}
