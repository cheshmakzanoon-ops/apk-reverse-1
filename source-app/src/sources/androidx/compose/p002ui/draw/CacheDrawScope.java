package androidx.compose.p002ui.draw;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.drawscope.DrawContext;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000l\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u0007\b\u0000¢\u0006\u0002\u0010\u0002J\u0006\u0010*\u001a\u00020+J\u001f\u0010,\u001a\u00020\u00142\u0017\u0010-\u001a\u0013\u0012\u0004\u0012\u00020/\u0012\u0004\u0012\u0002000.¢\u0006\u0002\b1J\u001f\u00102\u001a\u00020\u00142\u0017\u0010-\u001a\u0013\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u0002000.¢\u0006\u0002\b1JK\u00103\u001a\u000200*\u00020+2\b\b\u0002\u0010\u000f\u001a\u00020\u00012\b\b\u0002\u0010\"\u001a\u00020#2\b\b\u0002\u0010&\u001a\u0002042\u0017\u0010-\u001a\u0013\u0012\u0004\u0012\u00020\n\u0012\u0004\u0012\u0002000.¢\u0006\u0002\b1ø\u0001\u0000¢\u0006\u0004\b5\u00106R\u001a\u0010\u0003\u001a\u00020\u0004X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0005\u0010\u0006\"\u0004\b\u0007\u0010\bR\u001c\u0010\t\u001a\u0004\u0018\u00010\nX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\u0014\u0010\u000f\u001a\u00020\u00108VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0012R\u001c\u0010\u0013\u001a\u0004\u0018\u00010\u0014X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0019\u001a\u00020\u00108VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001a\u0010\u0012R\"\u0010\u001b\u001a\n\u0012\u0004\u0012\u00020\u001d\u0018\u00010\u001cX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u001f\"\u0004\b \u0010!R\u0011\u0010\"\u001a\u00020#8F¢\u0006\u0006\u001a\u0004\b$\u0010%R\u0017\u0010&\u001a\u00020'8Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b(\u0010)\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u00067"}, d2 = {"Landroidx/compose/ui/draw/CacheDrawScope;", "Landroidx/compose/ui/unit/Density;", "()V", "cacheParams", "Landroidx/compose/ui/draw/BuildDrawCacheParams;", "getCacheParams$ui_release", "()Landroidx/compose/ui/draw/BuildDrawCacheParams;", "setCacheParams$ui_release", "(Landroidx/compose/ui/draw/BuildDrawCacheParams;)V", "contentDrawScope", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "getContentDrawScope$ui_release", "()Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "setContentDrawScope$ui_release", "(Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;)V", "density", "", "getDensity", "()F", "drawResult", "Landroidx/compose/ui/draw/DrawResult;", "getDrawResult$ui_release", "()Landroidx/compose/ui/draw/DrawResult;", "setDrawResult$ui_release", "(Landroidx/compose/ui/draw/DrawResult;)V", "fontScale", "getFontScale", "graphicsContextProvider", "Lkotlin/Function0;", "Landroidx/compose/ui/graphics/GraphicsContext;", "getGraphicsContextProvider$ui_release", "()Lkotlin/jvm/functions/Function0;", "setGraphicsContextProvider$ui_release", "(Lkotlin/jvm/functions/Function0;)V", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "size", "Landroidx/compose/ui/geometry/Size;", "getSize-NH-jbRc", "()J", "obtainGraphicsLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "onDrawBehind", "block", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "", "Lkotlin/ExtensionFunctionType;", "onDrawWithContent", "record", "Landroidx/compose/ui/unit/IntSize;", "record-TdoYBX4", "(Landroidx/compose/ui/graphics/layer/GraphicsLayer;Landroidx/compose/ui/unit/Density;Landroidx/compose/ui/unit/LayoutDirection;JLkotlin/jvm/functions/Function1;)V", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class CacheDrawScope implements Density {
    public static final int $stable = 0;
    private BuildDrawCacheParams cacheParams = EmptyBuildDrawCacheParams.INSTANCE;
    private ContentDrawScope contentDrawScope;
    private DrawResult drawResult;
    private Function0<? extends GraphicsContext> graphicsContextProvider;

    public int m4219roundToPxR2X_6o(long j) {
        return Density.-CC.$default$roundToPx--R2X_6o(this, j);
    }

    public int m4220roundToPx0680j_4(float f) {
        return Density.-CC.$default$roundToPx-0680j_4(this, f);
    }

    public float m4221toDpGaN1DYA(long j) {
        return FontScaling.-CC.$default$toDp-GaN1DYA(this, j);
    }

    public float m4222toDpu2uoSUM(float f) {
        return Density.-CC.$default$toDp-u2uoSUM(this, f);
    }

    public float m4223toDpu2uoSUM(int i) {
        return Density.-CC.$default$toDp-u2uoSUM(this, i);
    }

    public long m4224toDpSizekrfVVM(long j) {
        return Density.-CC.$default$toDpSize-k-rfVVM(this, j);
    }

    public float m4225toPxR2X_6o(long j) {
        return Density.-CC.$default$toPx--R2X_6o(this, j);
    }

    public float m4226toPx0680j_4(float f) {
        return Density.-CC.$default$toPx-0680j_4(this, f);
    }

    public Rect toRect(DpRect dpRect) {
        return Density.-CC.$default$toRect(this, dpRect);
    }

    public long m4227toSizeXkaWNTQ(long j) {
        return Density.-CC.$default$toSize-XkaWNTQ(this, j);
    }

    public long m4228toSp0xMU5do(float f) {
        return FontScaling.-CC.$default$toSp-0xMU5do(this, f);
    }

    public long m4229toSpkPz2Gy4(float f) {
        return Density.-CC.$default$toSp-kPz2Gy4(this, f);
    }

    public long m4230toSpkPz2Gy4(int i) {
        return Density.-CC.$default$toSp-kPz2Gy4(this, i);
    }

    public final BuildDrawCacheParams getCacheParams() {
        return this.cacheParams;
    }

    public final void setCacheParams$ui_release(BuildDrawCacheParams buildDrawCacheParams) {
        this.cacheParams = buildDrawCacheParams;
    }

    public final DrawResult getDrawResult() {
        return this.drawResult;
    }

    public final void setDrawResult$ui_release(DrawResult drawResult) {
        this.drawResult = drawResult;
    }

    public final ContentDrawScope getContentDrawScope() {
        return this.contentDrawScope;
    }

    public final void setContentDrawScope$ui_release(ContentDrawScope contentDrawScope) {
        this.contentDrawScope = contentDrawScope;
    }

    public final Function0<GraphicsContext> getGraphicsContextProvider$ui_release() {
        return this.graphicsContextProvider;
    }

    public final void setGraphicsContextProvider$ui_release(Function0<? extends GraphicsContext> function0) {
        this.graphicsContextProvider = function0;
    }

    public final long m4217getSizeNHjbRc() {
        return this.cacheParams.mo4213getSizeNHjbRc();
    }

    public final LayoutDirection getLayoutDirection() {
        return this.cacheParams.getLayoutDirection();
    }

    public final GraphicsLayer obtainGraphicsLayer() {
        Function0<? extends GraphicsContext> function0 = this.graphicsContextProvider;
        Intrinsics.checkNotNull(function0);
        return ((GraphicsContext) function0.invoke()).createGraphicsLayer();
    }

    public static void m4216recordTdoYBX4$default(CacheDrawScope cacheDrawScope, GraphicsLayer graphicsLayer, Density density, LayoutDirection layoutDirection, long j, Function1 function1, int i, Object obj) {
        if ((i & 1) != 0) {
            density = cacheDrawScope;
        }
        Density density2 = density;
        if ((i & 2) != 0) {
            layoutDirection = cacheDrawScope.getLayoutDirection();
        }
        LayoutDirection layoutDirection2 = layoutDirection;
        if ((i & 4) != 0) {
            j = IntSizeKt.toIntSize-uvyYCjk(cacheDrawScope.m4217getSizeNHjbRc());
        }
        cacheDrawScope.m4218recordTdoYBX4(graphicsLayer, density2, layoutDirection2, j, function1);
    }

    public final void m4218recordTdoYBX4(GraphicsLayer graphicsLayer, final Density density, final LayoutDirection layoutDirection, final long j, final Function1<? super ContentDrawScope, Unit> function1) {
        graphicsLayer.m5277recordmLhObY(density, layoutDirection, j, new Function1<DrawScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((DrawScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(DrawScope drawScope) {
                ContentDrawScope contentDrawScope = this.this$0.getContentDrawScope();
                Intrinsics.checkNotNull(contentDrawScope);
                Density density2 = density;
                LayoutDirection layoutDirection2 = layoutDirection;
                long j2 = j;
                Function1<ContentDrawScope, Unit> function2 = function1;
                Canvas canvas = drawScope.getDrawContext().getCanvas();
                ContentDrawScope contentDrawScope2 = contentDrawScope;
                long jSize = SizeKt.Size(IntSize.getWidth-impl(j2), IntSize.getHeight-impl(j2));
                Density density3 = contentDrawScope2.getDrawContext().getDensity();
                LayoutDirection layoutDirection3 = contentDrawScope2.getDrawContext().getLayoutDirection();
                Canvas canvas2 = contentDrawScope2.getDrawContext().getCanvas();
                long jMo5102getSizeNHjbRc = contentDrawScope2.getDrawContext().mo5102getSizeNHjbRc();
                GraphicsLayer graphicsLayer2 = contentDrawScope2.getDrawContext().getGraphicsLayer();
                DrawContext drawContext = contentDrawScope2.getDrawContext();
                drawContext.setDensity(density2);
                drawContext.setLayoutDirection(layoutDirection2);
                drawContext.setCanvas(canvas);
                drawContext.mo5103setSizeuvyYCjk(jSize);
                drawContext.setGraphicsLayer(null);
                canvas.save();
                try {
                    function2.invoke(contentDrawScope);
                } finally {
                    canvas.restore();
                    DrawContext drawContext2 = contentDrawScope2.getDrawContext();
                    drawContext2.setDensity(density3);
                    drawContext2.setLayoutDirection(layoutDirection3);
                    drawContext2.setCanvas(canvas2);
                    drawContext2.mo5103setSizeuvyYCjk(jMo5102getSizeNHjbRc);
                    drawContext2.setGraphicsLayer(graphicsLayer2);
                }
            }
        });
    }

    public final DrawResult onDrawBehind(final Function1<? super DrawScope, Unit> block) {
        return onDrawWithContent(new Function1<ContentDrawScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((ContentDrawScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(ContentDrawScope contentDrawScope) {
                block.invoke(contentDrawScope);
                contentDrawScope.drawContent();
            }
        });
    }

    public final DrawResult onDrawWithContent(Function1<? super ContentDrawScope, Unit> block) {
        DrawResult drawResult = new DrawResult(block);
        this.drawResult = drawResult;
        return drawResult;
    }

    public float getDensity() {
        return this.cacheParams.getDensity().getDensity();
    }

    public float getFontScale() {
        return this.cacheParams.getDensity().getFontScale();
    }
}
