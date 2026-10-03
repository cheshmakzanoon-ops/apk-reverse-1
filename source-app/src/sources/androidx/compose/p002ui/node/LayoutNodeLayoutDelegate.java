package androidx.compose.p002ui.node;

import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.layout.AlignmentLine;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import java.util.List;
import java.util.Map;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u001c\b\u0000\u0018\u00002\u00020\u0001:\u0002ghB\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\r\u0010R\u001a\u00020MH\u0000¢\u0006\u0002\bSJ\u0006\u0010T\u001a\u00020MJ\u0006\u0010U\u001a\u00020MJ\r\u0010V\u001a\u00020MH\u0000¢\u0006\u0002\bWJ\r\u0010X\u001a\u00020MH\u0000¢\u0006\u0002\bYJ\r\u0010Z\u001a\u00020MH\u0000¢\u0006\u0002\b[J\r\u0010\\\u001a\u00020MH\u0000¢\u0006\u0002\b]J\u0006\u0010^\u001a\u00020MJ\u001a\u0010_\u001a\u00020M2\u0006\u0010`\u001a\u00020\"H\u0002ø\u0001\u0000¢\u0006\u0004\ba\u0010bJ\u001a\u0010c\u001a\u00020M2\u0006\u0010`\u001a\u00020\"H\u0002ø\u0001\u0000¢\u0006\u0004\bd\u0010bJ\u0006\u0010e\u001a\u00020MJ\u0006\u0010f\u001a\u00020MR\u0014\u0010\u0005\u001a\u00020\u00068@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\bR$\u0010\u000b\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR$\u0010\u0010\u001a\u00020\n2\u0006\u0010\t\u001a\u00020\n@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\r\"\u0004\b\u0012\u0010\u000fR$\u0010\u0014\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R$\u0010\u0019\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u0016\"\u0004\b\u001b\u0010\u0018R\u001e\u0010\u001d\u001a\u00020\u00132\u0006\u0010\u001c\u001a\u00020\u0013@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0016R\u0014\u0010\u001f\u001a\u00020\n8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b \u0010\rR\u0019\u0010!\u001a\u0004\u0018\u00010\"8Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b#\u0010$R\u0019\u0010%\u001a\u0004\u0018\u00010\"8Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b&\u0010$R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010'\u001a\u00020\u00132\u0006\u0010\u001c\u001a\u00020\u0013@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u0016R\u000e\u0010)\u001a\u00020\u0013X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010+\u001a\u00020*2\u0006\u0010\u001c\u001a\u00020*@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b,\u0010-R\u0016\u0010.\u001a\u0004\u0018\u00010\u00068@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b/\u0010\bR$\u00100\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b1\u0010\u0016\"\u0004\b2\u0010\u0018R$\u00103\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013@FX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b4\u0010\u0016\"\u0004\b5\u0010\u0018R\u001e\u00106\u001a\u00020\u00132\u0006\u0010\u001c\u001a\u00020\u0013@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b7\u0010\u0016R\u000e\u00108\u001a\u00020\u0013X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u00109\u001a\u00020\u00132\u0006\u0010\u001c\u001a\u00020\u0013@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b:\u0010\u0016R*\u0010<\u001a\b\u0018\u00010;R\u00020\u00002\f\u0010\u001c\u001a\b\u0018\u00010;R\u00020\u0000@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b=\u0010>R\u0018\u0010?\u001a\u00060@R\u00020\u0000X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\bA\u0010BR\u001e\u0010C\u001a\u00020\u00132\u0006\u0010\u001c\u001a\u00020\u0013@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bD\u0010\u0016R\u000e\u0010E\u001a\u00020\nX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010F\u001a\u00020\nX\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010G\u001a\u00020H8F¢\u0006\u0006\u001a\u0004\bI\u0010JR\u0014\u0010K\u001a\b\u0012\u0004\u0012\u00020M0LX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010N\u001a\u00020\"X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010OR\u0014\u0010P\u001a\u00020\n8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bQ\u0010\r\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006i"}, d2 = {"Landroidx/compose/ui/node/LayoutNodeLayoutDelegate;", "", "layoutNode", "Landroidx/compose/ui/node/LayoutNode;", "(Landroidx/compose/ui/node/LayoutNode;)V", "alignmentLinesOwner", "Landroidx/compose/ui/node/AlignmentLinesOwner;", "getAlignmentLinesOwner$ui_release", "()Landroidx/compose/ui/node/AlignmentLinesOwner;", "value", "", "childrenAccessingCoordinatesDuringPlacement", "getChildrenAccessingCoordinatesDuringPlacement", "()I", "setChildrenAccessingCoordinatesDuringPlacement", "(I)V", "childrenAccessingLookaheadCoordinatesDuringPlacement", "getChildrenAccessingLookaheadCoordinatesDuringPlacement", "setChildrenAccessingLookaheadCoordinatesDuringPlacement", "", "coordinatesAccessedDuringModifierPlacement", "getCoordinatesAccessedDuringModifierPlacement", "()Z", "setCoordinatesAccessedDuringModifierPlacement", "(Z)V", "coordinatesAccessedDuringPlacement", "getCoordinatesAccessedDuringPlacement", "setCoordinatesAccessedDuringPlacement", "<set-?>", "detachedFromParentLookaheadPass", "getDetachedFromParentLookaheadPass$ui_release", "height", "getHeight$ui_release", "lastConstraints", "Landroidx/compose/ui/unit/Constraints;", "getLastConstraints-DWUhwKw", "()Landroidx/compose/ui/unit/Constraints;", "lastLookaheadConstraints", "getLastLookaheadConstraints-DWUhwKw", "layoutPending", "getLayoutPending$ui_release", "layoutPendingForAlignment", "Landroidx/compose/ui/node/LayoutNode$LayoutState;", "layoutState", "getLayoutState$ui_release", "()Landroidx/compose/ui/node/LayoutNode$LayoutState;", "lookaheadAlignmentLinesOwner", "getLookaheadAlignmentLinesOwner$ui_release", "lookaheadCoordinatesAccessedDuringModifierPlacement", "getLookaheadCoordinatesAccessedDuringModifierPlacement", "setLookaheadCoordinatesAccessedDuringModifierPlacement", "lookaheadCoordinatesAccessedDuringPlacement", "getLookaheadCoordinatesAccessedDuringPlacement", "setLookaheadCoordinatesAccessedDuringPlacement", "lookaheadLayoutPending", "getLookaheadLayoutPending$ui_release", "lookaheadLayoutPendingForAlignment", "lookaheadMeasurePending", "getLookaheadMeasurePending$ui_release", "Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$LookaheadPassDelegate;", "lookaheadPassDelegate", "getLookaheadPassDelegate$ui_release", "()Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$LookaheadPassDelegate;", "measurePassDelegate", "Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$MeasurePassDelegate;", "getMeasurePassDelegate$ui_release", "()Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$MeasurePassDelegate;", "measurePending", "getMeasurePending$ui_release", "nextChildLookaheadPlaceOrder", "nextChildPlaceOrder", "outerCoordinator", "Landroidx/compose/ui/node/NodeCoordinator;", "getOuterCoordinator", "()Landroidx/compose/ui/node/NodeCoordinator;", "performMeasureBlock", "Lkotlin/Function0;", "", "performMeasureConstraints", "J", "width", "getWidth$ui_release", "ensureLookaheadDelegateCreated", "ensureLookaheadDelegateCreated$ui_release", "invalidateParentData", "markChildrenDirty", "markLayoutPending", "markLayoutPending$ui_release", "markLookaheadLayoutPending", "markLookaheadLayoutPending$ui_release", "markLookaheadMeasurePending", "markLookaheadMeasurePending$ui_release", "markMeasurePending", "markMeasurePending$ui_release", "onCoordinatesUsed", "performLookaheadMeasure", "constraints", "performLookaheadMeasure-BRTryo0", "(J)V", "performMeasure", "performMeasure-BRTryo0", "resetAlignmentLines", "updateParentData", "LookaheadPassDelegate", "MeasurePassDelegate", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LayoutNodeLayoutDelegate {
    public static final int $stable = 8;
    private int childrenAccessingCoordinatesDuringPlacement;
    private int childrenAccessingLookaheadCoordinatesDuringPlacement;
    private boolean coordinatesAccessedDuringModifierPlacement;
    private boolean coordinatesAccessedDuringPlacement;
    private boolean detachedFromParentLookaheadPass;
    private final LayoutNode layoutNode;
    private boolean layoutPending;
    private boolean layoutPendingForAlignment;
    private boolean lookaheadCoordinatesAccessedDuringModifierPlacement;
    private boolean lookaheadCoordinatesAccessedDuringPlacement;
    private boolean lookaheadLayoutPending;
    private boolean lookaheadLayoutPendingForAlignment;
    private boolean lookaheadMeasurePending;
    private LookaheadPassDelegate lookaheadPassDelegate;
    private boolean measurePending;
    private int nextChildLookaheadPlaceOrder;
    private int nextChildPlaceOrder;
    private LayoutNode.LayoutState layoutState = LayoutNode.LayoutState.Idle;
    private final MeasurePassDelegate measurePassDelegate = new MeasurePassDelegate();
    private long performMeasureConstraints = ConstraintsKt.Constraints$default(0, 0, 0, 0, 15, (Object) null);
    private final Function0<Unit> performMeasureBlock = new Function0<Unit>() {
        {
            super(0);
        }

        public Object invoke() {
            m6278invoke();
            return Unit.INSTANCE;
        }

        public final void m6278invoke() {
            this.this$0.getOuterCoordinator().mo6026measureBRTryo0(this.this$0.performMeasureConstraints);
        }
    };

    public LayoutNodeLayoutDelegate(LayoutNode layoutNode) {
        this.layoutNode = layoutNode;
    }

    public final NodeCoordinator getOuterCoordinator() {
        return this.layoutNode.getNodes().getOuterCoordinator();
    }

    public final Constraints m6263getLastConstraintsDWUhwKw() {
        return this.measurePassDelegate.m6273getLastConstraintsDWUhwKw();
    }

    public final Constraints m6264getLastLookaheadConstraintsDWUhwKw() {
        LookaheadPassDelegate lookaheadPassDelegate = this.lookaheadPassDelegate;
        if (lookaheadPassDelegate != null) {
            return lookaheadPassDelegate.getLookaheadConstraints();
        }
        return null;
    }

    public final int getHeight$ui_release() {
        return this.measurePassDelegate.getHeight();
    }

    public final int getWidth$ui_release() {
        return this.measurePassDelegate.getWidth();
    }

    public final boolean getDetachedFromParentLookaheadPass() {
        return this.detachedFromParentLookaheadPass;
    }

    public final LayoutNode.LayoutState getLayoutState() {
        return this.layoutState;
    }

    public final boolean getMeasurePending() {
        return this.measurePending;
    }

    public final boolean getLayoutPending() {
        return this.layoutPending;
    }

    public final boolean getLookaheadMeasurePending() {
        return this.lookaheadMeasurePending;
    }

    public final boolean getLookaheadLayoutPending() {
        return this.lookaheadLayoutPending;
    }

    public final void markLayoutPending$ui_release() {
        this.layoutPending = true;
        this.layoutPendingForAlignment = true;
    }

    public final void markMeasurePending$ui_release() {
        this.measurePending = true;
    }

    public final void markLookaheadLayoutPending$ui_release() {
        this.lookaheadLayoutPending = true;
        this.lookaheadLayoutPendingForAlignment = true;
    }

    public final void markLookaheadMeasurePending$ui_release() {
        this.lookaheadMeasurePending = true;
    }

    public final AlignmentLinesOwner getAlignmentLinesOwner$ui_release() {
        return this.measurePassDelegate;
    }

    public final AlignmentLinesOwner getLookaheadAlignmentLinesOwner$ui_release() {
        return this.lookaheadPassDelegate;
    }

    public final boolean getCoordinatesAccessedDuringPlacement() {
        return this.coordinatesAccessedDuringPlacement;
    }

    public final void setCoordinatesAccessedDuringPlacement(boolean z) {
        if (this.coordinatesAccessedDuringPlacement != z) {
            this.coordinatesAccessedDuringPlacement = z;
            if (z && !this.coordinatesAccessedDuringModifierPlacement) {
                setChildrenAccessingCoordinatesDuringPlacement(this.childrenAccessingCoordinatesDuringPlacement + 1);
            } else {
                if (z || this.coordinatesAccessedDuringModifierPlacement) {
                    return;
                }
                setChildrenAccessingCoordinatesDuringPlacement(this.childrenAccessingCoordinatesDuringPlacement - 1);
            }
        }
    }

    public final boolean getCoordinatesAccessedDuringModifierPlacement() {
        return this.coordinatesAccessedDuringModifierPlacement;
    }

    public final void setCoordinatesAccessedDuringModifierPlacement(boolean z) {
        if (this.coordinatesAccessedDuringModifierPlacement != z) {
            this.coordinatesAccessedDuringModifierPlacement = z;
            if (z && !this.coordinatesAccessedDuringPlacement) {
                setChildrenAccessingCoordinatesDuringPlacement(this.childrenAccessingCoordinatesDuringPlacement + 1);
            } else {
                if (z || this.coordinatesAccessedDuringPlacement) {
                    return;
                }
                setChildrenAccessingCoordinatesDuringPlacement(this.childrenAccessingCoordinatesDuringPlacement - 1);
            }
        }
    }

    public final int getChildrenAccessingCoordinatesDuringPlacement() {
        return this.childrenAccessingCoordinatesDuringPlacement;
    }

    public final void setChildrenAccessingCoordinatesDuringPlacement(int i) {
        int i2 = this.childrenAccessingCoordinatesDuringPlacement;
        this.childrenAccessingCoordinatesDuringPlacement = i;
        if ((i2 == 0) != (i == 0)) {
            LayoutNode parent$ui_release = this.layoutNode.getParent$ui_release();
            LayoutNodeLayoutDelegate layoutDelegate = parent$ui_release != null ? parent$ui_release.getLayoutDelegate() : null;
            if (layoutDelegate != null) {
                if (i == 0) {
                    layoutDelegate.setChildrenAccessingCoordinatesDuringPlacement(layoutDelegate.childrenAccessingCoordinatesDuringPlacement - 1);
                } else {
                    layoutDelegate.setChildrenAccessingCoordinatesDuringPlacement(layoutDelegate.childrenAccessingCoordinatesDuringPlacement + 1);
                }
            }
        }
    }

    public final boolean getLookaheadCoordinatesAccessedDuringPlacement() {
        return this.lookaheadCoordinatesAccessedDuringPlacement;
    }

    public final void setLookaheadCoordinatesAccessedDuringPlacement(boolean z) {
        if (this.lookaheadCoordinatesAccessedDuringPlacement != z) {
            this.lookaheadCoordinatesAccessedDuringPlacement = z;
            if (z && !this.lookaheadCoordinatesAccessedDuringModifierPlacement) {
                setChildrenAccessingLookaheadCoordinatesDuringPlacement(this.childrenAccessingLookaheadCoordinatesDuringPlacement + 1);
            } else {
                if (z || this.lookaheadCoordinatesAccessedDuringModifierPlacement) {
                    return;
                }
                setChildrenAccessingLookaheadCoordinatesDuringPlacement(this.childrenAccessingLookaheadCoordinatesDuringPlacement - 1);
            }
        }
    }

    public final boolean getLookaheadCoordinatesAccessedDuringModifierPlacement() {
        return this.lookaheadCoordinatesAccessedDuringModifierPlacement;
    }

    public final void setLookaheadCoordinatesAccessedDuringModifierPlacement(boolean z) {
        if (this.lookaheadCoordinatesAccessedDuringModifierPlacement != z) {
            this.lookaheadCoordinatesAccessedDuringModifierPlacement = z;
            if (z && !this.lookaheadCoordinatesAccessedDuringPlacement) {
                setChildrenAccessingLookaheadCoordinatesDuringPlacement(this.childrenAccessingLookaheadCoordinatesDuringPlacement + 1);
            } else {
                if (z || this.lookaheadCoordinatesAccessedDuringPlacement) {
                    return;
                }
                setChildrenAccessingLookaheadCoordinatesDuringPlacement(this.childrenAccessingLookaheadCoordinatesDuringPlacement - 1);
            }
        }
    }

    public final int getChildrenAccessingLookaheadCoordinatesDuringPlacement() {
        return this.childrenAccessingLookaheadCoordinatesDuringPlacement;
    }

    public final void setChildrenAccessingLookaheadCoordinatesDuringPlacement(int i) {
        int i2 = this.childrenAccessingLookaheadCoordinatesDuringPlacement;
        this.childrenAccessingLookaheadCoordinatesDuringPlacement = i;
        if ((i2 == 0) != (i == 0)) {
            LayoutNode parent$ui_release = this.layoutNode.getParent$ui_release();
            LayoutNodeLayoutDelegate layoutDelegate = parent$ui_release != null ? parent$ui_release.getLayoutDelegate() : null;
            if (layoutDelegate != null) {
                if (i == 0) {
                    layoutDelegate.setChildrenAccessingLookaheadCoordinatesDuringPlacement(layoutDelegate.childrenAccessingLookaheadCoordinatesDuringPlacement - 1);
                } else {
                    layoutDelegate.setChildrenAccessingLookaheadCoordinatesDuringPlacement(layoutDelegate.childrenAccessingLookaheadCoordinatesDuringPlacement + 1);
                }
            }
        }
    }

    public final MeasurePassDelegate getMeasurePassDelegate() {
        return this.measurePassDelegate;
    }

    public final LookaheadPassDelegate getLookaheadPassDelegate() {
        return this.lookaheadPassDelegate;
    }

    public final void onCoordinatesUsed() {
        LayoutNode.LayoutState layoutState$ui_release = this.layoutNode.getLayoutState$ui_release();
        if (layoutState$ui_release == LayoutNode.LayoutState.LayingOut || layoutState$ui_release == LayoutNode.LayoutState.LookaheadLayingOut) {
            if (this.measurePassDelegate.getLayingOutChildren()) {
                setCoordinatesAccessedDuringPlacement(true);
            } else {
                setCoordinatesAccessedDuringModifierPlacement(true);
            }
        }
        if (layoutState$ui_release == LayoutNode.LayoutState.LookaheadLayingOut) {
            LookaheadPassDelegate lookaheadPassDelegate = this.lookaheadPassDelegate;
            if (lookaheadPassDelegate != null && lookaheadPassDelegate.getLayingOutChildren()) {
                setLookaheadCoordinatesAccessedDuringPlacement(true);
            } else {
                setLookaheadCoordinatesAccessedDuringModifierPlacement(true);
            }
        }
    }

    @Metadata(d1 = {"\u0000¤\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\n\n\u0002\u0010\u0000\n\u0002\b\u0013\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b5\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0004\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0014\u0010_\u001a\u000e\u0012\u0004\u0012\u00020a\u0012\u0004\u0012\u00020A0`H\u0016J\b\u0010b\u001a\u00020/H\u0002J\b\u0010c\u001a\u00020/H\u0002J\u001c\u0010d\u001a\u00020/2\u0012\u0010e\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020/0-H\u0016J!\u0010f\u001a\u00020/2\u0016\u0010e\u001a\u0012\u0012\b\u0012\u00060\u0000R\u00020\b\u0012\u0004\u0012\u00020/0-H\u0082\bJ\u0011\u0010g\u001a\u00020A2\u0006\u0010h\u001a\u00020aH\u0096\u0002J\u000e\u0010i\u001a\u00020/2\u0006\u0010j\u001a\u00020\u0012J\u0006\u0010k\u001a\u00020/J\b\u0010l\u001a\u00020/H\u0016J\r\u0010m\u001a\u00020/H\u0000¢\u0006\u0002\bnJ\b\u0010o\u001a\u00020/H\u0002J\b\u0010p\u001a\u00020/H\u0002J\u0010\u0010q\u001a\u00020A2\u0006\u0010r\u001a\u00020AH\u0016J\u0010\u0010s\u001a\u00020A2\u0006\u0010t\u001a\u00020AH\u0016J\u001a\u0010u\u001a\u00020\u00022\u0006\u0010v\u001a\u00020'H\u0016ø\u0001\u0000¢\u0006\u0004\bw\u0010xJ\u0006\u0010y\u001a\u00020/J\u0010\u0010z\u001a\u00020A2\u0006\u0010r\u001a\u00020AH\u0016J\u0010\u0010{\u001a\u00020A2\u0006\u0010t\u001a\u00020AH\u0016J\u0006\u0010|\u001a\u00020/J\b\u0010}\u001a\u00020/H\u0002J\b\u0010~\u001a\u00020/H\u0002J\u0006\u0010\u007f\u001a\u00020/J\u000f\u0010\u0080\u0001\u001a\u00020/H\u0000¢\u0006\u0003\b\u0081\u0001JB\u0010\u0082\u0001\u001a\u00020/2\u0007\u0010\u0083\u0001\u001a\u0002022\u0006\u0010\\\u001a\u0002052\u001a\u0010\u0084\u0001\u001a\u0015\u0012\u0004\u0012\u00020.\u0012\u0004\u0012\u00020/\u0018\u00010-¢\u0006\u0002\b0H\u0014ø\u0001\u0000¢\u0006\u0006\b\u0085\u0001\u0010\u0086\u0001J/\u0010\u0082\u0001\u001a\u00020/2\u0007\u0010\u0083\u0001\u001a\u0002022\u0006\u0010\\\u001a\u0002052\u0007\u0010\u0087\u0001\u001a\u00020+H\u0014ø\u0001\u0000¢\u0006\u0006\b\u0085\u0001\u0010\u0088\u0001J\u0007\u0010\u0089\u0001\u001a\u00020/JM\u0010\u008a\u0001\u001a\u00020/2\u0007\u0010\u0083\u0001\u001a\u0002022\u0006\u0010\\\u001a\u0002052\u001a\u0010\u0084\u0001\u001a\u0015\u0012\u0004\u0012\u00020.\u0012\u0004\u0012\u00020/\u0018\u00010-¢\u0006\u0002\b02\t\u0010\u0087\u0001\u001a\u0004\u0018\u00010+H\u0002ø\u0001\u0000¢\u0006\u0006\b\u008b\u0001\u0010\u008c\u0001JM\u0010\u008d\u0001\u001a\u00020/2\u0007\u0010\u0083\u0001\u001a\u0002022\u0006\u0010\\\u001a\u0002052\u001a\u0010\u0084\u0001\u001a\u0015\u0012\u0004\u0012\u00020.\u0012\u0004\u0012\u00020/\u0018\u00010-¢\u0006\u0002\b02\t\u0010\u0087\u0001\u001a\u0004\u0018\u00010+H\u0002ø\u0001\u0000¢\u0006\u0006\b\u008e\u0001\u0010\u008c\u0001J\u001b\u0010\u008f\u0001\u001a\u00020\u00122\u0006\u0010v\u001a\u00020'ø\u0001\u0000¢\u0006\u0006\b\u0090\u0001\u0010\u0091\u0001J\u0007\u0010\u0092\u0001\u001a\u00020/J\t\u0010\u0093\u0001\u001a\u00020/H\u0016J\t\u0010\u0094\u0001\u001a\u00020/H\u0016J\u0013\u0010\u0095\u0001\u001a\u00020/2\b\u0010\u0096\u0001\u001a\u00030\u0097\u0001H\u0002J\u0007\u0010\u0098\u0001\u001a\u00020\u0012R\u0018\u0010\u0006\u001a\f\u0012\b\u0012\u00060\u0000R\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\u00020\nX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u001e\u0010\r\u001a\f\u0012\b\u0012\u00060\u0000R\u00020\b0\u000e8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010R\u001a\u0010\u0011\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0013\u0010\u0014\"\u0004\b\u0015\u0010\u0016R\u001a\u0010\u0017\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0014\"\u0004\b\u0019\u0010\u0016R\u0014\u0010\u001a\u001a\u00020\u001b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u001dR$\u0010\u001f\u001a\u00020\u00122\u0006\u0010\u001e\u001a\u00020\u0012@PX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010\u0014\"\u0004\b \u0010\u0016R$\u0010!\u001a\u00020\u00122\u0006\u0010\u001e\u001a\u00020\u0012@@X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\u0014\"\u0004\b\"\u0010\u0016R$\u0010$\u001a\u00020\u00122\u0006\u0010#\u001a\u00020\u0012@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b$\u0010\u0014\"\u0004\b%\u0010\u0016R\u0019\u0010&\u001a\u0004\u0018\u00010'8Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b(\u0010)R\u0010\u0010*\u001a\u0004\u0018\u00010+X\u0082\u000e¢\u0006\u0002\n\u0000R!\u0010,\u001a\u0015\u0012\u0004\u0012\u00020.\u0012\u0004\u0012\u00020/\u0018\u00010-¢\u0006\u0002\b0X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u00101\u001a\u000202X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u00103R\u000e\u00104\u001a\u000205X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u00106\u001a\u00020\u00122\u0006\u0010\u001e\u001a\u00020\u0012@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b7\u0010\u0014R\u0014\u00108\u001a\b\u0012\u0004\u0012\u00020/09X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010:\u001a\u00020;X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b<\u0010=\"\u0004\b>\u0010?R\u0014\u0010@\u001a\u00020A8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bB\u0010CR\u000e\u0010D\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010E\u001a\u00020A8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bF\u0010CR\u000e\u0010G\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010H\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010I\u001a\u0004\u0018\u00010\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bJ\u0010KR\"\u0010M\u001a\u0004\u0018\u00010L2\b\u0010\u001e\u001a\u0004\u0018\u00010L@RX\u0096\u000e¢\u0006\b\n\u0000\u001a\u0004\bN\u0010OR\u000e\u0010P\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010Q\u001a\u00020A2\u0006\u0010\u001e\u001a\u00020A@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bR\u0010CR\u0014\u0010S\u001a\b\u0012\u0004\u0012\u00020/09X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010T\u001a\u0004\u0018\u00010+X\u0082\u000e¢\u0006\u0002\n\u0000R!\u0010U\u001a\u0015\u0012\u0004\u0012\u00020.\u0012\u0004\u0012\u00020/\u0018\u00010-¢\u0006\u0002\b0X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010V\u001a\u000202X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u00103R\u000e\u0010W\u001a\u000205X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010X\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010Y\u001a\u00020A2\u0006\u0010\u001e\u001a\u00020A@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\bZ\u0010CR\u000e\u0010[\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u001e\u0010\\\u001a\u0002052\u0006\u0010\u001e\u001a\u000205@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b]\u0010^\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0099\u0001"}, d2 = {"Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$MeasurePassDelegate;", "Landroidx/compose/ui/layout/Measurable;", "Landroidx/compose/ui/layout/Placeable;", "Landroidx/compose/ui/node/AlignmentLinesOwner;", "Landroidx/compose/ui/node/MotionReferencePlacementDelegate;", "(Landroidx/compose/ui/node/LayoutNodeLayoutDelegate;)V", "_childDelegates", "Landroidx/compose/runtime/collection/MutableVector;", "Landroidx/compose/ui/node/LayoutNodeLayoutDelegate;", "alignmentLines", "Landroidx/compose/ui/node/AlignmentLines;", "getAlignmentLines", "()Landroidx/compose/ui/node/AlignmentLines;", "childDelegates", "", "getChildDelegates$ui_release", "()Ljava/util/List;", "childDelegatesDirty", "", "getChildDelegatesDirty$ui_release", "()Z", "setChildDelegatesDirty$ui_release", "(Z)V", "duringAlignmentLinesQuery", "getDuringAlignmentLinesQuery$ui_release", "setDuringAlignmentLinesQuery$ui_release", "innerCoordinator", "Landroidx/compose/ui/node/NodeCoordinator;", "getInnerCoordinator", "()Landroidx/compose/ui/node/NodeCoordinator;", "<set-?>", "isPlaced", "setPlaced$ui_release", "isPlacedByParent", "setPlacedByParent$ui_release", "new", "isPlacedUnderMotionFrameOfReference", "setPlacedUnderMotionFrameOfReference", "lastConstraints", "Landroidx/compose/ui/unit/Constraints;", "getLastConstraints-DWUhwKw", "()Landroidx/compose/ui/unit/Constraints;", "lastExplicitLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "lastLayerBlock", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/GraphicsLayerScope;", "", "Lkotlin/ExtensionFunctionType;", "lastPosition", "Landroidx/compose/ui/unit/IntOffset;", "J", "lastZIndex", "", "layingOutChildren", "getLayingOutChildren", "layoutChildrenBlock", "Lkotlin/Function0;", "measuredByParent", "Landroidx/compose/ui/node/LayoutNode$UsageByParent;", "getMeasuredByParent$ui_release", "()Landroidx/compose/ui/node/LayoutNode$UsageByParent;", "setMeasuredByParent$ui_release", "(Landroidx/compose/ui/node/LayoutNode$UsageByParent;)V", "measuredHeight", "", "getMeasuredHeight", "()I", "measuredOnce", "measuredWidth", "getMeasuredWidth", "needsCoordinatesUpdate", "onNodePlacedCalled", "parentAlignmentLinesOwner", "getParentAlignmentLinesOwner", "()Landroidx/compose/ui/node/AlignmentLinesOwner;", "", "parentData", "getParentData", "()Ljava/lang/Object;", "parentDataDirty", "placeOrder", "getPlaceOrder$ui_release", "placeOuterCoordinatorBlock", "placeOuterCoordinatorLayer", "placeOuterCoordinatorLayerBlock", "placeOuterCoordinatorPosition", "placeOuterCoordinatorZIndex", "placedOnce", "previousPlaceOrder", "getPreviousPlaceOrder$ui_release", "relayoutWithoutParentInProgress", "zIndex", "getZIndex$ui_release", "()F", "calculateAlignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "checkChildrenPlaceOrderForUpdates", "clearPlaceOrder", "forEachChildAlignmentLinesOwner", "block", "forEachChildDelegate", "get", "alignmentLine", "invalidateIntrinsicsParent", "forceRequest", "invalidateParentData", "layoutChildren", "markDetachedFromParentLookaheadPass", "markDetachedFromParentLookaheadPass$ui_release", "markNodeAndSubtreeAsPlaced", "markSubtreeAsNotPlaced", "maxIntrinsicHeight", "width", "maxIntrinsicWidth", "height", "measure", "constraints", "measure-BRTryo0", "(J)Landroidx/compose/ui/layout/Placeable;", "measureBasedOnLookahead", "minIntrinsicHeight", "minIntrinsicWidth", "notifyChildrenUsingCoordinatesWhilePlacing", "onBeforeLayoutChildren", "onIntrinsicsQueried", "onNodeDetached", "onNodePlaced", "onNodePlaced$ui_release", "placeAt", "position", "layerBlock", "placeAt-f8xVGno", "(JFLkotlin/jvm/functions/Function1;)V", "layer", "(JFLandroidx/compose/ui/graphics/layer/GraphicsLayer;)V", "placeBasedOnLookahead", "placeOuterCoordinator", "placeOuterCoordinator-MLgxB_4", "(JFLkotlin/jvm/functions/Function1;Landroidx/compose/ui/graphics/layer/GraphicsLayer;)V", "placeSelf", "placeSelf-MLgxB_4", "remeasure", "remeasure-BRTryo0", "(J)Z", "replace", "requestLayout", "requestMeasure", "trackMeasurementByParent", "node", "Landroidx/compose/ui/node/LayoutNode;", "updateParentData", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public final class MeasurePassDelegate extends Placeable implements Measurable, AlignmentLinesOwner, MotionReferencePlacementDelegate {
        private boolean duringAlignmentLinesQuery;
        private boolean isPlaced;
        private boolean isPlacedByParent;
        private boolean isPlacedUnderMotionFrameOfReference;
        private GraphicsLayer lastExplicitLayer;
        private Function1<? super GraphicsLayerScope, Unit> lastLayerBlock;
        private float lastZIndex;
        private boolean layingOutChildren;
        private boolean measuredOnce;
        private boolean needsCoordinatesUpdate;
        private boolean onNodePlacedCalled;
        private Object parentData;
        private final Function0<Unit> placeOuterCoordinatorBlock;
        private GraphicsLayer placeOuterCoordinatorLayer;
        private Function1<? super GraphicsLayerScope, Unit> placeOuterCoordinatorLayerBlock;
        private float placeOuterCoordinatorZIndex;
        private boolean placedOnce;
        private boolean relayoutWithoutParentInProgress;
        private float zIndex;
        private int previousPlaceOrder = Integer.MAX_VALUE;
        private int placeOrder = Integer.MAX_VALUE;
        private LayoutNode.UsageByParent measuredByParent = LayoutNode.UsageByParent.NotUsed;
        private long lastPosition = IntOffset.Companion.getZero-nOcc-ac();
        private boolean parentDataDirty = true;
        private final AlignmentLines alignmentLines = new LayoutNodeAlignmentLines(this);
        private final MutableVector<MeasurePassDelegate> _childDelegates = new MutableVector<>(new MeasurePassDelegate[16], 0);
        private boolean childDelegatesDirty = true;
        private final Function0<Unit> layoutChildrenBlock = new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() throws KotlinNothingValueException {
                m6275invoke();
                return Unit.INSTANCE;
            }

            public final void m6275invoke() throws KotlinNothingValueException {
                this.this$0.clearPlaceOrder();
                this.this$0.forEachChildAlignmentLinesOwner(new Function1<AlignmentLinesOwner, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((AlignmentLinesOwner) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(AlignmentLinesOwner alignmentLinesOwner) {
                        alignmentLinesOwner.getAlignmentLines().setUsedDuringParentLayout$ui_release(false);
                    }
                });
                this.this$0.getInnerCoordinator().getMeasureResult$ui_release().placeChildren();
                this.this$0.checkChildrenPlaceOrderForUpdates();
                this.this$0.forEachChildAlignmentLinesOwner(new Function1<AlignmentLinesOwner, Unit>() {
                    public Object invoke(Object obj) {
                        invoke((AlignmentLinesOwner) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(AlignmentLinesOwner alignmentLinesOwner) {
                        alignmentLinesOwner.getAlignmentLines().setPreviousUsedDuringParentLayout$ui_release(alignmentLinesOwner.getAlignmentLines().getUsedDuringParentLayout());
                    }
                });
            }
        };
        private long placeOuterCoordinatorPosition = IntOffset.Companion.getZero-nOcc-ac();

        @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;
            public static final int[] $EnumSwitchMapping$1;

            static {
                int[] iArr = new int[LayoutNode.LayoutState.values().length];
                try {
                    iArr[LayoutNode.LayoutState.Measuring.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[LayoutNode.LayoutState.LayingOut.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                $EnumSwitchMapping$0 = iArr;
                int[] iArr2 = new int[LayoutNode.UsageByParent.values().length];
                try {
                    iArr2[LayoutNode.UsageByParent.InMeasureBlock.ordinal()] = 1;
                } catch (NoSuchFieldError unused3) {
                }
                try {
                    iArr2[LayoutNode.UsageByParent.InLayoutBlock.ordinal()] = 2;
                } catch (NoSuchFieldError unused4) {
                }
                $EnumSwitchMapping$1 = iArr2;
            }
        }

        public MeasurePassDelegate() {
            this.placeOuterCoordinatorBlock = new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6276invoke();
                    return Unit.INSTANCE;
                }

                public final void m6276invoke() {
                    Placeable.PlacementScope placementScope;
                    NodeCoordinator wrappedBy = layoutNodeLayoutDelegate.getOuterCoordinator().getWrappedBy();
                    if (wrappedBy == null || (placementScope = wrappedBy.getPlacementScope()) == null) {
                        placementScope = LayoutNodeKt.requireOwner(layoutNodeLayoutDelegate.layoutNode).getPlacementScope();
                    }
                    Placeable.PlacementScope placementScope2 = placementScope;
                    LayoutNodeLayoutDelegate.MeasurePassDelegate measurePassDelegate = this;
                    LayoutNodeLayoutDelegate layoutNodeLayoutDelegate = layoutNodeLayoutDelegate;
                    Function1<? super GraphicsLayerScope, Unit> function1 = measurePassDelegate.placeOuterCoordinatorLayerBlock;
                    GraphicsLayer graphicsLayer = measurePassDelegate.placeOuterCoordinatorLayer;
                    if (graphicsLayer != null) {
                        placementScope2.m6150placeWithLayeraW9wM(layoutNodeLayoutDelegate.getOuterCoordinator(), measurePassDelegate.placeOuterCoordinatorPosition, graphicsLayer, measurePassDelegate.placeOuterCoordinatorZIndex);
                    } else if (function1 == null) {
                        placementScope2.m6141place70tqf50(layoutNodeLayoutDelegate.getOuterCoordinator(), measurePassDelegate.placeOuterCoordinatorPosition, measurePassDelegate.placeOuterCoordinatorZIndex);
                    } else {
                        placementScope2.m6149placeWithLayeraW9wM(layoutNodeLayoutDelegate.getOuterCoordinator(), measurePassDelegate.placeOuterCoordinatorPosition, measurePassDelegate.placeOuterCoordinatorZIndex, function1);
                    }
                }
            };
        }

        public final int getPreviousPlaceOrder() {
            return this.previousPlaceOrder;
        }

        public final int getPlaceOrder() {
            return this.placeOrder;
        }

        public final Constraints m6273getLastConstraintsDWUhwKw() {
            if (this.measuredOnce) {
                return Constraints.box-impl(getMeasurementConstraints());
            }
            return null;
        }

        public final LayoutNode.UsageByParent getMeasuredByParent() {
            return this.measuredByParent;
        }

        public final void setMeasuredByParent$ui_release(LayoutNode.UsageByParent usageByParent) {
            this.measuredByParent = usageByParent;
        }

        public final boolean getDuringAlignmentLinesQuery() {
            return this.duringAlignmentLinesQuery;
        }

        public final void setDuringAlignmentLinesQuery$ui_release(boolean z) {
            this.duringAlignmentLinesQuery = z;
        }

        @Override
        public Object getParentData() {
            return this.parentData;
        }

        @Override
        public boolean getIsPlaced() {
            return this.isPlaced;
        }

        public void setPlaced$ui_release(boolean z) {
            this.isPlaced = z;
        }

        public final boolean getIsPlacedByParent() {
            return this.isPlacedByParent;
        }

        public final void setPlacedByParent$ui_release(boolean z) {
            this.isPlacedByParent = z;
        }

        @Override
        public NodeCoordinator getInnerCoordinator() {
            return LayoutNodeLayoutDelegate.this.layoutNode.getInnerCoordinator$ui_release();
        }

        @Override
        public AlignmentLines getAlignmentLines() {
            return this.alignmentLines;
        }

        public final boolean getChildDelegatesDirty() {
            return this.childDelegatesDirty;
        }

        public final void setChildDelegatesDirty$ui_release(boolean z) {
            this.childDelegatesDirty = z;
        }

        public final List<MeasurePassDelegate> getChildDelegates$ui_release() {
            LayoutNodeLayoutDelegate.this.layoutNode.updateChildrenIfDirty$ui_release();
            if (!this.childDelegatesDirty) {
                return this._childDelegates.asMutableList();
            }
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            MutableVector<MeasurePassDelegate> mutableVector = this._childDelegates;
            MutableVector<LayoutNode> mutableVector2 = layoutNode.get_children$ui_release();
            int size = mutableVector2.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector2.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode2 = content[i];
                    if (mutableVector.getSize() <= i) {
                        mutableVector.add(layoutNode2.getLayoutDelegate().getMeasurePassDelegate());
                    } else {
                        mutableVector.set(i, layoutNode2.getLayoutDelegate().getMeasurePassDelegate());
                    }
                    i++;
                } while (i < size);
            }
            mutableVector.removeRange(layoutNode.getChildren$ui_release().size(), mutableVector.getSize());
            this.childDelegatesDirty = false;
            return this._childDelegates.asMutableList();
        }

        public final void markDetachedFromParentLookaheadPass$ui_release() {
            LayoutNodeLayoutDelegate.this.detachedFromParentLookaheadPass = true;
        }

        public final boolean getLayingOutChildren() {
            return this.layingOutChildren;
        }

        @Override
        public void layoutChildren() {
            this.layingOutChildren = true;
            getAlignmentLines().recalculateQueryOwner();
            if (LayoutNodeLayoutDelegate.this.getLayoutPending()) {
                onBeforeLayoutChildren();
            }
            if (LayoutNodeLayoutDelegate.this.layoutPendingForAlignment || (!this.duringAlignmentLinesQuery && !getInnerCoordinator().getIsPlacingForAlignment() && LayoutNodeLayoutDelegate.this.getLayoutPending())) {
                LayoutNodeLayoutDelegate.this.layoutPending = false;
                LayoutNode.LayoutState layoutState = LayoutNodeLayoutDelegate.this.getLayoutState();
                LayoutNodeLayoutDelegate.this.layoutState = LayoutNode.LayoutState.LayingOut;
                LayoutNodeLayoutDelegate.this.setCoordinatesAccessedDuringPlacement(false);
                LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
                LayoutNodeKt.requireOwner(layoutNode).getSnapshotObserver().observeLayoutSnapshotReads$ui_release(layoutNode, false, this.layoutChildrenBlock);
                LayoutNodeLayoutDelegate.this.layoutState = layoutState;
                if (getInnerCoordinator().getIsPlacingForAlignment() && LayoutNodeLayoutDelegate.this.getCoordinatesAccessedDuringPlacement()) {
                    requestLayout();
                }
                LayoutNodeLayoutDelegate.this.layoutPendingForAlignment = false;
            }
            if (getAlignmentLines().getUsedDuringParentLayout()) {
                getAlignmentLines().setPreviousUsedDuringParentLayout$ui_release(true);
            }
            if (getAlignmentLines().getDirty() && getAlignmentLines().getRequired$ui_release()) {
                getAlignmentLines().recalculate();
            }
            this.layingOutChildren = false;
        }

        public final void checkChildrenPlaceOrderForUpdates() throws KotlinNothingValueException {
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            MutableVector<LayoutNode> mutableVector = layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode2 = content[i];
                    if (layoutNode2.getMeasurePassDelegate$ui_release().previousPlaceOrder != layoutNode2.getPlaceOrder$ui_release()) {
                        layoutNode.onZSortedChildrenInvalidated$ui_release();
                        layoutNode.invalidateLayer$ui_release();
                        if (layoutNode2.getPlaceOrder$ui_release() == Integer.MAX_VALUE) {
                            layoutNode2.getMeasurePassDelegate$ui_release().markSubtreeAsNotPlaced();
                        }
                    }
                    i++;
                } while (i < size);
            }
        }

        private final void markSubtreeAsNotPlaced() throws KotlinNothingValueException {
            if (getIsPlaced()) {
                int i = 0;
                setPlaced$ui_release(false);
                LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
                NodeCoordinator wrapped = layoutNode.getInnerCoordinator$ui_release().getWrapped();
                for (NodeCoordinator outerCoordinator$ui_release = layoutNode.getOuterCoordinator$ui_release(); !Intrinsics.areEqual(outerCoordinator$ui_release, wrapped) && outerCoordinator$ui_release != null; outerCoordinator$ui_release = outerCoordinator$ui_release.getWrapped()) {
                    outerCoordinator$ui_release.releaseLayer();
                }
                MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
                int size = mutableVector.getSize();
                if (size > 0) {
                    LayoutNode[] content = mutableVector.getContent();
                    do {
                        content[i].getMeasurePassDelegate$ui_release().markSubtreeAsNotPlaced();
                        i++;
                    } while (i < size);
                }
            }
        }

        private final void markNodeAndSubtreeAsPlaced() {
            boolean isPlaced = getIsPlaced();
            setPlaced$ui_release(true);
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            if (!isPlaced) {
                if (layoutNode.getMeasurePending$ui_release()) {
                    LayoutNode.requestRemeasure$ui_release$default(layoutNode, true, false, false, 6, null);
                } else if (layoutNode.getLookaheadMeasurePending$ui_release()) {
                    LayoutNode.requestLookaheadRemeasure$ui_release$default(layoutNode, true, false, false, 6, null);
                }
            }
            NodeCoordinator wrapped = layoutNode.getInnerCoordinator$ui_release().getWrapped();
            for (NodeCoordinator outerCoordinator$ui_release = layoutNode.getOuterCoordinator$ui_release(); !Intrinsics.areEqual(outerCoordinator$ui_release, wrapped) && outerCoordinator$ui_release != null; outerCoordinator$ui_release = outerCoordinator$ui_release.getWrapped()) {
                if (outerCoordinator$ui_release.getLastLayerDrawingWasSkipped()) {
                    outerCoordinator$ui_release.invalidateLayer();
                }
            }
            MutableVector<LayoutNode> mutableVector = layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode2 = content[i];
                    if (layoutNode2.getPlaceOrder$ui_release() != Integer.MAX_VALUE) {
                        layoutNode2.getMeasurePassDelegate$ui_release().markNodeAndSubtreeAsPlaced();
                        layoutNode.rescheduleRemeasureOrRelayout$ui_release(layoutNode2);
                    }
                    i++;
                } while (i < size);
            }
        }

        public final float getZIndex() {
            return this.zIndex;
        }

        public final void onNodePlaced$ui_release() {
            this.onNodePlacedCalled = true;
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            float zIndex = getInnerCoordinator().getZIndex();
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            NodeCoordinator outerCoordinator$ui_release = layoutNode.getOuterCoordinator$ui_release();
            NodeCoordinator innerCoordinator$ui_release = layoutNode.getInnerCoordinator$ui_release();
            while (outerCoordinator$ui_release != innerCoordinator$ui_release) {
                Intrinsics.checkNotNull(outerCoordinator$ui_release, "null cannot be cast to non-null type androidx.compose.ui.node.LayoutModifierNodeCoordinator");
                LayoutModifierNodeCoordinator layoutModifierNodeCoordinator = (LayoutModifierNodeCoordinator) outerCoordinator$ui_release;
                zIndex += layoutModifierNodeCoordinator.getZIndex();
                outerCoordinator$ui_release = layoutModifierNodeCoordinator.getWrapped();
            }
            if (zIndex != this.zIndex) {
                this.zIndex = zIndex;
                if (parent$ui_release != null) {
                    parent$ui_release.onZSortedChildrenInvalidated$ui_release();
                }
                if (parent$ui_release != null) {
                    parent$ui_release.invalidateLayer$ui_release();
                }
            }
            if (!getIsPlaced()) {
                if (parent$ui_release != null) {
                    parent$ui_release.invalidateLayer$ui_release();
                }
                markNodeAndSubtreeAsPlaced();
                if (this.relayoutWithoutParentInProgress && parent$ui_release != null) {
                    LayoutNode.requestRelayout$ui_release$default(parent$ui_release, false, 1, null);
                }
            }
            if (parent$ui_release != null) {
                if (!this.relayoutWithoutParentInProgress && parent$ui_release.getLayoutState$ui_release() == LayoutNode.LayoutState.LayingOut) {
                    if (!(this.placeOrder == Integer.MAX_VALUE)) {
                        InlineClassHelperKt.throwIllegalStateException("Place was called on a node which was placed already");
                    }
                    this.placeOrder = parent$ui_release.getLayoutDelegate().nextChildPlaceOrder;
                    parent$ui_release.getLayoutDelegate().nextChildPlaceOrder++;
                }
            } else {
                this.placeOrder = 0;
            }
            layoutChildren();
        }

        public final void clearPlaceOrder() {
            LayoutNodeLayoutDelegate.this.nextChildPlaceOrder = 0;
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    MeasurePassDelegate measurePassDelegate$ui_release = content[i].getMeasurePassDelegate$ui_release();
                    measurePassDelegate$ui_release.previousPlaceOrder = measurePassDelegate$ui_release.placeOrder;
                    measurePassDelegate$ui_release.placeOrder = Integer.MAX_VALUE;
                    measurePassDelegate$ui_release.isPlacedByParent = false;
                    if (measurePassDelegate$ui_release.measuredByParent == LayoutNode.UsageByParent.InLayoutBlock) {
                        measurePassDelegate$ui_release.measuredByParent = LayoutNode.UsageByParent.NotUsed;
                    }
                    i++;
                } while (i < size);
            }
        }

        private final void forEachChildDelegate(Function1<? super MeasurePassDelegate, Unit> block) {
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    block.invoke(content[i].getMeasurePassDelegate$ui_release());
                    i++;
                } while (i < size);
            }
        }

        @Override
        public Placeable mo6026measureBRTryo0(long constraints) throws KotlinNothingValueException {
            if (LayoutNodeLayoutDelegate.this.layoutNode.getIntrinsicsUsageByParent() == LayoutNode.UsageByParent.NotUsed) {
                LayoutNodeLayoutDelegate.this.layoutNode.clearSubtreeIntrinsicsUsage$ui_release();
            }
            if (LayoutNodeLayoutDelegateKt.isOutMostLookaheadRoot(LayoutNodeLayoutDelegate.this.layoutNode)) {
                LookaheadPassDelegate lookaheadPassDelegate = LayoutNodeLayoutDelegate.this.getLookaheadPassDelegate();
                Intrinsics.checkNotNull(lookaheadPassDelegate);
                lookaheadPassDelegate.setMeasuredByParent$ui_release(LayoutNode.UsageByParent.NotUsed);
                lookaheadPassDelegate.mo6026measureBRTryo0(constraints);
            }
            trackMeasurementByParent(LayoutNodeLayoutDelegate.this.layoutNode);
            m6274remeasureBRTryo0(constraints);
            return this;
        }

        public final boolean m6274remeasureBRTryo0(long constraints) throws KotlinNothingValueException {
            if (LayoutNodeLayoutDelegate.this.layoutNode.getIsDeactivated()) {
                InlineClassHelperKt.throwIllegalArgumentException("measure is called on a deactivated node");
            }
            Owner ownerRequireOwner = LayoutNodeKt.requireOwner(LayoutNodeLayoutDelegate.this.layoutNode);
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            boolean z = true;
            LayoutNodeLayoutDelegate.this.layoutNode.setCanMultiMeasure$ui_release(LayoutNodeLayoutDelegate.this.layoutNode.getCanMultiMeasure() || (parent$ui_release != null && parent$ui_release.getCanMultiMeasure()));
            if (!LayoutNodeLayoutDelegate.this.layoutNode.getMeasurePending$ui_release() && Constraints.equals-impl0(getMeasurementConstraints(), constraints)) {
                Owner.CC.forceMeasureTheSubtree$default(ownerRequireOwner, LayoutNodeLayoutDelegate.this.layoutNode, false, 2, null);
                LayoutNodeLayoutDelegate.this.layoutNode.resetSubtreeIntrinsicsUsage$ui_release();
                return false;
            }
            getAlignmentLines().setUsedByModifierMeasurement$ui_release(false);
            forEachChildAlignmentLinesOwner(new Function1<AlignmentLinesOwner, Unit>() {
                public Object invoke(Object obj) {
                    invoke((AlignmentLinesOwner) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(AlignmentLinesOwner alignmentLinesOwner) {
                    alignmentLinesOwner.getAlignmentLines().setUsedDuringParentMeasurement$ui_release(false);
                }
            });
            this.measuredOnce = true;
            long jMo6040getSizeYbymL2g = LayoutNodeLayoutDelegate.this.getOuterCoordinator().mo6040getSizeYbymL2g();
            m6134setMeasurementConstraintsBRTryo0(constraints);
            LayoutNodeLayoutDelegate.this.m6262performMeasureBRTryo0(constraints);
            if (IntSize.equals-impl0(LayoutNodeLayoutDelegate.this.getOuterCoordinator().mo6040getSizeYbymL2g(), jMo6040getSizeYbymL2g) && LayoutNodeLayoutDelegate.this.getOuterCoordinator().getWidth() == getWidth() && LayoutNodeLayoutDelegate.this.getOuterCoordinator().getHeight() == getHeight()) {
                z = false;
            }
            m6133setMeasuredSizeozmzZPI(IntSizeKt.IntSize(LayoutNodeLayoutDelegate.this.getOuterCoordinator().getWidth(), LayoutNodeLayoutDelegate.this.getOuterCoordinator().getHeight()));
            return z;
        }

        private final void trackMeasurementByParent(LayoutNode node) {
            LayoutNode.UsageByParent usageByParent;
            LayoutNode parent$ui_release = node.getParent$ui_release();
            if (parent$ui_release != null) {
                if (!(this.measuredByParent == LayoutNode.UsageByParent.NotUsed || node.getCanMultiMeasure())) {
                    InlineClassHelperKt.throwIllegalStateException("measure() may not be called multiple times on the same Measurable. If you want to get the content size of the Measurable before calculating the final constraints, please use methods like minIntrinsicWidth()/maxIntrinsicWidth() and minIntrinsicHeight()/maxIntrinsicHeight()");
                }
                int i = WhenMappings.$EnumSwitchMapping$0[parent$ui_release.getLayoutState$ui_release().ordinal()];
                if (i == 1) {
                    usageByParent = LayoutNode.UsageByParent.InMeasureBlock;
                } else if (i == 2) {
                    usageByParent = LayoutNode.UsageByParent.InLayoutBlock;
                } else {
                    throw new IllegalStateException("Measurable could be only measured from the parent's measure or layout block. Parents state is " + parent$ui_release.getLayoutState$ui_release());
                }
                this.measuredByParent = usageByParent;
                return;
            }
            this.measuredByParent = LayoutNode.UsageByParent.NotUsed;
        }

        @Override
        public int getMeasuredWidth() {
            return LayoutNodeLayoutDelegate.this.getOuterCoordinator().getMeasuredWidth();
        }

        @Override
        public int getMeasuredHeight() {
            return LayoutNodeLayoutDelegate.this.getOuterCoordinator().getMeasuredHeight();
        }

        @Override
        public int get(AlignmentLine alignmentLine) {
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if ((parent$ui_release != null ? parent$ui_release.getLayoutState$ui_release() : null) != LayoutNode.LayoutState.Measuring) {
                LayoutNode parent$ui_release2 = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
                if ((parent$ui_release2 != null ? parent$ui_release2.getLayoutState$ui_release() : null) == LayoutNode.LayoutState.LayingOut) {
                    getAlignmentLines().setUsedDuringParentLayout$ui_release(true);
                }
            } else {
                getAlignmentLines().setUsedDuringParentMeasurement$ui_release(true);
            }
            this.duringAlignmentLinesQuery = true;
            int i = LayoutNodeLayoutDelegate.this.getOuterCoordinator().get(alignmentLine);
            this.duringAlignmentLinesQuery = false;
            return i;
        }

        @Override
        public void mo6027placeAtf8xVGno(long position, float zIndex, Function1<? super GraphicsLayerScope, Unit> layerBlock) throws KotlinNothingValueException {
            m6272placeSelfMLgxB_4(position, zIndex, layerBlock, null);
        }

        @Override
        public void mo6132placeAtf8xVGno(long position, float zIndex, GraphicsLayer layer) throws KotlinNothingValueException {
            m6272placeSelfMLgxB_4(position, zIndex, null, layer);
        }

        @Override
        public boolean getIsPlacedUnderMotionFrameOfReference() {
            return this.isPlacedUnderMotionFrameOfReference;
        }

        @Override
        public void setPlacedUnderMotionFrameOfReference(boolean z) {
            boolean zIsPlacedUnderMotionFrameOfReference = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getIsPlacedUnderMotionFrameOfReference();
            if (z != zIsPlacedUnderMotionFrameOfReference) {
                LayoutNodeLayoutDelegate.this.getOuterCoordinator().setPlacedUnderMotionFrameOfReference(zIsPlacedUnderMotionFrameOfReference);
                this.needsCoordinatesUpdate = true;
            }
            this.isPlacedUnderMotionFrameOfReference = z;
        }

        private final void m6272placeSelfMLgxB_4(long position, float zIndex, Function1<? super GraphicsLayerScope, Unit> layerBlock, GraphicsLayer layer) throws KotlinNothingValueException {
            Placeable.PlacementScope placementScope;
            this.isPlacedByParent = true;
            if (!IntOffset.equals-impl0(position, this.lastPosition) || this.needsCoordinatesUpdate) {
                if (LayoutNodeLayoutDelegate.this.getCoordinatesAccessedDuringModifierPlacement() || LayoutNodeLayoutDelegate.this.getCoordinatesAccessedDuringPlacement() || this.needsCoordinatesUpdate) {
                    LayoutNodeLayoutDelegate.this.layoutPending = true;
                    this.needsCoordinatesUpdate = false;
                }
                notifyChildrenUsingCoordinatesWhilePlacing();
            }
            if (LayoutNodeLayoutDelegateKt.isOutMostLookaheadRoot(LayoutNodeLayoutDelegate.this.layoutNode)) {
                NodeCoordinator wrappedBy = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getWrappedBy();
                if (wrappedBy == null || (placementScope = wrappedBy.getPlacementScope()) == null) {
                    placementScope = LayoutNodeKt.requireOwner(LayoutNodeLayoutDelegate.this.layoutNode).getPlacementScope();
                }
                Placeable.PlacementScope placementScope2 = placementScope;
                LayoutNodeLayoutDelegate layoutNodeLayoutDelegate = LayoutNodeLayoutDelegate.this;
                LookaheadPassDelegate lookaheadPassDelegate = layoutNodeLayoutDelegate.getLookaheadPassDelegate();
                Intrinsics.checkNotNull(lookaheadPassDelegate);
                LayoutNode parent$ui_release = layoutNodeLayoutDelegate.layoutNode.getParent$ui_release();
                if (parent$ui_release != null) {
                    parent$ui_release.getLayoutDelegate().nextChildLookaheadPlaceOrder = 0;
                }
                lookaheadPassDelegate.setPlaceOrder$ui_release(Integer.MAX_VALUE);
                Placeable.PlacementScope.place$default(placementScope2, lookaheadPassDelegate, IntOffset.getX-impl(position), IntOffset.getY-impl(position), 0.0f, 4, null);
            }
            LookaheadPassDelegate lookaheadPassDelegate2 = LayoutNodeLayoutDelegate.this.getLookaheadPassDelegate();
            if ((lookaheadPassDelegate2 == null || lookaheadPassDelegate2.getPlacedOnce()) ? false : true) {
                InlineClassHelperKt.throwIllegalStateException("Error: Placement happened before lookahead.");
            }
            m6271placeOuterCoordinatorMLgxB_4(position, zIndex, layerBlock, layer);
        }

        private final void m6271placeOuterCoordinatorMLgxB_4(long position, float zIndex, Function1<? super GraphicsLayerScope, Unit> layerBlock, GraphicsLayer layer) throws KotlinNothingValueException {
            if (LayoutNodeLayoutDelegate.this.layoutNode.getIsDeactivated()) {
                InlineClassHelperKt.throwIllegalArgumentException("place is called on a deactivated node");
            }
            LayoutNodeLayoutDelegate.this.layoutState = LayoutNode.LayoutState.LayingOut;
            this.lastPosition = position;
            this.lastZIndex = zIndex;
            this.lastLayerBlock = layerBlock;
            this.lastExplicitLayer = layer;
            this.placedOnce = true;
            this.onNodePlacedCalled = false;
            Owner ownerRequireOwner = LayoutNodeKt.requireOwner(LayoutNodeLayoutDelegate.this.layoutNode);
            if (!LayoutNodeLayoutDelegate.this.getLayoutPending() && getIsPlaced()) {
                LayoutNodeLayoutDelegate.this.getOuterCoordinator().m6351placeSelfApparentToRealOffsetMLgxB_4(position, zIndex, layerBlock, layer);
                onNodePlaced$ui_release();
            } else {
                getAlignmentLines().setUsedByModifierLayout$ui_release(false);
                LayoutNodeLayoutDelegate.this.setCoordinatesAccessedDuringModifierPlacement(false);
                this.placeOuterCoordinatorLayerBlock = layerBlock;
                this.placeOuterCoordinatorPosition = position;
                this.placeOuterCoordinatorZIndex = zIndex;
                this.placeOuterCoordinatorLayer = layer;
                ownerRequireOwner.getSnapshotObserver().observeLayoutModifierSnapshotReads$ui_release(LayoutNodeLayoutDelegate.this.layoutNode, false, this.placeOuterCoordinatorBlock);
            }
            LayoutNodeLayoutDelegate.this.layoutState = LayoutNode.LayoutState.Idle;
        }

        public final void replace() {
            LayoutNode parent$ui_release;
            try {
                this.relayoutWithoutParentInProgress = true;
                if (!this.placedOnce) {
                    InlineClassHelperKt.throwIllegalStateException("replace called on unplaced item");
                }
                boolean isPlaced = getIsPlaced();
                m6271placeOuterCoordinatorMLgxB_4(this.lastPosition, this.lastZIndex, this.lastLayerBlock, this.lastExplicitLayer);
                if (isPlaced && !this.onNodePlacedCalled && (parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release()) != null) {
                    LayoutNode.requestRelayout$ui_release$default(parent$ui_release, false, 1, null);
                }
            } finally {
                this.relayoutWithoutParentInProgress = false;
            }
        }

        @Override
        public int minIntrinsicWidth(int height) {
            onIntrinsicsQueried();
            return LayoutNodeLayoutDelegate.this.getOuterCoordinator().minIntrinsicWidth(height);
        }

        @Override
        public int maxIntrinsicWidth(int height) {
            onIntrinsicsQueried();
            return LayoutNodeLayoutDelegate.this.getOuterCoordinator().maxIntrinsicWidth(height);
        }

        @Override
        public int minIntrinsicHeight(int width) {
            onIntrinsicsQueried();
            return LayoutNodeLayoutDelegate.this.getOuterCoordinator().minIntrinsicHeight(width);
        }

        @Override
        public int maxIntrinsicHeight(int width) {
            onIntrinsicsQueried();
            return LayoutNodeLayoutDelegate.this.getOuterCoordinator().maxIntrinsicHeight(width);
        }

        private final void onIntrinsicsQueried() {
            LayoutNode.UsageByParent intrinsicsUsageByParent;
            LayoutNode.requestRemeasure$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, false, false, false, 7, null);
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if (parent$ui_release == null || LayoutNodeLayoutDelegate.this.layoutNode.getIntrinsicsUsageByParent() != LayoutNode.UsageByParent.NotUsed) {
                return;
            }
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            int i = WhenMappings.$EnumSwitchMapping$0[parent$ui_release.getLayoutState$ui_release().ordinal()];
            if (i == 1) {
                intrinsicsUsageByParent = LayoutNode.UsageByParent.InMeasureBlock;
            } else if (i == 2) {
                intrinsicsUsageByParent = LayoutNode.UsageByParent.InLayoutBlock;
            } else {
                intrinsicsUsageByParent = parent$ui_release.getIntrinsicsUsageByParent();
            }
            layoutNode.setIntrinsicsUsageByParent$ui_release(intrinsicsUsageByParent);
        }

        public final void invalidateParentData() {
            this.parentDataDirty = true;
        }

        public final boolean updateParentData() {
            if ((getParentData() == null && LayoutNodeLayoutDelegate.this.getOuterCoordinator().getParentData() == null) || !this.parentDataDirty) {
                return false;
            }
            this.parentDataDirty = false;
            this.parentData = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getParentData();
            return true;
        }

        @Override
        public Map<AlignmentLine, Integer> calculateAlignmentLines() {
            if (!this.duringAlignmentLinesQuery) {
                if (LayoutNodeLayoutDelegate.this.getLayoutState() == LayoutNode.LayoutState.Measuring) {
                    getAlignmentLines().setUsedByModifierMeasurement$ui_release(true);
                    if (getAlignmentLines().getDirty()) {
                        LayoutNodeLayoutDelegate.this.markLayoutPending$ui_release();
                    }
                } else {
                    getAlignmentLines().setUsedByModifierLayout$ui_release(true);
                }
            }
            getInnerCoordinator().setPlacingForAlignment$ui_release(true);
            layoutChildren();
            getInnerCoordinator().setPlacingForAlignment$ui_release(false);
            return getAlignmentLines().getLastCalculation();
        }

        @Override
        public AlignmentLinesOwner getParentAlignmentLinesOwner() {
            LayoutNodeLayoutDelegate layoutDelegate;
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if (parent$ui_release == null || (layoutDelegate = parent$ui_release.getLayoutDelegate()) == null) {
                return null;
            }
            return layoutDelegate.getAlignmentLinesOwner$ui_release();
        }

        @Override
        public void forEachChildAlignmentLinesOwner(Function1<? super AlignmentLinesOwner, Unit> block) {
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    block.invoke(content[i].getLayoutDelegate().getAlignmentLinesOwner$ui_release());
                    i++;
                } while (i < size);
            }
        }

        @Override
        public void requestLayout() {
            LayoutNode.requestRelayout$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, false, 1, null);
        }

        @Override
        public void requestMeasure() {
            LayoutNode.requestRemeasure$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, false, false, false, 7, null);
        }

        public final void notifyChildrenUsingCoordinatesWhilePlacing() {
            MutableVector<LayoutNode> mutableVector;
            int size;
            if (LayoutNodeLayoutDelegate.this.getChildrenAccessingCoordinatesDuringPlacement() <= 0 || (size = (mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release()).getSize()) <= 0) {
                return;
            }
            LayoutNode[] content = mutableVector.getContent();
            int i = 0;
            do {
                LayoutNode layoutNode = content[i];
                LayoutNodeLayoutDelegate layoutDelegate = layoutNode.getLayoutDelegate();
                if ((layoutDelegate.getCoordinatesAccessedDuringPlacement() || layoutDelegate.getCoordinatesAccessedDuringModifierPlacement()) && !layoutDelegate.getLayoutPending()) {
                    LayoutNode.requestRelayout$ui_release$default(layoutNode, false, 1, null);
                }
                layoutDelegate.getMeasurePassDelegate().notifyChildrenUsingCoordinatesWhilePlacing();
                i++;
            } while (i < size);
        }

        private final void onBeforeLayoutChildren() {
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            LayoutNodeLayoutDelegate layoutNodeLayoutDelegate = LayoutNodeLayoutDelegate.this;
            MutableVector<LayoutNode> mutableVector = layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode2 = content[i];
                    if (layoutNode2.getMeasurePending$ui_release() && layoutNode2.getMeasuredByParent$ui_release() == LayoutNode.UsageByParent.InMeasureBlock && LayoutNode.m6231remeasure_Sx5XlM$ui_release$default(layoutNode2, null, 1, null)) {
                        LayoutNode.requestRemeasure$ui_release$default(layoutNodeLayoutDelegate.layoutNode, false, false, false, 7, null);
                    }
                    i++;
                } while (i < size);
            }
        }

        public final void invalidateIntrinsicsParent(boolean forceRequest) {
            LayoutNode layoutNode;
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            LayoutNode.UsageByParent intrinsicsUsageByParent = LayoutNodeLayoutDelegate.this.layoutNode.getIntrinsicsUsageByParent();
            if (parent$ui_release == null || intrinsicsUsageByParent == LayoutNode.UsageByParent.NotUsed) {
                return;
            }
            do {
                layoutNode = parent$ui_release;
                if (layoutNode.getIntrinsicsUsageByParent() != intrinsicsUsageByParent) {
                    break;
                } else {
                    parent$ui_release = layoutNode.getParent$ui_release();
                }
            } while (parent$ui_release != null);
            int i = WhenMappings.$EnumSwitchMapping$1[intrinsicsUsageByParent.ordinal()];
            if (i == 1) {
                LayoutNode.requestRemeasure$ui_release$default(layoutNode, forceRequest, false, false, 6, null);
            } else {
                if (i == 2) {
                    layoutNode.requestRelayout$ui_release(forceRequest);
                    return;
                }
                throw new IllegalStateException("Intrinsics isn't used by the parent".toString());
            }
        }

        public final void onNodeDetached() {
            this.placeOrder = Integer.MAX_VALUE;
            this.previousPlaceOrder = Integer.MAX_VALUE;
            setPlaced$ui_release(false);
        }

        public final void measureBasedOnLookahead() throws KotlinNothingValueException {
            LookaheadPassDelegate lookaheadPassDelegate = LayoutNodeLayoutDelegate.this.getLookaheadPassDelegate();
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if (parent$ui_release == null) {
                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("layoutNode parent is not set");
                throw new KotlinNothingValueException();
            }
            if (lookaheadPassDelegate != null) {
                if (lookaheadPassDelegate.getMeasuredByParent() == LayoutNode.UsageByParent.InMeasureBlock && parent$ui_release.getLayoutState$ui_release() == LayoutNode.LayoutState.Measuring) {
                    Constraints lookaheadConstraints = lookaheadPassDelegate.getLookaheadConstraints();
                    Intrinsics.checkNotNull(lookaheadConstraints);
                    mo6026measureBRTryo0(lookaheadConstraints.unbox-impl());
                    return;
                } else {
                    if (lookaheadPassDelegate.getMeasuredByParent() == LayoutNode.UsageByParent.InLayoutBlock && parent$ui_release.getLayoutState$ui_release() == LayoutNode.LayoutState.LayingOut) {
                        Constraints lookaheadConstraints2 = lookaheadPassDelegate.getLookaheadConstraints();
                        Intrinsics.checkNotNull(lookaheadConstraints2);
                        mo6026measureBRTryo0(lookaheadConstraints2.unbox-impl());
                        return;
                    }
                    return;
                }
            }
            InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("invalid lookaheadDelegate");
            throw new KotlinNothingValueException();
        }

        public final void placeBasedOnLookahead() throws KotlinNothingValueException {
            LookaheadPassDelegate lookaheadPassDelegate = LayoutNodeLayoutDelegate.this.getLookaheadPassDelegate();
            if (lookaheadPassDelegate != null) {
                m6272placeSelfMLgxB_4(lookaheadPassDelegate.getLastPosition(), lookaheadPassDelegate.getLastZIndex(), lookaheadPassDelegate.getLastLayerBlock$ui_release(), lookaheadPassDelegate.getLastExplicitLayer());
            } else {
                InlineClassHelperKt.throwIllegalStateExceptionForNullCheck("invalid lookaheadDelegate");
                throw new KotlinNothingValueException();
            }
        }
    }

    @Metadata(d1 = {"\u0000ª\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u0000\n\u0002\b\u000e\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b0\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0004\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u00032\u00020\u0004B\u0005¢\u0006\u0002\u0010\u0005J\u0014\u0010b\u001a\u000e\u0012\u0004\u0012\u00020d\u0012\u0004\u0012\u00020J0cH\u0016J\b\u0010e\u001a\u00020.H\u0002J\b\u0010f\u001a\u00020.H\u0002J\u001c\u0010g\u001a\u00020.2\u0012\u0010h\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020.0,H\u0016J!\u0010i\u001a\u00020.2\u0016\u0010h\u001a\u0012\u0012\b\u0012\u00060\u0000R\u00020\b\u0012\u0004\u0012\u00020.0,H\u0082\bJ\u0011\u0010j\u001a\u00020J2\u0006\u0010k\u001a\u00020dH\u0096\u0002J\u000e\u0010l\u001a\u00020.2\u0006\u0010m\u001a\u00020\u0012J\u0006\u0010n\u001a\u00020.J\b\u0010o\u001a\u00020.H\u0016J\b\u0010p\u001a\u00020.H\u0002J\b\u0010q\u001a\u00020.H\u0002J\u0010\u0010r\u001a\u00020J2\u0006\u0010s\u001a\u00020JH\u0016J\u0010\u0010t\u001a\u00020J2\u0006\u0010u\u001a\u00020JH\u0016J\u001a\u0010v\u001a\u00020\u00012\u0006\u0010w\u001a\u00020$H\u0016ø\u0001\u0000¢\u0006\u0004\bx\u0010yJ\u0010\u0010z\u001a\u00020J2\u0006\u0010s\u001a\u00020JH\u0016J\u0010\u0010{\u001a\u00020J2\u0006\u0010u\u001a\u00020JH\u0016J\u0006\u0010|\u001a\u00020.J\b\u0010}\u001a\u00020.H\u0002J\b\u0010~\u001a\u00020.H\u0002J\u0006\u0010\u007f\u001a\u00020.J\u000f\u0010\u0080\u0001\u001a\u00020.H\u0000¢\u0006\u0003\b\u0081\u0001JC\u0010\u0082\u0001\u001a\u00020.2\u0007\u0010\u0083\u0001\u001a\u0002032\u0007\u0010\u0084\u0001\u001a\u0002082\u001a\u0010\u0085\u0001\u001a\u0015\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020.\u0018\u00010,¢\u0006\u0002\b/H\u0014ø\u0001\u0000¢\u0006\u0006\b\u0086\u0001\u0010\u0087\u0001J0\u0010\u0082\u0001\u001a\u00020.2\u0007\u0010\u0083\u0001\u001a\u0002032\u0007\u0010\u0084\u0001\u001a\u0002082\u0007\u0010\u0088\u0001\u001a\u00020(H\u0014ø\u0001\u0000¢\u0006\u0006\b\u0086\u0001\u0010\u0089\u0001JN\u0010\u008a\u0001\u001a\u00020.2\u0007\u0010\u0083\u0001\u001a\u0002032\u0007\u0010\u0084\u0001\u001a\u0002082\u001a\u0010\u0085\u0001\u001a\u0015\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020.\u0018\u00010,¢\u0006\u0002\b/2\t\u0010\u0088\u0001\u001a\u0004\u0018\u00010(H\u0002ø\u0001\u0000¢\u0006\u0006\b\u008b\u0001\u0010\u008c\u0001J\u001b\u0010\u008d\u0001\u001a\u00020\u00122\u0006\u0010w\u001a\u00020$ø\u0001\u0000¢\u0006\u0006\b\u008e\u0001\u0010\u008f\u0001J\u0007\u0010\u0090\u0001\u001a\u00020.J\t\u0010\u0091\u0001\u001a\u00020.H\u0016J\t\u0010\u0092\u0001\u001a\u00020.H\u0016J\u0013\u0010\u0093\u0001\u001a\u00020.2\b\u0010\u0094\u0001\u001a\u00030\u0095\u0001H\u0002J\u0007\u0010\u0096\u0001\u001a\u00020\u0012R\u0018\u0010\u0006\u001a\f\u0012\b\u0012\u00060\u0000R\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\u00020\nX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u001e\u0010\r\u001a\f\u0012\b\u0012\u00060\u0000R\u00020\b0\u000e8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010R\u001a\u0010\u0011\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0013\u0010\u0014\"\u0004\b\u0015\u0010\u0016R\u001a\u0010\u0017\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0014\"\u0004\b\u0019\u0010\u0016R\u0014\u0010\u001a\u001a\u00020\u001b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u001dR\u001a\u0010\u001e\u001a\u00020\u0012X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u0014\"\u0004\b\u001f\u0010\u0016R$\u0010!\u001a\u00020\u00122\u0006\u0010 \u001a\u00020\u0012@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\u0014\"\u0004\b\"\u0010\u0016R\u0019\u0010#\u001a\u0004\u0018\u00010$8Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b%\u0010&R\"\u0010)\u001a\u0004\u0018\u00010(2\b\u0010'\u001a\u0004\u0018\u00010(@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b*\u0010+RD\u00100\u001a\u0015\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020.\u0018\u00010,¢\u0006\u0002\b/2\u0019\u0010'\u001a\u0015\u0012\u0004\u0012\u00020-\u0012\u0004\u0012\u00020.\u0018\u00010,¢\u0006\u0002\b/@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b1\u00102R&\u00104\u001a\u0002032\u0006\u0010'\u001a\u000203@BX\u0080\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00107\u001a\u0004\b5\u00106R\u001e\u00109\u001a\u0002082\u0006\u0010'\u001a\u000208@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b:\u0010;R\u001e\u0010<\u001a\u00020\u00122\u0006\u0010'\u001a\u00020\u0012@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b=\u0010\u0014R\u0016\u0010>\u001a\u0004\u0018\u00010$X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000R\u0018\u0010?\u001a\u00060@R\u00020\b8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bA\u0010BR\u001a\u0010C\u001a\u00020DX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bE\u0010F\"\u0004\bG\u0010HR\u0014\u0010I\u001a\u00020J8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bK\u0010LR\u000e\u0010M\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010N\u001a\u00020J8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bO\u0010LR\u000e\u0010P\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010Q\u001a\u0004\u0018\u00010\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\bR\u0010SR\"\u0010U\u001a\u0004\u0018\u00010T2\b\u0010'\u001a\u0004\u0018\u00010T@RX\u0096\u000e¢\u0006\b\n\u0000\u001a\u0004\bV\u0010WR\u000e\u0010X\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010Y\u001a\u00020JX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bZ\u0010L\"\u0004\b[\u0010\\R\u001a\u0010]\u001a\u00020\u0012X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b^\u0010\u0014\"\u0004\b_\u0010\u0016R\u0018\u0010`\u001a\u00020J2\u0006\u0010'\u001a\u00020J@BX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010a\u001a\u00020\u0012X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0097\u0001"}, d2 = {"Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$LookaheadPassDelegate;", "Landroidx/compose/ui/layout/Placeable;", "Landroidx/compose/ui/layout/Measurable;", "Landroidx/compose/ui/node/AlignmentLinesOwner;", "Landroidx/compose/ui/node/MotionReferencePlacementDelegate;", "(Landroidx/compose/ui/node/LayoutNodeLayoutDelegate;)V", "_childDelegates", "Landroidx/compose/runtime/collection/MutableVector;", "Landroidx/compose/ui/node/LayoutNodeLayoutDelegate;", "alignmentLines", "Landroidx/compose/ui/node/AlignmentLines;", "getAlignmentLines", "()Landroidx/compose/ui/node/AlignmentLines;", "childDelegates", "", "getChildDelegates$ui_release", "()Ljava/util/List;", "childDelegatesDirty", "", "getChildDelegatesDirty$ui_release", "()Z", "setChildDelegatesDirty$ui_release", "(Z)V", "duringAlignmentLinesQuery", "getDuringAlignmentLinesQuery$ui_release", "setDuringAlignmentLinesQuery$ui_release", "innerCoordinator", "Landroidx/compose/ui/node/NodeCoordinator;", "getInnerCoordinator", "()Landroidx/compose/ui/node/NodeCoordinator;", "isPlaced", "setPlaced", "new", "isPlacedUnderMotionFrameOfReference", "setPlacedUnderMotionFrameOfReference", "lastConstraints", "Landroidx/compose/ui/unit/Constraints;", "getLastConstraints-DWUhwKw", "()Landroidx/compose/ui/unit/Constraints;", "<set-?>", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "lastExplicitLayer", "getLastExplicitLayer$ui_release", "()Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "Lkotlin/Function1;", "Landroidx/compose/ui/graphics/GraphicsLayerScope;", "", "Lkotlin/ExtensionFunctionType;", "lastLayerBlock", "getLastLayerBlock$ui_release", "()Lkotlin/jvm/functions/Function1;", "Landroidx/compose/ui/unit/IntOffset;", "lastPosition", "getLastPosition-nOcc-ac$ui_release", "()J", "J", "", "lastZIndex", "getLastZIndex$ui_release", "()F", "layingOutChildren", "getLayingOutChildren", "lookaheadConstraints", "measurePassDelegate", "Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$MeasurePassDelegate;", "getMeasurePassDelegate$ui_release", "()Landroidx/compose/ui/node/LayoutNodeLayoutDelegate$MeasurePassDelegate;", "measuredByParent", "Landroidx/compose/ui/node/LayoutNode$UsageByParent;", "getMeasuredByParent$ui_release", "()Landroidx/compose/ui/node/LayoutNode$UsageByParent;", "setMeasuredByParent$ui_release", "(Landroidx/compose/ui/node/LayoutNode$UsageByParent;)V", "measuredHeight", "", "getMeasuredHeight", "()I", "measuredOnce", "measuredWidth", "getMeasuredWidth", "onNodePlacedCalled", "parentAlignmentLinesOwner", "getParentAlignmentLinesOwner", "()Landroidx/compose/ui/node/AlignmentLinesOwner;", "", "parentData", "getParentData", "()Ljava/lang/Object;", "parentDataDirty", "placeOrder", "getPlaceOrder$ui_release", "setPlaceOrder$ui_release", "(I)V", "placedOnce", "getPlacedOnce$ui_release", "setPlacedOnce$ui_release", "previousPlaceOrder", "relayoutWithoutParentInProgress", "calculateAlignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "checkChildrenPlaceOrderForUpdates", "clearPlaceOrder", "forEachChildAlignmentLinesOwner", "block", "forEachChildDelegate", "get", "alignmentLine", "invalidateIntrinsicsParent", "forceRequest", "invalidateParentData", "layoutChildren", "markNodeAndSubtreeAsPlaced", "markSubtreeAsNotPlaced", "maxIntrinsicHeight", "width", "maxIntrinsicWidth", "height", "measure", "constraints", "measure-BRTryo0", "(J)Landroidx/compose/ui/layout/Placeable;", "minIntrinsicHeight", "minIntrinsicWidth", "notifyChildrenUsingLookaheadCoordinatesWhilePlacing", "onBeforeLayoutChildren", "onIntrinsicsQueried", "onNodeDetached", "onNodePlaced", "onNodePlaced$ui_release", "placeAt", "position", "zIndex", "layerBlock", "placeAt-f8xVGno", "(JFLkotlin/jvm/functions/Function1;)V", "layer", "(JFLandroidx/compose/ui/graphics/layer/GraphicsLayer;)V", "placeSelf", "placeSelf-MLgxB_4", "(JFLkotlin/jvm/functions/Function1;Landroidx/compose/ui/graphics/layer/GraphicsLayer;)V", "remeasure", "remeasure-BRTryo0", "(J)Z", "replace", "requestLayout", "requestMeasure", "trackLookaheadMeasurementByParent", "node", "Landroidx/compose/ui/node/LayoutNode;", "updateParentData", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public final class LookaheadPassDelegate extends Placeable implements Measurable, AlignmentLinesOwner, MotionReferencePlacementDelegate {
        private boolean duringAlignmentLinesQuery;
        private boolean isPlaced;
        private boolean isPlacedUnderMotionFrameOfReference;
        private GraphicsLayer lastExplicitLayer;
        private Function1<? super GraphicsLayerScope, Unit> lastLayerBlock;
        private float lastZIndex;
        private boolean layingOutChildren;
        private Constraints lookaheadConstraints;
        private boolean measuredOnce;
        private boolean onNodePlacedCalled;
        private boolean placedOnce;
        private boolean relayoutWithoutParentInProgress;
        private int previousPlaceOrder = Integer.MAX_VALUE;
        private int placeOrder = Integer.MAX_VALUE;
        private LayoutNode.UsageByParent measuredByParent = LayoutNode.UsageByParent.NotUsed;
        private long lastPosition = IntOffset.Companion.getZero-nOcc-ac();
        private final AlignmentLines alignmentLines = new LookaheadAlignmentLines(this);
        private final MutableVector<LookaheadPassDelegate> _childDelegates = new MutableVector<>(new LookaheadPassDelegate[16], 0);
        private boolean childDelegatesDirty = true;
        private boolean parentDataDirty = true;
        private Object parentData = getMeasurePassDelegate$ui_release().getParentData();

        @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
        public class WhenMappings {
            public static final int[] $EnumSwitchMapping$0;
            public static final int[] $EnumSwitchMapping$1;

            static {
                int[] iArr = new int[LayoutNode.LayoutState.values().length];
                try {
                    iArr[LayoutNode.LayoutState.LookaheadMeasuring.ordinal()] = 1;
                } catch (NoSuchFieldError unused) {
                }
                try {
                    iArr[LayoutNode.LayoutState.Measuring.ordinal()] = 2;
                } catch (NoSuchFieldError unused2) {
                }
                try {
                    iArr[LayoutNode.LayoutState.LayingOut.ordinal()] = 3;
                } catch (NoSuchFieldError unused3) {
                }
                try {
                    iArr[LayoutNode.LayoutState.LookaheadLayingOut.ordinal()] = 4;
                } catch (NoSuchFieldError unused4) {
                }
                $EnumSwitchMapping$0 = iArr;
                int[] iArr2 = new int[LayoutNode.UsageByParent.values().length];
                try {
                    iArr2[LayoutNode.UsageByParent.InMeasureBlock.ordinal()] = 1;
                } catch (NoSuchFieldError unused5) {
                }
                try {
                    iArr2[LayoutNode.UsageByParent.InLayoutBlock.ordinal()] = 2;
                } catch (NoSuchFieldError unused6) {
                }
                $EnumSwitchMapping$1 = iArr2;
            }
        }

        public LookaheadPassDelegate() {
        }

        public final int getPlaceOrder() {
            return this.placeOrder;
        }

        public final void setPlaceOrder$ui_release(int i) {
            this.placeOrder = i;
        }

        public final LayoutNode.UsageByParent getMeasuredByParent() {
            return this.measuredByParent;
        }

        public final void setMeasuredByParent$ui_release(LayoutNode.UsageByParent usageByParent) {
            this.measuredByParent = usageByParent;
        }

        public final MeasurePassDelegate getMeasurePassDelegate$ui_release() {
            return LayoutNodeLayoutDelegate.this.getMeasurePassDelegate();
        }

        public final boolean getDuringAlignmentLinesQuery() {
            return this.duringAlignmentLinesQuery;
        }

        public final void setDuringAlignmentLinesQuery$ui_release(boolean z) {
            this.duringAlignmentLinesQuery = z;
        }

        public final boolean getPlacedOnce() {
            return this.placedOnce;
        }

        public final void setPlacedOnce$ui_release(boolean z) {
            this.placedOnce = z;
        }

        public final Constraints getLookaheadConstraints() {
            return this.lookaheadConstraints;
        }

        public final long getLastPosition() {
            return this.lastPosition;
        }

        public final float getLastZIndex() {
            return this.lastZIndex;
        }

        public final Function1<GraphicsLayerScope, Unit> getLastLayerBlock$ui_release() {
            return this.lastLayerBlock;
        }

        public final GraphicsLayer getLastExplicitLayer() {
            return this.lastExplicitLayer;
        }

        @Override
        public boolean getIsPlaced() {
            return this.isPlaced;
        }

        public void setPlaced(boolean z) {
            this.isPlaced = z;
        }

        @Override
        public NodeCoordinator getInnerCoordinator() {
            return LayoutNodeLayoutDelegate.this.layoutNode.getInnerCoordinator$ui_release();
        }

        @Override
        public AlignmentLines getAlignmentLines() {
            return this.alignmentLines;
        }

        public final boolean getChildDelegatesDirty() {
            return this.childDelegatesDirty;
        }

        public final void setChildDelegatesDirty$ui_release(boolean z) {
            this.childDelegatesDirty = z;
        }

        public final List<LookaheadPassDelegate> getChildDelegates$ui_release() {
            LayoutNodeLayoutDelegate.this.layoutNode.getChildren$ui_release();
            if (!this.childDelegatesDirty) {
                return this._childDelegates.asMutableList();
            }
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            MutableVector<LookaheadPassDelegate> mutableVector = this._childDelegates;
            MutableVector<LayoutNode> mutableVector2 = layoutNode.get_children$ui_release();
            int size = mutableVector2.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector2.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode2 = content[i];
                    if (mutableVector.getSize() <= i) {
                        LookaheadPassDelegate lookaheadPassDelegate = layoutNode2.getLayoutDelegate().getLookaheadPassDelegate();
                        Intrinsics.checkNotNull(lookaheadPassDelegate);
                        mutableVector.add(lookaheadPassDelegate);
                    } else {
                        LookaheadPassDelegate lookaheadPassDelegate2 = layoutNode2.getLayoutDelegate().getLookaheadPassDelegate();
                        Intrinsics.checkNotNull(lookaheadPassDelegate2);
                        mutableVector.set(i, lookaheadPassDelegate2);
                    }
                    i++;
                } while (i < size);
            }
            mutableVector.removeRange(layoutNode.getChildren$ui_release().size(), mutableVector.getSize());
            this.childDelegatesDirty = false;
            return this._childDelegates.asMutableList();
        }

        public final boolean getLayingOutChildren() {
            return this.layingOutChildren;
        }

        private final void forEachChildDelegate(Function1<? super LookaheadPassDelegate, Unit> block) {
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LookaheadPassDelegate lookaheadPassDelegate = content[i].getLayoutDelegate().getLookaheadPassDelegate();
                    Intrinsics.checkNotNull(lookaheadPassDelegate);
                    block.invoke(lookaheadPassDelegate);
                    i++;
                } while (i < size);
            }
        }

        @Override
        public void layoutChildren() throws KotlinNothingValueException {
            this.layingOutChildren = true;
            getAlignmentLines().recalculateQueryOwner();
            if (LayoutNodeLayoutDelegate.this.getLookaheadLayoutPending()) {
                onBeforeLayoutChildren();
            }
            final LookaheadDelegate lookaheadDelegate = getInnerCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            if (LayoutNodeLayoutDelegate.this.lookaheadLayoutPendingForAlignment || (!this.duringAlignmentLinesQuery && !lookaheadDelegate.getIsPlacingForAlignment() && LayoutNodeLayoutDelegate.this.getLookaheadLayoutPending())) {
                LayoutNodeLayoutDelegate.this.lookaheadLayoutPending = false;
                LayoutNode.LayoutState layoutState = LayoutNodeLayoutDelegate.this.getLayoutState();
                LayoutNodeLayoutDelegate.this.layoutState = LayoutNode.LayoutState.LookaheadLayingOut;
                Owner ownerRequireOwner = LayoutNodeKt.requireOwner(LayoutNodeLayoutDelegate.this.layoutNode);
                LayoutNodeLayoutDelegate.this.setLookaheadCoordinatesAccessedDuringPlacement(false);
                OwnerSnapshotObserver snapshotObserver = ownerRequireOwner.getSnapshotObserver();
                LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
                final LayoutNodeLayoutDelegate layoutNodeLayoutDelegate = LayoutNodeLayoutDelegate.this;
                OwnerSnapshotObserver.observeLayoutSnapshotReads$ui_release$default(snapshotObserver, layoutNode, false, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m6269invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m6269invoke() {
                        this.this$0.clearPlaceOrder();
                        this.this$0.forEachChildAlignmentLinesOwner(new Function1<AlignmentLinesOwner, Unit>() {
                            public Object invoke(Object obj) {
                                invoke((AlignmentLinesOwner) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(AlignmentLinesOwner alignmentLinesOwner) {
                                alignmentLinesOwner.getAlignmentLines().setUsedDuringParentLayout$ui_release(false);
                            }
                        });
                        LookaheadDelegate lookaheadDelegate2 = this.this$0.getInnerCoordinator().getLookaheadDelegate();
                        if (lookaheadDelegate2 != null) {
                            boolean zIsPlacingForAlignment$ui_release = lookaheadDelegate2.getIsPlacingForAlignment();
                            List<LayoutNode> children$ui_release = layoutNodeLayoutDelegate.layoutNode.getChildren$ui_release();
                            int size = children$ui_release.size();
                            for (int i = 0; i < size; i++) {
                                LookaheadDelegate lookaheadDelegate3 = children$ui_release.get(i).getOuterCoordinator$ui_release().getLookaheadDelegate();
                                if (lookaheadDelegate3 != null) {
                                    lookaheadDelegate3.setPlacingForAlignment$ui_release(zIsPlacingForAlignment$ui_release);
                                }
                            }
                        }
                        lookaheadDelegate.getMeasureResult$ui_release().placeChildren();
                        LookaheadDelegate lookaheadDelegate4 = this.this$0.getInnerCoordinator().getLookaheadDelegate();
                        if (lookaheadDelegate4 != null) {
                            lookaheadDelegate4.getIsPlacingForAlignment();
                            List<LayoutNode> children$ui_release2 = layoutNodeLayoutDelegate.layoutNode.getChildren$ui_release();
                            int size2 = children$ui_release2.size();
                            for (int i2 = 0; i2 < size2; i2++) {
                                LookaheadDelegate lookaheadDelegate5 = children$ui_release2.get(i2).getOuterCoordinator$ui_release().getLookaheadDelegate();
                                if (lookaheadDelegate5 != null) {
                                    lookaheadDelegate5.setPlacingForAlignment$ui_release(false);
                                }
                            }
                        }
                        this.this$0.checkChildrenPlaceOrderForUpdates();
                        this.this$0.forEachChildAlignmentLinesOwner(new Function1<AlignmentLinesOwner, Unit>() {
                            public Object invoke(Object obj) {
                                invoke((AlignmentLinesOwner) obj);
                                return Unit.INSTANCE;
                            }

                            public final void invoke(AlignmentLinesOwner alignmentLinesOwner) {
                                alignmentLinesOwner.getAlignmentLines().setPreviousUsedDuringParentLayout$ui_release(alignmentLinesOwner.getAlignmentLines().getUsedDuringParentLayout());
                            }
                        });
                    }
                }, 2, null);
                LayoutNodeLayoutDelegate.this.layoutState = layoutState;
                if (LayoutNodeLayoutDelegate.this.getLookaheadCoordinatesAccessedDuringPlacement() && lookaheadDelegate.getIsPlacingForAlignment()) {
                    requestLayout();
                }
                LayoutNodeLayoutDelegate.this.lookaheadLayoutPendingForAlignment = false;
            }
            if (getAlignmentLines().getUsedDuringParentLayout()) {
                getAlignmentLines().setPreviousUsedDuringParentLayout$ui_release(true);
            }
            if (getAlignmentLines().getDirty() && getAlignmentLines().getRequired$ui_release()) {
                getAlignmentLines().recalculate();
            }
            this.layingOutChildren = false;
        }

        private final void markSubtreeAsNotPlaced() {
            if (getIsPlaced()) {
                int i = 0;
                setPlaced(false);
                MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
                int size = mutableVector.getSize();
                if (size > 0) {
                    LayoutNode[] content = mutableVector.getContent();
                    do {
                        LookaheadPassDelegate lookaheadPassDelegate = content[i].getLayoutDelegate().getLookaheadPassDelegate();
                        Intrinsics.checkNotNull(lookaheadPassDelegate);
                        lookaheadPassDelegate.markSubtreeAsNotPlaced();
                        i++;
                    } while (i < size);
                }
            }
        }

        @Override
        public Map<AlignmentLine, Integer> calculateAlignmentLines() throws KotlinNothingValueException {
            if (!this.duringAlignmentLinesQuery) {
                if (LayoutNodeLayoutDelegate.this.getLayoutState() == LayoutNode.LayoutState.LookaheadMeasuring) {
                    getAlignmentLines().setUsedByModifierMeasurement$ui_release(true);
                    if (getAlignmentLines().getDirty()) {
                        LayoutNodeLayoutDelegate.this.markLookaheadLayoutPending$ui_release();
                    }
                } else {
                    getAlignmentLines().setUsedByModifierLayout$ui_release(true);
                }
            }
            LookaheadDelegate lookaheadDelegate = getInnerCoordinator().getLookaheadDelegate();
            if (lookaheadDelegate != null) {
                lookaheadDelegate.setPlacingForAlignment$ui_release(true);
            }
            layoutChildren();
            LookaheadDelegate lookaheadDelegate2 = getInnerCoordinator().getLookaheadDelegate();
            if (lookaheadDelegate2 != null) {
                lookaheadDelegate2.setPlacingForAlignment$ui_release(false);
            }
            return getAlignmentLines().getLastCalculation();
        }

        @Override
        public AlignmentLinesOwner getParentAlignmentLinesOwner() {
            LayoutNodeLayoutDelegate layoutDelegate;
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if (parent$ui_release == null || (layoutDelegate = parent$ui_release.getLayoutDelegate()) == null) {
                return null;
            }
            return layoutDelegate.getLookaheadAlignmentLinesOwner$ui_release();
        }

        @Override
        public void forEachChildAlignmentLinesOwner(Function1<? super AlignmentLinesOwner, Unit> block) {
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    AlignmentLinesOwner lookaheadAlignmentLinesOwner$ui_release = content[i].getLayoutDelegate().getLookaheadAlignmentLinesOwner$ui_release();
                    Intrinsics.checkNotNull(lookaheadAlignmentLinesOwner$ui_release);
                    block.invoke(lookaheadAlignmentLinesOwner$ui_release);
                    i++;
                } while (i < size);
            }
        }

        @Override
        public void requestLayout() {
            LayoutNode.requestLookaheadRelayout$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, false, 1, null);
        }

        @Override
        public void requestMeasure() {
            LayoutNode.requestLookaheadRemeasure$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, false, false, false, 7, null);
        }

        public final void notifyChildrenUsingLookaheadCoordinatesWhilePlacing() {
            MutableVector<LayoutNode> mutableVector;
            int size;
            if (LayoutNodeLayoutDelegate.this.getChildrenAccessingLookaheadCoordinatesDuringPlacement() <= 0 || (size = (mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release()).getSize()) <= 0) {
                return;
            }
            LayoutNode[] content = mutableVector.getContent();
            int i = 0;
            do {
                LayoutNode layoutNode = content[i];
                LayoutNodeLayoutDelegate layoutDelegate = layoutNode.getLayoutDelegate();
                if ((layoutDelegate.getLookaheadCoordinatesAccessedDuringPlacement() || layoutDelegate.getLookaheadCoordinatesAccessedDuringModifierPlacement()) && !layoutDelegate.getLookaheadLayoutPending()) {
                    LayoutNode.requestLookaheadRelayout$ui_release$default(layoutNode, false, 1, null);
                }
                LookaheadPassDelegate lookaheadPassDelegate = layoutDelegate.getLookaheadPassDelegate();
                if (lookaheadPassDelegate != null) {
                    lookaheadPassDelegate.notifyChildrenUsingLookaheadCoordinatesWhilePlacing();
                }
                i++;
            } while (i < size);
        }

        @Override
        public Placeable mo6026measureBRTryo0(long constraints) {
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if ((parent$ui_release != null ? parent$ui_release.getLayoutState$ui_release() : null) == LayoutNode.LayoutState.LookaheadMeasuring) {
                LayoutNodeLayoutDelegate.this.detachedFromParentLookaheadPass = false;
            } else {
                LayoutNode parent$ui_release2 = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
                if ((parent$ui_release2 != null ? parent$ui_release2.getLayoutState$ui_release() : null) == LayoutNode.LayoutState.LookaheadLayingOut) {
                    LayoutNodeLayoutDelegate.this.detachedFromParentLookaheadPass = false;
                }
            }
            trackLookaheadMeasurementByParent(LayoutNodeLayoutDelegate.this.layoutNode);
            if (LayoutNodeLayoutDelegate.this.layoutNode.getIntrinsicsUsageByParent() == LayoutNode.UsageByParent.NotUsed) {
                LayoutNodeLayoutDelegate.this.layoutNode.clearSubtreeIntrinsicsUsage$ui_release();
            }
            m6268remeasureBRTryo0(constraints);
            return this;
        }

        private final void trackLookaheadMeasurementByParent(LayoutNode node) {
            LayoutNode.UsageByParent usageByParent;
            LayoutNode parent$ui_release = node.getParent$ui_release();
            if (parent$ui_release != null) {
                if (!(this.measuredByParent == LayoutNode.UsageByParent.NotUsed || node.getCanMultiMeasure())) {
                    InlineClassHelperKt.throwIllegalStateException("measure() may not be called multiple times on the same Measurable. If you want to get the content size of the Measurable before calculating the final constraints, please use methods like minIntrinsicWidth()/maxIntrinsicWidth() and minIntrinsicHeight()/maxIntrinsicHeight()");
                }
                int i = WhenMappings.$EnumSwitchMapping$0[parent$ui_release.getLayoutState$ui_release().ordinal()];
                if (i == 1 || i == 2) {
                    usageByParent = LayoutNode.UsageByParent.InMeasureBlock;
                } else if (i == 3 || i == 4) {
                    usageByParent = LayoutNode.UsageByParent.InLayoutBlock;
                } else {
                    throw new IllegalStateException("Measurable could be only measured from the parent's measure or layout block. Parents state is " + parent$ui_release.getLayoutState$ui_release());
                }
                this.measuredByParent = usageByParent;
                return;
            }
            this.measuredByParent = LayoutNode.UsageByParent.NotUsed;
        }

        @Override
        public Object getParentData() {
            return this.parentData;
        }

        public final boolean m6268remeasureBRTryo0(long constraints) {
            long jIntSize;
            if (LayoutNodeLayoutDelegate.this.layoutNode.getIsDeactivated()) {
                InlineClassHelperKt.throwIllegalArgumentException("measure is called on a deactivated node");
            }
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            LayoutNodeLayoutDelegate.this.layoutNode.setCanMultiMeasure$ui_release(LayoutNodeLayoutDelegate.this.layoutNode.getCanMultiMeasure() || (parent$ui_release != null && parent$ui_release.getCanMultiMeasure()));
            if (!LayoutNodeLayoutDelegate.this.layoutNode.getLookaheadMeasurePending$ui_release()) {
                Constraints constraints2 = this.lookaheadConstraints;
                if (constraints2 == null ? false : Constraints.equals-impl0(constraints2.unbox-impl(), constraints)) {
                    Owner owner = LayoutNodeLayoutDelegate.this.layoutNode.getOwner();
                    if (owner != null) {
                        owner.forceMeasureTheSubtree(LayoutNodeLayoutDelegate.this.layoutNode, true);
                    }
                    LayoutNodeLayoutDelegate.this.layoutNode.resetSubtreeIntrinsicsUsage$ui_release();
                    return false;
                }
            }
            this.lookaheadConstraints = Constraints.box-impl(constraints);
            m6134setMeasurementConstraintsBRTryo0(constraints);
            getAlignmentLines().setUsedByModifierMeasurement$ui_release(false);
            forEachChildAlignmentLinesOwner(new Function1<AlignmentLinesOwner, Unit>() {
                public Object invoke(Object obj) {
                    invoke((AlignmentLinesOwner) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(AlignmentLinesOwner alignmentLinesOwner) {
                    alignmentLinesOwner.getAlignmentLines().setUsedDuringParentMeasurement$ui_release(false);
                }
            });
            if (this.measuredOnce) {
                jIntSize = getMeasuredSize();
            } else {
                jIntSize = IntSizeKt.IntSize(Integer.MIN_VALUE, Integer.MIN_VALUE);
            }
            this.measuredOnce = true;
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            if (!(lookaheadDelegate != null)) {
                InlineClassHelperKt.throwIllegalStateException("Lookahead result from lookaheadRemeasure cannot be null");
            }
            LayoutNodeLayoutDelegate.this.m6261performLookaheadMeasureBRTryo0(constraints);
            m6133setMeasuredSizeozmzZPI(IntSizeKt.IntSize(lookaheadDelegate.getWidth(), lookaheadDelegate.getHeight()));
            return (IntSize.getWidth-impl(jIntSize) == lookaheadDelegate.getWidth() && IntSize.getHeight-impl(jIntSize) == lookaheadDelegate.getHeight()) ? false : true;
        }

        @Override
        public void mo6027placeAtf8xVGno(long position, float zIndex, Function1<? super GraphicsLayerScope, Unit> layerBlock) throws KotlinNothingValueException {
            m6265placeSelfMLgxB_4(position, zIndex, layerBlock, null);
        }

        @Override
        public void mo6132placeAtf8xVGno(long position, float zIndex, GraphicsLayer layer) throws KotlinNothingValueException {
            m6265placeSelfMLgxB_4(position, zIndex, null, layer);
        }

        @Override
        public boolean getIsPlacedUnderMotionFrameOfReference() {
            return this.isPlacedUnderMotionFrameOfReference;
        }

        @Override
        public void setPlacedUnderMotionFrameOfReference(boolean z) {
            LookaheadDelegate lookaheadDelegate;
            LookaheadDelegate lookaheadDelegate2 = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            if (!Intrinsics.areEqual(Boolean.valueOf(z), lookaheadDelegate2 != null ? Boolean.valueOf(lookaheadDelegate2.getIsPlacedUnderMotionFrameOfReference()) : null) && (lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate()) != null) {
                lookaheadDelegate.setPlacedUnderMotionFrameOfReference(z);
            }
            this.isPlacedUnderMotionFrameOfReference = z;
        }

        private final void m6265placeSelfMLgxB_4(final long position, float zIndex, Function1<? super GraphicsLayerScope, Unit> layerBlock, GraphicsLayer layer) throws KotlinNothingValueException {
            if (LayoutNodeLayoutDelegate.this.layoutNode.getIsDeactivated()) {
                InlineClassHelperKt.throwIllegalArgumentException("place is called on a deactivated node");
            }
            LayoutNodeLayoutDelegate.this.layoutState = LayoutNode.LayoutState.LookaheadLayingOut;
            this.placedOnce = true;
            this.onNodePlacedCalled = false;
            if (!IntOffset.equals-impl0(position, this.lastPosition)) {
                if (LayoutNodeLayoutDelegate.this.getLookaheadCoordinatesAccessedDuringModifierPlacement() || LayoutNodeLayoutDelegate.this.getLookaheadCoordinatesAccessedDuringPlacement()) {
                    LayoutNodeLayoutDelegate.this.lookaheadLayoutPending = true;
                }
                notifyChildrenUsingLookaheadCoordinatesWhilePlacing();
            }
            final Owner ownerRequireOwner = LayoutNodeKt.requireOwner(LayoutNodeLayoutDelegate.this.layoutNode);
            if (!LayoutNodeLayoutDelegate.this.getLookaheadLayoutPending() && getIsPlaced()) {
                LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
                Intrinsics.checkNotNull(lookaheadDelegate);
                lookaheadDelegate.m6310placeSelfApparentToRealOffsetgyyYBs$ui_release(position);
                onNodePlaced$ui_release();
            } else {
                LayoutNodeLayoutDelegate.this.setLookaheadCoordinatesAccessedDuringModifierPlacement(false);
                getAlignmentLines().setUsedByModifierLayout$ui_release(false);
                OwnerSnapshotObserver snapshotObserver = ownerRequireOwner.getSnapshotObserver();
                LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
                final LayoutNodeLayoutDelegate layoutNodeLayoutDelegate = LayoutNodeLayoutDelegate.this;
                OwnerSnapshotObserver.observeLayoutModifierSnapshotReads$ui_release$default(snapshotObserver, layoutNode, false, new Function0<Unit>() {
                    {
                        super(0);
                    }

                    public Object invoke() {
                        m6270invoke();
                        return Unit.INSTANCE;
                    }

                    public final void m6270invoke() {
                        LookaheadDelegate lookaheadDelegate2;
                        Placeable.PlacementScope placementScope = null;
                        if (LayoutNodeLayoutDelegateKt.isOutMostLookaheadRoot(layoutNodeLayoutDelegate.layoutNode)) {
                            NodeCoordinator wrappedBy = layoutNodeLayoutDelegate.getOuterCoordinator().getWrappedBy();
                            if (wrappedBy != null) {
                                placementScope = wrappedBy.getPlacementScope();
                            }
                        } else {
                            NodeCoordinator wrappedBy2 = layoutNodeLayoutDelegate.getOuterCoordinator().getWrappedBy();
                            if (wrappedBy2 != null && (lookaheadDelegate2 = wrappedBy2.getLookaheadDelegate()) != null) {
                                placementScope = lookaheadDelegate2.getPlacementScope();
                            }
                        }
                        if (placementScope == null) {
                            placementScope = ownerRequireOwner.getPlacementScope();
                        }
                        LayoutNodeLayoutDelegate layoutNodeLayoutDelegate2 = layoutNodeLayoutDelegate;
                        long j = position;
                        LookaheadDelegate lookaheadDelegate3 = layoutNodeLayoutDelegate2.getOuterCoordinator().getLookaheadDelegate();
                        Intrinsics.checkNotNull(lookaheadDelegate3);
                        Placeable.PlacementScope.m6135place70tqf50$default(placementScope, lookaheadDelegate3, j, 0.0f, 2, null);
                    }
                }, 2, null);
            }
            this.lastPosition = position;
            this.lastZIndex = zIndex;
            this.lastLayerBlock = layerBlock;
            this.lastExplicitLayer = layer;
            LayoutNodeLayoutDelegate.this.layoutState = LayoutNode.LayoutState.Idle;
        }

        @Override
        public int getMeasuredWidth() {
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            return lookaheadDelegate.getMeasuredWidth();
        }

        @Override
        public int getMeasuredHeight() {
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            return lookaheadDelegate.getMeasuredHeight();
        }

        @Override
        public int get(AlignmentLine alignmentLine) {
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if ((parent$ui_release != null ? parent$ui_release.getLayoutState$ui_release() : null) != LayoutNode.LayoutState.LookaheadMeasuring) {
                LayoutNode parent$ui_release2 = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
                if ((parent$ui_release2 != null ? parent$ui_release2.getLayoutState$ui_release() : null) == LayoutNode.LayoutState.LookaheadLayingOut) {
                    getAlignmentLines().setUsedDuringParentLayout$ui_release(true);
                }
            } else {
                getAlignmentLines().setUsedDuringParentMeasurement$ui_release(true);
            }
            this.duringAlignmentLinesQuery = true;
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            int i = lookaheadDelegate.get(alignmentLine);
            this.duringAlignmentLinesQuery = false;
            return i;
        }

        @Override
        public int minIntrinsicWidth(int height) {
            onIntrinsicsQueried();
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            return lookaheadDelegate.minIntrinsicWidth(height);
        }

        @Override
        public int maxIntrinsicWidth(int height) {
            onIntrinsicsQueried();
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            return lookaheadDelegate.maxIntrinsicWidth(height);
        }

        @Override
        public int minIntrinsicHeight(int width) {
            onIntrinsicsQueried();
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            return lookaheadDelegate.minIntrinsicHeight(width);
        }

        @Override
        public int maxIntrinsicHeight(int width) {
            onIntrinsicsQueried();
            LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate);
            return lookaheadDelegate.maxIntrinsicHeight(width);
        }

        private final void onIntrinsicsQueried() {
            LayoutNode.UsageByParent intrinsicsUsageByParent;
            LayoutNode.requestLookaheadRemeasure$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, false, false, false, 7, null);
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if (parent$ui_release == null || LayoutNodeLayoutDelegate.this.layoutNode.getIntrinsicsUsageByParent() != LayoutNode.UsageByParent.NotUsed) {
                return;
            }
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            int i = WhenMappings.$EnumSwitchMapping$0[parent$ui_release.getLayoutState$ui_release().ordinal()];
            if (i == 2) {
                intrinsicsUsageByParent = LayoutNode.UsageByParent.InMeasureBlock;
            } else if (i == 3) {
                intrinsicsUsageByParent = LayoutNode.UsageByParent.InLayoutBlock;
            } else {
                intrinsicsUsageByParent = parent$ui_release.getIntrinsicsUsageByParent();
            }
            layoutNode.setIntrinsicsUsageByParent$ui_release(intrinsicsUsageByParent);
        }

        public final void invalidateIntrinsicsParent(boolean forceRequest) {
            LayoutNode layoutNode;
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            LayoutNode.UsageByParent intrinsicsUsageByParent = LayoutNodeLayoutDelegate.this.layoutNode.getIntrinsicsUsageByParent();
            if (parent$ui_release == null || intrinsicsUsageByParent == LayoutNode.UsageByParent.NotUsed) {
                return;
            }
            do {
                layoutNode = parent$ui_release;
                if (layoutNode.getIntrinsicsUsageByParent() != intrinsicsUsageByParent) {
                    break;
                } else {
                    parent$ui_release = layoutNode.getParent$ui_release();
                }
            } while (parent$ui_release != null);
            int i = WhenMappings.$EnumSwitchMapping$1[intrinsicsUsageByParent.ordinal()];
            if (i == 1) {
                if (layoutNode.getLookaheadRoot() != null) {
                    LayoutNode.requestLookaheadRemeasure$ui_release$default(layoutNode, forceRequest, false, false, 6, null);
                    return;
                } else {
                    LayoutNode.requestRemeasure$ui_release$default(layoutNode, forceRequest, false, false, 6, null);
                    return;
                }
            }
            if (i == 2) {
                if (layoutNode.getLookaheadRoot() != null) {
                    layoutNode.requestLookaheadRelayout$ui_release(forceRequest);
                    return;
                } else {
                    layoutNode.requestRelayout$ui_release(forceRequest);
                    return;
                }
            }
            throw new IllegalStateException("Intrinsics isn't used by the parent".toString());
        }

        public final void invalidateParentData() {
            this.parentDataDirty = true;
        }

        public final boolean updateParentData() {
            if (getParentData() == null) {
                LookaheadDelegate lookaheadDelegate = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
                Intrinsics.checkNotNull(lookaheadDelegate);
                if (lookaheadDelegate.getParentData() == null) {
                    return false;
                }
            }
            if (!this.parentDataDirty) {
                return false;
            }
            this.parentDataDirty = false;
            LookaheadDelegate lookaheadDelegate2 = LayoutNodeLayoutDelegate.this.getOuterCoordinator().getLookaheadDelegate();
            Intrinsics.checkNotNull(lookaheadDelegate2);
            this.parentData = lookaheadDelegate2.getParentData();
            return true;
        }

        public final void onNodePlaced$ui_release() {
            this.onNodePlacedCalled = true;
            LayoutNode parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release();
            if (!getIsPlaced()) {
                markNodeAndSubtreeAsPlaced();
                if (this.relayoutWithoutParentInProgress && parent$ui_release != null) {
                    LayoutNode.requestLookaheadRelayout$ui_release$default(parent$ui_release, false, 1, null);
                }
            }
            if (parent$ui_release != null) {
                if (!this.relayoutWithoutParentInProgress && (parent$ui_release.getLayoutState$ui_release() == LayoutNode.LayoutState.LayingOut || parent$ui_release.getLayoutState$ui_release() == LayoutNode.LayoutState.LookaheadLayingOut)) {
                    if (!(this.placeOrder == Integer.MAX_VALUE)) {
                        InlineClassHelperKt.throwIllegalStateException("Place was called on a node which was placed already");
                    }
                    this.placeOrder = parent$ui_release.getLayoutDelegate().nextChildLookaheadPlaceOrder;
                    parent$ui_release.getLayoutDelegate().nextChildLookaheadPlaceOrder++;
                }
            } else {
                this.placeOrder = 0;
            }
            layoutChildren();
        }

        public final void clearPlaceOrder() {
            int i = 0;
            LayoutNodeLayoutDelegate.this.nextChildLookaheadPlaceOrder = 0;
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                do {
                    LookaheadPassDelegate lookaheadPassDelegate = content[i].getLayoutDelegate().getLookaheadPassDelegate();
                    Intrinsics.checkNotNull(lookaheadPassDelegate);
                    lookaheadPassDelegate.previousPlaceOrder = lookaheadPassDelegate.placeOrder;
                    lookaheadPassDelegate.placeOrder = Integer.MAX_VALUE;
                    if (lookaheadPassDelegate.measuredByParent == LayoutNode.UsageByParent.InLayoutBlock) {
                        lookaheadPassDelegate.measuredByParent = LayoutNode.UsageByParent.NotUsed;
                    }
                    i++;
                } while (i < size);
            }
        }

        private final void markNodeAndSubtreeAsPlaced() {
            boolean isPlaced = getIsPlaced();
            setPlaced(true);
            if (!isPlaced && LayoutNodeLayoutDelegate.this.getLookaheadMeasurePending()) {
                LayoutNode.requestLookaheadRemeasure$ui_release$default(LayoutNodeLayoutDelegate.this.layoutNode, true, false, false, 6, null);
            }
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode = content[i];
                    LookaheadPassDelegate lookaheadPassDelegate$ui_release = layoutNode.getLookaheadPassDelegate$ui_release();
                    if (lookaheadPassDelegate$ui_release == null) {
                        throw new IllegalArgumentException("Error: Child node's lookahead pass delegate cannot be null when in a lookahead scope.".toString());
                    }
                    if (lookaheadPassDelegate$ui_release.placeOrder != Integer.MAX_VALUE) {
                        lookaheadPassDelegate$ui_release.markNodeAndSubtreeAsPlaced();
                        layoutNode.rescheduleRemeasureOrRelayout$ui_release(layoutNode);
                    }
                    i++;
                } while (i < size);
            }
        }

        private final void onBeforeLayoutChildren() {
            LayoutNode layoutNode = LayoutNodeLayoutDelegate.this.layoutNode;
            LayoutNodeLayoutDelegate layoutNodeLayoutDelegate = LayoutNodeLayoutDelegate.this;
            MutableVector<LayoutNode> mutableVector = layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LayoutNode layoutNode2 = content[i];
                    if (layoutNode2.getLookaheadMeasurePending$ui_release() && layoutNode2.getMeasuredByParentInLookahead$ui_release() == LayoutNode.UsageByParent.InMeasureBlock) {
                        LookaheadPassDelegate lookaheadPassDelegate = layoutNode2.getLayoutDelegate().getLookaheadPassDelegate();
                        Intrinsics.checkNotNull(lookaheadPassDelegate);
                        Constraints constraintsM6264getLastLookaheadConstraintsDWUhwKw = layoutNode2.getLayoutDelegate().m6264getLastLookaheadConstraintsDWUhwKw();
                        Intrinsics.checkNotNull(constraintsM6264getLastLookaheadConstraintsDWUhwKw);
                        if (lookaheadPassDelegate.m6268remeasureBRTryo0(constraintsM6264getLastLookaheadConstraintsDWUhwKw.unbox-impl())) {
                            LayoutNode.requestLookaheadRemeasure$ui_release$default(layoutNodeLayoutDelegate.layoutNode, false, false, false, 7, null);
                        }
                    }
                    i++;
                } while (i < size);
            }
        }

        public final void replace() {
            LayoutNode parent$ui_release;
            try {
                this.relayoutWithoutParentInProgress = true;
                if (!this.placedOnce) {
                    InlineClassHelperKt.throwIllegalStateException("replace() called on item that was not placed");
                }
                this.onNodePlacedCalled = false;
                boolean isPlaced = getIsPlaced();
                m6265placeSelfMLgxB_4(this.lastPosition, 0.0f, this.lastLayerBlock, this.lastExplicitLayer);
                if (isPlaced && !this.onNodePlacedCalled && (parent$ui_release = LayoutNodeLayoutDelegate.this.layoutNode.getParent$ui_release()) != null) {
                    LayoutNode.requestLookaheadRelayout$ui_release$default(parent$ui_release, false, 1, null);
                }
            } finally {
                this.relayoutWithoutParentInProgress = false;
            }
        }

        public final void onNodeDetached() {
            this.placeOrder = Integer.MAX_VALUE;
            this.previousPlaceOrder = Integer.MAX_VALUE;
            setPlaced(false);
        }

        public final void checkChildrenPlaceOrderForUpdates() {
            MutableVector<LayoutNode> mutableVector = LayoutNodeLayoutDelegate.this.layoutNode.get_children$ui_release();
            int size = mutableVector.getSize();
            if (size > 0) {
                LayoutNode[] content = mutableVector.getContent();
                int i = 0;
                do {
                    LookaheadPassDelegate lookaheadPassDelegate = content[i].getLayoutDelegate().getLookaheadPassDelegate();
                    Intrinsics.checkNotNull(lookaheadPassDelegate);
                    int i2 = lookaheadPassDelegate.previousPlaceOrder;
                    int i3 = lookaheadPassDelegate.placeOrder;
                    if (i2 != i3 && i3 == Integer.MAX_VALUE) {
                        lookaheadPassDelegate.markSubtreeAsNotPlaced();
                    }
                    i++;
                } while (i < size);
            }
        }
    }

    public final void m6262performMeasureBRTryo0(long constraints) {
        if (!(this.layoutState == LayoutNode.LayoutState.Idle)) {
            InlineClassHelperKt.throwIllegalStateException("layout state is not idle before measure starts");
        }
        this.layoutState = LayoutNode.LayoutState.Measuring;
        this.measurePending = false;
        this.performMeasureConstraints = constraints;
        LayoutNodeKt.requireOwner(this.layoutNode).getSnapshotObserver().observeMeasureSnapshotReads$ui_release(this.layoutNode, false, this.performMeasureBlock);
        if (this.layoutState == LayoutNode.LayoutState.Measuring) {
            markLayoutPending$ui_release();
            this.layoutState = LayoutNode.LayoutState.Idle;
        }
    }

    public final void m6261performLookaheadMeasureBRTryo0(final long constraints) {
        this.layoutState = LayoutNode.LayoutState.LookaheadMeasuring;
        this.lookaheadMeasurePending = false;
        OwnerSnapshotObserver.observeMeasureSnapshotReads$ui_release$default(LayoutNodeKt.requireOwner(this.layoutNode).getSnapshotObserver(), this.layoutNode, false, new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m6277invoke();
                return Unit.INSTANCE;
            }

            public final void m6277invoke() {
                LookaheadDelegate lookaheadDelegate = this.this$0.getOuterCoordinator().getLookaheadDelegate();
                Intrinsics.checkNotNull(lookaheadDelegate);
                lookaheadDelegate.mo6026measureBRTryo0(constraints);
            }
        }, 2, null);
        markLookaheadLayoutPending$ui_release();
        if (LayoutNodeLayoutDelegateKt.isOutMostLookaheadRoot(this.layoutNode)) {
            markLayoutPending$ui_release();
        } else {
            markMeasurePending$ui_release();
        }
        this.layoutState = LayoutNode.LayoutState.Idle;
    }

    public final void ensureLookaheadDelegateCreated$ui_release() {
        if (this.lookaheadPassDelegate == null) {
            this.lookaheadPassDelegate = new LookaheadPassDelegate();
        }
    }

    public final void updateParentData() {
        LayoutNode parent$ui_release;
        if (this.measurePassDelegate.updateParentData() && (parent$ui_release = this.layoutNode.getParent$ui_release()) != null) {
            LayoutNode.requestRemeasure$ui_release$default(parent$ui_release, false, false, false, 7, null);
        }
        LookaheadPassDelegate lookaheadPassDelegate = this.lookaheadPassDelegate;
        if (lookaheadPassDelegate == null || !lookaheadPassDelegate.updateParentData()) {
            return;
        }
        if (LayoutNodeLayoutDelegateKt.isOutMostLookaheadRoot(this.layoutNode)) {
            LayoutNode parent$ui_release2 = this.layoutNode.getParent$ui_release();
            if (parent$ui_release2 != null) {
                LayoutNode.requestRemeasure$ui_release$default(parent$ui_release2, false, false, false, 7, null);
                return;
            }
            return;
        }
        LayoutNode parent$ui_release3 = this.layoutNode.getParent$ui_release();
        if (parent$ui_release3 != null) {
            LayoutNode.requestLookaheadRemeasure$ui_release$default(parent$ui_release3, false, false, false, 7, null);
        }
    }

    public final void invalidateParentData() {
        this.measurePassDelegate.invalidateParentData();
        LookaheadPassDelegate lookaheadPassDelegate = this.lookaheadPassDelegate;
        if (lookaheadPassDelegate != null) {
            lookaheadPassDelegate.invalidateParentData();
        }
    }

    public final void resetAlignmentLines() {
        AlignmentLines alignmentLines;
        this.measurePassDelegate.getAlignmentLines().reset$ui_release();
        LookaheadPassDelegate lookaheadPassDelegate = this.lookaheadPassDelegate;
        if (lookaheadPassDelegate == null || (alignmentLines = lookaheadPassDelegate.getAlignmentLines()) == null) {
            return;
        }
        alignmentLines.reset$ui_release();
    }

    public final void markChildrenDirty() {
        this.measurePassDelegate.setChildDelegatesDirty$ui_release(true);
        LookaheadPassDelegate lookaheadPassDelegate = this.lookaheadPassDelegate;
        if (lookaheadPassDelegate != null) {
            lookaheadPassDelegate.setChildDelegatesDirty$ui_release(true);
        }
    }
}
