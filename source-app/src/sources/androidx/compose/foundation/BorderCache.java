package androidx.compose.foundation;

import androidx.compose.p002ui.draw.CacheDrawScope;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.BlendMode;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.ImageBitmap;
import androidx.compose.p002ui.graphics.ImageBitmapConfig;
import androidx.compose.p002ui.graphics.ImageBitmapKt;
import androidx.compose.p002ui.graphics.Path;
import androidx.compose.p002ui.graphics.drawscope.CanvasDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0082\b\u0018\u00002\u00020\u0001B5\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nJ\u000b\u0010\u000b\u001a\u0004\u0018\u00010\u0003HÂ\u0003J\u000b\u0010\f\u001a\u0004\u0018\u00010\u0005HÂ\u0003J\u000b\u0010\r\u001a\u0004\u0018\u00010\u0007HÂ\u0003J\u000b\u0010\u000e\u001a\u0004\u0018\u00010\tHÂ\u0003J9\u0010\u000f\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\tHÆ\u0001J\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\u0006\u0010\u0015\u001a\u00020\tJ\t\u0010\u0016\u001a\u00020\u0017HÖ\u0001J@\u0010\u0018\u001a\u00020\u0003*\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00020\u001d2\u0017\u0010\u001e\u001a\u0013\u0012\u0004\u0012\u00020 \u0012\u0004\u0012\u00020!0\u001f¢\u0006\u0002\b\"H\u0086\bø\u0001\u0000¢\u0006\u0004\b#\u0010$R\u0010\u0010\b\u001a\u0004\u0018\u00010\tX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0006\u001a\u0004\u0018\u00010\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006%"}, d2 = {"Landroidx/compose/foundation/BorderCache;", "", "imageBitmap", "Landroidx/compose/ui/graphics/ImageBitmap;", "canvas", "Landroidx/compose/ui/graphics/Canvas;", "canvasDrawScope", "Landroidx/compose/ui/graphics/drawscope/CanvasDrawScope;", "borderPath", "Landroidx/compose/ui/graphics/Path;", "(Landroidx/compose/ui/graphics/ImageBitmap;Landroidx/compose/ui/graphics/Canvas;Landroidx/compose/ui/graphics/drawscope/CanvasDrawScope;Landroidx/compose/ui/graphics/Path;)V", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "", "obtainPath", "toString", "", "drawBorderCache", "Landroidx/compose/ui/draw/CacheDrawScope;", "borderSize", "Landroidx/compose/ui/unit/IntSize;", "config", "Landroidx/compose/ui/graphics/ImageBitmapConfig;", "block", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "", "Lkotlin/ExtensionFunctionType;", "drawBorderCache-EMwLDEs", "(Landroidx/compose/ui/draw/CacheDrawScope;JILkotlin/jvm/functions/Function1;)Landroidx/compose/ui/graphics/ImageBitmap;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class BorderCache {
    private Path borderPath;
    private Canvas canvas;
    private CanvasDrawScope canvasDrawScope;
    private ImageBitmap imageBitmap;

    public BorderCache() {
        this(null, null, null, null, 15, null);
    }

    private final ImageBitmap getImageBitmap() {
        return this.imageBitmap;
    }

    private final Canvas getCanvas() {
        return this.canvas;
    }

    private final CanvasDrawScope getCanvasDrawScope() {
        return this.canvasDrawScope;
    }

    private final Path getBorderPath() {
        return this.borderPath;
    }

    public static BorderCache copy$default(BorderCache borderCache, ImageBitmap imageBitmap, Canvas canvas, CanvasDrawScope canvasDrawScope, Path path, int i, Object obj) {
        if ((i & 1) != 0) {
            imageBitmap = borderCache.imageBitmap;
        }
        if ((i & 2) != 0) {
            canvas = borderCache.canvas;
        }
        if ((i & 4) != 0) {
            canvasDrawScope = borderCache.canvasDrawScope;
        }
        if ((i & 8) != 0) {
            path = borderCache.borderPath;
        }
        return borderCache.copy(imageBitmap, canvas, canvasDrawScope, path);
    }

    public final BorderCache copy(ImageBitmap imageBitmap, Canvas canvas, CanvasDrawScope canvasDrawScope, Path borderPath) {
        return new BorderCache(imageBitmap, canvas, canvasDrawScope, borderPath);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof BorderCache)) {
            return false;
        }
        BorderCache borderCache = (BorderCache) other;
        return Intrinsics.areEqual(this.imageBitmap, borderCache.imageBitmap) && Intrinsics.areEqual(this.canvas, borderCache.canvas) && Intrinsics.areEqual(this.canvasDrawScope, borderCache.canvasDrawScope) && Intrinsics.areEqual(this.borderPath, borderCache.borderPath);
    }

    public int hashCode() {
        ImageBitmap imageBitmap = this.imageBitmap;
        int iHashCode = (imageBitmap == null ? 0 : imageBitmap.hashCode()) * 31;
        Canvas canvas = this.canvas;
        int iHashCode2 = (iHashCode + (canvas == null ? 0 : canvas.hashCode())) * 31;
        CanvasDrawScope canvasDrawScope = this.canvasDrawScope;
        int iHashCode3 = (iHashCode2 + (canvasDrawScope == null ? 0 : canvasDrawScope.hashCode())) * 31;
        Path path = this.borderPath;
        return iHashCode3 + (path != null ? path.hashCode() : 0);
    }

    public String toString() {
        return "BorderCache(imageBitmap=" + this.imageBitmap + ", canvas=" + this.canvas + ", canvasDrawScope=" + this.canvasDrawScope + ", borderPath=" + this.borderPath + ')';
    }

    public BorderCache(ImageBitmap imageBitmap, Canvas canvas, CanvasDrawScope canvasDrawScope, Path path) {
        this.imageBitmap = imageBitmap;
        this.canvas = canvas;
        this.canvasDrawScope = canvasDrawScope;
        this.borderPath = path;
    }

    public BorderCache(ImageBitmap imageBitmap, Canvas canvas, CanvasDrawScope canvasDrawScope, Path path, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : imageBitmap, (i & 2) != 0 ? null : canvas, (i & 4) != 0 ? null : canvasDrawScope, (i & 8) != 0 ? null : path);
    }

    public final ImageBitmap m530drawBorderCacheEMwLDEs(CacheDrawScope cacheDrawScope, long j, int i, Function1<? super DrawScope, Unit> function1) {
        CanvasDrawScope canvasDrawScope;
        ImageBitmap imageBitmapM4823ImageBitmapx__hDU$default = this.imageBitmap;
        Canvas Canvas = this.canvas;
        ImageBitmapConfig imageBitmapConfigM4810boximpl = imageBitmapM4823ImageBitmapx__hDU$default != null ? ImageBitmapConfig.m4810boximpl(imageBitmapM4823ImageBitmapx__hDU$default.mo4455getConfig_sVssgQ()) : null;
        boolean z = false;
        if (!(imageBitmapConfigM4810boximpl == null ? false : ImageBitmapConfig.m4813equalsimpl0(imageBitmapConfigM4810boximpl.m4816unboximpl(), ImageBitmapConfig.INSTANCE.m4818getArgb8888_sVssgQ()))) {
            if (ImageBitmapConfig.m4812equalsimpl(i, imageBitmapM4823ImageBitmapx__hDU$default != null ? ImageBitmapConfig.m4810boximpl(imageBitmapM4823ImageBitmapx__hDU$default.mo4455getConfig_sVssgQ()) : null)) {
            }
            if (imageBitmapM4823ImageBitmapx__hDU$default != null || Canvas == null || Size.m4415getWidthimpl(cacheDrawScope.m4217getSizeNHjbRc()) > imageBitmapM4823ImageBitmapx__hDU$default.getWidth() || Size.m4412getHeightimpl(cacheDrawScope.m4217getSizeNHjbRc()) > imageBitmapM4823ImageBitmapx__hDU$default.getHeight() || !z) {
                imageBitmapM4823ImageBitmapx__hDU$default = ImageBitmapKt.m4823ImageBitmapx__hDU$default(IntSize.getWidth-impl(j), IntSize.getHeight-impl(j), i, false, null, 24, null);
                this.imageBitmap = imageBitmapM4823ImageBitmapx__hDU$default;
                Canvas = androidx.compose.p002ui.graphics.CanvasKt.Canvas(imageBitmapM4823ImageBitmapx__hDU$default);
                this.canvas = Canvas;
            }
            canvasDrawScope = this.canvasDrawScope;
            if (canvasDrawScope == null) {
                canvasDrawScope = new CanvasDrawScope();
                this.canvasDrawScope = canvasDrawScope;
            }
            long j2 = IntSizeKt.toSize-ozmzZPI(j);
            LayoutDirection layoutDirection = cacheDrawScope.getLayoutDirection();
            CanvasDrawScope.DrawParams drawParams = canvasDrawScope.getDrawParams();
            Density density = drawParams.getDensity();
            LayoutDirection layoutDirection2 = drawParams.getLayoutDirection();
            Canvas canvas = drawParams.getCanvas();
            long size = drawParams.getSize();
            CanvasDrawScope.DrawParams drawParams2 = canvasDrawScope.getDrawParams();
            drawParams2.setDensity(cacheDrawScope);
            drawParams2.setLayoutDirection(layoutDirection);
            drawParams2.setCanvas(Canvas);
            drawParams2.m5101setSizeuvyYCjk(j2);
            Canvas.save();
            CanvasDrawScope canvasDrawScope2 = canvasDrawScope;
            DrawScope.CC.m5180drawRectnJ9OG0$default(canvasDrawScope2, Color.INSTANCE.m4616getBlack0d7_KjU(), 0L, j2, 0.0f, null, null, BlendMode.INSTANCE.m4505getClear0nO6VwU(), 58, null);
            function1.invoke(canvasDrawScope2);
            Canvas.restore();
            CanvasDrawScope.DrawParams drawParams3 = canvasDrawScope.getDrawParams();
            drawParams3.setDensity(density);
            drawParams3.setLayoutDirection(layoutDirection2);
            drawParams3.setCanvas(canvas);
            drawParams3.m5101setSizeuvyYCjk(size);
            imageBitmapM4823ImageBitmapx__hDU$default.prepareToDraw();
            return imageBitmapM4823ImageBitmapx__hDU$default;
        }
        z = true;
        if (imageBitmapM4823ImageBitmapx__hDU$default != null) {
            imageBitmapM4823ImageBitmapx__hDU$default = ImageBitmapKt.m4823ImageBitmapx__hDU$default(IntSize.getWidth-impl(j), IntSize.getHeight-impl(j), i, false, null, 24, null);
            this.imageBitmap = imageBitmapM4823ImageBitmapx__hDU$default;
            Canvas = androidx.compose.p002ui.graphics.CanvasKt.Canvas(imageBitmapM4823ImageBitmapx__hDU$default);
            this.canvas = Canvas;
        } else {
            imageBitmapM4823ImageBitmapx__hDU$default = ImageBitmapKt.m4823ImageBitmapx__hDU$default(IntSize.getWidth-impl(j), IntSize.getHeight-impl(j), i, false, null, 24, null);
            this.imageBitmap = imageBitmapM4823ImageBitmapx__hDU$default;
            Canvas = androidx.compose.p002ui.graphics.CanvasKt.Canvas(imageBitmapM4823ImageBitmapx__hDU$default);
            this.canvas = Canvas;
        }
        canvasDrawScope = this.canvasDrawScope;
        if (canvasDrawScope == null) {
            canvasDrawScope = new CanvasDrawScope();
            this.canvasDrawScope = canvasDrawScope;
        }
        long j3 = IntSizeKt.toSize-ozmzZPI(j);
        LayoutDirection layoutDirection3 = cacheDrawScope.getLayoutDirection();
        CanvasDrawScope.DrawParams drawParams4 = canvasDrawScope.getDrawParams();
        Density density2 = drawParams4.getDensity();
        LayoutDirection layoutDirection4 = drawParams4.getLayoutDirection();
        Canvas canvas2 = drawParams4.getCanvas();
        long size2 = drawParams4.getSize();
        CanvasDrawScope.DrawParams drawParams5 = canvasDrawScope.getDrawParams();
        drawParams5.setDensity(cacheDrawScope);
        drawParams5.setLayoutDirection(layoutDirection3);
        drawParams5.setCanvas(Canvas);
        drawParams5.m5101setSizeuvyYCjk(j3);
        Canvas.save();
        CanvasDrawScope canvasDrawScope3 = canvasDrawScope;
        DrawScope.CC.m5180drawRectnJ9OG0$default(canvasDrawScope3, Color.INSTANCE.m4616getBlack0d7_KjU(), 0L, j3, 0.0f, null, null, BlendMode.INSTANCE.m4505getClear0nO6VwU(), 58, null);
        function1.invoke(canvasDrawScope3);
        Canvas.restore();
        CanvasDrawScope.DrawParams drawParams6 = canvasDrawScope.getDrawParams();
        drawParams6.setDensity(density2);
        drawParams6.setLayoutDirection(layoutDirection4);
        drawParams6.setCanvas(canvas2);
        drawParams6.m5101setSizeuvyYCjk(size2);
        imageBitmapM4823ImageBitmapx__hDU$default.prepareToDraw();
        return imageBitmapM4823ImageBitmapx__hDU$default;
    }

    public final Path obtainPath() {
        Path path = this.borderPath;
        if (path != null) {
            return path;
        }
        Path Path = AndroidPath_androidKt.Path();
        this.borderPath = Path;
        return Path;
    }
}
