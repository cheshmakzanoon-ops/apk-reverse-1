package androidx.compose.p002ui.node;

import androidx.collection.MutableObjectFloatMap;
import androidx.collection.MutableScatterMap;
import androidx.collection.MutableScatterSet;
import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.layout.AlignmentLine;
import androidx.compose.p002ui.layout.LayoutCoordinates;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.layout.PlaceableKt;
import androidx.compose.p002ui.layout.Ruler;
import androidx.compose.p002ui.layout.RulerScope;
import androidx.compose.p002ui.layout.VerticalAlignmentLine;
import androidx.compose.p002ui.layout.VerticalRuler;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.LayoutDirection;
import java.lang.ref.WeakReference;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000²\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0007\n\u0002\u0010$\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0004\b \u0018\u0000 e2\u00020\u00012\u00020\u00022\u00020\u0003:\u0001eB\u0005¢\u0006\u0002\u0010\u0004J\u0018\u0010?\u001a\u00020@2\u0006\u0010!\u001a\u00020\"2\u0006\u0010A\u001a\u000205H\u0002J\u0010\u0010B\u001a\u00020C2\u0006\u0010D\u001a\u00020EH&J\u0017\u0010F\u001a\u00020@2\b\u0010G\u001a\u0004\u0018\u00010&H\u0000¢\u0006\u0002\bHJ\u0010\u0010F\u001a\u00020@2\u0006\u0010I\u001a\u00020JH\u0002J\u0010\u0010K\u001a\u00020\u00002\u0006\u0010A\u001a\u000205H\u0002J\u0016\u0010L\u001a\u00020M2\u0006\u0010A\u001a\u0002052\u0006\u0010N\u001a\u00020MJ\u0011\u0010O\u001a\u00020C2\u0006\u0010D\u001a\u00020EH\u0086\u0002J\u0010\u0010P\u001a\u00020@2\u0006\u0010A\u001a\u000205H\u0002J`\u0010Q\u001a\u00020&2\u0006\u0010R\u001a\u00020C2\u0006\u0010S\u001a\u00020C2\u0012\u0010T\u001a\u000e\u0012\u0004\u0012\u00020E\u0012\u0004\u0012\u00020C0U2\u0019\u0010V\u001a\u0015\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020@\u0018\u00010W¢\u0006\u0002\bX2\u0017\u0010Y\u001a\u0013\u0012\u0004\u0012\u00020,\u0012\u0004\u0012\u00020@0W¢\u0006\u0002\bXH\u0016J&\u0010Z\u001a\u00020@2\u001c\u0010[\u001a\u0018\u0012\u0014\u0012\u0012\u0012\u0004\u0012\u00020\"07j\b\u0012\u0004\u0012\u00020\"`806H\u0002J\u0016\u0010\\\u001a\u00020@2\u0006\u0010A\u001a\u0002052\u0006\u0010]\u001a\u00020MJ\u0016\u0010^\u001a\u00020@2\u0006\u0010A\u001a\u0002052\u0006\u0010]\u001a\u00020MJ\r\u0010_\u001a\u00020@H ¢\u0006\u0002\b`J\f\u0010a\u001a\u00020@*\u00020bH\u0004J\u0014\u0010c\u001a\u00020\u0013*\u00020\"2\u0006\u0010d\u001a\u00020\"H\u0002R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010\u0007\u001a\u00020\bX¦\u0004¢\u0006\u0006\u001a\u0004\b\t\u0010\nR\u0014\u0010\u000b\u001a\u0004\u0018\u00010\u0000X¦\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0012\u0010\u000e\u001a\u00020\u000fX¦\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0012\u0010\u0012\u001a\u00020\u0013X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u0015R\u001a\u0010\u0016\u001a\u00020\u00138VX\u0096\u0004¢\u0006\f\u0012\u0004\b\u0017\u0010\u0004\u001a\u0004\b\u0016\u0010\u0015R\u001a\u0010\u0018\u001a\u00020\u0013X\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0018\u0010\u0015\"\u0004\b\u0019\u0010\u001aR\u001a\u0010\u001b\u001a\u00020\u0013X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u0015\"\u0004\b\u001d\u0010\u001aR\u001a\u0010\u001e\u001a\u00020\u0013X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010\u0015\"\u0004\b \u0010\u001aR\u0012\u0010!\u001a\u00020\"X¦\u0004¢\u0006\u0006\u001a\u0004\b#\u0010$R\u0012\u0010%\u001a\u00020&X \u0004¢\u0006\u0006\u001a\u0004\b'\u0010(R\u0014\u0010)\u001a\u0004\u0018\u00010\u0000X¦\u0004¢\u0006\u0006\u001a\u0004\b*\u0010\rR\u0011\u0010+\u001a\u00020,¢\u0006\b\n\u0000\u001a\u0004\b-\u0010.R\u0018\u0010/\u001a\u000200X¦\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b1\u00102R2\u00103\u001a&\u0012\u0004\u0012\u000205\u0012\u001a\u0012\u0018\u0012\u0014\u0012\u0012\u0012\u0004\u0012\u00020\"07j\b\u0012\u0004\u0012\u00020\"`806\u0018\u000104X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u00109\u001a\u00020\u00068F¢\u0006\u0006\u001a\u0004\b:\u0010;R\u0016\u0010<\u001a\n\u0012\u0004\u0012\u000205\u0018\u00010=X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010>\u001a\n\u0012\u0004\u0012\u000205\u0018\u00010=X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006f"}, d2 = {"Landroidx/compose/ui/node/LookaheadCapablePlaceable;", "Landroidx/compose/ui/layout/Placeable;", "Landroidx/compose/ui/node/MeasureScopeWithLayoutNode;", "Landroidx/compose/ui/node/MotionReferencePlacementDelegate;", "()V", "_rulerScope", "Landroidx/compose/ui/layout/RulerScope;", "alignmentLinesOwner", "Landroidx/compose/ui/node/AlignmentLinesOwner;", "getAlignmentLinesOwner", "()Landroidx/compose/ui/node/AlignmentLinesOwner;", "child", "getChild", "()Landroidx/compose/ui/node/LookaheadCapablePlaceable;", "coordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "getCoordinates", "()Landroidx/compose/ui/layout/LayoutCoordinates;", "hasMeasureResult", "", "getHasMeasureResult", "()Z", "isLookingAhead", "isLookingAhead$annotations", "isPlacedUnderMotionFrameOfReference", "setPlacedUnderMotionFrameOfReference", "(Z)V", "isPlacingForAlignment", "isPlacingForAlignment$ui_release", "setPlacingForAlignment$ui_release", "isShallowPlacing", "isShallowPlacing$ui_release", "setShallowPlacing$ui_release", "layoutNode", "Landroidx/compose/ui/node/LayoutNode;", "getLayoutNode", "()Landroidx/compose/ui/node/LayoutNode;", "measureResult", "Landroidx/compose/ui/layout/MeasureResult;", "getMeasureResult$ui_release", "()Landroidx/compose/ui/layout/MeasureResult;", "parent", "getParent", "placementScope", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "getPlacementScope", "()Landroidx/compose/ui/layout/Placeable$PlacementScope;", "position", "Landroidx/compose/ui/unit/IntOffset;", "getPosition-nOcc-ac", "()J", "rulerReaders", "Landroidx/collection/MutableScatterMap;", "Landroidx/compose/ui/layout/Ruler;", "Landroidx/collection/MutableScatterSet;", "Ljava/lang/ref/WeakReference;", "Landroidx/compose/ui/node/WeakReference;", "rulerScope", "getRulerScope", "()Landroidx/compose/ui/layout/RulerScope;", "rulerValues", "Landroidx/collection/MutableObjectFloatMap;", "rulerValuesCache", "addRulerReader", "", "ruler", "calculateAlignmentLine", "", "alignmentLine", "Landroidx/compose/ui/layout/AlignmentLine;", "captureRulers", "result", "captureRulers$ui_release", "placeableResult", "Landroidx/compose/ui/node/PlaceableResult;", "findAncestorRulerDefiner", "findRulerValue", "", "defaultValue", "get", "invalidateChildrenOfDefiningRuler", "layout", "width", "height", "alignmentLines", "", "rulers", "Lkotlin/Function1;", "Lkotlin/ExtensionFunctionType;", "placementBlock", "notifyRulerValueChange", "layoutNodes", "provideRelativeRulerValue", "value", "provideRulerValue", "replace", "replace$ui_release", "invalidateAlignmentLinesFromPositionChange", "Landroidx/compose/ui/node/NodeCoordinator;", "isLayoutNodeAncestor", "ancestor", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class LookaheadCapablePlaceable extends Placeable implements MeasureScopeWithLayoutNode, MotionReferencePlacementDelegate {
    public static final int $stable = 0;
    private static final Function1<PlaceableResult, Unit> onCommitAffectingRuler = new Function1<PlaceableResult, Unit>() {
        public Object invoke(Object obj) {
            invoke((PlaceableResult) obj);
            return Unit.INSTANCE;
        }

        public final void invoke(PlaceableResult placeableResult) {
            if (placeableResult.isValidOwnerScope()) {
                placeableResult.getPlaceable().captureRulers(placeableResult);
            }
        }
    };
    private RulerScope _rulerScope;
    private boolean isPlacedUnderMotionFrameOfReference;
    private boolean isPlacingForAlignment;
    private boolean isShallowPlacing;
    private final Placeable.PlacementScope placementScope = PlaceableKt.PlacementScope(this);
    private MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> rulerReaders;
    private MutableObjectFloatMap<Ruler> rulerValues;
    private MutableObjectFloatMap<Ruler> rulerValuesCache;

    public static void isLookingAhead$annotations() {
    }

    public abstract int calculateAlignmentLine(AlignmentLine alignmentLine);

    public abstract AlignmentLinesOwner getAlignmentLinesOwner();

    public abstract LookaheadCapablePlaceable getChild();

    public abstract LayoutCoordinates getCoordinates();

    public abstract boolean getHasMeasureResult();

    @Override
    public abstract LayoutNode getLayoutNode();

    public abstract MeasureResult getMeasureResult$ui_release();

    public abstract LookaheadCapablePlaceable getParent();

    public abstract long getPosition();

    @Override
    public boolean isLookingAhead() {
        return false;
    }

    @Override
    public MeasureResult layout(int i, int i2, Map map, Function1 function1) {
        return MeasureScope.CC.$default$layout(this, i, i2, map, function1);
    }

    public abstract void replace$ui_release();

    public int m6280roundToPxR2X_6o(long j) {
        return Density.-CC.$default$roundToPx--R2X_6o(this, j);
    }

    public int m6281roundToPx0680j_4(float f) {
        return Density.-CC.$default$roundToPx-0680j_4(this, f);
    }

    public float m6282toDpGaN1DYA(long j) {
        return FontScaling.-CC.$default$toDp-GaN1DYA(this, j);
    }

    public float m6283toDpu2uoSUM(float f) {
        return Density.-CC.$default$toDp-u2uoSUM(this, f);
    }

    public float m6284toDpu2uoSUM(int i) {
        return Density.-CC.$default$toDp-u2uoSUM(this, i);
    }

    public long m6285toDpSizekrfVVM(long j) {
        return Density.-CC.$default$toDpSize-k-rfVVM(this, j);
    }

    public float m6286toPxR2X_6o(long j) {
        return Density.-CC.$default$toPx--R2X_6o(this, j);
    }

    public float m6287toPx0680j_4(float f) {
        return Density.-CC.$default$toPx-0680j_4(this, f);
    }

    public Rect toRect(DpRect dpRect) {
        return Density.-CC.$default$toRect(this, dpRect);
    }

    public long m6288toSizeXkaWNTQ(long j) {
        return Density.-CC.$default$toSize-XkaWNTQ(this, j);
    }

    public long m6289toSp0xMU5do(float f) {
        return FontScaling.-CC.$default$toSp-0xMU5do(this, f);
    }

    public long m6290toSpkPz2Gy4(float f) {
        return Density.-CC.$default$toSp-kPz2Gy4(this, f);
    }

    public long m6291toSpkPz2Gy4(int i) {
        return Density.-CC.$default$toSp-kPz2Gy4(this, i);
    }

    @Override
    public boolean getIsPlacedUnderMotionFrameOfReference() {
        return this.isPlacedUnderMotionFrameOfReference;
    }

    @Override
    public void setPlacedUnderMotionFrameOfReference(boolean z) {
        this.isPlacedUnderMotionFrameOfReference = z;
    }

    public final RulerScope getRulerScope() {
        RulerScope rulerScope = this._rulerScope;
        return rulerScope == null ? new RulerScope() {
            public int m6293roundToPxR2X_6o(long j) {
                return Density.-CC.$default$roundToPx--R2X_6o(this, j);
            }

            public int m6294roundToPx0680j_4(float f) {
                return Density.-CC.$default$roundToPx-0680j_4(this, f);
            }

            public float m6295toDpGaN1DYA(long j) {
                return FontScaling.-CC.$default$toDp-GaN1DYA(this, j);
            }

            public float m6296toDpu2uoSUM(float f) {
                return Density.-CC.$default$toDp-u2uoSUM(this, f);
            }

            public float m6297toDpu2uoSUM(int i) {
                return Density.-CC.$default$toDp-u2uoSUM(this, i);
            }

            public long m6298toDpSizekrfVVM(long j) {
                return Density.-CC.$default$toDpSize-k-rfVVM(this, j);
            }

            public float m6299toPxR2X_6o(long j) {
                return Density.-CC.$default$toPx--R2X_6o(this, j);
            }

            public float m6300toPx0680j_4(float f) {
                return Density.-CC.$default$toPx-0680j_4(this, f);
            }

            public Rect toRect(DpRect dpRect) {
                return Density.-CC.$default$toRect(this, dpRect);
            }

            public long m6301toSizeXkaWNTQ(long j) {
                return Density.-CC.$default$toSize-XkaWNTQ(this, j);
            }

            public long m6302toSp0xMU5do(float f) {
                return FontScaling.-CC.$default$toSp-0xMU5do(this, f);
            }

            public long m6303toSpkPz2Gy4(float f) {
                return Density.-CC.$default$toSp-kPz2Gy4(this, f);
            }

            public long m6304toSpkPz2Gy4(int i) {
                return Density.-CC.$default$toSp-kPz2Gy4(this, i);
            }

            @Override
            public LayoutCoordinates getCoordinates() {
                this.this$0.getLayoutNode().getLayoutDelegate().onCoordinatesUsed();
                return this.this$0.getCoordinates();
            }

            @Override
            public void provides(Ruler ruler, float f) {
                this.this$0.provideRulerValue(ruler, f);
            }

            @Override
            public void providesRelative(VerticalRuler verticalRuler, float f) {
                this.this$0.provideRelativeRulerValue(verticalRuler, f);
            }

            public float getDensity() {
                return this.this$0.getDensity();
            }

            public float getFontScale() {
                return this.this$0.getFontScale();
            }
        } : rulerScope;
    }

    @Override
    public final int get(AlignmentLine alignmentLine) {
        int iCalculateAlignmentLine;
        int i;
        if (!getHasMeasureResult() || (iCalculateAlignmentLine = calculateAlignmentLine(alignmentLine)) == Integer.MIN_VALUE) {
            return Integer.MIN_VALUE;
        }
        if (alignmentLine instanceof VerticalAlignmentLine) {
            i = IntOffset.getX-impl(getApparentToRealOffset());
        } else {
            i = IntOffset.getY-impl(getApparentToRealOffset());
        }
        return iCalculateAlignmentLine + i;
    }

    public final boolean getIsShallowPlacing() {
        return this.isShallowPlacing;
    }

    public final void setShallowPlacing$ui_release(boolean z) {
        this.isShallowPlacing = z;
    }

    public final boolean getIsPlacingForAlignment() {
        return this.isPlacingForAlignment;
    }

    public final void setPlacingForAlignment$ui_release(boolean z) {
        this.isPlacingForAlignment = z;
    }

    public final Placeable.PlacementScope getPlacementScope() {
        return this.placementScope;
    }

    protected final void invalidateAlignmentLinesFromPositionChange(NodeCoordinator nodeCoordinator) {
        AlignmentLines alignmentLines;
        NodeCoordinator wrapped = nodeCoordinator.getWrapped();
        if (!Intrinsics.areEqual(wrapped != null ? wrapped.getLayoutNode() : null, nodeCoordinator.getLayoutNode())) {
            nodeCoordinator.getAlignmentLinesOwner().getAlignmentLines().onAlignmentsChanged();
            return;
        }
        AlignmentLinesOwner parentAlignmentLinesOwner = nodeCoordinator.getAlignmentLinesOwner().getParentAlignmentLinesOwner();
        if (parentAlignmentLinesOwner == null || (alignmentLines = parentAlignmentLinesOwner.getAlignmentLines()) == null) {
            return;
        }
        alignmentLines.onAlignmentsChanged();
    }

    public final float findRulerValue(Ruler ruler, float defaultValue) {
        if (this.isPlacingForAlignment) {
            return defaultValue;
        }
        LookaheadCapablePlaceable lookaheadCapablePlaceable = this;
        while (true) {
            MutableObjectFloatMap<Ruler> mutableObjectFloatMap = lookaheadCapablePlaceable.rulerValues;
            float orDefault = mutableObjectFloatMap != null ? mutableObjectFloatMap.getOrDefault(ruler, Float.NaN) : Float.NaN;
            if (!Float.isNaN(orDefault)) {
                lookaheadCapablePlaceable.addRulerReader(getLayoutNode(), ruler);
                return ruler.calculateCoordinate$ui_release(orDefault, lookaheadCapablePlaceable.getCoordinates(), getCoordinates());
            }
            LookaheadCapablePlaceable parent = lookaheadCapablePlaceable.getParent();
            if (parent == null) {
                lookaheadCapablePlaceable.addRulerReader(getLayoutNode(), ruler);
                return defaultValue;
            }
            lookaheadCapablePlaceable = parent;
        }
    }

    private final void addRulerReader(LayoutNode layoutNode, Ruler ruler) {
        int i;
        int i2;
        long[] jArr;
        Object[] objArr;
        Object[] objArr2;
        int i3;
        int i4;
        Object[] objArr3;
        long[] jArr2;
        Object[] objArr4;
        long[] jArr3;
        boolean z;
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap = this.rulerReaders;
        long j = 255;
        char c = 7;
        long j2 = -9187201950435737472L;
        int i5 = 8;
        if (mutableScatterMap != null) {
            MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap2 = mutableScatterMap;
            Object[] objArr5 = mutableScatterMap2.values;
            long[] jArr4 = mutableScatterMap2.metadata;
            int length = jArr4.length - 2;
            if (length >= 0) {
                int i6 = 0;
                while (true) {
                    long j3 = jArr4[i6];
                    if ((((~j3) << c) & j3 & j2) != j2) {
                        int i7 = 8 - ((~(i6 - length)) >>> 31);
                        int i8 = 0;
                        while (i8 < i7) {
                            if ((j3 & j) < 128) {
                                MutableScatterSet mutableScatterSet = (MutableScatterSet) objArr5[(i6 << 3) + i8];
                                Object[] objArr6 = mutableScatterSet.elements;
                                long[] jArr5 = mutableScatterSet.metadata;
                                int length2 = jArr5.length - 2;
                                if (length2 >= 0) {
                                    int i9 = 0;
                                    while (true) {
                                        long j4 = jArr5[i9];
                                        objArr2 = objArr5;
                                        i3 = length;
                                        if ((((~j4) << c) & j4 & (-9187201950435737472L)) != -9187201950435737472L) {
                                            int i10 = 8 - ((~(i9 - length2)) >>> 31);
                                            int i11 = 0;
                                            while (i11 < i10) {
                                                if ((j4 & 255) < 128) {
                                                    int i12 = (i9 << 3) + i11;
                                                    LayoutNode layoutNode2 = (LayoutNode) ((WeakReference) objArr6[i12]).get();
                                                    objArr4 = objArr6;
                                                    if (layoutNode2 != null) {
                                                        boolean zIsAttached = layoutNode2.isAttached();
                                                        jArr3 = jArr5;
                                                        z = zIsAttached;
                                                        if (!z) {
                                                            mutableScatterSet.removeElementAt(i12);
                                                        }
                                                    } else {
                                                        jArr3 = jArr5;
                                                    }
                                                    if (!z) {
                                                        mutableScatterSet.removeElementAt(i12);
                                                    }
                                                } else {
                                                    objArr4 = objArr6;
                                                    jArr3 = jArr5;
                                                }
                                                j4 >>= 8;
                                                i11++;
                                                jArr5 = jArr3;
                                                objArr6 = objArr4;
                                            }
                                            objArr3 = objArr6;
                                            jArr2 = jArr5;
                                            if (i10 != 8) {
                                                break;
                                            }
                                        } else {
                                            objArr3 = objArr6;
                                            jArr2 = jArr5;
                                        }
                                        if (i9 == length2) {
                                            break;
                                        }
                                        i9++;
                                        objArr5 = objArr2;
                                        length = i3;
                                        jArr5 = jArr2;
                                        objArr6 = objArr3;
                                        c = 7;
                                    }
                                } else {
                                    objArr2 = objArr5;
                                    i3 = length;
                                }
                                i4 = 8;
                            } else {
                                objArr2 = objArr5;
                                i3 = length;
                                i4 = i5;
                            }
                            j3 >>= i4;
                            i8++;
                            i5 = i4;
                            jArr4 = jArr4;
                            objArr5 = objArr2;
                            length = i3;
                            j = 255;
                            c = 7;
                        }
                        jArr = jArr4;
                        objArr = objArr5;
                        int i13 = length;
                        if (i7 != i5) {
                            break;
                        } else {
                            length = i13;
                        }
                    } else {
                        jArr = jArr4;
                        objArr = objArr5;
                    }
                    if (i6 == length) {
                        break;
                    }
                    i6++;
                    jArr4 = jArr;
                    objArr5 = objArr;
                    j = 255;
                    c = 7;
                    j2 = -9187201950435737472L;
                    i5 = 8;
                }
            }
        }
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap3 = this.rulerReaders;
        if (mutableScatterMap3 != null) {
            long[] jArr6 = mutableScatterMap3.metadata;
            int length3 = jArr6.length - 2;
            if (length3 >= 0) {
                int i14 = 0;
                while (true) {
                    long j5 = jArr6[i14];
                    if ((((~j5) << 7) & j5 & (-9187201950435737472L)) != -9187201950435737472L) {
                        int i15 = 8 - ((~(i14 - length3)) >>> 31);
                        for (int i16 = 0; i16 < i15; i16++) {
                            if ((j5 & 255) < 128) {
                                int i17 = (i14 << 3) + i16;
                                if (((MutableScatterSet) mutableScatterMap3.values[i17]).isEmpty()) {
                                    mutableScatterMap3.removeValueAt(i17);
                                }
                            }
                            j5 >>= 8;
                        }
                        if (i15 != 8) {
                            break;
                        }
                    }
                    if (i14 == length3) {
                        break;
                    } else {
                        i14++;
                    }
                }
            }
        }
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap4 = this.rulerReaders;
        if (mutableScatterMap4 == null) {
            i = 1;
            i2 = 0;
            mutableScatterMap4 = new MutableScatterMap<>(0, 1, null);
            this.rulerReaders = mutableScatterMap4;
        } else {
            i = 1;
            i2 = 0;
        }
        MutableScatterSet<WeakReference<LayoutNode>> mutableScatterSet2 = mutableScatterMap4.get(ruler);
        if (mutableScatterSet2 == null) {
            mutableScatterSet2 = new MutableScatterSet<>(i2, i, null);
            mutableScatterMap4.set(ruler, mutableScatterSet2);
        }
        mutableScatterSet2.plusAssign(new WeakReference<>(layoutNode));
    }

    private final LookaheadCapablePlaceable findAncestorRulerDefiner(Ruler ruler) {
        LookaheadCapablePlaceable parent;
        LookaheadCapablePlaceable lookaheadCapablePlaceable = this;
        while (true) {
            MutableObjectFloatMap<Ruler> mutableObjectFloatMap = lookaheadCapablePlaceable.rulerValues;
            if ((mutableObjectFloatMap != null && mutableObjectFloatMap.contains(ruler)) || (parent = lookaheadCapablePlaceable.getParent()) == null) {
                return lookaheadCapablePlaceable;
            }
            lookaheadCapablePlaceable = parent;
        }
    }

    private final boolean isLayoutNodeAncestor(LayoutNode layoutNode, LayoutNode layoutNode2) {
        if (layoutNode == layoutNode2) {
            return true;
        }
        LayoutNode parent$ui_release = layoutNode.getParent$ui_release();
        if (parent$ui_release != null) {
            return isLayoutNodeAncestor(parent$ui_release, layoutNode2);
        }
        return false;
    }

    private final void invalidateChildrenOfDefiningRuler(Ruler ruler) {
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap = findAncestorRulerDefiner(ruler).rulerReaders;
        MutableScatterSet<WeakReference<LayoutNode>> mutableScatterSetRemove = mutableScatterMap != null ? mutableScatterMap.remove(ruler) : null;
        if (mutableScatterSetRemove != null) {
            notifyRulerValueChange(mutableScatterSetRemove);
        }
    }

    public final void captureRulers$ui_release(MeasureResult result) {
        if (result != null) {
            captureRulers(new PlaceableResult(result, this));
            return;
        }
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap = this.rulerReaders;
        if (mutableScatterMap != null) {
            MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap2 = mutableScatterMap;
            Object[] objArr = mutableScatterMap2.values;
            long[] jArr = mutableScatterMap2.metadata;
            int length = jArr.length - 2;
            if (length >= 0) {
                int i = 0;
                while (true) {
                    long j = jArr[i];
                    if ((((~j) << 7) & j & (-9187201950435737472L)) == -9187201950435737472L) {
                        if (i != length) {
                            break;
                            break;
                        }
                        i++;
                    } else {
                        int i2 = 8 - ((~(i - length)) >>> 31);
                        for (int i3 = 0; i3 < i2; i3++) {
                            if ((255 & j) < 128) {
                                notifyRulerValueChange((MutableScatterSet) objArr[(i << 3) + i3]);
                            }
                            j >>= 8;
                        }
                        if (i2 != 8) {
                            break;
                        } else if (i != length) {
                            break;
                        } else {
                            i++;
                        }
                    }
                }
            }
        }
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap3 = this.rulerReaders;
        if (mutableScatterMap3 != null) {
            mutableScatterMap3.clear();
        }
        MutableObjectFloatMap<Ruler> mutableObjectFloatMap = this.rulerValues;
        if (mutableObjectFloatMap != null) {
            mutableObjectFloatMap.clear();
        }
    }

    public final void captureRulers(final PlaceableResult placeableResult) {
        LookaheadCapablePlaceable parent;
        MutableScatterSet<WeakReference<LayoutNode>> mutableScatterSetRemove;
        OwnerSnapshotObserver snapshotObserver;
        if (this.isPlacingForAlignment) {
            return;
        }
        Function1<RulerScope, Unit> rulers = placeableResult.getResult().getRulers();
        MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap = this.rulerReaders;
        char c = 7;
        if (rulers == null) {
            if (mutableScatterMap != null) {
                MutableScatterMap<Ruler, MutableScatterSet<WeakReference<LayoutNode>>> mutableScatterMap2 = mutableScatterMap;
                Object[] objArr = mutableScatterMap2.values;
                long[] jArr = mutableScatterMap2.metadata;
                int length = jArr.length - 2;
                if (length >= 0) {
                    int i = 0;
                    while (true) {
                        long j = jArr[i];
                        if ((((~j) << 7) & j & (-9187201950435737472L)) == -9187201950435737472L) {
                            if (i != length) {
                                break;
                                break;
                            }
                            i++;
                        } else {
                            int i2 = 8 - ((~(i - length)) >>> 31);
                            for (int i3 = 0; i3 < i2; i3++) {
                                if ((j & 255) < 128) {
                                    notifyRulerValueChange((MutableScatterSet) objArr[(i << 3) + i3]);
                                }
                                j >>= 8;
                            }
                            if (i2 != 8) {
                                break;
                            } else if (i != length) {
                                break;
                            } else {
                                i++;
                            }
                        }
                    }
                }
                mutableScatterMap.clear();
                return;
            }
            return;
        }
        MutableObjectFloatMap<Ruler> mutableObjectFloatMap = this.rulerValuesCache;
        if (mutableObjectFloatMap == null) {
            mutableObjectFloatMap = new MutableObjectFloatMap<>(0, 1, null);
            this.rulerValuesCache = mutableObjectFloatMap;
        }
        MutableObjectFloatMap<Ruler> mutableObjectFloatMap2 = this.rulerValues;
        if (mutableObjectFloatMap2 == null) {
            mutableObjectFloatMap2 = new MutableObjectFloatMap<>(0, 1, null);
            this.rulerValues = mutableObjectFloatMap2;
        }
        MutableObjectFloatMap<Ruler> mutableObjectFloatMap3 = mutableObjectFloatMap2;
        mutableObjectFloatMap.putAll(mutableObjectFloatMap3);
        mutableObjectFloatMap2.clear();
        Owner owner = getLayoutNode().getOwner();
        if (owner != null && (snapshotObserver = owner.getSnapshotObserver()) != null) {
            snapshotObserver.observeReads$ui_release(placeableResult, onCommitAffectingRuler, new Function0<Unit>() {
                {
                    super(0);
                }

                public Object invoke() {
                    m6292invoke();
                    return Unit.INSTANCE;
                }

                public final void m6292invoke() {
                    Function1<RulerScope, Unit> rulers2 = placeableResult.getResult().getRulers();
                    if (rulers2 != null) {
                        rulers2.invoke(this.getRulerScope());
                    }
                }
            });
        }
        if (mutableScatterMap != null) {
            MutableObjectFloatMap<Ruler> mutableObjectFloatMap4 = mutableObjectFloatMap;
            Object[] objArr2 = mutableObjectFloatMap4.keys;
            float[] fArr = mutableObjectFloatMap4.values;
            long[] jArr2 = mutableObjectFloatMap4.metadata;
            int length2 = jArr2.length - 2;
            if (length2 >= 0) {
                int i4 = 0;
                while (true) {
                    long j2 = jArr2[i4];
                    if ((((~j2) << c) & j2 & (-9187201950435737472L)) != -9187201950435737472L) {
                        int i5 = 8 - ((~(i4 - length2)) >>> 31);
                        for (int i6 = 0; i6 < i5; i6++) {
                            if ((j2 & 255) < 128) {
                                int i7 = (i4 << 3) + i6;
                                Ruler ruler = (Ruler) objArr2[i7];
                                if (mutableObjectFloatMap2.getOrDefault(ruler, Float.NaN) != fArr[i7] && (mutableScatterSetRemove = mutableScatterMap.remove(ruler)) != null) {
                                    notifyRulerValueChange(mutableScatterSetRemove);
                                }
                            }
                            j2 >>= 8;
                        }
                        if (i5 != 8) {
                            break;
                        }
                        if (i4 != length2) {
                            break;
                        }
                        i4++;
                        c = 7;
                    } else if (i4 != length2) {
                        break;
                        break;
                    } else {
                        i4++;
                        c = 7;
                    }
                }
            }
        }
        Object[] objArr3 = mutableObjectFloatMap3.keys;
        long[] jArr3 = mutableObjectFloatMap3.metadata;
        int length3 = jArr3.length - 2;
        if (length3 >= 0) {
            int i8 = 0;
            while (true) {
                long j3 = jArr3[i8];
                if ((((~j3) << 7) & j3 & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i9 = 8 - ((~(i8 - length3)) >>> 31);
                    for (int i10 = 0; i10 < i9; i10++) {
                        if ((j3 & 255) < 128) {
                            Ruler ruler2 = (Ruler) objArr3[(i8 << 3) + i10];
                            if (!mutableObjectFloatMap.contains(ruler2) && (parent = getParent()) != null) {
                                parent.invalidateChildrenOfDefiningRuler(ruler2);
                            }
                        }
                        j3 >>= 8;
                    }
                    if (i9 != 8) {
                        break;
                    }
                }
                if (i8 == length3) {
                    break;
                } else {
                    i8++;
                }
            }
        }
        mutableObjectFloatMap.clear();
    }

    private final void notifyRulerValueChange(MutableScatterSet<WeakReference<LayoutNode>> layoutNodes) {
        LayoutNode layoutNode;
        MutableScatterSet<WeakReference<LayoutNode>> mutableScatterSet = layoutNodes;
        Object[] objArr = mutableScatterSet.elements;
        long[] jArr = mutableScatterSet.metadata;
        int length = jArr.length - 2;
        if (length < 0) {
            return;
        }
        int i = 0;
        while (true) {
            long j = jArr[i];
            if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                int i2 = 8 - ((~(i - length)) >>> 31);
                for (int i3 = 0; i3 < i2; i3++) {
                    if ((255 & j) < 128 && (layoutNode = (LayoutNode) ((WeakReference) objArr[(i << 3) + i3]).get()) != null) {
                        if (isLookingAhead()) {
                            layoutNode.requestLookaheadRelayout$ui_release(false);
                        } else {
                            layoutNode.requestRelayout$ui_release(false);
                        }
                    }
                    j >>= 8;
                }
                if (i2 != 8) {
                    return;
                }
            }
            if (i == length) {
                return;
            } else {
                i++;
            }
        }
    }

    public final void provideRulerValue(Ruler ruler, float value) {
        MutableObjectFloatMap<Ruler> mutableObjectFloatMap = this.rulerValues;
        if (mutableObjectFloatMap == null) {
            mutableObjectFloatMap = new MutableObjectFloatMap<>(0, 1, null);
            this.rulerValues = mutableObjectFloatMap;
        }
        mutableObjectFloatMap.set(ruler, value);
    }

    public final void provideRelativeRulerValue(Ruler ruler, float value) {
        MutableObjectFloatMap<Ruler> mutableObjectFloatMap = this.rulerValues;
        if (mutableObjectFloatMap == null) {
            mutableObjectFloatMap = new MutableObjectFloatMap<>(0, 1, null);
            this.rulerValues = mutableObjectFloatMap;
        }
        if (getLayoutDirection() != LayoutDirection.Ltr) {
            value = getWidth() - value;
        }
        mutableObjectFloatMap.set(ruler, value);
    }

    @Override
    public MeasureResult layout(final int width, final int height, final Map<AlignmentLine, Integer> alignmentLines, final Function1<? super RulerScope, Unit> rulers, final Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
        if (!((width & (-16777216)) == 0 && ((-16777216) & height) == 0)) {
            InlineClassHelperKt.throwIllegalStateException("Size(" + width + " x " + height + ") is out of range. Each dimension must be between 0 and 16777215.");
        }
        return new MeasureResult() {
            @Override
            public int getF157$w() {
                return width;
            }

            @Override
            public int getF156$h() {
                return height;
            }

            @Override
            public Map<AlignmentLine, Integer> getAlignmentLines() {
                return alignmentLines;
            }

            @Override
            public Function1<RulerScope, Unit> getRulers() {
                return rulers;
            }

            @Override
            public void placeChildren() {
                placementBlock.invoke(this.getPlacementScope());
            }
        };
    }
}
