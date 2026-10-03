package androidx.compose.p002ui.graphics;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Region;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntSize;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000ª\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010 \n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0014\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\"\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0014\u0010\u0015J:\u0010\u0016\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00182\u0006\u0010\u001a\u001a\u00020\u00182\u0006\u0010\u001b\u001a\u00020\u00182\u0006\u0010\u0012\u001a\u00020\u0013H\u0016ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ\u001a\u0010\u001e\u001a\u00020\u000f2\u0006\u0010\u001f\u001a\u00020 H\u0016ø\u0001\u0000¢\u0006\u0004\b!\u0010\"J\b\u0010#\u001a\u00020\u000fH\u0016JH\u0010$\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00182\u0006\u0010\u001a\u001a\u00020\u00182\u0006\u0010\u001b\u001a\u00020\u00182\u0006\u0010%\u001a\u00020\u00182\u0006\u0010&\u001a\u00020\u00182\u0006\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020*H\u0016J*\u0010+\u001a\u00020\u000f2\u0006\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020\u00182\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\b/\u00100J*\u00101\u001a\u00020\u000f2\u0006\u00102\u001a\u0002032\u0006\u00104\u001a\u00020-2\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\b5\u00106JB\u00107\u001a\u00020\u000f2\u0006\u00102\u001a\u0002032\u0006\u00108\u001a\u0002092\u0006\u0010:\u001a\u00020;2\u0006\u0010<\u001a\u0002092\u0006\u0010=\u001a\u00020;2\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\b>\u0010?J*\u0010@\u001a\u00020\u000f2\u0006\u0010A\u001a\u00020-2\u0006\u0010B\u001a\u00020-2\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\bC\u0010DJ&\u0010E\u001a\u00020\u000f2\f\u0010F\u001a\b\u0012\u0004\u0012\u00020-0G2\u0006\u0010)\u001a\u00020*2\u0006\u0010H\u001a\u00020IH\u0002J0\u0010J\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00182\u0006\u0010\u001a\u001a\u00020\u00182\u0006\u0010\u001b\u001a\u00020\u00182\u0006\u0010)\u001a\u00020*H\u0016J\u0018\u0010K\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010)\u001a\u00020*H\u0016J0\u0010L\u001a\u00020\u000f2\u0006\u0010M\u001a\u00020N2\f\u0010F\u001a\b\u0012\u0004\u0012\u00020-0G2\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\bO\u0010PJ\u001e\u0010L\u001a\u00020\u000f2\f\u0010F\u001a\b\u0012\u0004\u0012\u00020-0G2\u0006\u0010)\u001a\u00020*H\u0002J \u0010Q\u001a\u00020\u000f2\u0006\u0010F\u001a\u00020R2\u0006\u0010)\u001a\u00020*2\u0006\u0010H\u001a\u00020IH\u0002J*\u0010S\u001a\u00020\u000f2\u0006\u0010M\u001a\u00020N2\u0006\u0010F\u001a\u00020R2\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\bT\u0010UJ \u0010S\u001a\u00020\u000f2\u0006\u0010F\u001a\u00020R2\u0006\u0010)\u001a\u00020*2\u0006\u0010H\u001a\u00020IH\u0002J0\u0010V\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00182\u0006\u0010\u001a\u001a\u00020\u00182\u0006\u0010\u001b\u001a\u00020\u00182\u0006\u0010)\u001a\u00020*H\u0016J@\u0010W\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u00182\u0006\u0010\u001a\u001a\u00020\u00182\u0006\u0010\u001b\u001a\u00020\u00182\u0006\u0010X\u001a\u00020\u00182\u0006\u0010Y\u001a\u00020\u00182\u0006\u0010)\u001a\u00020*H\u0016J*\u0010Z\u001a\u00020\u000f2\u0006\u0010[\u001a\u00020\\2\u0006\u0010]\u001a\u00020^2\u0006\u0010)\u001a\u00020*H\u0016ø\u0001\u0000¢\u0006\u0004\b_\u0010`J\b\u0010a\u001a\u00020\u000fH\u0016J\b\u0010b\u001a\u00020\u000fH\u0016J\u0010\u0010c\u001a\u00020\u000f2\u0006\u0010d\u001a\u00020\u0018H\u0016J\b\u0010e\u001a\u00020\u000fH\u0016J\u0018\u0010f\u001a\u00020\u000f2\u0006\u0010g\u001a\u00020h2\u0006\u0010)\u001a\u00020*H\u0016J\u0018\u0010i\u001a\u00020\u000f2\u0006\u0010j\u001a\u00020\u00182\u0006\u0010k\u001a\u00020\u0018H\u0016J\u0018\u0010l\u001a\u00020\u000f2\u0006\u0010j\u001a\u00020\u00182\u0006\u0010k\u001a\u00020\u0018H\u0016J\u0018\u0010m\u001a\u00020\u000f2\u0006\u0010n\u001a\u00020\u00182\u0006\u0010o\u001a\u00020\u0018H\u0016J\u0014\u0010p\u001a\u00020q*\u00020\u0013ø\u0001\u0000¢\u0006\u0004\br\u0010sR\u0010\u0010\u0003\u001a\u0004\u0018\u00010\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R(\u0010\u0005\u001a\u00060\u0006j\u0002`\u00078\u0000@\u0000X\u0081\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b\b\u0010\u0002\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\u0010\u0010\r\u001a\u0004\u0018\u00010\u0004X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006t"}, d2 = {"Landroidx/compose/ui/graphics/AndroidCanvas;", "Landroidx/compose/ui/graphics/Canvas;", "()V", "dstRect", "Landroid/graphics/Rect;", "internalCanvas", "Landroid/graphics/Canvas;", "Landroidx/compose/ui/graphics/NativeCanvas;", "getInternalCanvas$annotations", "getInternalCanvas", "()Landroid/graphics/Canvas;", "setInternalCanvas", "(Landroid/graphics/Canvas;)V", "srcRect", "clipPath", "", "path", "Landroidx/compose/ui/graphics/Path;", "clipOp", "Landroidx/compose/ui/graphics/ClipOp;", "clipPath-mtrdD-E", "(Landroidx/compose/ui/graphics/Path;I)V", "clipRect", "left", "", "top", "right", "bottom", "clipRect-N_I0leg", "(FFFFI)V", "concat", "matrix", "Landroidx/compose/ui/graphics/Matrix;", "concat-58bKbWc", "([F)V", "disableZ", "drawArc", "startAngle", "sweepAngle", "useCenter", "", "paint", "Landroidx/compose/ui/graphics/Paint;", "drawCircle", "center", "Landroidx/compose/ui/geometry/Offset;", "radius", "drawCircle-9KIMszo", "(JFLandroidx/compose/ui/graphics/Paint;)V", "drawImage", "image", "Landroidx/compose/ui/graphics/ImageBitmap;", "topLeftOffset", "drawImage-d-4ec7I", "(Landroidx/compose/ui/graphics/ImageBitmap;JLandroidx/compose/ui/graphics/Paint;)V", "drawImageRect", "srcOffset", "Landroidx/compose/ui/unit/IntOffset;", "srcSize", "Landroidx/compose/ui/unit/IntSize;", "dstOffset", "dstSize", "drawImageRect-HPBpro0", "(Landroidx/compose/ui/graphics/ImageBitmap;JJJJLandroidx/compose/ui/graphics/Paint;)V", "drawLine", "p1", "p2", "drawLine-Wko1d7g", "(JJLandroidx/compose/ui/graphics/Paint;)V", "drawLines", "points", "", "stepBy", "", "drawOval", "drawPath", "drawPoints", "pointMode", "Landroidx/compose/ui/graphics/PointMode;", "drawPoints-O7TthRY", "(ILjava/util/List;Landroidx/compose/ui/graphics/Paint;)V", "drawRawLines", "", "drawRawPoints", "drawRawPoints-O7TthRY", "(I[FLandroidx/compose/ui/graphics/Paint;)V", "drawRect", "drawRoundRect", "radiusX", "radiusY", "drawVertices", "vertices", "Landroidx/compose/ui/graphics/Vertices;", "blendMode", "Landroidx/compose/ui/graphics/BlendMode;", "drawVertices-TPEHhCM", "(Landroidx/compose/ui/graphics/Vertices;ILandroidx/compose/ui/graphics/Paint;)V", "enableZ", "restore", "rotate", "degrees", "save", "saveLayer", "bounds", "Landroidx/compose/ui/geometry/Rect;", "scale", "sx", "sy", "skew", "translate", "dx", "dy", "toRegionOp", "Landroid/graphics/Region$Op;", "toRegionOp--7u2Bmg", "(I)Landroid/graphics/Region$Op;", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AndroidCanvas implements Canvas {
    private Rect dstRect;
    private Canvas internalCanvas = AndroidCanvas_androidKt.EmptyCanvas;
    private Rect srcRect;

    public static void getInternalCanvas$annotations() {
    }

    @Override
    public void mo4442clipRectmtrdDE(androidx.compose.p002ui.geometry.Rect rect, int i) {
        Canvas.CC.m4560$default$clipRectmtrdDE(this, rect, i);
    }

    @Override
    public void drawArc(androidx.compose.p002ui.geometry.Rect rect, float f, float f2, boolean z, Paint paint) {
        Canvas.CC.$default$drawArc(this, rect, f, f2, z, paint);
    }

    @Override
    public void drawArcRad(androidx.compose.p002ui.geometry.Rect rect, float f, float f2, boolean z, Paint paint) {
        Canvas.CC.$default$drawArcRad(this, rect, f, f2, z, paint);
    }

    @Override
    public void drawOval(androidx.compose.p002ui.geometry.Rect rect, Paint paint) {
        Canvas.CC.$default$drawOval(this, rect, paint);
    }

    @Override
    public void drawRect(androidx.compose.p002ui.geometry.Rect rect, Paint paint) {
        Canvas.CC.$default$drawRect(this, rect, paint);
    }

    @Override
    public void skewRad(float f, float f2) {
        Canvas.CC.$default$skewRad(this, f, f2);
    }

    public final Canvas getInternalCanvas() {
        return this.internalCanvas;
    }

    public final void setInternalCanvas(Canvas canvas) {
        this.internalCanvas = canvas;
    }

    @Override
    public void save() {
        this.internalCanvas.save();
    }

    @Override
    public void restore() {
        this.internalCanvas.restore();
    }

    @Override
    public void saveLayer(androidx.compose.p002ui.geometry.Rect bounds, Paint paint) {
        this.internalCanvas.saveLayer(bounds.getLeft(), bounds.getTop(), bounds.getRight(), bounds.getBottom(), paint.getInternalPaint(), 31);
    }

    @Override
    public void translate(float dx, float dy) {
        this.internalCanvas.translate(dx, dy);
    }

    @Override
    public void scale(float sx, float sy) {
        this.internalCanvas.scale(sx, sy);
    }

    @Override
    public void rotate(float degrees) {
        this.internalCanvas.rotate(degrees);
    }

    @Override
    public void skew(float sx, float sy) {
        this.internalCanvas.skew(sx, sy);
    }

    @Override
    public void mo4443concat58bKbWc(float[] matrix) {
        if (MatrixKt.m4852isIdentity58bKbWc(matrix)) {
            return;
        }
        Matrix matrix2 = new Matrix();
        AndroidMatrixConversions_androidKt.m4458setFromEL8BTi8(matrix2, matrix);
        this.internalCanvas.concat(matrix2);
    }

    @Override
    public void mo4441clipRectN_I0leg(float left, float top, float right, float bottom, int clipOp) {
        this.internalCanvas.clipRect(left, top, right, bottom, m4451toRegionOp7u2Bmg(clipOp));
    }

    @Override
    public void mo4440clipPathmtrdDE(Path path, int clipOp) {
        Canvas canvas = this.internalCanvas;
        if (path instanceof AndroidPath) {
            canvas.clipPath(((AndroidPath) path).getInternalPath(), m4451toRegionOp7u2Bmg(clipOp));
            return;
        }
        throw new UnsupportedOperationException("Unable to obtain android.graphics.Path");
    }

    public final Region.Op m4451toRegionOp7u2Bmg(int i) {
        return ClipOp.m4574equalsimpl0(i, ClipOp.INSTANCE.m4578getDifferencertfAjoo()) ? Region.Op.DIFFERENCE : Region.Op.INTERSECT;
    }

    @Override
    public void mo4447drawLineWko1d7g(long p1, long p2, Paint paint) {
        this.internalCanvas.drawLine(Offset.m4346getXimpl(p1), Offset.m4347getYimpl(p1), Offset.m4346getXimpl(p2), Offset.m4347getYimpl(p2), paint.getInternalPaint());
    }

    @Override
    public void drawRect(float left, float top, float right, float bottom, Paint paint) {
        this.internalCanvas.drawRect(left, top, right, bottom, paint.getInternalPaint());
    }

    @Override
    public void drawRoundRect(float left, float top, float right, float bottom, float radiusX, float radiusY, Paint paint) {
        this.internalCanvas.drawRoundRect(left, top, right, bottom, radiusX, radiusY, paint.getInternalPaint());
    }

    @Override
    public void drawOval(float left, float top, float right, float bottom, Paint paint) {
        this.internalCanvas.drawOval(left, top, right, bottom, paint.getInternalPaint());
    }

    @Override
    public void mo4444drawCircle9KIMszo(long center, float radius, Paint paint) {
        this.internalCanvas.drawCircle(Offset.m4346getXimpl(center), Offset.m4347getYimpl(center), radius, paint.getInternalPaint());
    }

    @Override
    public void drawArc(float left, float top, float right, float bottom, float startAngle, float sweepAngle, boolean useCenter, Paint paint) {
        this.internalCanvas.drawArc(left, top, right, bottom, startAngle, sweepAngle, useCenter, paint.getInternalPaint());
    }

    @Override
    public void drawPath(Path path, Paint paint) {
        Canvas canvas = this.internalCanvas;
        if (path instanceof AndroidPath) {
            canvas.drawPath(((AndroidPath) path).getInternalPath(), paint.getInternalPaint());
            return;
        }
        throw new UnsupportedOperationException("Unable to obtain android.graphics.Path");
    }

    @Override
    public void mo4445drawImaged4ec7I(ImageBitmap image, long topLeftOffset, Paint paint) {
        this.internalCanvas.drawBitmap(AndroidImageBitmap_androidKt.asAndroidBitmap(image), Offset.m4346getXimpl(topLeftOffset), Offset.m4347getYimpl(topLeftOffset), paint.getInternalPaint());
    }

    @Override
    public void mo4446drawImageRectHPBpro0(ImageBitmap image, long srcOffset, long srcSize, long dstOffset, long dstSize, Paint paint) {
        if (this.srcRect == null) {
            this.srcRect = new Rect();
            this.dstRect = new Rect();
        }
        Canvas canvas = this.internalCanvas;
        Bitmap bitmapAsAndroidBitmap = AndroidImageBitmap_androidKt.asAndroidBitmap(image);
        Rect rect = this.srcRect;
        Intrinsics.checkNotNull(rect);
        rect.left = IntOffset.getX-impl(srcOffset);
        rect.top = IntOffset.getY-impl(srcOffset);
        rect.right = IntOffset.getX-impl(srcOffset) + IntSize.getWidth-impl(srcSize);
        rect.bottom = IntOffset.getY-impl(srcOffset) + IntSize.getHeight-impl(srcSize);
        Unit unit = Unit.INSTANCE;
        Rect rect2 = this.dstRect;
        Intrinsics.checkNotNull(rect2);
        rect2.left = IntOffset.getX-impl(dstOffset);
        rect2.top = IntOffset.getY-impl(dstOffset);
        rect2.right = IntOffset.getX-impl(dstOffset) + IntSize.getWidth-impl(dstSize);
        rect2.bottom = IntOffset.getY-impl(dstOffset) + IntSize.getHeight-impl(dstSize);
        Unit unit2 = Unit.INSTANCE;
        canvas.drawBitmap(bitmapAsAndroidBitmap, rect, rect2, paint.getInternalPaint());
    }

    @Override
    public void mo4448drawPointsO7TthRY(int pointMode, List<Offset> points, Paint paint) {
        if (PointMode.m4899equalsimpl0(pointMode, PointMode.INSTANCE.m4903getLinesr_lszbg())) {
            drawLines(points, paint, 2);
        } else if (PointMode.m4899equalsimpl0(pointMode, PointMode.INSTANCE.m4905getPolygonr_lszbg())) {
            drawLines(points, paint, 1);
        } else if (PointMode.m4899equalsimpl0(pointMode, PointMode.INSTANCE.m4904getPointsr_lszbg())) {
            drawPoints(points, paint);
        }
    }

    @Override
    public void enableZ() {
        CanvasUtils.INSTANCE.enableZ(this.internalCanvas, true);
    }

    @Override
    public void disableZ() {
        CanvasUtils.INSTANCE.enableZ(this.internalCanvas, false);
    }

    private final void drawLines(List<Offset> points, Paint paint, int stepBy) {
        if (points.size() >= 2) {
            Paint paintAsFrameworkPaint = paint.getInternalPaint();
            int i = 0;
            while (i < points.size() - 1) {
                long packedValue = points.get(i).getPackedValue();
                long packedValue2 = points.get(i + 1).getPackedValue();
                this.internalCanvas.drawLine(Offset.m4346getXimpl(packedValue), Offset.m4347getYimpl(packedValue), Offset.m4346getXimpl(packedValue2), Offset.m4347getYimpl(packedValue2), paintAsFrameworkPaint);
                i += stepBy;
            }
        }
    }

    @Override
    public void mo4449drawRawPointsO7TthRY(int pointMode, float[] points, Paint paint) {
        if (points.length % 2 != 0) {
            throw new IllegalArgumentException("points must have an even number of values");
        }
        if (PointMode.m4899equalsimpl0(pointMode, PointMode.INSTANCE.m4903getLinesr_lszbg())) {
            drawRawLines(points, paint, 2);
        } else if (PointMode.m4899equalsimpl0(pointMode, PointMode.INSTANCE.m4905getPolygonr_lszbg())) {
            drawRawLines(points, paint, 1);
        } else if (PointMode.m4899equalsimpl0(pointMode, PointMode.INSTANCE.m4904getPointsr_lszbg())) {
            drawRawPoints(points, paint, 2);
        }
    }

    private final void drawRawPoints(float[] points, Paint paint, int stepBy) {
        if (points.length % 2 == 0) {
            Paint paintAsFrameworkPaint = paint.getInternalPaint();
            int i = 0;
            while (i < points.length - 1) {
                this.internalCanvas.drawPoint(points[i], points[i + 1], paintAsFrameworkPaint);
                i += stepBy;
            }
        }
    }

    private final void drawRawLines(float[] points, Paint paint, int stepBy) {
        if (points.length < 4 || points.length % 2 != 0) {
            return;
        }
        Paint paintAsFrameworkPaint = paint.getInternalPaint();
        int i = 0;
        while (i < points.length - 3) {
            this.internalCanvas.drawLine(points[i], points[i + 1], points[i + 2], points[i + 3], paintAsFrameworkPaint);
            i += stepBy * 2;
        }
    }

    @Override
    public void mo4450drawVerticesTPEHhCM(Vertices vertices, int blendMode, Paint paint) {
        this.internalCanvas.drawVertices(AndroidVertexMode_androidKt.m4494toAndroidVertexModeJOOmi9M(vertices.getVertexMode()), vertices.getPositions().length, vertices.getPositions(), 0, vertices.getTextureCoordinates(), 0, vertices.getColors(), 0, vertices.getIndices(), 0, vertices.getIndices().length, paint.getInternalPaint());
    }

    private final void drawPoints(List<Offset> points, Paint paint) {
        int size = points.size();
        for (int i = 0; i < size; i++) {
            long packedValue = points.get(i).getPackedValue();
            this.internalCanvas.drawPoint(Offset.m4346getXimpl(packedValue), Offset.m4347getYimpl(packedValue), paint.getInternalPaint());
        }
    }
}
