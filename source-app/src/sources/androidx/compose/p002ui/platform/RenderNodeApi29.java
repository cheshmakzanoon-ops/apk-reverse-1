package androidx.compose.p002ui.platform;

import android.graphics.Matrix;
import android.graphics.Outline;
import android.graphics.RecordingCanvas;
import android.graphics.RenderNode;
import android.os.Build;
import androidx.activity.ComponentDialog$$ExternalSyntheticApiModelOutline0;
import androidx.compose.p002ui.graphics.AndroidCanvas;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.CanvasHolder;
import androidx.compose.p002ui.graphics.CompositingStrategy;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.RenderEffect;
import androidx.core.app.NotificationCompat$;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0088\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\b\u001d\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\b\u0010b\u001a\u00020cH\u0016J\u0010\u0010d\u001a\u00020c2\u0006\u0010e\u001a\u00020fH\u0016J\b\u0010g\u001a\u00020hH\u0016J\u0010\u0010i\u001a\u00020c2\u0006\u0010j\u001a\u00020kH\u0016J\u0010\u0010l\u001a\u00020c2\u0006\u0010j\u001a\u00020kH\u0016J\r\u0010m\u001a\u00020\u0017H\u0000¢\u0006\u0002\bnJ\r\u0010o\u001a\u00020\u0017H\u0000¢\u0006\u0002\bpJ\u0010\u0010q\u001a\u00020c2\u0006\u0010r\u001a\u00020\fH\u0016J\u0010\u0010s\u001a\u00020c2\u0006\u0010r\u001a\u00020\fH\u0016J.\u0010t\u001a\u00020c2\u0006\u0010u\u001a\u00020v2\b\u0010w\u001a\u0004\u0018\u00010x2\u0012\u0010y\u001a\u000e\u0012\u0004\u0012\u00020{\u0012\u0004\u0012\u00020c0zH\u0016J\u0010\u0010|\u001a\u00020\u00172\u0006\u0010m\u001a\u00020\u0017H\u0016J\u0012\u0010}\u001a\u00020c2\b\u0010~\u001a\u0004\u0018\u00010\u007fH\u0016J)\u0010\u0080\u0001\u001a\u00020\u00172\u0006\u0010/\u001a\u00020\f2\u0006\u0010T\u001a\u00020\f2\u0006\u0010@\u001a\u00020\f2\u0006\u0010\u0012\u001a\u00020\fH\u0016R$\u0010\u0007\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR$\u0010\r\u001a\u00020\f2\u0006\u0010\u0005\u001a\u00020\f8V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011R\u0014\u0010\u0012\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u000fR$\u0010\u0014\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u0015\u0010\t\"\u0004\b\u0016\u0010\u000bR$\u0010\u0018\u001a\u00020\u00172\u0006\u0010\u0005\u001a\u00020\u00178V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR$\u0010\u001d\u001a\u00020\u00172\u0006\u0010\u0005\u001a\u00020\u00178V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u001e\u0010\u001a\"\u0004\b\u001f\u0010\u001cR*\u0010!\u001a\u00020 2\u0006\u0010\u0005\u001a\u00020 8V@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b\"\u0010\u000f\"\u0004\b#\u0010\u0011R$\u0010$\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b%\u0010\t\"\u0004\b&\u0010\u000bR\u0014\u0010'\u001a\u00020\u00178VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b(\u0010\u001aR\u0014\u0010)\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b*\u0010\u000fR\u0016\u0010+\u001a\u00020 X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010,R\u0010\u0010-\u001a\u0004\u0018\u00010.X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010/\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b0\u0010\u000fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b1\u00102R$\u00103\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b4\u0010\t\"\u0004\b5\u0010\u000bR$\u00106\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b7\u0010\t\"\u0004\b8\u0010\u000bR(\u00109\u001a\u0004\u0018\u00010.2\b\u0010\u0005\u001a\u0004\u0018\u00010.8V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b:\u0010;\"\u0004\b<\u0010=R\u000e\u0010>\u001a\u00020?X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010@\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bA\u0010\u000fR$\u0010B\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bC\u0010\t\"\u0004\bD\u0010\u000bR$\u0010E\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bF\u0010\t\"\u0004\bG\u0010\u000bR$\u0010H\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bI\u0010\t\"\u0004\bJ\u0010\u000bR$\u0010K\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bL\u0010\t\"\u0004\bM\u0010\u000bR$\u0010N\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bO\u0010\t\"\u0004\bP\u0010\u000bR$\u0010Q\u001a\u00020\f2\u0006\u0010\u0005\u001a\u00020\f8V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bR\u0010\u000f\"\u0004\bS\u0010\u0011R\u0014\u0010T\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bU\u0010\u000fR$\u0010V\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bW\u0010\t\"\u0004\bX\u0010\u000bR$\u0010Y\u001a\u00020\u00062\u0006\u0010\u0005\u001a\u00020\u00068V@VX\u0096\u000e¢\u0006\f\u001a\u0004\bZ\u0010\t\"\u0004\b[\u0010\u000bR\u0014\u0010\\\u001a\u00020]8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b^\u0010_R\u0014\u0010`\u001a\u00020\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\ba\u0010\u000f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0081\u0001"}, d2 = {"Landroidx/compose/ui/platform/RenderNodeApi29;", "Landroidx/compose/ui/platform/DeviceRenderNode;", "ownerView", "Landroidx/compose/ui/platform/AndroidComposeView;", "(Landroidx/compose/ui/platform/AndroidComposeView;)V", "value", "", "alpha", "getAlpha", "()F", "setAlpha", "(F)V", "", "ambientShadowColor", "getAmbientShadowColor", "()I", "setAmbientShadowColor", "(I)V", "bottom", "getBottom", "cameraDistance", "getCameraDistance", "setCameraDistance", "", "clipToBounds", "getClipToBounds", "()Z", "setClipToBounds", "(Z)V", "clipToOutline", "getClipToOutline", "setClipToOutline", "Landroidx/compose/ui/graphics/CompositingStrategy;", "compositingStrategy", "getCompositingStrategy--NrFUSI", "setCompositingStrategy-aDBOjCE", "elevation", "getElevation", "setElevation", "hasDisplayList", "getHasDisplayList", "height", "getHeight", "internalCompositingStrategy", "I", "internalRenderEffect", "Landroidx/compose/ui/graphics/RenderEffect;", "left", "getLeft", "getOwnerView", "()Landroidx/compose/ui/platform/AndroidComposeView;", "pivotX", "getPivotX", "setPivotX", "pivotY", "getPivotY", "setPivotY", "renderEffect", "getRenderEffect", "()Landroidx/compose/ui/graphics/RenderEffect;", "setRenderEffect", "(Landroidx/compose/ui/graphics/RenderEffect;)V", "renderNode", "Landroid/graphics/RenderNode;", "right", "getRight", "rotationX", "getRotationX", "setRotationX", "rotationY", "getRotationY", "setRotationY", "rotationZ", "getRotationZ", "setRotationZ", "scaleX", "getScaleX", "setScaleX", "scaleY", "getScaleY", "setScaleY", "spotShadowColor", "getSpotShadowColor", "setSpotShadowColor", "top", "getTop", "translationX", "getTranslationX", "setTranslationX", "translationY", "getTranslationY", "setTranslationY", "uniqueId", "", "getUniqueId", "()J", "width", "getWidth", "discardDisplayList", "", "drawInto", "canvas", "Landroid/graphics/Canvas;", "dumpRenderNodeData", "Landroidx/compose/ui/platform/DeviceRenderNodeData;", "getInverseMatrix", "matrix", "Landroid/graphics/Matrix;", "getMatrix", "hasOverlappingRendering", "hasOverlappingRendering$ui_release", "isUsingCompositingLayer", "isUsingCompositingLayer$ui_release", "offsetLeftAndRight", "offset", "offsetTopAndBottom", "record", "canvasHolder", "Landroidx/compose/ui/graphics/CanvasHolder;", "clipPath", "Landroidx/compose/ui/graphics/Path;", "drawBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/Canvas;", "setHasOverlappingRendering", "setOutline", "outline", "Landroid/graphics/Outline;", "setPosition", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class RenderNodeApi29 implements DeviceRenderNode {
    public static final int $stable = 8;
    private RenderEffect internalRenderEffect;
    private final AndroidComposeView ownerView;
    private final RenderNode renderNode = ComponentDialog$$ExternalSyntheticApiModelOutline0.m13m("Compose");
    private int internalCompositingStrategy = CompositingStrategy.INSTANCE.m4679getAutoNrFUSI();

    public RenderNodeApi29(AndroidComposeView androidComposeView) {
        this.ownerView = androidComposeView;
    }

    public final AndroidComposeView getOwnerView() {
        return this.ownerView;
    }

    public final boolean isUsingCompositingLayer$ui_release() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$1(this.renderNode);
    }

    public final boolean hasOverlappingRendering$ui_release() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode);
    }

    @Override
    public long getUniqueId() {
        return this.renderNode.getUniqueId();
    }

    @Override
    public int getLeft() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$4(this.renderNode);
    }

    @Override
    public int getTop() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$5(this.renderNode);
    }

    @Override
    public int getRight() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$6(this.renderNode);
    }

    @Override
    public int getBottom() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$7(this.renderNode);
    }

    @Override
    public int getWidth() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode);
    }

    @Override
    public int getHeight() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$1(this.renderNode);
    }

    @Override
    public float getScaleX() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$1(this.renderNode);
    }

    @Override
    public void setScaleX(float f) {
        this.renderNode.setScaleX(f);
    }

    @Override
    public float getScaleY() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$2(this.renderNode);
    }

    @Override
    public void setScaleY(float f) {
        this.renderNode.setScaleY(f);
    }

    @Override
    public float getTranslationX() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$3(this.renderNode);
    }

    @Override
    public void setTranslationX(float f) {
        this.renderNode.setTranslationX(f);
    }

    @Override
    public float getTranslationY() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$4(this.renderNode);
    }

    @Override
    public void setTranslationY(float f) {
        this.renderNode.setTranslationY(f);
    }

    @Override
    public float getElevation() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$6(this.renderNode);
    }

    @Override
    public void setElevation(float f) {
        this.renderNode.setElevation(f);
    }

    @Override
    public int getAmbientShadowColor() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$2(this.renderNode);
    }

    @Override
    public void setAmbientShadowColor(int i) {
        this.renderNode.setAmbientShadowColor(i);
    }

    @Override
    public int getSpotShadowColor() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$3(this.renderNode);
    }

    @Override
    public void setSpotShadowColor(int i) {
        this.renderNode.setSpotShadowColor(i);
    }

    @Override
    public float getRotationZ() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$7(this.renderNode);
    }

    @Override
    public void setRotationZ(float f) {
        this.renderNode.setRotationZ(f);
    }

    @Override
    public float getRotationX() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$8(this.renderNode);
    }

    @Override
    public void setRotationX(float f) {
        this.renderNode.setRotationX(f);
    }

    @Override
    public float getRotationY() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$9(this.renderNode);
    }

    @Override
    public void setRotationY(float f) {
        this.renderNode.setRotationY(f);
    }

    @Override
    public float getCameraDistance() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode);
    }

    @Override
    public void setCameraDistance(float f) {
        this.renderNode.setCameraDistance(f);
    }

    @Override
    public float getPivotX() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$5(this.renderNode);
    }

    @Override
    public void setPivotX(float f) {
        this.renderNode.setPivotX(f);
    }

    @Override
    public float getPivotY() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$10(this.renderNode);
    }

    @Override
    public void setPivotY(float f) {
        this.renderNode.setPivotY(f);
    }

    @Override
    public boolean getClipToOutline() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$2(this.renderNode);
    }

    @Override
    public void setClipToOutline(boolean z) {
        this.renderNode.setClipToOutline(z);
    }

    @Override
    public boolean getClipToBounds() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$3(this.renderNode);
    }

    @Override
    public void setClipToBounds(boolean z) {
        this.renderNode.setClipToBounds(z);
    }

    @Override
    public float getAlpha() {
        return NotificationCompat$.ExternalSyntheticApiModelOutline0.m$11(this.renderNode);
    }

    @Override
    public void setAlpha(float f) {
        this.renderNode.setAlpha(f);
    }

    @Override
    public RenderEffect getInternalRenderEffect() {
        return this.internalRenderEffect;
    }

    @Override
    public void setRenderEffect(RenderEffect renderEffect) {
        this.internalRenderEffect = renderEffect;
        if (Build.VERSION.SDK_INT >= 31) {
            RenderNodeApi29VerificationHelper.INSTANCE.setRenderEffect(this.renderNode, renderEffect);
        }
    }

    @Override
    public int getInternalCompositingStrategy() {
        return this.internalCompositingStrategy;
    }

    @Override
    public void mo6528setCompositingStrategyaDBOjCE(int i) {
        RenderNode renderNode = this.renderNode;
        if (CompositingStrategy.m4675equalsimpl0(i, CompositingStrategy.INSTANCE.m4681getOffscreenNrFUSI())) {
            renderNode.setUseCompositingLayer(true, null);
            renderNode.setHasOverlappingRendering(true);
        } else if (CompositingStrategy.m4675equalsimpl0(i, CompositingStrategy.INSTANCE.m4680getModulateAlphaNrFUSI())) {
            renderNode.setUseCompositingLayer(false, null);
            renderNode.setHasOverlappingRendering(false);
        } else {
            renderNode.setUseCompositingLayer(false, null);
            renderNode.setHasOverlappingRendering(true);
        }
        this.internalCompositingStrategy = i;
    }

    @Override
    public boolean getHasDisplayList() {
        return this.renderNode.hasDisplayList();
    }

    @Override
    public void setOutline(Outline outline) {
        this.renderNode.setOutline(outline);
    }

    @Override
    public boolean setPosition(int left, int top, int right, int bottom) {
        return this.renderNode.setPosition(left, top, right, bottom);
    }

    @Override
    public void offsetLeftAndRight(int offset) {
        NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode, offset);
    }

    @Override
    public void offsetTopAndBottom(int offset) {
        NotificationCompat$.ExternalSyntheticApiModelOutline0.m$1(this.renderNode, offset);
    }

    @Override
    public void record(CanvasHolder canvasHolder, Path clipPath, Function1<? super Canvas, Unit> drawBlock) {
        RecordingCanvas recordingCanvasBeginRecording = this.renderNode.beginRecording();
        android.graphics.Canvas internalCanvas = canvasHolder.getAndroidCanvas().getInternalCanvas();
        canvasHolder.getAndroidCanvas().setInternalCanvas(recordingCanvasBeginRecording);
        AndroidCanvas androidCanvas = canvasHolder.getAndroidCanvas();
        if (clipPath != null) {
            androidCanvas.save();
            Canvas.CC.m4562clipPathmtrdDE$default(androidCanvas, clipPath, 0, 2, null);
        }
        drawBlock.invoke(androidCanvas);
        if (clipPath != null) {
            androidCanvas.restore();
        }
        canvasHolder.getAndroidCanvas().setInternalCanvas(internalCanvas);
        this.renderNode.endRecording();
    }

    @Override
    public void getMatrix(Matrix matrix) {
        this.renderNode.getMatrix(matrix);
    }

    @Override
    public void getInverseMatrix(Matrix matrix) {
        NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode, matrix);
    }

    @Override
    public void drawInto(android.graphics.Canvas canvas) {
        canvas.drawRenderNode(this.renderNode);
    }

    @Override
    public boolean setHasOverlappingRendering(boolean hasOverlappingRendering) {
        return this.renderNode.setHasOverlappingRendering(hasOverlappingRendering);
    }

    @Override
    public DeviceRenderNodeData dumpRenderNodeData() {
        return new DeviceRenderNodeData(this.renderNode.getUniqueId(), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$4(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$5(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$6(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$7(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$1(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$1(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$2(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$3(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$4(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$6(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$2(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$3(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$7(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$8(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$9(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$5(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$10(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$2(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$3(this.renderNode), NotificationCompat$.ExternalSyntheticApiModelOutline0.m$11(this.renderNode), this.internalRenderEffect, this.internalCompositingStrategy, null);
    }

    @Override
    public void discardDisplayList() {
        this.renderNode.discardDisplayList();
    }
}
