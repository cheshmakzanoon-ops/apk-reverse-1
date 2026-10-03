package androidx.compose.foundation.lazy.layout;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.layout.AlignmentLine;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.layout.RulerScope;
import androidx.compose.p002ui.layout.SubcomposeMeasureScope;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000¬\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\b\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0001\u0018\u00002\u00020\u00012\u00020\u0002B\u0017\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007Je\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u00192\u0006\u0010 \u001a\u00020\u00192\u0014\b\u0002\u0010!\u001a\u000e\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u00190\"2\u001b\b\u0002\u0010$\u001a\u0015\u0012\u0004\u0012\u00020&\u0012\u0004\u0012\u00020'\u0018\u00010%¢\u0006\u0002\b(2\u0017\u0010)\u001a\u0013\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020'0%¢\u0006\u0002\b(H\u0096\u0001JH\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u00192\u0006\u0010 \u001a\u00020\u00192\u0014\b\u0002\u0010!\u001a\u000e\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\u00190\"2\u0017\u0010)\u001a\u0013\u0012\u0004\u0012\u00020*\u0012\u0004\u0012\u00020'0%¢\u0006\u0002\b(H\u0096\u0001J(\u0010+\u001a\b\u0012\u0004\u0012\u00020\u001b0\u001a2\u0006\u0010,\u001a\u00020\u00192\u0006\u0010-\u001a\u00020.H\u0016ø\u0001\u0000¢\u0006\u0004\b/\u00100J\u0017\u00101\u001a\u00020\u0019*\u000202H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b3\u00104J\u0017\u00101\u001a\u00020\u0019*\u000205H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b6\u00107J\u0016\u00108\u001a\u000202*\u000205H\u0016ø\u0001\u0000¢\u0006\u0004\b9\u0010:J\u0019\u00108\u001a\u000202*\u00020\tH\u0016ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b;\u0010<J\u0019\u00108\u001a\u000202*\u00020\u0019H\u0016ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b;\u0010=J\u0016\u0010>\u001a\u00020?*\u00020@H\u0016ø\u0001\u0000¢\u0006\u0004\bA\u0010BJ\u0017\u0010C\u001a\u00020\t*\u000202H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\bD\u0010<J\u0017\u0010C\u001a\u00020\t*\u000205H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\bE\u0010:J\r\u0010F\u001a\u00020G*\u00020HH\u0097\u0001J\u0016\u0010I\u001a\u00020@*\u00020?H\u0016ø\u0001\u0000¢\u0006\u0004\bJ\u0010BJ\u0016\u0010K\u001a\u000205*\u000202H\u0016ø\u0001\u0000¢\u0006\u0004\bL\u0010MJ\u0019\u0010K\u001a\u000205*\u00020\tH\u0016ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bN\u0010MJ\u0019\u0010K\u001a\u000205*\u00020\u0019H\u0016ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bN\u0010OR\u0014\u0010\b\u001a\u00020\t8\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\f\u001a\u00020\t8\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\r\u0010\u000bR\u0014\u0010\u000e\u001a\u00020\u000f8VX\u0096\u0005¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u0010R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u0012\u0010\u0013\u001a\u00020\u0014X\u0096\u0005¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0016R6\u0010\u0017\u001a*\u0012\u0004\u0012\u00020\u0019\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001b0\u001a0\u0018j\u0014\u0012\u0004\u0012\u00020\u0019\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001b0\u001a`\u001cX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006P"}, d2 = {"Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScopeImpl;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;", "Landroidx/compose/ui/layout/MeasureScope;", "itemContentFactory", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemContentFactory;", "subcomposeMeasureScope", "Landroidx/compose/ui/layout/SubcomposeMeasureScope;", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutItemContentFactory;Landroidx/compose/ui/layout/SubcomposeMeasureScope;)V", "density", "", "getDensity", "()F", "fontScale", "getFontScale", "isLookingAhead", "", "()Z", "itemProvider", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemProvider;", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "placeablesCache", "Ljava/util/HashMap;", "", "", "Landroidx/compose/ui/layout/Placeable;", "Lkotlin/collections/HashMap;", "layout", "Landroidx/compose/ui/layout/MeasureResult;", "width", "height", "alignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "rulers", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/RulerScope;", "", "Lkotlin/ExtensionFunctionType;", "placementBlock", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "measure", "index", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-0kLqBqw", "(IJ)Ljava/util/List;", "roundToPx", "Landroidx/compose/ui/unit/Dp;", "roundToPx-0680j_4", "(F)I", "Landroidx/compose/ui/unit/TextUnit;", "roundToPx--R2X_6o", "(J)I", "toDp", "toDp-GaN1DYA", "(J)F", "toDp-u2uoSUM", "(F)F", "(I)F", "toDpSize", "Landroidx/compose/ui/unit/DpSize;", "Landroidx/compose/ui/geometry/Size;", "toDpSize-k-rfVVM", "(J)J", "toPx", "toPx-0680j_4", "toPx--R2X_6o", "toRect", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/unit/DpRect;", "toSize", "toSize-XkaWNTQ", "toSp", "toSp-0xMU5do", "(F)J", "toSp-kPz2Gy4", "(I)J", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LazyLayoutMeasureScopeImpl implements LazyLayoutMeasureScope, MeasureScope {
    public static final int $stable = 0;
    private final LazyLayoutItemContentFactory itemContentFactory;
    private final LazyLayoutItemProvider itemProvider;
    private final HashMap<Integer, List<Placeable>> placeablesCache = new HashMap<>();
    private final SubcomposeMeasureScope subcomposeMeasureScope;

    public float getDensity() {
        return this.subcomposeMeasureScope.getDensity();
    }

    public float getFontScale() {
        return this.subcomposeMeasureScope.getFontScale();
    }

    @Override
    public LayoutDirection getLayoutDirection() {
        return this.subcomposeMeasureScope.getLayoutDirection();
    }

    @Override
    public boolean isLookingAhead() {
        return this.subcomposeMeasureScope.isLookingAhead();
    }

    @Override
    public MeasureResult layout(int width, int height, Map<AlignmentLine, Integer> alignmentLines, Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
        return this.subcomposeMeasureScope.layout(width, height, alignmentLines, placementBlock);
    }

    @Override
    public MeasureResult layout(int width, int height, Map<AlignmentLine, Integer> alignmentLines, Function1<? super RulerScope, Unit> rulers, Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
        return this.subcomposeMeasureScope.layout(width, height, alignmentLines, rulers, placementBlock);
    }

    public int m1239roundToPxR2X_6o(long j) {
        return this.subcomposeMeasureScope.roundToPx--R2X_6o(j);
    }

    public int m1240roundToPx0680j_4(float f) {
        return this.subcomposeMeasureScope.roundToPx-0680j_4(f);
    }

    public float m1241toPxR2X_6o(long j) {
        return this.subcomposeMeasureScope.toPx--R2X_6o(j);
    }

    public float m1242toPx0680j_4(float f) {
        return this.subcomposeMeasureScope.toPx-0680j_4(f);
    }

    public Rect toRect(DpRect dpRect) {
        return this.subcomposeMeasureScope.toRect(dpRect);
    }

    public LazyLayoutMeasureScopeImpl(LazyLayoutItemContentFactory lazyLayoutItemContentFactory, SubcomposeMeasureScope subcomposeMeasureScope) {
        this.itemContentFactory = lazyLayoutItemContentFactory;
        this.subcomposeMeasureScope = subcomposeMeasureScope;
        this.itemProvider = (LazyLayoutItemProvider) lazyLayoutItemContentFactory.getItemProvider().invoke();
    }

    @Override
    public List<Placeable> mo1222measure0kLqBqw(int index, long constraints) {
        List<Placeable> list = this.placeablesCache.get(Integer.valueOf(index));
        if (list != null) {
            return list;
        }
        Object key = this.itemProvider.getKey(index);
        List<Measurable> listSubcompose = this.subcomposeMeasureScope.subcompose(key, this.itemContentFactory.getContent(index, key, this.itemProvider.getContentType(index)));
        int size = listSubcompose.size();
        ArrayList arrayList = new ArrayList(size);
        for (int i = 0; i < size; i++) {
            arrayList.add(listSubcompose.get(i).mo6026measureBRTryo0(constraints));
        }
        ArrayList arrayList2 = arrayList;
        this.placeablesCache.put(Integer.valueOf(index), arrayList2);
        return arrayList2;
    }

    @Override
    public float mo1223toDpGaN1DYA(long j) {
        return this.subcomposeMeasureScope.toDp-GaN1DYA(j);
    }

    @Override
    public float mo1225toDpu2uoSUM(int i) {
        return this.subcomposeMeasureScope.toDp-u2uoSUM(i);
    }

    @Override
    public float mo1224toDpu2uoSUM(float f) {
        return this.subcomposeMeasureScope.toDp-u2uoSUM(f);
    }

    @Override
    public long mo1229toSpkPz2Gy4(float f) {
        return this.subcomposeMeasureScope.toSp-kPz2Gy4(f);
    }

    @Override
    public long mo1230toSpkPz2Gy4(int i) {
        return this.subcomposeMeasureScope.toSp-kPz2Gy4(i);
    }

    @Override
    public long mo1228toSp0xMU5do(float f) {
        return this.subcomposeMeasureScope.toSp-0xMU5do(f);
    }

    @Override
    public long mo1227toSizeXkaWNTQ(long j) {
        return this.subcomposeMeasureScope.toSize-XkaWNTQ(j);
    }

    @Override
    public long mo1226toDpSizekrfVVM(long j) {
        return this.subcomposeMeasureScope.toDpSize-k-rfVVM(j);
    }
}
