package androidx.compose.p002ui.node;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.geometry.MutableRect;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.ReusableGraphicsLayerScope;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000h\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\b`\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H&J\u001a\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\bH&J\b\u0010\t\u001a\u00020\u0003H&J\u001a\u0010\n\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\fH&ø\u0001\u0000¢\u0006\u0004\b\r\u0010\u000eJ\u001a\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012H&ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014J\u0018\u0010\u0015\u001a\u00020\u00032\u0006\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0010H&J\"\u0010\u0019\u001a\u00020\u00122\u0006\u0010\u001a\u001a\u00020\u00122\u0006\u0010\u0018\u001a\u00020\u0010H&ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001cJ\u001a\u0010\u001d\u001a\u00020\u00032\u0006\u0010\u0011\u001a\u00020\u001eH&ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010 J\u001a\u0010!\u001a\u00020\u00032\u0006\u0010\"\u001a\u00020#H&ø\u0001\u0000¢\u0006\u0004\b$\u0010 JP\u0010%\u001a\u00020\u000328\u0010&\u001a4\u0012\u0013\u0012\u00110\u0006¢\u0006\f\b(\u0012\b\b)\u0012\u0004\b\b(\u0005\u0012\u0015\u0012\u0013\u0018\u00010\b¢\u0006\f\b(\u0012\b\b)\u0012\u0004\b\b(\u0007\u0012\u0004\u0012\u00020\u00030'2\f\u0010*\u001a\b\u0012\u0004\u0012\u00020\u00030+H&J\u001a\u0010,\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\fH&ø\u0001\u0000¢\u0006\u0004\b-\u0010\u000eJ\b\u0010.\u001a\u00020\u0003H&J\u0010\u0010/\u001a\u00020\u00032\u0006\u00100\u001a\u000201H&ø\u0001\u0001\u0082\u0002\r\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u00062À\u0006\u0001"}, d2 = {"Landroidx/compose/ui/node/OwnedLayer;", "", "destroy", "", "drawLayer", "canvas", "Landroidx/compose/ui/graphics/Canvas;", "parentLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "invalidate", "inverseTransform", "matrix", "Landroidx/compose/ui/graphics/Matrix;", "inverseTransform-58bKbWc", "([F)V", "isInLayer", "", "position", "Landroidx/compose/ui/geometry/Offset;", "isInLayer-k-4lQ0M", "(J)Z", "mapBounds", "rect", "Landroidx/compose/ui/geometry/MutableRect;", "inverse", "mapOffset", "point", "mapOffset-8S9VItk", "(JZ)J", "move", "Landroidx/compose/ui/unit/IntOffset;", "move--gyyYBs", "(J)V", "resize", "size", "Landroidx/compose/ui/unit/IntSize;", "resize-ozmzZPI", "reuseLayer", "drawBlock", "Lkotlin/Function2;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "invalidateParentLayer", "Lkotlin/Function0;", "transform", "transform-58bKbWc", "updateDisplayList", "updateLayerProperties", "scope", "Landroidx/compose/ui/graphics/ReusableGraphicsLayerScope;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface OwnedLayer {
    void destroy();

    void drawLayer(Canvas canvas, GraphicsLayer parentLayer);

    void invalidate();

    void mo6414inverseTransform58bKbWc(float[] matrix);

    boolean mo6415isInLayerk4lQ0M(long position);

    void mapBounds(MutableRect rect, boolean inverse);

    long mo6416mapOffset8S9VItk(long point, boolean inverse);

    void mo6417movegyyYBs(long position);

    void mo6418resizeozmzZPI(long size);

    void reuseLayer(Function2<? super Canvas, ? super GraphicsLayer, Unit> drawBlock, Function0<Unit> invalidateParentLayer);

    void mo6419transform58bKbWc(float[] matrix);

    void updateDisplayList();

    void updateLayerProperties(ReusableGraphicsLayerScope scope);
}
