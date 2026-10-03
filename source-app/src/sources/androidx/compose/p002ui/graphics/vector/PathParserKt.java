package androidx.compose.p002ui.graphics.vector;

import androidx.compose.p002ui.graphics.AndroidPath_androidKt;
import androidx.compose.p002ui.graphics.Path;
import java.util.List;
import kotlin.Metadata;

@Metadata(d1 = {"\u00002\n\u0000\n\u0002\u0010\u0014\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\u001aX\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\t2\u0006\u0010\u000b\u001a\u00020\t2\u0006\u0010\f\u001a\u00020\t2\u0006\u0010\r\u001a\u00020\t2\u0006\u0010\u000e\u001a\u00020\t2\u0006\u0010\u000f\u001a\u00020\t2\u0006\u0010\u0010\u001a\u00020\t2\u0006\u0010\u0011\u001a\u00020\tH\u0002\u001aX\u0010\u0012\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\u0013\u001a\u00020\t2\u0006\u0010\u0014\u001a\u00020\t2\u0006\u0010\u0015\u001a\u00020\t2\u0006\u0010\u0016\u001a\u00020\t2\u0006\u0010\u000b\u001a\u00020\t2\u0006\u0010\f\u001a\u00020\t2\u0006\u0010\u000f\u001a\u00020\t2\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u0018H\u0002\u001a\u001a\u0010\u001a\u001a\u00020\u0007*\b\u0012\u0004\u0012\u00020\u001c0\u001b2\b\b\u0002\u0010\u001d\u001a\u00020\u0007\u001a\r\u0010\u001e\u001a\u00020\t*\u00020\tH\u0082\b\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0003¨\u0006\u001f"}, d2 = {"EmptyArray", "", "getEmptyArray", "()[F", "arcToBezier", "", "p", "Landroidx/compose/ui/graphics/Path;", "cx", "", "cy", "a", "b", "e1x", "e1y", "theta", "start", "sweep", "drawArc", "x0", "y0", "x1", "y1", "isMoreThanHalf", "", "isPositiveArc", "toPath", "", "Landroidx/compose/ui/graphics/vector/PathNode;", "target", "toRadians", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class PathParserKt {
    private static final float[] EmptyArray = new float[0];

    private static final double toRadians(double d) {
        return (d / ((double) 180)) * 3.141592653589793d;
    }

    public static final float[] getEmptyArray() {
        return EmptyArray;
    }

    public static Path toPath$default(List list, Path path, int i, Object obj) {
        if ((i & 1) != 0) {
            path = AndroidPath_androidKt.Path();
        }
        return toPath(list, path);
    }

    public static final Path toPath(List<? extends PathNode> list, Path path) {
        float f;
        float f2;
        float x1;
        float dy1;
        float dy;
        float x2;
        float y2;
        float dy2;
        float f3;
        float f4;
        float y1;
        float x3;
        float y3;
        float f5;
        float f6;
        List<? extends PathNode> list2 = list;
        Path path2 = path;
        int iMo4479getFillTypeRgk1Os = path.mo4479getFillTypeRgk1Os();
        path.rewind();
        path2.mo4481setFillTypeoQ8Xj4U(iMo4479getFillTypeRgk1Os);
        PathNode pathNode = list.isEmpty() ? PathNode.Close.INSTANCE : list2.get(0);
        int size = list.size();
        float f7 = 0.0f;
        int i = 0;
        float x4 = 0.0f;
        float arcStartY = 0.0f;
        float arcStartX = 0.0f;
        float y = 0.0f;
        float f8 = 0.0f;
        float f9 = 0.0f;
        while (i < size) {
            PathNode pathNode2 = list2.get(i);
            if (pathNode2 instanceof PathNode.Close) {
                path.close();
                pathNode2 = pathNode2;
                f7 = f7;
                i = i;
                size = size;
                x4 = f8;
                arcStartX = x4;
                arcStartY = f9;
                y = arcStartY;
            } else {
                if (pathNode2 instanceof PathNode.RelativeMoveTo) {
                    PathNode.RelativeMoveTo relativeMoveTo = (PathNode.RelativeMoveTo) pathNode2;
                    arcStartX += relativeMoveTo.getDx();
                    y += relativeMoveTo.getDy();
                    path2.relativeMoveTo(relativeMoveTo.getDx(), relativeMoveTo.getDy());
                    f8 = arcStartX;
                } else if (pathNode2 instanceof PathNode.MoveTo) {
                    PathNode.MoveTo moveTo = (PathNode.MoveTo) pathNode2;
                    float x = moveTo.getX();
                    float y4 = moveTo.getY();
                    path2.moveTo(moveTo.getX(), moveTo.getY());
                    arcStartX = x;
                    f8 = arcStartX;
                    y = y4;
                } else {
                    if (pathNode2 instanceof PathNode.RelativeLineTo) {
                        PathNode.RelativeLineTo relativeLineTo = (PathNode.RelativeLineTo) pathNode2;
                        path2.relativeLineTo(relativeLineTo.getDx(), relativeLineTo.getDy());
                        arcStartX += relativeLineTo.getDx();
                        dy2 = relativeLineTo.getDy();
                    } else {
                        if (pathNode2 instanceof PathNode.LineTo) {
                            PathNode.LineTo lineTo = (PathNode.LineTo) pathNode2;
                            path2.lineTo(lineTo.getX(), lineTo.getY());
                            x2 = lineTo.getX();
                            y2 = lineTo.getY();
                        } else {
                            if (pathNode2 instanceof PathNode.RelativeHorizontalTo) {
                                PathNode.RelativeHorizontalTo relativeHorizontalTo = (PathNode.RelativeHorizontalTo) pathNode2;
                                path2.relativeLineTo(relativeHorizontalTo.getDx(), f7);
                                arcStartX += relativeHorizontalTo.getDx();
                            } else if (pathNode2 instanceof PathNode.HorizontalTo) {
                                PathNode.HorizontalTo horizontalTo = (PathNode.HorizontalTo) pathNode2;
                                path2.lineTo(horizontalTo.getX(), y);
                                arcStartX = horizontalTo.getX();
                            } else if (pathNode2 instanceof PathNode.RelativeVerticalTo) {
                                PathNode.RelativeVerticalTo relativeVerticalTo = (PathNode.RelativeVerticalTo) pathNode2;
                                path2.relativeLineTo(f7, relativeVerticalTo.getDy());
                                dy2 = relativeVerticalTo.getDy();
                            } else if (pathNode2 instanceof PathNode.VerticalTo) {
                                PathNode.VerticalTo verticalTo = (PathNode.VerticalTo) pathNode2;
                                path2.lineTo(arcStartX, verticalTo.getY());
                                y = verticalTo.getY();
                            } else {
                                if (pathNode2 instanceof PathNode.RelativeCurveTo) {
                                    PathNode.RelativeCurveTo relativeCurveTo = (PathNode.RelativeCurveTo) pathNode2;
                                    path.relativeCubicTo(relativeCurveTo.getDx1(), relativeCurveTo.getDy1(), relativeCurveTo.getDx2(), relativeCurveTo.getDy2(), relativeCurveTo.getDx3(), relativeCurveTo.getDy3());
                                    x1 = relativeCurveTo.getDx2() + arcStartX;
                                    dy1 = relativeCurveTo.getDy2() + y;
                                    arcStartX += relativeCurveTo.getDx3();
                                    dy = relativeCurveTo.getDy3();
                                } else {
                                    if (pathNode2 instanceof PathNode.CurveTo) {
                                        PathNode.CurveTo curveTo = (PathNode.CurveTo) pathNode2;
                                        path.cubicTo(curveTo.getX1(), curveTo.getY1(), curveTo.getX2(), curveTo.getY2(), curveTo.getX3(), curveTo.getY3());
                                        x1 = curveTo.getX2();
                                        y1 = curveTo.getY2();
                                        x3 = curveTo.getX3();
                                        y3 = curveTo.getY3();
                                    } else if (pathNode2 instanceof PathNode.RelativeReflectiveCurveTo) {
                                        if (pathNode.getIsCurve()) {
                                            f6 = y - arcStartY;
                                            f5 = arcStartX - x4;
                                        } else {
                                            f5 = f7;
                                            f6 = f5;
                                        }
                                        PathNode.RelativeReflectiveCurveTo relativeReflectiveCurveTo = (PathNode.RelativeReflectiveCurveTo) pathNode2;
                                        path.relativeCubicTo(f5, f6, relativeReflectiveCurveTo.getDx1(), relativeReflectiveCurveTo.getDy1(), relativeReflectiveCurveTo.getDx2(), relativeReflectiveCurveTo.getDy2());
                                        x1 = relativeReflectiveCurveTo.getDx1() + arcStartX;
                                        dy1 = relativeReflectiveCurveTo.getDy1() + y;
                                        arcStartX += relativeReflectiveCurveTo.getDx2();
                                        dy = relativeReflectiveCurveTo.getDy2();
                                    } else if (pathNode2 instanceof PathNode.ReflectiveCurveTo) {
                                        if (pathNode.getIsCurve()) {
                                            float f10 = 2;
                                            f4 = (f10 * y) - arcStartY;
                                            f3 = (arcStartX * f10) - x4;
                                        } else {
                                            f3 = arcStartX;
                                            f4 = y;
                                        }
                                        PathNode.ReflectiveCurveTo reflectiveCurveTo = (PathNode.ReflectiveCurveTo) pathNode2;
                                        path.cubicTo(f3, f4, reflectiveCurveTo.getX1(), reflectiveCurveTo.getY1(), reflectiveCurveTo.getX2(), reflectiveCurveTo.getY2());
                                        x1 = reflectiveCurveTo.getX1();
                                        y1 = reflectiveCurveTo.getY1();
                                        x3 = reflectiveCurveTo.getX2();
                                        y3 = reflectiveCurveTo.getY2();
                                    } else if (pathNode2 instanceof PathNode.RelativeQuadTo) {
                                        PathNode.RelativeQuadTo relativeQuadTo = (PathNode.RelativeQuadTo) pathNode2;
                                        path2.relativeQuadraticTo(relativeQuadTo.getDx1(), relativeQuadTo.getDy1(), relativeQuadTo.getDx2(), relativeQuadTo.getDy2());
                                        x4 = relativeQuadTo.getDx1() + arcStartX;
                                        arcStartY = relativeQuadTo.getDy1() + y;
                                        arcStartX += relativeQuadTo.getDx2();
                                        dy2 = relativeQuadTo.getDy2();
                                    } else if (pathNode2 instanceof PathNode.QuadTo) {
                                        PathNode.QuadTo quadTo = (PathNode.QuadTo) pathNode2;
                                        path2.quadraticTo(quadTo.getX1(), quadTo.getY1(), quadTo.getX2(), quadTo.getY2());
                                        x4 = quadTo.getX1();
                                        arcStartY = quadTo.getY1();
                                        x2 = quadTo.getX2();
                                        y2 = quadTo.getY2();
                                    } else if (pathNode2 instanceof PathNode.RelativeReflectiveQuadTo) {
                                        if (pathNode.getIsQuad()) {
                                            f = arcStartX - x4;
                                            f2 = y - arcStartY;
                                        } else {
                                            f = f7;
                                            f2 = f;
                                        }
                                        PathNode.RelativeReflectiveQuadTo relativeReflectiveQuadTo = (PathNode.RelativeReflectiveQuadTo) pathNode2;
                                        path2.relativeQuadraticTo(f, f2, relativeReflectiveQuadTo.getDx(), relativeReflectiveQuadTo.getDy());
                                        x1 = f + arcStartX;
                                        dy1 = f2 + y;
                                        arcStartX += relativeReflectiveQuadTo.getDx();
                                        dy = relativeReflectiveQuadTo.getDy();
                                    } else if (pathNode2 instanceof PathNode.ReflectiveQuadTo) {
                                        if (pathNode.getIsQuad()) {
                                            float f11 = 2;
                                            arcStartX = (arcStartX * f11) - x4;
                                            y = (f11 * y) - arcStartY;
                                        }
                                        PathNode.ReflectiveQuadTo reflectiveQuadTo = (PathNode.ReflectiveQuadTo) pathNode2;
                                        path2.quadraticTo(arcStartX, y, reflectiveQuadTo.getX(), reflectiveQuadTo.getY());
                                        float x5 = reflectiveQuadTo.getX();
                                        arcStartY = y;
                                        pathNode2 = pathNode2;
                                        f7 = f7;
                                        i = i;
                                        size = size;
                                        y = reflectiveQuadTo.getY();
                                        float f12 = arcStartX;
                                        arcStartX = x5;
                                        x4 = f12;
                                    } else if (pathNode2 instanceof PathNode.RelativeArcTo) {
                                        PathNode.RelativeArcTo relativeArcTo = (PathNode.RelativeArcTo) pathNode2;
                                        float arcStartDx = relativeArcTo.getArcStartDx() + arcStartX;
                                        float arcStartDy = relativeArcTo.getArcStartDy() + y;
                                        pathNode2 = pathNode2;
                                        i = i;
                                        f7 = 0.0f;
                                        size = size;
                                        drawArc(path, arcStartX, y, arcStartDx, arcStartDy, relativeArcTo.getHorizontalEllipseRadius(), relativeArcTo.getVerticalEllipseRadius(), relativeArcTo.getTheta(), relativeArcTo.isMoreThanHalf(), relativeArcTo.isPositiveArc());
                                        arcStartY = arcStartDy;
                                        y = arcStartY;
                                        x4 = arcStartDx;
                                        arcStartX = x4;
                                    } else {
                                        pathNode2 = pathNode2;
                                        f7 = f7;
                                        i = i;
                                        size = size;
                                        if (pathNode2 instanceof PathNode.ArcTo) {
                                            PathNode.ArcTo arcTo = (PathNode.ArcTo) pathNode2;
                                            drawArc(path, arcStartX, y, arcTo.getArcStartX(), arcTo.getArcStartY(), arcTo.getHorizontalEllipseRadius(), arcTo.getVerticalEllipseRadius(), arcTo.getTheta(), arcTo.isMoreThanHalf(), arcTo.isPositiveArc());
                                            arcStartX = arcTo.getArcStartX();
                                            arcStartY = arcTo.getArcStartY();
                                            y = arcStartY;
                                            x4 = arcStartX;
                                        }
                                    }
                                    arcStartX = x3;
                                    y = y3;
                                    arcStartY = y1;
                                    x4 = x1;
                                }
                                y += dy;
                                arcStartY = dy1;
                                x4 = x1;
                            }
                            pathNode2 = pathNode2;
                            f7 = f7;
                            i = i;
                            size = size;
                        }
                        y = y2;
                        arcStartX = x2;
                        pathNode2 = pathNode2;
                        f7 = f7;
                        i = i;
                        size = size;
                    }
                    y += dy2;
                    pathNode2 = pathNode2;
                    f7 = f7;
                    i = i;
                    size = size;
                }
                f9 = y;
                pathNode2 = pathNode2;
                f7 = f7;
                i = i;
                size = size;
            }
            i++;
            path2 = path;
            pathNode = pathNode2;
            f7 = f7;
            size = size;
            list2 = list;
        }
        return path;
    }

    private static final void drawArc(Path path, double d, double d2, double d3, double d4, double d5, double d6, double d7, boolean z, boolean z2) {
        double d8;
        double d9;
        double d10 = (d7 / ((double) 180)) * 3.141592653589793d;
        double dCos = Math.cos(d10);
        double dSin = Math.sin(d10);
        double d11 = ((d * dCos) + (d2 * dSin)) / d5;
        double d12 = (((-d) * dSin) + (d2 * dCos)) / d6;
        double d13 = ((d3 * dCos) + (d4 * dSin)) / d5;
        double d14 = (((-d3) * dSin) + (d4 * dCos)) / d6;
        double d15 = d11 - d13;
        double d16 = d12 - d14;
        double d17 = 2;
        double d18 = (d11 + d13) / d17;
        double d19 = (d12 + d14) / d17;
        double d20 = (d15 * d15) + (d16 * d16);
        if (d20 == 0.0d) {
            return;
        }
        double d21 = (1.0d / d20) - 0.25d;
        if (d21 < 0.0d) {
            double dSqrt = (float) (Math.sqrt(d20) / 1.99999d);
            drawArc(path, d, d2, d3, d4, d5 * dSqrt, d6 * dSqrt, d7, z, z2);
            return;
        }
        double dSqrt2 = Math.sqrt(d21);
        double d22 = d15 * dSqrt2;
        double d23 = dSqrt2 * d16;
        if (z == z2) {
            d8 = d18 - d23;
            d9 = d19 + d22;
        } else {
            d8 = d18 + d23;
            d9 = d19 - d22;
        }
        double dAtan2 = Math.atan2(d12 - d9, d11 - d8);
        double dAtan3 = Math.atan2(d14 - d9, d13 - d8) - dAtan2;
        if (z2 != (dAtan3 >= 0.0d)) {
            dAtan3 = dAtan3 > 0.0d ? dAtan3 - 6.283185307179586d : dAtan3 + 6.283185307179586d;
        }
        double d24 = d8 * d5;
        double d25 = d9 * d6;
        arcToBezier(path, (d24 * dCos) - (d25 * dSin), (d24 * dSin) + (d25 * dCos), d5, d6, d, d2, d10, dAtan2, dAtan3);
    }

    private static final void arcToBezier(Path path, double d, double d2, double d3, double d4, double d5, double d6, double d7, double d8, double d9) {
        double d10 = d3;
        double d11 = 4;
        int iCeil = (int) Math.ceil(Math.abs((d9 * d11) / 3.141592653589793d));
        double dCos = Math.cos(d7);
        double dSin = Math.sin(d7);
        double dCos2 = Math.cos(d8);
        double dSin2 = Math.sin(d8);
        double d12 = -d10;
        double d13 = d12 * dCos;
        double d14 = d4 * dSin;
        double d15 = (d13 * dSin2) - (d14 * dCos2);
        double d16 = d12 * dSin;
        double d17 = d4 * dCos;
        double d18 = (dSin2 * d16) + (dCos2 * d17);
        double d19 = d9 / ((double) iCeil);
        double d20 = d5;
        double d21 = d18;
        double d22 = d15;
        int i = 0;
        double d23 = d6;
        double d24 = d8;
        while (i < iCeil) {
            double d25 = d24 + d19;
            double dSin3 = Math.sin(d25);
            double dCos3 = Math.cos(d25);
            int i2 = iCeil;
            double d26 = (d + ((d10 * dCos) * dCos3)) - (d14 * dSin3);
            double d27 = d2 + (d10 * dSin * dCos3) + (d17 * dSin3);
            double d28 = (d13 * dSin3) - (d14 * dCos3);
            double d29 = (dSin3 * d16) + (dCos3 * d17);
            double d30 = d25 - d24;
            double dTan = Math.tan(d30 / ((double) 2));
            double dSin4 = (Math.sin(d30) * (Math.sqrt(d11 + ((3.0d * dTan) * dTan)) - ((double) 1))) / ((double) 3);
            path.cubicTo((float) (d20 + (d22 * dSin4)), (float) (d23 + (d21 * dSin4)), (float) (d26 - (dSin4 * d28)), (float) (d27 - (dSin4 * d29)), (float) d26, (float) d27);
            i++;
            d19 = d19;
            dSin = dSin;
            d20 = d26;
            d16 = d16;
            d24 = d25;
            d21 = d29;
            d11 = d11;
            d22 = d28;
            dCos = dCos;
            iCeil = i2;
            d23 = d27;
            d10 = d3;
        }
    }
}
