package androidx.compose.p002ui.scrollcapture;

import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.os.CancellationSignal;
import android.view.ScrollCaptureCallback;
import android.view.ScrollCaptureSession;
import androidx.compose.p002ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.p002ui.graphics.RectHelper_androidKt;
import androidx.compose.p002ui.node.NodeCoordinator;
import androidx.compose.p002ui.semantics.SemanticsNode;
import androidx.compose.runtime.MonotonicFrameClockKt;
import androidx.compose.ui.unit.IntRect;
import androidx.core.app.NotificationCompat$;
import java.util.function.Consumer;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.math.MathKt;
import kotlin.random.Random;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.NonCancellable;

@Metadata(d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u00002\u00020\u0001:\u0001\"B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u0010\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012H\u0016J.\u0010\u0013\u001a\u00020\u00102\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\f\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00190\u001bH\u0016J\u001e\u0010\u0013\u001a\u00020\u00052\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0018\u001a\u00020\u0005H\u0082@¢\u0006\u0002\u0010\u001cJ\u001e\u0010\u001d\u001a\u00020\u00102\u0006\u0010\u0016\u001a\u00020\u00172\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00190\u001bH\u0016J \u0010\u001e\u001a\u00020\u00102\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0011\u001a\u00020\u0012H\u0016J\f\u0010\u001f\u001a\u00020\u0010*\u00020 H\u0002J\f\u0010!\u001a\u00020\u0010*\u00020 H\u0002R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006#"}, d2 = {"Landroidx/compose/ui/scrollcapture/ComposeScrollCaptureCallback;", "Landroid/view/ScrollCaptureCallback;", "node", "Landroidx/compose/ui/semantics/SemanticsNode;", "viewportBoundsInWindow", "Landroidx/compose/ui/unit/IntRect;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "listener", "Landroidx/compose/ui/scrollcapture/ComposeScrollCaptureCallback$ScrollCaptureSessionListener;", "(Landroidx/compose/ui/semantics/SemanticsNode;Landroidx/compose/ui/unit/IntRect;Lkotlinx/coroutines/CoroutineScope;Landroidx/compose/ui/scrollcapture/ComposeScrollCaptureCallback$ScrollCaptureSessionListener;)V", "requestCount", "", "scrollTracker", "Landroidx/compose/ui/scrollcapture/RelativeScroller;", "onScrollCaptureEnd", "", "onReady", "Ljava/lang/Runnable;", "onScrollCaptureImageRequest", "session", "Landroid/view/ScrollCaptureSession;", "signal", "Landroid/os/CancellationSignal;", "captureArea", "Landroid/graphics/Rect;", "onComplete", "Ljava/util/function/Consumer;", "(Landroid/view/ScrollCaptureSession;Landroidx/compose/ui/unit/IntRect;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onScrollCaptureSearch", "onScrollCaptureStart", "drawDebugBackground", "Landroid/graphics/Canvas;", "drawDebugOverlay", "ScrollCaptureSessionListener", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ComposeScrollCaptureCallback implements ScrollCaptureCallback {
    public static final int $stable = 8;
    private final CoroutineScope coroutineScope;
    private final ScrollCaptureSessionListener listener;
    private final SemanticsNode node;
    private int requestCount;
    private final RelativeScroller scrollTracker;
    private final IntRect viewportBoundsInWindow;

    @Metadata(d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\bf\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H&J\b\u0010\u0004\u001a\u00020\u0003H&ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0005À\u0006\u0001"}, d2 = {"Landroidx/compose/ui/scrollcapture/ComposeScrollCaptureCallback$ScrollCaptureSessionListener;", "", "onSessionEnded", "", "onSessionStarted", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public interface ScrollCaptureSessionListener {
        void onSessionEnded();

        void onSessionStarted();
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.scrollcapture.ComposeScrollCaptureCallback", f = "ComposeScrollCaptureCallback.android.kt", i = {0, 0, 0, 0, 0, 1, 1, 1, 1, 1}, l = {129, 132}, m = "onScrollCaptureImageRequest", n = {"this", "session", "captureArea", "targetMin", "targetMax", "this", "session", "captureArea", "targetMin", "targetMax"}, s = {"L$0", "L$1", "L$2", "I$0", "I$1", "L$0", "L$1", "L$2", "I$0", "I$1"})
    static final class C17682 extends ContinuationImpl {
        int I$0;
        int I$1;
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C17682(Continuation<? super C17682> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ComposeScrollCaptureCallback.this.onScrollCaptureImageRequest(null, null, (Continuation) this);
        }
    }

    public ComposeScrollCaptureCallback(SemanticsNode semanticsNode, IntRect intRect, CoroutineScope coroutineScope, ScrollCaptureSessionListener scrollCaptureSessionListener) {
        this.node = semanticsNode;
        this.viewportBoundsInWindow = intRect;
        this.listener = scrollCaptureSessionListener;
        this.coroutineScope = CoroutineScopeKt.plus(coroutineScope, DisableAnimationMotionDurationScale.INSTANCE);
        this.scrollTracker = new RelativeScroller(intRect.getHeight(), new ComposeScrollCaptureCallback$scrollTracker$1(this, null));
    }

    @Override
    public void onScrollCaptureSearch(CancellationSignal signal, Consumer<Rect> onReady) {
        onReady.accept(RectHelper_androidKt.toAndroidRect(this.viewportBoundsInWindow));
    }

    @Override
    public void onScrollCaptureStart(ScrollCaptureSession session, CancellationSignal signal, Runnable onReady) {
        this.scrollTracker.reset();
        this.requestCount = 0;
        this.listener.onSessionStarted();
        onReady.run();
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.scrollcapture.ComposeScrollCaptureCallback$onScrollCaptureImageRequest$1", f = "ComposeScrollCaptureCallback.android.kt", i = {}, l = {116}, m = "invokeSuspend", n = {}, s = {})
    static final class C17671 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Rect $captureArea;
        final Consumer<Rect> $onComplete;
        final ScrollCaptureSession $session;
        int label;

        C17671(ScrollCaptureSession scrollCaptureSession, Rect rect, Consumer<Rect> consumer, Continuation<? super C17671> continuation) {
            super(2, continuation);
            this.$session = scrollCaptureSession;
            this.$captureArea = rect;
            this.$onComplete = consumer;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ComposeScrollCaptureCallback.this.new C17671(this.$session, this.$captureArea, this.$onComplete, continuation);
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
                obj = ComposeScrollCaptureCallback.this.onScrollCaptureImageRequest(this.$session, RectHelper_androidKt.toComposeIntRect(this.$captureArea), (Continuation) this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            this.$onComplete.accept(RectHelper_androidKt.toAndroidRect((IntRect) obj));
            return Unit.INSTANCE;
        }
    }

    @Override
    public void onScrollCaptureImageRequest(ScrollCaptureSession session, CancellationSignal signal, Rect captureArea, Consumer<Rect> onComplete) {
        ComposeScrollCaptureCallback_androidKt.launchWithCancellationSignal(this.coroutineScope, signal, new C17671(session, captureArea, onComplete, null));
    }

    public final Object onScrollCaptureImageRequest(ScrollCaptureSession scrollCaptureSession, IntRect intRect, Continuation<? super IntRect> continuation) {
        C17682 c17682;
        int top;
        int bottom;
        ComposeScrollCaptureCallback composeScrollCaptureCallback;
        IntRect intRect2;
        int i;
        ComposeScrollCaptureCallback composeScrollCaptureCallback2;
        ScrollCaptureSession scrollCaptureSession2;
        int i2;
        int iMapOffsetToViewport;
        int iMapOffsetToViewport2;
        IntRect intRectCopy$default;
        NodeCoordinator nodeCoordinatorFindCoordinatorToGetBounds$ui_release;
        Canvas canvasLockHardwareCanvas;
        if (continuation instanceof C17682) {
            c17682 = (C17682) continuation;
            if ((c17682.label & Integer.MIN_VALUE) != 0) {
                c17682.label -= Integer.MIN_VALUE;
            } else {
                c17682 = new C17682(continuation);
            }
        } else {
            c17682 = new C17682(continuation);
        }
        Object obj = c17682.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i3 = c17682.label;
        if (i3 == 0) {
            ResultKt.throwOnFailure(obj);
            top = intRect.getTop();
            bottom = intRect.getBottom();
            RelativeScroller relativeScroller = this.scrollTracker;
            c17682.L$0 = this;
            c17682.L$1 = scrollCaptureSession;
            c17682.L$2 = intRect;
            c17682.I$0 = top;
            c17682.I$1 = bottom;
            c17682.label = 1;
            if (relativeScroller.scrollRangeIntoView(top, bottom, c17682) == coroutine_suspended) {
                return coroutine_suspended;
            }
            composeScrollCaptureCallback = this;
        } else {
            if (i3 == 1) {
                int i4 = c17682.I$1;
                int i5 = c17682.I$0;
                IntRect intRect3 = (IntRect) c17682.L$2;
                ScrollCaptureSession scrollCaptureSessionM = NotificationCompat$.ExternalSyntheticApiModelOutline0.m(c17682.L$1);
                composeScrollCaptureCallback = (ComposeScrollCaptureCallback) c17682.L$0;
                ResultKt.throwOnFailure(obj);
                top = i5;
                intRect = intRect3;
                bottom = i4;
                scrollCaptureSession = scrollCaptureSessionM;
            } else {
                if (i3 != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                i2 = c17682.I$1;
                i = c17682.I$0;
                intRect2 = (IntRect) c17682.L$2;
                ScrollCaptureSession scrollCaptureSessionM2 = NotificationCompat$.ExternalSyntheticApiModelOutline0.m(c17682.L$1);
                composeScrollCaptureCallback2 = (ComposeScrollCaptureCallback) c17682.L$0;
                ResultKt.throwOnFailure(obj);
                scrollCaptureSession2 = scrollCaptureSessionM2;
            }
            iMapOffsetToViewport = composeScrollCaptureCallback2.scrollTracker.mapOffsetToViewport(i);
            iMapOffsetToViewport2 = composeScrollCaptureCallback2.scrollTracker.mapOffsetToViewport(i2);
            intRectCopy$default = IntRect.copy$default(intRect2, 0, iMapOffsetToViewport, 0, iMapOffsetToViewport2, 5, (Object) null);
            if (iMapOffsetToViewport == iMapOffsetToViewport2) {
                return IntRect.Companion.getZero();
            }
            nodeCoordinatorFindCoordinatorToGetBounds$ui_release = composeScrollCaptureCallback2.node.findCoordinatorToGetBounds$ui_release();
            if (nodeCoordinatorFindCoordinatorToGetBounds$ui_release != null) {
                throw new IllegalStateException("Could not find coordinator for semantics node.".toString());
            }
            canvasLockHardwareCanvas = NotificationCompat$.ExternalSyntheticApiModelOutline0.m(scrollCaptureSession2).lockHardwareCanvas();
            try {
                NotificationCompat$.ExternalSyntheticApiModelOutline0.m(canvasLockHardwareCanvas, 0, BlendMode.CLEAR);
                androidx.compose.p002ui.graphics.Canvas Canvas = AndroidCanvas_androidKt.Canvas(canvasLockHardwareCanvas);
                Canvas.translate(-intRectCopy$default.getLeft(), -intRectCopy$default.getTop());
                nodeCoordinatorFindCoordinatorToGetBounds$ui_release.draw(Canvas, null);
                return intRectCopy$default.translate(0, MathKt.roundToInt(composeScrollCaptureCallback2.scrollTracker.getScrollAmount()));
            } finally {
                NotificationCompat$.ExternalSyntheticApiModelOutline0.m(scrollCaptureSession2).unlockCanvasAndPost(canvasLockHardwareCanvas);
            }
        }
        C17693 c17693 = new Function1<Long, Unit>() {
            public final void invoke(long j) {
            }

            public Object invoke(Object obj2) {
                invoke(((Number) obj2).longValue());
                return Unit.INSTANCE;
            }
        };
        c17682.L$0 = composeScrollCaptureCallback;
        c17682.L$1 = scrollCaptureSession;
        c17682.L$2 = intRect;
        c17682.I$0 = top;
        c17682.I$1 = bottom;
        c17682.label = 2;
        if (MonotonicFrameClockKt.withFrameNanos(c17693, c17682) == coroutine_suspended) {
            return coroutine_suspended;
        }
        intRect2 = intRect;
        i = top;
        composeScrollCaptureCallback2 = composeScrollCaptureCallback;
        scrollCaptureSession2 = scrollCaptureSession;
        i2 = bottom;
        iMapOffsetToViewport = composeScrollCaptureCallback2.scrollTracker.mapOffsetToViewport(i);
        iMapOffsetToViewport2 = composeScrollCaptureCallback2.scrollTracker.mapOffsetToViewport(i2);
        intRectCopy$default = IntRect.copy$default(intRect2, 0, iMapOffsetToViewport, 0, iMapOffsetToViewport2, 5, (Object) null);
        if (iMapOffsetToViewport == iMapOffsetToViewport2) {
            return IntRect.Companion.getZero();
        }
        nodeCoordinatorFindCoordinatorToGetBounds$ui_release = composeScrollCaptureCallback2.node.findCoordinatorToGetBounds$ui_release();
        if (nodeCoordinatorFindCoordinatorToGetBounds$ui_release != null) {
            throw new IllegalStateException("Could not find coordinator for semantics node.".toString());
        }
        canvasLockHardwareCanvas = NotificationCompat$.ExternalSyntheticApiModelOutline0.m(scrollCaptureSession2).lockHardwareCanvas();
        NotificationCompat$.ExternalSyntheticApiModelOutline0.m(canvasLockHardwareCanvas, 0, BlendMode.CLEAR);
        androidx.compose.p002ui.graphics.Canvas Canvas2 = AndroidCanvas_androidKt.Canvas(canvasLockHardwareCanvas);
        Canvas2.translate(-intRectCopy$default.getLeft(), -intRectCopy$default.getTop());
        nodeCoordinatorFindCoordinatorToGetBounds$ui_release.draw(Canvas2, null);
        return intRectCopy$default.translate(0, MathKt.roundToInt(composeScrollCaptureCallback2.scrollTracker.getScrollAmount()));
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.scrollcapture.ComposeScrollCaptureCallback$onScrollCaptureEnd$1", f = "ComposeScrollCaptureCallback.android.kt", i = {}, l = {190}, m = "invokeSuspend", n = {}, s = {})
    static final class C17661 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Runnable $onReady;
        int label;

        C17661(Runnable runnable, Continuation<? super C17661> continuation) {
            super(2, continuation);
            this.$onReady = runnable;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ComposeScrollCaptureCallback.this.new C17661(this.$onReady, continuation);
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
                if (ComposeScrollCaptureCallback.this.scrollTracker.scrollTo(0.0f, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            ComposeScrollCaptureCallback.this.listener.onSessionEnded();
            this.$onReady.run();
            return Unit.INSTANCE;
        }
    }

    @Override
    public void onScrollCaptureEnd(Runnable onReady) {
        BuildersKt.launch$default(this.coroutineScope, NonCancellable.INSTANCE, (CoroutineStart) null, new C17661(onReady, null), 2, (Object) null);
    }

    private final void drawDebugBackground(Canvas canvas) {
        canvas.drawColor(ColorKt.m4644toArgb8_81llA(Color.Companion.m4614hslJlNiLsg$default(Color.INSTANCE, Random.Default.nextFloat() * 360.0f, 0.75f, 0.5f, 1.0f, null, 16, null)));
    }

    private final void drawDebugOverlay(Canvas canvas) {
        Paint paint = new Paint();
        paint.setColor(-65536);
        paint.setTextSize(48.0f);
        canvas.drawCircle(0.0f, 0.0f, 20.0f, paint);
        canvas.drawCircle(canvas.getWidth(), 0.0f, 20.0f, paint);
        canvas.drawCircle(canvas.getWidth(), canvas.getHeight(), 20.0f, paint);
        canvas.drawCircle(0.0f, canvas.getHeight(), 20.0f, paint);
        canvas.drawText(String.valueOf(this.requestCount), canvas.getWidth() / 2.0f, canvas.getHeight() / 2.0f, paint);
        this.requestCount++;
    }
}
