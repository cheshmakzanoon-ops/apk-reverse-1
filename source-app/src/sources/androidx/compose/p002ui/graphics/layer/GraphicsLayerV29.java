package androidx.compose.p002ui.graphics.layer;

import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Outline;
import android.graphics.Paint;
import android.graphics.RecordingCanvas;
import android.graphics.RenderNode;
import android.os.Build;
import androidx.activity.ComponentDialog$$ExternalSyntheticApiModelOutline0;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.AndroidBlendMode_androidKt;
import androidx.compose.p002ui.graphics.AndroidCanvas;
import androidx.compose.p002ui.graphics.AndroidCanvas_androidKt;
import androidx.compose.p002ui.graphics.AndroidColorFilter_androidKt;
import androidx.compose.p002ui.graphics.BlendMode;
import androidx.compose.p002ui.graphics.CanvasHolder;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.ColorKt;
import androidx.compose.p002ui.graphics.RenderEffect;
import androidx.compose.p002ui.graphics.drawscope.CanvasDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000Ä\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\b\b\u0001\u0018\u00002\u00020\u0001B!\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\b\u0010h\u001a\u00020iH\u0002J\b\u0010j\u001a\u00020<H\u0016J\b\u0010k\u001a\u00020iH\u0016J\u0010\u0010l\u001a\u00020i2\u0006\u0010m\u001a\u00020nH\u0016J\b\u0010o\u001a\u00020:H\u0002J9\u0010p\u001a\u00020i2\u0006\u0010q\u001a\u00020r2\u0006\u0010s\u001a\u00020t2\u0006\u0010u\u001a\u00020v2\u0017\u0010w\u001a\u0013\u0012\u0004\u0012\u00020y\u0012\u0004\u0012\u00020i0x¢\u0006\u0002\bzH\u0016J\b\u0010{\u001a\u00020!H\u0002J\b\u0010|\u001a\u00020!H\u0002J(\u0010}\u001a\u00020i2\b\u0010~\u001a\u0004\u0018\u00010\u007f2\b\u0010\u0080\u0001\u001a\u00030\u0081\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\b\u0082\u0001\u0010\u0083\u0001J2\u0010\u0084\u0001\u001a\u00020i2\b\u0010\u0085\u0001\u001a\u00030\u0086\u00012\b\u0010\u0087\u0001\u001a\u00030\u0086\u00012\u0007\u0010]\u001a\u00030\u0081\u0001H\u0016ø\u0001\u0000¢\u0006\u0006\b\u0088\u0001\u0010\u0089\u0001J\t\u0010\u008a\u0001\u001a\u00020iH\u0002J!\u0010\u008b\u0001\u001a\u00020i*\u00020J2\u0006\u00100\u001a\u00020/H\u0002ø\u0001\u0000¢\u0006\u0006\b\u008c\u0001\u0010\u008d\u0001R$\u0010\u000b\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR,\u0010\u0011\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0016\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R,\u0010\u0018\u001a\u00020\u00172\u0006\u0010\t\u001a\u00020\u0017@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u001d\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR$\u0010\u001e\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010\r\"\u0004\b \u0010\u000fR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\"\u001a\u00020!2\u0006\u0010\t\u001a\u00020!@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b#\u0010$\"\u0004\b%\u0010&R\u000e\u0010'\u001a\u00020!X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010(\u001a\u00020!X\u0082\u000e¢\u0006\u0002\n\u0000R(\u0010*\u001a\u0004\u0018\u00010)2\b\u0010\t\u001a\u0004\u0018\u00010)@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b+\u0010,\"\u0004\b-\u0010.R,\u00100\u001a\u00020/2\u0006\u0010\t\u001a\u00020/@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u001d\u001a\u0004\b1\u0010\u001a\"\u0004\b2\u0010\u001cR\u0014\u00103\u001a\u00020!8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b4\u0010$R\u001a\u00105\u001a\u00020!X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b5\u0010$\"\u0004\b6\u0010&R\u0014\u00107\u001a\u00020\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b8\u0010\u0013R\u0010\u00109\u001a\u0004\u0018\u00010:X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010;\u001a\u0004\u0018\u00010<X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010=\u001a\u00020!X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b>\u0010\u0013R,\u0010@\u001a\u00020?2\u0006\u0010\t\u001a\u00020?@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0016\u001a\u0004\bA\u0010\u0013\"\u0004\bB\u0010\u0015R(\u0010D\u001a\u0004\u0018\u00010C2\b\u0010\t\u001a\u0004\u0018\u00010C@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bE\u0010F\"\u0004\bG\u0010HR\u000e\u0010I\u001a\u00020JX\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010K\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bL\u0010\r\"\u0004\bM\u0010\u000fR$\u0010N\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bO\u0010\r\"\u0004\bP\u0010\u000fR$\u0010Q\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bR\u0010\r\"\u0004\bS\u0010\u000fR$\u0010T\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bU\u0010\r\"\u0004\bV\u0010\u000fR$\u0010W\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bX\u0010\r\"\u0004\bY\u0010\u000fR$\u0010Z\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b[\u0010\r\"\u0004\b\\\u0010\u000fR\u0016\u0010]\u001a\u00020^X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0016R,\u0010_\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010@VX\u0096\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0016\u001a\u0004\b`\u0010\u0013\"\u0004\ba\u0010\u0015R$\u0010b\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bc\u0010\r\"\u0004\bd\u0010\u000fR$\u0010e\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bf\u0010\r\"\u0004\bg\u0010\u000f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u008e\u0001"}, d2 = {"Landroidx/compose/ui/graphics/layer/GraphicsLayerV29;", "Landroidx/compose/ui/graphics/layer/GraphicsLayerImpl;", "ownerId", "", "canvasHolder", "Landroidx/compose/ui/graphics/CanvasHolder;", "canvasDrawScope", "Landroidx/compose/ui/graphics/drawscope/CanvasDrawScope;", "(JLandroidx/compose/ui/graphics/CanvasHolder;Landroidx/compose/ui/graphics/drawscope/CanvasDrawScope;)V", "value", "", "alpha", "getAlpha", "()F", "setAlpha", "(F)V", "Landroidx/compose/ui/graphics/Color;", "ambientShadowColor", "getAmbientShadowColor-0d7_KjU", "()J", "setAmbientShadowColor-8_81llA", "(J)V", "J", "Landroidx/compose/ui/graphics/BlendMode;", "blendMode", "getBlendMode-0nO6VwU", "()I", "setBlendMode-s9anfk8", "(I)V", "I", "cameraDistance", "getCameraDistance", "setCameraDistance", "", "clip", "getClip", "()Z", "setClip", "(Z)V", "clipToBounds", "clipToOutline", "Landroidx/compose/ui/graphics/ColorFilter;", "colorFilter", "getColorFilter", "()Landroidx/compose/ui/graphics/ColorFilter;", "setColorFilter", "(Landroidx/compose/ui/graphics/ColorFilter;)V", "Landroidx/compose/ui/graphics/layer/CompositingStrategy;", "compositingStrategy", "getCompositingStrategy-ke2Ky5w", "setCompositingStrategy-Wpw9cng", "hasDisplayList", "getHasDisplayList", "isInvalidated", "setInvalidated", "layerId", "getLayerId", "layerPaint", "Landroid/graphics/Paint;", "matrix", "Landroid/graphics/Matrix;", "outlineIsProvided", "getOwnerId", "Landroidx/compose/ui/geometry/Offset;", "pivotOffset", "getPivotOffset-F1C5BW0", "setPivotOffset-k-4lQ0M", "Landroidx/compose/ui/graphics/RenderEffect;", "renderEffect", "getRenderEffect", "()Landroidx/compose/ui/graphics/RenderEffect;", "setRenderEffect", "(Landroidx/compose/ui/graphics/RenderEffect;)V", "renderNode", "Landroid/graphics/RenderNode;", "rotationX", "getRotationX", "setRotationX", "rotationY", "getRotationY", "setRotationY", "rotationZ", "getRotationZ", "setRotationZ", "scaleX", "getScaleX", "setScaleX", "scaleY", "getScaleY", "setScaleY", "shadowElevation", "getShadowElevation", "setShadowElevation", "size", "Landroidx/compose/ui/geometry/Size;", "spotShadowColor", "getSpotShadowColor-0d7_KjU", "setSpotShadowColor-8_81llA", "translationX", "getTranslationX", "setTranslationX", "translationY", "getTranslationY", "setTranslationY", "applyClip", "", "calculateMatrix", "discardDisplayList", "draw", "canvas", "Landroidx/compose/ui/graphics/Canvas;", "obtainLayerPaint", "record", "density", "Landroidx/compose/ui/unit/Density;", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "layer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "block", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "Lkotlin/ExtensionFunctionType;", "requiresCompositingLayer", "requiresLayerPaint", "setOutline", "outline", "Landroid/graphics/Outline;", "outlineSize", "Landroidx/compose/ui/unit/IntSize;", "setOutline-O0kMr_c", "(Landroid/graphics/Outline;J)V", "setPosition", "x", "", "y", "setPosition-H0pRuoY", "(IIJ)V", "updateLayerProperties", "applyCompositingStrategy", "applyCompositingStrategy-Z1X6vPc", "(Landroid/graphics/RenderNode;I)V", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class GraphicsLayerV29 implements GraphicsLayerImpl {
    private float alpha;
    private long ambientShadowColor;
    private int blendMode;
    private float cameraDistance;
    private final CanvasDrawScope canvasDrawScope;
    private final CanvasHolder canvasHolder;
    private boolean clip;
    private boolean clipToBounds;
    private boolean clipToOutline;
    private ColorFilter colorFilter;
    private int compositingStrategy;
    private boolean isInvalidated;
    private Paint layerPaint;
    private Matrix matrix;
    private boolean outlineIsProvided;
    private final long ownerId;
    private long pivotOffset;
    private RenderEffect renderEffect;
    private final RenderNode renderNode;
    private float rotationX;
    private float rotationY;
    private float rotationZ;
    private float scaleX;
    private float scaleY;
    private float shadowElevation;
    private long size;
    private long spotShadowColor;
    private float translationX;
    private float translationY;

    public GraphicsLayerV29(long j, CanvasHolder canvasHolder, CanvasDrawScope canvasDrawScope) {
        this.ownerId = j;
        this.canvasHolder = canvasHolder;
        this.canvasDrawScope = canvasDrawScope;
        RenderNode renderNodeM13m = ComponentDialog$$ExternalSyntheticApiModelOutline0.m13m("graphicsLayer");
        this.renderNode = renderNodeM13m;
        this.size = Size.INSTANCE.m4424getZeroNHjbRc();
        renderNodeM13m.setClipToBounds(false);
        m5299applyCompositingStrategyZ1X6vPc(renderNodeM13m, CompositingStrategy.INSTANCE.m5263getAutoke2Ky5w());
        this.alpha = 1.0f;
        this.blendMode = BlendMode.INSTANCE.m4532getSrcOver0nO6VwU();
        this.pivotOffset = Offset.INSTANCE.m4361getUnspecifiedF1C5BW0();
        this.scaleX = 1.0f;
        this.scaleY = 1.0f;
        this.ambientShadowColor = Color.INSTANCE.m4616getBlack0d7_KjU();
        this.spotShadowColor = Color.INSTANCE.m4616getBlack0d7_KjU();
        this.cameraDistance = 8.0f;
        this.compositingStrategy = CompositingStrategy.INSTANCE.m5263getAutoke2Ky5w();
        this.isInvalidated = true;
    }

    @Override
    public long getOwnerId() {
        return this.ownerId;
    }

    public GraphicsLayerV29(long j, CanvasHolder canvasHolder, CanvasDrawScope canvasDrawScope, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, (i & 2) != 0 ? new CanvasHolder() : canvasHolder, (i & 4) != 0 ? new CanvasDrawScope() : canvasDrawScope);
    }

    @Override
    public float getAlpha() {
        return this.alpha;
    }

    @Override
    public void setAlpha(float f) {
        this.alpha = f;
        this.renderNode.setAlpha(f);
    }

    @Override
    public int getBlendMode() {
        return this.blendMode;
    }

    @Override
    public void mo5292setBlendModes9anfk8(int i) {
        this.blendMode = i;
        obtainLayerPaint().setBlendMode(AndroidBlendMode_androidKt.m4438toAndroidBlendModes9anfk8(i));
        updateLayerProperties();
    }

    @Override
    public ColorFilter getColorFilter() {
        return this.colorFilter;
    }

    @Override
    public void setColorFilter(ColorFilter colorFilter) {
        this.colorFilter = colorFilter;
        obtainLayerPaint().setColorFilter(colorFilter != null ? AndroidColorFilter_androidKt.asAndroidColorFilter(colorFilter) : null);
        updateLayerProperties();
    }

    @Override
    public long getPivotOffset() {
        return this.pivotOffset;
    }

    @Override
    public void mo5295setPivotOffsetk4lQ0M(long j) {
        this.pivotOffset = j;
        if (OffsetKt.m4367isUnspecifiedk4lQ0M(j)) {
            this.renderNode.resetPivot();
        } else {
            this.renderNode.setPivotX(Offset.m4346getXimpl(j));
            this.renderNode.setPivotY(Offset.m4347getYimpl(j));
        }
    }

    @Override
    public float getScaleX() {
        return this.scaleX;
    }

    @Override
    public void setScaleX(float f) {
        this.scaleX = f;
        this.renderNode.setScaleX(f);
    }

    @Override
    public float getScaleY() {
        return this.scaleY;
    }

    @Override
    public void setScaleY(float f) {
        this.scaleY = f;
        this.renderNode.setScaleY(f);
    }

    @Override
    public float getTranslationX() {
        return this.translationX;
    }

    @Override
    public void setTranslationX(float f) {
        this.translationX = f;
        this.renderNode.setTranslationX(f);
    }

    @Override
    public float getTranslationY() {
        return this.translationY;
    }

    @Override
    public void setTranslationY(float f) {
        this.translationY = f;
        this.renderNode.setTranslationY(f);
    }

    @Override
    public float getShadowElevation() {
        return this.shadowElevation;
    }

    @Override
    public void setShadowElevation(float f) {
        this.shadowElevation = f;
        this.renderNode.setElevation(f);
    }

    @Override
    public long getAmbientShadowColor() {
        return this.ambientShadowColor;
    }

    @Override
    public void mo5291setAmbientShadowColor8_81llA(long j) {
        this.ambientShadowColor = j;
        this.renderNode.setAmbientShadowColor(ColorKt.m4644toArgb8_81llA(j));
    }

    @Override
    public long getSpotShadowColor() {
        return this.spotShadowColor;
    }

    @Override
    public void mo5297setSpotShadowColor8_81llA(long j) {
        this.spotShadowColor = j;
        this.renderNode.setSpotShadowColor(ColorKt.m4644toArgb8_81llA(j));
    }

    @Override
    public float getRotationX() {
        return this.rotationX;
    }

    @Override
    public void setRotationX(float f) {
        this.rotationX = f;
        this.renderNode.setRotationX(f);
    }

    @Override
    public float getRotationY() {
        return this.rotationY;
    }

    @Override
    public void setRotationY(float f) {
        this.rotationY = f;
        this.renderNode.setRotationY(f);
    }

    @Override
    public float getRotationZ() {
        return this.rotationZ;
    }

    @Override
    public void setRotationZ(float f) {
        this.rotationZ = f;
        this.renderNode.setRotationZ(f);
    }

    @Override
    public float getCameraDistance() {
        return this.cameraDistance;
    }

    @Override
    public void setCameraDistance(float f) {
        this.cameraDistance = f;
        this.renderNode.setCameraDistance(f);
    }

    @Override
    public boolean getClip() {
        return this.clip;
    }

    @Override
    public void setClip(boolean z) {
        this.clip = z;
        applyClip();
    }

    private final void applyClip() {
        boolean z = getClip() && !this.outlineIsProvided;
        boolean z2 = getClip() && this.outlineIsProvided;
        if (z != this.clipToBounds) {
            this.clipToBounds = z;
            this.renderNode.setClipToBounds(z);
        }
        if (z2 != this.clipToOutline) {
            this.clipToOutline = z2;
            this.renderNode.setClipToOutline(z2);
        }
    }

    @Override
    public RenderEffect getRenderEffect() {
        return this.renderEffect;
    }

    @Override
    public void setRenderEffect(RenderEffect renderEffect) {
        this.renderEffect = renderEffect;
        if (Build.VERSION.SDK_INT >= 31) {
            RenderNodeVerificationHelper.INSTANCE.setRenderEffect(this.renderNode, renderEffect);
        }
    }

    @Override
    public int getCompositingStrategy() {
        return this.compositingStrategy;
    }

    @Override
    public void mo5293setCompositingStrategyWpw9cng(int i) {
        this.compositingStrategy = i;
        updateLayerProperties();
    }

    private final void m5299applyCompositingStrategyZ1X6vPc(RenderNode renderNode, int i) {
        if (CompositingStrategy.m5259equalsimpl0(i, CompositingStrategy.INSTANCE.m5265getOffscreenke2Ky5w())) {
            renderNode.setUseCompositingLayer(true, this.layerPaint);
            renderNode.setHasOverlappingRendering(true);
        } else if (CompositingStrategy.m5259equalsimpl0(i, CompositingStrategy.INSTANCE.m5264getModulateAlphake2Ky5w())) {
            renderNode.setUseCompositingLayer(false, this.layerPaint);
            renderNode.setHasOverlappingRendering(false);
        } else {
            renderNode.setUseCompositingLayer(false, this.layerPaint);
            renderNode.setHasOverlappingRendering(true);
        }
    }

    private final void updateLayerProperties() {
        if (requiresCompositingLayer()) {
            m5299applyCompositingStrategyZ1X6vPc(this.renderNode, CompositingStrategy.INSTANCE.m5265getOffscreenke2Ky5w());
        } else {
            m5299applyCompositingStrategyZ1X6vPc(this.renderNode, getCompositingStrategy());
        }
    }

    @Override
    public void mo5296setPositionH0pRuoY(int x, int y, long size) {
        this.renderNode.setPosition(x, y, IntSize.getWidth-impl(size) + x, IntSize.getHeight-impl(size) + y);
        this.size = IntSizeKt.toSize-ozmzZPI(size);
    }

    @Override
    public void mo5294setOutlineO0kMr_c(Outline outline, long outlineSize) {
        this.renderNode.setOutline(outline);
        this.outlineIsProvided = outline != null;
        applyClip();
    }

    @Override
    public boolean getIsInvalidated() {
        return this.isInvalidated;
    }

    @Override
    public void setInvalidated(boolean z) {
        this.isInvalidated = z;
    }

    @Override
    public void record(Density density, LayoutDirection layoutDirection, GraphicsLayer layer, Function1<? super DrawScope, Unit> block) {
        RecordingCanvas recordingCanvasBeginRecording = this.renderNode.beginRecording();
        try {
            CanvasHolder canvasHolder = this.canvasHolder;
            Canvas internalCanvas = canvasHolder.getAndroidCanvas().getInternalCanvas();
            canvasHolder.getAndroidCanvas().setInternalCanvas(recordingCanvasBeginRecording);
            AndroidCanvas androidCanvas = canvasHolder.getAndroidCanvas();
            DrawContext drawContext = this.canvasDrawScope.getDrawContext();
            drawContext.setDensity(density);
            drawContext.setLayoutDirection(layoutDirection);
            drawContext.setGraphicsLayer(layer);
            drawContext.mo5103setSizeuvyYCjk(this.size);
            drawContext.setCanvas(androidCanvas);
            block.invoke(this.canvasDrawScope);
            canvasHolder.getAndroidCanvas().setInternalCanvas(internalCanvas);
            this.renderNode.endRecording();
            setInvalidated(false);
        } catch (Throwable th) {
            this.renderNode.endRecording();
            throw th;
        }
    }

    @Override
    public void draw(androidx.compose.p002ui.graphics.Canvas canvas) {
        AndroidCanvas_androidKt.getNativeCanvas(canvas).drawRenderNode(this.renderNode);
    }

    @Override
    public Matrix calculateMatrix() {
        Matrix matrix = this.matrix;
        if (matrix == null) {
            matrix = new Matrix();
            this.matrix = matrix;
        }
        this.renderNode.getMatrix(matrix);
        return matrix;
    }

    @Override
    public boolean getHasDisplayList() {
        return this.renderNode.hasDisplayList();
    }

    @Override
    public void discardDisplayList() {
        this.renderNode.discardDisplayList();
    }

    @Override
    public long getLayerId() {
        return this.renderNode.getUniqueId();
    }

    private final Paint obtainLayerPaint() {
        Paint paint = this.layerPaint;
        if (paint != null) {
            return paint;
        }
        Paint paint2 = new Paint();
        this.layerPaint = paint2;
        return paint2;
    }

    private final boolean requiresCompositingLayer() {
        return CompositingStrategy.m5259equalsimpl0(getCompositingStrategy(), CompositingStrategy.INSTANCE.m5265getOffscreenke2Ky5w()) || requiresLayerPaint() || getRenderEffect() != null;
    }

    private final boolean requiresLayerPaint() {
        return (BlendMode.m4501equalsimpl0(getBlendMode(), BlendMode.INSTANCE.m4532getSrcOver0nO6VwU()) && getColorFilter() == null) ? false : true;
    }
}
