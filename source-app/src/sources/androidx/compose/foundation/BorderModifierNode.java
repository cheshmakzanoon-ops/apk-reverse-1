package androidx.compose.foundation;

import androidx.compose.p002ui.draw.CacheDrawModifierNode;
import androidx.compose.p002ui.draw.CacheDrawScope;
import androidx.compose.p002ui.draw.DrawModifierKt;
import androidx.compose.p002ui.draw.DrawResult;
import androidx.compose.p002ui.geometry.CornerRadius;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.RoundRectKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.BlendMode;
import androidx.compose.p002ui.graphics.Brush;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.ClipOp;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.ImageBitmap;
import androidx.compose.p002ui.graphics.ImageBitmapConfig;
import androidx.compose.p002ui.graphics.ImageBitmapKt;
import androidx.compose.p002ui.graphics.Outline;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.PathOperation;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.SolidColor;
import androidx.compose.p002ui.graphics.drawscope.CanvasDrawScope;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.drawscope.Stroke;
import androidx.compose.p002ui.node.DelegatingNode;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ,\u0010\u001e\u001a\u00020\u001f*\u00020 2\u0006\u0010\f\u001a\u00020\u00052\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&H\u0002JF\u0010'\u001a\u00020\u001f*\u00020 2\u0006\u0010\f\u001a\u00020\u00052\u0006\u0010!\u001a\u00020(2\u0006\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020,2\u0006\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020&H\u0002ø\u0001\u0000¢\u0006\u0004\b-\u0010.R\u0010\u0010\t\u001a\u0004\u0018\u00010\nX\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010\f\u001a\u00020\u00052\u0006\u0010\u000b\u001a\u00020\u0005@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010\u0013\u001a\u00020\u00072\u0006\u0010\u000b\u001a\u00020\u0007@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017R,\u0010\u0018\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\u0003@FX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u001d\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001c\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006/"}, d2 = {"Landroidx/compose/foundation/BorderModifierNode;", "Landroidx/compose/ui/node/DelegatingNode;", "widthParameter", "Landroidx/compose/ui/unit/Dp;", "brushParameter", "Landroidx/compose/ui/graphics/Brush;", "shapeParameter", "Landroidx/compose/ui/graphics/Shape;", "(FLandroidx/compose/ui/graphics/Brush;Landroidx/compose/ui/graphics/Shape;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "borderCache", "Landroidx/compose/foundation/BorderCache;", "value", "brush", "getBrush", "()Landroidx/compose/ui/graphics/Brush;", "setBrush", "(Landroidx/compose/ui/graphics/Brush;)V", "drawWithCacheModifierNode", "Landroidx/compose/ui/draw/CacheDrawModifierNode;", "shape", "getShape", "()Landroidx/compose/ui/graphics/Shape;", "setShape", "(Landroidx/compose/ui/graphics/Shape;)V", "width", "getWidth-D9Ej5fM", "()F", "setWidth-0680j_4", "(F)V", "F", "drawGenericBorder", "Landroidx/compose/ui/draw/DrawResult;", "Landroidx/compose/ui/draw/CacheDrawScope;", "outline", "Landroidx/compose/ui/graphics/Outline$Generic;", "fillArea", "", "strokeWidth", "", "drawRoundRectBorder", "Landroidx/compose/ui/graphics/Outline$Rounded;", "topLeft", "Landroidx/compose/ui/geometry/Offset;", "borderSize", "Landroidx/compose/ui/geometry/Size;", "drawRoundRectBorder-JqoCqck", "(Landroidx/compose/ui/draw/CacheDrawScope;Landroidx/compose/ui/graphics/Brush;Landroidx/compose/ui/graphics/Outline$Rounded;JJZF)Landroidx/compose/ui/draw/DrawResult;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class BorderModifierNode extends DelegatingNode {
    public static final int $stable = 8;
    private BorderCache borderCache;
    private Brush brush;
    private final CacheDrawModifierNode drawWithCacheModifierNode;
    private Shape shape;
    private float width;

    public BorderModifierNode(float f, Brush brush, Shape shape, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, brush, shape);
    }

    private BorderModifierNode(float f, Brush brush, Shape shape) {
        this.width = f;
        this.brush = brush;
        this.shape = shape;
        this.drawWithCacheModifierNode = (CacheDrawModifierNode) delegate(DrawModifierKt.CacheDrawModifierNode(new Function1<CacheDrawScope, DrawResult>() {
            {
                super(1);
            }

            public final DrawResult invoke(CacheDrawScope cacheDrawScope) throws NoWhenBranchMatchedException {
                if (cacheDrawScope.m4226toPx0680j_4(this.this$0.getWidth()) < 0.0f || Size.m4414getMinDimensionimpl(cacheDrawScope.m4217getSizeNHjbRc()) <= 0.0f) {
                    return BorderKt.drawContentWithoutBorder(cacheDrawScope);
                }
                float f2 = 2;
                float fMin = Math.min(Dp.equals-impl0(this.this$0.getWidth(), Dp.Companion.getHairline-D9Ej5fM()) ? 1.0f : (float) Math.ceil(cacheDrawScope.m4226toPx0680j_4(this.this$0.getWidth())), (float) Math.ceil(Size.m4414getMinDimensionimpl(cacheDrawScope.m4217getSizeNHjbRc()) / f2));
                float f3 = fMin / f2;
                long jOffset = OffsetKt.Offset(f3, f3);
                long jSize = SizeKt.Size(Size.m4415getWidthimpl(cacheDrawScope.m4217getSizeNHjbRc()) - fMin, Size.m4412getHeightimpl(cacheDrawScope.m4217getSizeNHjbRc()) - fMin);
                boolean z = f2 * fMin > Size.m4414getMinDimensionimpl(cacheDrawScope.m4217getSizeNHjbRc());
                Outline outlineMo572createOutlinePq9zytI = this.this$0.getShape().mo572createOutlinePq9zytI(cacheDrawScope.m4217getSizeNHjbRc(), cacheDrawScope.getLayoutDirection(), cacheDrawScope);
                if (outlineMo572createOutlinePq9zytI instanceof Outline.Generic) {
                    BorderModifierNode borderModifierNode = this.this$0;
                    return borderModifierNode.drawGenericBorder(cacheDrawScope, borderModifierNode.getBrush(), (Outline.Generic) outlineMo572createOutlinePq9zytI, z, fMin);
                }
                if (outlineMo572createOutlinePq9zytI instanceof Outline.Rounded) {
                    BorderModifierNode borderModifierNode2 = this.this$0;
                    return borderModifierNode2.m539drawRoundRectBorderJqoCqck(cacheDrawScope, borderModifierNode2.getBrush(), (Outline.Rounded) outlineMo572createOutlinePq9zytI, jOffset, jSize, z, fMin);
                }
                if (outlineMo572createOutlinePq9zytI instanceof Outline.Rectangle) {
                    return BorderKt.m536drawRectBorderNsqcLGU(cacheDrawScope, this.this$0.getBrush(), jOffset, jSize, z, fMin);
                }
                throw new NoWhenBranchMatchedException();
            }
        }));
    }

    public final float getWidth() {
        return this.width;
    }

    public final void m541setWidth0680j_4(float f) {
        if (Dp.equals-impl0(this.width, f)) {
            return;
        }
        this.width = f;
        this.drawWithCacheModifierNode.invalidateDrawCache();
    }

    public final Brush getBrush() {
        return this.brush;
    }

    public final void setBrush(Brush brush) {
        if (Intrinsics.areEqual(this.brush, brush)) {
            return;
        }
        this.brush = brush;
        this.drawWithCacheModifierNode.invalidateDrawCache();
    }

    public final Shape getShape() {
        return this.shape;
    }

    public final void setShape(Shape shape) {
        if (Intrinsics.areEqual(this.shape, shape)) {
            return;
        }
        this.shape = shape;
        this.drawWithCacheModifierNode.invalidateDrawCache();
    }

    public final DrawResult drawGenericBorder(CacheDrawScope cacheDrawScope, final Brush brush, final Outline.Generic generic, boolean z, float f) throws Throwable {
        int iM4818getArgb8888_sVssgQ;
        ColorFilter colorFilterM4631tintxETnrds$default;
        boolean z2;
        Canvas canvas;
        ImageBitmap imageBitmap;
        float f2;
        float f3;
        long j;
        DrawContext drawContext;
        if (z) {
            return cacheDrawScope.onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((ContentDrawScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(ContentDrawScope contentDrawScope) {
                    contentDrawScope.drawContent();
                    DrawScope.CC.m5175drawPathGBMwjPU$default(contentDrawScope, generic.getPath(), brush, 0.0f, null, null, 0, 60, null);
                }
            });
        }
        if (brush instanceof SolidColor) {
            iM4818getArgb8888_sVssgQ = ImageBitmapConfig.INSTANCE.m4817getAlpha8_sVssgQ();
            colorFilterM4631tintxETnrds$default = ColorFilter.Companion.m4631tintxETnrds$default(ColorFilter.INSTANCE, ((SolidColor) brush).getValue(), 0, 2, null);
        } else {
            iM4818getArgb8888_sVssgQ = ImageBitmapConfig.INSTANCE.m4818getArgb8888_sVssgQ();
            colorFilterM4631tintxETnrds$default = null;
        }
        final Rect bounds = generic.getPath().getBounds();
        if (this.borderCache == null) {
            this.borderCache = new BorderCache(null, null, null, null, 15, null);
        }
        BorderCache borderCache = this.borderCache;
        Intrinsics.checkNotNull(borderCache);
        Path pathObtainPath = borderCache.obtainPath();
        pathObtainPath.reset();
        Path.CC.addRect$default(pathObtainPath, bounds, null, 2, null);
        pathObtainPath.mo4480opN5in7k0(pathObtainPath, generic.getPath(), PathOperation.INSTANCE.m4890getDifferenceb3I0S0c());
        final Ref.ObjectRef objectRef = new Ref.ObjectRef();
        final long jIntSize = IntSizeKt.IntSize((int) Math.ceil(bounds.getWidth()), (int) Math.ceil(bounds.getHeight()));
        BorderCache borderCache2 = this.borderCache;
        Intrinsics.checkNotNull(borderCache2);
        ImageBitmap imageBitmap2 = borderCache2.imageBitmap;
        Canvas canvas2 = borderCache2.canvas;
        ImageBitmapConfig imageBitmapConfigM4810boximpl = imageBitmap2 != null ? ImageBitmapConfig.m4810boximpl(imageBitmap2.mo4455getConfig_sVssgQ()) : null;
        if (!(imageBitmapConfigM4810boximpl == null ? false : ImageBitmapConfig.m4813equalsimpl0(imageBitmapConfigM4810boximpl.m4816unboximpl(), ImageBitmapConfig.INSTANCE.m4818getArgb8888_sVssgQ()))) {
            z2 = ImageBitmapConfig.m4812equalsimpl(iM4818getArgb8888_sVssgQ, imageBitmap2 != null ? ImageBitmapConfig.m4810boximpl(imageBitmap2.mo4455getConfig_sVssgQ()) : null);
        }
        if (imageBitmap2 == null || canvas2 == null || Size.m4415getWidthimpl(cacheDrawScope.m4217getSizeNHjbRc()) > imageBitmap2.getWidth() || Size.m4412getHeightimpl(cacheDrawScope.m4217getSizeNHjbRc()) > imageBitmap2.getHeight() || !z2) {
            ImageBitmap imageBitmapM4823ImageBitmapx__hDU$default = ImageBitmapKt.m4823ImageBitmapx__hDU$default(IntSize.getWidth-impl(jIntSize), IntSize.getHeight-impl(jIntSize), iM4818getArgb8888_sVssgQ, false, null, 24, null);
            borderCache2.imageBitmap = imageBitmapM4823ImageBitmapx__hDU$default;
            Canvas Canvas = androidx.compose.p002ui.graphics.CanvasKt.Canvas(imageBitmapM4823ImageBitmapx__hDU$default);
            borderCache2.canvas = Canvas;
            canvas = Canvas;
            imageBitmap = imageBitmapM4823ImageBitmapx__hDU$default;
        } else {
            imageBitmap = imageBitmap2;
            canvas = canvas2;
        }
        CanvasDrawScope canvasDrawScope = borderCache2.canvasDrawScope;
        if (canvasDrawScope == null) {
            canvasDrawScope = new CanvasDrawScope();
            borderCache2.canvasDrawScope = canvasDrawScope;
        }
        CanvasDrawScope canvasDrawScope2 = canvasDrawScope;
        long j2 = IntSizeKt.toSize-ozmzZPI(jIntSize);
        LayoutDirection layoutDirection = cacheDrawScope.getLayoutDirection();
        CanvasDrawScope.DrawParams drawParams = canvasDrawScope2.getDrawParams();
        Density density = drawParams.getDensity();
        LayoutDirection layoutDirection2 = drawParams.getLayoutDirection();
        Canvas canvas3 = drawParams.getCanvas();
        long size = drawParams.getSize();
        CanvasDrawScope.DrawParams drawParams2 = canvasDrawScope2.getDrawParams();
        drawParams2.setDensity(cacheDrawScope);
        drawParams2.setLayoutDirection(layoutDirection);
        drawParams2.setCanvas(canvas);
        drawParams2.m5101setSizeuvyYCjk(j2);
        canvas.save();
        CanvasDrawScope canvasDrawScope3 = canvasDrawScope2;
        DrawScope.CC.m5180drawRectnJ9OG0$default(canvasDrawScope3, Color.INSTANCE.m4616getBlack0d7_KjU(), 0L, j2, 0.0f, null, null, BlendMode.INSTANCE.m4505getClear0nO6VwU(), 58, null);
        float f4 = -bounds.getLeft();
        float f5 = -bounds.getTop();
        canvasDrawScope3.getDrawContext().getTransform().translate(f4, f5);
        try {
            f2 = f5;
            f3 = f4;
            try {
                DrawScope.CC.m5175drawPathGBMwjPU$default(canvasDrawScope3, generic.getPath(), brush, 0.0f, new Stroke(f * 2, 0.0f, 0, 0, null, 30, null), null, 0, 52, null);
                float f6 = 1;
                float fM4415getWidthimpl = (Size.m4415getWidthimpl(canvasDrawScope3.mo5083getSizeNHjbRc()) + f6) / Size.m4415getWidthimpl(canvasDrawScope3.mo5083getSizeNHjbRc());
                float fM4412getHeightimpl = (Size.m4412getHeightimpl(canvasDrawScope3.mo5083getSizeNHjbRc()) + f6) / Size.m4412getHeightimpl(canvasDrawScope3.mo5083getSizeNHjbRc());
                long jMo5082getCenterF1C5BW0 = canvasDrawScope3.mo5082getCenterF1C5BW0();
                DrawContext drawContext2 = canvasDrawScope3.getDrawContext();
                long jMo5102getSizeNHjbRc = drawContext2.mo5102getSizeNHjbRc();
                drawContext2.getCanvas().save();
                try {
                    drawContext2.getTransform().mo5109scale0AR0LA0(fM4415getWidthimpl, fM4412getHeightimpl, jMo5082getCenterF1C5BW0);
                    drawContext = drawContext2;
                    try {
                        DrawScope.CC.m5175drawPathGBMwjPU$default(canvasDrawScope3, pathObtainPath, brush, 0.0f, null, null, BlendMode.INSTANCE.m4505getClear0nO6VwU(), 28, null);
                        drawContext.getCanvas().restore();
                        drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                        canvasDrawScope3.getDrawContext().getTransform().translate(-f3, -f2);
                        canvas.restore();
                        CanvasDrawScope.DrawParams drawParams3 = canvasDrawScope2.getDrawParams();
                        drawParams3.setDensity(density);
                        drawParams3.setLayoutDirection(layoutDirection2);
                        drawParams3.setCanvas(canvas3);
                        drawParams3.m5101setSizeuvyYCjk(size);
                        imageBitmap.prepareToDraw();
                        objectRef.element = imageBitmap;
                        final ColorFilter colorFilter = colorFilterM4631tintxETnrds$default;
                        return cacheDrawScope.onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
                            {
                                super(1);
                            }

                            public Object invoke(Object obj) throws Throwable {
                                invoke((ContentDrawScope) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(ContentDrawScope contentDrawScope) throws Throwable {
                                float f7;
                                float f8;
                                contentDrawScope.drawContent();
                                ContentDrawScope contentDrawScope2 = contentDrawScope;
                                float left = bounds.getLeft();
                                float top = bounds.getTop();
                                Ref.ObjectRef<ImageBitmap> objectRef2 = objectRef;
                                long j3 = jIntSize;
                                ColorFilter colorFilter2 = colorFilter;
                                contentDrawScope2.getDrawContext().getTransform().translate(left, top);
                                try {
                                    f8 = left;
                                    try {
                                        DrawScope.CC.m5169drawImageAZ2fEMs$default(contentDrawScope2, (ImageBitmap) objectRef2.element, 0L, j3, 0L, 0L, 0.0f, null, colorFilter2, 0, 0, 890, null);
                                        contentDrawScope2.getDrawContext().getTransform().translate(-f8, -top);
                                    } catch (Throwable th) {
                                        th = th;
                                        f7 = top;
                                        contentDrawScope2.getDrawContext().getTransform().translate(-f8, -f7);
                                        throw th;
                                    }
                                } catch (Throwable th2) {
                                    th = th2;
                                    f7 = top;
                                    f8 = left;
                                }
                            }
                        });
                    } catch (Throwable th) {
                        th = th;
                        j = jMo5102getSizeNHjbRc;
                        try {
                            drawContext.getCanvas().restore();
                            drawContext.mo5103setSizeuvyYCjk(j);
                            throw th;
                        } catch (Throwable th2) {
                            th = th2;
                            canvasDrawScope3.getDrawContext().getTransform().translate(-f3, -f2);
                            throw th;
                        }
                    }
                } catch (Throwable th3) {
                    th = th3;
                    j = jMo5102getSizeNHjbRc;
                    drawContext = drawContext2;
                }
            } catch (Throwable th4) {
                th = th4;
                f2 = f2;
                f3 = f3;
            }
        } catch (Throwable th5) {
            th = th5;
            f2 = f5;
            f3 = f4;
        }
    }

    public final DrawResult m539drawRoundRectBorderJqoCqck(CacheDrawScope cacheDrawScope, final Brush brush, Outline.Rounded rounded, final long j, final long j2, final boolean z, final float f) {
        if (RoundRectKt.isSimple(rounded.getRoundRect())) {
            final long jM4396getTopLeftCornerRadiuskKHJgLs = rounded.getRoundRect().m4396getTopLeftCornerRadiuskKHJgLs();
            final float f2 = f / 2;
            final Stroke stroke = new Stroke(f, 0.0f, 0, 0, null, 30, null);
            return cacheDrawScope.onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) throws Throwable {
                    invoke((ContentDrawScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(ContentDrawScope contentDrawScope) throws Throwable {
                    long j3;
                    contentDrawScope.drawContent();
                    if (z) {
                        DrawScope.CC.m5181drawRoundRectZuiqVtQ$default(contentDrawScope, brush, 0L, 0L, jM4396getTopLeftCornerRadiuskKHJgLs, 0.0f, null, null, 0, 246, null);
                        return;
                    }
                    float fM4321getXimpl = CornerRadius.m4321getXimpl(jM4396getTopLeftCornerRadiuskKHJgLs);
                    float f3 = f2;
                    if (fM4321getXimpl < f3) {
                        ContentDrawScope contentDrawScope2 = contentDrawScope;
                        float f4 = f;
                        float fM4415getWidthimpl = Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) - f;
                        float fM4412getHeightimpl = Size.m4412getHeightimpl(contentDrawScope.mo5083getSizeNHjbRc()) - f;
                        int iM4578getDifferencertfAjoo = ClipOp.INSTANCE.m4578getDifferencertfAjoo();
                        Brush brush2 = brush;
                        long j4 = jM4396getTopLeftCornerRadiuskKHJgLs;
                        DrawContext drawContext = contentDrawScope2.getDrawContext();
                        long jMo5102getSizeNHjbRc = drawContext.mo5102getSizeNHjbRc();
                        drawContext.getCanvas().save();
                        try {
                            drawContext.getTransform().mo5105clipRectN_I0leg(f4, f4, fM4415getWidthimpl, fM4412getHeightimpl, iM4578getDifferencertfAjoo);
                            try {
                                DrawScope.CC.m5181drawRoundRectZuiqVtQ$default(contentDrawScope2, brush2, 0L, 0L, j4, 0.0f, null, null, 0, 246, null);
                                drawContext.getCanvas().restore();
                                drawContext.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                            } catch (Throwable th) {
                                th = th;
                                j3 = jMo5102getSizeNHjbRc;
                                drawContext.getCanvas().restore();
                                drawContext.mo5103setSizeuvyYCjk(j3);
                                throw th;
                            }
                        } catch (Throwable th2) {
                            th = th2;
                            j3 = jMo5102getSizeNHjbRc;
                        }
                    } else {
                        DrawScope.CC.m5181drawRoundRectZuiqVtQ$default(contentDrawScope, brush, j, j2, BorderKt.m537shrinkKibmq7A(jM4396getTopLeftCornerRadiuskKHJgLs, f3), 0.0f, stroke, null, 0, 208, null);
                    }
                }
            });
        }
        if (this.borderCache == null) {
            this.borderCache = new BorderCache(null, null, null, null, 15, null);
        }
        BorderCache borderCache = this.borderCache;
        Intrinsics.checkNotNull(borderCache);
        final Path pathCreateRoundRectPath = BorderKt.createRoundRectPath(borderCache.obtainPath(), rounded.getRoundRect(), f, z);
        return cacheDrawScope.onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((ContentDrawScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ContentDrawScope contentDrawScope) {
                contentDrawScope.drawContent();
                DrawScope.CC.m5175drawPathGBMwjPU$default(contentDrawScope, pathCreateRoundRectPath, brush, 0.0f, null, null, 0, 60, null);
            }
        });
    }
}
