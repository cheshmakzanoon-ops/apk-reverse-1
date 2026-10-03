package androidx.compose.foundation.lazy.grid;

import androidx.autofill.HintConstants;
import androidx.compose.foundation.gestures.FlingBehavior;
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
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.functions.Function5;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\u0096\u0001\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010 \n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0011\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a~\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u000b2\u0017\u0010\u0013\u001a\u0013\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00010\u0014¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u0017\u001a~\u0010\u0018\u001a\u00020\u00012\u0006\u0010\u0019\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\b\b\u0002\u0010\u0012\u001a\u00020\u000b2\u0017\u0010\u0013\u001a\u0013\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00010\u0014¢\u0006\u0002\b\u0016H\u0007¢\u0006\u0002\u0010\u001a\u001a&\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u001d0\u001c2\u0006\u0010\u001e\u001a\u00020\u001d2\u0006\u0010\u001f\u001a\u00020\u001d2\u0006\u0010 \u001a\u00020\u001dH\u0002\u001a%\u0010!\u001a\u00020\"2\u0006\u0010\u0019\u001a\u00020\u00032\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\b\u001a\u00020\tH\u0003¢\u0006\u0002\u0010#\u001a%\u0010$\u001a\u00020\"2\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\b\u001a\u00020\tH\u0003¢\u0006\u0002\u0010%\u001aÛ\u0001\u0010&\u001a\u00020\u0001\"\u0004\b\u0000\u0010'*\u00020\u00152\f\u0010&\u001a\b\u0012\u0004\u0012\u0002H'0(2%\b\n\u0010)\u001a\u001f\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020-\u0018\u00010\u001420\b\n\u0010.\u001a*\u0012\u0004\u0012\u000200\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u000201\u0018\u00010/¢\u0006\u0002\b\u00162%\b\n\u00102\u001a\u001f\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0006\u0012\u0004\u0018\u00010-0\u001423\b\u0004\u00103\u001a-\u0012\u0004\u0012\u000204\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020\u00010/¢\u0006\u0002\b5¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u00106\u001aÛ\u0001\u0010&\u001a\u00020\u0001\"\u0004\b\u0000\u0010'*\u00020\u00152\f\u0010&\u001a\b\u0012\u0004\u0012\u0002H'0\u001c2%\b\n\u0010)\u001a\u001f\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020-\u0018\u00010\u001420\b\n\u0010.\u001a*\u0012\u0004\u0012\u000200\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u000201\u0018\u00010/¢\u0006\u0002\b\u00162%\b\n\u00102\u001a\u001f\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0006\u0012\u0004\u0018\u00010-0\u001423\b\u0004\u00103\u001a-\u0012\u0004\u0012\u000204\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020\u00010/¢\u0006\u0002\b5¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u00107\u001a¯\u0002\u00108\u001a\u00020\u0001\"\u0004\b\u0000\u0010'*\u00020\u00152\f\u0010&\u001a\b\u0012\u0004\u0012\u0002H'0(2:\b\n\u0010)\u001a4\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020-\u0018\u00010/2E\b\n\u0010.\u001a?\u0012\u0004\u0012\u000200\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u000201\u0018\u00010:¢\u0006\u0002\b\u00162:\b\u0006\u00102\u001a4\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0006\u0012\u0004\u0018\u00010-0/2H\b\u0004\u00103\u001aB\u0012\u0004\u0012\u000204\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020\u00010:¢\u0006\u0002\b5¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u0010;\u001a¯\u0002\u00108\u001a\u00020\u0001\"\u0004\b\u0000\u0010'*\u00020\u00152\f\u0010&\u001a\b\u0012\u0004\u0012\u0002H'0\u001c2:\b\n\u0010)\u001a4\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020-\u0018\u00010/2E\b\n\u0010.\u001a?\u0012\u0004\u0012\u000200\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u000201\u0018\u00010:¢\u0006\u0002\b\u00162:\b\u0006\u00102\u001a4\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0006\u0012\u0004\u0018\u00010-0/2H\b\u0004\u00103\u001aB\u0012\u0004\u0012\u000204\u0012\u0013\u0012\u00110\u001d¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(9\u0012\u0013\u0012\u0011H'¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020\u00010:¢\u0006\u0002\b5¢\u0006\u0002\b\u0016H\u0086\b¢\u0006\u0002\u0010<¨\u0006="}, d2 = {"LazyHorizontalGrid", "", "rows", "Landroidx/compose/foundation/lazy/grid/GridCells;", "modifier", "Landroidx/compose/ui/Modifier;", "state", "Landroidx/compose/foundation/lazy/grid/LazyGridState;", "contentPadding", "Landroidx/compose/foundation/layout/PaddingValues;", "reverseLayout", "", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "flingBehavior", "Landroidx/compose/foundation/gestures/FlingBehavior;", "userScrollEnabled", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/lazy/grid/LazyGridScope;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/lazy/grid/GridCells;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/grid/LazyGridState;Landroidx/compose/foundation/layout/PaddingValues;ZLandroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/gestures/FlingBehavior;ZLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "LazyVerticalGrid", "columns", "(Landroidx/compose/foundation/lazy/grid/GridCells;Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/lazy/grid/LazyGridState;Landroidx/compose/foundation/layout/PaddingValues;ZLandroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/gestures/FlingBehavior;ZLkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;II)V", "calculateCellsCrossAxisSizeImpl", "", "", "gridSize", "slotCount", "spacing", "rememberColumnWidthSums", "Landroidx/compose/foundation/lazy/grid/LazyGridSlotsProvider;", "(Landroidx/compose/foundation/lazy/grid/GridCells;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/PaddingValues;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/lazy/grid/LazyGridSlotsProvider;", "rememberRowHeightSums", "(Landroidx/compose/foundation/lazy/grid/GridCells;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/PaddingValues;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/lazy/grid/LazyGridSlotsProvider;", "items", "T", "", "key", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "item", "", "span", "Lkotlin/Function2;", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "contentType", "itemContent", "Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;", "Landroidx/compose/runtime/Composable;", "(Landroidx/compose/foundation/lazy/grid/LazyGridScope;[Ljava/lang/Object;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function4;)V", "(Landroidx/compose/foundation/lazy/grid/LazyGridScope;Ljava/util/List;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function4;)V", "itemsIndexed", "index", "Lkotlin/Function3;", "(Landroidx/compose/foundation/lazy/grid/LazyGridScope;[Ljava/lang/Object;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function5;)V", "(Landroidx/compose/foundation/lazy/grid/LazyGridScope;Ljava/util/List;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function2;Lkotlin/jvm/functions/Function5;)V", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LazyGridDslKt {
    public static final void LazyVerticalGrid(final GridCells gridCells, Modifier modifier, LazyGridState lazyGridState, PaddingValues paddingValues, boolean z, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, FlingBehavior flingBehavior, boolean z2, final Function1<? super LazyGridScope, Unit> function1, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        PaddingValues paddingValues2;
        int i5;
        int i6;
        boolean z3;
        int i7;
        Arrangement.Vertical vertical2;
        int i8;
        Arrangement.Horizontal horizontal2;
        int i9;
        int i10;
        int i11;
        int i12;
        Modifier.Companion companion;
        LazyGridState lazyGridStateRememberLazyGridState;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        boolean z4;
        Arrangement.Vertical bottom;
        Arrangement.Horizontal start;
        FlingBehavior flingBehavior2;
        boolean z5;
        Arrangement arrangement;
        final LazyGridState lazyGridState2;
        final boolean z6;
        final Arrangement.Vertical vertical3;
        final FlingBehavior flingBehavior3;
        boolean z7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(1485410512);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyVerticalGrid)P(!1,5,7,2,6,9,4,3,8)64@2980L23,70@3340L15,75@3468L71,74@3442L481:LazyGridDsl.kt#7791vq");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(gridCells) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 2;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) != 0) {
                i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changed(lazyGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
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
                    if ((i & 196608) == 0) {
                        if ((i2 & 32) == 0) {
                            vertical2 = vertical;
                            int i14 = composerStartRestartGroup.changed(vertical2) ? Fields.RenderEffect : 65536;
                            i3 |= i14;
                        } else {
                            vertical2 = vertical;
                        }
                        i3 |= i14;
                    } else {
                        vertical2 = vertical;
                    }
                    i8 = i2 & 64;
                    if (i8 != 0) {
                        i3 |= 1572864;
                        horizontal2 = horizontal;
                    } else {
                        horizontal2 = horizontal;
                        if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(horizontal2)) {
                                i9 = 1048576;
                            } else {
                                i9 = 524288;
                            }
                            i3 |= i9;
                        }
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i10 = i2 & Fields.RotationX;
                    if (i10 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = 67108864;
                        } else {
                            i11 = 33554432;
                        }
                        i3 |= i11;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i12 = 536870912;
                            } else {
                                i12 = 268435456;
                            }
                            i3 |= i12;
                        }
                        if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                if (i13 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyGridStateRememberLazyGridState = lazyGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                z4 = i6 == 0 ? z3 : false;
                                if ((i2 & 32) != 0) {
                                    arrangement = Arrangement.INSTANCE;
                                    if (z4) {
                                        bottom = arrangement.getBottom();
                                    } else {
                                        bottom = arrangement.getTop();
                                    }
                                    i3 &= -458753;
                                } else {
                                    bottom = vertical2;
                                }
                                if (i8 != 0) {
                                    start = Arrangement.INSTANCE.getStart();
                                } else {
                                    start = horizontal2;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i10 != 0) {
                                    z5 = true;
                                } else {
                                    z5 = z2;
                                }
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 4) != 0) {
                                    i3 &= -897;
                                }
                                if ((i2 & 32) != 0) {
                                    i3 &= -458753;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    i3 &= -29360129;
                                }
                                companion = modifier;
                                lazyGridStateRememberLazyGridState = lazyGridState;
                                z5 = z2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                z4 = z3;
                                start = horizontal2;
                                bottom = vertical2;
                                flingBehavior2 = flingBehavior;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                            }
                            int i15 = i3 >> 3;
                            int i16 = i3 << 9;
                            LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i15 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i15 & 14) | 196608 | (i15 & 112) | (57344 & i3) | (3670016 & i15) | (29360128 & i15) | (234881024 & i16) | (i16 & 1879048192), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyGridState2 = lazyGridStateRememberLazyGridState;
                            z6 = z4;
                            vertical3 = bottom;
                            flingBehavior3 = flingBehavior2;
                            z7 = z5;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            companion = modifier;
                            lazyGridState2 = lazyGridState;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            z6 = z3;
                            start = horizontal2;
                            vertical3 = vertical2;
                            flingBehavior3 = flingBehavior;
                            z7 = z2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier2 = companion;
                            final PaddingValues paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Horizontal horizontal3 = start;
                            final boolean z8 = z7;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i17) {
                                    LazyGridDslKt.LazyVerticalGrid(gridCells, modifier2, lazyGridState2, paddingValues3, z6, vertical3, horizontal3, flingBehavior3, z8, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i17 = i3 >> 3;
                        int i18 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i17 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i17 & 14) | 196608 | (i17 & 112) | (57344 & i3) | (3670016 & i17) | (29360128 & i17) | (234881024 & i18) | (i18 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i19 = i3 >> 3;
                        int i110 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i19 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i19 & 14) | 196608 | (i19 & 112) | (57344 & i3) | (3670016 & i19) | (29360128 & i19) | (234881024 & i110) | (i110 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = companion;
                        final PaddingValues paddingValues4 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal4 = start;
                        final boolean z9 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i111) {
                                LazyGridDslKt.LazyVerticalGrid(gridCells, modifier3, lazyGridState2, paddingValues4, z6, vertical3, horizontal4, flingBehavior3, z9, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                z3 = z;
                if ((i & 196608) == 0) {
                    if ((i2 & 32) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                        }
                        i3 |= i14;
                    } else {
                        vertical2 = vertical;
                    }
                    i3 |= i14;
                } else {
                    vertical2 = vertical;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    horizontal2 = horizontal;
                } else {
                    horizontal2 = horizontal;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal2)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i111 = i3 >> 3;
                        int i112 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i111 & 14) | 196608 | (i111 & 112) | (57344 & i3) | (3670016 & i111) | (29360128 & i111) | (234881024 & i112) | (i112 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i113 = i3 >> 3;
                        int i114 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i113 & 14) | 196608 | (i113 & 112) | (57344 & i3) | (3670016 & i113) | (29360128 & i113) | (234881024 & i114) | (i114 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = companion;
                        final PaddingValues paddingValues5 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal5 = start;
                        final boolean z10 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i115) {
                                LazyGridDslKt.LazyVerticalGrid(gridCells, modifier4, lazyGridState2, paddingValues5, z6, vertical3, horizontal5, flingBehavior3, z10, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i115 = i3 >> 3;
                    int i116 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i115 & 14) | 196608 | (i115 & 112) | (57344 & i3) | (3670016 & i115) | (29360128 & i115) | (234881024 & i116) | (i116 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i117 = i3 >> 3;
                    int i118 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i117 & 14) | 196608 | (i117 & 112) | (57344 & i3) | (3670016 & i117) | (29360128 & i117) | (234881024 & i118) | (i118 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = companion;
                    final PaddingValues paddingValues6 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal6 = start;
                    final boolean z11 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i119) {
                            LazyGridDslKt.LazyVerticalGrid(gridCells, modifier5, lazyGridState2, paddingValues6, z6, vertical3, horizontal6, flingBehavior3, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
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
                if ((i & 196608) == 0) {
                    if ((i2 & 32) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                        }
                        i3 |= i14;
                    } else {
                        vertical2 = vertical;
                    }
                    i3 |= i14;
                } else {
                    vertical2 = vertical;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    horizontal2 = horizontal;
                } else {
                    horizontal2 = horizontal;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal2)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i119 = i3 >> 3;
                        int i1110 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i119 & 14) | 196608 | (i119 & 112) | (57344 & i3) | (3670016 & i119) | (29360128 & i119) | (234881024 & i1110) | (i1110 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i1111 = i3 >> 3;
                        int i1112 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1111 & 14) | 196608 | (i1111 & 112) | (57344 & i3) | (3670016 & i1111) | (29360128 & i1111) | (234881024 & i1112) | (i1112 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier6 = companion;
                        final PaddingValues paddingValues7 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal7 = start;
                        final boolean z12 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1113) {
                                LazyGridDslKt.LazyVerticalGrid(gridCells, modifier6, lazyGridState2, paddingValues7, z6, vertical3, horizontal7, flingBehavior3, z12, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i1113 = i3 >> 3;
                    int i1114 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1113 & 14) | 196608 | (i1113 & 112) | (57344 & i3) | (3670016 & i1113) | (29360128 & i1113) | (234881024 & i1114) | (i1114 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i1115 = i3 >> 3;
                    int i1116 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1115 & 14) | 196608 | (i1115 & 112) | (57344 & i3) | (3670016 & i1115) | (29360128 & i1115) | (234881024 & i1116) | (i1116 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = companion;
                    final PaddingValues paddingValues8 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal8 = start;
                    final boolean z13 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1117) {
                            LazyGridDslKt.LazyVerticalGrid(gridCells, modifier7, lazyGridState2, paddingValues8, z6, vertical3, horizontal8, flingBehavior3, z13, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            if ((i & 196608) == 0) {
                if ((i2 & 32) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                    }
                    i3 |= i14;
                } else {
                    vertical2 = vertical;
                }
                i3 |= i14;
            } else {
                vertical2 = vertical;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                horizontal2 = horizontal;
            } else {
                horizontal2 = horizontal;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i1117 = i3 >> 3;
                    int i1118 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1117 & 14) | 196608 | (i1117 & 112) | (57344 & i3) | (3670016 & i1117) | (29360128 & i1117) | (234881024 & i1118) | (i1118 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i1119 = i3 >> 3;
                    int i11110 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1119 & 14) | 196608 | (i1119 & 112) | (57344 & i3) | (3670016 & i1119) | (29360128 & i1119) | (234881024 & i11110) | (i11110 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = companion;
                    final PaddingValues paddingValues9 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal9 = start;
                    final boolean z14 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11111) {
                            LazyGridDslKt.LazyVerticalGrid(gridCells, modifier8, lazyGridState2, paddingValues9, z6, vertical3, horizontal9, flingBehavior3, z14, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i11111 = i3 >> 3;
                int i11112 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11111 & 14) | 196608 | (i11111 & 112) | (57344 & i3) | (3670016 & i11111) | (29360128 & i11111) | (234881024 & i11112) | (i11112 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i11113 = i3 >> 3;
                int i11114 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11113 & 14) | 196608 | (i11113 & 112) | (57344 & i3) | (3670016 & i11113) | (29360128 & i11113) | (234881024 & i11114) | (i11114 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = companion;
                final PaddingValues paddingValues10 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal10 = start;
                final boolean z15 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11115) {
                        LazyGridDslKt.LazyVerticalGrid(gridCells, modifier9, lazyGridState2, paddingValues10, z6, vertical3, horizontal10, flingBehavior3, z15, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) != 0) {
            i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changed(lazyGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
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
                if ((i & 196608) == 0) {
                    if ((i2 & 32) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                        }
                        i3 |= i14;
                    } else {
                        vertical2 = vertical;
                    }
                    i3 |= i14;
                } else {
                    vertical2 = vertical;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    horizontal2 = horizontal;
                } else {
                    horizontal2 = horizontal;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(horizontal2)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i11115 = i3 >> 3;
                        int i11116 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11115 & 14) | 196608 | (i11115 & 112) | (57344 & i3) | (3670016 & i11115) | (29360128 & i11115) | (234881024 & i11116) | (i11116 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    bottom = arrangement.getTop();
                                } else {
                                    bottom = arrangement.getBottom();
                                }
                                i3 &= -458753;
                            } else {
                                bottom = vertical2;
                            }
                            if (i8 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                        }
                        int i11117 = i3 >> 3;
                        int i11118 = i3 << 9;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11117 & 14) | 196608 | (i11117 & 112) | (57344 & i3) | (3670016 & i11117) | (29360128 & i11117) | (234881024 & i11118) | (i11118 & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        vertical3 = bottom;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier10 = companion;
                        final PaddingValues paddingValues11 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Horizontal horizontal11 = start;
                        final boolean z16 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i11119) {
                                LazyGridDslKt.LazyVerticalGrid(gridCells, modifier10, lazyGridState2, paddingValues11, z6, vertical3, horizontal11, flingBehavior3, z16, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i11119 = i3 >> 3;
                    int i111110 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11119 & 14) | 196608 | (i11119 & 112) | (57344 & i3) | (3670016 & i11119) | (29360128 & i11119) | (234881024 & i111110) | (i111110 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i111111 = i3 >> 3;
                    int i111112 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i111111 & 14) | 196608 | (i111111 & 112) | (57344 & i3) | (3670016 & i111111) | (29360128 & i111111) | (234881024 & i111112) | (i111112 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier11 = companion;
                    final PaddingValues paddingValues12 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal12 = start;
                    final boolean z17 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111113) {
                            LazyGridDslKt.LazyVerticalGrid(gridCells, modifier11, lazyGridState2, paddingValues12, z6, vertical3, horizontal12, flingBehavior3, z17, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            if ((i & 196608) == 0) {
                if ((i2 & 32) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                    }
                    i3 |= i14;
                } else {
                    vertical2 = vertical;
                }
                i3 |= i14;
            } else {
                vertical2 = vertical;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                horizontal2 = horizontal;
            } else {
                horizontal2 = horizontal;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i111113 = i3 >> 3;
                    int i111114 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i111113 & 14) | 196608 | (i111113 & 112) | (57344 & i3) | (3670016 & i111113) | (29360128 & i111113) | (234881024 & i111114) | (i111114 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i111115 = i3 >> 3;
                    int i111116 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i111115 & 14) | 196608 | (i111115 & 112) | (57344 & i3) | (3670016 & i111115) | (29360128 & i111115) | (234881024 & i111116) | (i111116 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = companion;
                    final PaddingValues paddingValues13 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal13 = start;
                    final boolean z18 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i111117) {
                            LazyGridDslKt.LazyVerticalGrid(gridCells, modifier12, lazyGridState2, paddingValues13, z6, vertical3, horizontal13, flingBehavior3, z18, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i111117 = i3 >> 3;
                int i111118 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i111117 & 14) | 196608 | (i111117 & 112) | (57344 & i3) | (3670016 & i111117) | (29360128 & i111117) | (234881024 & i111118) | (i111118 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i111119 = i3 >> 3;
                int i1111110 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i111119 & 14) | 196608 | (i111119 & 112) | (57344 & i3) | (3670016 & i111119) | (29360128 & i111119) | (234881024 & i1111110) | (i1111110 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier13 = companion;
                final PaddingValues paddingValues14 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal14 = start;
                final boolean z19 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111111) {
                        LazyGridDslKt.LazyVerticalGrid(gridCells, modifier13, lazyGridState2, paddingValues14, z6, vertical3, horizontal14, flingBehavior3, z19, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
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
            if ((i & 196608) == 0) {
                if ((i2 & 32) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                    }
                    i3 |= i14;
                } else {
                    vertical2 = vertical;
                }
                i3 |= i14;
            } else {
                vertical2 = vertical;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                horizontal2 = horizontal;
            } else {
                horizontal2 = horizontal;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i1111111 = i3 >> 3;
                    int i1111112 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1111111 & 14) | 196608 | (i1111111 & 112) | (57344 & i3) | (3670016 & i1111111) | (29360128 & i1111111) | (234881024 & i1111112) | (i1111112 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                bottom = arrangement.getTop();
                            } else {
                                bottom = arrangement.getBottom();
                            }
                            i3 &= -458753;
                        } else {
                            bottom = vertical2;
                        }
                        if (i8 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                    }
                    int i1111113 = i3 >> 3;
                    int i1111114 = i3 << 9;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1111113 & 14) | 196608 | (i1111113 & 112) | (57344 & i3) | (3670016 & i1111113) | (29360128 & i1111113) | (234881024 & i1111114) | (i1111114 & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    vertical3 = bottom;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier14 = companion;
                    final PaddingValues paddingValues15 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Horizontal horizontal15 = start;
                    final boolean z110 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1111115) {
                            LazyGridDslKt.LazyVerticalGrid(gridCells, modifier14, lazyGridState2, paddingValues15, z6, vertical3, horizontal15, flingBehavior3, z110, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i1111115 = i3 >> 3;
                int i1111116 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1111115 & 14) | 196608 | (i1111115 & 112) | (57344 & i3) | (3670016 & i1111115) | (29360128 & i1111115) | (234881024 & i1111116) | (i1111116 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i1111117 = i3 >> 3;
                int i1111118 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1111117 & 14) | 196608 | (i1111117 & 112) | (57344 & i3) | (3670016 & i1111117) | (29360128 & i1111117) | (234881024 & i1111118) | (i1111118 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier15 = companion;
                final PaddingValues paddingValues16 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal16 = start;
                final boolean z111 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1111119) {
                        LazyGridDslKt.LazyVerticalGrid(gridCells, modifier15, lazyGridState2, paddingValues16, z6, vertical3, horizontal16, flingBehavior3, z111, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        z3 = z;
        if ((i & 196608) == 0) {
            if ((i2 & 32) == 0) {
                vertical2 = vertical;
                if (composerStartRestartGroup.changed(vertical2)) {
                }
                i3 |= i14;
            } else {
                vertical2 = vertical;
            }
            i3 |= i14;
        } else {
            vertical2 = vertical;
        }
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 1572864;
            horizontal2 = horizontal;
        } else {
            horizontal2 = horizontal;
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(horizontal2)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
        }
        if ((i & 12582912) != 0) {
            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
        }
        i10 = i2 & Fields.RotationX;
        if (i10 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i11 = 67108864;
            } else {
                i11 = 33554432;
            }
            i3 |= i11;
        }
        if ((i2 & Fields.RotationY) != 0) {
            if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i3 |= i12;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i1111119 = i3 >> 3;
                int i11111110 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i1111119 & 14) | 196608 | (i1111119 & 112) | (57344 & i3) | (3670016 & i1111119) | (29360128 & i1111119) | (234881024 & i11111110) | (i11111110 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            bottom = arrangement.getTop();
                        } else {
                            bottom = arrangement.getBottom();
                        }
                        i3 &= -458753;
                    } else {
                        bottom = vertical2;
                    }
                    if (i8 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
                }
                int i11111111 = i3 >> 3;
                int i11111112 = i3 << 9;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11111111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11111111 & 14) | 196608 | (i11111111 & 112) | (57344 & i3) | (3670016 & i11111111) | (29360128 & i11111111) | (234881024 & i11111112) | (i11111112 & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                vertical3 = bottom;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = companion;
                final PaddingValues paddingValues17 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Horizontal horizontal17 = start;
                final boolean z112 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11111113) {
                        LazyGridDslKt.LazyVerticalGrid(gridCells, modifier16, lazyGridState2, paddingValues17, z6, vertical3, horizontal17, flingBehavior3, z112, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 805306368;
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        bottom = arrangement.getTop();
                    } else {
                        bottom = arrangement.getBottom();
                    }
                    i3 &= -458753;
                } else {
                    bottom = vertical2;
                }
                if (i8 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        bottom = arrangement.getTop();
                    } else {
                        bottom = arrangement.getBottom();
                    }
                    i3 &= -458753;
                } else {
                    bottom = vertical2;
                }
                if (i8 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
            }
            int i11111113 = i3 >> 3;
            int i11111114 = i3 << 9;
            LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11111113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11111113 & 14) | 196608 | (i11111113 & 112) | (57344 & i3) | (3670016 & i11111113) | (29360128 & i11111113) | (234881024 & i11111114) | (i11111114 & 1879048192), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyGridState2 = lazyGridStateRememberLazyGridState;
            z6 = z4;
            vertical3 = bottom;
            flingBehavior3 = flingBehavior2;
            z7 = z5;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        bottom = arrangement.getTop();
                    } else {
                        bottom = arrangement.getBottom();
                    }
                    i3 &= -458753;
                } else {
                    bottom = vertical2;
                }
                if (i8 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        bottom = arrangement.getTop();
                    } else {
                        bottom = arrangement.getBottom();
                    }
                    i3 &= -458753;
                } else {
                    bottom = vertical2;
                }
                if (i8 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(1485410512, i3, -1, "androidx.compose.foundation.lazy.grid.LazyVerticalGrid (LazyGridDsl.kt:73)");
            }
            int i11111115 = i3 >> 3;
            int i11111116 = i3 << 9;
            LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberColumnWidthSums(gridCells, start, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11111115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, true, flingBehavior2, z5, bottom, start, function1, composerStartRestartGroup, (i3 & 7168) | (i11111115 & 14) | 196608 | (i11111115 & 112) | (57344 & i3) | (3670016 & i11111115) | (29360128 & i11111115) | (234881024 & i11111116) | (i11111116 & 1879048192), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyGridState2 = lazyGridStateRememberLazyGridState;
            z6 = z4;
            vertical3 = bottom;
            flingBehavior3 = flingBehavior2;
            z7 = z5;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier17 = companion;
            final PaddingValues paddingValues18 = paddingValuesM1028PaddingValues0680j_4;
            final Arrangement.Horizontal horizontal18 = start;
            final boolean z113 = z7;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11111117) {
                    LazyGridDslKt.LazyVerticalGrid(gridCells, modifier17, lazyGridState2, paddingValues18, z6, vertical3, horizontal18, flingBehavior3, z113, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    public static final void LazyHorizontalGrid(final GridCells gridCells, Modifier modifier, LazyGridState lazyGridState, PaddingValues paddingValues, boolean z, Arrangement.Horizontal horizontal, Arrangement.Vertical vertical, FlingBehavior flingBehavior, boolean z2, final Function1<? super LazyGridScope, Unit> function1, Composer composer, final int i, final int i2) {
        int i3;
        int i4;
        PaddingValues paddingValues2;
        int i5;
        int i6;
        boolean z3;
        int i7;
        Arrangement.Horizontal horizontal2;
        int i8;
        Arrangement.Vertical vertical2;
        int i9;
        int i10;
        int i11;
        int i12;
        Modifier.Companion companion;
        LazyGridState lazyGridStateRememberLazyGridState;
        PaddingValues paddingValuesM1028PaddingValues0680j_4;
        boolean z4;
        Arrangement.Horizontal end;
        Arrangement.Vertical top;
        FlingBehavior flingBehavior2;
        boolean z5;
        Arrangement arrangement;
        final LazyGridState lazyGridState2;
        final boolean z6;
        final Arrangement.Horizontal horizontal3;
        final FlingBehavior flingBehavior3;
        boolean z7;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(2123608858);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(LazyHorizontalGrid)P(6,4,7,1,5,3,9,2,8)117@5477L23,123@5834L15,128@5962L64,127@5936L475:LazyGridDsl.kt#7791vq");
        if ((i2 & 1) != 0) {
            i3 = i | 6;
        } else if ((i & 6) == 0) {
            i3 = (composerStartRestartGroup.changed(gridCells) ? 4 : 2) | i;
        } else {
            i3 = i;
        }
        int i13 = i2 & 2;
        if (i13 == 0) {
            if ((i & 48) == 0) {
                i3 |= composerStartRestartGroup.changed(modifier) ? 32 : 16;
            }
            if ((i & 384) != 0) {
                i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changed(lazyGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
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
                    if ((i & 196608) == 0) {
                        if ((i2 & 32) == 0) {
                            horizontal2 = horizontal;
                            int i14 = composerStartRestartGroup.changed(horizontal2) ? Fields.RenderEffect : 65536;
                            i3 |= i14;
                        } else {
                            horizontal2 = horizontal;
                        }
                        i3 |= i14;
                    } else {
                        horizontal2 = horizontal;
                    }
                    i8 = i2 & 64;
                    if (i8 != 0) {
                        i3 |= 1572864;
                        vertical2 = vertical;
                    } else {
                        vertical2 = vertical;
                        if ((i & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(vertical2)) {
                                i9 = 1048576;
                            } else {
                                i9 = 524288;
                            }
                            i3 |= i9;
                        }
                    }
                    if ((i & 12582912) != 0) {
                        i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                    }
                    i10 = i2 & Fields.RotationX;
                    if (i10 != 0) {
                        i3 |= 100663296;
                    } else if ((i & 100663296) == 0) {
                        if (composerStartRestartGroup.changed(z2)) {
                            i11 = 67108864;
                        } else {
                            i11 = 33554432;
                        }
                        i3 |= i11;
                    }
                    if ((i2 & Fields.RotationY) != 0) {
                        if ((i & 805306368) == 0) {
                            if (composerStartRestartGroup.changedInstance(function1)) {
                                i12 = 536870912;
                            } else {
                                i12 = 268435456;
                            }
                            i3 |= i12;
                        }
                        if ((i3 & 306783379) == 306783378 || !composerStartRestartGroup.getSkipping()) {
                            composerStartRestartGroup.startDefaults();
                            if ((i & 1) != 0 || composerStartRestartGroup.getDefaultsInvalid()) {
                                if (i13 != 0) {
                                    companion = Modifier.INSTANCE;
                                } else {
                                    companion = modifier;
                                }
                                if ((i2 & 4) != 0) {
                                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                    i3 &= -897;
                                } else {
                                    lazyGridStateRememberLazyGridState = lazyGridState;
                                }
                                if (i4 != 0) {
                                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                                } else {
                                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                }
                                z4 = i6 == 0 ? z3 : false;
                                if ((i2 & 32) != 0) {
                                    arrangement = Arrangement.INSTANCE;
                                    if (z4) {
                                        end = arrangement.getEnd();
                                    } else {
                                        end = arrangement.getStart();
                                    }
                                    i3 &= -458753;
                                } else {
                                    end = horizontal2;
                                }
                                if (i8 != 0) {
                                    top = Arrangement.INSTANCE.getTop();
                                } else {
                                    top = vertical2;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                    i3 &= -29360129;
                                } else {
                                    flingBehavior2 = flingBehavior;
                                }
                                if (i10 != 0) {
                                    z5 = true;
                                } else {
                                    z5 = z2;
                                }
                            } else {
                                composerStartRestartGroup.skipToGroupEnd();
                                if ((i2 & 4) != 0) {
                                    i3 &= -897;
                                }
                                if ((i2 & 32) != 0) {
                                    i3 &= -458753;
                                }
                                if ((i2 & Fields.SpotShadowColor) != 0) {
                                    i3 &= -29360129;
                                }
                                companion = modifier;
                                lazyGridStateRememberLazyGridState = lazyGridState;
                                z5 = z2;
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                                z4 = z3;
                                top = vertical2;
                                end = horizontal2;
                                flingBehavior2 = flingBehavior;
                            }
                            composerStartRestartGroup.endDefaults();
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                            }
                            int i15 = i3 >> 3;
                            LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i15 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i15 & 14) | 196608 | (i15 & 112) | (57344 & i3) | (3670016 & i15) | (29360128 & i15) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            lazyGridState2 = lazyGridStateRememberLazyGridState;
                            z6 = z4;
                            horizontal3 = end;
                            flingBehavior3 = flingBehavior2;
                            z7 = z5;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            companion = modifier;
                            lazyGridState2 = lazyGridState;
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            z6 = z3;
                            top = vertical2;
                            horizontal3 = horizontal2;
                            flingBehavior3 = flingBehavior;
                            z7 = z2;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier2 = companion;
                            final PaddingValues paddingValues3 = paddingValuesM1028PaddingValues0680j_4;
                            final Arrangement.Vertical vertical3 = top;
                            final boolean z8 = z7;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj, Object obj2) {
                                    invoke((Composer) obj, ((Number) obj2).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i16) {
                                    LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier2, lazyGridState2, paddingValues3, z6, horizontal3, vertical3, flingBehavior3, z8, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                                }
                            });
                        }
                    }
                    i3 |= 805306368;
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i16 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i16 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i16 & 14) | 196608 | (i16 & 112) | (57344 & i3) | (3670016 & i16) | (29360128 & i16) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i17 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i17 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i17 & 14) | 196608 | (i17 & 112) | (57344 & i3) | (3670016 & i17) | (29360128 & i17) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier3 = companion;
                        final PaddingValues paddingValues4 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Vertical vertical4 = top;
                        final boolean z9 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i18) {
                                LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier3, lazyGridState2, paddingValues4, z6, horizontal3, vertical4, flingBehavior3, z9, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 24576;
                z3 = z;
                if ((i & 196608) == 0) {
                    if ((i2 & 32) == 0) {
                        horizontal2 = horizontal;
                        if (composerStartRestartGroup.changed(horizontal2)) {
                        }
                        i3 |= i14;
                    } else {
                        horizontal2 = horizontal;
                    }
                    i3 |= i14;
                } else {
                    horizontal2 = horizontal;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    vertical2 = vertical;
                } else {
                    vertical2 = vertical;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i18 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i18 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i18 & 14) | 196608 | (i18 & 112) | (57344 & i3) | (3670016 & i18) | (29360128 & i18) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i19 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i19 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i19 & 14) | 196608 | (i19 & 112) | (57344 & i3) | (3670016 & i19) | (29360128 & i19) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = companion;
                        final PaddingValues paddingValues5 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Vertical vertical5 = top;
                        final boolean z10 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i110) {
                                LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier4, lazyGridState2, paddingValues5, z6, horizontal3, vertical5, flingBehavior3, z10, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i110 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i110 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i110 & 14) | 196608 | (i110 & 112) | (57344 & i3) | (3670016 & i110) | (29360128 & i110) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i111 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i111 & 14) | 196608 | (i111 & 112) | (57344 & i3) | (3670016 & i111) | (29360128 & i111) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier5 = companion;
                    final PaddingValues paddingValues6 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Vertical vertical6 = top;
                    final boolean z11 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i112) {
                            LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier5, lazyGridState2, paddingValues6, z6, horizontal3, vertical6, flingBehavior3, z11, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
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
                if ((i & 196608) == 0) {
                    if ((i2 & 32) == 0) {
                        horizontal2 = horizontal;
                        if (composerStartRestartGroup.changed(horizontal2)) {
                        }
                        i3 |= i14;
                    } else {
                        horizontal2 = horizontal;
                    }
                    i3 |= i14;
                } else {
                    horizontal2 = horizontal;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    vertical2 = vertical;
                } else {
                    vertical2 = vertical;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i112 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i112 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i112 & 14) | 196608 | (i112 & 112) | (57344 & i3) | (3670016 & i112) | (29360128 & i112) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i113 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i113 & 14) | 196608 | (i113 & 112) | (57344 & i3) | (3670016 & i113) | (29360128 & i113) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier6 = companion;
                        final PaddingValues paddingValues7 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Vertical vertical7 = top;
                        final boolean z12 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i114) {
                                LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier6, lazyGridState2, paddingValues7, z6, horizontal3, vertical7, flingBehavior3, z12, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i114 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i114 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i114 & 14) | 196608 | (i114 & 112) | (57344 & i3) | (3670016 & i114) | (29360128 & i114) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i115 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i115 & 14) | 196608 | (i115 & 112) | (57344 & i3) | (3670016 & i115) | (29360128 & i115) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier7 = companion;
                    final PaddingValues paddingValues8 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Vertical vertical8 = top;
                    final boolean z13 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i116) {
                            LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier7, lazyGridState2, paddingValues8, z6, horizontal3, vertical8, flingBehavior3, z13, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            if ((i & 196608) == 0) {
                if ((i2 & 32) == 0) {
                    horizontal2 = horizontal;
                    if (composerStartRestartGroup.changed(horizontal2)) {
                    }
                    i3 |= i14;
                } else {
                    horizontal2 = horizontal;
                }
                i3 |= i14;
            } else {
                horizontal2 = horizontal;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                vertical2 = vertical;
            } else {
                vertical2 = vertical;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i116 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i116 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i116 & 14) | 196608 | (i116 & 112) | (57344 & i3) | (3670016 & i116) | (29360128 & i116) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i117 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i117 & 14) | 196608 | (i117 & 112) | (57344 & i3) | (3670016 & i117) | (29360128 & i117) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = companion;
                    final PaddingValues paddingValues9 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Vertical vertical9 = top;
                    final boolean z14 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i118) {
                            LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier8, lazyGridState2, paddingValues9, z6, horizontal3, vertical9, flingBehavior3, z14, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i118 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i118 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i118 & 14) | 196608 | (i118 & 112) | (57344 & i3) | (3670016 & i118) | (29360128 & i118) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i119 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i119 & 14) | 196608 | (i119 & 112) | (57344 & i3) | (3670016 & i119) | (29360128 & i119) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier9 = companion;
                final PaddingValues paddingValues10 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Vertical vertical10 = top;
                final boolean z15 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1110) {
                        LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier9, lazyGridState2, paddingValues10, z6, horizontal3, vertical10, flingBehavior3, z15, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 48;
        if ((i & 384) != 0) {
            i3 |= ((i2 & 4) == 0 || !composerStartRestartGroup.changed(lazyGridState)) ? Fields.SpotShadowColor : Fields.RotationX;
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
                if ((i & 196608) == 0) {
                    if ((i2 & 32) == 0) {
                        horizontal2 = horizontal;
                        if (composerStartRestartGroup.changed(horizontal2)) {
                        }
                        i3 |= i14;
                    } else {
                        horizontal2 = horizontal;
                    }
                    i3 |= i14;
                } else {
                    horizontal2 = horizontal;
                }
                i8 = i2 & 64;
                if (i8 != 0) {
                    i3 |= 1572864;
                    vertical2 = vertical;
                } else {
                    vertical2 = vertical;
                    if ((i & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i9 = 1048576;
                        } else {
                            i9 = 524288;
                        }
                        i3 |= i9;
                    }
                }
                if ((i & 12582912) != 0) {
                    i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
                }
                i10 = i2 & Fields.RotationX;
                if (i10 != 0) {
                    i3 |= 100663296;
                } else if ((i & 100663296) == 0) {
                    if (composerStartRestartGroup.changed(z2)) {
                        i11 = 67108864;
                    } else {
                        i11 = 33554432;
                    }
                    i3 |= i11;
                }
                if ((i2 & Fields.RotationY) != 0) {
                    if ((i & 805306368) == 0) {
                        if (composerStartRestartGroup.changedInstance(function1)) {
                            i12 = 536870912;
                        } else {
                            i12 = 268435456;
                        }
                        i3 |= i12;
                    }
                    if ((i3 & 306783379) == 306783378) {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i1110 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1110 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1110 & 14) | 196608 | (i1110 & 112) | (57344 & i3) | (3670016 & i1110) | (29360128 & i1110) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    } else {
                        composerStartRestartGroup.startDefaults();
                        if ((i & 1) != 0) {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        } else {
                            if (i13 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if ((i2 & 4) != 0) {
                                lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                                i3 &= -897;
                            } else {
                                lazyGridStateRememberLazyGridState = lazyGridState;
                            }
                            if (i4 != 0) {
                                paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                            } else {
                                paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                            }
                            if (i6 == 0) {
                            }
                            if ((i2 & 32) != 0) {
                                arrangement = Arrangement.INSTANCE;
                                if (z4) {
                                    end = arrangement.getStart();
                                } else {
                                    end = arrangement.getEnd();
                                }
                                i3 &= -458753;
                            } else {
                                end = horizontal2;
                            }
                            if (i8 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if ((i2 & Fields.SpotShadowColor) != 0) {
                                flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                                i3 &= -29360129;
                            } else {
                                flingBehavior2 = flingBehavior;
                            }
                            if (i10 != 0) {
                                z5 = true;
                            } else {
                                z5 = z2;
                            }
                        }
                        composerStartRestartGroup.endDefaults();
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                        }
                        int i1111 = i3 >> 3;
                        LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1111 & 14) | 196608 | (i1111 & 112) | (57344 & i3) | (3670016 & i1111) | (29360128 & i1111) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        lazyGridState2 = lazyGridStateRememberLazyGridState;
                        z6 = z4;
                        horizontal3 = end;
                        flingBehavior3 = flingBehavior2;
                        z7 = z5;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier10 = companion;
                        final PaddingValues paddingValues11 = paddingValuesM1028PaddingValues0680j_4;
                        final Arrangement.Vertical vertical11 = top;
                        final boolean z16 = z7;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj, Object obj2) {
                                invoke((Composer) obj, ((Number) obj2).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i1112) {
                                LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier10, lazyGridState2, paddingValues11, z6, horizontal3, vertical11, flingBehavior3, z16, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                            }
                        });
                    }
                }
                i3 |= 805306368;
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i1112 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1112 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1112 & 14) | 196608 | (i1112 & 112) | (57344 & i3) | (3670016 & i1112) | (29360128 & i1112) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i1113 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1113 & 14) | 196608 | (i1113 & 112) | (57344 & i3) | (3670016 & i1113) | (29360128 & i1113) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier11 = companion;
                    final PaddingValues paddingValues12 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Vertical vertical12 = top;
                    final boolean z17 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1114) {
                            LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier11, lazyGridState2, paddingValues12, z6, horizontal3, vertical12, flingBehavior3, z17, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 24576;
            z3 = z;
            if ((i & 196608) == 0) {
                if ((i2 & 32) == 0) {
                    horizontal2 = horizontal;
                    if (composerStartRestartGroup.changed(horizontal2)) {
                    }
                    i3 |= i14;
                } else {
                    horizontal2 = horizontal;
                }
                i3 |= i14;
            } else {
                horizontal2 = horizontal;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                vertical2 = vertical;
            } else {
                vertical2 = vertical;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i1114 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1114 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1114 & 14) | 196608 | (i1114 & 112) | (57344 & i3) | (3670016 & i1114) | (29360128 & i1114) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i1115 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1115 & 14) | 196608 | (i1115 & 112) | (57344 & i3) | (3670016 & i1115) | (29360128 & i1115) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = companion;
                    final PaddingValues paddingValues13 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Vertical vertical13 = top;
                    final boolean z18 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i1116) {
                            LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier12, lazyGridState2, paddingValues13, z6, horizontal3, vertical13, flingBehavior3, z18, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i1116 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1116 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1116 & 14) | 196608 | (i1116 & 112) | (57344 & i3) | (3670016 & i1116) | (29360128 & i1116) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i1117 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1117 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1117 & 14) | 196608 | (i1117 & 112) | (57344 & i3) | (3670016 & i1117) | (29360128 & i1117) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier13 = companion;
                final PaddingValues paddingValues14 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Vertical vertical14 = top;
                final boolean z19 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i1118) {
                        LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier13, lazyGridState2, paddingValues14, z6, horizontal3, vertical14, flingBehavior3, z19, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
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
            if ((i & 196608) == 0) {
                if ((i2 & 32) == 0) {
                    horizontal2 = horizontal;
                    if (composerStartRestartGroup.changed(horizontal2)) {
                    }
                    i3 |= i14;
                } else {
                    horizontal2 = horizontal;
                }
                i3 |= i14;
            } else {
                horizontal2 = horizontal;
            }
            i8 = i2 & 64;
            if (i8 != 0) {
                i3 |= 1572864;
                vertical2 = vertical;
            } else {
                vertical2 = vertical;
                if ((i & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i9 = 1048576;
                    } else {
                        i9 = 524288;
                    }
                    i3 |= i9;
                }
            }
            if ((i & 12582912) != 0) {
                i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
            }
            i10 = i2 & Fields.RotationX;
            if (i10 != 0) {
                i3 |= 100663296;
            } else if ((i & 100663296) == 0) {
                if (composerStartRestartGroup.changed(z2)) {
                    i11 = 67108864;
                } else {
                    i11 = 33554432;
                }
                i3 |= i11;
            }
            if ((i2 & Fields.RotationY) != 0) {
                if ((i & 805306368) == 0) {
                    if (composerStartRestartGroup.changedInstance(function1)) {
                        i12 = 536870912;
                    } else {
                        i12 = 268435456;
                    }
                    i3 |= i12;
                }
                if ((i3 & 306783379) == 306783378) {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i1118 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1118 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1118 & 14) | 196608 | (i1118 & 112) | (57344 & i3) | (3670016 & i1118) | (29360128 & i1118) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                } else {
                    composerStartRestartGroup.startDefaults();
                    if ((i & 1) != 0) {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    } else {
                        if (i13 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if ((i2 & 4) != 0) {
                            lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                            i3 &= -897;
                        } else {
                            lazyGridStateRememberLazyGridState = lazyGridState;
                        }
                        if (i4 != 0) {
                            paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                        } else {
                            paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                        }
                        if (i6 == 0) {
                        }
                        if ((i2 & 32) != 0) {
                            arrangement = Arrangement.INSTANCE;
                            if (z4) {
                                end = arrangement.getStart();
                            } else {
                                end = arrangement.getEnd();
                            }
                            i3 &= -458753;
                        } else {
                            end = horizontal2;
                        }
                        if (i8 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if ((i2 & Fields.SpotShadowColor) != 0) {
                            flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                            i3 &= -29360129;
                        } else {
                            flingBehavior2 = flingBehavior;
                        }
                        if (i10 != 0) {
                            z5 = true;
                        } else {
                            z5 = z2;
                        }
                    }
                    composerStartRestartGroup.endDefaults();
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                    }
                    int i1119 = i3 >> 3;
                    LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i1119 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i1119 & 14) | 196608 | (i1119 & 112) | (57344 & i3) | (3670016 & i1119) | (29360128 & i1119) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    lazyGridState2 = lazyGridStateRememberLazyGridState;
                    z6 = z4;
                    horizontal3 = end;
                    flingBehavior3 = flingBehavior2;
                    z7 = z5;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier14 = companion;
                    final PaddingValues paddingValues15 = paddingValuesM1028PaddingValues0680j_4;
                    final Arrangement.Vertical vertical15 = top;
                    final boolean z110 = z7;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj, Object obj2) {
                            invoke((Composer) obj, ((Number) obj2).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i11110) {
                            LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier14, lazyGridState2, paddingValues15, z6, horizontal3, vertical15, flingBehavior3, z110, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                        }
                    });
                }
            }
            i3 |= 805306368;
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i11110 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11110 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i11110 & 14) | 196608 | (i11110 & 112) | (57344 & i3) | (3670016 & i11110) | (29360128 & i11110) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i11111 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11111 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i11111 & 14) | 196608 | (i11111 & 112) | (57344 & i3) | (3670016 & i11111) | (29360128 & i11111) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier15 = companion;
                final PaddingValues paddingValues16 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Vertical vertical16 = top;
                final boolean z111 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11112) {
                        LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier15, lazyGridState2, paddingValues16, z6, horizontal3, vertical16, flingBehavior3, z111, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 24576;
        z3 = z;
        if ((i & 196608) == 0) {
            if ((i2 & 32) == 0) {
                horizontal2 = horizontal;
                if (composerStartRestartGroup.changed(horizontal2)) {
                }
                i3 |= i14;
            } else {
                horizontal2 = horizontal;
            }
            i3 |= i14;
        } else {
            horizontal2 = horizontal;
        }
        i8 = i2 & 64;
        if (i8 != 0) {
            i3 |= 1572864;
            vertical2 = vertical;
        } else {
            vertical2 = vertical;
            if ((i & 1572864) == 0) {
                if (composerStartRestartGroup.changed(vertical2)) {
                    i9 = 1048576;
                } else {
                    i9 = 524288;
                }
                i3 |= i9;
            }
        }
        if ((i & 12582912) != 0) {
            i3 |= ((i2 & Fields.SpotShadowColor) == 0 || !composerStartRestartGroup.changed(flingBehavior)) ? 4194304 : 8388608;
        }
        i10 = i2 & Fields.RotationX;
        if (i10 != 0) {
            i3 |= 100663296;
        } else if ((i & 100663296) == 0) {
            if (composerStartRestartGroup.changed(z2)) {
                i11 = 67108864;
            } else {
                i11 = 33554432;
            }
            i3 |= i11;
        }
        if ((i2 & Fields.RotationY) != 0) {
            if ((i & 805306368) == 0) {
                if (composerStartRestartGroup.changedInstance(function1)) {
                    i12 = 536870912;
                } else {
                    i12 = 268435456;
                }
                i3 |= i12;
            }
            if ((i3 & 306783379) == 306783378) {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i11112 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11112 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i11112 & 14) | 196608 | (i11112 & 112) | (57344 & i3) | (3670016 & i11112) | (29360128 & i11112) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            } else {
                composerStartRestartGroup.startDefaults();
                if ((i & 1) != 0) {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                } else {
                    if (i13 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if ((i2 & 4) != 0) {
                        lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                        i3 &= -897;
                    } else {
                        lazyGridStateRememberLazyGridState = lazyGridState;
                    }
                    if (i4 != 0) {
                        paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                    } else {
                        paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                    }
                    if (i6 == 0) {
                    }
                    if ((i2 & 32) != 0) {
                        arrangement = Arrangement.INSTANCE;
                        if (z4) {
                            end = arrangement.getStart();
                        } else {
                            end = arrangement.getEnd();
                        }
                        i3 &= -458753;
                    } else {
                        end = horizontal2;
                    }
                    if (i8 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if ((i2 & Fields.SpotShadowColor) != 0) {
                        flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                        i3 &= -29360129;
                    } else {
                        flingBehavior2 = flingBehavior;
                    }
                    if (i10 != 0) {
                        z5 = true;
                    } else {
                        z5 = z2;
                    }
                }
                composerStartRestartGroup.endDefaults();
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
                }
                int i11113 = i3 >> 3;
                LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11113 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i11113 & 14) | 196608 | (i11113 & 112) | (57344 & i3) | (3670016 & i11113) | (29360128 & i11113) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                lazyGridState2 = lazyGridStateRememberLazyGridState;
                z6 = z4;
                horizontal3 = end;
                flingBehavior3 = flingBehavior2;
                z7 = z5;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = companion;
                final PaddingValues paddingValues17 = paddingValuesM1028PaddingValues0680j_4;
                final Arrangement.Vertical vertical17 = top;
                final boolean z112 = z7;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj, Object obj2) {
                        invoke((Composer) obj, ((Number) obj2).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i11114) {
                        LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier16, lazyGridState2, paddingValues17, z6, horizontal3, vertical17, flingBehavior3, z112, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                    }
                });
            }
        }
        i3 |= 805306368;
        if ((i3 & 306783379) == 306783378) {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        end = arrangement.getStart();
                    } else {
                        end = arrangement.getEnd();
                    }
                    i3 &= -458753;
                } else {
                    end = horizontal2;
                }
                if (i8 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        end = arrangement.getStart();
                    } else {
                        end = arrangement.getEnd();
                    }
                    i3 &= -458753;
                } else {
                    end = horizontal2;
                }
                if (i8 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
            }
            int i11114 = i3 >> 3;
            LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11114 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i11114 & 14) | 196608 | (i11114 & 112) | (57344 & i3) | (3670016 & i11114) | (29360128 & i11114) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyGridState2 = lazyGridStateRememberLazyGridState;
            z6 = z4;
            horizontal3 = end;
            flingBehavior3 = flingBehavior2;
            z7 = z5;
        } else {
            composerStartRestartGroup.startDefaults();
            if ((i & 1) != 0) {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        end = arrangement.getStart();
                    } else {
                        end = arrangement.getEnd();
                    }
                    i3 &= -458753;
                } else {
                    end = horizontal2;
                }
                if (i8 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            } else {
                if (i13 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if ((i2 & 4) != 0) {
                    lazyGridStateRememberLazyGridState = LazyGridStateKt.rememberLazyGridState(0, 0, composerStartRestartGroup, 0, 3);
                    i3 &= -897;
                } else {
                    lazyGridStateRememberLazyGridState = lazyGridState;
                }
                if (i4 != 0) {
                    paddingValuesM1028PaddingValues0680j_4 = PaddingKt.m1028PaddingValues0680j_4(Dp.constructor-impl(0));
                } else {
                    paddingValuesM1028PaddingValues0680j_4 = paddingValues2;
                }
                if (i6 == 0) {
                }
                if ((i2 & 32) != 0) {
                    arrangement = Arrangement.INSTANCE;
                    if (z4) {
                        end = arrangement.getStart();
                    } else {
                        end = arrangement.getEnd();
                    }
                    i3 &= -458753;
                } else {
                    end = horizontal2;
                }
                if (i8 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if ((i2 & Fields.SpotShadowColor) != 0) {
                    flingBehavior2 = ScrollableDefaults.INSTANCE.flingBehavior(composerStartRestartGroup, 6);
                    i3 &= -29360129;
                } else {
                    flingBehavior2 = flingBehavior;
                }
                if (i10 != 0) {
                    z5 = true;
                } else {
                    z5 = z2;
                }
            }
            composerStartRestartGroup.endDefaults();
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(2123608858, i3, -1, "androidx.compose.foundation.lazy.grid.LazyHorizontalGrid (LazyGridDsl.kt:126)");
            }
            int i11115 = i3 >> 3;
            LazyGridKt.LazyGrid(companion, lazyGridStateRememberLazyGridState, rememberRowHeightSums(gridCells, top, paddingValuesM1028PaddingValues0680j_4, composerStartRestartGroup, (i3 & 14) | ((i3 >> 15) & 112) | (i11115 & 896)), paddingValuesM1028PaddingValues0680j_4, z4, false, flingBehavior2, z5, top, end, function1, composerStartRestartGroup, (i3 & 7168) | (i11115 & 14) | 196608 | (i11115 & 112) | (57344 & i3) | (3670016 & i11115) | (29360128 & i11115) | ((i3 << 6) & 234881024) | ((i3 << 12) & 1879048192), (i3 >> 27) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            lazyGridState2 = lazyGridStateRememberLazyGridState;
            z6 = z4;
            horizontal3 = end;
            flingBehavior3 = flingBehavior2;
            z7 = z5;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier17 = companion;
            final PaddingValues paddingValues18 = paddingValuesM1028PaddingValues0680j_4;
            final Arrangement.Vertical vertical18 = top;
            final boolean z113 = z7;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    invoke((Composer) obj, ((Number) obj2).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i11116) {
                    LazyGridDslKt.LazyHorizontalGrid(gridCells, modifier17, lazyGridState2, paddingValues18, z6, horizontal3, vertical18, flingBehavior3, z113, function1, composer2, RecomposeScopeImplKt.updateChangedFlags(i | 1), i2);
                }
            });
        }
    }

    private static final LazyGridSlotsProvider rememberColumnWidthSums(final GridCells gridCells, final Arrangement.Horizontal horizontal, final PaddingValues paddingValues, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1632454918, "C(rememberColumnWidthSums)P(!1,2)148@6622L975:LazyGridDsl.kt#7791vq");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1632454918, i, -1, "androidx.compose.foundation.lazy.grid.rememberColumnWidthSums (LazyGridDsl.kt:148)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, -2103044334, "CC(remember):LazyGridDsl.kt#9igjgp");
        boolean z = ((((i & 14) ^ 6) > 4 && composer.changed(gridCells)) || (i & 6) == 4) | ((((i & 112) ^ 48) > 32 && composer.changed(horizontal)) || (i & 48) == 32) | ((((i & 896) ^ 384) > 256 && composer.changed(paddingValues)) || (i & 384) == 256);
        GridSlotCache gridSlotCacheRememberedValue = composer.rememberedValue();
        if (z || gridSlotCacheRememberedValue == Composer.INSTANCE.getEmpty()) {
            gridSlotCacheRememberedValue = new GridSlotCache(new Function2<Density, Constraints, LazyGridSlots>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1175invoke0kLqBqw((Density) obj, ((Constraints) obj2).unbox-impl());
                }

                public final LazyGridSlots m1175invoke0kLqBqw(Density density, long j) {
                    if (Constraints.getMaxWidth-impl(j) == Integer.MAX_VALUE) {
                        throw new IllegalArgumentException("LazyVerticalGrid's width should be bound by parent.".toString());
                    }
                    int i2 = Constraints.getMaxWidth-impl(j) - density.roundToPx-0680j_4(Dp.constructor-impl(PaddingKt.calculateStartPadding(paddingValues, LayoutDirection.Ltr) + PaddingKt.calculateEndPadding(paddingValues, LayoutDirection.Ltr)));
                    GridCells gridCells2 = gridCells;
                    Arrangement.Horizontal horizontal2 = horizontal;
                    int[] intArray = CollectionsKt.toIntArray(gridCells2.calculateCrossAxisCellSizes(density, i2, density.roundToPx-0680j_4(horizontal2.getSpacing())));
                    int[] iArr = new int[intArray.length];
                    horizontal2.arrange(density, i2, intArray, LayoutDirection.Ltr, iArr);
                    return new LazyGridSlots(intArray, iArr);
                }
            });
            composer.updateRememberedValue(gridSlotCacheRememberedValue);
        }
        LazyGridSlotsProvider lazyGridSlotsProvider = (LazyGridSlotsProvider) gridSlotCacheRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return lazyGridSlotsProvider;
    }

    private static final LazyGridSlotsProvider rememberRowHeightSums(final GridCells gridCells, final Arrangement.Vertical vertical, final PaddingValues paddingValues, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -741512409, "C(rememberRowHeightSums)P(1,2)181@7795L909:LazyGridDsl.kt#7791vq");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-741512409, i, -1, "androidx.compose.foundation.lazy.grid.rememberRowHeightSums (LazyGridDsl.kt:181)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, -380187903, "CC(remember):LazyGridDsl.kt#9igjgp");
        boolean z = ((((i & 14) ^ 6) > 4 && composer.changed(gridCells)) || (i & 6) == 4) | ((((i & 112) ^ 48) > 32 && composer.changed(vertical)) || (i & 48) == 32) | ((((i & 896) ^ 384) > 256 && composer.changed(paddingValues)) || (i & 384) == 256);
        GridSlotCache gridSlotCacheRememberedValue = composer.rememberedValue();
        if (z || gridSlotCacheRememberedValue == Composer.INSTANCE.getEmpty()) {
            gridSlotCacheRememberedValue = new GridSlotCache(new Function2<Density, Constraints, LazyGridSlots>() {
                {
                    super(2);
                }

                public Object invoke(Object obj, Object obj2) {
                    return m1176invoke0kLqBqw((Density) obj, ((Constraints) obj2).unbox-impl());
                }

                public final LazyGridSlots m1176invoke0kLqBqw(Density density, long j) {
                    if (Constraints.getMaxHeight-impl(j) == Integer.MAX_VALUE) {
                        throw new IllegalArgumentException("LazyHorizontalGrid's height should be bound by parent.".toString());
                    }
                    int i2 = Constraints.getMaxHeight-impl(j) - density.roundToPx-0680j_4(Dp.constructor-impl(paddingValues.getTop() + paddingValues.getBottom()));
                    GridCells gridCells2 = gridCells;
                    Arrangement.Vertical vertical2 = vertical;
                    int[] intArray = CollectionsKt.toIntArray(gridCells2.calculateCrossAxisCellSizes(density, i2, density.roundToPx-0680j_4(vertical2.getSpacing())));
                    int[] iArr = new int[intArray.length];
                    vertical2.arrange(density, i2, intArray, iArr);
                    return new LazyGridSlots(intArray, iArr);
                }
            });
            composer.updateRememberedValue(gridSlotCacheRememberedValue);
        }
        LazyGridSlotsProvider lazyGridSlotsProvider = (LazyGridSlotsProvider) gridSlotCacheRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return lazyGridSlotsProvider;
    }

    public static final List<Integer> calculateCellsCrossAxisSizeImpl(int i, int i2, int i3) {
        int i4 = i - (i3 * (i2 - 1));
        int i5 = i4 / i2;
        int i6 = i4 % i2;
        ArrayList arrayList = new ArrayList(i2);
        int i7 = 0;
        while (i7 < i2) {
            arrayList.add(Integer.valueOf((i7 < i6 ? 1 : 0) + i5));
            i7++;
        }
        return arrayList;
    }

    public static void items$default(LazyGridScope lazyGridScope, List list, Function1 function1, Function2 function2, Function1 function3, Function4 function4, int i, Object obj) {
        if ((i & 2) != 0) {
            function1 = null;
        }
        if ((i & 4) != 0) {
            function2 = null;
        }
        if ((i & 8) != 0) {
            function3 = new Function1() {
                public final Void invoke(T t) {
                    return null;
                }
            };
        }
        lazyGridScope.items(list.size(), function1 != null ? new C06542(function1, list) : null, function2 != null ? new C06553(function2, list) : null, new C06564(function3, list), ComposableLambdaKt.composableLambdaInstance(699646206, true, new C06575(function4, list)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06542 extends Lambda implements Function1<Integer, Object> {
        final List<T> $items;
        final Function1<T, Object> $key;

        public C06542(Function1<? super T, ? extends Object> function1, List<? extends T> list) {
            super(1);
            this.$key = function1;
            this.$items = list;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$key.invoke(this.$items.get(i));
        }
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\n¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "it", "", "invoke-_-orMbw", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;I)J"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06553 extends Lambda implements Function2<LazyGridItemSpanScope, Integer, GridItemSpan> {
        final List<T> $items;
        final Function2<LazyGridItemSpanScope, T, GridItemSpan> $span;

        public C06553(Function2<? super LazyGridItemSpanScope, ? super T, GridItemSpan> function2, List<? extends T> list) {
            super(2);
            this.$span = function2;
            this.$items = list;
        }

        public Object invoke(Object obj, Object obj2) {
            return GridItemSpan.m1160boximpl(m1170invoke_orMbw((LazyGridItemSpanScope) obj, ((Number) obj2).intValue()));
        }

        public final long m1170invoke_orMbw(LazyGridItemSpanScope lazyGridItemSpanScope, int i) {
            return ((GridItemSpan) this.$span.invoke(lazyGridItemSpanScope, this.$items.get(i))).getPackedValue();
        }
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06564 extends Lambda implements Function1<Integer, Object> {
        final Function1<T, Object> $contentType;
        final List<T> $items;

        public C06564(Function1<? super T, ? extends Object> function1, List<? extends T> list) {
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

    public static final <T> void items(LazyGridScope lazyGridScope, List<? extends T> list, Function1<? super T, ? extends Object> function1, Function2<? super LazyGridItemSpanScope, ? super T, GridItemSpan> function2, Function1<? super T, ? extends Object> function3, Function4<? super LazyGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4) {
        lazyGridScope.items(list.size(), function1 != null ? new C06542(function1, list) : null, function2 != null ? new C06553(function2, list) : null, new C06564(function3, list), ComposableLambdaKt.composableLambdaInstance(699646206, true, new C06575(function4, list)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;", "it", "", "invoke", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06575 extends Lambda implements Function4<LazyGridItemScope, Integer, Composer, Integer, Unit> {
        final Function4<LazyGridItemScope, T, Composer, Integer, Unit> $itemContent;
        final List<T> $items;

        public C06575(Function4<? super LazyGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4, List<? extends T> list) {
            super(4);
            this.$itemContent = function4;
            this.$items = list;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyGridItemScope lazyGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C464@19670L22:LazyGridDsl.kt#7791vq");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyGridItemScope) ? 4 : 2) | i2;
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
                ComposerKt.traceEventStart(699646206, i3, -1, "androidx.compose.foundation.lazy.grid.items.<anonymous> (LazyGridDsl.kt:464)");
            }
            this.$itemContent.invoke(lazyGridItemScope, this.$items.get(i), composer, Integer.valueOf(i3 & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }

    public static void itemsIndexed$default(LazyGridScope lazyGridScope, List list, Function2 function2, Function3 function3, Function2 function4, Function5 function5, int i, Object obj) {
        if ((i & 2) != 0) {
            function2 = null;
        }
        if ((i & 4) != 0) {
            function3 = null;
        }
        if ((i & 8) != 0) {
            function4 = new Function2() {
                public final Void invoke(int i2, T t) {
                    return null;
                }

                public Object invoke(Object obj2, Object obj3) {
                    return invoke(((Number) obj2).intValue(), obj3);
                }
            };
        }
        lazyGridScope.items(list.size(), function2 != null ? new C06642(function2, list) : null, function3 != null ? new C06653(function3, list) : null, new C06664(function4, list), ComposableLambdaKt.composableLambdaInstance(1229287273, true, new C06675(function5, list)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06642 extends Lambda implements Function1<Integer, Object> {
        final List<T> $items;
        final Function2<Integer, T, Object> $key;

        public C06642(Function2<? super Integer, ? super T, ? extends Object> function2, List<? extends T> list) {
            super(1);
            this.$key = function2;
            this.$items = list;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$key.invoke(Integer.valueOf(i), this.$items.get(i));
        }
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\n¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "it", "", "invoke-_-orMbw", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;I)J"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06653 extends Lambda implements Function2<LazyGridItemSpanScope, Integer, GridItemSpan> {
        final List<T> $items;
        final Function3<LazyGridItemSpanScope, Integer, T, GridItemSpan> $span;

        public C06653(Function3<? super LazyGridItemSpanScope, ? super Integer, ? super T, GridItemSpan> function3, List<? extends T> list) {
            super(2);
            this.$span = function3;
            this.$items = list;
        }

        public Object invoke(Object obj, Object obj2) {
            return GridItemSpan.m1160boximpl(m1173invoke_orMbw((LazyGridItemSpanScope) obj, ((Number) obj2).intValue()));
        }

        public final long m1173invoke_orMbw(LazyGridItemSpanScope lazyGridItemSpanScope, int i) {
            return ((GridItemSpan) this.$span.invoke(lazyGridItemSpanScope, Integer.valueOf(i), this.$items.get(i))).getPackedValue();
        }
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06664 extends Lambda implements Function1<Integer, Object> {
        final Function2<Integer, T, Object> $contentType;
        final List<T> $items;

        public C06664(Function2<? super Integer, ? super T, ? extends Object> function2, List<? extends T> list) {
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

    public static final <T> void itemsIndexed(LazyGridScope lazyGridScope, List<? extends T> list, Function2<? super Integer, ? super T, ? extends Object> function2, Function3<? super LazyGridItemSpanScope, ? super Integer, ? super T, GridItemSpan> function3, Function2<? super Integer, ? super T, ? extends Object> function4, Function5<? super LazyGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5) {
        lazyGridScope.items(list.size(), function2 != null ? new C06642(function2, list) : null, function3 != null ? new C06653(function3, list) : null, new C06664(function4, list), ComposableLambdaKt.composableLambdaInstance(1229287273, true, new C06675(function5, list)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;", "it", "", "invoke", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06675 extends Lambda implements Function4<LazyGridItemScope, Integer, Composer, Integer, Unit> {
        final Function5<LazyGridItemScope, Integer, T, Composer, Integer, Unit> $itemContent;
        final List<T> $items;

        public C06675(Function5<? super LazyGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5, List<? extends T> list) {
            super(4);
            this.$itemContent = function5;
            this.$items = list;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyGridItemScope lazyGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C498@21519L26:LazyGridDsl.kt#7791vq");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyGridItemScope) ? 4 : 2) | i2;
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
                ComposerKt.traceEventStart(1229287273, i3, -1, "androidx.compose.foundation.lazy.grid.itemsIndexed.<anonymous> (LazyGridDsl.kt:498)");
            }
            this.$itemContent.invoke(lazyGridItemScope, Integer.valueOf(i), this.$items.get(i), composer, Integer.valueOf(i3 & 126));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }

    public static void items$default(LazyGridScope lazyGridScope, Object[] objArr, Function1 function1, Function2 function2, Function1 function3, Function4 function4, int i, Object obj) {
        if ((i & 2) != 0) {
            function1 = null;
        }
        if ((i & 4) != 0) {
            function2 = null;
        }
        if ((i & 8) != 0) {
            function3 = new Function1() {
                public final Void invoke(T t) {
                    return null;
                }
            };
        }
        lazyGridScope.items(objArr.length, function1 != null ? new C06597(function1, objArr) : null, function2 != null ? new C06608(function2, objArr) : null, new C06619(function3, objArr), ComposableLambdaKt.composableLambdaInstance(407562193, true, new C065310(function4, objArr)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06597 extends Lambda implements Function1<Integer, Object> {
        final T[] $items;
        final Function1<T, Object> $key;

        public C06597(Function1<? super T, ? extends Object> function1, T[] tArr) {
            super(1);
            this.$key = function1;
            this.$items = tArr;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$key.invoke(this.$items[i]);
        }
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\n¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "it", "", "invoke-_-orMbw", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;I)J"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06608 extends Lambda implements Function2<LazyGridItemSpanScope, Integer, GridItemSpan> {
        final T[] $items;
        final Function2<LazyGridItemSpanScope, T, GridItemSpan> $span;

        public C06608(Function2<? super LazyGridItemSpanScope, ? super T, GridItemSpan> function2, T[] tArr) {
            super(2);
            this.$span = function2;
            this.$items = tArr;
        }

        public Object invoke(Object obj, Object obj2) {
            return GridItemSpan.m1160boximpl(m1172invoke_orMbw((LazyGridItemSpanScope) obj, ((Number) obj2).intValue()));
        }

        public final long m1172invoke_orMbw(LazyGridItemSpanScope lazyGridItemSpanScope, int i) {
            return ((GridItemSpan) this.$span.invoke(lazyGridItemSpanScope, this.$items[i])).getPackedValue();
        }
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06619 extends Lambda implements Function1<Integer, Object> {
        final Function1<T, Object> $contentType;
        final T[] $items;

        public C06619(Function1<? super T, ? extends Object> function1, T[] tArr) {
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

    public static final <T> void items(LazyGridScope lazyGridScope, T[] tArr, Function1<? super T, ? extends Object> function1, Function2<? super LazyGridItemSpanScope, ? super T, GridItemSpan> function2, Function1<? super T, ? extends Object> function3, Function4<? super LazyGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4) {
        lazyGridScope.items(tArr.length, function1 != null ? new C06597(function1, tArr) : null, function2 != null ? new C06608(function2, tArr) : null, new C06619(function3, tArr), ComposableLambdaKt.composableLambdaInstance(407562193, true, new C065310(function4, tArr)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;", "it", "", "invoke", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C065310 extends Lambda implements Function4<LazyGridItemScope, Integer, Composer, Integer, Unit> {
        final Function4<LazyGridItemScope, T, Composer, Integer, Unit> $itemContent;
        final T[] $items;

        public C065310(Function4<? super LazyGridItemScope, ? super T, ? super Composer, ? super Integer, Unit> function4, T[] tArr) {
            super(4);
            this.$itemContent = function4;
            this.$items = tArr;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyGridItemScope lazyGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C532@23245L22:LazyGridDsl.kt#7791vq");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyGridItemScope) ? 4 : 2) | i2;
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
                ComposerKt.traceEventStart(407562193, i3, -1, "androidx.compose.foundation.lazy.grid.items.<anonymous> (LazyGridDsl.kt:532)");
            }
            this.$itemContent.invoke(lazyGridItemScope, this.$items[i], composer, Integer.valueOf(i3 & 14));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }

    public static void itemsIndexed$default(LazyGridScope lazyGridScope, Object[] objArr, Function2 function2, Function3 function3, Function2 function4, Function5 function5, int i, Object obj) {
        if ((i & 2) != 0) {
            function2 = null;
        }
        if ((i & 4) != 0) {
            function3 = null;
        }
        if ((i & 8) != 0) {
            function4 = new Function2() {
                public final Void invoke(int i2, T t) {
                    return null;
                }

                public Object invoke(Object obj2, Object obj3) {
                    return invoke(((Number) obj2).intValue(), obj3);
                }
            };
        }
        lazyGridScope.items(objArr.length, function2 != null ? new C06697(function2, objArr) : null, function3 != null ? new C06708(function3, objArr) : null, new C06719(function4, objArr), ComposableLambdaKt.composableLambdaInstance(-911455938, true, new C066310(function5, objArr)));
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06697 extends Lambda implements Function1<Integer, Object> {
        final T[] $items;
        final Function2<Integer, T, Object> $key;

        public C06697(Function2<? super Integer, ? super T, ? extends Object> function2, T[] tArr) {
            super(1);
            this.$key = function2;
            this.$items = tArr;
        }

        public Object invoke(Object obj) {
            return invoke(((Number) obj).intValue());
        }

        public final Object invoke(int i) {
            return this.$key.invoke(Integer.valueOf(i), this.$items[i]);
        }
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\n¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "Landroidx/compose/foundation/lazy/grid/GridItemSpan;", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;", "it", "", "invoke-_-orMbw", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemSpanScope;I)J"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06708 extends Lambda implements Function2<LazyGridItemSpanScope, Integer, GridItemSpan> {
        final T[] $items;
        final Function3<LazyGridItemSpanScope, Integer, T, GridItemSpan> $span;

        public C06708(Function3<? super LazyGridItemSpanScope, ? super Integer, ? super T, GridItemSpan> function3, T[] tArr) {
            super(2);
            this.$span = function3;
            this.$items = tArr;
        }

        public Object invoke(Object obj, Object obj2) {
            return GridItemSpan.m1160boximpl(m1174invoke_orMbw((LazyGridItemSpanScope) obj, ((Number) obj2).intValue()));
        }

        public final long m1174invoke_orMbw(LazyGridItemSpanScope lazyGridItemSpanScope, int i) {
            return ((GridItemSpan) this.$span.invoke(lazyGridItemSpanScope, Integer.valueOf(i), this.$items[i])).getPackedValue();
        }
    }

    @Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C06719 extends Lambda implements Function1<Integer, Object> {
        final Function2<Integer, T, Object> $contentType;
        final T[] $items;

        public C06719(Function2<? super Integer, ? super T, ? extends Object> function2, T[] tArr) {
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

    public static final <T> void itemsIndexed(LazyGridScope lazyGridScope, T[] tArr, Function2<? super Integer, ? super T, ? extends Object> function2, Function3<? super LazyGridItemSpanScope, ? super Integer, ? super T, GridItemSpan> function3, Function2<? super Integer, ? super T, ? extends Object> function4, Function5<? super LazyGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5) {
        lazyGridScope.items(tArr.length, function2 != null ? new C06697(function2, tArr) : null, function3 != null ? new C06708(function3, tArr) : null, new C06719(function4, tArr), ComposableLambdaKt.composableLambdaInstance(-911455938, true, new C066310(function5, tArr)));
    }

    @Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u000b¢\u0006\u0004\b\u0006\u0010\u0007"}, d2 = {"<anonymous>", "", "T", "Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;", "it", "", "invoke", "(Landroidx/compose/foundation/lazy/grid/LazyGridItemScope;ILandroidx/compose/runtime/Composer;I)V"}, k = 3, mv = {1, 8, 0}, xi = 176)
    public static final class C066310 extends Lambda implements Function4<LazyGridItemScope, Integer, Composer, Integer, Unit> {
        final Function5<LazyGridItemScope, Integer, T, Composer, Integer, Unit> $itemContent;
        final T[] $items;

        public C066310(Function5<? super LazyGridItemScope, ? super Integer, ? super T, ? super Composer, ? super Integer, Unit> function5, T[] tArr) {
            super(4);
            this.$itemContent = function5;
            this.$items = tArr;
        }

        public Object invoke(Object obj, Object obj2, Object obj3, Object obj4) {
            invoke((LazyGridItemScope) obj, ((Number) obj2).intValue(), (Composer) obj3, ((Number) obj4).intValue());
            return Unit.INSTANCE;
        }

        public final void invoke(LazyGridItemScope lazyGridItemScope, int i, Composer composer, int i2) {
            int i3;
            ComposerKt.sourceInformation(composer, "C566@25098L26:LazyGridDsl.kt#7791vq");
            if ((i2 & 6) == 0) {
                i3 = (composer.changed(lazyGridItemScope) ? 4 : 2) | i2;
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
                ComposerKt.traceEventStart(-911455938, i3, -1, "androidx.compose.foundation.lazy.grid.itemsIndexed.<anonymous> (LazyGridDsl.kt:566)");
            }
            this.$itemContent.invoke(lazyGridItemScope, Integer.valueOf(i), this.$items[i], composer, Integer.valueOf(i3 & 126));
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
        }
    }
}
