package androidx.compose.p002ui.graphics;

import android.graphics.Path;
import androidx.graphics.path.PathIterator;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;

@Metadata(d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0014\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0002\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0010\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u0016H\u0016J\t\u0010\u0017\u001a\u00020\u0016H\u0096\u0002J\t\u0010\u0018\u001a\u00020\u0019H\u0096\u0002J\u0018\u0010\u0018\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u00102\u0006\u0010\u001c\u001a\u00020\u0014H\u0016R\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012¨\u0006\u001d"}, d2 = {"Landroidx/compose/ui/graphics/AndroidPathIterator;", "Landroidx/compose/ui/graphics/PathIterator;", "path", "Landroidx/compose/ui/graphics/Path;", "conicEvaluation", "Landroidx/compose/ui/graphics/PathIterator$ConicEvaluation;", "tolerance", "", "(Landroidx/compose/ui/graphics/Path;Landroidx/compose/ui/graphics/PathIterator$ConicEvaluation;F)V", "getConicEvaluation", "()Landroidx/compose/ui/graphics/PathIterator$ConicEvaluation;", "implementation", "Landroidx/graphics/path/PathIterator;", "getPath", "()Landroidx/compose/ui/graphics/Path;", "segmentPoints", "", "getTolerance", "()F", "calculateSize", "", "includeConvertedConics", "", "hasNext", "next", "Landroidx/compose/ui/graphics/PathSegment;", "Landroidx/compose/ui/graphics/PathSegment$Type;", "outPoints", "offset", "ui-graphics_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class AndroidPathIterator implements PathIterator {
    private final PathIterator.ConicEvaluation conicEvaluation;
    private final PathIterator implementation;
    private final Path path;
    private final float[] segmentPoints = new float[8];
    private final float tolerance;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;
        public static final int[] $EnumSwitchMapping$1;

        static {
            int[] iArr = new int[PathIterator.ConicEvaluation.values().length];
            try {
                iArr[PathIterator.ConicEvaluation.AsConic.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[PathIterator.ConicEvaluation.AsQuadratics.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
            int[] iArr2 = new int[PathSegment.Type.values().length];
            try {
                iArr2[PathSegment.Type.Move.ordinal()] = 1;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr2[PathSegment.Type.Line.ordinal()] = 2;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr2[PathSegment.Type.Quadratic.ordinal()] = 3;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr2[PathSegment.Type.Conic.ordinal()] = 4;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr2[PathSegment.Type.Cubic.ordinal()] = 5;
            } catch (NoSuchFieldError unused7) {
            }
            $EnumSwitchMapping$1 = iArr2;
        }
    }

    @Override
    public void remove() {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    public AndroidPathIterator(Path path, PathIterator.ConicEvaluation conicEvaluation, float f) throws NoWhenBranchMatchedException {
        PathIterator.ConicEvaluation conicEvaluation2;
        this.path = path;
        this.conicEvaluation = conicEvaluation;
        this.tolerance = f;
        Path path2 = getPath();
        if (path2 instanceof AndroidPath) {
            Path internalPath = ((AndroidPath) path2).getInternalPath();
            int i = WhenMappings.$EnumSwitchMapping$0[getConicEvaluation().ordinal()];
            if (i == 1) {
                conicEvaluation2 = PathIterator.ConicEvaluation.AsConic;
            } else {
                if (i != 2) {
                    throw new NoWhenBranchMatchedException();
                }
                conicEvaluation2 = PathIterator.ConicEvaluation.AsQuadratics;
            }
            this.implementation = new PathIterator(internalPath, conicEvaluation2, getTolerance());
            return;
        }
        throw new UnsupportedOperationException("Unable to obtain android.graphics.Path");
    }

    @Override
    public Path getPath() {
        return this.path;
    }

    @Override
    public PathIterator.ConicEvaluation getConicEvaluation() {
        return this.conicEvaluation;
    }

    @Override
    public float getTolerance() {
        return this.tolerance;
    }

    @Override
    public int calculateSize(boolean includeConvertedConics) {
        return this.implementation.calculateSize(includeConvertedConics);
    }

    @Override
    public boolean hasNext() {
        return this.implementation.hasNext();
    }

    @Override
    public PathSegment.Type next(float[] outPoints, int offset) {
        return AndroidPathIterator_androidKt.toPathSegmentType(this.implementation.next(outPoints, offset));
    }

    @Override
    public PathSegment next() throws NoWhenBranchMatchedException {
        float[] fArr;
        float[] fArr2;
        float f;
        float[] fArr3 = this.segmentPoints;
        PathSegment.Type pathSegmentType = AndroidPathIterator_androidKt.toPathSegmentType(this.implementation.next(fArr3, 0));
        if (pathSegmentType == PathSegment.Type.Done) {
            return PathSegmentKt.getDoneSegment();
        }
        if (pathSegmentType == PathSegment.Type.Close) {
            return PathSegmentKt.getCloseSegment();
        }
        int i = WhenMappings.$EnumSwitchMapping$1[pathSegmentType.ordinal()];
        if (i == 1) {
            fArr = new float[]{fArr3[0], fArr3[1]};
        } else if (i == 2) {
            fArr = new float[]{fArr3[0], fArr3[1], fArr3[2], fArr3[3]};
        } else if (i == 3 || i == 4) {
            fArr = new float[]{fArr3[0], fArr3[1], fArr3[2], fArr3[3], fArr3[4], fArr3[5]};
        } else {
            if (i == 5) {
                fArr = new float[]{fArr3[0], fArr3[1], fArr3[2], fArr3[3], fArr3[4], fArr3[5], fArr3[6], fArr3[7]};
            } else {
                fArr2 = new float[0];
            }
            if (pathSegmentType == PathSegment.Type.Conic) {
                f = fArr3[6];
            } else {
                f = 0.0f;
            }
            return new PathSegment(pathSegmentType, fArr2, f);
        }
        fArr2 = fArr;
        if (pathSegmentType == PathSegment.Type.Conic) {
            f = fArr3[6];
        } else {
            f = 0.0f;
        }
        return new PathSegment(pathSegmentType, fArr2, f);
    }
}
