package androidx.compose.p002ui.node;

import androidx.compose.p002ui.graphics.AndroidPaint_androidKt;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.Paint;
import androidx.compose.p002ui.graphics.PaintingStyle;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.layout.AlignmentLine;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.runtime.collection.MutableVector;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u0088\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 C2\u00020\u0001:\u0002CDB\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u0015H\u0016J\b\u0010\u0016\u001a\u00020\u0017H\u0016J:\u0010\u0018\u001a\u00020\u00172\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020 H\u0016ø\u0001\u0000¢\u0006\u0004\b\"\u0010#J\u0010\u0010$\u001a\u00020\u00132\u0006\u0010%\u001a\u00020\u0013H\u0016J\u0010\u0010&\u001a\u00020\u00132\u0006\u0010'\u001a\u00020\u0013H\u0016J\u001a\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+H\u0016ø\u0001\u0000¢\u0006\u0004\b,\u0010-J\u0010\u0010.\u001a\u00020\u00132\u0006\u0010%\u001a\u00020\u0013H\u0016J\u0010\u0010/\u001a\u00020\u00132\u0006\u0010'\u001a\u00020\u0013H\u0016J\b\u00100\u001a\u00020\u0017H\u0002J\u001a\u00101\u001a\u00020\u00172\u0006\u00102\u001a\u0002032\b\u00104\u001a\u0004\u0018\u000105H\u0016J=\u00106\u001a\u00020\u00172\u0006\u00107\u001a\u0002082\u0006\u00109\u001a\u00020:2\u0019\u0010;\u001a\u0015\u0012\u0004\u0012\u00020=\u0012\u0004\u0012\u00020\u0017\u0018\u00010<¢\u0006\u0002\b>H\u0014ø\u0001\u0000¢\u0006\u0004\b?\u0010@J*\u00106\u001a\u00020\u00172\u0006\u00107\u001a\u0002082\u0006\u00109\u001a\u00020:2\u0006\u0010A\u001a\u000205H\u0014ø\u0001\u0000¢\u0006\u0004\b?\u0010BR(\u0010\u0007\u001a\u0004\u0018\u00010\u00062\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006@TX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u001a\u0010\f\u001a\u00020\rX\u0096\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000e\u0010\u000f\u001a\u0004\b\u0010\u0010\u0011\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006E"}, d2 = {"Landroidx/compose/ui/node/InnerNodeCoordinator;", "Landroidx/compose/ui/node/NodeCoordinator;", "layoutNode", "Landroidx/compose/ui/node/LayoutNode;", "(Landroidx/compose/ui/node/LayoutNode;)V", "<set-?>", "Landroidx/compose/ui/node/LookaheadDelegate;", "lookaheadDelegate", "getLookaheadDelegate", "()Landroidx/compose/ui/node/LookaheadDelegate;", "setLookaheadDelegate", "(Landroidx/compose/ui/node/LookaheadDelegate;)V", "tail", "Landroidx/compose/ui/node/TailModifierNode;", "getTail$annotations", "()V", "getTail", "()Landroidx/compose/ui/node/TailModifierNode;", "calculateAlignmentLine", "", "alignmentLine", "Landroidx/compose/ui/layout/AlignmentLine;", "ensureLookaheadDelegateCreated", "", "hitTestChild", "hitTestSource", "Landroidx/compose/ui/node/NodeCoordinator$HitTestSource;", "pointerPosition", "Landroidx/compose/ui/geometry/Offset;", "hitTestResult", "Landroidx/compose/ui/node/HitTestResult;", "isTouchEvent", "", "isInLayer", "hitTestChild-YqVAtuI", "(Landroidx/compose/ui/node/NodeCoordinator$HitTestSource;JLandroidx/compose/ui/node/HitTestResult;ZZ)V", "maxIntrinsicHeight", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/Placeable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-BRTryo0", "(J)Landroidx/compose/ui/layout/Placeable;", "minIntrinsicHeight", "minIntrinsicWidth", "onAfterPlaceAt", "performDraw", "canvas", "Landroidx/compose/ui/graphics/Canvas;", "graphicsLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "placeAt", "position", "Landroidx/compose/ui/unit/IntOffset;", "zIndex", "", "layerBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/GraphicsLayerScope;", "Lkotlin/ExtensionFunctionType;", "placeAt-f8xVGno", "(JFLkotlin/jvm/functions/Function1;)V", "layer", "(JFLandroidx/compose/ui/graphics/layer/GraphicsLayer;)V", "Companion", "LookaheadDelegateImpl", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class InnerNodeCoordinator extends NodeCoordinator {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private static final Paint innerBoundsPaint;
    private LookaheadDelegate lookaheadDelegate;
    private final TailModifierNode tail;

    public static void getTail$annotations() {
    }

    public InnerNodeCoordinator(LayoutNode layoutNode) {
        super(layoutNode);
        this.tail = new TailModifierNode();
        getTail().updateCoordinator$ui_release(this);
        this.lookaheadDelegate = layoutNode.getLookaheadRoot() != null ? new LookaheadDelegateImpl() : null;
    }

    @Override
    public TailModifierNode getTail() {
        return this.tail;
    }

    @Override
    public LookaheadDelegate getLookaheadDelegate() {
        return this.lookaheadDelegate;
    }

    @Override
    protected void setLookaheadDelegate(LookaheadDelegate lookaheadDelegate) {
        this.lookaheadDelegate = lookaheadDelegate;
    }

    @Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\b\u0082\u0004\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0016J\u0010\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0016J\u0010\u0010\t\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u0004H\u0016J\u001a\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0016ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010J\u0010\u0010\u0011\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u0004H\u0016J\u0010\u0010\u0012\u001a\u00020\u00042\u0006\u0010\n\u001a\u00020\u0004H\u0016J\b\u0010\u0013\u001a\u00020\u0014H\u0014\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0015"}, d2 = {"Landroidx/compose/ui/node/InnerNodeCoordinator$LookaheadDelegateImpl;", "Landroidx/compose/ui/node/LookaheadDelegate;", "(Landroidx/compose/ui/node/InnerNodeCoordinator;)V", "calculateAlignmentLine", "", "alignmentLine", "Landroidx/compose/ui/layout/AlignmentLine;", "maxIntrinsicHeight", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/Placeable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-BRTryo0", "(J)Landroidx/compose/ui/layout/Placeable;", "minIntrinsicHeight", "minIntrinsicWidth", "placeChildren", "", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private final class LookaheadDelegateImpl extends LookaheadDelegate {
        public LookaheadDelegateImpl() {
            super(InnerNodeCoordinator.this);
        }

        @Override
        public Placeable mo6026measureBRTryo0(long constraints) {
            LookaheadDelegateImpl lookaheadDelegateImpl = this;
            lookaheadDelegateImpl.m6134setMeasurementConstraintsBRTryo0(constraints);
            MutableVector<LayoutNode> mutableVector = getLayoutNode().get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LayoutNodeLayoutDelegate.LookaheadPassDelegate lookaheadPassDelegate$ui_release = content[i].getLookaheadPassDelegate$ui_release();
                    Intrinsics.checkNotNull(lookaheadPassDelegate$ui_release);
                    lookaheadPassDelegate$ui_release.setMeasuredByParent$ui_release(LayoutNode.UsageByParent.NotUsed);
                    i++;
                } while (i < size);
            }
            lookaheadDelegateImpl.set_measureResult(getLayoutNode().getMeasurePolicy().mo296measure3p2s80s(this, getLayoutNode().getChildLookaheadMeasurables$ui_release(), constraints));
            return lookaheadDelegateImpl;
        }

        @Override
        public int calculateAlignmentLine(AlignmentLine alignmentLine) {
            Integer num = getAlignmentLinesOwner().calculateAlignmentLines().get(alignmentLine);
            int iIntValue = num != null ? num.intValue() : Integer.MIN_VALUE;
            getCachedAlignmentLinesMap().put(alignmentLine, Integer.valueOf(iIntValue));
            return iIntValue;
        }

        @Override
        protected void placeChildren() {
            LayoutNodeLayoutDelegate.LookaheadPassDelegate lookaheadPassDelegate$ui_release = getLayoutNode().getLookaheadPassDelegate$ui_release();
            Intrinsics.checkNotNull(lookaheadPassDelegate$ui_release);
            lookaheadPassDelegate$ui_release.onNodePlaced$ui_release();
        }

        @Override
        public int minIntrinsicWidth(int height) {
            return getLayoutNode().minLookaheadIntrinsicWidth(height);
        }

        @Override
        public int minIntrinsicHeight(int width) {
            return getLayoutNode().minLookaheadIntrinsicHeight(width);
        }

        @Override
        public int maxIntrinsicWidth(int height) {
            return getLayoutNode().maxLookaheadIntrinsicWidth(height);
        }

        @Override
        public int maxIntrinsicHeight(int width) {
            return getLayoutNode().maxLookaheadIntrinsicHeight(width);
        }
    }

    @Override
    public void ensureLookaheadDelegateCreated() {
        if (getLookaheadDelegate() == null) {
            setLookaheadDelegate(new LookaheadDelegateImpl());
        }
    }

    @Override
    public Placeable mo6026measureBRTryo0(long constraints) {
        if (getForceMeasureWithLookaheadConstraints()) {
            LookaheadDelegate lookaheadDelegate = getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            constraints = lookaheadDelegate.m6307getConstraintsmsEJaDk$ui_release();
        }
        m6134setMeasurementConstraintsBRTryo0(constraints);
        MutableVector<LayoutNode> mutableVector = getLayoutNode().get_children$ui_release();
        int size = mutableVector.getSize();
        if (size > 0) {
            LayoutNode[] content = mutableVector.getContent();
            int i = 0;
            do {
                content[i].getMeasurePassDelegate$ui_release().setMeasuredByParent$ui_release(LayoutNode.UsageByParent.NotUsed);
                i++;
            } while (i < size);
        }
        setMeasureResult$ui_release(getLayoutNode().getMeasurePolicy().mo296measure3p2s80s(this, getLayoutNode().getChildMeasurables$ui_release(), constraints));
        onMeasured();
        return this;
    }

    @Override
    public int minIntrinsicWidth(int height) {
        return getLayoutNode().minIntrinsicWidth(height);
    }

    @Override
    public int minIntrinsicHeight(int width) {
        return getLayoutNode().minIntrinsicHeight(width);
    }

    @Override
    public int maxIntrinsicWidth(int height) {
        return getLayoutNode().maxIntrinsicWidth(height);
    }

    @Override
    public int maxIntrinsicHeight(int width) {
        return getLayoutNode().maxIntrinsicHeight(width);
    }

    @Override
    protected void mo6132placeAtf8xVGno(long position, float zIndex, GraphicsLayer layer) throws KotlinNothingValueException {
        super.mo6132placeAtf8xVGno(position, zIndex, layer);
        onAfterPlaceAt();
    }

    @Override
    protected void mo6027placeAtf8xVGno(long position, float zIndex, Function1<? super GraphicsLayerScope, Unit> layerBlock) throws KotlinNothingValueException {
        super.mo6027placeAtf8xVGno(position, zIndex, layerBlock);
        onAfterPlaceAt();
    }

    private final void onAfterPlaceAt() {
        if (getIsShallowPlacing()) {
            return;
        }
        onPlaced();
        getLayoutNode().getMeasurePassDelegate$ui_release().onNodePlaced$ui_release();
    }

    @Override
    public int calculateAlignmentLine(AlignmentLine alignmentLine) {
        LookaheadDelegate lookaheadDelegate = getLookaheadDelegate();
        if (lookaheadDelegate != null) {
            return lookaheadDelegate.calculateAlignmentLine(alignmentLine);
        }
        Integer num = getAlignmentLinesOwner().calculateAlignmentLines().get(alignmentLine);
        if (num != null) {
            return num.intValue();
        }
        return Integer.MIN_VALUE;
    }

    @Override
    public void performDraw(Canvas canvas, GraphicsLayer graphicsLayer) throws KotlinNothingValueException {
        Owner ownerRequireOwner = LayoutNodeKt.requireOwner(getLayoutNode());
        MutableVector<LayoutNode> zSortedChildren = getLayoutNode().getZSortedChildren();
        int size = zSortedChildren.getSize();
        if (size > 0) {
            LayoutNode[] content = zSortedChildren.getContent();
            int i = 0;
            do {
                LayoutNode layoutNode = content[i];
                if (layoutNode.isPlaced()) {
                    layoutNode.draw$ui_release(canvas, graphicsLayer);
                }
                i++;
            } while (i < size);
        }
        if (ownerRequireOwner.getShowLayoutBounds()) {
            drawBorder(canvas, innerBoundsPaint);
        }
    }

    @Override
    public void mo6223hitTestChildYqVAtuI(NodeCoordinator.HitTestSource hitTestSource, long pointerPosition, HitTestResult hitTestResult, boolean isTouchEvent, boolean isInLayer) {
        boolean z;
        boolean z2 = false;
        if (hitTestSource.shouldHitTestChildren(getLayoutNode())) {
            if (m6355withinLayerBoundsk4lQ0M(pointerPosition)) {
                z = isInLayer;
            } else {
                if (isTouchEvent) {
                    float f = m6343distanceInMinimumTouchTargettz77jQw(pointerPosition, m6346getMinimumTouchTargetSizeNHjbRc());
                    if (!Float.isInfinite(f) && !Float.isNaN(f)) {
                        z = false;
                    }
                }
                z = isInLayer;
            }
            z2 = true;
        } else {
            z = isInLayer;
        }
        if (z2) {
            int i = hitTestResult.hitDepth;
            MutableVector<LayoutNode> zSortedChildren = getLayoutNode().getZSortedChildren();
            int size = zSortedChildren.getSize();
            if (size > 0) {
                LayoutNode[] content = zSortedChildren.getContent();
                int i2 = size - 1;
                do {
                    LayoutNode layoutNode = content[i2];
                    if (layoutNode.isPlaced()) {
                        hitTestSource.mo6356childHitTestYqVAtuI(layoutNode, pointerPosition, hitTestResult, isTouchEvent, z);
                        if (!hitTestResult.hasHit()) {
                            i2--;
                        } else {
                            if (!hitTestResult.getShouldSharePointerInputWithSibling()) {
                                break;
                            }
                            hitTestResult.acceptHits();
                            i2--;
                        }
                    } else {
                        i2--;
                    }
                } while (i2 >= 0);
            }
            hitTestResult.hitDepth = i;
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/ui/node/InnerNodeCoordinator$Companion;", "", "()V", "innerBoundsPaint", "Landroidx/compose/ui/graphics/Paint;", "getInnerBoundsPaint", "()Landroidx/compose/ui/graphics/Paint;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final Paint getInnerBoundsPaint() {
            return InnerNodeCoordinator.innerBoundsPaint;
        }
    }

    static {
        Paint Paint = AndroidPaint_androidKt.Paint();
        Paint.mo4467setColor8_81llA(Color.INSTANCE.m4624getRed0d7_KjU());
        Paint.setStrokeWidth(1.0f);
        Paint.mo4471setStylek9PVt8s(PaintingStyle.INSTANCE.m4865getStrokeTiuSbCo());
        innerBoundsPaint = Paint;
    }
}
