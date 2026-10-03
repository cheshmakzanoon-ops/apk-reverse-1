package androidx.compose.foundation.lazy.layout;

import androidx.collection.MutableScatterMap;
import androidx.collection.MutableScatterSet;
import androidx.collection.ScatterMapKt;
import androidx.collection.ScatterSetKt;
import androidx.compose.foundation.lazy.layout.LazyLayoutMeasuredItem;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.GraphicsContext;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.layer.GraphicsLayer;
import androidx.compose.p002ui.graphics.layer.GraphicsLayerKt;
import androidx.compose.p002ui.node.DrawModifierNode;
import androidx.compose.p002ui.node.DrawModifierNodeKt;
import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntOffsetKt;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000~\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\b\n\u0002\u0010\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0015\n\u0002\b\u0005\b\u0000\u0018\u0000*\b\b\u0000\u0010\u0001*\u00020\u00022\u00020\u0003:\u0003IJKB\u0005¢\u0006\u0002\u0010\u0004J\u0018\u0010(\u001a\u0004\u0018\u00010\u00072\u0006\u0010)\u001a\u00020\u00032\u0006\u0010*\u001a\u00020\u000bJ1\u0010+\u001a\u00020,2\u0006\u0010-\u001a\u00028\u00002\u0006\u0010&\u001a\u00020\u000b2\u0012\b\u0002\u0010.\u001a\f0\u0010R\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0002¢\u0006\u0002\u0010/J\u0082\u0001\u00100\u001a\u00020,2\u0006\u00101\u001a\u00020\u000b2\u0006\u00102\u001a\u00020\u000b2\u0006\u00103\u001a\u00020\u000b2\f\u00104\u001a\b\u0012\u0004\u0012\u00028\u00000\u00062\u0006\u0010\f\u001a\u00020\r2\f\u00105\u001a\b\u0012\u0004\u0012\u00028\u0000062\u0006\u00107\u001a\u00020#2\u0006\u00108\u001a\u00020#2\u0006\u00109\u001a\u00020\u000b2\u0006\u0010:\u001a\u00020#2\u0006\u0010;\u001a\u00020\u000b2\u0006\u0010<\u001a\u00020\u000b2\u0006\u0010=\u001a\u00020>2\u0006\u0010?\u001a\u00020@J\u0010\u0010A\u001a\u00020,2\u0006\u0010)\u001a\u00020\u0003H\u0002J\u0006\u0010B\u001a\u00020,J\u001f\u0010C\u001a\u00020,2\u0006\u0010-\u001a\u00028\u00002\b\b\u0002\u0010D\u001a\u00020#H\u0002¢\u0006\u0002\u0010EJ\u0019\u0010F\u001a\u00020\u000b*\u00020G2\u0006\u0010-\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010HR\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\b\u001a\u0004\u0018\u00010\tX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010\u000e\u001a\u0018\u0012\u0004\u0012\u00020\u0003\u0012\u000e\u0012\f0\u0010R\b\u0012\u0004\u0012\u00028\u00000\u00000\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u0011\u001a\u00020\u00128Fø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\u0015\u001a\u00020\u0016¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0019\u001a\b\u0012\u0004\u0012\u00020\u00030\u001aX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001b\u001a\b\u0012\u0004\u0012\u00028\u00000\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001c\u001a\b\u0012\u0004\u0012\u00028\u00000\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001d\u001a\b\u0012\u0004\u0012\u00028\u00000\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00000\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010\u001f\u001a\u00020\u000b*\u00020\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b \u0010!R\u0018\u0010\"\u001a\u00020#*\u00028\u00008BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b$\u0010%R\u0018\u0010&\u001a\u00020\u000b*\u00020\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b'\u0010!\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006L"}, d2 = {"Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "T", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;", "", "()V", "disappearingItems", "", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimation;", "displayingNode", "Landroidx/compose/ui/node/DrawModifierNode;", "firstVisibleIndex", "", "keyIndexMap", "Landroidx/compose/foundation/lazy/layout/LazyLayoutKeyIndexMap;", "keyToItemInfoMap", "Landroidx/collection/MutableScatterMap;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator$ItemInfo;", "minSizeToFitDisappearingItems", "Landroidx/compose/ui/unit/IntSize;", "getMinSizeToFitDisappearingItems-YbymL2g", "()J", "modifier", "Landroidx/compose/ui/Modifier;", "getModifier", "()Landroidx/compose/ui/Modifier;", "movingAwayKeys", "Landroidx/collection/MutableScatterSet;", "movingAwayToEndBound", "movingAwayToStartBound", "movingInFromEndBound", "movingInFromStartBound", "crossAxisOffset", "getCrossAxisOffset", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;)I", "hasAnimations", "", "getHasAnimations", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;)Z", "mainAxisOffset", "getMainAxisOffset", "getAnimation", "key", "placeableIndex", "initializeAnimation", "", "item", "itemInfo", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;ILandroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator$ItemInfo;)V", "onMeasured", "consumedScroll", "layoutWidth", "layoutHeight", "positionedItems", "itemProvider", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItemProvider;", "isVertical", "isLookingAhead", "laneCount", "hasLookaheadOccurred", "layoutMinOffset", "layoutMaxOffset", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "removeInfoForKey", "reset", "startPlacementAnimationsIfNeeded", "isMovingAway", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;Z)V", "updateAndReturnOffsetFor", "", "([ILandroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;)I", "DisplayingDisappearingItemsElement", "DisplayingDisappearingItemsNode", "ItemInfo", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class LazyLayoutItemAnimator<T extends LazyLayoutMeasuredItem> {
    public static final int $stable = 8;
    private DrawModifierNode displayingNode;
    private int firstVisibleIndex;
    private LazyLayoutKeyIndexMap keyIndexMap;
    private final MutableScatterMap<Object, LazyLayoutItemAnimator<T>.ItemInfo> keyToItemInfoMap = ScatterMapKt.mutableScatterMapOf();
    private final MutableScatterSet<Object> movingAwayKeys = ScatterSetKt.mutableScatterSetOf();
    private final List<T> movingInFromStartBound = new ArrayList();
    private final List<T> movingInFromEndBound = new ArrayList();
    private final List<T> movingAwayToStartBound = new ArrayList();
    private final List<T> movingAwayToEndBound = new ArrayList();
    private final List<LazyLayoutItemAnimation> disappearingItems = new ArrayList();
    private final Modifier modifier = new DisplayingDisappearingItemsElement(this);

    public final void onMeasured(int consumedScroll, int layoutWidth, int layoutHeight, List<T> positionedItems, LazyLayoutKeyIndexMap keyIndexMap, LazyLayoutMeasuredItemProvider<T> itemProvider, boolean isVertical, boolean isLookingAhead, int laneCount, boolean hasLookaheadOccurred, int layoutMinOffset, int layoutMaxOffset, CoroutineScope coroutineScope, GraphicsContext graphicsContext) {
        long jIntOffset;
        final LazyLayoutKeyIndexMap lazyLayoutKeyIndexMap;
        final LazyLayoutKeyIndexMap lazyLayoutKeyIndexMap2;
        int[] iArr;
        int[] iArr2;
        int layoutMaxOffset2;
        int layoutMinOffset2;
        long[] jArr;
        Object[] objArr;
        long[] jArr2;
        Object[] objArr2;
        int[] iArr3;
        LazyLayoutItemAnimation[] lazyLayoutItemAnimationArr;
        int i;
        LazyLayoutKeyIndexMap lazyLayoutKeyIndexMap3;
        LazyLayoutKeyIndexMap lazyLayoutKeyIndexMap4;
        long[] jArr3;
        Object[] objArr3;
        List<T> list = positionedItems;
        LazyLayoutKeyIndexMap lazyLayoutKeyIndexMap5 = this.keyIndexMap;
        this.keyIndexMap = keyIndexMap;
        int size = positionedItems.size();
        int i2 = 0;
        int i3 = 0;
        while (true) {
            if (i3 < size) {
                if (getHasAnimations(list.get(i3))) {
                    break;
                } else {
                    i3++;
                }
            } else {
                if (!this.keyToItemInfoMap.isEmpty()) {
                    break;
                }
                reset();
                return;
            }
        }
        int i4 = this.firstVisibleIndex;
        LazyLayoutMeasuredItem lazyLayoutMeasuredItem = (LazyLayoutMeasuredItem) CollectionsKt.firstOrNull(positionedItems);
        this.firstVisibleIndex = lazyLayoutMeasuredItem != null ? lazyLayoutMeasuredItem.getIndex() : 0;
        if (isVertical) {
            jIntOffset = IntOffsetKt.IntOffset(0, consumedScroll);
        } else {
            jIntOffset = IntOffsetKt.IntOffset(consumedScroll, 0);
        }
        boolean z = isLookingAhead || !hasLookaheadOccurred;
        MutableScatterMap<Object, LazyLayoutItemAnimator<T>.ItemInfo> mutableScatterMap = this.keyToItemInfoMap;
        Object[] objArr4 = mutableScatterMap.keys;
        long[] jArr4 = mutableScatterMap.metadata;
        int length = jArr4.length - 2;
        boolean z2 = z;
        if (length >= 0) {
            while (true) {
                long j = jArr4[i2];
                if ((((~j) << 7) & j & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i5 = 8 - ((~(i2 - length)) >>> 31);
                    int i6 = 0;
                    while (i6 < i5) {
                        if ((j & 255) < 128) {
                            this.movingAwayKeys.add(objArr4[(i2 << 3) + i6]);
                        }
                        j >>= 8;
                        i6++;
                        objArr4 = objArr4;
                        jArr4 = jArr4;
                    }
                    jArr3 = jArr4;
                    objArr3 = objArr4;
                    if (i5 != 8) {
                        break;
                    }
                } else {
                    jArr3 = jArr4;
                    objArr3 = objArr4;
                }
                if (i2 == length) {
                    break;
                }
                i2++;
                objArr4 = objArr3;
                jArr4 = jArr3;
            }
        }
        int size2 = positionedItems.size();
        int i7 = 0;
        while (i7 < size2) {
            T t = list.get(i7);
            this.movingAwayKeys.remove(t.getKey());
            if (getHasAnimations(t)) {
                LazyLayoutItemAnimator<T>.ItemInfo itemInfo = this.keyToItemInfoMap.get(t.getKey());
                int index = lazyLayoutKeyIndexMap5 != null ? lazyLayoutKeyIndexMap5.getIndex(t.getKey()) : -1;
                boolean z3 = index == -1 && lazyLayoutKeyIndexMap5 != null;
                if (itemInfo == null) {
                    LazyLayoutItemAnimator<T>.ItemInfo itemInfo2 = new ItemInfo();
                    ItemInfo.updateAnimation$default(itemInfo2, t, coroutineScope, graphicsContext, layoutMinOffset, layoutMaxOffset, 0, 32, null);
                    this.keyToItemInfoMap.set(t.getKey(), itemInfo2);
                    if (t.getIndex() == index || index == -1) {
                        long jMo1151getOffsetBjo55l4 = t.mo1151getOffsetBjo55l4(0);
                        initializeAnimation(t, t.getIsVertical() ? IntOffset.getY-impl(jMo1151getOffsetBjo55l4) : IntOffset.getX-impl(jMo1151getOffsetBjo55l4), itemInfo2);
                        if (z3) {
                            LazyLayoutItemAnimation[] animations = itemInfo2.getAnimations();
                            for (LazyLayoutItemAnimation lazyLayoutItemAnimation : animations) {
                                if (lazyLayoutItemAnimation != null) {
                                    lazyLayoutItemAnimation.animateAppearance();
                                    Unit unit = Unit.INSTANCE;
                                }
                            }
                        }
                    } else if (index < i4) {
                        this.movingInFromStartBound.add(t);
                    } else {
                        this.movingInFromEndBound.add(t);
                    }
                } else if (z2) {
                    ItemInfo.updateAnimation$default(itemInfo, t, coroutineScope, graphicsContext, layoutMinOffset, layoutMaxOffset, 0, 32, null);
                    LazyLayoutItemAnimation[] animations2 = itemInfo.getAnimations();
                    int length2 = animations2.length;
                    int i8 = 0;
                    while (i8 < length2) {
                        int i9 = size2;
                        LazyLayoutItemAnimation lazyLayoutItemAnimation2 = animations2[i8];
                        if (lazyLayoutItemAnimation2 != null) {
                            lazyLayoutKeyIndexMap4 = lazyLayoutKeyIndexMap5;
                            if (!IntOffset.equals-impl0(lazyLayoutItemAnimation2.getRawOffset(), LazyLayoutItemAnimation.INSTANCE.m1212getNotInitializednOccac())) {
                                lazyLayoutItemAnimation2.m1210setRawOffsetgyyYBs(IntOffset.plus-qkQi6aY(lazyLayoutItemAnimation2.getRawOffset(), jIntOffset));
                            }
                        } else {
                            lazyLayoutKeyIndexMap4 = lazyLayoutKeyIndexMap5;
                        }
                        i8++;
                        size2 = i9;
                        lazyLayoutKeyIndexMap5 = lazyLayoutKeyIndexMap4;
                    }
                    i = size2;
                    lazyLayoutKeyIndexMap3 = lazyLayoutKeyIndexMap5;
                    if (z3) {
                        for (LazyLayoutItemAnimation lazyLayoutItemAnimation3 : itemInfo.getAnimations()) {
                            if (lazyLayoutItemAnimation3 != null) {
                                if (lazyLayoutItemAnimation3.isDisappearanceAnimationInProgress()) {
                                    this.disappearingItems.remove(lazyLayoutItemAnimation3);
                                    DrawModifierNode drawModifierNode = this.displayingNode;
                                    if (drawModifierNode != null) {
                                        DrawModifierNodeKt.invalidateDraw(drawModifierNode);
                                        Unit unit2 = Unit.INSTANCE;
                                    }
                                }
                                lazyLayoutItemAnimation3.animateAppearance();
                            }
                        }
                    }
                    startPlacementAnimationsIfNeeded$default(this, t, false, 2, null);
                }
                i = size2;
                lazyLayoutKeyIndexMap3 = lazyLayoutKeyIndexMap5;
            } else {
                i = size2;
                lazyLayoutKeyIndexMap3 = lazyLayoutKeyIndexMap5;
                removeInfoForKey(t.getKey());
            }
            i7++;
            list = positionedItems;
            size2 = i;
            lazyLayoutKeyIndexMap5 = lazyLayoutKeyIndexMap3;
        }
        int i10 = laneCount;
        LazyLayoutKeyIndexMap lazyLayoutKeyIndexMap6 = lazyLayoutKeyIndexMap5;
        int[] iArr4 = new int[i10];
        for (int i11 = 0; i11 < i10; i11++) {
            iArr4[i11] = 0;
        }
        if (!z2 || lazyLayoutKeyIndexMap6 == null) {
            lazyLayoutKeyIndexMap = lazyLayoutKeyIndexMap6;
        } else {
            if (this.movingInFromStartBound.isEmpty()) {
                lazyLayoutKeyIndexMap = lazyLayoutKeyIndexMap6;
            } else {
                List<T> list2 = this.movingInFromStartBound;
                if (list2.size() > 1) {
                    lazyLayoutKeyIndexMap = lazyLayoutKeyIndexMap6;
                    CollectionsKt.sortWith(list2, new Comparator() {
                        @Override
                        public final int compare(T t2, T t3) {
                            return ComparisonsKt.compareValues(Integer.valueOf(lazyLayoutKeyIndexMap.getIndex(((LazyLayoutMeasuredItem) t3).getKey())), Integer.valueOf(lazyLayoutKeyIndexMap.getIndex(((LazyLayoutMeasuredItem) t2).getKey())));
                        }
                    });
                } else {
                    lazyLayoutKeyIndexMap = lazyLayoutKeyIndexMap6;
                }
                List<T> list3 = this.movingInFromStartBound;
                int size3 = list3.size();
                for (int i12 = 0; i12 < size3; i12++) {
                    T t2 = list3.get(i12);
                    initializeAnimation$default(this, t2, layoutMinOffset - updateAndReturnOffsetFor(iArr4, t2), null, 4, null);
                    startPlacementAnimationsIfNeeded$default(this, t2, false, 2, null);
                }
                ArraysKt.fill$default(iArr4, 0, 0, 0, 6, (Object) null);
            }
            if (!this.movingInFromEndBound.isEmpty()) {
                List<T> list4 = this.movingInFromEndBound;
                if (list4.size() > 1) {
                    CollectionsKt.sortWith(list4, new Comparator() {
                        @Override
                        public final int compare(T t3, T t4) {
                            return ComparisonsKt.compareValues(Integer.valueOf(lazyLayoutKeyIndexMap.getIndex(((LazyLayoutMeasuredItem) t3).getKey())), Integer.valueOf(lazyLayoutKeyIndexMap.getIndex(((LazyLayoutMeasuredItem) t4).getKey())));
                        }
                    });
                }
                List<T> list5 = this.movingInFromEndBound;
                int size4 = list5.size();
                for (int i13 = 0; i13 < size4; i13++) {
                    T t3 = list5.get(i13);
                    initializeAnimation$default(this, t3, (layoutMaxOffset + updateAndReturnOffsetFor(iArr4, t3)) - t3.getMainAxisSizeWithSpacings(), null, 4, null);
                    startPlacementAnimationsIfNeeded$default(this, t3, false, 2, null);
                }
                ArraysKt.fill$default(iArr4, 0, 0, 0, 6, (Object) null);
            }
        }
        MutableScatterSet<Object> mutableScatterSet = this.movingAwayKeys;
        Object[] objArr5 = mutableScatterSet.elements;
        long[] jArr5 = mutableScatterSet.metadata;
        int length3 = jArr5.length - 2;
        if (length3 >= 0) {
            int i14 = 0;
            while (true) {
                long j2 = jArr5[i14];
                if ((((~j2) << 7) & j2 & (-9187201950435737472L)) != -9187201950435737472L) {
                    int i15 = 8 - ((~(i14 - length3)) >>> 31);
                    int i16 = 0;
                    while (i16 < i15) {
                        if ((j2 & 255) < 128) {
                            Object obj = objArr5[(i14 << 3) + i16];
                            LazyLayoutItemAnimator<T>.ItemInfo itemInfo3 = this.keyToItemInfoMap.get(obj);
                            Intrinsics.checkNotNull(itemInfo3);
                            LazyLayoutItemAnimator<T>.ItemInfo itemInfo4 = itemInfo3;
                            int index2 = keyIndexMap.getIndex(obj);
                            jArr2 = jArr5;
                            itemInfo4.setSpan(Math.min(i10, itemInfo4.getSpan()));
                            objArr2 = objArr5;
                            itemInfo4.setLane(Math.min(i10 - itemInfo4.getSpan(), itemInfo4.getLane()));
                            if (index2 == -1) {
                                LazyLayoutItemAnimation[] animations3 = itemInfo4.getAnimations();
                                int length4 = animations3.length;
                                int i17 = 0;
                                boolean z4 = false;
                                int i18 = 0;
                                while (i17 < length4) {
                                    LazyLayoutItemAnimation lazyLayoutItemAnimation4 = animations3[i17];
                                    int i19 = i18 + 1;
                                    if (lazyLayoutItemAnimation4 != null) {
                                        if (lazyLayoutItemAnimation4.isDisappearanceAnimationInProgress()) {
                                            lazyLayoutItemAnimationArr = animations3;
                                        } else {
                                            if (lazyLayoutItemAnimation4.isDisappearanceAnimationFinished()) {
                                                lazyLayoutItemAnimation4.release();
                                                itemInfo4.getAnimations()[i18] = null;
                                                lazyLayoutItemAnimationArr = animations3;
                                                this.disappearingItems.remove(lazyLayoutItemAnimation4);
                                                DrawModifierNode drawModifierNode2 = this.displayingNode;
                                                if (drawModifierNode2 != null) {
                                                    DrawModifierNodeKt.invalidateDraw(drawModifierNode2);
                                                    Unit unit3 = Unit.INSTANCE;
                                                }
                                            } else {
                                                lazyLayoutItemAnimationArr = animations3;
                                                if (lazyLayoutItemAnimation4.getLayer() != null) {
                                                    lazyLayoutItemAnimation4.animateDisappearance();
                                                }
                                                if (lazyLayoutItemAnimation4.isDisappearanceAnimationInProgress()) {
                                                    this.disappearingItems.add(lazyLayoutItemAnimation4);
                                                    DrawModifierNode drawModifierNode3 = this.displayingNode;
                                                    if (drawModifierNode3 != null) {
                                                        DrawModifierNodeKt.invalidateDraw(drawModifierNode3);
                                                        Unit unit4 = Unit.INSTANCE;
                                                    }
                                                } else {
                                                    lazyLayoutItemAnimation4.release();
                                                    itemInfo4.getAnimations()[i18] = null;
                                                }
                                            }
                                            i17++;
                                            i18 = i19;
                                            animations3 = lazyLayoutItemAnimationArr;
                                        }
                                        z4 = true;
                                        i17++;
                                        i18 = i19;
                                        animations3 = lazyLayoutItemAnimationArr;
                                    } else {
                                        lazyLayoutItemAnimationArr = animations3;
                                    }
                                    i17++;
                                    i18 = i19;
                                    animations3 = lazyLayoutItemAnimationArr;
                                }
                                if (!z4) {
                                    removeInfoForKey(obj);
                                }
                            } else {
                                Constraints constraints = itemInfo4.getConstraints();
                                Intrinsics.checkNotNull(constraints);
                                LazyLayoutMeasuredItem lazyLayoutMeasuredItemMo1153getAndMeasurehBUhpc = itemProvider.mo1153getAndMeasurehBUhpc(index2, itemInfo4.getLane(), itemInfo4.getSpan(), constraints.unbox-impl());
                                lazyLayoutMeasuredItemMo1153getAndMeasurehBUhpc.setNonScrollableItem(true);
                                LazyLayoutItemAnimation[] animations4 = itemInfo4.getAnimations();
                                int length5 = animations4.length;
                                iArr3 = iArr4;
                                int i20 = 0;
                                while (true) {
                                    if (i20 < length5) {
                                        LazyLayoutItemAnimation lazyLayoutItemAnimation5 = animations4[i20];
                                        int i21 = length5;
                                        if (lazyLayoutItemAnimation5 != null && lazyLayoutItemAnimation5.isPlacementAnimationInProgress()) {
                                        }
                                        i20++;
                                        animations4 = animations4;
                                        length5 = i21;
                                    } else if (lazyLayoutKeyIndexMap != null && index2 == lazyLayoutKeyIndexMap.getIndex(obj)) {
                                        removeInfoForKey(obj);
                                    }
                                    itemInfo4.updateAnimation(lazyLayoutMeasuredItemMo1153getAndMeasurehBUhpc, coroutineScope, graphicsContext, layoutMinOffset, layoutMaxOffset, itemInfo4.getCrossAxisOffset());
                                    if (index2 < this.firstVisibleIndex) {
                                        this.movingAwayToStartBound.add((T) lazyLayoutMeasuredItemMo1153getAndMeasurehBUhpc);
                                    } else {
                                        this.movingAwayToEndBound.add((T) lazyLayoutMeasuredItemMo1153getAndMeasurehBUhpc);
                                    }
                                }
                            }
                            j2 >>= 8;
                            i16++;
                            jArr5 = jArr2;
                            i10 = laneCount;
                            iArr4 = iArr3;
                            objArr5 = objArr2;
                        } else {
                            jArr2 = jArr5;
                            objArr2 = objArr5;
                        }
                        iArr3 = iArr4;
                        j2 >>= 8;
                        i16++;
                        jArr5 = jArr2;
                        i10 = laneCount;
                        iArr4 = iArr3;
                        objArr5 = objArr2;
                    }
                    lazyLayoutKeyIndexMap2 = keyIndexMap;
                    jArr = jArr5;
                    objArr = objArr5;
                    iArr = iArr4;
                    if (i15 != 8) {
                        break;
                    }
                } else {
                    lazyLayoutKeyIndexMap2 = keyIndexMap;
                    jArr = jArr5;
                    objArr = objArr5;
                    iArr = iArr4;
                }
                if (i14 == length3) {
                    break;
                }
                i14++;
                jArr5 = jArr;
                i10 = laneCount;
                iArr4 = iArr;
                objArr5 = objArr;
            }
        } else {
            lazyLayoutKeyIndexMap2 = keyIndexMap;
            iArr = iArr4;
        }
        if (this.movingAwayToStartBound.isEmpty()) {
            iArr2 = iArr;
        } else {
            List<T> list6 = this.movingAwayToStartBound;
            if (list6.size() > 1) {
                CollectionsKt.sortWith(list6, new Comparator() {
                    @Override
                    public final int compare(T t4, T t5) {
                        return ComparisonsKt.compareValues(Integer.valueOf(lazyLayoutKeyIndexMap2.getIndex(((LazyLayoutMeasuredItem) t5).getKey())), Integer.valueOf(lazyLayoutKeyIndexMap2.getIndex(((LazyLayoutMeasuredItem) t4).getKey())));
                    }
                });
            }
            List<T> list7 = this.movingAwayToStartBound;
            int size5 = list7.size();
            int i22 = 0;
            while (i22 < size5) {
                T t4 = list7.get(i22);
                LazyLayoutItemAnimator<T>.ItemInfo itemInfo5 = this.keyToItemInfoMap.get(t4.getKey());
                Intrinsics.checkNotNull(itemInfo5);
                LazyLayoutItemAnimator<T>.ItemInfo itemInfo6 = itemInfo5;
                int[] iArr5 = iArr;
                int iUpdateAndReturnOffsetFor = updateAndReturnOffsetFor(iArr5, t4);
                if (isLookingAhead) {
                    layoutMinOffset2 = getMainAxisOffset((LazyLayoutMeasuredItem) CollectionsKt.first(positionedItems));
                } else {
                    layoutMinOffset2 = itemInfo6.getLayoutMinOffset();
                }
                t4.position(layoutMinOffset2 - iUpdateAndReturnOffsetFor, itemInfo6.getCrossAxisOffset(), layoutWidth, layoutHeight);
                if (z2) {
                    startPlacementAnimationsIfNeeded(t4, true);
                }
                i22++;
                iArr = iArr5;
            }
            iArr2 = iArr;
            ArraysKt.fill$default(iArr2, 0, 0, 0, 6, (Object) null);
        }
        if (!this.movingAwayToEndBound.isEmpty()) {
            List<T> list8 = this.movingAwayToEndBound;
            if (list8.size() > 1) {
                CollectionsKt.sortWith(list8, new Comparator() {
                    @Override
                    public final int compare(T t5, T t6) {
                        return ComparisonsKt.compareValues(Integer.valueOf(lazyLayoutKeyIndexMap2.getIndex(((LazyLayoutMeasuredItem) t5).getKey())), Integer.valueOf(lazyLayoutKeyIndexMap2.getIndex(((LazyLayoutMeasuredItem) t6).getKey())));
                    }
                });
            }
            List<T> list9 = this.movingAwayToEndBound;
            int size6 = list9.size();
            for (int i23 = 0; i23 < size6; i23++) {
                T t5 = list9.get(i23);
                LazyLayoutItemAnimator<T>.ItemInfo itemInfo7 = this.keyToItemInfoMap.get(t5.getKey());
                Intrinsics.checkNotNull(itemInfo7);
                LazyLayoutItemAnimator<T>.ItemInfo itemInfo8 = itemInfo7;
                int iUpdateAndReturnOffsetFor2 = updateAndReturnOffsetFor(iArr2, t5);
                if (isLookingAhead) {
                    layoutMaxOffset2 = getMainAxisOffset((LazyLayoutMeasuredItem) CollectionsKt.last(positionedItems));
                } else {
                    layoutMaxOffset2 = itemInfo8.getLayoutMaxOffset() - t5.getMainAxisSizeWithSpacings();
                }
                t5.position(layoutMaxOffset2 + iUpdateAndReturnOffsetFor2, itemInfo8.getCrossAxisOffset(), layoutWidth, layoutHeight);
                if (z2) {
                    startPlacementAnimationsIfNeeded(t5, true);
                }
            }
        }
        List<T> list10 = this.movingAwayToStartBound;
        CollectionsKt.reverse(list10);
        Unit unit5 = Unit.INSTANCE;
        positionedItems.addAll(0, list10);
        positionedItems.addAll(this.movingAwayToEndBound);
        this.movingInFromStartBound.clear();
        this.movingInFromEndBound.clear();
        this.movingAwayToStartBound.clear();
        this.movingAwayToEndBound.clear();
        this.movingAwayKeys.clear();
    }

    private final void removeInfoForKey(Object key) {
        LazyLayoutItemAnimation[] animations;
        LazyLayoutItemAnimator<T>.ItemInfo itemInfoRemove = this.keyToItemInfoMap.remove(key);
        if (itemInfoRemove == null || (animations = itemInfoRemove.getAnimations()) == null) {
            return;
        }
        for (LazyLayoutItemAnimation lazyLayoutItemAnimation : animations) {
            if (lazyLayoutItemAnimation != null) {
                lazyLayoutItemAnimation.release();
            }
        }
    }

    public final void reset() {
        if (this.keyToItemInfoMap.isNotEmpty()) {
            MutableScatterMap<Object, LazyLayoutItemAnimator<T>.ItemInfo> mutableScatterMap = this.keyToItemInfoMap;
            Object[] objArr = mutableScatterMap.values;
            long[] jArr = mutableScatterMap.metadata;
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
                                for (LazyLayoutItemAnimation lazyLayoutItemAnimation : ((ItemInfo) objArr[(i << 3) + i3]).getAnimations()) {
                                    if (lazyLayoutItemAnimation != null) {
                                        lazyLayoutItemAnimation.release();
                                    }
                                }
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
            this.keyToItemInfoMap.clear();
        }
        this.keyIndexMap = LazyLayoutKeyIndexMap.INSTANCE;
        this.firstVisibleIndex = -1;
    }

    static void initializeAnimation$default(LazyLayoutItemAnimator lazyLayoutItemAnimator, LazyLayoutMeasuredItem lazyLayoutMeasuredItem, int i, ItemInfo itemInfo, int i2, Object obj) {
        if ((i2 & 4) != 0) {
            LazyLayoutItemAnimator<T>.ItemInfo itemInfo2 = lazyLayoutItemAnimator.keyToItemInfoMap.get(lazyLayoutMeasuredItem.getKey());
            Intrinsics.checkNotNull(itemInfo2);
            itemInfo = itemInfo2;
        }
        lazyLayoutItemAnimator.initializeAnimation(lazyLayoutMeasuredItem, i, itemInfo);
    }

    private final void initializeAnimation(T item, int mainAxisOffset, LazyLayoutItemAnimator<T>.ItemInfo itemInfo) {
        long j;
        int i = 0;
        long jMo1151getOffsetBjo55l4 = item.mo1151getOffsetBjo55l4(0);
        if (item.getIsVertical()) {
            j = IntOffset.copy-iSbpLlY$default(jMo1151getOffsetBjo55l4, 0, mainAxisOffset, 1, (Object) null);
        } else {
            j = IntOffset.copy-iSbpLlY$default(jMo1151getOffsetBjo55l4, mainAxisOffset, 0, 2, (Object) null);
        }
        LazyLayoutItemAnimation[] animations = itemInfo.getAnimations();
        int length = animations.length;
        int i2 = 0;
        while (i < length) {
            LazyLayoutItemAnimation lazyLayoutItemAnimation = animations[i];
            int i3 = i2 + 1;
            if (lazyLayoutItemAnimation != null) {
                lazyLayoutItemAnimation.m1210setRawOffsetgyyYBs(IntOffset.plus-qkQi6aY(j, IntOffset.minus-qkQi6aY(item.mo1151getOffsetBjo55l4(i2), jMo1151getOffsetBjo55l4)));
            }
            i++;
            i2 = i3;
        }
    }

    static void startPlacementAnimationsIfNeeded$default(LazyLayoutItemAnimator lazyLayoutItemAnimator, LazyLayoutMeasuredItem lazyLayoutMeasuredItem, boolean z, int i, Object obj) {
        if ((i & 2) != 0) {
            z = false;
        }
        lazyLayoutItemAnimator.startPlacementAnimationsIfNeeded(lazyLayoutMeasuredItem, z);
    }

    private final void startPlacementAnimationsIfNeeded(T item, boolean isMovingAway) {
        LazyLayoutItemAnimator<T>.ItemInfo itemInfo = this.keyToItemInfoMap.get(item.getKey());
        Intrinsics.checkNotNull(itemInfo);
        LazyLayoutItemAnimation[] animations = itemInfo.getAnimations();
        int length = animations.length;
        int i = 0;
        int i2 = 0;
        while (i < length) {
            LazyLayoutItemAnimation lazyLayoutItemAnimation = animations[i];
            int i3 = i2 + 1;
            if (lazyLayoutItemAnimation != null) {
                long jMo1151getOffsetBjo55l4 = item.mo1151getOffsetBjo55l4(i2);
                long rawOffset = lazyLayoutItemAnimation.getRawOffset();
                if (!IntOffset.equals-impl0(rawOffset, LazyLayoutItemAnimation.INSTANCE.m1212getNotInitializednOccac()) && !IntOffset.equals-impl0(rawOffset, jMo1151getOffsetBjo55l4)) {
                    lazyLayoutItemAnimation.m1203animatePlacementDeltaar5cAso(IntOffset.minus-qkQi6aY(jMo1151getOffsetBjo55l4, rawOffset), isMovingAway);
                }
                lazyLayoutItemAnimation.m1210setRawOffsetgyyYBs(jMo1151getOffsetBjo55l4);
            }
            i++;
            i2 = i3;
        }
    }

    public final LazyLayoutItemAnimation getAnimation(Object key, int placeableIndex) {
        LazyLayoutItemAnimation[] animations;
        LazyLayoutItemAnimator<T>.ItemInfo itemInfo = this.keyToItemInfoMap.get(key);
        if (itemInfo == null || (animations = itemInfo.getAnimations()) == null) {
            return null;
        }
        return animations[placeableIndex];
    }

    private final int updateAndReturnOffsetFor(int[] iArr, T t) {
        int lane = t.getLane();
        int span = t.getSpan() + lane;
        int iMax = 0;
        while (lane < span) {
            int mainAxisSizeWithSpacings = iArr[lane] + t.getMainAxisSizeWithSpacings();
            iArr[lane] = mainAxisSizeWithSpacings;
            iMax = Math.max(iMax, mainAxisSizeWithSpacings);
            lane++;
        }
        return iMax;
    }

    public final long m1213getMinSizeToFitDisappearingItemsYbymL2g() {
        long jIntSize = IntSize.Companion.getZero-YbymL2g();
        List<LazyLayoutItemAnimation> list = this.disappearingItems;
        int size = list.size();
        for (int i = 0; i < size; i++) {
            LazyLayoutItemAnimation lazyLayoutItemAnimation = list.get(i);
            GraphicsLayer layer = lazyLayoutItemAnimation.getLayer();
            if (layer != null) {
                jIntSize = IntSizeKt.IntSize(Math.max(IntSize.getWidth-impl(jIntSize), IntOffset.getX-impl(lazyLayoutItemAnimation.getRawOffset()) + IntSize.getWidth-impl(layer.getSize())), Math.max(IntSize.getHeight-impl(jIntSize), IntOffset.getY-impl(lazyLayoutItemAnimation.getRawOffset()) + IntSize.getHeight-impl(layer.getSize())));
            }
        }
        return jIntSize;
    }

    public final Modifier getModifier() {
        return this.modifier;
    }

    private final boolean getHasAnimations(T t) {
        int placeablesCount = t.getPlaceablesCount();
        for (int i = 0; i < placeablesCount; i++) {
            if (LazyLayoutItemAnimatorKt.getSpecs(t.getParentData(i)) != null) {
                return true;
            }
        }
        return false;
    }

    private final int getMainAxisOffset(LazyLayoutMeasuredItem lazyLayoutMeasuredItem) {
        long jMo1151getOffsetBjo55l4 = lazyLayoutMeasuredItem.mo1151getOffsetBjo55l4(0);
        return lazyLayoutMeasuredItem.getIsVertical() ? IntOffset.getY-impl(jMo1151getOffsetBjo55l4) : IntOffset.getX-impl(jMo1151getOffsetBjo55l4);
    }

    public final int getCrossAxisOffset(LazyLayoutMeasuredItem lazyLayoutMeasuredItem) {
        long jMo1151getOffsetBjo55l4 = lazyLayoutMeasuredItem.mo1151getOffsetBjo55l4(0);
        return !lazyLayoutMeasuredItem.getIsVertical() ? IntOffset.getY-impl(jMo1151getOffsetBjo55l4) : IntOffset.getX-impl(jMo1151getOffsetBjo55l4);
    }

    @Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\f\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0082\u0004\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J=\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00028\u00002\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020)2\u0006\u0010\u001e\u001a\u00020\u00112\u0006\u0010\u001c\u001a\u00020\u00112\b\b\u0002\u0010\u0010\u001a\u00020\u0011¢\u0006\u0002\u0010*R0\u0010\u0006\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u00042\u000e\u0010\u0003\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0004@BX\u0086\u000e¢\u0006\n\n\u0002\u0010\t\u001a\u0004\b\u0007\u0010\bR\"\u0010\n\u001a\u0004\u0018\u00010\u000bX\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR\u001a\u0010\u0010\u001a\u00020\u0011X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R\u0014\u0010\u0016\u001a\u00020\u00178BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u0018R\u001a\u0010\u0019\u001a\u00020\u0011X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u0013\"\u0004\b\u001b\u0010\u0015R\u001e\u0010\u001c\u001a\u00020\u00112\u0006\u0010\u0003\u001a\u00020\u0011@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0013R\u001e\u0010\u001e\u001a\u00020\u00112\u0006\u0010\u0003\u001a\u00020\u0011@BX\u0086\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0013R\u001a\u0010 \u001a\u00020\u0011X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\u0013\"\u0004\b\"\u0010\u0015\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006+"}, d2 = {"Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator$ItemInfo;", "", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;)V", "<set-?>", "", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimation;", "animations", "getAnimations", "()[Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimation;", "[Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimation;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "getConstraints-DWUhwKw", "()Landroidx/compose/ui/unit/Constraints;", "setConstraints-_Sx5XlM", "(Landroidx/compose/ui/unit/Constraints;)V", "crossAxisOffset", "", "getCrossAxisOffset", "()I", "setCrossAxisOffset", "(I)V", "isRunningPlacement", "", "()Z", "lane", "getLane", "setLane", "layoutMaxOffset", "getLayoutMaxOffset", "layoutMinOffset", "getLayoutMinOffset", "span", "getSpan", "setSpan", "updateAnimation", "", "positionedItem", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "graphicsContext", "Landroidx/compose/ui/graphics/GraphicsContext;", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasuredItem;Lkotlinx/coroutines/CoroutineScope;Landroidx/compose/ui/graphics/GraphicsContext;III)V", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private final class ItemInfo {
        private Constraints constraints;
        private int crossAxisOffset;
        private int lane;
        private int layoutMaxOffset;
        private int layoutMinOffset;
        private LazyLayoutItemAnimation[] animations = LazyLayoutItemAnimatorKt.EmptyArray;
        private int span = 1;

        public ItemInfo() {
        }

        public final LazyLayoutItemAnimation[] getAnimations() {
            return this.animations;
        }

        public final Constraints getConstraints() {
            return this.constraints;
        }

        public final void m1215setConstraints_Sx5XlM(Constraints constraints) {
            this.constraints = constraints;
        }

        public final int getCrossAxisOffset() {
            return this.crossAxisOffset;
        }

        public final void setCrossAxisOffset(int i) {
            this.crossAxisOffset = i;
        }

        public final int getLane() {
            return this.lane;
        }

        public final void setLane(int i) {
            this.lane = i;
        }

        public final int getSpan() {
            return this.span;
        }

        public final void setSpan(int i) {
            this.span = i;
        }

        private final boolean isRunningPlacement() {
            for (LazyLayoutItemAnimation lazyLayoutItemAnimation : this.animations) {
                if (lazyLayoutItemAnimation != null && lazyLayoutItemAnimation.getIsRunningMovingAwayAnimation()) {
                    return true;
                }
            }
            return false;
        }

        public final int getLayoutMinOffset() {
            return this.layoutMinOffset;
        }

        public final int getLayoutMaxOffset() {
            return this.layoutMaxOffset;
        }

        public static void updateAnimation$default(ItemInfo itemInfo, LazyLayoutMeasuredItem lazyLayoutMeasuredItem, CoroutineScope coroutineScope, GraphicsContext graphicsContext, int i, int i2, int i3, int i4, Object obj) {
            if ((i4 & 32) != 0) {
                i3 = LazyLayoutItemAnimator.this.getCrossAxisOffset(lazyLayoutMeasuredItem);
            }
            itemInfo.updateAnimation(lazyLayoutMeasuredItem, coroutineScope, graphicsContext, i, i2, i3);
        }

        public final void updateAnimation(T positionedItem, CoroutineScope coroutineScope, GraphicsContext graphicsContext, int layoutMinOffset, int layoutMaxOffset, int crossAxisOffset) {
            if (!isRunningPlacement()) {
                this.layoutMinOffset = layoutMinOffset;
                this.layoutMaxOffset = layoutMaxOffset;
            }
            int length = this.animations.length;
            for (int placeablesCount = positionedItem.getPlaceablesCount(); placeablesCount < length; placeablesCount++) {
                LazyLayoutItemAnimation lazyLayoutItemAnimation = this.animations[placeablesCount];
                if (lazyLayoutItemAnimation != null) {
                    lazyLayoutItemAnimation.release();
                }
            }
            if (this.animations.length != positionedItem.getPlaceablesCount()) {
                Object[] objArrCopyOf = Arrays.copyOf(this.animations, positionedItem.getPlaceablesCount());
                Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
                this.animations = (LazyLayoutItemAnimation[]) objArrCopyOf;
            }
            this.constraints = Constraints.box-impl(positionedItem.getConstraints());
            this.crossAxisOffset = crossAxisOffset;
            this.lane = positionedItem.getLane();
            this.span = positionedItem.getSpan();
            int placeablesCount2 = positionedItem.getPlaceablesCount();
            final LazyLayoutItemAnimator<T> lazyLayoutItemAnimator = LazyLayoutItemAnimator.this;
            for (int i = 0; i < placeablesCount2; i++) {
                LazyLayoutAnimationSpecsNode specs = LazyLayoutItemAnimatorKt.getSpecs(positionedItem.getParentData(i));
                if (specs == null) {
                    LazyLayoutItemAnimation lazyLayoutItemAnimation2 = this.animations[i];
                    if (lazyLayoutItemAnimation2 != null) {
                        lazyLayoutItemAnimation2.release();
                    }
                    this.animations[i] = null;
                } else {
                    LazyLayoutItemAnimation lazyLayoutItemAnimation3 = this.animations[i];
                    if (lazyLayoutItemAnimation3 == null) {
                        lazyLayoutItemAnimation3 = new LazyLayoutItemAnimation(coroutineScope, graphicsContext, new Function0<Unit>() {
                            {
                                super(0);
                            }

                            public final void m1216invoke() {
                                DrawModifierNode drawModifierNode = ((LazyLayoutItemAnimator) lazyLayoutItemAnimator).displayingNode;
                                if (drawModifierNode != null) {
                                    DrawModifierNodeKt.invalidateDraw(drawModifierNode);
                                }
                            }

                            public Object invoke() {
                                m1216invoke();
                                return Unit.INSTANCE;
                            }
                        });
                        this.animations[i] = lazyLayoutItemAnimation3;
                    }
                    lazyLayoutItemAnimation3.setFadeInSpec(specs.getFadeInSpec());
                    lazyLayoutItemAnimation3.setPlacementSpec(specs.getPlacementSpec());
                    lazyLayoutItemAnimation3.setFadeOutSpec(specs.getFadeOutSpec());
                }
            }
        }
    }

    @Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0082\b\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0011\u0012\n\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004¢\u0006\u0002\u0010\u0005J\r\u0010\u0006\u001a\u0006\u0012\u0002\b\u00030\u0004HÂ\u0003J\u0017\u0010\u0007\u001a\u00020\u00002\f\b\u0002\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004HÆ\u0001J\b\u0010\b\u001a\u00020\u0002H\u0016J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001J\u0010\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002H\u0016J\f\u0010\u0014\u001a\u00020\u0012*\u00020\u0015H\u0016R\u0012\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator$DisplayingDisappearingItemsElement;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator$DisplayingDisappearingItemsNode;", "animator", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;)V", "component1", "copy", "create", "equals", "", "other", "", "hashCode", "", "toString", "", "update", "", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class DisplayingDisappearingItemsElement extends ModifierNodeElement<DisplayingDisappearingItemsNode> {
        private final LazyLayoutItemAnimator<?> animator;

        private final LazyLayoutItemAnimator<?> component1() {
            return this.animator;
        }

        public static DisplayingDisappearingItemsElement copy$default(DisplayingDisappearingItemsElement displayingDisappearingItemsElement, LazyLayoutItemAnimator lazyLayoutItemAnimator, int i, Object obj) {
            if ((i & 1) != 0) {
                lazyLayoutItemAnimator = displayingDisappearingItemsElement.animator;
            }
            return displayingDisappearingItemsElement.copy(lazyLayoutItemAnimator);
        }

        public final DisplayingDisappearingItemsElement copy(LazyLayoutItemAnimator<?> animator) {
            return new DisplayingDisappearingItemsElement(animator);
        }

        @Override
        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof DisplayingDisappearingItemsElement) && Intrinsics.areEqual(this.animator, ((DisplayingDisappearingItemsElement) other).animator);
        }

        @Override
        public int hashCode() {
            return this.animator.hashCode();
        }

        public String toString() {
            return "DisplayingDisappearingItemsElement(animator=" + this.animator + ')';
        }

        public DisplayingDisappearingItemsElement(LazyLayoutItemAnimator<?> lazyLayoutItemAnimator) {
            this.animator = lazyLayoutItemAnimator;
        }

        @Override
        public DisplayingDisappearingItemsNode getNode() {
            return new DisplayingDisappearingItemsNode(this.animator);
        }

        @Override
        public void update(DisplayingDisappearingItemsNode node) {
            node.setAnimator(this.animator);
        }

        @Override
        public void inspectableProperties(InspectorInfo inspectorInfo) {
            inspectorInfo.setName("DisplayingDisappearingItemsElement");
        }
    }

    @Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0082\b\u0018\u00002\u00020\u00012\u00020\u0002B\u0011\u0012\n\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004¢\u0006\u0002\u0010\u0005J\r\u0010\u0006\u001a\u0006\u0012\u0002\b\u00030\u0004HÂ\u0003J\u0017\u0010\u0007\u001a\u00020\u00002\f\b\u0002\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004HÆ\u0001J\u0013\u0010\b\u001a\u00020\t2\b\u0010\n\u001a\u0004\u0018\u00010\u000bHÖ\u0003J\t\u0010\f\u001a\u00020\rHÖ\u0001J\b\u0010\u000e\u001a\u00020\u000fH\u0016J\b\u0010\u0010\u001a\u00020\u000fH\u0016J\u0012\u0010\u0011\u001a\u00020\u000f2\n\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\f\u0010\u0014\u001a\u00020\u000f*\u00020\u0015H\u0016R\u0012\u0010\u0003\u001a\u0006\u0012\u0002\b\u00030\u0004X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0016"}, d2 = {"Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator$DisplayingDisappearingItemsNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/DrawModifierNode;", "animator", "Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;", "(Landroidx/compose/foundation/lazy/layout/LazyLayoutItemAnimator;)V", "component1", "copy", "equals", "", "other", "", "hashCode", "", "onAttach", "", "onDetach", "setAnimator", "toString", "", "draw", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    private static final class DisplayingDisappearingItemsNode extends Modifier.Node implements DrawModifierNode {
        private LazyLayoutItemAnimator<?> animator;

        private final LazyLayoutItemAnimator<?> component1() {
            return this.animator;
        }

        public static DisplayingDisappearingItemsNode copy$default(DisplayingDisappearingItemsNode displayingDisappearingItemsNode, LazyLayoutItemAnimator lazyLayoutItemAnimator, int i, Object obj) {
            if ((i & 1) != 0) {
                lazyLayoutItemAnimator = displayingDisappearingItemsNode.animator;
            }
            return displayingDisappearingItemsNode.copy(lazyLayoutItemAnimator);
        }

        public final DisplayingDisappearingItemsNode copy(LazyLayoutItemAnimator<?> animator) {
            return new DisplayingDisappearingItemsNode(animator);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof DisplayingDisappearingItemsNode) && Intrinsics.areEqual(this.animator, ((DisplayingDisappearingItemsNode) other).animator);
        }

        public int hashCode() {
            return this.animator.hashCode();
        }

        @Override
        public void onMeasureResultChanged() {
            DrawModifierNode.CC.$default$onMeasureResultChanged(this);
        }

        public String toString() {
            return "DisplayingDisappearingItemsNode(animator=" + this.animator + ')';
        }

        public DisplayingDisappearingItemsNode(LazyLayoutItemAnimator<?> lazyLayoutItemAnimator) {
            this.animator = lazyLayoutItemAnimator;
        }

        @Override
        public void draw(ContentDrawScope contentDrawScope) {
            List list = ((LazyLayoutItemAnimator) this.animator).disappearingItems;
            int size = list.size();
            for (int i = 0; i < size; i++) {
                LazyLayoutItemAnimation lazyLayoutItemAnimation = (LazyLayoutItemAnimation) list.get(i);
                GraphicsLayer layer = lazyLayoutItemAnimation.getLayer();
                if (layer != null) {
                    float f = IntOffset.getX-impl(lazyLayoutItemAnimation.getFinalOffset());
                    float f2 = IntOffset.getY-impl(lazyLayoutItemAnimation.getFinalOffset());
                    ContentDrawScope contentDrawScope2 = contentDrawScope;
                    float f3 = f - IntOffset.getX-impl(layer.getTopLeft());
                    float f4 = f2 - IntOffset.getY-impl(layer.getTopLeft());
                    contentDrawScope2.getDrawContext().getTransform().translate(f3, f4);
                    try {
                        GraphicsLayerKt.drawLayer(contentDrawScope2, layer);
                        contentDrawScope2.getDrawContext().getTransform().translate(-f3, -f4);
                    } catch (Throwable th) {
                        contentDrawScope2.getDrawContext().getTransform().translate(-f3, -f4);
                        throw th;
                    }
                }
            }
            contentDrawScope.drawContent();
        }

        @Override
        public void onAttach() {
            ((LazyLayoutItemAnimator) this.animator).displayingNode = this;
        }

        @Override
        public void onDetach() {
            this.animator.reset();
        }

        public final void setAnimator(LazyLayoutItemAnimator<?> animator) {
            if (Intrinsics.areEqual(this.animator, animator) || !getNode().getIsAttached()) {
                return;
            }
            this.animator.reset();
            ((LazyLayoutItemAnimator) animator).displayingNode = this;
            this.animator = animator;
        }
    }
}
