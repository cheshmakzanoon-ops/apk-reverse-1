package androidx.compose.p002ui.platform;

import android.os.Build;
import androidx.autofill.HintConstants;
import androidx.compose.p002ui.geometry.MutableRect;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.p002ui.graphics.AndroidPaint_androidKt;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.CompositingStrategy;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.graphics.Matrix;
import androidx.compose.p002ui.graphics.Outline;
import androidx.compose.p002ui.graphics.Paint;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.ReusableGraphicsLayerScope;
import androidx.compose.p002ui.graphics.TransformOrigin;
import androidx.compose.p002ui.graphics.drawscope.CanvasDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.graphics.layer.GraphicsLayerKt;
import androidx.compose.p002ui.layout.GraphicLayerInfo;
import androidx.compose.p002ui.node.OwnedLayer;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DensityKt;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000À\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002Bg\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u00128\u0010\t\u001a4\u0012\u0013\u0012\u00110\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\u0015\u0012\u0013\u0018\u00010\u0004¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000f\u0012\u0004\u0012\u00020\u00100\n\u0012\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00100\u0012¢\u0006\u0002\u0010\u0013J\u0010\u0010<\u001a\u00020\u00102\u0006\u0010\u000e\u001a\u00020\u000bH\u0002J\b\u0010=\u001a\u00020\u0010H\u0016J\u001a\u0010>\u001a\u00020\u00102\u0006\u0010\u000e\u001a\u00020\u000b2\b\u0010\u000f\u001a\u0004\u0018\u00010\u0004H\u0016J\u0017\u0010?\u001a\u0004\u0018\u00010\u0019H\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b@\u0010AJ\u0015\u0010B\u001a\u00020\u0019H\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bC\u0010AJ\b\u0010D\u001a\u00020\u0010H\u0016J\u001a\u0010E\u001a\u00020\u00102\u0006\u0010F\u001a\u00020\u0019H\u0016ø\u0001\u0000¢\u0006\u0004\bG\u0010HJ\u001a\u0010I\u001a\u00020\u00172\u0006\u0010J\u001a\u00020KH\u0016ø\u0001\u0000¢\u0006\u0004\bL\u0010MJ\u0018\u0010N\u001a\u00020\u00102\u0006\u0010O\u001a\u00020P2\u0006\u0010Q\u001a\u00020\u0017H\u0016J\"\u0010R\u001a\u00020K2\u0006\u0010S\u001a\u00020K2\u0006\u0010Q\u001a\u00020\u0017H\u0016ø\u0001\u0000¢\u0006\u0004\bT\u0010UJ\u001a\u0010V\u001a\u00020\u00102\u0006\u0010J\u001a\u00020WH\u0016ø\u0001\u0000¢\u0006\u0004\bX\u0010YJ\u001a\u0010Z\u001a\u00020\u00102\u0006\u00103\u001a\u000204H\u0016ø\u0001\u0000¢\u0006\u0004\b[\u0010YJP\u0010\\\u001a\u00020\u001028\u0010\t\u001a4\u0012\u0013\u0012\u00110\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\u0015\u0012\u0013\u0018\u00010\u0004¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000f\u0012\u0004\u0012\u00020\u00100\n2\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00100\u0012H\u0016J\u001a\u0010]\u001a\u00020\u00102\u0006\u0010F\u001a\u00020\u0019H\u0016ø\u0001\u0000¢\u0006\u0004\b^\u0010HJ\b\u0010_\u001a\u00020\u0010H\u0002J\b\u0010`\u001a\u00020\u0010H\u0016J\u0010\u0010a\u001a\u00020\u00102\u0006\u00101\u001a\u00020bH\u0016J\b\u0010c\u001a\u00020\u0010H\u0002J\b\u0010d\u001a\u00020\u0010H\u0002R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u000e¢\u0006\u0002\n\u0000RB\u0010\t\u001a6\u0012\u0013\u0012\u00110\u000b¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000e\u0012\u0015\u0012\u0013\u0018\u00010\u0004¢\u0006\f\b\f\u0012\b\b\r\u0012\u0004\b\b(\u000f\u0012\u0004\u0012\u00020\u0010\u0018\u00010\nX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0017X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0010\u0018\u00010\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010\u0018\u001a\u0004\u0018\u00010\u0019X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u001aR\u000e\u0010\u001b\u001a\u00020\u0017X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010\u001d\u001a\u00020\u00172\u0006\u0010\u001c\u001a\u00020\u0017@BX\u0082\u000e¢\u0006\b\n\u0000\"\u0004\b\u001e\u0010\u001fR\u0014\u0010 \u001a\u00020!8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\"\u0010#R\u000e\u0010$\u001a\u00020%X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010&\u001a\u00020\u0019X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u001aR\u000e\u0010'\u001a\u00020(X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010)\u001a\u0004\u0018\u00010*X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010+\u001a\u00020!8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b,\u0010#R\u001f\u0010-\u001a\u0013\u0012\u0004\u0012\u00020/\u0012\u0004\u0012\u00020\u00100.¢\u0006\u0002\b0X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u00101\u001a\u000202X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u00103\u001a\u000204X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u00105R\u0010\u00106\u001a\u0004\u0018\u000107X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u00108\u001a\u0004\u0018\u000109X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010:\u001a\u00020;X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u00105\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006e"}, d2 = {"Landroidx/compose/ui/platform/GraphicsLayerOwnerLayer;", "Landroidx/compose/ui/node/OwnedLayer;", "Landroidx/compose/ui/layout/GraphicLayerInfo;", "graphicsLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "context", "Landroidx/compose/ui/graphics/GraphicsContext;", "ownerView", "Landroidx/compose/ui/platform/AndroidComposeView;", "drawBlock", "Lkotlin/Function2;", "Landroidx/compose/ui/graphics/Canvas;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "canvas", "parentLayer", "", "invalidateParentLayer", "Lkotlin/Function0;", "(Landroidx/compose/ui/graphics/layer/GraphicsLayer;Landroidx/compose/ui/graphics/GraphicsContext;Landroidx/compose/ui/platform/AndroidComposeView;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function0;)V", "density", "Landroidx/compose/ui/unit/Density;", "drawnWithEnabledZ", "", "inverseMatrixCache", "Landroidx/compose/ui/graphics/Matrix;", "[F", "isDestroyed", "value", "isDirty", "setDirty", "(Z)V", "layerId", "", "getLayerId", "()J", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "matrixCache", "mutatedFields", "", "outline", "Landroidx/compose/ui/graphics/Outline;", "ownerViewId", "getOwnerViewId", "recordLambda", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "Lkotlin/ExtensionFunctionType;", "scope", "Landroidx/compose/ui/graphics/drawscope/CanvasDrawScope;", "size", "Landroidx/compose/ui/unit/IntSize;", "J", "softwareLayerPaint", "Landroidx/compose/ui/graphics/Paint;", "tmpPath", "Landroidx/compose/ui/graphics/Path;", "transformOrigin", "Landroidx/compose/ui/graphics/TransformOrigin;", "clipManually", "destroy", "drawLayer", "getInverseMatrix", "getInverseMatrix-3i98HWw", "()[F", "getMatrix", "getMatrix-sQKQjiQ", "invalidate", "inverseTransform", "matrix", "inverseTransform-58bKbWc", "([F)V", "isInLayer", "position", "Landroidx/compose/ui/geometry/Offset;", "isInLayer-k-4lQ0M", "(J)Z", "mapBounds", "rect", "Landroidx/compose/ui/geometry/MutableRect;", "inverse", "mapOffset", "point", "mapOffset-8S9VItk", "(JZ)J", "move", "Landroidx/compose/ui/unit/IntOffset;", "move--gyyYBs", "(J)V", "resize", "resize-ozmzZPI", "reuseLayer", "transform", "transform-58bKbWc", "triggerRepaint", "updateDisplayList", "updateLayerProperties", "Landroidx/compose/ui/graphics/ReusableGraphicsLayerScope;", "updateMatrix", "updateOutline", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class GraphicsLayerOwnerLayer implements OwnedLayer, GraphicLayerInfo {
    public static final int $stable = 8;
    private final GraphicsContext context;
    private Function2<? super Canvas, ? super GraphicsLayer, Unit> drawBlock;
    private boolean drawnWithEnabledZ;
    private GraphicsLayer graphicsLayer;
    private Function0<Unit> invalidateParentLayer;
    private float[] inverseMatrixCache;
    private boolean isDestroyed;
    private boolean isDirty;
    private int mutatedFields;
    private Outline outline;
    private final AndroidComposeView ownerView;
    private Paint softwareLayerPaint;
    private Path tmpPath;
    private long size = IntSizeKt.IntSize(Integer.MAX_VALUE, Integer.MAX_VALUE);
    private final float[] matrixCache = Matrix.m4828constructorimpl$default(null, 1, null);
    private Density density = DensityKt.Density$default(1.0f, 0.0f, 2, (Object) null);
    private LayoutDirection layoutDirection = LayoutDirection.Ltr;
    private final CanvasDrawScope scope = new CanvasDrawScope();
    private long transformOrigin = TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ();
    private final Function1<DrawScope, Unit> recordLambda = new Function1<DrawScope, Unit>() {
        {
            super(1);
        }

        public Object invoke(Object obj) {
            invoke((DrawScope) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(DrawScope drawScope) {
            GraphicsLayerOwnerLayer graphicsLayerOwnerLayer = this.this$0;
            Canvas canvas = drawScope.getDrawContext().getCanvas();
            Function2 function2 = graphicsLayerOwnerLayer.drawBlock;
            if (function2 != null) {
                function2.invoke(canvas, drawScope.getDrawContext().getGraphicsLayer());
            }
        }
    };

    public GraphicsLayerOwnerLayer(GraphicsLayer graphicsLayer, GraphicsContext graphicsContext, AndroidComposeView androidComposeView, Function2<? super Canvas, ? super GraphicsLayer, Unit> function2, Function0<Unit> function0) {
        this.graphicsLayer = graphicsLayer;
        this.context = graphicsContext;
        this.ownerView = androidComposeView;
        this.drawBlock = function2;
        this.invalidateParentLayer = function0;
    }

    private final void setDirty(boolean z) {
        if (z != this.isDirty) {
            this.isDirty = z;
            this.ownerView.notifyLayerIsDirty$ui_release(this, z);
        }
    }

    @Override
    public void updateLayerProperties(ReusableGraphicsLayerScope scope) {
        boolean z;
        int iM5264getModulateAlphake2Ky5w;
        Function0<Unit> function0;
        int mutatedFields = scope.getMutatedFields() | this.mutatedFields;
        this.layoutDirection = scope.getLayoutDirection();
        this.density = scope.getGraphicsDensity();
        int i = mutatedFields & Fields.TransformOrigin;
        if (i != 0) {
            this.transformOrigin = scope.getTransformOrigin();
        }
        if ((mutatedFields & 1) != 0) {
            this.graphicsLayer.setScaleX(scope.getScaleX());
        }
        if ((mutatedFields & 2) != 0) {
            this.graphicsLayer.setScaleY(scope.getScaleY());
        }
        if ((mutatedFields & 4) != 0) {
            this.graphicsLayer.setAlpha(scope.getAlpha());
        }
        if ((mutatedFields & 8) != 0) {
            this.graphicsLayer.setTranslationX(scope.getTranslationX());
        }
        if ((mutatedFields & 16) != 0) {
            this.graphicsLayer.setTranslationY(scope.getTranslationY());
        }
        if ((mutatedFields & 32) != 0) {
            this.graphicsLayer.setShadowElevation(scope.getShadowElevation());
            if (scope.getShadowElevation() > 0.0f && !this.drawnWithEnabledZ && (function0 = this.invalidateParentLayer) != null) {
                function0.invoke();
            }
        }
        if ((mutatedFields & 64) != 0) {
            this.graphicsLayer.m5278setAmbientShadowColor8_81llA(scope.getAmbientShadowColor());
        }
        if ((mutatedFields & Fields.SpotShadowColor) != 0) {
            this.graphicsLayer.m5284setSpotShadowColor8_81llA(scope.getSpotShadowColor());
        }
        if ((mutatedFields & Fields.RotationZ) != 0) {
            this.graphicsLayer.setRotationZ(scope.getRotationZ());
        }
        if ((mutatedFields & Fields.RotationX) != 0) {
            this.graphicsLayer.setRotationX(scope.getRotationX());
        }
        if ((mutatedFields & Fields.RotationY) != 0) {
            this.graphicsLayer.setRotationY(scope.getRotationY());
        }
        if ((mutatedFields & Fields.CameraDistance) != 0) {
            this.graphicsLayer.setCameraDistance(scope.getCameraDistance());
        }
        if (i != 0) {
            if (TransformOrigin.m4995equalsimpl0(this.transformOrigin, TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ())) {
                this.graphicsLayer.m5281setPivotOffsetk4lQ0M(Offset.INSTANCE.m4361getUnspecifiedF1C5BW0());
            } else {
                this.graphicsLayer.m5281setPivotOffsetk4lQ0M(OffsetKt.Offset(TransformOrigin.m4996getPivotFractionXimpl(this.transformOrigin) * IntSize.getWidth-impl(this.size), TransformOrigin.m4997getPivotFractionYimpl(this.transformOrigin) * IntSize.getHeight-impl(this.size)));
            }
        }
        if ((mutatedFields & Fields.Clip) != 0) {
            this.graphicsLayer.setClip(scope.getClip());
        }
        if ((131072 & mutatedFields) != 0) {
            this.graphicsLayer.setRenderEffect(scope.getRenderEffect());
        }
        if ((32768 & mutatedFields) != 0) {
            GraphicsLayer graphicsLayer = this.graphicsLayer;
            int compositingStrategy = scope.getCompositingStrategy();
            if (CompositingStrategy.m4675equalsimpl0(compositingStrategy, CompositingStrategy.INSTANCE.m4679getAutoNrFUSI())) {
                iM5264getModulateAlphake2Ky5w = androidx.compose.p002ui.graphics.layer.CompositingStrategy.INSTANCE.m5263getAutoke2Ky5w();
            } else if (CompositingStrategy.m4675equalsimpl0(compositingStrategy, CompositingStrategy.INSTANCE.m4681getOffscreenNrFUSI())) {
                iM5264getModulateAlphake2Ky5w = androidx.compose.p002ui.graphics.layer.CompositingStrategy.INSTANCE.m5265getOffscreenke2Ky5w();
            } else {
                if (!CompositingStrategy.m4675equalsimpl0(compositingStrategy, CompositingStrategy.INSTANCE.m4680getModulateAlphaNrFUSI())) {
                    throw new IllegalStateException("Not supported composition strategy");
                }
                iM5264getModulateAlphake2Ky5w = androidx.compose.p002ui.graphics.layer.CompositingStrategy.INSTANCE.m5264getModulateAlphake2Ky5w();
            }
            graphicsLayer.m5280setCompositingStrategyWpw9cng(iM5264getModulateAlphake2Ky5w);
        }
        if (Intrinsics.areEqual(this.outline, scope.getOutline())) {
            z = false;
        } else {
            this.outline = scope.getOutline();
            updateOutline();
            z = true;
        }
        this.mutatedFields = scope.getMutatedFields();
        if (mutatedFields != 0 || z) {
            triggerRepaint();
        }
    }

    private final void triggerRepaint() {
        if (Build.VERSION.SDK_INT >= 26) {
            WrapperRenderNodeLayerHelperMethods.INSTANCE.onDescendantInvalidated(this.ownerView);
        } else {
            this.ownerView.invalidate();
        }
    }

    private final void updateOutline() {
        Function0<Unit> function0;
        Outline outline = this.outline;
        if (outline == null) {
            return;
        }
        GraphicsLayerKt.setOutline(this.graphicsLayer, outline);
        if (!(outline instanceof Outline.Generic) || Build.VERSION.SDK_INT >= 33 || (function0 = this.invalidateParentLayer) == null) {
            return;
        }
        function0.invoke();
    }

    @Override
    public boolean mo6415isInLayerk4lQ0M(long position) {
        float fM4346getXimpl = Offset.m4346getXimpl(position);
        float fM4347getYimpl = Offset.m4347getYimpl(position);
        if (this.graphicsLayer.getClip()) {
            return ShapeContainingUtilKt.isInOutline$default(this.graphicsLayer.getOutline(), fM4346getXimpl, fM4347getYimpl, null, null, 24, null);
        }
        return true;
    }

    @Override
    public void mo6417movegyyYBs(long position) {
        this.graphicsLayer.m5285setTopLeftgyyYBs(position);
        triggerRepaint();
    }

    @Override
    public void mo6418resizeozmzZPI(long size) {
        if (IntSize.equals-impl0(size, this.size)) {
            return;
        }
        this.size = size;
        invalidate();
    }

    @Override
    public void drawLayer(Canvas canvas, GraphicsLayer parentLayer) {
        android.graphics.Canvas nativeCanvas = AndroidCanvas_androidKt.getNativeCanvas(canvas);
        if (nativeCanvas.isHardwareAccelerated()) {
            updateDisplayList();
            this.drawnWithEnabledZ = this.graphicsLayer.getShadowElevation() > 0.0f;
            DrawContext drawContext = this.scope.getDrawContext();
            drawContext.setCanvas(canvas);
            drawContext.setGraphicsLayer(parentLayer);
            GraphicsLayerKt.drawLayer(this.scope, this.graphicsLayer);
            return;
        }
        float f = IntOffset.getX-impl(this.graphicsLayer.getTopLeft());
        float f2 = IntOffset.getY-impl(this.graphicsLayer.getTopLeft());
        float f3 = f + IntSize.getWidth-impl(this.size);
        float f4 = f2 + IntSize.getHeight-impl(this.size);
        if (this.graphicsLayer.getAlpha() < 1.0f) {
            Paint Paint = this.softwareLayerPaint;
            if (Paint == null) {
                Paint = AndroidPaint_androidKt.Paint();
                this.softwareLayerPaint = Paint;
            }
            Paint.setAlpha(this.graphicsLayer.getAlpha());
            nativeCanvas.saveLayer(f, f2, f3, f4, Paint.getInternalPaint());
        } else {
            canvas.save();
        }
        canvas.translate(f, f2);
        canvas.mo4443concat58bKbWc(m6544getMatrixsQKQjiQ());
        if (this.graphicsLayer.getClip()) {
            clipManually(canvas);
        }
        Function2<? super Canvas, ? super GraphicsLayer, Unit> function2 = this.drawBlock;
        if (function2 != null) {
            function2.invoke(canvas, (Object) null);
        }
        canvas.restore();
    }

    @Override
    public void updateDisplayList() {
        if (this.isDirty) {
            if (!TransformOrigin.m4995equalsimpl0(this.transformOrigin, TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ()) && !IntSize.equals-impl0(this.graphicsLayer.getSize(), this.size)) {
                this.graphicsLayer.m5281setPivotOffsetk4lQ0M(OffsetKt.Offset(TransformOrigin.m4996getPivotFractionXimpl(this.transformOrigin) * IntSize.getWidth-impl(this.size), TransformOrigin.m4997getPivotFractionYimpl(this.transformOrigin) * IntSize.getHeight-impl(this.size)));
            }
            this.graphicsLayer.m5277recordmLhObY(this.density, this.layoutDirection, this.size, this.recordLambda);
            setDirty(false);
        }
    }

    @Override
    public void invalidate() {
        if (this.isDirty || this.isDestroyed) {
            return;
        }
        this.ownerView.invalidate();
        setDirty(true);
    }

    @Override
    public void destroy() {
        this.drawBlock = null;
        this.invalidateParentLayer = null;
        this.isDestroyed = true;
        setDirty(false);
        GraphicsContext graphicsContext = this.context;
        if (graphicsContext != null) {
            graphicsContext.releaseGraphicsLayer(this.graphicsLayer);
            this.ownerView.recycle$ui_release(this);
        }
    }

    @Override
    public long mo6416mapOffset8S9VItk(long point, boolean inverse) {
        if (inverse) {
            float[] fArrM6543getInverseMatrix3i98HWw = m6543getInverseMatrix3i98HWw();
            return fArrM6543getInverseMatrix3i98HWw != null ? Matrix.m4834mapMKHz9U(fArrM6543getInverseMatrix3i98HWw, point) : Offset.INSTANCE.m4360getInfiniteF1C5BW0();
        }
        return Matrix.m4834mapMKHz9U(m6544getMatrixsQKQjiQ(), point);
    }

    @Override
    public void mapBounds(MutableRect rect, boolean inverse) {
        if (inverse) {
            float[] fArrM6543getInverseMatrix3i98HWw = m6543getInverseMatrix3i98HWw();
            if (fArrM6543getInverseMatrix3i98HWw == null) {
                rect.set(0.0f, 0.0f, 0.0f, 0.0f);
                return;
            } else {
                Matrix.m4836mapimpl(fArrM6543getInverseMatrix3i98HWw, rect);
                return;
            }
        }
        Matrix.m4836mapimpl(m6544getMatrixsQKQjiQ(), rect);
    }

    @Override
    public void reuseLayer(Function2<? super Canvas, ? super GraphicsLayer, Unit> drawBlock, Function0<Unit> invalidateParentLayer) {
        GraphicsContext graphicsContext = this.context;
        if (graphicsContext == null) {
            throw new IllegalArgumentException("currently reuse is only supported when we manage the layer lifecycle".toString());
        }
        if (!this.graphicsLayer.getIsReleased()) {
            throw new IllegalArgumentException("layer should have been released before reuse".toString());
        }
        this.graphicsLayer = graphicsContext.createGraphicsLayer();
        this.isDestroyed = false;
        this.drawBlock = drawBlock;
        this.invalidateParentLayer = invalidateParentLayer;
        this.transformOrigin = TransformOrigin.INSTANCE.m5001getCenterSzJe1aQ();
        this.drawnWithEnabledZ = false;
        this.size = IntSizeKt.IntSize(Integer.MAX_VALUE, Integer.MAX_VALUE);
        this.outline = null;
        this.mutatedFields = 0;
    }

    @Override
    public void mo6419transform58bKbWc(float[] matrix) {
        Matrix.m4845timesAssign58bKbWc(matrix, m6544getMatrixsQKQjiQ());
    }

    @Override
    public void mo6414inverseTransform58bKbWc(float[] matrix) {
        float[] fArrM6543getInverseMatrix3i98HWw = m6543getInverseMatrix3i98HWw();
        if (fArrM6543getInverseMatrix3i98HWw != null) {
            Matrix.m4845timesAssign58bKbWc(matrix, fArrM6543getInverseMatrix3i98HWw);
        }
    }

    @Override
    public long getLayerId() {
        return this.graphicsLayer.getLayerId();
    }

    @Override
    public long getOwnerViewId() {
        return this.graphicsLayer.getOwnerViewId();
    }

    private final float[] m6544getMatrixsQKQjiQ() {
        updateMatrix();
        return this.matrixCache;
    }

    private final float[] m6543getInverseMatrix3i98HWw() {
        float[] fArrM6544getMatrixsQKQjiQ = m6544getMatrixsQKQjiQ();
        float[] fArrM4828constructorimpl$default = this.inverseMatrixCache;
        if (fArrM4828constructorimpl$default == null) {
            fArrM4828constructorimpl$default = Matrix.m4828constructorimpl$default(null, 1, null);
            this.inverseMatrixCache = fArrM4828constructorimpl$default;
        }
        if (InvertMatrixKt.m6546invertToJiSxe2E(fArrM6544getMatrixsQKQjiQ, fArrM4828constructorimpl$default)) {
            return fArrM4828constructorimpl$default;
        }
        return null;
    }

    private final void updateMatrix() {
        long pivotOffset;
        GraphicsLayer graphicsLayer = this.graphicsLayer;
        if (OffsetKt.m4367isUnspecifiedk4lQ0M(graphicsLayer.getPivotOffset())) {
            pivotOffset = SizeKt.m4425getCenteruvyYCjk(IntSizeKt.toSize-ozmzZPI(this.size));
        } else {
            pivotOffset = graphicsLayer.getPivotOffset();
        }
        Matrix.m4837resetimpl(this.matrixCache);
        float[] fArr = this.matrixCache;
        float[] fArrM4828constructorimpl$default = Matrix.m4828constructorimpl$default(null, 1, null);
        Matrix.m4848translateimpl$default(fArrM4828constructorimpl$default, -Offset.m4346getXimpl(pivotOffset), -Offset.m4347getYimpl(pivotOffset), 0.0f, 4, null);
        Matrix.m4845timesAssign58bKbWc(fArr, fArrM4828constructorimpl$default);
        float[] fArr2 = this.matrixCache;
        float[] fArrM4828constructorimpl$default2 = Matrix.m4828constructorimpl$default(null, 1, null);
        Matrix.m4848translateimpl$default(fArrM4828constructorimpl$default2, graphicsLayer.getTranslationX(), graphicsLayer.getTranslationY(), 0.0f, 4, null);
        Matrix.m4838rotateXimpl(fArrM4828constructorimpl$default2, graphicsLayer.getRotationX());
        Matrix.m4839rotateYimpl(fArrM4828constructorimpl$default2, graphicsLayer.getRotationY());
        Matrix.m4840rotateZimpl(fArrM4828constructorimpl$default2, graphicsLayer.getRotationZ());
        Matrix.m4842scaleimpl$default(fArrM4828constructorimpl$default2, graphicsLayer.getScaleX(), graphicsLayer.getScaleY(), 0.0f, 4, null);
        Matrix.m4845timesAssign58bKbWc(fArr2, fArrM4828constructorimpl$default2);
        float[] fArr3 = this.matrixCache;
        float[] fArrM4828constructorimpl$default3 = Matrix.m4828constructorimpl$default(null, 1, null);
        Matrix.m4848translateimpl$default(fArrM4828constructorimpl$default3, Offset.m4346getXimpl(pivotOffset), Offset.m4347getYimpl(pivotOffset), 0.0f, 4, null);
        Matrix.m4845timesAssign58bKbWc(fArr3, fArrM4828constructorimpl$default3);
    }

    private final void clipManually(Canvas canvas) {
        if (this.graphicsLayer.getClip()) {
            Outline outline = this.graphicsLayer.getOutline();
            if (outline instanceof Outline.Rectangle) {
                Canvas.CC.m4564clipRectmtrdDE$default(canvas, ((Outline.Rectangle) outline).getRect(), 0, 2, null);
                return;
            }
            if (outline instanceof Outline.Rounded) {
                Path Path = this.tmpPath;
                if (Path == null) {
                    Path = AndroidPath_androidKt.Path();
                    this.tmpPath = Path;
                }
                Path.reset();
                Path.CC.addRoundRect$default(Path, ((Outline.Rounded) outline).getRoundRect(), null, 2, null);
                Canvas.CC.m4562clipPathmtrdDE$default(canvas, Path, 0, 2, null);
                return;
            }
            if (outline instanceof Outline.Generic) {
                Canvas.CC.m4562clipPathmtrdDE$default(canvas, ((Outline.Generic) outline).getPath(), 0, 2, null);
            }
        }
    }
}
