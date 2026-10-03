package androidx.compose.p002ui.graphics;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.Rect;
import java.util.ArrayList;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u001b\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0012H\u0086\u0002ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014J\u0018\u0010\u0015\u001a\u00020\u00162\u0006\u0010\n\u001a\u00020\u000b2\b\b\u0003\u0010\r\u001a\u00020\u000eR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0017"}, d2 = {"Landroidx/compose/ui/graphics/PathHitTester;", "", "()V", "bounds", "Landroidx/compose/ui/geometry/Rect;", "curves", "", "intervals", "Landroidx/compose/ui/graphics/IntervalTree;", "Landroidx/compose/ui/graphics/PathSegment;", "path", "Landroidx/compose/ui/graphics/Path;", "roots", "tolerance", "", "contains", "", "position", "Landroidx/compose/ui/geometry/Offset;", "contains-k-4lQ0M", "(J)Z", "updatePath", "", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PathHitTester {
    private Path path = PathHitTesterKt.EmptyPath;
    private float tolerance = 0.5f;
    private Rect bounds = Rect.INSTANCE.getZero();
    private final IntervalTree<PathSegment> intervals = new IntervalTree<>();
    private final float[] curves = new float[20];
    private final float[] roots = new float[2];

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[PathSegment.Type.values().length];
            try {
                iArr[PathSegment.Type.Line.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[PathSegment.Type.Quadratic.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[PathSegment.Type.Cubic.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[PathSegment.Type.Done.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static void updatePath$default(PathHitTester pathHitTester, Path path, float f, int i, Object obj) {
        if ((i & 2) != 0) {
            f = 0.5f;
        }
        pathHitTester.updatePath(path, f);
    }

    public final void updatePath(Path path, float tolerance) {
        this.path = path;
        this.tolerance = tolerance;
        this.bounds = path.getBounds();
        this.intervals.clear();
        PathIterator it = path.iterator(PathIterator.ConicEvaluation.AsQuadratics, tolerance);
        while (it.hasNext()) {
            PathSegment next = it.next();
            int i = WhenMappings.$EnumSwitchMapping$0[next.getType().ordinal()];
            if (i == 1 || i == 2 || i == 3) {
                long jComputeVerticalBounds$default = BezierKt.computeVerticalBounds$default(next, this.curves, 0, 4, null);
                this.intervals.addInterval(Float.intBitsToFloat((int) (jComputeVerticalBounds$default >> 32)), Float.intBitsToFloat((int) (jComputeVerticalBounds$default & 4294967295L)), next);
            } else if (i == 4) {
                return;
            }
        }
    }

    public final boolean m4882containsk4lQ0M(long position) {
        int i;
        int iLineWinding;
        if (!this.path.isEmpty() && this.bounds.m4372containsk4lQ0M(position)) {
            float fM4346getXimpl = Offset.m4346getXimpl(position);
            float fM4347getYimpl = Offset.m4347getYimpl(position);
            float[] fArr = this.curves;
            float[] fArr2 = this.roots;
            IntervalTree<PathSegment> intervalTree = this.intervals;
            if (((IntervalTree) intervalTree).root != ((IntervalTree) intervalTree).terminator) {
                ArrayList arrayList = ((IntervalTree) intervalTree).stack;
                arrayList.add(((IntervalTree) intervalTree).root);
                i = 0;
                while (arrayList.size() > 0) {
                    IntervalTree.Node node = (IntervalTree.Node) CollectionsKt.removeLast(arrayList);
                    if (node.overlaps(fM4347getYimpl, fM4347getYimpl)) {
                        T data = node.getData();
                        Intrinsics.checkNotNull(data);
                        PathSegment pathSegment = (PathSegment) data;
                        float[] points = pathSegment.getPoints();
                        int i2 = WhenMappings.$EnumSwitchMapping$0[pathSegment.getType().ordinal()];
                        if (i2 == 1) {
                            iLineWinding = BezierKt.lineWinding(points, fM4346getXimpl, fM4347getYimpl);
                        } else if (i2 == 2) {
                            iLineWinding = BezierKt.quadraticWinding(points, fM4346getXimpl, fM4347getYimpl, fArr, fArr2);
                        } else if (i2 == 3) {
                            iLineWinding = BezierKt.cubicWinding(points, fM4346getXimpl, fM4347getYimpl, fArr, fArr2);
                        }
                        i += iLineWinding;
                    }
                    if (node.getLeft() != ((IntervalTree) intervalTree).terminator && node.getLeft().getMax() >= fM4347getYimpl) {
                        arrayList.add(node.getLeft());
                    }
                    if (node.getRight() != ((IntervalTree) intervalTree).terminator && node.getRight().getMin() <= fM4347getYimpl) {
                        arrayList.add(node.getRight());
                    }
                }
                arrayList.clear();
            } else {
                i = 0;
            }
            if (PathFillType.m4876equalsimpl0(this.path.mo4479getFillTypeRgk1Os(), PathFillType.INSTANCE.m4880getEvenOddRgk1Os())) {
                i &= 1;
            }
            if (i != 0) {
                return true;
            }
        }
        return false;
    }
}
