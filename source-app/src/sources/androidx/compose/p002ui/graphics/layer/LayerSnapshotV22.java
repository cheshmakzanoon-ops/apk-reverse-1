package androidx.compose.p002ui.graphics.layer;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.PorterDuff;
import android.media.Image;
import android.media.ImageReader;
import android.os.Looper;
import android.view.Surface;
import androidx.compose.p002ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.ui.unit.IntSize;
import androidx.core.os.HandlerCompat;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.jdk7.AutoCloseableKt;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÁ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0016\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0096@¢\u0006\u0002\u0010\u0007¨\u0006\b"}, d2 = {"Landroidx/compose/ui/graphics/layer/LayerSnapshotV22;", "Landroidx/compose/ui/graphics/layer/LayerSnapshotImpl;", "()V", "toBitmap", "Landroid/graphics/Bitmap;", "graphicsLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "(Landroidx/compose/ui/graphics/layer/GraphicsLayer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LayerSnapshotV22 implements LayerSnapshotImpl {
    public static final LayerSnapshotV22 INSTANCE = new LayerSnapshotV22();

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.ui.graphics.layer.LayerSnapshotV22", f = "LayerSnapshot.android.kt", i = {0, 0, 0, 0}, l = {231}, m = "toBitmap", n = {"graphicsLayer", "looper", "reader", "$completion$iv"}, s = {"L$0", "L$1", "L$3", "L$4"})
    static final class C16211 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        int label;
        Object result;

        C16211(Continuation<? super C16211> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return LayerSnapshotV22.this.toBitmap(null, (Continuation) this);
        }
    }

    private LayerSnapshotV22() {
    }

    @Override
    public Object toBitmap(GraphicsLayer graphicsLayer, Continuation<? super Bitmap> continuation) {
        C16211 c16211;
        AutoCloseable autoCloseable;
        if (continuation instanceof C16211) {
            c16211 = (C16211) continuation;
            if ((c16211.label & Integer.MIN_VALUE) != 0) {
                c16211.label -= Integer.MIN_VALUE;
            } else {
                c16211 = new C16211(continuation);
            }
        } else {
            c16211 = new C16211(continuation);
        }
        Object result = c16211.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c16211.label;
        if (i == 0) {
            ResultKt.throwOnFailure(result);
            long size = graphicsLayer.getSize();
            Looper looperMyLooper = Looper.myLooper();
            if (looperMyLooper == null) {
                looperMyLooper = Looper.getMainLooper();
            }
            ImageReader imageReaderNewInstance = ImageReader.newInstance(IntSize.getWidth-impl(size), IntSize.getHeight-impl(size), 1, 1);
            try {
                ImageReader imageReader = imageReaderNewInstance;
                c16211.L$0 = graphicsLayer;
                c16211.L$1 = looperMyLooper;
                c16211.L$2 = imageReaderNewInstance;
                c16211.L$3 = imageReader;
                c16211.L$4 = c16211;
                c16211.label = 1;
                CancellableContinuation cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted((Continuation) c16211), 1);
                cancellableContinuationImpl.initCancellability();
                final CancellableContinuation cancellableContinuation = cancellableContinuationImpl;
                imageReader.setOnImageAvailableListener(new ImageReader.OnImageAvailableListener() {
                    @Override
                    public final void onImageAvailable(ImageReader imageReader2) {
                        Continuation continuation2 = cancellableContinuation;
                        Result.Companion companion = Result.Companion;
                        continuation2.resumeWith(Result.constructor-impl(imageReader2.acquireLatestImage()));
                    }
                }, HandlerCompat.createAsync(looperMyLooper));
                Surface surface = imageReader.getSurface();
                Canvas canvasLockCanvas = SurfaceUtils.INSTANCE.lockCanvas(surface);
                try {
                    canvasLockCanvas.drawColor(ColorKt.m4644toArgb8_81llA(Color.INSTANCE.m4616getBlack0d7_KjU()), PorterDuff.Mode.CLEAR);
                    graphicsLayer.draw$ui_graphics_release(AndroidCanvas_androidKt.Canvas(canvasLockCanvas), null);
                    surface.unlockCanvasAndPost(canvasLockCanvas);
                    result = cancellableContinuationImpl.getResult();
                    if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
                        DebugProbesKt.probeCoroutineSuspended((Continuation) c16211);
                    }
                    if (result == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    autoCloseable = imageReaderNewInstance;
                } catch (Throwable th) {
                    surface.unlockCanvasAndPost(canvasLockCanvas);
                    throw th;
                }
            } catch (Throwable th2) {
                th = th2;
                autoCloseable = imageReaderNewInstance;
                throw th;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            autoCloseable = (AutoCloseable) c16211.L$2;
            try {
                ResultKt.throwOnFailure(result);
            } catch (Throwable th3) {
                th = th3;
                try {
                    throw th;
                } catch (Throwable th4) {
                    AutoCloseableKt.closeFinally(autoCloseable, th);
                    throw th4;
                }
            }
        }
        Bitmap bitmap = LayerSnapshot_androidKt.toBitmap((Image) result);
        AutoCloseableKt.closeFinally(autoCloseable, (Throwable) null);
        return bitmap;
    }
}
