package androidx.compose.p002ui.graphics;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000 \n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010!\n\u0002\b\u0004\u001a\u0010\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u0002\u001a\n\u0010\u0004\u001a\u00020\u0005*\u00020\u0006\u001a \u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00060\b*\u00020\u00062\u000e\b\u0002\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00060\b\u001a\u0014\u0010\n\u001a\u00020\u0006*\u00020\u00062\b\b\u0002\u0010\u000b\u001a\u00020\u0006¨\u0006\f"}, d2 = {"floatCountForType", "", "type", "Landroidx/compose/ui/graphics/PathSegment$Type;", "computeDirection", "Landroidx/compose/ui/graphics/Path$Direction;", "Landroidx/compose/ui/graphics/Path;", "divide", "", "contours", "reverse", "destination", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PathGeometryKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[PathSegment.Type.values().length];
            try {
                iArr[PathSegment.Type.Move.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[PathSegment.Type.Line.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[PathSegment.Type.Quadratic.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[PathSegment.Type.Conic.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr[PathSegment.Type.Cubic.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr[PathSegment.Type.Close.ordinal()] = 6;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                iArr[PathSegment.Type.Done.ordinal()] = 7;
            } catch (NoSuchFieldError unused7) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final Path.Direction computeDirection(Path path) {
        float fCubicArea;
        PathIterator it = path.iterator();
        float[] fArr = new float[8];
        PathSegment.Type typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
        boolean z = true;
        float fCubicArea2 = 0.0f;
        float f = 0.0f;
        float f2 = 0.0f;
        float f3 = 0.0f;
        float f4 = 0.0f;
        while (typeNext$default != PathSegment.Type.Done) {
            switch (WhenMappings.$EnumSwitchMapping$0[typeNext$default.ordinal()]) {
                case 1:
                    if (z) {
                        f3 = fArr[0];
                        f4 = fArr[1];
                        z = false;
                        typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    }
                    break;
                case 2:
                    float f5 = fArr[0];
                    float f6 = fArr[1];
                    f = fArr[2];
                    f2 = fArr[3];
                    fCubicArea = BezierKt.cubicArea(f5, f6, f5, f6, f, f2, f, f2);
                    fCubicArea2 += fCubicArea;
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 3:
                    float f7 = fArr[0];
                    float f8 = fArr[1];
                    float f9 = fArr[2];
                    float f10 = fArr[3];
                    f = fArr[4];
                    f2 = fArr[5];
                    fCubicArea = BezierKt.cubicArea(f7, f8, f7 + ((f9 - f7) * 0.6666667f), f8 + ((f10 - f8) * 0.6666667f), f + ((f9 - f) * 0.6666667f), f2 + ((f10 - f2) * 0.6666667f), f, f2);
                    fCubicArea2 += fCubicArea;
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 4:
                    break;
                case 5:
                    fCubicArea2 += BezierKt.cubicArea(fArr[0], fArr[1], fArr[2], fArr[3], fArr[4], fArr[5], fArr[6], fArr[7]);
                    f = fArr[6];
                    f2 = fArr[7];
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 6:
                    if (Math.abs(f - f3) >= 8.34465E-7f || Math.abs(f2 - f4) >= 8.34465E-7f) {
                        fCubicArea2 += BezierKt.cubicArea(f, f2, f, f2, f3, f4, f3, f4);
                        f = f3;
                        f2 = f4;
                    }
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 7:
                    break;
                default:
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
            }
            if (fCubicArea2 >= 0.0f) {
                return Path.Direction.Clockwise;
            }
            return Path.Direction.CounterClockwise;
        }
        if (fCubicArea2 >= 0.0f) {
            return Path.Direction.Clockwise;
        }
        return Path.Direction.CounterClockwise;
    }

    public static List divide$default(Path path, List list, int i, Object obj) {
        if ((i & 1) != 0) {
            list = new ArrayList();
        }
        return divide(path, list);
    }

    public static final List<Path> divide(Path path, List<Path> list) {
        Path Path = AndroidPath_androidKt.Path();
        PathIterator it = path.iterator();
        float[] fArr = new float[8];
        PathSegment.Type typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
        boolean z = true;
        boolean z2 = true;
        while (typeNext$default != PathSegment.Type.Done) {
            switch (WhenMappings.$EnumSwitchMapping$0[typeNext$default.ordinal()]) {
                case 1:
                    if (!z2 && !z) {
                        list.add(Path);
                        Path = AndroidPath_androidKt.Path();
                    }
                    Path.moveTo(fArr[0], fArr[1]);
                    z2 = false;
                    z = true;
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 2:
                    Path.lineTo(fArr[2], fArr[3]);
                    z = false;
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 3:
                    Path.quadraticTo(fArr[2], fArr[3], fArr[4], fArr[5]);
                    z = false;
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 4:
                case 7:
                    break;
                case 5:
                    Path.cubicTo(fArr[2], fArr[3], fArr[4], fArr[5], fArr[6], fArr[7]);
                    z = false;
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                case 6:
                    Path.close();
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
                default:
                    typeNext$default = PathIterator.CC.next$default(it, fArr, 0, 2, null);
                    break;
            }
        }
        if (!z2 && !z) {
            list.add(Path);
        }
        return list;
    }

    public static Path reverse$default(Path path, Path path2, int i, Object obj) {
        if ((i & 1) != 0) {
            path2 = AndroidPath_androidKt.Path();
        }
        return reverse(path, path2);
    }

    public static final Path reverse(Path path, Path path2) {
        int i;
        boolean z;
        float[] fArr;
        PathIterator it = path.iterator();
        int iCalculateSize = it.calculateSize(false);
        ArrayList arrayList = new ArrayList(iCalculateSize);
        ArrayList arrayList2 = new ArrayList(iCalculateSize);
        float[] fArr2 = new float[8];
        for (PathSegment.Type typeNext$default = PathIterator.CC.next$default(it, fArr2, 0, 2, null); typeNext$default != PathSegment.Type.Done; typeNext$default = PathIterator.CC.next$default(it, fArr2, 0, 2, null)) {
            arrayList.add(typeNext$default);
            if (typeNext$default != PathSegment.Type.Close) {
                float[] fArrCopyOf = Arrays.copyOf(fArr2, floatCountForType(typeNext$default));
                Intrinsics.checkNotNullExpressionValue(fArrCopyOf, "copyOf(this, newSize)");
                arrayList2.add(fArrCopyOf);
            }
        }
        int size = arrayList2.size();
        boolean z2 = false;
        boolean z3 = true;
        for (int size2 = arrayList.size() - 1; -1 < size2; size2--) {
            if (z3) {
                int i2 = size - 1;
                fArr = (float[]) arrayList2.get(i2);
                int lastIndex = ArraysKt.getLastIndex(fArr);
                path2.moveTo(fArr[lastIndex - 1], fArr[lastIndex]);
                i = i2;
                z = false;
            } else {
                i = size;
                z = z3;
                fArr = (float[]) arrayList2.get(size);
            }
            int i3 = WhenMappings.$EnumSwitchMapping$0[((PathSegment.Type) arrayList.get(size2)).ordinal()];
            if (i3 != 1) {
                if (i3 == 2) {
                    path2.lineTo(fArr[0], fArr[1]);
                } else if (i3 != 3) {
                    if (i3 == 5) {
                        path2.cubicTo(fArr[4], fArr[5], fArr[2], fArr[3], fArr[0], fArr[1]);
                    } else if (i3 == 6) {
                        z2 = true;
                    }
                    size = i;
                    z3 = z;
                } else {
                    path2.quadraticTo(fArr[2], fArr[3], fArr[0], fArr[1]);
                }
                i--;
                size = i;
                z3 = z;
            } else {
                if (z2) {
                    path2.close();
                    z2 = false;
                }
                z3 = true;
                size = i;
            }
        }
        if (z2) {
            path2.close();
        }
        return path2;
    }

    private static final int floatCountForType(PathSegment.Type type) throws NoWhenBranchMatchedException {
        switch (WhenMappings.$EnumSwitchMapping$0[type.ordinal()]) {
            case 1:
                return 2;
            case 2:
                return 4;
            case 3:
                return 6;
            case 4:
            case 5:
                return 8;
            case 6:
            case 7:
                return 0;
            default:
                throw new NoWhenBranchMatchedException();
        }
    }
}
