package androidx.compose.foundation.text.selection;

import androidx.compose.foundation.gestures.DragGestureDetectorKt;
import androidx.compose.foundation.gestures.ForEachGestureKt;
import androidx.compose.foundation.text.TextDragObserver;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerEvent;
import androidx.compose.p002ui.input.pointer.PointerEventKt;
import androidx.compose.p002ui.input.pointer.PointerEvent_androidKt;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import androidx.compose.p002ui.input.pointer.PointerType;
import androidx.compose.p002ui.input.pointer.SuspendingPointerInputFilterKt;
import androidx.compose.p002ui.platform.ViewConfiguration;
import java.util.List;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000Z\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\u001a \u0010\u0006\u001a\u00020\u00032\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\nH\u0002\u001a\u0012\u0010\f\u001a\u00020\u0004*\u00020\rH\u0082@¢\u0006\u0002\u0010\u000e\u001a*\u0010\u000f\u001a\u00020\u0010*\u00020\r2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010\u0016\u001a*\u0010\u0017\u001a\u00020\u0010*\u00020\r2\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010\u0016\u001a\u001c\u0010\u0018\u001a\u00020\u0019*\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u00122\u0006\u0010\u001b\u001a\u00020\u001cH\u0000\u001a\"\u0010\u001d\u001a\u00020\u0010*\u00020\u001e2\u0006\u0010\u001a\u001a\u00020\u00122\u0006\u0010\u001b\u001a\u00020\u001cH\u0080@¢\u0006\u0002\u0010\u001f\u001a\"\u0010 \u001a\u00020\u0010*\u00020\r2\u0006\u0010\u0011\u001a\u00020\u001c2\u0006\u0010\u0015\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010!\u001a\"\u0010\"\u001a\u00020\u0010*\u00020\r2\u0006\u0010\u0011\u001a\u00020\u001c2\u0006\u0010#\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010!\u001a\"\u0010$\u001a\u00020\u0010*\u00020\r2\u0006\u0010\u0011\u001a\u00020\u001c2\u0006\u0010#\u001a\u00020\u0004H\u0082@¢\u0006\u0002\u0010!\u001a \u0010%\u001a\u00020\u0019*\u00020\u00192\u0012\u0010&\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00100'H\u0000\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0018\u0010\u0002\u001a\u00020\u0003*\u00020\u00048@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0002\u0010\u0005¨\u0006("}, d2 = {"STATIC_KEY", "", "isPrecisePointer", "", "Landroidx/compose/ui/input/pointer/PointerEvent;", "(Landroidx/compose/ui/input/pointer/PointerEvent;)Z", "distanceIsTolerable", "viewConfiguration", "Landroidx/compose/ui/platform/ViewConfiguration;", "change1", "Landroidx/compose/ui/input/pointer/PointerInputChange;", "change2", "awaitDown", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "mouseSelection", "", "observer", "Landroidx/compose/foundation/text/selection/MouseSelectionObserver;", "clicksCounter", "Landroidx/compose/foundation/text/selection/ClicksCounter;", "down", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Landroidx/compose/foundation/text/selection/MouseSelectionObserver;Landroidx/compose/foundation/text/selection/ClicksCounter;Landroidx/compose/ui/input/pointer/PointerEvent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "mouseSelectionBtf2", "selectionGestureInput", "Landroidx/compose/ui/Modifier;", "mouseSelectionObserver", "textDragObserver", "Landroidx/compose/foundation/text/TextDragObserver;", "selectionGesturePointerInputBtf2", "Landroidx/compose/ui/input/pointer/PointerInputScope;", "(Landroidx/compose/ui/input/pointer/PointerInputScope;Landroidx/compose/foundation/text/selection/MouseSelectionObserver;Landroidx/compose/foundation/text/TextDragObserver;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "touchSelection", "(Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;Landroidx/compose/foundation/text/TextDragObserver;Landroidx/compose/ui/input/pointer/PointerEvent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "touchSelectionFirstPress", "downEvent", "touchSelectionSubsequentPress", "updateSelectionTouchMode", "updateTouchMode", "Lkotlin/Function1;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SelectionGesturesKt {
    private static final int STATIC_KEY = 8675309;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt", f = "SelectionGestures.kt", i = {0}, l = {425}, m = "awaitDown", n = {"$this$awaitDown"}, s = {"L$0"})
    static final class C09831 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C09831(Continuation<? super C09831> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SelectionGesturesKt.awaitDown(null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt", f = "SelectionGestures.kt", i = {0, 0, 1, 1}, l = {158, 181}, m = "mouseSelection", n = {"$this$mouseSelection", "observer", "$this$mouseSelection", "observer"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C09841 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C09841(Continuation<? super C09841> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SelectionGesturesKt.mouseSelection(null, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt", f = "SelectionGestures.kt", i = {0, 0, 1, 1}, l = {351, 377}, m = "mouseSelectionBtf2", n = {"$this$mouseSelectionBtf2", "observer", "$this$mouseSelectionBtf2", "observer"}, s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C09851 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C09851(Continuation<? super C09851> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SelectionGesturesKt.mouseSelectionBtf2(null, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt", f = "SelectionGestures.kt", i = {0, 0, 0, 1, 1}, l = {124, Fields.SpotShadowColor}, m = "touchSelection", n = {"$this$touchSelection", "observer", "firstDown", "$this$touchSelection", "observer"}, s = {"L$0", "L$1", "L$2", "L$0", "L$1"})
    static final class C09881 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09881(Continuation<? super C09881> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SelectionGesturesKt.touchSelection(null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt", f = "SelectionGestures.kt", i = {0, 0, 0, 1, 1}, l = {238, 241}, m = "touchSelectionFirstPress", n = {"$this$touchSelectionFirstPress", "observer", "firstDown", "$this$touchSelectionFirstPress", "observer"}, s = {"L$0", "L$1", "L$2", "L$0", "L$1"})
    static final class C09901 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09901(Continuation<? super C09901> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SelectionGesturesKt.touchSelectionFirstPress(null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt", f = "SelectionGestures.kt", i = {0, 0, 0, 0, 0, 1, 1}, l = {276, 315}, m = "touchSelectionSubsequentPress", n = {"$this$touchSelectionSubsequentPress", "observer", "firstDown", "overSlop", "pointerId", "$this$touchSelectionSubsequentPress", "observer"}, s = {"L$0", "L$1", "L$2", "L$3", "J$0", "L$0", "L$1"})
    static final class C09921 extends ContinuationImpl {
        long J$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C09921(Continuation<? super C09921> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SelectionGesturesKt.touchSelectionSubsequentPress(null, null, null, (Continuation) this);
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt$updateSelectionTouchMode$1", f = "SelectionGestures.kt", i = {}, l = {91}, m = "invokeSuspend", n = {}, s = {})
    static final class C09961 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
        final Function1<Boolean, Unit> $updateTouchMode;
        private Object L$0;
        int label;

        C09961(Function1<? super Boolean, Unit> function1, Continuation<? super C09961> continuation) {
            super(2, continuation);
            this.$updateTouchMode = function1;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09961 = new C09961(this.$updateTouchMode, continuation);
            c09961.L$0 = obj;
            return c09961;
        }

        public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
            return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt$updateSelectionTouchMode$1$1", f = "SelectionGestures.kt", i = {0}, l = {93}, m = "invokeSuspend", n = {"$this$awaitPointerEventScope"}, s = {"L$0"})
        static final class AnonymousClass1 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
            final Function1<Boolean, Unit> $updateTouchMode;
            private Object L$0;
            int label;

            AnonymousClass1(Function1<? super Boolean, Unit> function1, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$updateTouchMode = function1;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$updateTouchMode, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final java.lang.Object invokeSuspend(java.lang.Object r5) {
                throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.text.selection.SelectionGesturesKt.C09961.AnonymousClass1.invokeSuspend(java.lang.Object):java.lang.Object");
            }
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (((PointerInputScope) this.L$0).awaitPointerEventScope(new AnonymousClass1(this.$updateTouchMode, null), (Continuation) this) == coroutine_suspended) {
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

    public static final Modifier updateSelectionTouchMode(Modifier modifier, Function1<? super Boolean, Unit> function1) {
        return SuspendingPointerInputFilterKt.pointerInput(modifier, Integer.valueOf(STATIC_KEY), new C09961(function1, null));
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt$selectionGestureInput$1", f = "SelectionGestures.kt", i = {}, l = {104}, m = "invokeSuspend", n = {}, s = {})
    static final class C09861 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
        final MouseSelectionObserver $mouseSelectionObserver;
        final TextDragObserver $textDragObserver;
        private Object L$0;
        int label;

        C09861(MouseSelectionObserver mouseSelectionObserver, TextDragObserver textDragObserver, Continuation<? super C09861> continuation) {
            super(2, continuation);
            this.$mouseSelectionObserver = mouseSelectionObserver;
            this.$textDragObserver = textDragObserver;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09861 = new C09861(this.$mouseSelectionObserver, this.$textDragObserver, continuation);
            c09861.L$0 = obj;
            return c09861;
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
                ClicksCounter clicksCounter = new ClicksCounter(pointerInputScope.getViewConfiguration());
                this.label = 1;
                if (ForEachGestureKt.awaitEachGesture(pointerInputScope, new AnonymousClass1(this.$mouseSelectionObserver, clicksCounter, this.$textDragObserver, null), (Continuation) this) == coroutine_suspended) {
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
        @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt$selectionGestureInput$1$1", f = "SelectionGestures.kt", i = {0}, l = {105, 111, 113}, m = "invokeSuspend", n = {"$this$awaitEachGesture"}, s = {"L$0"})
        static final class AnonymousClass1 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
            final ClicksCounter $clicksCounter;
            final MouseSelectionObserver $mouseSelectionObserver;
            final TextDragObserver $textDragObserver;
            private Object L$0;
            int label;

            AnonymousClass1(MouseSelectionObserver mouseSelectionObserver, ClicksCounter clicksCounter, TextDragObserver textDragObserver, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.$mouseSelectionObserver = mouseSelectionObserver;
                this.$clicksCounter = clicksCounter;
                this.$textDragObserver = textDragObserver;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.$mouseSelectionObserver, this.$clicksCounter, this.$textDragObserver, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
                return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                AwaitPointerEventScope awaitPointerEventScope;
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    this.L$0 = awaitPointerEventScope;
                    this.label = 1;
                    obj = SelectionGesturesKt.awaitDown(awaitPointerEventScope, (Continuation) this);
                    if (obj == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i == 1) {
                        awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                        ResultKt.throwOnFailure(obj);
                    } else {
                        if (i != 2 && i != 3) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
                PointerEvent pointerEvent = (PointerEvent) obj;
                if (SelectionGesturesKt.isPrecisePointer(pointerEvent) && PointerEvent_androidKt.m5819isPrimaryPressedaHzCxE(pointerEvent.getButtons())) {
                    List<PointerInputChange> changes = pointerEvent.getChanges();
                    int size = changes.size();
                    int i2 = 0;
                    while (true) {
                        if (i2 >= size) {
                            this.L$0 = null;
                            this.label = 2;
                            if (SelectionGesturesKt.mouseSelection(awaitPointerEventScope, this.$mouseSelectionObserver, this.$clicksCounter, pointerEvent, (Continuation) this) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        } else {
                            if (changes.get(i2).isConsumed()) {
                                break;
                            }
                            i2++;
                        }
                    }
                    if (!SelectionGesturesKt.isPrecisePointer(pointerEvent)) {
                        this.L$0 = null;
                        this.label = 3;
                        if (SelectionGesturesKt.touchSelection(awaitPointerEventScope, this.$textDragObserver, pointerEvent, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    }
                } else if (!SelectionGesturesKt.isPrecisePointer(pointerEvent)) {
                    this.L$0 = null;
                    this.label = 3;
                    if (SelectionGesturesKt.touchSelection(awaitPointerEventScope, this.$textDragObserver, pointerEvent, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                return Unit.INSTANCE;
            }
        }
    }

    public static final Modifier selectionGestureInput(Modifier modifier, MouseSelectionObserver mouseSelectionObserver, TextDragObserver textDragObserver) {
        return SuspendingPointerInputFilterKt.pointerInput(modifier, mouseSelectionObserver, textDragObserver, new C09861(mouseSelectionObserver, textDragObserver, null));
    }

    public static final Object touchSelection(AwaitPointerEventScope awaitPointerEventScope, final TextDragObserver textDragObserver, PointerEvent pointerEvent, Continuation<? super Unit> continuation) {
        C09881 c09881;
        PointerInputChange pointerInputChange;
        List<PointerInputChange> changes;
        int size;
        int i;
        PointerInputChange pointerInputChange2;
        if (continuation instanceof C09881) {
            c09881 = (C09881) continuation;
            if ((c09881.label & Integer.MIN_VALUE) != 0) {
                c09881.label -= Integer.MIN_VALUE;
            } else {
                c09881 = new C09881(continuation);
            }
        } else {
            c09881 = new C09881(continuation);
        }
        Object objM725awaitLongPressOrCancellationrnUCldI = c09881.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c09881.label;
        try {
            if (i2 == 0) {
                ResultKt.throwOnFailure(objM725awaitLongPressOrCancellationrnUCldI);
                pointerInputChange = (PointerInputChange) CollectionsKt.first(pointerEvent.getChanges());
                long id = pointerInputChange.getId();
                c09881.L$0 = awaitPointerEventScope;
                c09881.L$1 = textDragObserver;
                c09881.L$2 = pointerInputChange;
                c09881.label = 1;
                objM725awaitLongPressOrCancellationrnUCldI = DragGestureDetectorKt.m725awaitLongPressOrCancellationrnUCldI(awaitPointerEventScope, id, c09881);
                if (objM725awaitLongPressOrCancellationrnUCldI == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i2 == 1) {
                    PointerInputChange pointerInputChange3 = (PointerInputChange) c09881.L$2;
                    textDragObserver = (TextDragObserver) c09881.L$1;
                    AwaitPointerEventScope awaitPointerEventScope2 = (AwaitPointerEventScope) c09881.L$0;
                    ResultKt.throwOnFailure(objM725awaitLongPressOrCancellationrnUCldI);
                    pointerInputChange = pointerInputChange3;
                    awaitPointerEventScope = awaitPointerEventScope2;
                } else {
                    if (i2 != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    textDragObserver = (TextDragObserver) c09881.L$1;
                    awaitPointerEventScope = (AwaitPointerEventScope) c09881.L$0;
                    ResultKt.throwOnFailure(objM725awaitLongPressOrCancellationrnUCldI);
                }
                if (((Boolean) objM725awaitLongPressOrCancellationrnUCldI).booleanValue()) {
                    changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                    size = changes.size();
                    for (i = 0; i < size; i++) {
                        pointerInputChange2 = changes.get(i);
                        if (PointerEventKt.changedToUp(pointerInputChange2)) {
                            pointerInputChange2.consume();
                        }
                    }
                    textDragObserver.onStop();
                } else {
                    textDragObserver.onCancel();
                }
                return Unit.INSTANCE;
            }
            PointerInputChange pointerInputChange4 = (PointerInputChange) objM725awaitLongPressOrCancellationrnUCldI;
            if (pointerInputChange4 != null && distanceIsTolerable(awaitPointerEventScope.getViewConfiguration(), pointerInputChange, pointerInputChange4)) {
                textDragObserver.mo1525onStartk4lQ0M(pointerInputChange4.getPosition());
                long id2 = pointerInputChange4.getId();
                Function1<PointerInputChange, Unit> function1 = new Function1<PointerInputChange, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((PointerInputChange) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(PointerInputChange pointerInputChange5) {
                        textDragObserver.mo1524onDragk4lQ0M(PointerEventKt.positionChange(pointerInputChange5));
                        pointerInputChange5.consume();
                    }
                };
                c09881.L$0 = awaitPointerEventScope;
                c09881.L$1 = textDragObserver;
                c09881.L$2 = null;
                c09881.label = 2;
                objM725awaitLongPressOrCancellationrnUCldI = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id2, function1, c09881);
                if (objM725awaitLongPressOrCancellationrnUCldI == coroutine_suspended) {
                    return coroutine_suspended;
                }
                if (((Boolean) objM725awaitLongPressOrCancellationrnUCldI).booleanValue()) {
                    changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                    size = changes.size();
                    while (i < size) {
                        pointerInputChange2 = changes.get(i);
                        if (PointerEventKt.changedToUp(pointerInputChange2)) {
                            pointerInputChange2.consume();
                        }
                    }
                    textDragObserver.onStop();
                } else {
                    textDragObserver.onCancel();
                }
            }
            return Unit.INSTANCE;
        } catch (CancellationException e) {
            textDragObserver.onCancel();
            throw e;
        }
    }

    public static final Object mouseSelection(AwaitPointerEventScope awaitPointerEventScope, final MouseSelectionObserver mouseSelectionObserver, ClicksCounter clicksCounter, PointerEvent pointerEvent, Continuation<? super Unit> continuation) {
        C09841 c09841;
        final SelectionAdjustment none;
        List<PointerInputChange> changes;
        int size;
        PointerInputChange pointerInputChange;
        List<PointerInputChange> changes2;
        int size2;
        PointerInputChange pointerInputChange2;
        if (continuation instanceof C09841) {
            c09841 = (C09841) continuation;
            if ((c09841.label & Integer.MIN_VALUE) != 0) {
                c09841.label -= Integer.MIN_VALUE;
            } else {
                c09841 = new C09841(continuation);
            }
        } else {
            c09841 = new C09841(continuation);
        }
        Object objM733dragjO51t88 = c09841.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09841.label;
        int i2 = 0;
        if (i == 0) {
            ResultKt.throwOnFailure(objM733dragjO51t88);
            clicksCounter.update(pointerEvent);
            PointerInputChange pointerInputChange3 = pointerEvent.getChanges().get(0);
            if (TextFieldSelectionManager_androidKt.isShiftPressed(pointerEvent)) {
                if (mouseSelectionObserver.mo1768onExtendk4lQ0M(pointerInputChange3.getPosition())) {
                    long id = pointerInputChange3.getId();
                    Function1<PointerInputChange, Unit> function1 = new Function1<PointerInputChange, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((PointerInputChange) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PointerInputChange pointerInputChange4) {
                            if (mouseSelectionObserver.mo1769onExtendDragk4lQ0M(pointerInputChange4.getPosition())) {
                                pointerInputChange4.consume();
                            }
                        }
                    };
                    c09841.L$0 = awaitPointerEventScope;
                    c09841.L$1 = mouseSelectionObserver;
                    c09841.label = 1;
                    objM733dragjO51t88 = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id, function1, c09841);
                    if (objM733dragjO51t88 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    if (((Boolean) objM733dragjO51t88).booleanValue()) {
                        changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                        size = changes.size();
                        while (i2 < size) {
                            pointerInputChange = changes.get(i2);
                            if (PointerEventKt.changedToUp(pointerInputChange)) {
                                pointerInputChange.consume();
                            }
                            i2++;
                        }
                    }
                    mouseSelectionObserver.onDragDone();
                }
            } else {
                int clicks = clicksCounter.getClicks();
                if (clicks == 1) {
                    none = SelectionAdjustment.INSTANCE.getNone();
                } else if (clicks == 2) {
                    none = SelectionAdjustment.INSTANCE.getWord();
                } else {
                    none = SelectionAdjustment.INSTANCE.getParagraph();
                }
                if (mouseSelectionObserver.mo1770onStart3MmeM6k(pointerInputChange3.getPosition(), none)) {
                    long id2 = pointerInputChange3.getId();
                    Function1<PointerInputChange, Unit> function2 = new Function1<PointerInputChange, Unit>() {
                        {
                            super(1);
                        }

                        public Object invoke(Object obj) {
                            invoke((PointerInputChange) obj);
                            return Unit.INSTANCE;
                        }

                        public final void invoke(PointerInputChange pointerInputChange4) {
                            if (mouseSelectionObserver.mo1767onDrag3MmeM6k(pointerInputChange4.getPosition(), none)) {
                                pointerInputChange4.consume();
                            }
                        }
                    };
                    c09841.L$0 = awaitPointerEventScope;
                    c09841.L$1 = mouseSelectionObserver;
                    c09841.label = 2;
                    objM733dragjO51t88 = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id2, function2, c09841);
                    if (objM733dragjO51t88 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    if (((Boolean) objM733dragjO51t88).booleanValue()) {
                        changes2 = awaitPointerEventScope.getCurrentEvent().getChanges();
                        size2 = changes2.size();
                        while (i2 < size2) {
                            pointerInputChange2 = changes2.get(i2);
                            if (PointerEventKt.changedToUp(pointerInputChange2)) {
                                pointerInputChange2.consume();
                            }
                            i2++;
                        }
                    }
                    mouseSelectionObserver.onDragDone();
                }
            }
        } else if (i == 1) {
            mouseSelectionObserver = (MouseSelectionObserver) c09841.L$1;
            awaitPointerEventScope = (AwaitPointerEventScope) c09841.L$0;
            ResultKt.throwOnFailure(objM733dragjO51t88);
            if (((Boolean) objM733dragjO51t88).booleanValue()) {
                changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                size = changes.size();
                while (i2 < size) {
                    pointerInputChange = changes.get(i2);
                    if (PointerEventKt.changedToUp(pointerInputChange)) {
                        pointerInputChange.consume();
                    }
                    i2++;
                }
            }
            mouseSelectionObserver.onDragDone();
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            mouseSelectionObserver = (MouseSelectionObserver) c09841.L$1;
            awaitPointerEventScope = (AwaitPointerEventScope) c09841.L$0;
            ResultKt.throwOnFailure(objM733dragjO51t88);
            if (((Boolean) objM733dragjO51t88).booleanValue()) {
                changes2 = awaitPointerEventScope.getCurrentEvent().getChanges();
                size2 = changes2.size();
                while (i2 < size2) {
                    pointerInputChange2 = changes2.get(i2);
                    if (PointerEventKt.changedToUp(pointerInputChange2)) {
                        pointerInputChange2.consume();
                    }
                    i2++;
                }
            }
            mouseSelectionObserver.onDragDone();
        }
        return Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt$selectionGesturePointerInputBtf2$2", f = "SelectionGestures.kt", i = {0}, l = {209, 217, 220, 221}, m = "invokeSuspend", n = {"$this$awaitEachGesture"}, s = {"L$0"})
    static final class C09872 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super Unit>, Object> {
        final ClicksCounter $clicksCounter;
        final MouseSelectionObserver $mouseSelectionObserver;
        final TextDragObserver $textDragObserver;
        private Object L$0;
        int label;

        C09872(ClicksCounter clicksCounter, MouseSelectionObserver mouseSelectionObserver, TextDragObserver textDragObserver, Continuation<? super C09872> continuation) {
            super(2, continuation);
            this.$clicksCounter = clicksCounter;
            this.$mouseSelectionObserver = mouseSelectionObserver;
            this.$textDragObserver = textDragObserver;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c09872 = new C09872(this.$clicksCounter, this.$mouseSelectionObserver, this.$textDragObserver, continuation);
            c09872.L$0 = obj;
            return c09872;
        }

        public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super Unit> continuation) {
            return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            AwaitPointerEventScope awaitPointerEventScope;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                this.L$0 = awaitPointerEventScope;
                this.label = 1;
                obj = SelectionGesturesKt.awaitDown(awaitPointerEventScope, (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2 && i != 3 && i != 4) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            PointerEvent pointerEvent = (PointerEvent) obj;
            this.$clicksCounter.update(pointerEvent);
            boolean zIsPrecisePointer = SelectionGesturesKt.isPrecisePointer(pointerEvent);
            if (zIsPrecisePointer && PointerEvent_androidKt.m5819isPrimaryPressedaHzCxE(pointerEvent.getButtons())) {
                List<PointerInputChange> changes = pointerEvent.getChanges();
                int size = changes.size();
                int i2 = 0;
                while (true) {
                    if (i2 >= size) {
                        this.L$0 = null;
                        this.label = 2;
                        if (SelectionGesturesKt.mouseSelectionBtf2(awaitPointerEventScope, this.$mouseSelectionObserver, this.$clicksCounter, pointerEvent, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (changes.get(i2).isConsumed()) {
                            break;
                        }
                        i2++;
                    }
                }
                if (!zIsPrecisePointer) {
                    if (this.$clicksCounter.getClicks() == 1) {
                        this.L$0 = null;
                        this.label = 3;
                        if (SelectionGesturesKt.touchSelectionFirstPress(awaitPointerEventScope, this.$textDragObserver, pointerEvent, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        this.L$0 = null;
                        this.label = 4;
                        if (SelectionGesturesKt.touchSelectionSubsequentPress(awaitPointerEventScope, this.$textDragObserver, pointerEvent, (Continuation) this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    }
                }
            } else if (!zIsPrecisePointer) {
                if (this.$clicksCounter.getClicks() == 1) {
                    this.L$0 = null;
                    this.label = 3;
                    if (SelectionGesturesKt.touchSelectionFirstPress(awaitPointerEventScope, this.$textDragObserver, pointerEvent, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    this.L$0 = null;
                    this.label = 4;
                    if (SelectionGesturesKt.touchSelectionSubsequentPress(awaitPointerEventScope, this.$textDragObserver, pointerEvent, (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
            }
            return Unit.INSTANCE;
        }
    }

    public static final Object selectionGesturePointerInputBtf2(PointerInputScope pointerInputScope, MouseSelectionObserver mouseSelectionObserver, TextDragObserver textDragObserver, Continuation<? super Unit> continuation) {
        Object objAwaitEachGesture = ForEachGestureKt.awaitEachGesture(pointerInputScope, new C09872(new ClicksCounter(pointerInputScope.getViewConfiguration()), mouseSelectionObserver, textDragObserver, null), continuation);
        return objAwaitEachGesture == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAwaitEachGesture : Unit.INSTANCE;
    }

    public static final Object touchSelectionFirstPress(AwaitPointerEventScope awaitPointerEventScope, final TextDragObserver textDragObserver, PointerEvent pointerEvent, Continuation<? super Unit> continuation) {
        C09901 c09901;
        PointerInputChange pointerInputChange;
        List<PointerInputChange> changes;
        int size;
        int i;
        PointerInputChange pointerInputChange2;
        if (continuation instanceof C09901) {
            c09901 = (C09901) continuation;
            if ((c09901.label & Integer.MIN_VALUE) != 0) {
                c09901.label -= Integer.MIN_VALUE;
            } else {
                c09901 = new C09901(continuation);
            }
        } else {
            c09901 = new C09901(continuation);
        }
        Object objM725awaitLongPressOrCancellationrnUCldI = c09901.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c09901.label;
        try {
            if (i2 == 0) {
                ResultKt.throwOnFailure(objM725awaitLongPressOrCancellationrnUCldI);
                pointerInputChange = (PointerInputChange) CollectionsKt.first(pointerEvent.getChanges());
                long id = pointerInputChange.getId();
                c09901.L$0 = awaitPointerEventScope;
                c09901.L$1 = textDragObserver;
                c09901.L$2 = pointerInputChange;
                c09901.label = 1;
                objM725awaitLongPressOrCancellationrnUCldI = DragGestureDetectorKt.m725awaitLongPressOrCancellationrnUCldI(awaitPointerEventScope, id, c09901);
                if (objM725awaitLongPressOrCancellationrnUCldI == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i2 == 1) {
                    PointerInputChange pointerInputChange3 = (PointerInputChange) c09901.L$2;
                    textDragObserver = (TextDragObserver) c09901.L$1;
                    AwaitPointerEventScope awaitPointerEventScope2 = (AwaitPointerEventScope) c09901.L$0;
                    ResultKt.throwOnFailure(objM725awaitLongPressOrCancellationrnUCldI);
                    pointerInputChange = pointerInputChange3;
                    awaitPointerEventScope = awaitPointerEventScope2;
                } else {
                    if (i2 != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    textDragObserver = (TextDragObserver) c09901.L$1;
                    awaitPointerEventScope = (AwaitPointerEventScope) c09901.L$0;
                    ResultKt.throwOnFailure(objM725awaitLongPressOrCancellationrnUCldI);
                }
                if (((Boolean) objM725awaitLongPressOrCancellationrnUCldI).booleanValue()) {
                    changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                    size = changes.size();
                    for (i = 0; i < size; i++) {
                        pointerInputChange2 = changes.get(i);
                        if (PointerEventKt.changedToUp(pointerInputChange2)) {
                            pointerInputChange2.consume();
                        }
                    }
                    textDragObserver.onStop();
                } else {
                    textDragObserver.onCancel();
                }
                return Unit.INSTANCE;
            }
            PointerInputChange pointerInputChange4 = (PointerInputChange) objM725awaitLongPressOrCancellationrnUCldI;
            if (pointerInputChange4 != null && distanceIsTolerable(awaitPointerEventScope.getViewConfiguration(), pointerInputChange, pointerInputChange4)) {
                textDragObserver.mo1525onStartk4lQ0M(pointerInputChange4.getPosition());
                long id2 = pointerInputChange4.getId();
                Function1<PointerInputChange, Unit> function1 = new Function1<PointerInputChange, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((PointerInputChange) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(PointerInputChange pointerInputChange5) {
                        textDragObserver.mo1524onDragk4lQ0M(PointerEventKt.positionChange(pointerInputChange5));
                        pointerInputChange5.consume();
                    }
                };
                c09901.L$0 = awaitPointerEventScope;
                c09901.L$1 = textDragObserver;
                c09901.L$2 = null;
                c09901.label = 2;
                objM725awaitLongPressOrCancellationrnUCldI = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id2, function1, c09901);
                if (objM725awaitLongPressOrCancellationrnUCldI == coroutine_suspended) {
                    return coroutine_suspended;
                }
                if (((Boolean) objM725awaitLongPressOrCancellationrnUCldI).booleanValue()) {
                    changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                    size = changes.size();
                    while (i < size) {
                        pointerInputChange2 = changes.get(i);
                        if (PointerEventKt.changedToUp(pointerInputChange2)) {
                            pointerInputChange2.consume();
                        }
                    }
                    textDragObserver.onStop();
                } else {
                    textDragObserver.onCancel();
                }
            }
            return Unit.INSTANCE;
        } catch (CancellationException e) {
            textDragObserver.onCancel();
            throw e;
        }
    }

    public static final Object touchSelectionSubsequentPress(AwaitPointerEventScope awaitPointerEventScope, final TextDragObserver textDragObserver, PointerEvent pointerEvent, Continuation<? super Unit> continuation) {
        C09921 c09921;
        PointerInputChange pointerInputChange;
        long id;
        Ref.LongRef longRef;
        Object objWithTimeoutOrNull;
        List<PointerInputChange> changes;
        int size;
        int i;
        PointerInputChange pointerInputChange2;
        if (continuation instanceof C09921) {
            c09921 = (C09921) continuation;
            if ((c09921.label & Integer.MIN_VALUE) != 0) {
                c09921.label -= Integer.MIN_VALUE;
            } else {
                c09921 = new C09921(continuation);
            }
        } else {
            c09921 = new C09921(continuation);
        }
        Object objM733dragjO51t88 = c09921.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i2 = c09921.label;
        try {
            if (i2 == 0) {
                ResultKt.throwOnFailure(objM733dragjO51t88);
                pointerInputChange = (PointerInputChange) CollectionsKt.first(pointerEvent.getChanges());
                id = pointerInputChange.getId();
                longRef = new Ref.LongRef();
                longRef.element = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
                long longPressTimeoutMillis = awaitPointerEventScope.getViewConfiguration().getLongPressTimeoutMillis();
                C0993xcb1d223 c0993xcb1d223 = new C0993xcb1d223(id, longRef, null);
                c09921.L$0 = awaitPointerEventScope;
                c09921.L$1 = textDragObserver;
                c09921.L$2 = pointerInputChange;
                c09921.L$3 = longRef;
                c09921.J$0 = id;
                c09921.label = 1;
                objWithTimeoutOrNull = awaitPointerEventScope.withTimeoutOrNull(longPressTimeoutMillis, c0993xcb1d223, c09921);
                if (objWithTimeoutOrNull == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i2 == 1) {
                    long j = c09921.J$0;
                    Ref.LongRef longRef2 = (Ref.LongRef) c09921.L$3;
                    pointerInputChange = (PointerInputChange) c09921.L$2;
                    TextDragObserver textDragObserver2 = (TextDragObserver) c09921.L$1;
                    AwaitPointerEventScope awaitPointerEventScope2 = (AwaitPointerEventScope) c09921.L$0;
                    try {
                        ResultKt.throwOnFailure(objM733dragjO51t88);
                        longRef = longRef2;
                        objWithTimeoutOrNull = objM733dragjO51t88;
                        id = j;
                        textDragObserver = textDragObserver2;
                        awaitPointerEventScope = awaitPointerEventScope2;
                    } catch (CancellationException e) {
                        e = e;
                        textDragObserver = textDragObserver2;
                        textDragObserver.onCancel();
                        throw e;
                    }
                } else {
                    if (i2 != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    textDragObserver = (TextDragObserver) c09921.L$1;
                    awaitPointerEventScope = (AwaitPointerEventScope) c09921.L$0;
                    ResultKt.throwOnFailure(objM733dragjO51t88);
                }
                if (((Boolean) objM733dragjO51t88).booleanValue()) {
                    changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                    size = changes.size();
                    for (i = 0; i < size; i++) {
                        pointerInputChange2 = changes.get(i);
                        if (PointerEventKt.changedToUp(pointerInputChange2)) {
                            pointerInputChange2.consume();
                        }
                    }
                    textDragObserver.onStop();
                } else {
                    textDragObserver.onCancel();
                }
                return Unit.INSTANCE;
            }
            DownResolution downResolution = (DownResolution) objWithTimeoutOrNull;
            if (downResolution == null) {
                downResolution = DownResolution.Timeout;
            }
            if (downResolution == DownResolution.Cancel) {
                return Unit.INSTANCE;
            }
            textDragObserver.mo1525onStartk4lQ0M(pointerInputChange.getPosition());
            if (downResolution == DownResolution.Up) {
                textDragObserver.onStop();
                return Unit.INSTANCE;
            }
            if (downResolution == DownResolution.Drag) {
                textDragObserver.mo1524onDragk4lQ0M(longRef.element);
            }
            Function1<PointerInputChange, Unit> function1 = new Function1<PointerInputChange, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((PointerInputChange) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(PointerInputChange pointerInputChange3) {
                    textDragObserver.mo1524onDragk4lQ0M(PointerEventKt.positionChange(pointerInputChange3));
                    pointerInputChange3.consume();
                }
            };
            c09921.L$0 = awaitPointerEventScope;
            c09921.L$1 = textDragObserver;
            c09921.L$2 = null;
            c09921.L$3 = null;
            c09921.label = 2;
            objM733dragjO51t88 = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id, function1, c09921);
            if (objM733dragjO51t88 == coroutine_suspended) {
                return coroutine_suspended;
            }
            if (((Boolean) objM733dragjO51t88).booleanValue()) {
                changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                size = changes.size();
                while (i < size) {
                    pointerInputChange2 = changes.get(i);
                    if (PointerEventKt.changedToUp(pointerInputChange2)) {
                        pointerInputChange2.consume();
                    }
                }
                textDragObserver.onStop();
            } else {
                textDragObserver.onCancel();
            }
            return Unit.INSTANCE;
        } catch (CancellationException e2) {
            e = e2;
        }
    }

    public static final Object mouseSelectionBtf2(AwaitPointerEventScope awaitPointerEventScope, final MouseSelectionObserver mouseSelectionObserver, ClicksCounter clicksCounter, PointerEvent pointerEvent, Continuation<? super Unit> continuation) {
        C09851 c09851;
        final SelectionAdjustment none;
        List<PointerInputChange> changes;
        int size;
        PointerInputChange pointerInputChange;
        List<PointerInputChange> changes2;
        int size2;
        PointerInputChange pointerInputChange2;
        if (continuation instanceof C09851) {
            c09851 = (C09851) continuation;
            if ((c09851.label & Integer.MIN_VALUE) != 0) {
                c09851.label -= Integer.MIN_VALUE;
            } else {
                c09851 = new C09851(continuation);
            }
        } else {
            c09851 = new C09851(continuation);
        }
        Object objM733dragjO51t88 = c09851.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09851.label;
        int i2 = 0;
        try {
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(objM733dragjO51t88);
                    PointerInputChange pointerInputChange3 = pointerEvent.getChanges().get(0);
                    if (TextFieldSelectionManager_androidKt.isShiftPressed(pointerEvent)) {
                        if (mouseSelectionObserver.mo1768onExtendk4lQ0M(pointerInputChange3.getPosition())) {
                            pointerInputChange3.consume();
                            long id = pointerInputChange3.getId();
                            Function1<PointerInputChange, Unit> function1 = new Function1<PointerInputChange, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((PointerInputChange) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(PointerInputChange pointerInputChange4) {
                                    if (mouseSelectionObserver.mo1769onExtendDragk4lQ0M(pointerInputChange4.getPosition())) {
                                        pointerInputChange4.consume();
                                    }
                                }
                            };
                            c09851.L$0 = awaitPointerEventScope;
                            c09851.L$1 = mouseSelectionObserver;
                            c09851.label = 1;
                            objM733dragjO51t88 = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id, function1, c09851);
                            if (objM733dragjO51t88 == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            if (((Boolean) objM733dragjO51t88).booleanValue()) {
                                changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                                size = changes.size();
                                while (i2 < size) {
                                    pointerInputChange = changes.get(i2);
                                    if (PointerEventKt.changedToUp(pointerInputChange)) {
                                        pointerInputChange.consume();
                                    }
                                    i2++;
                                }
                            }
                            mouseSelectionObserver.onDragDone();
                        }
                    } else {
                        int clicks = clicksCounter.getClicks();
                        if (clicks == 1) {
                            none = SelectionAdjustment.INSTANCE.getNone();
                        } else if (clicks == 2) {
                            none = SelectionAdjustment.INSTANCE.getWord();
                        } else {
                            none = SelectionAdjustment.INSTANCE.getParagraph();
                        }
                        if (mouseSelectionObserver.mo1770onStart3MmeM6k(pointerInputChange3.getPosition(), none)) {
                            pointerInputChange3.consume();
                            long id2 = pointerInputChange3.getId();
                            Function1<PointerInputChange, Unit> function2 = new Function1<PointerInputChange, Unit>() {
                                {
                                    super(1);
                                }

                                public Object invoke(Object obj) {
                                    invoke((PointerInputChange) obj);
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(PointerInputChange pointerInputChange4) {
                                    if (mouseSelectionObserver.mo1767onDrag3MmeM6k(pointerInputChange4.getPosition(), none)) {
                                        pointerInputChange4.consume();
                                    }
                                }
                            };
                            c09851.L$0 = awaitPointerEventScope;
                            c09851.L$1 = mouseSelectionObserver;
                            c09851.label = 2;
                            objM733dragjO51t88 = DragGestureDetectorKt.m733dragjO51t88(awaitPointerEventScope, id2, function2, c09851);
                            if (objM733dragjO51t88 == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            if (((Boolean) objM733dragjO51t88).booleanValue()) {
                                changes2 = awaitPointerEventScope.getCurrentEvent().getChanges();
                                size2 = changes2.size();
                                while (i2 < size2) {
                                    pointerInputChange2 = changes2.get(i2);
                                    if (PointerEventKt.changedToUp(pointerInputChange2)) {
                                        pointerInputChange2.consume();
                                    }
                                    i2++;
                                }
                            }
                            mouseSelectionObserver.onDragDone();
                        }
                    }
                } else if (i == 1) {
                    mouseSelectionObserver = (MouseSelectionObserver) c09851.L$1;
                    awaitPointerEventScope = (AwaitPointerEventScope) c09851.L$0;
                    ResultKt.throwOnFailure(objM733dragjO51t88);
                    if (((Boolean) objM733dragjO51t88).booleanValue()) {
                        changes = awaitPointerEventScope.getCurrentEvent().getChanges();
                        size = changes.size();
                        while (i2 < size) {
                            pointerInputChange = changes.get(i2);
                            if (PointerEventKt.changedToUp(pointerInputChange)) {
                                pointerInputChange.consume();
                            }
                            i2++;
                        }
                    }
                    mouseSelectionObserver.onDragDone();
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    mouseSelectionObserver = (MouseSelectionObserver) c09851.L$1;
                    awaitPointerEventScope = (AwaitPointerEventScope) c09851.L$0;
                    ResultKt.throwOnFailure(objM733dragjO51t88);
                    if (((Boolean) objM733dragjO51t88).booleanValue()) {
                        changes2 = awaitPointerEventScope.getCurrentEvent().getChanges();
                        size2 = changes2.size();
                        while (i2 < size2) {
                            pointerInputChange2 = changes2.get(i2);
                            if (PointerEventKt.changedToUp(pointerInputChange2)) {
                                pointerInputChange2.consume();
                            }
                            i2++;
                        }
                    }
                    mouseSelectionObserver.onDragDone();
                }
                return Unit.INSTANCE;
            } catch (Throwable th) {
                mouseSelectionObserver.onDragDone();
                throw th;
            }
        } catch (Throwable th2) {
            mouseSelectionObserver.onDragDone();
            throw th2;
        }
    }

    public static final java.lang.Object awaitDown(androidx.compose.p002ui.input.pointer.AwaitPointerEventScope r7, kotlin.coroutines.Continuation<? super androidx.compose.p002ui.input.pointer.PointerEvent> r8) {
        throw new UnsupportedOperationException("Method not decompiled: androidx.compose.foundation.text.selection.SelectionGesturesKt.awaitDown(androidx.compose.ui.input.pointer.AwaitPointerEventScope, kotlin.coroutines.Continuation):java.lang.Object");
    }

    public static final boolean distanceIsTolerable(ViewConfiguration viewConfiguration, PointerInputChange pointerInputChange, PointerInputChange pointerInputChange2) {
        return Offset.m4344getDistanceimpl(Offset.m4350minusMKHz9U(pointerInputChange.getPosition(), pointerInputChange2.getPosition())) < DragGestureDetectorKt.m736pointerSlopE8SPZFQ(viewConfiguration, pointerInputChange.getType());
    }

    public static final boolean isPrecisePointer(PointerEvent pointerEvent) {
        List<PointerInputChange> changes = pointerEvent.getChanges();
        int size = changes.size();
        for (int i = 0; i < size; i++) {
            if (!PointerType.m5919equalsimpl0(changes.get(i).getType(), PointerType.INSTANCE.m5924getMouseT8wyACA())) {
                return false;
            }
        }
        return true;
    }
}
