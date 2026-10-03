package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerEventPass;
import androidx.compose.p002ui.input.pointer.PointerEventTimeoutCancellationException;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000L\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\u001a\u001c\u0010\t\u001a\u00020\n*\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\rH\u0087@¢\u0006\u0002\u0010\u000e\u001a&\u0010\t\u001a\u00020\n*\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000f\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\u0011\u001a\u001c\u0010\u0012\u001a\u0004\u0018\u00010\n*\u00020\u000b2\u0006\u0010\u0013\u001a\u00020\nH\u0082@¢\u0006\u0002\u0010\u0014\u001a\u0012\u0010\u0015\u001a\u00020\u0005*\u00020\u000bH\u0082@¢\u0006\u0002\u0010\u0016\u001a[\u0010\u0017\u001a\u00020\u0005*\u00020\u00182/\b\u0002\u0010\u0019\u001a)\b\u0001\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u0001¢\u0006\u0002\b\u00072\u0016\b\u0002\u0010\u001a\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u001bH\u0080@¢\u0006\u0002\u0010\u001c\u001a\u008b\u0001\u0010\u001d\u001a\u00020\u0005*\u00020\u00182\u0016\b\u0002\u0010\u001e\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u001b2\u0016\b\u0002\u0010\u001f\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u001b2/\b\u0002\u0010\u0019\u001a)\b\u0001\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u0001¢\u0006\u0002\b\u00072\u0016\b\u0002\u0010\u001a\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u001bH\u0086@¢\u0006\u0002\u0010 \u001a\u0014\u0010!\u001a\u0004\u0018\u00010\n*\u00020\u000bH\u0087@¢\u0006\u0002\u0010\u0016\u001a\u001e\u0010!\u001a\u0004\u0018\u00010\n*\u00020\u000b2\b\b\u0002\u0010\u000f\u001a\u00020\u0010H\u0086@¢\u0006\u0002\u0010\"\"7\u0010\u0000\u001a)\b\u0001\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00050\u0004\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u0001¢\u0006\u0002\b\u0007X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\b¨\u0006#"}, d2 = {"NoPressGesture", "Lkotlin/Function3;", "Landroidx/compose/foundation/gestures/PressGestureScope;", "Landroidx/compose/ui/geometry/Offset;", "Lkotlin/coroutines/Continuation;", "", "", "Lkotlin/ExtensionFunctionType;", "Lkotlin/jvm/functions/Function3;", "awaitFirstDown", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;", "requireUnconsumed", "", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "pass", "Landroidx/compose/ui/input/pointer/PointerEventPass;", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;ZLandroidx/compose/ui/input/pointer/PointerEventPass;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitSecondDown", "firstUp", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Landroidx/compose/ui/input/pointer/PointerInputChange;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "consumeUntilUp", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectTapAndPress", "Landroidx/compose/ui/input/pointer/PointerInputScope;", "onPress", "onTap", "Lkotlin/Function1;", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "detectTapGestures", "onDoubleTap", "onLongPress", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "waitForUpOrCancellation", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Landroidx/compose/ui/input/pointer/PointerEventPass;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TapGestureDetectorKt {
    private static final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> NoPressGesture = new TapGestureDetectorKt$NoPressGesture$1(null);

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt", f = "TapGestureDetector.kt", i = {0, 0, 0}, l = {279}, m = "awaitFirstDown", n = {"$this$awaitFirstDown", "pass", "requireUnconsumed"}, s = {"L$0", "L$1", "Z$0"})
    static final class C04932 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        boolean Z$0;
        int label;
        Object result;

        C04932(Continuation<? super C04932> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TapGestureDetectorKt.awaitFirstDown(null, false, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt", f = "TapGestureDetector.kt", i = {0}, l = {195}, m = "consumeUntilUp", n = {"$this$consumeUntilUp"}, s = {"L$0"})
    static final class C04951 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C04951(Continuation<? super C04951> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TapGestureDetectorKt.consumeUntilUp(null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt", f = "TapGestureDetector.kt", i = {0, 0, 1, 1}, l = {305, 320}, m = "waitForUpOrCancellation", n = {"$this$waitForUpOrCancellation", "pass", "$this$waitForUpOrCancellation", "pass"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C04982 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C04982(Continuation<? super C04982> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return TapGestureDetectorKt.waitForUpOrCancellation(null, null, (Continuation) this);
        }
    }

    public static Object detectTapGestures$default(PointerInputScope pointerInputScope, Function1 function1, Function1 function2, Function3 function3, Function1 function4, Continuation continuation, int i, Object obj) {
        Function1 function5 = (i & 1) != 0 ? null : function1;
        Function1 function6 = (i & 2) != 0 ? null : function2;
        if ((i & 4) != 0) {
            function3 = NoPressGesture;
        }
        return detectTapGestures(pointerInputScope, function5, function6, function3, (i & 8) != 0 ? null : function4, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2", f = "TapGestureDetector.kt", i = {}, l = {99}, m = "invokeSuspend", n = {}, s = {})
    static final class C04972 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function1<Offset, Unit> $onDoubleTap;
        final Function1<Offset, Unit> $onLongPress;
        final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
        final Function1<Offset, Unit> $onTap;
        final PointerInputScope $this_detectTapGestures;
        private Object L$0;
        int label;

        C04972(PointerInputScope pointerInputScope, Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, Function1<? super Offset, Unit> function1, Function1<? super Offset, Unit> function2, Function1<? super Offset, Unit> function4, Continuation<? super C04972> continuation) {
            super(2, continuation);
            this.$this_detectTapGestures = pointerInputScope;
            this.$onPress = function3;
            this.$onLongPress = function1;
            this.$onDoubleTap = function2;
            this.$onTap = function4;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04972 = new C04972(this.$this_detectTapGestures, this.$onPress, this.$onLongPress, this.$onDoubleTap, this.$onTap, continuation);
            c04972.L$0 = obj;
            return c04972;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                PressGestureScopeImpl pressGestureScopeImpl = new PressGestureScopeImpl(this.$this_detectTapGestures);
                this.label = 1;
                if (ForEachGestureKt.awaitEachGesture(this.$this_detectTapGestures, new AnonymousClass1(coroutineScope, this.$onPress, this.$onLongPress, this.$onDoubleTap, this.$onTap, pressGestureScopeImpl, null), (Continuation) this) == coroutine_suspended) {
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

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1", f = "TapGestureDetector.kt", i = {0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4}, l = {100, 114, 129, 141, 156, 178}, m = "invokeSuspend", n = {"$this$awaitEachGesture", "$this$awaitEachGesture", "down", "upOrCancel", "longPressTimeout", "$this$awaitEachGesture", "upOrCancel", "longPressTimeout", "$this$awaitEachGesture", "upOrCancel", "longPressTimeout", "$this$awaitEachGesture", "upOrCancel", "secondDown"}, s = {"L$0", "L$0", "L$1", "L$2", "J$0", "L$0", "L$1", "J$0", "L$0", "L$1", "J$0", "L$0", "L$1", "L$2"})
        static final class AnonymousClass1 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
            final CoroutineScope $$this$coroutineScope;
            final Function1<Offset, Unit> $onDoubleTap;
            final Function1<Offset, Unit> $onLongPress;
            final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
            final Function1<Offset, Unit> $onTap;
            final PressGestureScopeImpl $pressScope;
            long J$0;
            private Object L$0;
            Object L$1;
            Object L$2;
            Object L$3;
            int label;

            AnonymousClass1(CoroutineScope coroutineScope, Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, Function1<? super Offset, Unit> function1, Function1<? super Offset, Unit> function2, Function1<? super Offset, Unit> function4, PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$$this$coroutineScope = coroutineScope;
                this.$onPress = function3;
                this.$onLongPress = function1;
                this.$onDoubleTap = function2;
                this.$onTap = function4;
                this.$pressScope = pressGestureScopeImpl;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$$this$coroutineScope, this.$onPress, this.$onLongPress, this.$onDoubleTap, this.$onTap, this.$pressScope, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                AwaitPointerEventScope awaitPointerEventScope;
                Object objAwaitFirstDown$default;
                AwaitPointerEventScope awaitPointerEventScope2;
                PointerInputChange pointerInputChange;
                long longPressTimeoutMillis;
                Ref.ObjectRef objectRef;
                Object objWithTimeout;
                AwaitPointerEventScope awaitPointerEventScope3;
                PointerInputChange pointerInputChange2;
                Ref.ObjectRef objectRef2;
                AwaitPointerEventScope awaitPointerEventScope4;
                Function1<Offset, Unit> function1;
                Object objAwaitSecondDown;
                Ref.ObjectRef objectRef3;
                AwaitPointerEventScope awaitPointerEventScope5;
                Function1<Offset, Unit> function2;
                PointerInputChange pointerInputChange3;
                Ref.ObjectRef objectRef4;
                AwaitPointerEventScope awaitPointerEventScope6;
                Ref.ObjectRef objectRef5;
                Function1<Offset, Unit> function3;
                Function1<Offset, Unit> function4;
                Function1<Offset, Unit> function5;
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                switch (this.label) {
                    case 0:
                        ResultKt.throwOnFailure(obj);
                        awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                        this.L$0 = awaitPointerEventScope;
                        this.label = 1;
                        objAwaitFirstDown$default = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope, false, null, (Continuation) this, 3, null);
                        if (objAwaitFirstDown$default == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        awaitPointerEventScope2 = awaitPointerEventScope;
                        pointerInputChange = (PointerInputChange) objAwaitFirstDown$default;
                        pointerInputChange.consume();
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C17931(this.$pressScope, null), 3, (Object) null);
                        if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass2(this.$onPress, this.$pressScope, pointerInputChange, null), 3, (Object) null);
                        }
                        if (this.$onLongPress != null) {
                            longPressTimeoutMillis = awaitPointerEventScope2.getViewConfiguration().getLongPressTimeoutMillis();
                        } else {
                            longPressTimeoutMillis = 4611686018427387903L;
                        }
                        objectRef = new Ref.ObjectRef();
                        try {
                            this.L$0 = awaitPointerEventScope2;
                            this.L$1 = pointerInputChange;
                            this.L$2 = objectRef;
                            this.L$3 = objectRef;
                            this.J$0 = longPressTimeoutMillis;
                            this.label = 2;
                            objWithTimeout = awaitPointerEventScope2.withTimeout(longPressTimeoutMillis, new AnonymousClass3(null), (Continuation) this);
                            if (objWithTimeout == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            awaitPointerEventScope3 = awaitPointerEventScope2;
                            pointerInputChange2 = pointerInputChange;
                            objectRef2 = objectRef;
                            try {
                                objectRef.element = objWithTimeout;
                                if (objectRef2.element == null) {
                                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass4(this.$pressScope, null), 3, (Object) null);
                                } else {
                                    ((PointerInputChange) objectRef2.element).consume();
                                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass5(this.$pressScope, null), 3, (Object) null);
                                }
                                break;
                            } catch (PointerEventTimeoutCancellationException unused) {
                                objectRef = objectRef2;
                                pointerInputChange = pointerInputChange2;
                                awaitPointerEventScope4 = awaitPointerEventScope3;
                                function1 = this.$onLongPress;
                                if (function1 != null) {
                                    function1.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                                }
                                this.L$0 = awaitPointerEventScope4;
                                this.L$1 = objectRef;
                                this.L$2 = null;
                                this.L$3 = null;
                                this.J$0 = longPressTimeoutMillis;
                                this.label = 3;
                                if (TapGestureDetectorKt.consumeUntilUp(awaitPointerEventScope4, (Continuation) this) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass6(this.$pressScope, null), 3, (Object) null);
                                objectRef2 = objectRef;
                                awaitPointerEventScope3 = awaitPointerEventScope4;
                            }
                            if (objectRef2.element != null) {
                                if (this.$onDoubleTap == null) {
                                    function2 = this.$onTap;
                                    if (function2 != null) {
                                        function2.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef2.element).getPosition()));
                                    }
                                } else {
                                    this.L$0 = awaitPointerEventScope3;
                                    this.L$1 = objectRef2;
                                    this.L$2 = null;
                                    this.L$3 = null;
                                    this.J$0 = longPressTimeoutMillis;
                                    this.label = 4;
                                    objAwaitSecondDown = TapGestureDetectorKt.awaitSecondDown(awaitPointerEventScope3, (PointerInputChange) objectRef2.element, (Continuation) this);
                                    if (objAwaitSecondDown == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    objectRef3 = objectRef2;
                                    awaitPointerEventScope5 = awaitPointerEventScope3;
                                    pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                                    if (pointerInputChange3 == null) {
                                        function3 = this.$onTap;
                                        if (function3 != null) {
                                            function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                                        }
                                    } else {
                                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                                        if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                                        }
                                        try {
                                            objectRef5 = objectRef3;
                                            this.L$0 = awaitPointerEventScope5;
                                            this.L$1 = objectRef3;
                                            this.L$2 = pointerInputChange3;
                                            this.label = 5;
                                            if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                                return coroutine_suspended;
                                            }
                                        } catch (PointerEventTimeoutCancellationException unused2) {
                                            objectRef4 = objectRef3;
                                            awaitPointerEventScope6 = awaitPointerEventScope5;
                                            function4 = this.$onTap;
                                            if (function4 != null) {
                                                function4.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef4.element).getPosition()));
                                            }
                                            function5 = this.$onLongPress;
                                            if (function5 != null) {
                                                function5.invoke(Offset.m4335boximpl(pointerInputChange3.getPosition()));
                                            }
                                            this.L$0 = null;
                                            this.L$1 = null;
                                            this.L$2 = null;
                                            this.label = 6;
                                            if (TapGestureDetectorKt.consumeUntilUp(awaitPointerEventScope6, (Continuation) this) == coroutine_suspended) {
                                                return coroutine_suspended;
                                            }
                                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass10(this.$pressScope, null), 3, (Object) null);
                                        }
                                    }
                                }
                            }
                            return Unit.INSTANCE;
                        } catch (PointerEventTimeoutCancellationException unused3) {
                            awaitPointerEventScope4 = awaitPointerEventScope2;
                            function1 = this.$onLongPress;
                            if (function1 != null) {
                                function1.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                            }
                            this.L$0 = awaitPointerEventScope4;
                            this.L$1 = objectRef;
                            this.L$2 = null;
                            this.L$3 = null;
                            this.J$0 = longPressTimeoutMillis;
                            this.label = 3;
                            if (TapGestureDetectorKt.consumeUntilUp(awaitPointerEventScope4, (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass6(this.$pressScope, null), 3, (Object) null);
                            objectRef2 = objectRef;
                            awaitPointerEventScope3 = awaitPointerEventScope4;
                            if (objectRef2.element != null) {
                                if (this.$onDoubleTap == null) {
                                    function2 = this.$onTap;
                                    if (function2 != null) {
                                        function2.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef2.element).getPosition()));
                                    }
                                } else {
                                    this.L$0 = awaitPointerEventScope3;
                                    this.L$1 = objectRef2;
                                    this.L$2 = null;
                                    this.L$3 = null;
                                    this.J$0 = longPressTimeoutMillis;
                                    this.label = 4;
                                    objAwaitSecondDown = TapGestureDetectorKt.awaitSecondDown(awaitPointerEventScope3, (PointerInputChange) objectRef2.element, (Continuation) this);
                                    if (objAwaitSecondDown == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    objectRef3 = objectRef2;
                                    awaitPointerEventScope5 = awaitPointerEventScope3;
                                    pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                                    if (pointerInputChange3 == null) {
                                        function3 = this.$onTap;
                                        if (function3 != null) {
                                            function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                                        }
                                    } else {
                                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                                        if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                                        }
                                        objectRef5 = objectRef3;
                                        this.L$0 = awaitPointerEventScope5;
                                        this.L$1 = objectRef3;
                                        this.L$2 = pointerInputChange3;
                                        this.label = 5;
                                        if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                            return coroutine_suspended;
                                        }
                                    }
                                }
                            }
                            return Unit.INSTANCE;
                        }
                    case 1:
                        awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        objAwaitFirstDown$default = obj;
                        awaitPointerEventScope2 = awaitPointerEventScope;
                        pointerInputChange = (PointerInputChange) objAwaitFirstDown$default;
                        pointerInputChange.consume();
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C17931(this.$pressScope, null), 3, (Object) null);
                        if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass2(this.$onPress, this.$pressScope, pointerInputChange, null), 3, (Object) null);
                        }
                        if (this.$onLongPress != null) {
                            longPressTimeoutMillis = awaitPointerEventScope2.getViewConfiguration().getLongPressTimeoutMillis();
                        } else {
                            longPressTimeoutMillis = 4611686018427387903L;
                        }
                        objectRef = new Ref.ObjectRef();
                        this.L$0 = awaitPointerEventScope2;
                        this.L$1 = pointerInputChange;
                        this.L$2 = objectRef;
                        this.L$3 = objectRef;
                        this.J$0 = longPressTimeoutMillis;
                        this.label = 2;
                        objWithTimeout = awaitPointerEventScope2.withTimeout(longPressTimeoutMillis, new AnonymousClass3(null), (Continuation) this);
                        if (objWithTimeout == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        awaitPointerEventScope3 = awaitPointerEventScope2;
                        pointerInputChange2 = pointerInputChange;
                        objectRef2 = objectRef;
                        objectRef.element = objWithTimeout;
                        if (objectRef2.element == null) {
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass4(this.$pressScope, null), 3, (Object) null);
                        } else {
                            ((PointerInputChange) objectRef2.element).consume();
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass5(this.$pressScope, null), 3, (Object) null);
                        }
                        if (objectRef2.element != null) {
                            if (this.$onDoubleTap == null) {
                                function2 = this.$onTap;
                                if (function2 != null) {
                                    function2.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef2.element).getPosition()));
                                }
                            } else {
                                this.L$0 = awaitPointerEventScope3;
                                this.L$1 = objectRef2;
                                this.L$2 = null;
                                this.L$3 = null;
                                this.J$0 = longPressTimeoutMillis;
                                this.label = 4;
                                objAwaitSecondDown = TapGestureDetectorKt.awaitSecondDown(awaitPointerEventScope3, (PointerInputChange) objectRef2.element, (Continuation) this);
                                if (objAwaitSecondDown == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                objectRef3 = objectRef2;
                                awaitPointerEventScope5 = awaitPointerEventScope3;
                                pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                                if (pointerInputChange3 == null) {
                                    function3 = this.$onTap;
                                    if (function3 != null) {
                                        function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                                    }
                                } else {
                                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                                    if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                                    }
                                    objectRef5 = objectRef3;
                                    this.L$0 = awaitPointerEventScope5;
                                    this.L$1 = objectRef3;
                                    this.L$2 = pointerInputChange3;
                                    this.label = 5;
                                    if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                }
                            }
                        }
                        return Unit.INSTANCE;
                    case 2:
                        longPressTimeoutMillis = this.J$0;
                        objectRef = (Ref.ObjectRef) this.L$3;
                        Ref.ObjectRef objectRef6 = (Ref.ObjectRef) this.L$2;
                        pointerInputChange = (PointerInputChange) this.L$1;
                        awaitPointerEventScope2 = (AwaitPointerEventScope) this.L$0;
                        try {
                            ResultKt.throwOnFailure(obj);
                            awaitPointerEventScope3 = awaitPointerEventScope2;
                            pointerInputChange2 = pointerInputChange;
                            objectRef2 = objectRef6;
                            objWithTimeout = obj;
                            objectRef.element = objWithTimeout;
                            if (objectRef2.element == null) {
                                BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass4(this.$pressScope, null), 3, (Object) null);
                            } else {
                                ((PointerInputChange) objectRef2.element).consume();
                                BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass5(this.$pressScope, null), 3, (Object) null);
                            }
                            break;
                        } catch (PointerEventTimeoutCancellationException unused4) {
                            objectRef = objectRef6;
                            awaitPointerEventScope4 = awaitPointerEventScope2;
                            function1 = this.$onLongPress;
                            if (function1 != null) {
                                function1.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                            }
                            this.L$0 = awaitPointerEventScope4;
                            this.L$1 = objectRef;
                            this.L$2 = null;
                            this.L$3 = null;
                            this.J$0 = longPressTimeoutMillis;
                            this.label = 3;
                            if (TapGestureDetectorKt.consumeUntilUp(awaitPointerEventScope4, (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass6(this.$pressScope, null), 3, (Object) null);
                            objectRef2 = objectRef;
                            awaitPointerEventScope3 = awaitPointerEventScope4;
                            if (objectRef2.element != null) {
                                if (this.$onDoubleTap == null) {
                                    function2 = this.$onTap;
                                    if (function2 != null) {
                                        function2.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef2.element).getPosition()));
                                    }
                                } else {
                                    this.L$0 = awaitPointerEventScope3;
                                    this.L$1 = objectRef2;
                                    this.L$2 = null;
                                    this.L$3 = null;
                                    this.J$0 = longPressTimeoutMillis;
                                    this.label = 4;
                                    objAwaitSecondDown = TapGestureDetectorKt.awaitSecondDown(awaitPointerEventScope3, (PointerInputChange) objectRef2.element, (Continuation) this);
                                    if (objAwaitSecondDown == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    objectRef3 = objectRef2;
                                    awaitPointerEventScope5 = awaitPointerEventScope3;
                                    pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                                    if (pointerInputChange3 == null) {
                                        function3 = this.$onTap;
                                        if (function3 != null) {
                                            function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                                        }
                                    } else {
                                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                                        if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                                        }
                                        objectRef5 = objectRef3;
                                        this.L$0 = awaitPointerEventScope5;
                                        this.L$1 = objectRef3;
                                        this.L$2 = pointerInputChange3;
                                        this.label = 5;
                                        if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                            return coroutine_suspended;
                                        }
                                    }
                                }
                            }
                            return Unit.INSTANCE;
                        }
                        if (objectRef2.element != null) {
                            if (this.$onDoubleTap == null) {
                                function2 = this.$onTap;
                                if (function2 != null) {
                                    function2.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef2.element).getPosition()));
                                }
                            } else {
                                this.L$0 = awaitPointerEventScope3;
                                this.L$1 = objectRef2;
                                this.L$2 = null;
                                this.L$3 = null;
                                this.J$0 = longPressTimeoutMillis;
                                this.label = 4;
                                objAwaitSecondDown = TapGestureDetectorKt.awaitSecondDown(awaitPointerEventScope3, (PointerInputChange) objectRef2.element, (Continuation) this);
                                if (objAwaitSecondDown == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                objectRef3 = objectRef2;
                                awaitPointerEventScope5 = awaitPointerEventScope3;
                                pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                                if (pointerInputChange3 == null) {
                                    function3 = this.$onTap;
                                    if (function3 != null) {
                                        function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                                    }
                                } else {
                                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                                    if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                                    }
                                    objectRef5 = objectRef3;
                                    this.L$0 = awaitPointerEventScope5;
                                    this.L$1 = objectRef3;
                                    this.L$2 = pointerInputChange3;
                                    this.label = 5;
                                    if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                }
                            }
                        }
                        return Unit.INSTANCE;
                    case 3:
                        longPressTimeoutMillis = this.J$0;
                        objectRef = (Ref.ObjectRef) this.L$1;
                        awaitPointerEventScope4 = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass6(this.$pressScope, null), 3, (Object) null);
                        objectRef2 = objectRef;
                        awaitPointerEventScope3 = awaitPointerEventScope4;
                        if (objectRef2.element != null) {
                            if (this.$onDoubleTap == null) {
                                function2 = this.$onTap;
                                if (function2 != null) {
                                    function2.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef2.element).getPosition()));
                                }
                            } else {
                                this.L$0 = awaitPointerEventScope3;
                                this.L$1 = objectRef2;
                                this.L$2 = null;
                                this.L$3 = null;
                                this.J$0 = longPressTimeoutMillis;
                                this.label = 4;
                                objAwaitSecondDown = TapGestureDetectorKt.awaitSecondDown(awaitPointerEventScope3, (PointerInputChange) objectRef2.element, (Continuation) this);
                                if (objAwaitSecondDown == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                objectRef3 = objectRef2;
                                awaitPointerEventScope5 = awaitPointerEventScope3;
                                pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                                if (pointerInputChange3 == null) {
                                    function3 = this.$onTap;
                                    if (function3 != null) {
                                        function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                                    }
                                } else {
                                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                                    if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                                    }
                                    objectRef5 = objectRef3;
                                    this.L$0 = awaitPointerEventScope5;
                                    this.L$1 = objectRef3;
                                    this.L$2 = pointerInputChange3;
                                    this.label = 5;
                                    if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                }
                            }
                        }
                        return Unit.INSTANCE;
                    case 4:
                        longPressTimeoutMillis = this.J$0;
                        Ref.ObjectRef objectRef7 = (Ref.ObjectRef) this.L$1;
                        AwaitPointerEventScope awaitPointerEventScope7 = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        objectRef3 = objectRef7;
                        awaitPointerEventScope5 = awaitPointerEventScope7;
                        objAwaitSecondDown = obj;
                        pointerInputChange3 = (PointerInputChange) objAwaitSecondDown;
                        if (pointerInputChange3 == null) {
                            function3 = this.$onTap;
                            if (function3 != null) {
                                function3.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef3.element).getPosition()));
                            }
                        } else {
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass7(this.$pressScope, null), 3, (Object) null);
                            if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                                BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass8(this.$onPress, this.$pressScope, pointerInputChange3, null), 3, (Object) null);
                            }
                            objectRef5 = objectRef3;
                            this.L$0 = awaitPointerEventScope5;
                            this.L$1 = objectRef3;
                            this.L$2 = pointerInputChange3;
                            this.label = 5;
                            if (awaitPointerEventScope5.withTimeout(longPressTimeoutMillis, new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, objectRef5, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                        return Unit.INSTANCE;
                    case 5:
                        pointerInputChange3 = (PointerInputChange) this.L$2;
                        objectRef4 = (Ref.ObjectRef) this.L$1;
                        awaitPointerEventScope6 = (AwaitPointerEventScope) this.L$0;
                        try {
                            ResultKt.throwOnFailure(obj);
                            break;
                        } catch (PointerEventTimeoutCancellationException unused5) {
                            function4 = this.$onTap;
                            if (function4 != null) {
                                function4.invoke(Offset.m4335boximpl(((PointerInputChange) objectRef4.element).getPosition()));
                            }
                            function5 = this.$onLongPress;
                            if (function5 != null) {
                                function5.invoke(Offset.m4335boximpl(pointerInputChange3.getPosition()));
                            }
                            this.L$0 = null;
                            this.L$1 = null;
                            this.L$2 = null;
                            this.label = 6;
                            if (TapGestureDetectorKt.consumeUntilUp(awaitPointerEventScope6, (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass10(this.$pressScope, null), 3, (Object) null);
                        }
                        return Unit.INSTANCE;
                    case 6:
                        ResultKt.throwOnFailure(obj);
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass10(this.$pressScope, null), 3, (Object) null);
                        return Unit.INSTANCE;
                    default:
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$1", f = "TapGestureDetector.kt", i = {}, l = {103}, m = "invokeSuspend", n = {}, s = {})
            static final class C17931 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                C17931(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super C17931> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C17931(this.$pressScope, continuation);
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
                        if (this.$pressScope.reset((Continuation) this) == coroutine_suspended) {
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

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$2", f = "TapGestureDetector.kt", i = {}, l = {106}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PointerInputChange $down;
                final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass2(Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, PressGestureScopeImpl pressGestureScopeImpl, PointerInputChange pointerInputChange, Continuation<? super AnonymousClass2> continuation) {
                    super(2, continuation);
                    this.$onPress = function3;
                    this.$pressScope = pressGestureScopeImpl;
                    this.$down = pointerInputChange;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass2(this.$onPress, this.$pressScope, this.$down, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> function3 = this.$onPress;
                        PressGestureScopeImpl pressGestureScopeImpl = this.$pressScope;
                        Offset offsetM4335boximpl = Offset.m4335boximpl(this.$down.getPosition());
                        this.label = 1;
                        if (function3.invoke(pressGestureScopeImpl, offsetM4335boximpl, this) == coroutine_suspended) {
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

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$3", f = "TapGestureDetector.kt", i = {}, l = {115}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass3 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super PointerInputChange>, Object> {
                private Object L$0;
                int label;

                AnonymousClass3(Continuation<? super AnonymousClass3> continuation) {
                    super(2, continuation);
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    Continuation<Unit> anonymousClass3 = new AnonymousClass3(continuation);
                    anonymousClass3.L$0 = obj;
                    return anonymousClass3;
                }

                public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super PointerInputChange> continuation) {
                    return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        obj = TapGestureDetectorKt.waitForUpOrCancellation$default((AwaitPointerEventScope) this.L$0, null, (Continuation) this, 1, null);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return obj;
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$4", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass4 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass4(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass4> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass4(this.$pressScope, continuation);
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
                    this.$pressScope.cancel();
                    return Unit.INSTANCE;
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$5", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass5 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass5(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass5> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass5(this.$pressScope, continuation);
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
                    this.$pressScope.release();
                    return Unit.INSTANCE;
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$6", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass6 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass6(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass6> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass6(this.$pressScope, continuation);
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
                    this.$pressScope.release();
                    return Unit.INSTANCE;
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$7", f = "TapGestureDetector.kt", i = {}, l = {148}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass7 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass7(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass7> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass7(this.$pressScope, continuation);
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
                        if (this.$pressScope.reset((Continuation) this) == coroutine_suspended) {
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

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$8", f = "TapGestureDetector.kt", i = {}, l = {151}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass8 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
                final PressGestureScopeImpl $pressScope;
                final PointerInputChange $secondDown;
                int label;

                AnonymousClass8(Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, PressGestureScopeImpl pressGestureScopeImpl, PointerInputChange pointerInputChange, Continuation<? super AnonymousClass8> continuation) {
                    super(2, continuation);
                    this.$onPress = function3;
                    this.$pressScope = pressGestureScopeImpl;
                    this.$secondDown = pointerInputChange;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass8(this.$onPress, this.$pressScope, this.$secondDown, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> function3 = this.$onPress;
                        PressGestureScopeImpl pressGestureScopeImpl = this.$pressScope;
                        Offset offsetM4335boximpl = Offset.m4335boximpl(this.$secondDown.getPosition());
                        this.label = 1;
                        if (function3.invoke(pressGestureScopeImpl, offsetM4335boximpl, this) == coroutine_suspended) {
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

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$9", f = "TapGestureDetector.kt", i = {}, l = {157}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass9 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
                final CoroutineScope $$this$coroutineScope;
                final Function1<Offset, Unit> $onDoubleTap;
                final Function1<Offset, Unit> $onTap;
                final PressGestureScopeImpl $pressScope;
                final Ref.ObjectRef<PointerInputChange> $upOrCancel;
                private Object L$0;
                int label;

                AnonymousClass9(CoroutineScope coroutineScope, Function1<? super Offset, Unit> function1, Function1<? super Offset, Unit> function2, Ref.ObjectRef<PointerInputChange> objectRef, PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass9> continuation) {
                    super(2, continuation);
                    this.$$this$coroutineScope = coroutineScope;
                    this.$onDoubleTap = function1;
                    this.$onTap = function2;
                    this.$upOrCancel = objectRef;
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    Continuation<Unit> anonymousClass9 = new AnonymousClass9(this.$$this$coroutineScope, this.$onDoubleTap, this.$onTap, this.$upOrCancel, this.$pressScope, continuation);
                    anonymousClass9.L$0 = obj;
                    return anonymousClass9;
                }

                public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                    return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        this.label = 1;
                        obj = TapGestureDetectorKt.waitForUpOrCancellation$default((AwaitPointerEventScope) this.L$0, null, (Continuation) this, 1, null);
                        if (obj == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    PointerInputChange pointerInputChange = (PointerInputChange) obj;
                    if (pointerInputChange != null) {
                        pointerInputChange.consume();
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C17941(this.$pressScope, null), 3, (Object) null);
                        this.$onDoubleTap.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                        return Unit.INSTANCE;
                    }
                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass2(this.$pressScope, null), 3, (Object) null);
                    Function1<Offset, Unit> function1 = this.$onTap;
                    if (function1 == null) {
                        return null;
                    }
                    function1.invoke(Offset.m4335boximpl(((PointerInputChange) this.$upOrCancel.element).getPosition()));
                    return Unit.INSTANCE;
                }

                @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$9$1", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
                static final class C17941 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final PressGestureScopeImpl $pressScope;
                    int label;

                    C17941(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super C17941> continuation) {
                        super(2, continuation);
                        this.$pressScope = pressGestureScopeImpl;
                    }

                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C17941(this.$pressScope, continuation);
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
                        this.$pressScope.release();
                        return Unit.INSTANCE;
                    }
                }

                @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$9$2", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
                static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final PressGestureScopeImpl $pressScope;
                    int label;

                    AnonymousClass2(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass2> continuation) {
                        super(2, continuation);
                        this.$pressScope = pressGestureScopeImpl;
                    }

                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new AnonymousClass2(this.$pressScope, continuation);
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
                        this.$pressScope.cancel();
                        return Unit.INSTANCE;
                    }
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapGestures$2$1$10", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass10 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass10(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass10> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass10(this.$pressScope, continuation);
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
                    this.$pressScope.release();
                    return Unit.INSTANCE;
                }
            }
        }
    }

    public static final Object detectTapGestures(PointerInputScope pointerInputScope, Function1<? super Offset, Unit> function1, Function1<? super Offset, Unit> function2, Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, Function1<? super Offset, Unit> function4, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C04972(pointerInputScope, function3, function2, function1, function4, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    public static final java.lang.Object consumeUntilUp(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r8, kotlin.coroutines.Continuation<? super kotlin.Unit> r9) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.TapGestureDetectorKt.consumeUntilUp(androidx.compose.ui.input.pointer.AwaitPointerEventScope, kotlin.coroutines.Continuation):java.lang.Object");
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$awaitSecondDown$2", f = "TapGestureDetector.kt", i = {0, 0}, l = {212}, m = "invokeSuspend", n = {"$this$withTimeoutOrNull", "minUptime"}, s = {"L$0", "J$0"})
    static final class C04942 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super PointerInputChange>, Object> {
        final PointerInputChange $firstUp;
        long J$0;
        private Object L$0;
        int label;

        C04942(PointerInputChange pointerInputChange, Continuation<? super C04942> continuation) {
            super(2, continuation);
            this.$firstUp = pointerInputChange;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04942 = new C04942(this.$firstUp, continuation);
            c04942.L$0 = obj;
            return c04942;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super PointerInputChange> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final java.lang.Object invokeSuspend(java.lang.Object r12) {
            throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.TapGestureDetectorKt.C04942.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public static final Object awaitSecondDown(AwaitPointerEventScope awaitPointerEventScope, PointerInputChange pointerInputChange, Continuation<? super PointerInputChange> continuation) {
        return awaitPointerEventScope.withTimeoutOrNull(awaitPointerEventScope.getViewConfiguration().getDoubleTapTimeoutMillis(), new C04942(pointerInputChange, null), continuation);
    }

    public static Object detectTapAndPress$default(PointerInputScope pointerInputScope, Function3 function3, Function1 function1, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            function3 = NoPressGesture;
        }
        if ((i & 2) != 0) {
            function1 = null;
        }
        return detectTapAndPress(pointerInputScope, function3, function1, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapAndPress$2", f = "TapGestureDetector.kt", i = {}, l = {232}, m = "invokeSuspend", n = {}, s = {})
    static final class C04962 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
        final Function1<Offset, Unit> $onTap;
        final PressGestureScopeImpl $pressScope;
        final PointerInputScope $this_detectTapAndPress;
        private Object L$0;
        int label;

        C04962(PointerInputScope pointerInputScope, Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, Function1<? super Offset, Unit> function1, PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super C04962> continuation) {
            super(2, continuation);
            this.$this_detectTapAndPress = pointerInputScope;
            this.$onPress = function3;
            this.$onTap = function1;
            this.$pressScope = pressGestureScopeImpl;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04962 = new C04962(this.$this_detectTapAndPress, this.$onPress, this.$onTap, this.$pressScope, continuation);
            c04962.L$0 = obj;
            return c04962;
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapAndPress$2$1", f = "TapGestureDetector.kt", i = {0}, l = {237, 245}, m = "invokeSuspend", n = {"$this$awaitEachGesture"}, s = {"L$0"})
        static final class AnonymousClass1 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
            final CoroutineScope $$this$coroutineScope;
            final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
            final Function1<Offset, Unit> $onTap;
            final PressGestureScopeImpl $pressScope;
            private Object L$0;
            int label;

            AnonymousClass1(CoroutineScope coroutineScope, Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, Function1<? super Offset, Unit> function1, PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$$this$coroutineScope = coroutineScope;
                this.$onPress = function3;
                this.$onTap = function1;
                this.$pressScope = pressGestureScopeImpl;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$$this$coroutineScope, this.$onPress, this.$onTap, this.$pressScope, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapAndPress$2$1$1", f = "TapGestureDetector.kt", i = {}, l = {234}, m = "invokeSuspend", n = {}, s = {})
            static final class C17921 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                C17921(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super C17921> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new C17921(this.$pressScope, continuation);
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
                        if (this.$pressScope.reset((Continuation) this) == coroutine_suspended) {
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
                AwaitPointerEventScope awaitPointerEventScope;
                Object objAwaitFirstDown$default;
                Object objWaitForUpOrCancellation$default;
                PointerInputChange pointerInputChange;
                Function1<Offset, Unit> function1;
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i != 0) {
                    if (i == 1) {
                        awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        objAwaitFirstDown$default = obj;
                    } else {
                        if (i != 2) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                        objWaitForUpOrCancellation$default = obj;
                    }
                    pointerInputChange = (PointerInputChange) objWaitForUpOrCancellation$default;
                    if (pointerInputChange == null) {
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass3(this.$pressScope, null), 3, (Object) null);
                    } else {
                        pointerInputChange.consume();
                        BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass4(this.$pressScope, null), 3, (Object) null);
                        function1 = this.$onTap;
                        if (function1 != null) {
                            function1.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                        }
                    }
                    return Unit.INSTANCE;
                }
                ResultKt.throwOnFailure(obj);
                awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new C17921(this.$pressScope, null), 3, (Object) null);
                this.L$0 = awaitPointerEventScope;
                this.label = 1;
                objAwaitFirstDown$default = TapGestureDetectorKt.awaitFirstDown$default(awaitPointerEventScope, false, null, (Continuation) this, 3, null);
                if (objAwaitFirstDown$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                PointerInputChange pointerInputChange2 = (PointerInputChange) objAwaitFirstDown$default;
                pointerInputChange2.consume();
                if (this.$onPress != TapGestureDetectorKt.NoPressGesture) {
                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass2(this.$onPress, this.$pressScope, pointerInputChange2, null), 3, (Object) null);
                }
                this.L$0 = null;
                this.label = 2;
                objWaitForUpOrCancellation$default = TapGestureDetectorKt.waitForUpOrCancellation$default(awaitPointerEventScope, null, (Continuation) this, 1, null);
                if (objWaitForUpOrCancellation$default == coroutine_suspended) {
                    return coroutine_suspended;
                }
                pointerInputChange = (PointerInputChange) objWaitForUpOrCancellation$default;
                if (pointerInputChange == null) {
                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass3(this.$pressScope, null), 3, (Object) null);
                } else {
                    pointerInputChange.consume();
                    BuildersKt.launch$default(this.$$this$coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass4(this.$pressScope, null), 3, (Object) null);
                    function1 = this.$onTap;
                    if (function1 != null) {
                        function1.invoke(Offset.m4335boximpl(pointerInputChange.getPosition()));
                    }
                }
                return Unit.INSTANCE;
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapAndPress$2$1$2", f = "TapGestureDetector.kt", i = {}, l = {241}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PointerInputChange $down;
                final Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> $onPress;
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass2(Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, PressGestureScopeImpl pressGestureScopeImpl, PointerInputChange pointerInputChange, Continuation<? super AnonymousClass2> continuation) {
                    super(2, continuation);
                    this.$onPress = function3;
                    this.$pressScope = pressGestureScopeImpl;
                    this.$down = pointerInputChange;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass2(this.$onPress, this.$pressScope, this.$down, continuation);
                }

                public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                    return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                }

                public final Object invokeSuspend(Object obj) {
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = this.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        Function3<PressGestureScope, Offset, Continuation<? super Unit>, Object> function3 = this.$onPress;
                        PressGestureScopeImpl pressGestureScopeImpl = this.$pressScope;
                        Offset offsetM4335boximpl = Offset.m4335boximpl(this.$down.getPosition());
                        this.label = 1;
                        if (function3.invoke(pressGestureScopeImpl, offsetM4335boximpl, this) == coroutine_suspended) {
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

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapAndPress$2$1$3", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass3 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass3(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass3> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass3(this.$pressScope, continuation);
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
                    this.$pressScope.cancel();
                    return Unit.INSTANCE;
                }
            }

            @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
            @DebugMetadata(c = "androidx.compose.foundation.gestures.TapGestureDetectorKt$detectTapAndPress$2$1$4", f = "TapGestureDetector.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
            static final class AnonymousClass4 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                final PressGestureScopeImpl $pressScope;
                int label;

                AnonymousClass4(PressGestureScopeImpl pressGestureScopeImpl, Continuation<? super AnonymousClass4> continuation) {
                    super(2, continuation);
                    this.$pressScope = pressGestureScopeImpl;
                }

                public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                    return new AnonymousClass4(this.$pressScope, continuation);
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
                    this.$pressScope.release();
                    return Unit.INSTANCE;
                }
            }
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                this.label = 1;
                if (ForEachGestureKt.awaitEachGesture(this.$this_detectTapAndPress, new AnonymousClass1(coroutineScope, this.$onPress, this.$onTap, this.$pressScope, null), (Continuation) this) == coroutine_suspended) {
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

    public static final Object detectTapAndPress(PointerInputScope pointerInputScope, Function3<? super PressGestureScope, ? super Offset, ? super Continuation<? super Unit>, ? extends Object> function3, Function1<? super Offset, Unit> function1, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C04962(pointerInputScope, function3, function1, new PressGestureScopeImpl(pointerInputScope), null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    public static Object awaitFirstDown$default(AwaitPointerEventScope awaitPointerEventScope, boolean z, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        return awaitFirstDown(awaitPointerEventScope, z, continuation);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility. Use version with PointerEventPass instead.")
    public static final Object awaitFirstDown(AwaitPointerEventScope awaitPointerEventScope, boolean z, Continuation continuation) {
        return awaitFirstDown(awaitPointerEventScope, z, PointerEventPass.Main, continuation);
    }

    public static final java.lang.Object awaitFirstDown(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r9, boolean r10, androidx.compose.p002ui.input.pointer.PointerEventPass r11, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r12) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.TapGestureDetectorKt.awaitFirstDown(androidx.compose.ui.input.pointer.AwaitPointerEventScope, boolean, androidx.compose.ui.input.pointer.PointerEventPass, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static Object awaitFirstDown$default(AwaitPointerEventScope awaitPointerEventScope, boolean z, PointerEventPass pointerEventPass, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        if ((i & 2) != 0) {
            pointerEventPass = PointerEventPass.Main;
        }
        return awaitFirstDown(awaitPointerEventScope, z, pointerEventPass, continuation);
    }

    public static final java.lang.Object waitForUpOrCancellation(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r18, androidx.compose.p002ui.input.pointer.PointerEventPass r19, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerInputChange> r20) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.gestures.TapGestureDetectorKt.waitForUpOrCancellation(androidx.compose.ui.input.pointer.AwaitPointerEventScope, androidx.compose.ui.input.pointer.PointerEventPass, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static Object waitForUpOrCancellation$default(AwaitPointerEventScope awaitPointerEventScope, PointerEventPass pointerEventPass, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            pointerEventPass = PointerEventPass.Main;
        }
        return waitForUpOrCancellation(awaitPointerEventScope, pointerEventPass, continuation);
    }
}
