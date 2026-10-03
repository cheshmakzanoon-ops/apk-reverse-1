package androidx.compose.foundation.lazy.staggeredgrid;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.gestures.FlingBehavior;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.foundation.gestures.ScrollableDefaults;
import androidx.compose.foundation.layout.Arrangement;
import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.foundation.layout.PaddingValues;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.functions.Function5;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\u009a\u0001\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0011\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\u0083\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u000b2\u0017\u0010\u0013\u001a\u0013\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00010\u0014¢\u0006\u0002\b\u0016H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018\u001a\u0083\u0001\u0010\u0019\u001a\u00020\u00012\u0006\u0010\u001a\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\u001b\u001a\u00020\u000f2\b\b\u0002\u0010\u001c\u001a\u00020\u001d2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u000b2\u0017\u0010\u0013\u001a\u0013\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00010\u0014¢\u0006\u0002\b\u0016H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001f\u001a%\u0010 \u001a\u00020!2\u0006\u0010\u001a\u001a\u00020\u00032\u0006\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\b\u001a\u00020\tH\u0003¢\u0006\u0002\u0010\"\u001a%\u0010#\u001a\u00020!2\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\b\u001a\u00020\tH\u0003¢\u0006\u0002\u0010$\u001aÐ\u0001\u0010%\u001a\u00020\u0001\"\u0004\b\u0000\u0010&*\u00020\u00152\f\u0010%\u001a\b\u0012\u0004\u0012\u0002H&0'2%\b\n\u0010(\u001a\u001f\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020,\u0018\u00010\u00142%\b\u0006\u0010-\u001a\u001f\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0006\u0012\u0004\u0018\u00010,0\u00142%\b\n\u0010.\u001a\u001f\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020/\u0018\u00010\u001423\b\u0004\u00100\u001a-\u0012\u0004\u0012\u000202\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u000101¢\u0006\u0002\b3¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u00104\u001aÐ\u0001\u0010%\u001a\u00020\u0001\"\u0004\b\u0000\u0010&*\u00020\u00152\f\u0010%\u001a\b\u0012\u0004\u0012\u0002H&052%\b\n\u0010(\u001a\u001f\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020,\u0018\u00010\u00142%\b\u0006\u0010-\u001a\u001f\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0006\u0012\u0004\u0018\u00010,0\u00142%\b\n\u0010.\u001a\u001f\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020/\u0018\u00010\u001423\b\u0004\u00100\u001a-\u0012\u0004\u0012\u000202\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u000101¢\u0006\u0002\b3¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u00106\u001a¤\u0002\u00107\u001a\u00020\u0001\"\u0004\b\u0000\u0010&*\u00020\u00152\f\u0010%\u001a\b\u0012\u0004\u0012\u0002H&0'2:\b\n\u0010(\u001a4\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020,\u0018\u0001012:\b\u0006\u0010-\u001a4\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0006\u0012\u0004\u0018\u00010,012:\b\n\u0010.\u001a4\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020/\u0018\u0001012H\b\u0004\u00100\u001aB\u0012\u0004\u0012\u000202\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u00010:¢\u0006\u0002\b3¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u0010;\u001a¤\u0002\u00107\u001a\u00020\u0001\"\u0004\b\u0000\u0010&*\u00020\u00152\f\u0010%\u001a\b\u0012\u0004\u0012\u0002H&052:\b\n\u0010(\u001a4\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020,\u0018\u0001012:\b\u0006\u0010-\u001a4\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0006\u0012\u0004\u0018\u00010,012:\b\n\u0010.\u001a4\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020/\u0018\u0001012H\b\u0004\u00100\u001aB\u0012\u0004\u0012\u000202\u0012\u0013\u0012\u001108¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H&¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u00010:¢\u0006\u0002\b3¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u0010<\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006="}, d2 = {"LazyHorizontalStaggeredGrid", "", "rows", "Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridCells;", "modifier", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "reverseLayout", "", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "horizontalItemSpacing", "Landroidx/compose/ui/unit/Dp;", "flingBehavior", "Landroidx/compose/foundation/gestures/FlingBehavior;", "userScrollEnabled", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;", "Lkotlin/ExtensionFunctionType;", "LazyHorizontalStaggeredGrid-cJHQLPU", "(Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridCells;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;Landroidx/compose/foundation/layout/PaddingValues;ZLandroidx/compose/foundation/layout/Arrangement$Vertical;FLandroidx/compose/foundation/gestures/FlingBehavior;ZLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "LazyVerticalStaggeredGrid", "columns", "verticalItemSpacing", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "LazyVerticalStaggeredGrid-zadm560", "(Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridCells;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridState;Landroidx/compose/foundation/layout/PaddingValues;ZFLandroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/gestures/FlingBehavior;ZLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "rememberColumnSlots", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyGridStaggeredGridSlotsProvider;", "(Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridCells;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/PaddingValues;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/lazy/staggeredgrid/LazyGridStaggeredGridSlotsProvider;", "rememberRowSlots", "(Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridCells;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/PaddingValues;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/lazy/staggeredgrid/LazyGridStaggeredGridSlotsProvider;", "items", "T", "", "key", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "item", "", "contentType", "span", "Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridItemSpan;", "itemContent", "Lkotlin/Function2;", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;", "Landroidx/compose/runtime/Composable;", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;[Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function4;)V", "", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;Ljava/util/List;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function4;)V", "itemsIndexed", "", "index", "Lkotlin/Function3;", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;[Ljava/lang/Object;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function5;)V", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridScope;Ljava/util/List;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function5;)V", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyStaggeredGridDslKt {
    public static final void m1273LazyVerticalStaggeredGridzadm560(final StaggeredGridCells staggeredGridCells, Modifier modifier, LazyStaggeredGridState lazyStaggeredGridState, PaddingValues paddingValues, boolean z, float f, Arrangement.Horizontal horizontal, FlingBehavior flingBehavior, boolean z2, final Function1<? super LazyStaggeredGridScope, Unit> function1, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        PaddingValues paddingValues2;
        int i5;
        int i6;
        boolean z3;
        int i7;
        int i8;
        float f2;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        Modifier.Companion companion;
        LazyStaggeredGridState lazyStaggeredGridStateRememberLazyStaggeredGridState;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        float f3;
        Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4;
        FlingBehavior flingBehavior2;
        boolean z4;
        final LazyStaggeredGridState lazyStaggeredGridState2;
        final boolean z5;
        boolean z6;
        Arrangement.Horizontal horizontal2;
        final float f4;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1695323794);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyVerticalStaggeredGrid)P(!1,5,7,2,6,9:c#ui.unit.Dp,4,3,8)64@3068L32,69@3365L15,83@3878L67,73@3476L502:LazyStaggeredGridDsl.kt#fzvcnm");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(staggeredGridCells) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i15 = i2 & 2;
        if (i15 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) != 0) {
                i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changedInstance(lazyStaggeredGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    paddingValues2 = paddingValues;
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 16;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        z3 = z;
                        if (composerStartRestartGroup.changed(z3)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 32;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            f2 = f;
                            if (composerStartRestartGroup.changed(f2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        i10 = i2 & 64;
                        if (i10 != 0) {
                            i3 |= 1572864;
                        } else if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(horizontal)) {
                                i11 = 1048576;
                            } else {
                                i11 = 524288;
                            }
                            i3 |= i11;
                        }
                        if ((i & 12582912) != 0) {
                            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                        }
                        i12 = i2 & Fields.RotationX;
                        if (i12 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(z2)) {
                                i13 = 67108864;
                            } else {
                                i13 = 33554432;
                            }
                            i3 |= i13;
                        }
                        if ((i2 & Fields.RotationY) != 0) {
                            if ((i & 805306368) == 0) {
                                if (composerStartRestartGroup.changedInstance(function1)) {
                                    i14 = 536870912;
                                } else {
                                    i14 = 268435456;
                                }
                                i3 |= i14;
                            }
                            if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                                composerStartRestartGroup.startDefaults();
                                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                    if (i15 != 0) {
                                        companion = Modifier.INSTANCE;
                                    } else {
                                        companion = modifier;
                                    }
                                    if ((i2 & 4) != 0) {
                                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                        i3 &= -897;
                                    } else {
                                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                    }
                                    if (i4 != 0) {
                                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                    } else {
                                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                    }
                                    if (i6 != 0) {
                                        z3 = false;
                                    }
                                    if (i8 != 0) {
                                        f3 = Dp.constructor-impl(0);
                                    } else {
                                        f3 = f2;
                                    }
                                    if (i10 != 0) {
                                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                    } else {
                                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                    }
                                    if ((i2 & Fields.SpotShadowColor) != 0) {
                                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                        i3 &= -29360129;
                                    } else {
                                        flingBehavior2 = flingBehavior;
                                    }
                                    if (i12 != 0) {
                                        z4 = true;
                                    } else {
                                        z4 = z2;
                                    }
                                } else {
                                    composerStartRestartGroup.skipToGroupEnd();
                                    if ((i2 & 4) != 0) {
                                        i3 &= -897;
                                    }
                                    if ((i2 & Fields.SpotShadowColor) != 0) {
                                        i3 &= -29360129;
                                    }
                                    companion = modifier;
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                    flingBehavior2 = flingBehavior;
                                    z4 = z2;
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                    f3 = f2;
                                }
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                                }
                                int i16 = i3 >> 3;
                                int i17 = i3 << 3;
                                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i16 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i17 & 57344) | (i17 & 458752) | (3670016 & i16) | (29360128 & i16) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                                z5 = z3;
                                z6 = z4;
                                float f5 = f3;
                                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                                f4 = f5;
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                companion = modifier;
                                lazyStaggeredGridState2 = lazyStaggeredGridState;
                                flingBehavior2 = flingBehavior;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                z5 = z3;
                                f4 = f2;
                                horizontal2 = horizontal;
                                z6 = z2;
                            }
                            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                            if (scopeUpdateScopeEndRestartGroup != null) {
                                final Modifier modifier2 = companion;
                                final PaddingValues paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                                final Arrangement.Horizontal horizontal3 = horizontal2;
                                final FlingBehavior flingBehavior3 = flingBehavior2;
                                final boolean z7 = z6;
                                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i18) {
                                        LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier2, lazyStaggeredGridState2, paddingValues3, z5, f4, horizontal3, flingBehavior3, z7, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                    }
                                });
                            }
                        }
                        i3 |= 805306368;
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i18 = i3 >> 3;
                            int i19 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i18 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i19 & 57344) | (i19 & 458752) | (3670016 & i18) | (29360128 & i18) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f6 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f6;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i110 = i3 >> 3;
                            int i111 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111 & 57344) | (i111 & 458752) | (3670016 & i110) | (29360128 & i110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f7 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f7;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = companion;
                            final PaddingValues paddingValues4 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Horizontal horizontal4 = horizontal2;
                            final FlingBehavior flingBehavior4 = flingBehavior2;
                            final boolean z8 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i112) {
                                    LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier3, lazyStaggeredGridState2, paddingValues4, z5, f4, horizontal4, flingBehavior4, z8, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    f2 = f;
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i112 = i3 >> 3;
                            int i113 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i113 & 57344) | (i113 & 458752) | (3670016 & i112) | (29360128 & i112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f8 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f8;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i114 = i3 >> 3;
                            int i115 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i115 & 57344) | (i115 & 458752) | (3670016 & i114) | (29360128 & i114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f9 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f9;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier4 = companion;
                            final PaddingValues paddingValues5 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Horizontal horizontal5 = horizontal2;
                            final FlingBehavior flingBehavior5 = flingBehavior2;
                            final boolean z9 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i116) {
                                    LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier4, lazyStaggeredGridState2, paddingValues5, z5, f4, horizontal5, flingBehavior5, z9, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i116 = i3 >> 3;
                        int i117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i117 & 57344) | (i117 & 458752) | (3670016 & i116) | (29360128 & i116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f10 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f10;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i118 = i3 >> 3;
                        int i119 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i119 & 57344) | (i119 & 458752) | (3670016 & i118) | (29360128 & i118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f11 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f11;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = companion;
                        final PaddingValues paddingValues6 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal6 = horizontal2;
                        final FlingBehavior flingBehavior6 = flingBehavior2;
                        final boolean z10 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1110) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier5, lazyStaggeredGridState2, paddingValues6, z5, f4, horizontal6, flingBehavior6, z10, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                z3 = z;
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        f2 = f;
                        if (composerStartRestartGroup.changed(f2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i1110 = i3 >> 3;
                            int i1111 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111 & 57344) | (i1111 & 458752) | (3670016 & i1110) | (29360128 & i1110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f12 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f12;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i1112 = i3 >> 3;
                            int i1113 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1113 & 57344) | (i1113 & 458752) | (3670016 & i1112) | (29360128 & i1112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f13 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f13;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier6 = companion;
                            final PaddingValues paddingValues7 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Horizontal horizontal7 = horizontal2;
                            final FlingBehavior flingBehavior7 = flingBehavior2;
                            final boolean z11 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1114) {
                                    LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier6, lazyStaggeredGridState2, paddingValues7, z5, f4, horizontal7, flingBehavior7, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1114 = i3 >> 3;
                        int i1115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1115 & 57344) | (i1115 & 458752) | (3670016 & i1114) | (29360128 & i1114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f14 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f14;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1116 = i3 >> 3;
                        int i1117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1117 & 57344) | (i1117 & 458752) | (3670016 & i1116) | (29360128 & i1116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f15 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f15;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = companion;
                        final PaddingValues paddingValues8 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal8 = horizontal2;
                        final FlingBehavior flingBehavior8 = flingBehavior2;
                        final boolean z12 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1118) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier7, lazyStaggeredGridState2, paddingValues8, z5, f4, horizontal8, flingBehavior8, z12, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                f2 = f;
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1118 = i3 >> 3;
                        int i1119 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1119 & 57344) | (i1119 & 458752) | (3670016 & i1118) | (29360128 & i1118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f16 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f16;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i11110 = i3 >> 3;
                        int i11111 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111 & 57344) | (i11111 & 458752) | (3670016 & i11110) | (29360128 & i11110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f17 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f17;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier8 = companion;
                        final PaddingValues paddingValues9 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal9 = horizontal2;
                        final FlingBehavior flingBehavior9 = flingBehavior2;
                        final boolean z13 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11112) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier8, lazyStaggeredGridState2, paddingValues9, z5, f4, horizontal9, flingBehavior9, z13, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11112 = i3 >> 3;
                    int i11113 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11113 & 57344) | (i11113 & 458752) | (3670016 & i11112) | (29360128 & i11112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f18 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f18;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11114 = i3 >> 3;
                    int i11115 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11115 & 57344) | (i11115 & 458752) | (3670016 & i11114) | (29360128 & i11114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f19 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f19;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = companion;
                    final PaddingValues paddingValues10 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal10 = horizontal2;
                    final FlingBehavior flingBehavior10 = flingBehavior2;
                    final boolean z14 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11116) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier9, lazyStaggeredGridState2, paddingValues10, z5, f4, horizontal10, flingBehavior10, z14, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            paddingValues2 = paddingValues;
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z;
                    if (composerStartRestartGroup.changed(z3)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        f2 = f;
                        if (composerStartRestartGroup.changed(f2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i11116 = i3 >> 3;
                            int i11117 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11117 & 57344) | (i11117 & 458752) | (3670016 & i11116) | (29360128 & i11116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f110 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f110;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i11118 = i3 >> 3;
                            int i11119 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11119 & 57344) | (i11119 & 458752) | (3670016 & i11118) | (29360128 & i11118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f111 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f111;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier10 = companion;
                            final PaddingValues paddingValues11 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Horizontal horizontal11 = horizontal2;
                            final FlingBehavior flingBehavior11 = flingBehavior2;
                            final boolean z15 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111110) {
                                    LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier10, lazyStaggeredGridState2, paddingValues11, z5, f4, horizontal11, flingBehavior11, z15, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111110 = i3 >> 3;
                        int i111111 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111 & 57344) | (i111111 & 458752) | (3670016 & i111110) | (29360128 & i111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f112 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f112;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111112 = i3 >> 3;
                        int i111113 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111113 & 57344) | (i111113 & 458752) | (3670016 & i111112) | (29360128 & i111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f113 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f113;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = companion;
                        final PaddingValues paddingValues12 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal12 = horizontal2;
                        final FlingBehavior flingBehavior12 = flingBehavior2;
                        final boolean z16 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111114) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier11, lazyStaggeredGridState2, paddingValues12, z5, f4, horizontal12, flingBehavior12, z16, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                f2 = f;
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111114 = i3 >> 3;
                        int i111115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111115 & 57344) | (i111115 & 458752) | (3670016 & i111114) | (29360128 & i111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f114 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f114;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111116 = i3 >> 3;
                        int i111117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111117 & 57344) | (i111117 & 458752) | (3670016 & i111116) | (29360128 & i111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f115 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f115;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier12 = companion;
                        final PaddingValues paddingValues13 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal13 = horizontal2;
                        final FlingBehavior flingBehavior13 = flingBehavior2;
                        final boolean z17 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111118) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier12, lazyStaggeredGridState2, paddingValues13, z5, f4, horizontal13, flingBehavior13, z17, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i111118 = i3 >> 3;
                    int i111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111119 & 57344) | (i111119 & 458752) | (3670016 & i111118) | (29360128 & i111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f116 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f116;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111110 = i3 >> 3;
                    int i1111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111 & 57344) | (i1111111 & 458752) | (3670016 & i1111110) | (29360128 & i1111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f117 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f117;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = companion;
                    final PaddingValues paddingValues14 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal14 = horizontal2;
                    final FlingBehavior flingBehavior14 = flingBehavior2;
                    final boolean z18 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111112) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier13, lazyStaggeredGridState2, paddingValues14, z5, f4, horizontal14, flingBehavior14, z18, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    f2 = f;
                    if (composerStartRestartGroup.changed(f2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1111112 = i3 >> 3;
                        int i1111113 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111113 & 57344) | (i1111113 & 458752) | (3670016 & i1111112) | (29360128 & i1111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f118 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f118;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1111114 = i3 >> 3;
                        int i1111115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111115 & 57344) | (i1111115 & 458752) | (3670016 & i1111114) | (29360128 & i1111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f119 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f119;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier14 = companion;
                        final PaddingValues paddingValues15 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal15 = horizontal2;
                        final FlingBehavior flingBehavior15 = flingBehavior2;
                        final boolean z19 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111116) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier14, lazyStaggeredGridState2, paddingValues15, z5, f4, horizontal15, flingBehavior15, z19, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111116 = i3 >> 3;
                    int i1111117 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111117 & 57344) | (i1111117 & 458752) | (3670016 & i1111116) | (29360128 & i1111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f1110 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f1110;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111118 = i3 >> 3;
                    int i1111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111119 & 57344) | (i1111119 & 458752) | (3670016 & i1111118) | (29360128 & i1111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f1111 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f1111;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = companion;
                    final PaddingValues paddingValues16 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal16 = horizontal2;
                    final FlingBehavior flingBehavior16 = flingBehavior2;
                    final boolean z110 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111110) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier15, lazyStaggeredGridState2, paddingValues16, z5, f4, horizontal16, flingBehavior16, z110, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            f2 = f;
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11111110 = i3 >> 3;
                    int i11111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111 & 57344) | (i11111111 & 458752) | (3670016 & i11111110) | (29360128 & i11111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f1112 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f1112;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11111112 = i3 >> 3;
                    int i11111113 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111113 & 57344) | (i11111113 & 458752) | (3670016 & i11111112) | (29360128 & i11111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f1113 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f1113;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier16 = companion;
                    final PaddingValues paddingValues17 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal17 = horizontal2;
                    final FlingBehavior flingBehavior17 = flingBehavior2;
                    final boolean z111 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111114) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier16, lazyStaggeredGridState2, paddingValues17, z5, f4, horizontal17, flingBehavior17, z111, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111114 = i3 >> 3;
                int i11111115 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111115 & 57344) | (i11111115 & 458752) | (3670016 & i11111114) | (29360128 & i11111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f1114 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f1114;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111116 = i3 >> 3;
                int i11111117 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111117 & 57344) | (i11111117 & 458752) | (3670016 & i11111116) | (29360128 & i11111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f1115 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f1115;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = companion;
                final PaddingValues paddingValues18 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal18 = horizontal2;
                final FlingBehavior flingBehavior18 = flingBehavior2;
                final boolean z112 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111118) {
                        LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier17, lazyStaggeredGridState2, paddingValues18, z5, f4, horizontal18, flingBehavior18, z112, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) != 0) {
            i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changedInstance(lazyStaggeredGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                paddingValues2 = paddingValues;
                if (composerStartRestartGroup.changed(paddingValues2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z;
                    if (composerStartRestartGroup.changed(z3)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        f2 = f;
                        if (composerStartRestartGroup.changed(f2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i11111118 = i3 >> 3;
                            int i11111119 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111119 & 57344) | (i11111119 & 458752) | (3670016 & i11111118) | (29360128 & i11111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f1116 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f1116;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    f3 = Dp.constructor-impl(0);
                                } else {
                                    f3 = f2;
                                }
                                if (i10 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                            }
                            int i111111110 = i3 >> 3;
                            int i111111111 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111 & 57344) | (i111111111 & 458752) | (3670016 & i111111110) | (29360128 & i111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            z5 = z3;
                            z6 = z4;
                            float f1117 = f3;
                            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                            f4 = f1117;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier18 = companion;
                            final PaddingValues paddingValues19 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Horizontal horizontal19 = horizontal2;
                            final FlingBehavior flingBehavior19 = flingBehavior2;
                            final boolean z113 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111111112) {
                                    LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier18, lazyStaggeredGridState2, paddingValues19, z5, f4, horizontal19, flingBehavior19, z113, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111111112 = i3 >> 3;
                        int i111111113 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111113 & 57344) | (i111111113 & 458752) | (3670016 & i111111112) | (29360128 & i111111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f1118 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f1118;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111111114 = i3 >> 3;
                        int i111111115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111115 & 57344) | (i111111115 & 458752) | (3670016 & i111111114) | (29360128 & i111111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f1119 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f1119;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier19 = companion;
                        final PaddingValues paddingValues110 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal110 = horizontal2;
                        final FlingBehavior flingBehavior110 = flingBehavior2;
                        final boolean z114 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111111116) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier19, lazyStaggeredGridState2, paddingValues110, z5, f4, horizontal110, flingBehavior110, z114, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                f2 = f;
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111111116 = i3 >> 3;
                        int i111111117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111117 & 57344) | (i111111117 & 458752) | (3670016 & i111111116) | (29360128 & i111111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f11110 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f11110;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111111118 = i3 >> 3;
                        int i111111119 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111119 & 57344) | (i111111119 & 458752) | (3670016 & i111111118) | (29360128 & i111111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f11111 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f11111;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier110 = companion;
                        final PaddingValues paddingValues111 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal111 = horizontal2;
                        final FlingBehavior flingBehavior111 = flingBehavior2;
                        final boolean z115 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111111110) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier110, lazyStaggeredGridState2, paddingValues111, z5, f4, horizontal111, flingBehavior111, z115, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111111110 = i3 >> 3;
                    int i1111111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111 & 57344) | (i1111111111 & 458752) | (3670016 & i1111111110) | (29360128 & i1111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f11112 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f11112;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111111112 = i3 >> 3;
                    int i1111111113 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111113 & 57344) | (i1111111113 & 458752) | (3670016 & i1111111112) | (29360128 & i1111111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f11113 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f11113;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier111 = companion;
                    final PaddingValues paddingValues112 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal112 = horizontal2;
                    final FlingBehavior flingBehavior112 = flingBehavior2;
                    final boolean z116 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111111114) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier111, lazyStaggeredGridState2, paddingValues112, z5, f4, horizontal112, flingBehavior112, z116, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    f2 = f;
                    if (composerStartRestartGroup.changed(f2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1111111114 = i3 >> 3;
                        int i1111111115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111115 & 57344) | (i1111111115 & 458752) | (3670016 & i1111111114) | (29360128 & i1111111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f11114 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f11114;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i1111111116 = i3 >> 3;
                        int i1111111117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111117 & 57344) | (i1111111117 & 458752) | (3670016 & i1111111116) | (29360128 & i1111111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f11115 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f11115;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier112 = companion;
                        final PaddingValues paddingValues113 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal113 = horizontal2;
                        final FlingBehavior flingBehavior113 = flingBehavior2;
                        final boolean z117 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111111118) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier112, lazyStaggeredGridState2, paddingValues113, z5, f4, horizontal113, flingBehavior113, z117, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111111118 = i3 >> 3;
                    int i1111111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111119 & 57344) | (i1111111119 & 458752) | (3670016 & i1111111118) | (29360128 & i1111111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f11116 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f11116;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11111111110 = i3 >> 3;
                    int i11111111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111 & 57344) | (i11111111111 & 458752) | (3670016 & i11111111110) | (29360128 & i11111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f11117 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f11117;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier113 = companion;
                    final PaddingValues paddingValues114 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal114 = horizontal2;
                    final FlingBehavior flingBehavior114 = flingBehavior2;
                    final boolean z118 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111112) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier113, lazyStaggeredGridState2, paddingValues114, z5, f4, horizontal114, flingBehavior114, z118, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            f2 = f;
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11111111112 = i3 >> 3;
                    int i11111111113 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111113 & 57344) | (i11111111113 & 458752) | (3670016 & i11111111112) | (29360128 & i11111111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f11118 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f11118;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i11111111114 = i3 >> 3;
                    int i11111111115 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111115 & 57344) | (i11111111115 & 458752) | (3670016 & i11111111114) | (29360128 & i11111111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f11119 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f11119;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier114 = companion;
                    final PaddingValues paddingValues115 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal115 = horizontal2;
                    final FlingBehavior flingBehavior115 = flingBehavior2;
                    final boolean z119 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111116) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier114, lazyStaggeredGridState2, paddingValues115, z5, f4, horizontal115, flingBehavior115, z119, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111111116 = i3 >> 3;
                int i11111111117 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111117 & 57344) | (i11111111117 & 458752) | (3670016 & i11111111116) | (29360128 & i11111111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f111110 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f111110;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111111118 = i3 >> 3;
                int i11111111119 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111119 & 57344) | (i11111111119 & 458752) | (3670016 & i11111111118) | (29360128 & i11111111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f111111 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f111111;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier115 = companion;
                final PaddingValues paddingValues116 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal116 = horizontal2;
                final FlingBehavior flingBehavior116 = flingBehavior2;
                final boolean z1110 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i111111111110) {
                        LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier115, lazyStaggeredGridState2, paddingValues116, z5, f4, horizontal116, flingBehavior116, z1110, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        paddingValues2 = paddingValues;
        i6 = i2 & 16;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                z3 = z;
                if (composerStartRestartGroup.changed(z3)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    f2 = f;
                    if (composerStartRestartGroup.changed(f2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111111111110 = i3 >> 3;
                        int i111111111111 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111 & 57344) | (i111111111111 & 458752) | (3670016 & i111111111110) | (29360128 & i111111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f111112 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f111112;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                f3 = Dp.constructor-impl(0);
                            } else {
                                f3 = f2;
                            }
                            if (i10 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                        }
                        int i111111111112 = i3 >> 3;
                        int i111111111113 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111113 & 57344) | (i111111111113 & 458752) | (3670016 & i111111111112) | (29360128 & i111111111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        z5 = z3;
                        z6 = z4;
                        float f111113 = f3;
                        horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                        f4 = f111113;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier116 = companion;
                        final PaddingValues paddingValues117 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal117 = horizontal2;
                        final FlingBehavior flingBehavior117 = flingBehavior2;
                        final boolean z1111 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111111111114) {
                                LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier116, lazyStaggeredGridState2, paddingValues117, z5, f4, horizontal117, flingBehavior117, z1111, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i111111111114 = i3 >> 3;
                    int i111111111115 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111115 & 57344) | (i111111111115 & 458752) | (3670016 & i111111111114) | (29360128 & i111111111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f111114 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f111114;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i111111111116 = i3 >> 3;
                    int i111111111117 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111117 & 57344) | (i111111111117 & 458752) | (3670016 & i111111111116) | (29360128 & i111111111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f111115 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f111115;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier117 = companion;
                    final PaddingValues paddingValues118 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal118 = horizontal2;
                    final FlingBehavior flingBehavior118 = flingBehavior2;
                    final boolean z1112 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111111111118) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier117, lazyStaggeredGridState2, paddingValues118, z5, f4, horizontal118, flingBehavior118, z1112, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            f2 = f;
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i111111111118 = i3 >> 3;
                    int i111111111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111119 & 57344) | (i111111111119 & 458752) | (3670016 & i111111111118) | (29360128 & i111111111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f111116 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f111116;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111111111110 = i3 >> 3;
                    int i1111111111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111 & 57344) | (i1111111111111 & 458752) | (3670016 & i1111111111110) | (29360128 & i1111111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f111117 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f111117;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier118 = companion;
                    final PaddingValues paddingValues119 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal119 = horizontal2;
                    final FlingBehavior flingBehavior119 = flingBehavior2;
                    final boolean z1113 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111111111112) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier118, lazyStaggeredGridState2, paddingValues119, z5, f4, horizontal119, flingBehavior119, z1113, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i1111111111112 = i3 >> 3;
                int i1111111111113 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111113 & 57344) | (i1111111111113 & 458752) | (3670016 & i1111111111112) | (29360128 & i1111111111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f111118 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f111118;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i1111111111114 = i3 >> 3;
                int i1111111111115 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111115 & 57344) | (i1111111111115 & 458752) | (3670016 & i1111111111114) | (29360128 & i1111111111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f111119 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f111119;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier119 = companion;
                final PaddingValues paddingValues1110 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal1110 = horizontal2;
                final FlingBehavior flingBehavior1110 = flingBehavior2;
                final boolean z1114 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111111116) {
                        LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier119, lazyStaggeredGridState2, paddingValues1110, z5, f4, horizontal1110, flingBehavior1110, z1114, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        z3 = z;
        i8 = i2 & 32;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                f2 = f;
                if (composerStartRestartGroup.changed(f2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(horizontal)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111111111116 = i3 >> 3;
                    int i1111111111117 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111117 & 57344) | (i1111111111117 & 458752) | (3670016 & i1111111111116) | (29360128 & i1111111111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f1111110 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f1111110;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            f3 = Dp.constructor-impl(0);
                        } else {
                            f3 = f2;
                        }
                        if (i10 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                    }
                    int i1111111111118 = i3 >> 3;
                    int i1111111111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111119 & 57344) | (i1111111111119 & 458752) | (3670016 & i1111111111118) | (29360128 & i1111111111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    z5 = z3;
                    z6 = z4;
                    float f1111111 = f3;
                    horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                    f4 = f1111111;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier1110 = companion;
                    final PaddingValues paddingValues1111 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal1111 = horizontal2;
                    final FlingBehavior flingBehavior1111 = flingBehavior2;
                    final boolean z1115 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111111110) {
                            LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier1110, lazyStaggeredGridState2, paddingValues1111, z5, f4, horizontal1111, flingBehavior1111, z1115, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111111111110 = i3 >> 3;
                int i11111111111111 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111 & 57344) | (i11111111111111 & 458752) | (3670016 & i11111111111110) | (29360128 & i11111111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f1111112 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f1111112;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111111111112 = i3 >> 3;
                int i11111111111113 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111112 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111113 & 57344) | (i11111111111113 & 458752) | (3670016 & i11111111111112) | (29360128 & i11111111111112) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f1111113 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f1111113;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1111 = companion;
                final PaddingValues paddingValues1112 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal1112 = horizontal2;
                final FlingBehavior flingBehavior1112 = flingBehavior2;
                final boolean z1116 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111111114) {
                        LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier1111, lazyStaggeredGridState2, paddingValues1112, z5, f4, horizontal1112, flingBehavior1112, z1116, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        f2 = f;
        i10 = i2 & 64;
        if (i10 != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(horizontal)) {
                i11 = 1048576;
            } else {
                i11 = 524288;
            }
            i3 |= i11;
        }
        if ((i & 12582912) != 0) {
            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
        }
        i12 = i2 & Fields.RotationX;
        if (i12 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i13 = 67108864;
            } else {
                i13 = 33554432;
            }
            i3 |= i13;
        }
        if ((i2 & Fields.RotationY) != 0) {
            if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i3 |= i14;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111111111114 = i3 >> 3;
                int i11111111111115 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111114 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111115 & 57344) | (i11111111111115 & 458752) | (3670016 & i11111111111114) | (29360128 & i11111111111114) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f1111114 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f1111114;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        f3 = Dp.constructor-impl(0);
                    } else {
                        f3 = f2;
                    }
                    if (i10 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
                }
                int i11111111111116 = i3 >> 3;
                int i11111111111117 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111116 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111117 & 57344) | (i11111111111117 & 458752) | (3670016 & i11111111111116) | (29360128 & i11111111111116) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                z5 = z3;
                z6 = z4;
                float f1111115 = f3;
                horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
                f4 = f1111115;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1112 = companion;
                final PaddingValues paddingValues1113 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal1113 = horizontal2;
                final FlingBehavior flingBehavior1113 = flingBehavior2;
                final boolean z1117 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111111118) {
                        LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier1112, lazyStaggeredGridState2, paddingValues1113, z5, f4, horizontal1113, flingBehavior1113, z1117, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 805306368;
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if (i10 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            } else {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if (i10 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
            }
            int i11111111111118 = i3 >> 3;
            int i11111111111119 = i3 << 3;
            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111118 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111119 & 57344) | (i11111111111119 & 458752) | (3670016 & i11111111111118) | (29360128 & i11111111111118) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
            z5 = z3;
            z6 = z4;
            float f1111116 = f3;
            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
            f4 = f1111116;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if (i10 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            } else {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    f3 = Dp.constructor-impl(0);
                } else {
                    f3 = f2;
                }
                if (i10 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = horizontal;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1695323794, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyVerticalStaggeredGrid (LazyStaggeredGridDsl.kt:72)");
            }
            int i111111111111110 = i3 >> 3;
            int i111111111111111 = i3 << 3;
            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Vertical, rememberColumnSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111110 & 896) | (i3 & 14) | ((i3 >> 15) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f3, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, ((i3 << 6) & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111 & 57344) | (i111111111111111 & 458752) | (3670016 & i111111111111110) | (29360128 & i111111111111110) | ((i3 << 9) & 234881024), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
            z5 = z3;
            z6 = z4;
            float f1111117 = f3;
            horizontal2 = horizontalOrVerticalM911spacedBy0680j_4;
            f4 = f1111117;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier1113 = companion;
            final PaddingValues paddingValues1114 = paddingValuesM1028PaddingValues0680j_4;
            final Arrangement.Horizontal horizontal1114 = horizontal2;
            final FlingBehavior flingBehavior1114 = flingBehavior2;
            final boolean z1118 = z6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i111111111111112) {
                    LazyStaggeredGridDslKt.m1273LazyVerticalStaggeredGridzadm560(staggeredGridCells, modifier1113, lazyStaggeredGridState2, paddingValues1114, z5, f4, horizontal1114, flingBehavior1114, z1118, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final LazyGridStaggeredGridSlotsProvider rememberColumnSlots(final StaggeredGridCells staggeredGridCells, final Arrangement.Horizontal horizontal, final PaddingValues paddingValues, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1267076841, "C(rememberColumnSlots)P(!1,2)94@4216L1114:LazyStaggeredGridDsl.kt#fzvcnm");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1267076841, i, -1, "androidx.compose.foundation.lazy.staggeredgrid.rememberColumnSlots (LazyStaggeredGridDsl.kt:94)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 463564400, "CC(remember):LazyStaggeredGridDsl.kt#9igjgp");
        boolean z = ((((i & 14) ^ 6) > 4 && composer.changed(staggeredGridCells)) || (i & 6) == 4) | ((((i & 112) ^ 48) > 32 && composer.changed(horizontal)) || (i & 48) == 32) | ((((i & 896) ^ 384) > 256 && composer.changed(paddingValues)) || (i & 384) == 256);
        LazyStaggeredGridSlotCache lazyStaggeredGridSlotCacheRememberedValue = composer.rememberedValue();
        if (z || lazyStaggeredGridSlotCacheRememberedValue == Composer.INSTANCE.getEmpty()) {
            lazyStaggeredGridSlotCacheRememberedValue = new LazyStaggeredGridSlotCache(new Function2<Density, Constraints, LazyStaggeredGridSlots>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1276invoke0kLqBqw((Density) obj, ((Constraints) obj2).unbox-impl());
                }

                public final LazyStaggeredGridSlots m1276invoke0kLqBqw(Density density, long j) {
                    if (Constraints.getMaxWidth-impl(j) == Integer.MAX_VALUE) {
                        throw new IllegalArgumentException("LazyVerticalStaggeredGrid's width should be bound by parent.".toString());
                    }
                    int i2 = Constraints.getMaxWidth-impl(j) - density.roundToPx-0680j_4(Dp.constructor-impl(PaddingKt.calculateStartPadding(paddingValues, LayoutDirection.Ltr) + PaddingKt.calculateEndPadding(paddingValues, LayoutDirection.Ltr)));
                    StaggeredGridCells staggeredGridCells2 = staggeredGridCells;
                    Arrangement.Horizontal horizontal2 = horizontal;
                    int[] iArrCalculateCrossAxisCellSizes = staggeredGridCells2.calculateCrossAxisCellSizes(density, i2, density.roundToPx-0680j_4(horizontal2.getSpacing()));
                    int[] iArr = new int[iArrCalculateCrossAxisCellSizes.length];
                    horizontal2.arrange(density, i2, iArrCalculateCrossAxisCellSizes, LayoutDirection.Ltr, iArr);
                    return new LazyStaggeredGridSlots(iArr, iArrCalculateCrossAxisCellSizes);
                }
            });
            composer.updateRememberedValue(lazyStaggeredGridSlotCacheRememberedValue);
        }
        LazyGridStaggeredGridSlotsProvider lazyGridStaggeredGridSlotsProvider = (LazyGridStaggeredGridSlotsProvider) lazyStaggeredGridSlotCacheRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return lazyGridStaggeredGridSlotsProvider;
    }

    public static final void m1272LazyHorizontalStaggeredGridcJHQLPU(final StaggeredGridCells staggeredGridCells, Modifier modifier, LazyStaggeredGridState lazyStaggeredGridState, PaddingValues paddingValues, boolean z, Arrangement.Vertical vertical, float f, FlingBehavior flingBehavior, boolean z2, final Function1<? super LazyStaggeredGridScope, Unit> function1, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        PaddingValues paddingValues2;
        int i5;
        int i6;
        boolean z3;
        int i7;
        int i8;
        Arrangement.Vertical vertical2;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        Modifier.Companion companion;
        LazyStaggeredGridState lazyStaggeredGridStateRememberLazyStaggeredGridState;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        Arrangement.HorizontalOrVertical horizontalOrVerticalM911spacedBy0680j_4;
        float f2;
        FlingBehavior flingBehavior2;
        boolean z4;
        final LazyStaggeredGridState lazyStaggeredGridState2;
        float f3;
        final boolean z5;
        final Arrangement.Vertical vertical3;
        boolean z6;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-8666074);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyHorizontalStaggeredGrid)P(6,4,7,1,5,9,3:c#ui.unit.Dp,2,8)154@6993L32,159@7288L15,173@7803L59,163@7399L496:LazyStaggeredGridDsl.kt#fzvcnm");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(staggeredGridCells) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i15 = i2 & 2;
        if (i15 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) != 0) {
                i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changedInstance(lazyStaggeredGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
            }
            i4 = i2 & 8;
            if (i4 != 0) {
                if ((i & 3072) == 0) {
                    paddingValues2 = paddingValues;
                    if (composerStartRestartGroup.changed(paddingValues2)) {
                        i5 = Fields.CameraDistance;
                    } else {
                        i5 = Fields.RotationZ;
                    }
                    i3 |= i5;
                }
                i6 = i2 & 16;
                if (i6 != 0) {
                    if ((i & 24576) == 0) {
                        z3 = z;
                        if (composerStartRestartGroup.changed(z3)) {
                            i7 = Fields.Clip;
                        } else {
                            i7 = Fields.Shape;
                        }
                        i3 |= i7;
                    }
                    i8 = i2 & 32;
                    if (i8 != 0) {
                        if ((196608 & i) == 0) {
                            vertical2 = vertical;
                            if (composerStartRestartGroup.changed(vertical2)) {
                                i9 = Fields.RenderEffect;
                            } else {
                                i9 = 65536;
                            }
                            i3 |= i9;
                        }
                        i10 = i2 & 64;
                        if (i10 != 0) {
                            i3 |= 1572864;
                        } else if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(f)) {
                                i11 = 1048576;
                            } else {
                                i11 = 524288;
                            }
                            i3 |= i11;
                        }
                        if ((i & 12582912) != 0) {
                            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                        }
                        i12 = i2 & Fields.RotationX;
                        if (i12 != 0) {
                            i3 |= 100663296;
                        } else if ((i & 100663296) == 0) {
                            if (composerStartRestartGroup.changed(z2)) {
                                i13 = 67108864;
                            } else {
                                i13 = 33554432;
                            }
                            i3 |= i13;
                        }
                        if ((i2 & Fields.RotationY) != 0) {
                            if ((i & 805306368) == 0) {
                                if (composerStartRestartGroup.changedInstance(function1)) {
                                    i14 = 536870912;
                                } else {
                                    i14 = 268435456;
                                }
                                i3 |= i14;
                            }
                            if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                                composerStartRestartGroup.startDefaults();
                                if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                    if (i15 != 0) {
                                        companion = Modifier.INSTANCE;
                                    } else {
                                        companion = modifier;
                                    }
                                    if ((i2 & 4) != 0) {
                                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                        i3 &= -897;
                                    } else {
                                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                    }
                                    if (i4 != 0) {
                                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                    } else {
                                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                    }
                                    if (i6 != 0) {
                                        z3 = false;
                                    }
                                    if (i8 != 0) {
                                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                    } else {
                                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                    }
                                    if (i10 != 0) {
                                        f2 = Dp.constructor-impl(0);
                                    } else {
                                        f2 = f;
                                    }
                                    if ((i2 & Fields.SpotShadowColor) != 0) {
                                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                        i3 &= -29360129;
                                    } else {
                                        flingBehavior2 = flingBehavior;
                                    }
                                    if (i12 != 0) {
                                        z4 = true;
                                    } else {
                                        z4 = z2;
                                    }
                                } else {
                                    composerStartRestartGroup.skipToGroupEnd();
                                    if ((i2 & 4) != 0) {
                                        i3 &= -897;
                                    }
                                    if ((i2 & Fields.SpotShadowColor) != 0) {
                                        i3 &= -29360129;
                                    }
                                    companion = modifier;
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                    f2 = f;
                                    flingBehavior2 = flingBehavior;
                                    z4 = z2;
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                composerStartRestartGroup.endDefaults();
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                                }
                                int i16 = i3 >> 3;
                                int i17 = i3 << 6;
                                Arrangement.Vertical vertical4 = horizontalOrVerticalM911spacedBy0680j_4;
                                int i18 = i3 << 3;
                                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i16 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i17 & 7168) | ((i3 >> 6) & 14) | 48 | (i18 & 57344) | (i18 & 458752) | (3670016 & i16) | (29360128 & i16) | (i17 & 234881024), (i3 >> 27) & 14, 0);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                                f3 = f2;
                                z5 = z3;
                                vertical3 = vertical4;
                                z6 = z4;
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                companion = modifier;
                                lazyStaggeredGridState2 = lazyStaggeredGridState;
                                flingBehavior2 = flingBehavior;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                z5 = z3;
                                vertical3 = vertical2;
                                f3 = f;
                                z6 = z2;
                            }
                            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                            if (scopeUpdateScopeEndRestartGroup != null) {
                                final Modifier modifier2 = companion;
                                final PaddingValues paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                                final float f4 = f3;
                                final FlingBehavior flingBehavior3 = flingBehavior2;
                                final boolean z7 = z6;
                                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj, Object obj2) {
                                        invoke((Composer) obj, ((Number) obj2).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i19) {
                                        LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier2, lazyStaggeredGridState2, paddingValues3, z5, vertical3, f4, flingBehavior3, z7, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                    }
                                });
                            }
                        }
                        i3 |= 805306368;
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i19 = i3 >> 3;
                            int i110 = i3 << 6;
                            Arrangement.Vertical vertical5 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i111 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i19 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111 & 57344) | (i111 & 458752) | (3670016 & i19) | (29360128 & i19) | (i110 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical5;
                            z6 = z4;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i112 = i3 >> 3;
                            int i113 = i3 << 6;
                            Arrangement.Vertical vertical6 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i114 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i113 & 7168) | ((i3 >> 6) & 14) | 48 | (i114 & 57344) | (i114 & 458752) | (3670016 & i112) | (29360128 & i112) | (i113 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical6;
                            z6 = z4;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = companion;
                            final PaddingValues paddingValues4 = paddingValuesM1028PaddingValues0680j_4;
                            final float f5 = f3;
                            final FlingBehavior flingBehavior4 = flingBehavior2;
                            final boolean z8 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i115) {
                                    LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier3, lazyStaggeredGridState2, paddingValues4, z5, vertical3, f5, flingBehavior4, z8, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 196608;
                    vertical2 = vertical;
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(f)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i115 = i3 >> 3;
                            int i116 = i3 << 6;
                            Arrangement.Vertical vertical7 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i117 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i115 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i116 & 7168) | ((i3 >> 6) & 14) | 48 | (i117 & 57344) | (i117 & 458752) | (3670016 & i115) | (29360128 & i115) | (i116 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical7;
                            z6 = z4;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i118 = i3 >> 3;
                            int i119 = i3 << 6;
                            Arrangement.Vertical vertical8 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i1110 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i118 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i119 & 7168) | ((i3 >> 6) & 14) | 48 | (i1110 & 57344) | (i1110 & 458752) | (3670016 & i118) | (29360128 & i118) | (i119 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical8;
                            z6 = z4;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier4 = companion;
                            final PaddingValues paddingValues5 = paddingValuesM1028PaddingValues0680j_4;
                            final float f6 = f3;
                            final FlingBehavior flingBehavior5 = flingBehavior2;
                            final boolean z9 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111) {
                                    LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier4, lazyStaggeredGridState2, paddingValues5, z5, vertical3, f6, flingBehavior5, z9, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i1111 = i3 >> 3;
                        int i1112 = i3 << 6;
                        Arrangement.Vertical vertical9 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1113 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1112 & 7168) | ((i3 >> 6) & 14) | 48 | (i1113 & 57344) | (i1113 & 458752) | (3670016 & i1111) | (29360128 & i1111) | (i1112 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical9;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i1114 = i3 >> 3;
                        int i1115 = i3 << 6;
                        Arrangement.Vertical vertical10 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1116 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1114 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1115 & 7168) | ((i3 >> 6) & 14) | 48 | (i1116 & 57344) | (i1116 & 458752) | (3670016 & i1114) | (29360128 & i1114) | (i1115 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical10;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = companion;
                        final PaddingValues paddingValues6 = paddingValuesM1028PaddingValues0680j_4;
                        final float f7 = f3;
                        final FlingBehavior flingBehavior6 = flingBehavior2;
                        final boolean z10 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1117) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier5, lazyStaggeredGridState2, paddingValues6, z5, vertical3, f7, flingBehavior6, z10, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                z3 = z;
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(f)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i1117 = i3 >> 3;
                            int i1118 = i3 << 6;
                            Arrangement.Vertical vertical11 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i1119 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1117 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1118 & 7168) | ((i3 >> 6) & 14) | 48 | (i1119 & 57344) | (i1119 & 458752) | (3670016 & i1117) | (29360128 & i1117) | (i1118 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical11;
                            z6 = z4;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i11110 = i3 >> 3;
                            int i11111 = i3 << 6;
                            Arrangement.Vertical vertical12 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i11112 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11110 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111 & 7168) | ((i3 >> 6) & 14) | 48 | (i11112 & 57344) | (i11112 & 458752) | (3670016 & i11110) | (29360128 & i11110) | (i11111 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical12;
                            z6 = z4;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier6 = companion;
                            final PaddingValues paddingValues7 = paddingValuesM1028PaddingValues0680j_4;
                            final float f8 = f3;
                            final FlingBehavior flingBehavior7 = flingBehavior2;
                            final boolean z11 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i11113) {
                                    LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier6, lazyStaggeredGridState2, paddingValues7, z5, vertical3, f8, flingBehavior7, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11113 = i3 >> 3;
                        int i11114 = i3 << 6;
                        Arrangement.Vertical vertical13 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11113 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11114 & 7168) | ((i3 >> 6) & 14) | 48 | (i11115 & 57344) | (i11115 & 458752) | (3670016 & i11113) | (29360128 & i11113) | (i11114 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical13;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11116 = i3 >> 3;
                        int i11117 = i3 << 6;
                        Arrangement.Vertical vertical14 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11118 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11116 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11117 & 7168) | ((i3 >> 6) & 14) | 48 | (i11118 & 57344) | (i11118 & 458752) | (3670016 & i11116) | (29360128 & i11116) | (i11117 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical14;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = companion;
                        final PaddingValues paddingValues8 = paddingValuesM1028PaddingValues0680j_4;
                        final float f9 = f3;
                        final FlingBehavior flingBehavior8 = flingBehavior2;
                        final boolean z12 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier7, lazyStaggeredGridState2, paddingValues8, z5, vertical3, f9, flingBehavior8, z12, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                vertical2 = vertical;
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11119 = i3 >> 3;
                        int i111110 = i3 << 6;
                        Arrangement.Vertical vertical15 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i111111 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11119 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111 & 57344) | (i111111 & 458752) | (3670016 & i11119) | (29360128 & i11119) | (i111110 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical15;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i111112 = i3 >> 3;
                        int i111113 = i3 << 6;
                        Arrangement.Vertical vertical16 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i111114 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111113 & 7168) | ((i3 >> 6) & 14) | 48 | (i111114 & 57344) | (i111114 & 458752) | (3670016 & i111112) | (29360128 & i111112) | (i111113 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical16;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier8 = companion;
                        final PaddingValues paddingValues9 = paddingValuesM1028PaddingValues0680j_4;
                        final float f10 = f3;
                        final FlingBehavior flingBehavior9 = flingBehavior2;
                        final boolean z13 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111115) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier8, lazyStaggeredGridState2, paddingValues9, z5, vertical3, f10, flingBehavior9, z13, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111115 = i3 >> 3;
                    int i111116 = i3 << 6;
                    Arrangement.Vertical vertical17 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111117 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111115 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111116 & 7168) | ((i3 >> 6) & 14) | 48 | (i111117 & 57344) | (i111117 & 458752) | (3670016 & i111115) | (29360128 & i111115) | (i111116 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical17;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111118 = i3 >> 3;
                    int i111119 = i3 << 6;
                    Arrangement.Vertical vertical18 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111110 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111118 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111119 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111110 & 57344) | (i1111110 & 458752) | (3670016 & i111118) | (29360128 & i111118) | (i111119 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical18;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = companion;
                    final PaddingValues paddingValues10 = paddingValuesM1028PaddingValues0680j_4;
                    final float f11 = f3;
                    final FlingBehavior flingBehavior10 = flingBehavior2;
                    final boolean z14 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111111) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier9, lazyStaggeredGridState2, paddingValues10, z5, vertical3, f11, flingBehavior10, z14, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 3072;
            paddingValues2 = paddingValues;
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z;
                    if (composerStartRestartGroup.changed(z3)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(f)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i1111111 = i3 >> 3;
                            int i1111112 = i3 << 6;
                            Arrangement.Vertical vertical19 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i1111113 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111112 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111113 & 57344) | (i1111113 & 458752) | (3670016 & i1111111) | (29360128 & i1111111) | (i1111112 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical19;
                            z6 = z4;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i1111114 = i3 >> 3;
                            int i1111115 = i3 << 6;
                            Arrangement.Vertical vertical110 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i1111116 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111114 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111115 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111116 & 57344) | (i1111116 & 458752) | (3670016 & i1111114) | (29360128 & i1111114) | (i1111115 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical110;
                            z6 = z4;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier10 = companion;
                            final PaddingValues paddingValues11 = paddingValuesM1028PaddingValues0680j_4;
                            final float f12 = f3;
                            final FlingBehavior flingBehavior11 = flingBehavior2;
                            final boolean z15 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i1111117) {
                                    LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier10, lazyStaggeredGridState2, paddingValues11, z5, vertical3, f12, flingBehavior11, z15, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i1111117 = i3 >> 3;
                        int i1111118 = i3 << 6;
                        Arrangement.Vertical vertical111 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1111119 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111117 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111118 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111119 & 57344) | (i1111119 & 458752) | (3670016 & i1111117) | (29360128 & i1111117) | (i1111118 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical111;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11111110 = i3 >> 3;
                        int i11111111 = i3 << 6;
                        Arrangement.Vertical vertical112 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11111112 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111110 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111112 & 57344) | (i11111112 & 458752) | (3670016 & i11111110) | (29360128 & i11111110) | (i11111111 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical112;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = companion;
                        final PaddingValues paddingValues12 = paddingValuesM1028PaddingValues0680j_4;
                        final float f13 = f3;
                        final FlingBehavior flingBehavior12 = flingBehavior2;
                        final boolean z16 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111113) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier11, lazyStaggeredGridState2, paddingValues12, z5, vertical3, f13, flingBehavior12, z16, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                vertical2 = vertical;
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11111113 = i3 >> 3;
                        int i11111114 = i3 << 6;
                        Arrangement.Vertical vertical113 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11111115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111113 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111114 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111115 & 57344) | (i11111115 & 458752) | (3670016 & i11111113) | (29360128 & i11111113) | (i11111114 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical113;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11111116 = i3 >> 3;
                        int i11111117 = i3 << 6;
                        Arrangement.Vertical vertical114 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11111118 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111116 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111117 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111118 & 57344) | (i11111118 & 458752) | (3670016 & i11111116) | (29360128 & i11111116) | (i11111117 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical114;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier12 = companion;
                        final PaddingValues paddingValues13 = paddingValuesM1028PaddingValues0680j_4;
                        final float f14 = f3;
                        final FlingBehavior flingBehavior13 = flingBehavior2;
                        final boolean z17 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111119) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier12, lazyStaggeredGridState2, paddingValues13, z5, vertical3, f14, flingBehavior13, z17, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111119 = i3 >> 3;
                    int i111111110 = i3 << 6;
                    Arrangement.Vertical vertical115 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111119 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111 & 57344) | (i111111111 & 458752) | (3670016 & i11111119) | (29360128 & i11111119) | (i111111110 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical115;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111111112 = i3 >> 3;
                    int i111111113 = i3 << 6;
                    Arrangement.Vertical vertical116 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111114 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111113 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111114 & 57344) | (i111111114 & 458752) | (3670016 & i111111112) | (29360128 & i111111112) | (i111111113 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical116;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = companion;
                    final PaddingValues paddingValues14 = paddingValuesM1028PaddingValues0680j_4;
                    final float f15 = f3;
                    final FlingBehavior flingBehavior14 = flingBehavior2;
                    final boolean z18 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111111115) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier13, lazyStaggeredGridState2, paddingValues14, z5, vertical3, f15, flingBehavior14, z18, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i111111115 = i3 >> 3;
                        int i111111116 = i3 << 6;
                        Arrangement.Vertical vertical117 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i111111117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111115 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111116 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111117 & 57344) | (i111111117 & 458752) | (3670016 & i111111115) | (29360128 & i111111115) | (i111111116 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical117;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i111111118 = i3 >> 3;
                        int i111111119 = i3 << 6;
                        Arrangement.Vertical vertical118 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1111111110 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111118 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111119 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111110 & 57344) | (i1111111110 & 458752) | (3670016 & i111111118) | (29360128 & i111111118) | (i111111119 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical118;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier14 = companion;
                        final PaddingValues paddingValues15 = paddingValuesM1028PaddingValues0680j_4;
                        final float f16 = f3;
                        final FlingBehavior flingBehavior15 = flingBehavior2;
                        final boolean z19 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111111111) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier14, lazyStaggeredGridState2, paddingValues15, z5, vertical3, f16, flingBehavior15, z19, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i1111111111 = i3 >> 3;
                    int i1111111112 = i3 << 6;
                    Arrangement.Vertical vertical119 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111113 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111112 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111113 & 57344) | (i1111111113 & 458752) | (3670016 & i1111111111) | (29360128 & i1111111111) | (i1111111112 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical119;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i1111111114 = i3 >> 3;
                    int i1111111115 = i3 << 6;
                    Arrangement.Vertical vertical1110 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111116 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111114 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111115 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111116 & 57344) | (i1111111116 & 458752) | (3670016 & i1111111114) | (29360128 & i1111111114) | (i1111111115 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical1110;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = companion;
                    final PaddingValues paddingValues16 = paddingValuesM1028PaddingValues0680j_4;
                    final float f17 = f3;
                    final FlingBehavior flingBehavior16 = flingBehavior2;
                    final boolean z110 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111111117) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier15, lazyStaggeredGridState2, paddingValues16, z5, vertical3, f17, flingBehavior16, z110, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            vertical2 = vertical;
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i1111111117 = i3 >> 3;
                    int i1111111118 = i3 << 6;
                    Arrangement.Vertical vertical1111 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111117 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111118 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111119 & 57344) | (i1111111119 & 458752) | (3670016 & i1111111117) | (29360128 & i1111111117) | (i1111111118 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical1111;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111111110 = i3 >> 3;
                    int i11111111111 = i3 << 6;
                    Arrangement.Vertical vertical1112 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i11111111112 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111110 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111112 & 57344) | (i11111111112 & 458752) | (3670016 & i11111111110) | (29360128 & i11111111110) | (i11111111111 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical1112;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier16 = companion;
                    final PaddingValues paddingValues17 = paddingValuesM1028PaddingValues0680j_4;
                    final float f18 = f3;
                    final FlingBehavior flingBehavior17 = flingBehavior2;
                    final boolean z111 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111113) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier16, lazyStaggeredGridState2, paddingValues17, z5, vertical3, f18, flingBehavior17, z111, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i11111111113 = i3 >> 3;
                int i11111111114 = i3 << 6;
                Arrangement.Vertical vertical1113 = horizontalOrVerticalM911spacedBy0680j_4;
                int i11111111115 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111113 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111114 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111115 & 57344) | (i11111111115 & 458752) | (3670016 & i11111111113) | (29360128 & i11111111113) | (i11111111114 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical1113;
                z6 = z4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i11111111116 = i3 >> 3;
                int i11111111117 = i3 << 6;
                Arrangement.Vertical vertical1114 = horizontalOrVerticalM911spacedBy0680j_4;
                int i11111111118 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111116 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111117 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111118 & 57344) | (i11111111118 & 458752) | (3670016 & i11111111116) | (29360128 & i11111111116) | (i11111111117 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical1114;
                z6 = z4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = companion;
                final PaddingValues paddingValues18 = paddingValuesM1028PaddingValues0680j_4;
                final float f19 = f3;
                final FlingBehavior flingBehavior18 = flingBehavior2;
                final boolean z112 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111119) {
                        LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier17, lazyStaggeredGridState2, paddingValues18, z5, vertical3, f19, flingBehavior18, z112, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) != 0) {
            i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changedInstance(lazyStaggeredGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
        }
        i4 = i2 & 8;
        if (i4 != 0) {
            if ((i & 3072) == 0) {
                paddingValues2 = paddingValues;
                if (composerStartRestartGroup.changed(paddingValues2)) {
                    i5 = Fields.CameraDistance;
                } else {
                    i5 = Fields.RotationZ;
                }
                i3 |= i5;
            }
            i6 = i2 & 16;
            if (i6 != 0) {
                if ((i & 24576) == 0) {
                    z3 = z;
                    if (composerStartRestartGroup.changed(z3)) {
                        i7 = Fields.Clip;
                    } else {
                        i7 = Fields.Shape;
                    }
                    i3 |= i7;
                }
                i8 = i2 & 32;
                if (i8 != 0) {
                    if ((196608 & i) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i9 = Fields.RenderEffect;
                        } else {
                            i9 = 65536;
                        }
                        i3 |= i9;
                    }
                    i10 = i2 & 64;
                    if (i10 != 0) {
                        i3 |= 1572864;
                    } else if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(f)) {
                            i11 = 1048576;
                        } else {
                            i11 = 524288;
                        }
                        i3 |= i11;
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i12 = i2 & Fields.RotationX;
                    if (i12 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i13 = 67108864;
                        } else {
                            i13 = 33554432;
                        }
                        i3 |= i13;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i14 = 536870912;
                            } else {
                                i14 = 268435456;
                            }
                            i3 |= i14;
                        }
                        if ((i3 & 306783379) == 306783378) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i11111111119 = i3 >> 3;
                            int i111111111110 = i3 << 6;
                            Arrangement.Vertical vertical1115 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i111111111111 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111119 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111 & 57344) | (i111111111111 & 458752) | (3670016 & i11111111119) | (29360128 & i11111111119) | (i111111111110 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical1115;
                            z6 = z4;
                        } else {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0) {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            } else {
                                if (i15 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                if (i6 != 0) {
                                    z3 = false;
                                }
                                if (i8 != 0) {
                                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                                } else {
                                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                                }
                                if (i10 != 0) {
                                    f2 = Dp.constructor-impl(0);
                                } else {
                                    f2 = f;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i12 != 0) {
                                    z4 = true;
                                } else {
                                    z4 = z2;
                                }
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                            }
                            int i111111111112 = i3 >> 3;
                            int i111111111113 = i3 << 6;
                            Arrangement.Vertical vertical1116 = horizontalOrVerticalM911spacedBy0680j_4;
                            int i111111111114 = i3 << 3;
                            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111113 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111114 & 57344) | (i111111111114 & 458752) | (3670016 & i111111111112) | (29360128 & i111111111112) | (i111111111113 & 234881024), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                            f3 = f2;
                            z5 = z3;
                            vertical3 = vertical1116;
                            z6 = z4;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier18 = companion;
                            final PaddingValues paddingValues19 = paddingValuesM1028PaddingValues0680j_4;
                            final float f110 = f3;
                            final FlingBehavior flingBehavior19 = flingBehavior2;
                            final boolean z113 = z6;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i111111111115) {
                                    LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier18, lazyStaggeredGridState2, paddingValues19, z5, vertical3, f110, flingBehavior19, z113, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i111111111115 = i3 >> 3;
                        int i111111111116 = i3 << 6;
                        Arrangement.Vertical vertical1117 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i111111111117 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111115 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111116 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111117 & 57344) | (i111111111117 & 458752) | (3670016 & i111111111115) | (29360128 & i111111111115) | (i111111111116 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical1117;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i111111111118 = i3 >> 3;
                        int i111111111119 = i3 << 6;
                        Arrangement.Vertical vertical1118 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1111111111110 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111118 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111119 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111110 & 57344) | (i1111111111110 & 458752) | (3670016 & i111111111118) | (29360128 & i111111111118) | (i111111111119 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical1118;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier19 = companion;
                        final PaddingValues paddingValues110 = paddingValuesM1028PaddingValues0680j_4;
                        final float f111 = f3;
                        final FlingBehavior flingBehavior110 = flingBehavior2;
                        final boolean z114 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111111111111) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier19, lazyStaggeredGridState2, paddingValues110, z5, vertical3, f111, flingBehavior110, z114, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 196608;
                vertical2 = vertical;
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i1111111111111 = i3 >> 3;
                        int i1111111111112 = i3 << 6;
                        Arrangement.Vertical vertical1119 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1111111111113 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111112 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111113 & 57344) | (i1111111111113 & 458752) | (3670016 & i1111111111111) | (29360128 & i1111111111111) | (i1111111111112 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical1119;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i1111111111114 = i3 >> 3;
                        int i1111111111115 = i3 << 6;
                        Arrangement.Vertical vertical11110 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1111111111116 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111114 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111115 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111116 & 57344) | (i1111111111116 & 458752) | (3670016 & i1111111111114) | (29360128 & i1111111111114) | (i1111111111115 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical11110;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier110 = companion;
                        final PaddingValues paddingValues111 = paddingValuesM1028PaddingValues0680j_4;
                        final float f112 = f3;
                        final FlingBehavior flingBehavior111 = flingBehavior2;
                        final boolean z115 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1111111111117) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier110, lazyStaggeredGridState2, paddingValues111, z5, vertical3, f112, flingBehavior111, z115, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i1111111111117 = i3 >> 3;
                    int i1111111111118 = i3 << 6;
                    Arrangement.Vertical vertical11111 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111111119 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111117 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111118 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111119 & 57344) | (i1111111111119 & 458752) | (3670016 & i1111111111117) | (29360128 & i1111111111117) | (i1111111111118 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical11111;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111111111110 = i3 >> 3;
                    int i11111111111111 = i3 << 6;
                    Arrangement.Vertical vertical11112 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i11111111111112 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111110 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111112 & 57344) | (i11111111111112 & 458752) | (3670016 & i11111111111110) | (29360128 & i11111111111110) | (i11111111111111 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical11112;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier111 = companion;
                    final PaddingValues paddingValues112 = paddingValuesM1028PaddingValues0680j_4;
                    final float f113 = f3;
                    final FlingBehavior flingBehavior112 = flingBehavior2;
                    final boolean z116 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111111113) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier111, lazyStaggeredGridState2, paddingValues112, z5, vertical3, f113, flingBehavior112, z116, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11111111111113 = i3 >> 3;
                        int i11111111111114 = i3 << 6;
                        Arrangement.Vertical vertical11113 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11111111111115 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111113 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111114 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111115 & 57344) | (i11111111111115 & 458752) | (3670016 & i11111111111113) | (29360128 & i11111111111113) | (i11111111111114 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical11113;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11111111111116 = i3 >> 3;
                        int i11111111111117 = i3 << 6;
                        Arrangement.Vertical vertical11114 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11111111111118 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111116 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111117 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111118 & 57344) | (i11111111111118 & 458752) | (3670016 & i11111111111116) | (29360128 & i11111111111116) | (i11111111111117 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical11114;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier112 = companion;
                        final PaddingValues paddingValues113 = paddingValuesM1028PaddingValues0680j_4;
                        final float f114 = f3;
                        final FlingBehavior flingBehavior113 = flingBehavior2;
                        final boolean z117 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111111111119) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier112, lazyStaggeredGridState2, paddingValues113, z5, vertical3, f114, flingBehavior113, z117, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111111111119 = i3 >> 3;
                    int i111111111111110 = i3 << 6;
                    Arrangement.Vertical vertical11115 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111111111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111119 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111 & 57344) | (i111111111111111 & 458752) | (3670016 & i11111111111119) | (29360128 & i11111111111119) | (i111111111111110 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical11115;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111111111111112 = i3 >> 3;
                    int i111111111111113 = i3 << 6;
                    Arrangement.Vertical vertical11116 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111111111114 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111113 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111114 & 57344) | (i111111111111114 & 458752) | (3670016 & i111111111111112) | (29360128 & i111111111111112) | (i111111111111113 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical11116;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier113 = companion;
                    final PaddingValues paddingValues114 = paddingValuesM1028PaddingValues0680j_4;
                    final float f115 = f3;
                    final FlingBehavior flingBehavior114 = flingBehavior2;
                    final boolean z118 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111111111111115) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier113, lazyStaggeredGridState2, paddingValues114, z5, vertical3, f115, flingBehavior114, z118, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            vertical2 = vertical;
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111111111111115 = i3 >> 3;
                    int i111111111111116 = i3 << 6;
                    Arrangement.Vertical vertical11117 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111111111117 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111115 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111116 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111117 & 57344) | (i111111111111117 & 458752) | (3670016 & i111111111111115) | (29360128 & i111111111111115) | (i111111111111116 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical11117;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111111111111118 = i3 >> 3;
                    int i111111111111119 = i3 << 6;
                    Arrangement.Vertical vertical11118 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111111111110 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111118 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111119 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111110 & 57344) | (i1111111111111110 & 458752) | (3670016 & i111111111111118) | (29360128 & i111111111111118) | (i111111111111119 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical11118;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier114 = companion;
                    final PaddingValues paddingValues115 = paddingValuesM1028PaddingValues0680j_4;
                    final float f116 = f3;
                    final FlingBehavior flingBehavior115 = flingBehavior2;
                    final boolean z119 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111111111111111) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier114, lazyStaggeredGridState2, paddingValues115, z5, vertical3, f116, flingBehavior115, z119, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i1111111111111111 = i3 >> 3;
                int i1111111111111112 = i3 << 6;
                Arrangement.Vertical vertical11119 = horizontalOrVerticalM911spacedBy0680j_4;
                int i1111111111111113 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111111 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111111112 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111113 & 57344) | (i1111111111111113 & 458752) | (3670016 & i1111111111111111) | (29360128 & i1111111111111111) | (i1111111111111112 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical11119;
                z6 = z4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i1111111111111114 = i3 >> 3;
                int i1111111111111115 = i3 << 6;
                Arrangement.Vertical vertical111110 = horizontalOrVerticalM911spacedBy0680j_4;
                int i1111111111111116 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111114 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111111115 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111116 & 57344) | (i1111111111111116 & 458752) | (3670016 & i1111111111111114) | (29360128 & i1111111111111114) | (i1111111111111115 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical111110;
                z6 = z4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier115 = companion;
                final PaddingValues paddingValues116 = paddingValuesM1028PaddingValues0680j_4;
                final float f117 = f3;
                final FlingBehavior flingBehavior116 = flingBehavior2;
                final boolean z1110 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111111111117) {
                        LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier115, lazyStaggeredGridState2, paddingValues116, z5, vertical3, f117, flingBehavior116, z1110, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 3072;
        paddingValues2 = paddingValues;
        i6 = i2 & 16;
        if (i6 != 0) {
            if ((i & 24576) == 0) {
                z3 = z;
                if (composerStartRestartGroup.changed(z3)) {
                    i7 = Fields.Clip;
                } else {
                    i7 = Fields.Shape;
                }
                i3 |= i7;
            }
            i8 = i2 & 32;
            if (i8 != 0) {
                if ((196608 & i) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i9 = Fields.RenderEffect;
                    } else {
                        i9 = 65536;
                    }
                    i3 |= i9;
                }
                i10 = i2 & 64;
                if (i10 != 0) {
                    i3 |= 1572864;
                } else if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(f)) {
                        i11 = 1048576;
                    } else {
                        i11 = 524288;
                    }
                    i3 |= i11;
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i12 = i2 & Fields.RotationX;
                if (i12 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i13 = 67108864;
                    } else {
                        i13 = 33554432;
                    }
                    i3 |= i13;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i14 = 536870912;
                        } else {
                            i14 = 268435456;
                        }
                        i3 |= i14;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i1111111111111117 = i3 >> 3;
                        int i1111111111111118 = i3 << 6;
                        Arrangement.Vertical vertical111111 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i1111111111111119 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111117 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111111118 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111119 & 57344) | (i1111111111111119 & 458752) | (3670016 & i1111111111111117) | (29360128 & i1111111111111117) | (i1111111111111118 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical111111;
                        z6 = z4;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        } else {
                            if (i15 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 != 0) {
                                z3 = false;
                            }
                            if (i8 != 0) {
                                horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                            } else {
                                horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                            }
                            if (i10 != 0) {
                                f2 = Dp.constructor-impl(0);
                            } else {
                                f2 = f;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i12 != 0) {
                                z4 = true;
                            } else {
                                z4 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                        }
                        int i11111111111111110 = i3 >> 3;
                        int i11111111111111111 = i3 << 6;
                        Arrangement.Vertical vertical111112 = horizontalOrVerticalM911spacedBy0680j_4;
                        int i11111111111111112 = i3 << 3;
                        LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111110 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111111 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111112 & 57344) | (i11111111111111112 & 458752) | (3670016 & i11111111111111110) | (29360128 & i11111111111111110) | (i11111111111111111 & 234881024), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                        f3 = f2;
                        z5 = z3;
                        vertical3 = vertical111112;
                        z6 = z4;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier116 = companion;
                        final PaddingValues paddingValues117 = paddingValuesM1028PaddingValues0680j_4;
                        final float f118 = f3;
                        final FlingBehavior flingBehavior117 = flingBehavior2;
                        final boolean z1111 = z6;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11111111111111113) {
                                LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier116, lazyStaggeredGridState2, paddingValues117, z5, vertical3, f118, flingBehavior117, z1111, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111111111111113 = i3 >> 3;
                    int i11111111111111114 = i3 << 6;
                    Arrangement.Vertical vertical111113 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i11111111111111115 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111113 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111114 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111115 & 57344) | (i11111111111111115 & 458752) | (3670016 & i11111111111111113) | (29360128 & i11111111111111113) | (i11111111111111114 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical111113;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111111111111116 = i3 >> 3;
                    int i11111111111111117 = i3 << 6;
                    Arrangement.Vertical vertical111114 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i11111111111111118 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111116 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111117 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111118 & 57344) | (i11111111111111118 & 458752) | (3670016 & i11111111111111116) | (29360128 & i11111111111111116) | (i11111111111111117 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical111114;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier117 = companion;
                    final PaddingValues paddingValues118 = paddingValuesM1028PaddingValues0680j_4;
                    final float f119 = f3;
                    final FlingBehavior flingBehavior118 = flingBehavior2;
                    final boolean z1112 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111111111111119) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier117, lazyStaggeredGridState2, paddingValues118, z5, vertical3, f119, flingBehavior118, z1112, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 196608;
            vertical2 = vertical;
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i11111111111111119 = i3 >> 3;
                    int i111111111111111110 = i3 << 6;
                    Arrangement.Vertical vertical111115 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111111111111111 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111119 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111111110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111111 & 57344) | (i111111111111111111 & 458752) | (3670016 & i11111111111111119) | (29360128 & i11111111111111119) | (i111111111111111110 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical111115;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i111111111111111112 = i3 >> 3;
                    int i111111111111111113 = i3 << 6;
                    Arrangement.Vertical vertical111116 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i111111111111111114 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111111112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111111113 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111114 & 57344) | (i111111111111111114 & 458752) | (3670016 & i111111111111111112) | (29360128 & i111111111111111112) | (i111111111111111113 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical111116;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier118 = companion;
                    final PaddingValues paddingValues119 = paddingValuesM1028PaddingValues0680j_4;
                    final float f1110 = f3;
                    final FlingBehavior flingBehavior119 = flingBehavior2;
                    final boolean z1113 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111111111111111115) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier118, lazyStaggeredGridState2, paddingValues119, z5, vertical3, f1110, flingBehavior119, z1113, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i111111111111111115 = i3 >> 3;
                int i111111111111111116 = i3 << 6;
                Arrangement.Vertical vertical111117 = horizontalOrVerticalM911spacedBy0680j_4;
                int i111111111111111117 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111111115 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111111116 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111117 & 57344) | (i111111111111111117 & 458752) | (3670016 & i111111111111111115) | (29360128 & i111111111111111115) | (i111111111111111116 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical111117;
                z6 = z4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i111111111111111118 = i3 >> 3;
                int i111111111111111119 = i3 << 6;
                Arrangement.Vertical vertical111118 = horizontalOrVerticalM911spacedBy0680j_4;
                int i1111111111111111110 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111111118 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111111119 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111111110 & 57344) | (i1111111111111111110 & 458752) | (3670016 & i111111111111111118) | (29360128 & i111111111111111118) | (i111111111111111119 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical111118;
                z6 = z4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier119 = companion;
                final PaddingValues paddingValues1110 = paddingValuesM1028PaddingValues0680j_4;
                final float f1111 = f3;
                final FlingBehavior flingBehavior1110 = flingBehavior2;
                final boolean z1114 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111111111111111) {
                        LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier119, lazyStaggeredGridState2, paddingValues1110, z5, vertical3, f1111, flingBehavior1110, z1114, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        z3 = z;
        i8 = i2 & 32;
        if (i8 != 0) {
            if ((196608 & i) == 0) {
                vertical2 = vertical;
                if (composerStartRestartGroup.changed(vertical2)) {
                    i9 = Fields.RenderEffect;
                } else {
                    i9 = 65536;
                }
                i3 |= i9;
            }
            i10 = i2 & 64;
            if (i10 != 0) {
                i3 |= 1572864;
            } else if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(f)) {
                    i11 = 1048576;
                } else {
                    i11 = 524288;
                }
                i3 |= i11;
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i12 = i2 & Fields.RotationX;
            if (i12 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i13 = 67108864;
                } else {
                    i13 = 33554432;
                }
                i3 |= i13;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i14 = 536870912;
                    } else {
                        i14 = 268435456;
                    }
                    i3 |= i14;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i1111111111111111111 = i3 >> 3;
                    int i1111111111111111112 = i3 << 6;
                    Arrangement.Vertical vertical111119 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111111111111113 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111111111 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111111111112 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111111113 & 57344) | (i1111111111111111113 & 458752) | (3670016 & i1111111111111111111) | (29360128 & i1111111111111111111) | (i1111111111111111112 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical111119;
                    z6 = z4;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    } else {
                        if (i15 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 != 0) {
                            z3 = false;
                        }
                        if (i8 != 0) {
                            horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                        } else {
                            horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                        }
                        if (i10 != 0) {
                            f2 = Dp.constructor-impl(0);
                        } else {
                            f2 = f;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i12 != 0) {
                            z4 = true;
                        } else {
                            z4 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                    }
                    int i1111111111111111114 = i3 >> 3;
                    int i1111111111111111115 = i3 << 6;
                    Arrangement.Vertical vertical1111110 = horizontalOrVerticalM911spacedBy0680j_4;
                    int i1111111111111111116 = i3 << 3;
                    LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111111114 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111111111115 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111111116 & 57344) | (i1111111111111111116 & 458752) | (3670016 & i1111111111111111114) | (29360128 & i1111111111111111114) | (i1111111111111111115 & 234881024), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                    f3 = f2;
                    z5 = z3;
                    vertical3 = vertical1111110;
                    z6 = z4;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier1110 = companion;
                    final PaddingValues paddingValues1111 = paddingValuesM1028PaddingValues0680j_4;
                    final float f1112 = f3;
                    final FlingBehavior flingBehavior1111 = flingBehavior2;
                    final boolean z1115 = z6;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111111111111111117) {
                            LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier1110, lazyStaggeredGridState2, paddingValues1111, z5, vertical3, f1112, flingBehavior1111, z1115, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i1111111111111111117 = i3 >> 3;
                int i1111111111111111118 = i3 << 6;
                Arrangement.Vertical vertical1111111 = horizontalOrVerticalM911spacedBy0680j_4;
                int i1111111111111111119 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i1111111111111111117 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i1111111111111111118 & 7168) | ((i3 >> 6) & 14) | 48 | (i1111111111111111119 & 57344) | (i1111111111111111119 & 458752) | (3670016 & i1111111111111111117) | (29360128 & i1111111111111111117) | (i1111111111111111118 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical1111111;
                z6 = z4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i11111111111111111110 = i3 >> 3;
                int i11111111111111111111 = i3 << 6;
                Arrangement.Vertical vertical1111112 = horizontalOrVerticalM911spacedBy0680j_4;
                int i11111111111111111112 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111111110 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111111111 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111111112 & 57344) | (i11111111111111111112 & 458752) | (3670016 & i11111111111111111110) | (29360128 & i11111111111111111110) | (i11111111111111111111 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical1111112;
                z6 = z4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1111 = companion;
                final PaddingValues paddingValues1112 = paddingValuesM1028PaddingValues0680j_4;
                final float f1113 = f3;
                final FlingBehavior flingBehavior1112 = flingBehavior2;
                final boolean z1116 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111111111111113) {
                        LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier1111, lazyStaggeredGridState2, paddingValues1112, z5, vertical3, f1113, flingBehavior1112, z1116, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 196608;
        vertical2 = vertical;
        i10 = i2 & 64;
        if (i10 != 0) {
            i3 |= 1572864;
        } else if ((i & 1572864) == 0) {
            if (composerStartRestartGroup.changed(f)) {
                i11 = 1048576;
            } else {
                i11 = 524288;
            }
            i3 |= i11;
        }
        if ((i & 12582912) != 0) {
            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
        }
        i12 = i2 & Fields.RotationX;
        if (i12 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i13 = 67108864;
            } else {
                i13 = 33554432;
            }
            i3 |= i13;
        }
        if ((i2 & Fields.RotationY) != 0) {
            if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i14 = 536870912;
                } else {
                    i14 = 268435456;
                }
                i3 |= i14;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i11111111111111111113 = i3 >> 3;
                int i11111111111111111114 = i3 << 6;
                Arrangement.Vertical vertical1111113 = horizontalOrVerticalM911spacedBy0680j_4;
                int i11111111111111111115 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111111113 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111111114 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111111115 & 57344) | (i11111111111111111115 & 458752) | (3670016 & i11111111111111111113) | (29360128 & i11111111111111111113) | (i11111111111111111114 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical1111113;
                z6 = z4;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                } else {
                    if (i15 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 != 0) {
                        z3 = false;
                    }
                    if (i8 != 0) {
                        horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                    } else {
                        horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                    }
                    if (i10 != 0) {
                        f2 = Dp.constructor-impl(0);
                    } else {
                        f2 = f;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i12 != 0) {
                        z4 = true;
                    } else {
                        z4 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
                }
                int i11111111111111111116 = i3 >> 3;
                int i11111111111111111117 = i3 << 6;
                Arrangement.Vertical vertical1111114 = horizontalOrVerticalM911spacedBy0680j_4;
                int i11111111111111111118 = i3 << 3;
                LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111111116 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i11111111111111111117 & 7168) | ((i3 >> 6) & 14) | 48 | (i11111111111111111118 & 57344) | (i11111111111111111118 & 458752) | (3670016 & i11111111111111111116) | (29360128 & i11111111111111111116) | (i11111111111111111117 & 234881024), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
                f3 = f2;
                z5 = z3;
                vertical3 = vertical1111114;
                z6 = z4;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier1112 = companion;
                final PaddingValues paddingValues1113 = paddingValuesM1028PaddingValues0680j_4;
                final float f1114 = f3;
                final FlingBehavior flingBehavior1113 = flingBehavior2;
                final boolean z1117 = z6;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111111111111111119) {
                        LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier1112, lazyStaggeredGridState2, paddingValues1113, z5, vertical3, f1114, flingBehavior1113, z1117, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 805306368;
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                }
                if (i10 != 0) {
                    f2 = Dp.constructor-impl(0);
                } else {
                    f2 = f;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            } else {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                }
                if (i10 != 0) {
                    f2 = Dp.constructor-impl(0);
                } else {
                    f2 = f;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
            }
            int i11111111111111111119 = i3 >> 3;
            int i111111111111111111110 = i3 << 6;
            Arrangement.Vertical vertical1111115 = horizontalOrVerticalM911spacedBy0680j_4;
            int i111111111111111111111 = i3 << 3;
            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i11111111111111111119 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111111111110 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111111111 & 57344) | (i111111111111111111111 & 458752) | (3670016 & i11111111111111111119) | (29360128 & i11111111111111111119) | (i111111111111111111110 & 234881024), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
            f3 = f2;
            z5 = z3;
            vertical3 = vertical1111115;
            z6 = z4;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                }
                if (i10 != 0) {
                    f2 = Dp.constructor-impl(0);
                } else {
                    f2 = f;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            } else {
                if (i15 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = LazyStaggeredGridStateKt.rememberLazyStaggeredGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyStaggeredGridStateRememberLazyStaggeredGridState = lazyStaggeredGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 != 0) {
                    z3 = false;
                }
                if (i8 != 0) {
                    horizontalOrVerticalM911spacedBy0680j_4 = Arrangement.INSTANCE.m911spacedBy0680j_4(Dp.constructor-impl(0));
                } else {
                    horizontalOrVerticalM911spacedBy0680j_4 = vertical2;
                }
                if (i10 != 0) {
                    f2 = Dp.constructor-impl(0);
                } else {
                    f2 = f;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i12 != 0) {
                    z4 = true;
                } else {
                    z4 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-8666074, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.LazyHorizontalStaggeredGrid (LazyStaggeredGridDsl.kt:162)");
            }
            int i111111111111111111112 = i3 >> 3;
            int i111111111111111111113 = i3 << 6;
            Arrangement.Vertical vertical1111116 = horizontalOrVerticalM911spacedBy0680j_4;
            int i111111111111111111114 = i3 << 3;
            LazyStaggeredGridKt.m1282LazyStaggeredGridLJWHXA8(lazyStaggeredGridStateRememberLazyStaggeredGridState, Orientation.Horizontal, rememberRowSlots(staggeredGridCells, horizontalOrVerticalM911spacedBy0680j_4, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i111111111111111111112 & 896) | (i3 & 14) | ((i3 >> 12) & 112)), companion, paddingValuesM1028PaddingValues0680j_4, z3, flingBehavior2, z4, f2, horizontalOrVerticalM911spacedBy0680j_4.getSpacing(), function1, composerStartRestartGroup, (i111111111111111111113 & 7168) | ((i3 >> 6) & 14) | 48 | (i111111111111111111114 & 57344) | (i111111111111111111114 & 458752) | (3670016 & i111111111111111111112) | (29360128 & i111111111111111111112) | (i111111111111111111113 & 234881024), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyStaggeredGridState2 = lazyStaggeredGridStateRememberLazyStaggeredGridState;
            f3 = f2;
            z5 = z3;
            vertical3 = vertical1111116;
            z6 = z4;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier1113 = companion;
            final PaddingValues paddingValues1114 = paddingValuesM1028PaddingValues0680j_4;
            final float f1115 = f3;
            final FlingBehavior flingBehavior1114 = flingBehavior2;
            final boolean z1118 = z6;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i111111111111111111115) {
                    LazyStaggeredGridDslKt.m1272LazyHorizontalStaggeredGridcJHQLPU(staggeredGridCells, modifier1113, lazyStaggeredGridState2, paddingValues1114, z5, vertical3, f1115, flingBehavior1114, z1118, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final LazyGridStaggeredGridSlotsProvider rememberRowSlots(final StaggeredGridCells staggeredGridCells, final Arrangement.Vertical vertical, final PaddingValues paddingValues, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1532383053, "C(rememberRowSlots)P(1,2)184@8120L940:LazyStaggeredGridDsl.kt#fzvcnm");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1532383053, i, -1, "androidx.compose.foundation.lazy.staggeredgrid.rememberRowSlots (LazyStaggeredGridDsl.kt:184)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 1011137904, "CC(remember):LazyStaggeredGridDsl.kt#9igjgp");
        boolean z = ((((i & 14) ^ 6) > 4 && composer.changed(staggeredGridCells)) || (i & 6) == 4) | ((((i & 112) ^ 48) > 32 && composer.changed(vertical)) || (i & 48) == 32) | ((((i & 896) ^ 384) > 256 && composer.changed(paddingValues)) || (i & 384) == 256);
        LazyStaggeredGridSlotCache lazyStaggeredGridSlotCacheRememberedValue = composer.rememberedValue();
        if (z || lazyStaggeredGridSlotCacheRememberedValue == Composer.INSTANCE.getEmpty()) {
            lazyStaggeredGridSlotCacheRememberedValue = new LazyStaggeredGridSlotCache(new Function2<Density, Constraints, LazyStaggeredGridSlots>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1277invoke0kLqBqw((Density) obj, ((Constraints) obj2).unbox-impl());
                }

                public final LazyStaggeredGridSlots m1277invoke0kLqBqw(Density density, long j) {
                    if (Constraints.getMaxHeight-impl(j) == Integer.MAX_VALUE) {
                        throw new IllegalArgumentException("LazyHorizontalStaggeredGrid's height should be bound by parent.".toString());
                    }
                    int i2 = Constraints.getMaxHeight-impl(j) - density.roundToPx-0680j_4(Dp.constructor-impl(paddingValues.getTop() + paddingValues.getBottom()));
                    StaggeredGridCells staggeredGridCells2 = staggeredGridCells;
                    Arrangement.Vertical vertical2 = vertical;
                    int[] iArrCalculateCrossAxisCellSizes = staggeredGridCells2.calculateCrossAxisCellSizes(density, i2, density.roundToPx-0680j_4(vertical2.getSpacing()));
                    int[] iArr = new int[iArrCalculateCrossAxisCellSizes.length];
                    vertical2.arrange(density, i2, iArrCalculateCrossAxisCellSizes, iArr);
                    return new LazyStaggeredGridSlots(iArr, iArrCalculateCrossAxisCellSizes);
                }
            });
            composer.updateRememberedValue(lazyStaggeredGridSlotCacheRememberedValue);
        }
        LazyGridStaggeredGridSlotsProvider lazyGridStaggeredGridSlotsProvider = (LazyGridStaggeredGridSlotsProvider) lazyStaggeredGridSlotCacheRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return lazyGridStaggeredGridSlotsProvider;
    }

    public static void items$default(LazyStaggeredGridScope lazyStaggeredGridScope, List list, Function1 function1, Function1 function2, Function1 function3, Function4 function4, int i, Object obj) {
        if ((i & 2) != 0) {
            function1 = null;
        }
        if ((i & 4) != 0) {
            function2 = new Function1() {
                public final Void invoke(T t) {
                    return null;
                }
            };
        }
        if ((i & 8) != 0) {
            function3 = null;
        }
        lazyStaggeredGridScope.items(list.size(), function1 != null ? new LazyStaggeredGridDslKt$items$2$1(function1, list) : null, new C07193(function2, list), function3 != null ? new LazyStaggeredGridDslKt$items$4$1(function3, list) : null, ComposableLambdaKt.composableLambdaInstance(-886456479, true, new C07205(function4, list)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C07193 extends Lambda implements Function1<Integer, Object> {
        final Function1<T, Object> $contentType;
        final List<T> $items;

        public C07193(Function1<? super T, ? extends Object> function1, List<? extends T> list) {
            super(1);
            this.$contentType = function1;
            this.$items = list;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$contentType.invoke(this.$items.get(i));
        }
    }

    public static final <T> void items(LazyStaggeredGridScope lazyStaggeredGridScope, List<? extends T> list, Function1<? super T, ? extends Object> function1, Function1<? super T, ? extends Object> function2, Function1<? super T, StaggeredGridItemSpan> function3, Function4<? super LazyStaggeredGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4) {
        lazyStaggeredGridScope.items(list.size(), function1 != null ? new LazyStaggeredGridDslKt$items$2$1(function1, list) : null, new C07193(function2, list), function3 != null ? new LazyStaggeredGridDslKt$items$4$1(function3, list) : null, ComposableLambdaKt.composableLambdaInstance(-886456479, true, new C07205(function4, list)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;", "index", "", "invoke", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C07205 extends Lambda implements Function4<LazyStaggeredGridItemScope, Integer, Composer, Integer, Unit> {
        final Function4<LazyStaggeredGridItemScope, T, Composer, Integer, Unit> $itemContent;
        final List<T> $items;

        public C07205(Function4<? super LazyStaggeredGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4, List<? extends T> list) {
            super(4);
            this.$itemContent = function4;
            this.$items = list;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyStaggeredGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyStaggeredGridItemScope lazyStaggeredGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C345@15356L25:LazyStaggeredGridDsl.kt#fzvcnm");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyStaggeredGridItemScope) ? 4 : 2) | i2;
            } else {
                i3 = i2;
            }
            if ((i2 & 48) == 0) {
                i3 |= composer.changed(i) ? 32 : 16;
            }
            if ((i3 & 147) == 146 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-886456479, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.items.<anonymous> (LazyStaggeredGridDsl.kt:345)");
            }
            this.$itemContent.invoke(lazyStaggeredGridItemScope, this.$items.get(i), composer, Integer.valueOf(i3 & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }

    public static void itemsIndexed$default(LazyStaggeredGridScope lazyStaggeredGridScope, List list, Function2 function2, Function2 function3, Function2 function4, Function5 function5, int i, Object obj) {
        if ((i & 2) != 0) {
            function2 = null;
        }
        if ((i & 4) != 0) {
            function3 = new Function2() {
                public final Void invoke(int i2, T t) {
                    return null;
                }

                public Object invoke(Object obj2, Object obj3) {
                    return invoke(((Number) obj2).intValue(), obj3);
                }
            };
        }
        if ((i & 8) != 0) {
            function4 = null;
        }
        lazyStaggeredGridScope.items(list.size(), function2 != null ? new LazyStaggeredGridDslKt$itemsIndexed$2$1(function2, list) : null, new C07253(function3, list), function4 != null ? new LazyStaggeredGridDslKt$itemsIndexed$4$1(function4, list) : null, ComposableLambdaKt.composableLambdaInstance(284833944, true, new C07265(function5, list)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C07253 extends Lambda implements Function1<Integer, Object> {
        final Function2<Integer, T, Object> $contentType;
        final List<T> $items;

        public C07253(Function2<? super Integer, ? super T, ? extends Object> function2, List<? extends T> list) {
            super(1);
            this.$contentType = function2;
            this.$items = list;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$contentType.invoke(Integer.valueOf(i), this.$items.get(i));
        }
    }

    public static final <T> void itemsIndexed(LazyStaggeredGridScope lazyStaggeredGridScope, List<? extends T> list, Function2<? super Integer, ? super T, ? extends Object> function2, Function2<? super Integer, ? super T, ? extends Object> function3, Function2<? super Integer, ? super T, StaggeredGridItemSpan> function4, Function5<? super LazyStaggeredGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5) {
        lazyStaggeredGridScope.items(list.size(), function2 != null ? new LazyStaggeredGridDslKt$itemsIndexed$2$1(function2, list) : null, new C07253(function3, list), function4 != null ? new LazyStaggeredGridDslKt$itemsIndexed$4$1(function4, list) : null, ComposableLambdaKt.composableLambdaInstance(284833944, true, new C07265(function5, list)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;", "index", "", "invoke", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C07265 extends Lambda implements Function4<LazyStaggeredGridItemScope, Integer, Composer, Integer, Unit> {
        final Function5<LazyStaggeredGridItemScope, Integer, T, Composer, Integer, Unit> $itemContent;
        final List<T> $items;

        public C07265(Function5<? super LazyStaggeredGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5, List<? extends T> list) {
            super(4);
            this.$itemContent = function5;
            this.$items = list;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyStaggeredGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyStaggeredGridItemScope lazyStaggeredGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C385@17315L32:LazyStaggeredGridDsl.kt#fzvcnm");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyStaggeredGridItemScope) ? 4 : 2) | i2;
            } else {
                i3 = i2;
            }
            if ((i2 & 48) == 0) {
                i3 |= composer.changed(i) ? 32 : 16;
            }
            if ((i3 & 147) == 146 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(284833944, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.itemsIndexed.<anonymous> (LazyStaggeredGridDsl.kt:385)");
            }
            this.$itemContent.invoke(lazyStaggeredGridItemScope, Integer.valueOf(i), this.$items.get(i), composer, Integer.valueOf(i3 & 126));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }

    public static void items$default(LazyStaggeredGridScope lazyStaggeredGridScope, Object[] objArr, Function1 function1, Function1 function2, Function1 function3, Function4 function4, int i, Object obj) {
        if ((i & 2) != 0) {
            function1 = null;
        }
        if ((i & 4) != 0) {
            function2 = new Function1() {
                public final Void invoke(T t) {
                    return null;
                }
            };
        }
        if ((i & 8) != 0) {
            function3 = null;
        }
        lazyStaggeredGridScope.items(objArr.length, function1 != null ? new LazyStaggeredGridDslKt$items$7$1(function1, objArr) : null, new C07228(function2, objArr), function3 != null ? new LazyStaggeredGridDslKt$items$9$1(function3, objArr) : null, ComposableLambdaKt.composableLambdaInstance(2101296000, true, new C071810(function4, objArr)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C07228 extends Lambda implements Function1<Integer, Object> {
        final Function1<T, Object> $contentType;
        final T[] $items;

        public C07228(Function1<? super T, ? extends Object> function1, T[] tArr) {
            super(1);
            this.$contentType = function1;
            this.$items = tArr;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$contentType.invoke(this.$items[i]);
        }
    }

    public static final <T> void items(LazyStaggeredGridScope lazyStaggeredGridScope, T[] tArr, Function1<? super T, ? extends Object> function1, Function1<? super T, ? extends Object> function2, Function1<? super T, StaggeredGridItemSpan> function3, Function4<? super LazyStaggeredGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4) {
        lazyStaggeredGridScope.items(tArr.length, function1 != null ? new LazyStaggeredGridDslKt$items$7$1(function1, tArr) : null, new C07228(function2, tArr), function3 != null ? new LazyStaggeredGridDslKt$items$9$1(function3, tArr) : null, ComposableLambdaKt.composableLambdaInstance(2101296000, true, new C071810(function4, tArr)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;", "index", "", "invoke", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C071810 extends Lambda implements Function4<LazyStaggeredGridItemScope, Integer, Composer, Integer, Unit> {
        final Function4<LazyStaggeredGridItemScope, T, Composer, Integer, Unit> $itemContent;
        final T[] $items;

        public C071810(Function4<? super LazyStaggeredGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4, T[] tArr) {
            super(4);
            this.$itemContent = function4;
            this.$items = tArr;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyStaggeredGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyStaggeredGridItemScope lazyStaggeredGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C425@19176L25:LazyStaggeredGridDsl.kt#fzvcnm");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyStaggeredGridItemScope) ? 4 : 2) | i2;
            } else {
                i3 = i2;
            }
            if ((i2 & 48) == 0) {
                i3 |= composer.changed(i) ? 32 : 16;
            }
            if ((i3 & 147) == 146 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2101296000, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.items.<anonymous> (LazyStaggeredGridDsl.kt:425)");
            }
            this.$itemContent.invoke(lazyStaggeredGridItemScope, this.$items[i], composer, Integer.valueOf(i3 & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }

    public static void itemsIndexed$default(LazyStaggeredGridScope lazyStaggeredGridScope, Object[] objArr, Function2 function2, Function2 function3, Function2 function4, Function5 function5, int i, Object obj) {
        if ((i & 2) != 0) {
            function2 = null;
        }
        if ((i & 4) != 0) {
            function3 = new Function2() {
                public final Void invoke(int i2, T t) {
                    return null;
                }

                public Object invoke(Object obj2, Object obj3) {
                    return invoke(((Number) obj2).intValue(), obj3);
                }
            };
        }
        if ((i & 8) != 0) {
            function4 = null;
        }
        lazyStaggeredGridScope.items(objArr.length, function2 != null ? new LazyStaggeredGridDslKt$itemsIndexed$7$1(function2, objArr) : null, new C07288(function3, objArr), function4 != null ? new LazyStaggeredGridDslKt$itemsIndexed$9$1(function4, objArr) : null, ComposableLambdaKt.composableLambdaInstance(-804487775, true, new C072410(function5, objArr)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C07288 extends Lambda implements Function1<Integer, Object> {
        final Function2<Integer, T, Object> $contentType;
        final T[] $items;

        public C07288(Function2<? super Integer, ? super T, ? extends Object> function2, T[] tArr) {
            super(1);
            this.$contentType = function2;
            this.$items = tArr;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$contentType.invoke(Integer.valueOf(i), this.$items[i]);
        }
    }

    public static final <T> void itemsIndexed(LazyStaggeredGridScope lazyStaggeredGridScope, T[] tArr, Function2<? super Integer, ? super T, ? extends Object> function2, Function2<? super Integer, ? super T, ? extends Object> function3, Function2<? super Integer, ? super T, StaggeredGridItemSpan> function4, Function5<? super LazyStaggeredGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5) {
        lazyStaggeredGridScope.items(tArr.length, function2 != null ? new LazyStaggeredGridDslKt$itemsIndexed$7$1(function2, tArr) : null, new C07288(function3, tArr), function4 != null ? new LazyStaggeredGridDslKt$itemsIndexed$9$1(function4, tArr) : null, ComposableLambdaKt.composableLambdaInstance(-804487775, true, new C072410(function5, tArr)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;", "index", "", "invoke", "(Landroidx/compose/foundation/lazy/staggeredgrid/LazyStaggeredGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C072410 extends Lambda implements Function4<LazyStaggeredGridItemScope, Integer, Composer, Integer, Unit> {
        final Function5<LazyStaggeredGridItemScope, Integer, T, Composer, Integer, Unit> $itemContent;
        final T[] $items;

        public C072410(Function5<? super LazyStaggeredGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5, T[] tArr) {
            super(4);
            this.$itemContent = function5;
            this.$items = tArr;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyStaggeredGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyStaggeredGridItemScope lazyStaggeredGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C465@21139L32:LazyStaggeredGridDsl.kt#fzvcnm");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyStaggeredGridItemScope) ? 4 : 2) | i2;
            } else {
                i3 = i2;
            }
            if ((i2 & 48) == 0) {
                i3 |= composer.changed(i) ? 32 : 16;
            }
            if ((i3 & 147) == 146 && composer.getSkipping()) {
                composer.skipToGroupEnd();
                return;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-804487775, i3, -1, "androidx.compose.foundation.lazy.staggeredgrid.itemsIndexed.<anonymous> (LazyStaggeredGridDsl.kt:465)");
            }
            this.$itemContent.invoke(lazyStaggeredGridItemScope, Integer.valueOf(i), this.$items[i], composer, Integer.valueOf(i3 & 126));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }
}
