package androidx.compose.foundation.layout;

import androidx.collection.IntIntPair;
import androidx.collection.IntObjectMapKt;
import androidx.collection.MutableIntList;
import androidx.collection.MutableIntObjectMap;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.ComposedModifierKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.LayoutKt;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.MultiContentMeasurePolicy;
import androidx.compose.p002ui.layout.MultiContentMeasurePolicyKt;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.ComposeUiNode;
import androidx.compose.runtime.Applier;
import androidx.compose.runtime.ComposablesKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.CompositionLocalMap;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.Updater;
import androidx.compose.runtime.collection.MutableVector;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.collections.IntIterator;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlin.ranges.IntRange;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000Ô\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u0015\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010(\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\u001ag\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u000f2\b\b\u0002\u0010\u0011\u001a\u00020\u00122\u001c\u0010\u0013\u001a\u0018\u0012\u0004\u0012\u00020\u0015\u0012\u0004\u0012\u00020\u00070\u0014¢\u0006\u0002\b\u0016¢\u0006\u0002\b\u0017H\u0007¢\u0006\u0002\u0010\u0018\u001ag\u0010\u0019\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\u001a\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u000f2\b\b\u0002\u0010\u0011\u001a\u00020\u001b2\u001c\u0010\u0013\u001a\u0018\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u00070\u0014¢\u0006\u0002\b\u0016¢\u0006\u0002\b\u0017H\u0007¢\u0006\u0002\u0010\u001d\u001a%\u0010\u001e\u001a\u00020\u001f2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010 \u001a\u00020\u000fH\u0001¢\u0006\u0002\u0010!\u001a5\u0010\"\u001a\u00020#2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010 \u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010$\u001a\u00020%H\u0001¢\u0006\u0002\u0010&\u001a\u0095\u0001\u0010'\u001a\u00020(2\f\u0010)\u001a\b\u0012\u0004\u0012\u00020+0*2#\u0010,\u001a\u001f\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0-¢\u0006\u0002\b\u00172#\u0010.\u001a\u001f\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0-¢\u0006\u0002\b\u00172\u0006\u0010/\u001a\u00020\u000f2\u0006\u00100\u001a\u00020\u000f2\u0006\u00101\u001a\u00020\u000f2\u0006\u0010 \u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020%H\u0002¢\u0006\u0002\u00102\u001a[\u0010'\u001a\u00020(2\f\u0010)\u001a\b\u0012\u0004\u0012\u00020+0*2\u0006\u00103\u001a\u0002042\u0006\u00105\u001a\u0002042\u0006\u0010/\u001a\u00020\u000f2\u0006\u00100\u001a\u00020\u000f2\u0006\u00101\u001a\u00020\u000f2\u0006\u0010 \u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020%H\u0002¢\u0006\u0002\u00106\u001aS\u00107\u001a\u00020\u000f2\f\u0010)\u001a\b\u0012\u0004\u0012\u00020+0*2#\u0010,\u001a\u001f\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0-¢\u0006\u0002\b\u00172\u0006\u00108\u001a\u00020\u000f2\u0006\u00100\u001a\u00020\u000f2\u0006\u0010 \u001a\u00020\u000fH\u0002\u001a\u0090\u0001\u00109\u001a\u00020\u000f2\f\u0010)\u001a\b\u0012\u0004\u0012\u00020+0*2#\u0010,\u001a\u001f\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0-¢\u0006\u0002\b\u00172#\u0010.\u001a\u001f\u0012\u0004\u0012\u00020+\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\u000f0-¢\u0006\u0002\b\u00172\u0006\u00108\u001a\u00020\u000f2\u0006\u00100\u001a\u00020\u000f2\u0006\u00101\u001a\u00020\u000f2\u0006\u0010 \u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020%H\u0002\u001a%\u0010:\u001a\u00020\u001f2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010 \u001a\u00020\u000fH\u0001¢\u0006\u0002\u0010;\u001a5\u0010<\u001a\u00020#2\u0006\u0010\f\u001a\u00020\r2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010 \u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010$\u001a\u00020%H\u0001¢\u0006\u0002\u0010=\u001a\\\u0010>\u001a\u00020?*\u00020@2\u0006\u0010A\u001a\u00020B2\f\u0010C\u001a\b\u0012\u0004\u0012\u00020E0D2\u0006\u0010F\u001a\u00020G2\u0006\u0010H\u001a\u00020G2\u0006\u0010I\u001a\u00020J2\u0006\u0010 \u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u000f2\u0006\u0010\u0011\u001a\u00020%H\u0000ø\u0001\u0000¢\u0006\u0004\bK\u0010L\u001a\u001c\u0010M\u001a\u00020\u000f*\u00020+2\u0006\u0010N\u001a\u00020O2\u0006\u0010,\u001a\u00020\u000fH\u0000\u001a\u001c\u0010P\u001a\u00020\u000f*\u00020+2\u0006\u0010N\u001a\u00020O2\u0006\u0010.\u001a\u00020\u000fH\u0000\u001a<\u0010Q\u001a\u00020(*\u00020E2\u0006\u0010A\u001a\u00020B2\u0006\u0010I\u001a\u00020R2\u0014\u0010S\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010T\u0012\u0004\u0012\u00020\u00070\u0014H\u0000ø\u0001\u0000¢\u0006\u0004\bU\u0010V\u001aT\u0010W\u001a\u00020?*\u00020@2\u0006\u0010I\u001a\u00020J2\u0006\u0010X\u001a\u00020\u000f2\u0006\u0010Y\u001a\u00020\u000f2\u0006\u00105\u001a\u0002042\f\u0010Z\u001a\b\u0012\u0004\u0012\u00020?0[2\u0006\u0010\\\u001a\u00020B2\u0006\u0010]\u001a\u000204H\u0000ø\u0001\u0000¢\u0006\u0004\b^\u0010_\u001a\u001e\u0010`\u001a\u0004\u0018\u00010E*\b\u0012\u0004\u0012\u00020E0D2\b\u0010a\u001a\u0004\u0018\u00010bH\u0002\"\u0014\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0003\"\u0014\u0010\u0004\u001a\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0003\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006c"}, d2 = {"CROSS_AXIS_ALIGNMENT_START", "Landroidx/compose/foundation/layout/CrossAxisAlignment;", "getCROSS_AXIS_ALIGNMENT_START", "()Landroidx/compose/foundation/layout/CrossAxisAlignment;", "CROSS_AXIS_ALIGNMENT_TOP", "getCROSS_AXIS_ALIGNMENT_TOP", "FlowColumn", "", "modifier", "Landroidx/compose/ui/Modifier;", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "maxItemsInEachColumn", "", "maxLines", "overflow", "Landroidx/compose/foundation/layout/FlowColumnOverflow;", "content", "Lkotlin/Function1;", "Landroidx/compose/foundation/layout/FlowColumnScope;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;IILandroidx/compose/foundation/layout/FlowColumnOverflow;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "FlowRow", "maxItemsInEachRow", "Landroidx/compose/foundation/layout/FlowRowOverflow;", "Landroidx/compose/foundation/layout/FlowRowScope;", "(Landroidx/compose/ui/Modifier;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;IILandroidx/compose/foundation/layout/FlowRowOverflow;Lkotlin/jvm/functions/Function3;Landroidx/compose/runtime/Composer;II)V", "columnMeasurementHelper", "Landroidx/compose/ui/layout/MeasurePolicy;", "maxItemsInMainAxis", "(Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;ILandroidx/compose/runtime/Composer;I)Landroidx/compose/ui/layout/MeasurePolicy;", "columnMeasurementMultiContentHelper", "Landroidx/compose/ui/layout/MultiContentMeasurePolicy;", "overflowState", "Landroidx/compose/foundation/layout/FlowLayoutOverflowState;", "(Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;IILandroidx/compose/foundation/layout/FlowLayoutOverflowState;Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/layout/MultiContentMeasurePolicy;", "intrinsicCrossAxisSize", "Landroidx/collection/IntIntPair;", "children", "", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "mainAxisSize", "Lkotlin/Function3;", "crossAxisSize", "mainAxisAvailable", "mainAxisSpacing", "crossAxisSpacing", "(Ljava/util/List;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function3;IIIIILandroidx/compose/foundation/layout/FlowLayoutOverflowState;)J", "mainAxisSizes", "", "crossAxisSizes", "(Ljava/util/List;[I[IIIIIILandroidx/compose/foundation/layout/FlowLayoutOverflowState;)J", "maxIntrinsicMainAxisSize", "crossAxisAvailable", "minIntrinsicMainAxisSize", "rowMeasurementHelper", "(Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;ILandroidx/compose/runtime/Composer;I)Landroidx/compose/ui/layout/MeasurePolicy;", "rowMeasurementMultiContentHelper", "(Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;IILandroidx/compose/foundation/layout/FlowLayoutOverflowState;Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/layout/MultiContentMeasurePolicy;", "breakDownItems", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "measurePolicy", "Landroidx/compose/foundation/layout/FlowLineMeasurePolicy;", "measurablesIterator", "", "Landroidx/compose/ui/layout/Measurable;", "mainAxisSpacingDp", "Landroidx/compose/ui/unit/Dp;", "crossAxisSpacingDp", "constraints", "Landroidx/compose/foundation/layout/OrientationIndependentConstraints;", "breakDownItems-di9J0FM", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/foundation/layout/FlowLineMeasurePolicy;Ljava/util/Iterator;FFJIILandroidx/compose/foundation/layout/FlowLayoutOverflowState;)Landroidx/compose/ui/layout/MeasureResult;", "crossAxisMin", "isHorizontal", "", "mainAxisMin", "measureAndCache", "Landroidx/compose/ui/unit/Constraints;", "storePlaceable", "Landroidx/compose/ui/layout/Placeable;", "measureAndCache-rqJ1uqs", "(Landroidx/compose/ui/layout/Measurable;Landroidx/compose/foundation/layout/FlowLineMeasurePolicy;JLkotlin/jvm/functions/Function1;)J", "placeHelper", "mainAxisTotalSize", "crossAxisTotalSize", "items", "Landroidx/compose/runtime/collection/MutableVector;", "measureHelper", "outPosition", "placeHelper-BmaY500", "(Landroidx/compose/ui/layout/MeasureScope;JII[ILandroidx/compose/runtime/collection/MutableVector;Landroidx/compose/foundation/layout/FlowLineMeasurePolicy;[I)Landroidx/compose/ui/layout/MeasureResult;", "safeNext", "info", "Landroidx/compose/foundation/layout/FlowLineInfo;", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class FlowLayoutKt {
    private static final CrossAxisAlignment CROSS_AXIS_ALIGNMENT_TOP = CrossAxisAlignment.INSTANCE.vertical$foundation_layout_release(Alignment.INSTANCE.getTop());
    private static final CrossAxisAlignment CROSS_AXIS_ALIGNMENT_START = CrossAxisAlignment.INSTANCE.horizontal$foundation_layout_release(Alignment.INSTANCE.getStart());

    public static final void FlowRow(Modifier modifier, Arrangement.Horizontal horizontal, Arrangement.Vertical vertical, int i, int i2, FlowRowOverflow flowRowOverflow, final Function3<? super FlowRowScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i3, final int i4) {
        int i5;
        Arrangement.Horizontal start;
        int i6;
        Arrangement.Vertical vertical2;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        Modifier.Companion companion;
        Arrangement.Vertical top;
        int i17;
        FlowRowOverflow clip;
        int i18;
        boolean z;
        Object objRememberedValue;
        FlowLayoutOverflowState flowLayoutOverflowState;
        FlowRowOverflow flowRowOverflow2;
        MultiContentMeasurePolicy multiContentMeasurePolicyRowMeasurementMultiContentHelper;
        boolean z2;
        boolean z3;
        boolean z4;
        Object objRememberedValue2;
        Object obj;
        boolean zChanged;
        Object objRememberedValue3;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        final Arrangement.Vertical vertical3;
        final int i19;
        Modifier modifier2;
        FlowRowOverflow flowRowOverflow3;
        final int i20;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(437853230);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(FlowRow)P(4,1,6,2,3,5)93@4089L65,96@4179L166,103@4391L261,110@4658L105:FlowLayout.kt#2w3rfo");
        int i21 = i4 & 1;
        if (i21 != 0) {
            i5 = i3 | 6;
        } else if ((i3 & 6) == 0) {
            i5 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i3;
        } else {
            i5 = i3;
        }
        int i22 = i4 & 2;
        if (i22 == 0) {
            if ((i3 & 48) == 0) {
                start = horizontal;
                i5 |= composerStartRestartGroup.changed(start) ? 32 : 16;
            }
            i6 = i4 & 4;
            if (i6 != 0) {
                if ((i3 & 384) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i7 = Fields.RotationX;
                    } else {
                        i7 = Fields.SpotShadowColor;
                    }
                    i5 |= i7;
                }
                i8 = i4 & 8;
                if (i8 != 0) {
                    if ((i3 & 3072) == 0) {
                        i9 = i;
                        if (composerStartRestartGroup.changed(i9)) {
                            i10 = Fields.CameraDistance;
                        } else {
                            i10 = Fields.RotationZ;
                        }
                        i5 |= i10;
                    }
                    i11 = i4 & 16;
                    if (i11 != 0) {
                        if ((i3 & 24576) == 0) {
                            i12 = i2;
                            if (composerStartRestartGroup.changed(i12)) {
                                i13 = Fields.Clip;
                            } else {
                                i13 = Fields.Shape;
                            }
                            i5 |= i13;
                        }
                        i14 = i4 & 32;
                        if (i14 != 0) {
                            i5 |= 196608;
                        } else if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(flowRowOverflow)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i5 |= i15;
                        }
                        if ((i4 & 64) != 0) {
                            i5 |= 1572864;
                        } else if ((i3 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i16 = 1048576;
                            } else {
                                i16 = 524288;
                            }
                            i5 |= i16;
                        }
                        if ((i5 & 599187) == 599186 || !composerStartRestartGroup.getSkipping()) {
                            if (i21 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i22 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            }
                            if (i6 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if (i8 != 0) {
                                i17 = Integer.MAX_VALUE;
                            } else {
                                i17 = i9;
                            }
                            int i23 = i11 == 0 ? i12 : Integer.MAX_VALUE;
                            if (i14 != 0) {
                                clip = FlowRowOverflow.INSTANCE.getClip();
                            } else {
                                clip = flowRowOverflow;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                            i18 = i5 & 458752;
                            if (i18 == 131072) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            Arrangement.Vertical vertical4 = top;
                            int i24 = i23;
                            int i25 = i17;
                            flowRowOverflow2 = clip;
                            multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                            if (i18 == 131072) {
                                z2 = true;
                            } else {
                                z2 = false;
                            }
                            if ((3670016 & i5) == 1048576) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z3 | z2;
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z4 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                obj = objRememberedValue2;
                                ArrayList arrayList = new ArrayList();
                                arrayList.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj2, Object obj3) {
                                        invoke((Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i26) {
                                        ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                        if ((i26 & 3) == 2 && composer2.getSkipping()) {
                                            composer2.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(-139531073, i26, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                        }
                                        function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }));
                                flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList);
                                composerStartRestartGroup.updateRememberedValue(arrayList);
                                obj = arrayList;
                            }
                            obj = objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                            Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts = LayoutKt.combineAsVirtualLayouts((List) obj);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            MeasurePolicy measurePolicy = (MeasurePolicy) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                            constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(constructor);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (!composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            function2CombineAsVirtualLayouts.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            vertical3 = vertical4;
                            i19 = i25;
                            modifier2 = companion;
                            flowRowOverflow3 = flowRowOverflow2;
                            i20 = i24;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier2 = modifier;
                            flowRowOverflow3 = flowRowOverflow;
                            vertical3 = vertical2;
                            i19 = i9;
                            i20 = i12;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = modifier2;
                            final Arrangement.Horizontal horizontal2 = start;
                            final FlowRowOverflow flowRowOverflow4 = flowRowOverflow3;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i26) {
                                    FlowLayoutKt.FlowRow(modifier3, horizontal2, vertical3, i19, i20, flowRowOverflow4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                                }
                            });
                        }
                    }
                    i5 |= 24576;
                    i12 = i2;
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowRowOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical5 = top;
                        int i26 = i23;
                        int i27 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList2 = new ArrayList();
                            arrayList2.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i28) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i28 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i28, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList2);
                            composerStartRestartGroup.updateRememberedValue(arrayList2);
                            obj = arrayList2;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList3 = new ArrayList();
                            arrayList3.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i28) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i28 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i28, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList3);
                            composerStartRestartGroup.updateRememberedValue(arrayList3);
                            obj = arrayList3;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts2 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy2 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts2.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical5;
                        i19 = i27;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i26;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical6 = top;
                        int i28 = i23;
                        int i29 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList4 = new ArrayList();
                            arrayList4.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i210) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i210 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i210, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList4);
                            composerStartRestartGroup.updateRememberedValue(arrayList4);
                            obj = arrayList4;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList5 = new ArrayList();
                            arrayList5.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i210) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i210 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i210, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList5);
                            composerStartRestartGroup.updateRememberedValue(arrayList5);
                            obj = arrayList5;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts3 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy3 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts3.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical6;
                        i19 = i29;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i28;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = modifier2;
                        final Arrangement.Horizontal horizontal3 = start;
                        final FlowRowOverflow flowRowOverflow5 = flowRowOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i210) {
                                FlowLayoutKt.FlowRow(modifier4, horizontal3, vertical3, i19, i20, flowRowOverflow5, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 3072;
                i9 = i;
                i11 = i4 & 16;
                if (i11 != 0) {
                    if ((i3 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowRowOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical7 = top;
                        int i210 = i23;
                        int i211 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList6 = new ArrayList();
                            arrayList6.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i212) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i212 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i212, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList6);
                            composerStartRestartGroup.updateRememberedValue(arrayList6);
                            obj = arrayList6;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList7 = new ArrayList();
                            arrayList7.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i212) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i212 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i212, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList7);
                            composerStartRestartGroup.updateRememberedValue(arrayList7);
                            obj = arrayList7;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts4 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy4 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy4, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts4.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical7;
                        i19 = i211;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i210;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical8 = top;
                        int i212 = i23;
                        int i213 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList8 = new ArrayList();
                            arrayList8.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i214) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i214 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i214, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList8);
                            composerStartRestartGroup.updateRememberedValue(arrayList8);
                            obj = arrayList8;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList9 = new ArrayList();
                            arrayList9.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i214) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i214 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i214, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList9);
                            composerStartRestartGroup.updateRememberedValue(arrayList9);
                            obj = arrayList9;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts5 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy5 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy5, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap5, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier5, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical8;
                        i19 = i213;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i212;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = modifier2;
                        final Arrangement.Horizontal horizontal4 = start;
                        final FlowRowOverflow flowRowOverflow6 = flowRowOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i214) {
                                FlowLayoutKt.FlowRow(modifier5, horizontal4, vertical3, i19, i20, flowRowOverflow6, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i12 = i2;
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowRowOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical9 = top;
                    int i214 = i23;
                    int i215 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList10 = new ArrayList();
                        arrayList10.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i216) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i216 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i216, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList10);
                        composerStartRestartGroup.updateRememberedValue(arrayList10);
                        obj = arrayList10;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11 = new ArrayList();
                        arrayList11.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i216) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i216 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i216, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11);
                        composerStartRestartGroup.updateRememberedValue(arrayList11);
                        obj = arrayList11;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts6 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy6 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy6, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap6, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier6, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts6.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical9;
                    i19 = i215;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i214;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical10 = top;
                    int i216 = i23;
                    int i217 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList12 = new ArrayList();
                        arrayList12.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i218) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i218 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i218, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList12);
                        composerStartRestartGroup.updateRememberedValue(arrayList12);
                        obj = arrayList12;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList13 = new ArrayList();
                        arrayList13.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i218) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i218 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i218, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList13);
                        composerStartRestartGroup.updateRememberedValue(arrayList13);
                        obj = arrayList13;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts7 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy7 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy7, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap7, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier7, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts7.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical10;
                    i19 = i217;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i216;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = modifier2;
                    final Arrangement.Horizontal horizontal5 = start;
                    final FlowRowOverflow flowRowOverflow7 = flowRowOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i218) {
                            FlowLayoutKt.FlowRow(modifier6, horizontal5, vertical3, i19, i20, flowRowOverflow7, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 384;
            vertical2 = vertical;
            i8 = i4 & 8;
            if (i8 != 0) {
                if ((i3 & 3072) == 0) {
                    i9 = i;
                    if (composerStartRestartGroup.changed(i9)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i5 |= i10;
                }
                i11 = i4 & 16;
                if (i11 != 0) {
                    if ((i3 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowRowOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical11 = top;
                        int i218 = i23;
                        int i219 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList14 = new ArrayList();
                            arrayList14.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2110) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i2110 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i2110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList14);
                            composerStartRestartGroup.updateRememberedValue(arrayList14);
                            obj = arrayList14;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList15 = new ArrayList();
                            arrayList15.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2110) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i2110 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i2110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList15);
                            composerStartRestartGroup.updateRememberedValue(arrayList15);
                            obj = arrayList15;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts8 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy8 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy8, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap8, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier8, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts8.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical11;
                        i19 = i219;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i218;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical12 = top;
                        int i2110 = i23;
                        int i2111 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList16 = new ArrayList();
                            arrayList16.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2112) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i2112 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i2112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList16);
                            composerStartRestartGroup.updateRememberedValue(arrayList16);
                            obj = arrayList16;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList17 = new ArrayList();
                            arrayList17.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2112) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i2112 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i2112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList17);
                            composerStartRestartGroup.updateRememberedValue(arrayList17);
                            obj = arrayList17;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts9 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy9 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy9, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap9, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier9, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts9.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical12;
                        i19 = i2111;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i2110;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = modifier2;
                        final Arrangement.Horizontal horizontal6 = start;
                        final FlowRowOverflow flowRowOverflow8 = flowRowOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2112) {
                                FlowLayoutKt.FlowRow(modifier7, horizontal6, vertical3, i19, i20, flowRowOverflow8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i12 = i2;
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowRowOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical13 = top;
                    int i2112 = i23;
                    int i2113 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList18 = new ArrayList();
                        arrayList18.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2114) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList18);
                        composerStartRestartGroup.updateRememberedValue(arrayList18);
                        obj = arrayList18;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList19 = new ArrayList();
                        arrayList19.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2114) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList19);
                        composerStartRestartGroup.updateRememberedValue(arrayList19);
                        obj = arrayList19;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts10 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy10 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy10, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap10, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier10, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts10.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical13;
                    i19 = i2113;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i2112;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical14 = top;
                    int i2114 = i23;
                    int i2115 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList110 = new ArrayList();
                        arrayList110.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2116) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList110);
                        composerStartRestartGroup.updateRememberedValue(arrayList110);
                        obj = arrayList110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList111 = new ArrayList();
                        arrayList111.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2116) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111);
                        composerStartRestartGroup.updateRememberedValue(arrayList111);
                        obj = arrayList111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts11 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy11 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy11, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap11, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier11, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts11.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical14;
                    i19 = i2115;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i2114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = modifier2;
                    final Arrangement.Horizontal horizontal7 = start;
                    final FlowRowOverflow flowRowOverflow9 = flowRowOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2116) {
                            FlowLayoutKt.FlowRow(modifier8, horizontal7, vertical3, i19, i20, flowRowOverflow9, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            i9 = i;
            i11 = i4 & 16;
            if (i11 != 0) {
                if ((i3 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i5 |= i13;
                }
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowRowOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical15 = top;
                    int i2116 = i23;
                    int i2117 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList112 = new ArrayList();
                        arrayList112.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2118) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2118 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList112);
                        composerStartRestartGroup.updateRememberedValue(arrayList112);
                        obj = arrayList112;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList113 = new ArrayList();
                        arrayList113.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2118) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2118 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList113);
                        composerStartRestartGroup.updateRememberedValue(arrayList113);
                        obj = arrayList113;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts12 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy12 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy12, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap12, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier12, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts12.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical15;
                    i19 = i2117;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i2116;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical16 = top;
                    int i2118 = i23;
                    int i2119 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList114 = new ArrayList();
                        arrayList114.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21110) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i21110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i21110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList114);
                        composerStartRestartGroup.updateRememberedValue(arrayList114);
                        obj = arrayList114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList115 = new ArrayList();
                        arrayList115.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21110) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i21110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i21110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList115);
                        composerStartRestartGroup.updateRememberedValue(arrayList115);
                        obj = arrayList115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts13 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy13 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy13, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap13, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier13, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts13.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical16;
                    i19 = i2119;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i2118;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = modifier2;
                    final Arrangement.Horizontal horizontal8 = start;
                    final FlowRowOverflow flowRowOverflow10 = flowRowOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21110) {
                            FlowLayoutKt.FlowRow(modifier9, horizontal8, vertical3, i19, i20, flowRowOverflow10, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i12 = i2;
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowRowOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical17 = top;
                int i21110 = i23;
                int i21111 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList116 = new ArrayList();
                    arrayList116.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21112) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList116);
                    composerStartRestartGroup.updateRememberedValue(arrayList116);
                    obj = arrayList116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList117 = new ArrayList();
                    arrayList117.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21112) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList117);
                    composerStartRestartGroup.updateRememberedValue(arrayList117);
                    obj = arrayList117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts14 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy14 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy14, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap14, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier14, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts14.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical17;
                i19 = i21111;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i21110;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical18 = top;
                int i21112 = i23;
                int i21113 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList118 = new ArrayList();
                    arrayList118.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21114) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21114 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList118);
                    composerStartRestartGroup.updateRememberedValue(arrayList118);
                    obj = arrayList118;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList119 = new ArrayList();
                    arrayList119.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21114) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21114 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList119);
                    composerStartRestartGroup.updateRememberedValue(arrayList119);
                    obj = arrayList119;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts15 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy15 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy15, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap15, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier15, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts15.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical18;
                i19 = i21113;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i21112;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = modifier2;
                final Arrangement.Horizontal horizontal9 = start;
                final FlowRowOverflow flowRowOverflow11 = flowRowOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21114) {
                        FlowLayoutKt.FlowRow(modifier10, horizontal9, vertical3, i19, i20, flowRowOverflow11, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 48;
        start = horizontal;
        i6 = i4 & 4;
        if (i6 != 0) {
            if ((i3 & 384) == 0) {
                vertical2 = vertical;
                if (composerStartRestartGroup.changed(vertical2)) {
                    i7 = Fields.RotationX;
                } else {
                    i7 = Fields.SpotShadowColor;
                }
                i5 |= i7;
            }
            i8 = i4 & 8;
            if (i8 != 0) {
                if ((i3 & 3072) == 0) {
                    i9 = i;
                    if (composerStartRestartGroup.changed(i9)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i5 |= i10;
                }
                i11 = i4 & 16;
                if (i11 != 0) {
                    if ((i3 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowRowOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical19 = top;
                        int i21114 = i23;
                        int i21115 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1110 = new ArrayList();
                            arrayList1110.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21116) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i21116 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i21116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1110);
                            composerStartRestartGroup.updateRememberedValue(arrayList1110);
                            obj = arrayList1110;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1111 = new ArrayList();
                            arrayList1111.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21116) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i21116 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i21116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111);
                            composerStartRestartGroup.updateRememberedValue(arrayList1111);
                            obj = arrayList1111;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts16 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy16 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap16 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier16 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy16, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap16, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier16, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts16.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical19;
                        i19 = i21115;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i21114;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i6 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Vertical vertical110 = top;
                        int i21116 = i23;
                        int i21117 = i17;
                        flowRowOverflow2 = clip;
                        multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1112 = new ArrayList();
                            arrayList1112.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21118) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i21118 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i21118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1112);
                            composerStartRestartGroup.updateRememberedValue(arrayList1112);
                            obj = arrayList1112;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1113 = new ArrayList();
                            arrayList1113.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21118) {
                                    ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                    if ((i21118 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-139531073, i21118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                    }
                                    function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1113);
                            composerStartRestartGroup.updateRememberedValue(arrayList1113);
                            obj = arrayList1113;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts17 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy17 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap17 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier17 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy17, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap17, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier17, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts17.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical3 = vertical110;
                        i19 = i21117;
                        modifier2 = companion;
                        flowRowOverflow3 = flowRowOverflow2;
                        i20 = i21116;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = modifier2;
                        final Arrangement.Horizontal horizontal10 = start;
                        final FlowRowOverflow flowRowOverflow12 = flowRowOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21118) {
                                FlowLayoutKt.FlowRow(modifier11, horizontal10, vertical3, i19, i20, flowRowOverflow12, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i12 = i2;
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowRowOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical111 = top;
                    int i21118 = i23;
                    int i21119 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1114 = new ArrayList();
                        arrayList1114.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211110) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1114);
                        composerStartRestartGroup.updateRememberedValue(arrayList1114);
                        obj = arrayList1114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1115 = new ArrayList();
                        arrayList1115.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211110) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1115);
                        composerStartRestartGroup.updateRememberedValue(arrayList1115);
                        obj = arrayList1115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts18 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy18 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap18 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier18 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy18, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap18, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier18, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts18.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical111;
                    i19 = i21119;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i21118;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical112 = top;
                    int i211110 = i23;
                    int i211111 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1116 = new ArrayList();
                        arrayList1116.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211112) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1116);
                        composerStartRestartGroup.updateRememberedValue(arrayList1116);
                        obj = arrayList1116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1117 = new ArrayList();
                        arrayList1117.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211112) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1117);
                        composerStartRestartGroup.updateRememberedValue(arrayList1117);
                        obj = arrayList1117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts19 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy19 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap19 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier19 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy19, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap19, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier19, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts19.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical112;
                    i19 = i211111;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i211110;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = modifier2;
                    final Arrangement.Horizontal horizontal11 = start;
                    final FlowRowOverflow flowRowOverflow13 = flowRowOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211112) {
                            FlowLayoutKt.FlowRow(modifier12, horizontal11, vertical3, i19, i20, flowRowOverflow13, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            i9 = i;
            i11 = i4 & 16;
            if (i11 != 0) {
                if ((i3 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i5 |= i13;
                }
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowRowOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical113 = top;
                    int i211112 = i23;
                    int i211113 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1118 = new ArrayList();
                        arrayList1118.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211114) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1118);
                        composerStartRestartGroup.updateRememberedValue(arrayList1118);
                        obj = arrayList1118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1119 = new ArrayList();
                        arrayList1119.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211114) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1119);
                        composerStartRestartGroup.updateRememberedValue(arrayList1119);
                        obj = arrayList1119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts110 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy110 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap110 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier110 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy110, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap110, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier110, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts110.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical113;
                    i19 = i211113;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i211112;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical114 = top;
                    int i211114 = i23;
                    int i211115 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11110 = new ArrayList();
                        arrayList11110.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211116) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11110);
                        composerStartRestartGroup.updateRememberedValue(arrayList11110);
                        obj = arrayList11110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11111 = new ArrayList();
                        arrayList11111.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211116) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i211116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i211116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11111);
                        composerStartRestartGroup.updateRememberedValue(arrayList11111);
                        obj = arrayList11111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts111 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy111 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap111 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier111 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy111, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap111, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier111, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts111.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical114;
                    i19 = i211115;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i211114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = modifier2;
                    final Arrangement.Horizontal horizontal12 = start;
                    final FlowRowOverflow flowRowOverflow14 = flowRowOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211116) {
                            FlowLayoutKt.FlowRow(modifier13, horizontal12, vertical3, i19, i20, flowRowOverflow14, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i12 = i2;
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowRowOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical115 = top;
                int i211116 = i23;
                int i211117 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11112 = new ArrayList();
                    arrayList11112.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211118) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i211118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i211118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11112);
                    composerStartRestartGroup.updateRememberedValue(arrayList11112);
                    obj = arrayList11112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11113 = new ArrayList();
                    arrayList11113.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211118) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i211118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i211118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11113);
                    composerStartRestartGroup.updateRememberedValue(arrayList11113);
                    obj = arrayList11113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts112 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy112 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap112 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier112 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy112, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap112, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier112, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts112.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical115;
                i19 = i211117;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i211116;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical116 = top;
                int i211118 = i23;
                int i211119 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11114 = new ArrayList();
                    arrayList11114.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111110) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i2111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i2111110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11114);
                    composerStartRestartGroup.updateRememberedValue(arrayList11114);
                    obj = arrayList11114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11115 = new ArrayList();
                    arrayList11115.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111110) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i2111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i2111110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11115);
                    composerStartRestartGroup.updateRememberedValue(arrayList11115);
                    obj = arrayList11115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts113 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy113 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap113 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier113 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy113, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap113, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier113, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts113.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical116;
                i19 = i211119;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i211118;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier14 = modifier2;
                final Arrangement.Horizontal horizontal13 = start;
                final FlowRowOverflow flowRowOverflow15 = flowRowOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111110) {
                        FlowLayoutKt.FlowRow(modifier14, horizontal13, vertical3, i19, i20, flowRowOverflow15, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 384;
        vertical2 = vertical;
        i8 = i4 & 8;
        if (i8 != 0) {
            if ((i3 & 3072) == 0) {
                i9 = i;
                if (composerStartRestartGroup.changed(i9)) {
                    i10 = Fields.CameraDistance;
                } else {
                    i10 = Fields.RotationZ;
                }
                i5 |= i10;
            }
            i11 = i4 & 16;
            if (i11 != 0) {
                if ((i3 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i5 |= i13;
                }
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowRowOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical117 = top;
                    int i2111110 = i23;
                    int i2111111 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11116 = new ArrayList();
                        arrayList11116.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111112) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2111112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2111112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11116);
                        composerStartRestartGroup.updateRememberedValue(arrayList11116);
                        obj = arrayList11116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11117 = new ArrayList();
                        arrayList11117.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111112) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2111112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2111112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11117);
                        composerStartRestartGroup.updateRememberedValue(arrayList11117);
                        obj = arrayList11117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts114 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy114 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap114 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier114 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy114, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap114, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier114, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts114.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical117;
                    i19 = i2111111;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i2111110;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i6 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Vertical vertical118 = top;
                    int i2111112 = i23;
                    int i2111113 = i17;
                    flowRowOverflow2 = clip;
                    multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11118 = new ArrayList();
                        arrayList11118.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111114) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2111114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2111114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11118);
                        composerStartRestartGroup.updateRememberedValue(arrayList11118);
                        obj = arrayList11118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11119 = new ArrayList();
                        arrayList11119.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111114) {
                                ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                                if ((i2111114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-139531073, i2111114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                                }
                                function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11119);
                        composerStartRestartGroup.updateRememberedValue(arrayList11119);
                        obj = arrayList11119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts115 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy115 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap115 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier115 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy115, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap115, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier115, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts115.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical3 = vertical118;
                    i19 = i2111113;
                    modifier2 = companion;
                    flowRowOverflow3 = flowRowOverflow2;
                    i20 = i2111112;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = modifier2;
                    final Arrangement.Horizontal horizontal14 = start;
                    final FlowRowOverflow flowRowOverflow16 = flowRowOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111114) {
                            FlowLayoutKt.FlowRow(modifier15, horizontal14, vertical3, i19, i20, flowRowOverflow16, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i12 = i2;
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowRowOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical119 = top;
                int i2111114 = i23;
                int i2111115 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111110 = new ArrayList();
                    arrayList111110.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111116) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i2111116 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i2111116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111110);
                    composerStartRestartGroup.updateRememberedValue(arrayList111110);
                    obj = arrayList111110;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111111 = new ArrayList();
                    arrayList111111.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111116) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i2111116 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i2111116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111111);
                    composerStartRestartGroup.updateRememberedValue(arrayList111111);
                    obj = arrayList111111;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts116 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy116 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap116 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier116 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy116, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap116, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier116, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts116.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical119;
                i19 = i2111115;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i2111114;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical1110 = top;
                int i2111116 = i23;
                int i2111117 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111112 = new ArrayList();
                    arrayList111112.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111118) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i2111118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i2111118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111112);
                    composerStartRestartGroup.updateRememberedValue(arrayList111112);
                    obj = arrayList111112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111113 = new ArrayList();
                    arrayList111113.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111118) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i2111118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i2111118, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111113);
                    composerStartRestartGroup.updateRememberedValue(arrayList111113);
                    obj = arrayList111113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts117 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy117 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap117 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier117 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy117, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap117, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier117, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts117.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical1110;
                i19 = i2111117;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i2111116;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = modifier2;
                final Arrangement.Horizontal horizontal15 = start;
                final FlowRowOverflow flowRowOverflow17 = flowRowOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111118) {
                        FlowLayoutKt.FlowRow(modifier16, horizontal15, vertical3, i19, i20, flowRowOverflow17, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 3072;
        i9 = i;
        i11 = i4 & 16;
        if (i11 != 0) {
            if ((i3 & 24576) == 0) {
                i12 = i2;
                if (composerStartRestartGroup.changed(i12)) {
                    i13 = Fields.Clip;
                } else {
                    i13 = Fields.Shape;
                }
                i5 |= i13;
            }
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowRowOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical1111 = top;
                int i2111118 = i23;
                int i2111119 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111114 = new ArrayList();
                    arrayList111114.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111110) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21111110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111114);
                    composerStartRestartGroup.updateRememberedValue(arrayList111114);
                    obj = arrayList111114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111115 = new ArrayList();
                    arrayList111115.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111110) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21111110, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111115);
                    composerStartRestartGroup.updateRememberedValue(arrayList111115);
                    obj = arrayList111115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts118 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy118 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap118 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier118 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy118, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap118, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier118, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts118.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical1111;
                i19 = i2111119;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i2111118;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i6 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = flowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Vertical vertical1112 = top;
                int i21111110 = i23;
                int i21111111 = i17;
                flowRowOverflow2 = clip;
                multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111116 = new ArrayList();
                    arrayList111116.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111112) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21111112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21111112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111116);
                    composerStartRestartGroup.updateRememberedValue(arrayList111116);
                    obj = arrayList111116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111117 = new ArrayList();
                    arrayList111117.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111112) {
                            ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                            if ((i21111112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-139531073, i21111112, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                            }
                            function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111117);
                    composerStartRestartGroup.updateRememberedValue(arrayList111117);
                    obj = arrayList111117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts119 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy119 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap119 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier119 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy119, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap119, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier119, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts119.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical3 = vertical1112;
                i19 = i21111111;
                modifier2 = companion;
                flowRowOverflow3 = flowRowOverflow2;
                i20 = i21111110;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = modifier2;
                final Arrangement.Horizontal horizontal16 = start;
                final FlowRowOverflow flowRowOverflow18 = flowRowOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111112) {
                        FlowLayoutKt.FlowRow(modifier17, horizontal16, vertical3, i19, i20, flowRowOverflow18, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 24576;
        i12 = i2;
        i14 = i4 & 32;
        if (i14 != 0) {
            i5 |= 196608;
        } else if ((i3 & 196608) == 0) {
            if (composerStartRestartGroup.changed(flowRowOverflow)) {
                i15 = Fields.RenderEffect;
            } else {
                i15 = 65536;
            }
            i5 |= i15;
        }
        if ((i4 & 64) != 0) {
            i5 |= 1572864;
        } else if ((i3 & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i16 = 1048576;
            } else {
                i16 = 524288;
            }
            i5 |= i16;
        }
        if ((i5 & 599187) == 599186) {
            if (i21 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier;
            }
            if (i22 != 0) {
                start = Arrangement.INSTANCE.getStart();
            }
            if (i6 != 0) {
                top = Arrangement.INSTANCE.getTop();
            } else {
                top = vertical2;
            }
            if (i8 != 0) {
                i17 = Integer.MAX_VALUE;
            } else {
                i17 = i9;
            }
            if (i11 == 0) {
            }
            if (i14 != 0) {
                clip = FlowRowOverflow.INSTANCE.getClip();
            } else {
                clip = flowRowOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
            i18 = i5 & 458752;
            if (i18 == 131072) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Arrangement.Vertical vertical1113 = top;
            int i21111112 = i23;
            int i21111113 = i17;
            flowRowOverflow2 = clip;
            multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
            if (i18 == 131072) {
                z2 = true;
            } else {
                z2 = false;
            }
            if ((3670016 & i5) == 1048576) {
                z3 = true;
            } else {
                z3 = false;
            }
            z4 = z3 | z2;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                obj = objRememberedValue2;
                ArrayList arrayList111118 = new ArrayList();
                arrayList111118.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111114) {
                        ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                        if ((i21111114 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-139531073, i21111114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                        }
                        function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111118);
                composerStartRestartGroup.updateRememberedValue(arrayList111118);
                obj = arrayList111118;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList111119 = new ArrayList();
                arrayList111119.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111114) {
                        ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                        if ((i21111114 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-139531073, i21111114, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                        }
                        function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111119);
                composerStartRestartGroup.updateRememberedValue(arrayList111119);
                obj = arrayList111119;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
            Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts1110 = LayoutKt.combineAsVirtualLayouts((List) obj);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            MeasurePolicy measurePolicy1110 = (MeasurePolicy) objRememberedValue3;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap1110 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier1110 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy1110, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap1110, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier1110, ComposeUiNode.INSTANCE.getSetModifier());
            function2CombineAsVirtualLayouts1110.invoke(composerStartRestartGroup, 0);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            vertical3 = vertical1113;
            i19 = i21111113;
            modifier2 = companion;
            flowRowOverflow3 = flowRowOverflow2;
            i20 = i21111112;
        } else {
            if (i21 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier;
            }
            if (i22 != 0) {
                start = Arrangement.INSTANCE.getStart();
            }
            if (i6 != 0) {
                top = Arrangement.INSTANCE.getTop();
            } else {
                top = vertical2;
            }
            if (i8 != 0) {
                i17 = Integer.MAX_VALUE;
            } else {
                i17 = i9;
            }
            if (i11 == 0) {
            }
            if (i14 != 0) {
                clip = FlowRowOverflow.INSTANCE.getClip();
            } else {
                clip = flowRowOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(437853230, i5, -1, "androidx.compose.foundation.layout.FlowRow (FlowLayout.kt:92)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454955587, "CC(remember):FlowLayout.kt#9igjgp");
            i18 = i5 & 458752;
            if (i18 == 131072) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Arrangement.Vertical vertical1114 = top;
            int i21111114 = i23;
            int i21111115 = i17;
            flowRowOverflow2 = clip;
            multiContentMeasurePolicyRowMeasurementMultiContentHelper = rowMeasurementMultiContentHelper(start, top, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 454965447, "CC(remember):FlowLayout.kt#9igjgp");
            if (i18 == 131072) {
                z2 = true;
            } else {
                z2 = false;
            }
            if ((3670016 & i5) == 1048576) {
                z3 = true;
            } else {
                z3 = false;
            }
            z4 = z3 | z2;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                obj = objRememberedValue2;
                ArrayList arrayList1111110 = new ArrayList();
                arrayList1111110.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111116) {
                        ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                        if ((i21111116 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-139531073, i21111116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                        }
                        function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111110);
                composerStartRestartGroup.updateRememberedValue(arrayList1111110);
                obj = arrayList1111110;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList1111111 = new ArrayList();
                arrayList1111111.add(ComposableLambdaKt.composableLambdaInstance(-139531073, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111116) {
                        ComposerKt.sourceInformation(composer2, "C105@4547L9:FlowLayout.kt#2w3rfo");
                        if ((i21111116 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-139531073, i21111116, -1, "androidx.compose.foundation.layout.FlowRow.<anonymous>.<anonymous> (FlowLayout.kt:105)");
                        }
                        function3.invoke(FlowRowScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowRowOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111111);
                composerStartRestartGroup.updateRememberedValue(arrayList1111111);
                obj = arrayList1111111;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
            Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts1111 = LayoutKt.combineAsVirtualLayouts((List) obj);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyRowMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            MeasurePolicy measurePolicy1111 = (MeasurePolicy) objRememberedValue3;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap1111 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier1111 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy1111, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap1111, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier1111, ComposeUiNode.INSTANCE.getSetModifier());
            function2CombineAsVirtualLayouts1111.invoke(composerStartRestartGroup, 0);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            vertical3 = vertical1114;
            i19 = i21111115;
            modifier2 = companion;
            flowRowOverflow3 = flowRowOverflow2;
            i20 = i21111114;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier18 = modifier2;
            final Arrangement.Horizontal horizontal17 = start;
            final FlowRowOverflow flowRowOverflow19 = flowRowOverflow3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i21111116) {
                    FlowLayoutKt.FlowRow(modifier18, horizontal17, vertical3, i19, i20, flowRowOverflow19, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                }
            });
        }
    }

    public static final void FlowColumn(Modifier modifier, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, int i, int i2, FlowColumnOverflow flowColumnOverflow, final Function3<? super FlowColumnScope, ? super Composer, ? super Integer, Unit> function3, Composer composer, final int i3, final int i4) {
        int i5;
        Arrangement.Vertical top;
        int i6;
        Arrangement.Horizontal horizontal2;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        Modifier.Companion companion;
        Arrangement.Horizontal start;
        int i17;
        FlowColumnOverflow clip;
        int i18;
        boolean z;
        Object objRememberedValue;
        FlowLayoutOverflowState flowLayoutOverflowState;
        FlowColumnOverflow flowColumnOverflow2;
        MultiContentMeasurePolicy multiContentMeasurePolicyColumnMeasurementMultiContentHelper;
        boolean z2;
        boolean z3;
        boolean z4;
        Object objRememberedValue2;
        Object obj;
        boolean zChanged;
        Object objRememberedValue3;
        int currentCompositeKeyHash;
        Function0<ComposeUiNode> constructor;
        Composer composerM4037constructorimpl;
        Function2<ComposeUiNode, Integer, Unit> setCompositeKeyHash;
        final Arrangement.Horizontal horizontal3;
        final int i19;
        Modifier modifier2;
        FlowColumnOverflow flowColumnOverflow3;
        final int i20;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-1704849416);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(FlowColumn)P(4,6,1,2,3,5)157@6483L65,160@6573L172,167@6791L264,173@7060L105:FlowLayout.kt#2w3rfo");
        int i21 = i4 & 1;
        if (i21 != 0) {
            i5 = i3 | 6;
        } else if ((i3 & 6) == 0) {
            i5 = (composerStartRestartGroup.changed(modifier) ? 4 : 2) | i3;
        } else {
            i5 = i3;
        }
        int i22 = i4 & 2;
        if (i22 == 0) {
            if ((i3 & 48) == 0) {
                top = vertical;
                i5 |= composerStartRestartGroup.changed(top) ? 32 : 16;
            }
            i6 = i4 & 4;
            if (i6 != 0) {
                if ((i3 & 384) == 0) {
                    horizontal2 = horizontal;
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i7 = Fields.RotationX;
                    } else {
                        i7 = Fields.SpotShadowColor;
                    }
                    i5 |= i7;
                }
                i8 = i4 & 8;
                if (i8 != 0) {
                    if ((i3 & 3072) == 0) {
                        i9 = i;
                        if (composerStartRestartGroup.changed(i9)) {
                            i10 = Fields.CameraDistance;
                        } else {
                            i10 = Fields.RotationZ;
                        }
                        i5 |= i10;
                    }
                    i11 = i4 & 16;
                    if (i11 != 0) {
                        if ((i3 & 24576) == 0) {
                            i12 = i2;
                            if (composerStartRestartGroup.changed(i12)) {
                                i13 = Fields.Clip;
                            } else {
                                i13 = Fields.Shape;
                            }
                            i5 |= i13;
                        }
                        i14 = i4 & 32;
                        if (i14 != 0) {
                            i5 |= 196608;
                        } else if ((i3 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i5 |= i15;
                        }
                        if ((i4 & 64) != 0) {
                            i5 |= 1572864;
                        } else if ((i3 & 1572864) == 0) {
                            if (composerStartRestartGroup.changedInstance(function3)) {
                                i16 = 1048576;
                            } else {
                                i16 = 524288;
                            }
                            i5 |= i16;
                        }
                        if ((i5 & 599187) == 599186 || !composerStartRestartGroup.getSkipping()) {
                            if (i21 != 0) {
                                companion = Modifier.INSTANCE;
                            } else {
                                companion = modifier;
                            }
                            if (i22 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            }
                            if (i6 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if (i8 != 0) {
                                i17 = Integer.MAX_VALUE;
                            } else {
                                i17 = i9;
                            }
                            int i23 = i11 == 0 ? i12 : Integer.MAX_VALUE;
                            if (i14 != 0) {
                                clip = FlowColumnOverflow.INSTANCE.getClip();
                            } else {
                                clip = flowColumnOverflow;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                            i18 = i5 & 458752;
                            if (i18 == 131072) {
                                z = true;
                            } else {
                                z = false;
                            }
                            objRememberedValue = composerStartRestartGroup.rememberedValue();
                            if (!z || objRememberedValue == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                            }
                            flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            Arrangement.Horizontal horizontal4 = start;
                            int i24 = i23;
                            int i25 = i17;
                            flowColumnOverflow2 = clip;
                            multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                            if (i18 == 131072) {
                                z2 = true;
                            } else {
                                z2 = false;
                            }
                            if ((3670016 & i5) == 1048576) {
                                z3 = true;
                            } else {
                                z3 = false;
                            }
                            z4 = z3 | z2;
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z4 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                obj = objRememberedValue2;
                                ArrayList arrayList = new ArrayList();
                                arrayList.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                    {
                                        super(2);
                                    }

                                    public Object invoke(Object obj2, Object obj3) {
                                        invoke((Composer) obj2, ((Number) obj3).intValue());
                                        return Unit.INSTANCE;
                                    }

                                    public final void invoke(Composer composer2, int i26) {
                                        ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                        if ((i26 & 3) == 2 && composer2.getSkipping()) {
                                            composer2.skipToGroupEnd();
                                            return;
                                        }
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventStart(985886665, i26, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                        }
                                        function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                        if (ComposerKt.isTraceInProgress()) {
                                            ComposerKt.traceEventEnd();
                                        }
                                    }
                                }));
                                flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList);
                                composerStartRestartGroup.updateRememberedValue(arrayList);
                                obj = arrayList;
                            }
                            obj = objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                            Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts = LayoutKt.combineAsVirtualLayouts((List) obj);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                            zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                            if (!zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
                                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                            }
                            MeasurePolicy measurePolicy = (MeasurePolicy) objRememberedValue3;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                            CompositionLocalMap currentCompositionLocalMap = composerStartRestartGroup.getCurrentCompositionLocalMap();
                            Modifier modifierMaterializeModifier = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                            constructor = ComposeUiNode.INSTANCE.getConstructor();
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                                ComposablesKt.invalidApplier();
                            }
                            composerStartRestartGroup.startReusableNode();
                            if (composerStartRestartGroup.getInserting()) {
                                composerStartRestartGroup.createNode(constructor);
                            } else {
                                composerStartRestartGroup.useNode();
                            }
                            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                            if (!composerM4037constructorimpl.getInserting() || !Intrinsics.areEqual(composerM4037constructorimpl.rememberedValue(), Integer.valueOf(currentCompositeKeyHash))) {
                                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                            }
                            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier, ComposeUiNode.INSTANCE.getSetModifier());
                            function2CombineAsVirtualLayouts.invoke(composerStartRestartGroup, 0);
                            composerStartRestartGroup.endNode();
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            horizontal3 = horizontal4;
                            i19 = i25;
                            modifier2 = companion;
                            flowColumnOverflow3 = flowColumnOverflow2;
                            i20 = i24;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            modifier2 = modifier;
                            flowColumnOverflow3 = flowColumnOverflow;
                            horizontal3 = horizontal2;
                            i19 = i9;
                            i20 = i12;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            final Modifier modifier3 = modifier2;
                            final Arrangement.Vertical vertical2 = top;
                            final FlowColumnOverflow flowColumnOverflow4 = flowColumnOverflow3;
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i26) {
                                    FlowLayoutKt.FlowColumn(modifier3, vertical2, horizontal3, i19, i20, flowColumnOverflow4, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                                }
                            });
                        }
                    }
                    i5 |= 24576;
                    i12 = i2;
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal5 = start;
                        int i26 = i23;
                        int i27 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList2 = new ArrayList();
                            arrayList2.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i28) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i28 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i28, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList2);
                            composerStartRestartGroup.updateRememberedValue(arrayList2);
                            obj = arrayList2;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList3 = new ArrayList();
                            arrayList3.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i28) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i28 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i28, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList3);
                            composerStartRestartGroup.updateRememberedValue(arrayList3);
                            obj = arrayList3;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts2 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy2 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap2 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier2 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy2, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap2, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier2, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts2.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal5;
                        i19 = i27;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i26;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal6 = start;
                        int i28 = i23;
                        int i29 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList4 = new ArrayList();
                            arrayList4.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i210) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i210 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i210, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList4);
                            composerStartRestartGroup.updateRememberedValue(arrayList4);
                            obj = arrayList4;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList5 = new ArrayList();
                            arrayList5.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i210) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i210 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i210, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList5);
                            composerStartRestartGroup.updateRememberedValue(arrayList5);
                            obj = arrayList5;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts3 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy3 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap3 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier3 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy3, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap3, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier3, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts3.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal6;
                        i19 = i29;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i28;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier4 = modifier2;
                        final Arrangement.Vertical vertical3 = top;
                        final FlowColumnOverflow flowColumnOverflow5 = flowColumnOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i210) {
                                FlowLayoutKt.FlowColumn(modifier4, vertical3, horizontal3, i19, i20, flowColumnOverflow5, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 3072;
                i9 = i;
                i11 = i4 & 16;
                if (i11 != 0) {
                    if ((i3 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal7 = start;
                        int i210 = i23;
                        int i211 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList6 = new ArrayList();
                            arrayList6.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i212) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i212 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i212, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList6);
                            composerStartRestartGroup.updateRememberedValue(arrayList6);
                            obj = arrayList6;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList7 = new ArrayList();
                            arrayList7.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i212) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i212 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i212, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList7);
                            composerStartRestartGroup.updateRememberedValue(arrayList7);
                            obj = arrayList7;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts4 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy4 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap4 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier4 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy4, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap4, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier4, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts4.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal7;
                        i19 = i211;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i210;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal8 = start;
                        int i212 = i23;
                        int i213 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList8 = new ArrayList();
                            arrayList8.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i214) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i214 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i214, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList8);
                            composerStartRestartGroup.updateRememberedValue(arrayList8);
                            obj = arrayList8;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList9 = new ArrayList();
                            arrayList9.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i214) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i214 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i214, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList9);
                            composerStartRestartGroup.updateRememberedValue(arrayList9);
                            obj = arrayList9;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts5 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy5 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap5 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier5 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy5, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap5, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier5, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts5.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal8;
                        i19 = i213;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i212;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier5 = modifier2;
                        final Arrangement.Vertical vertical4 = top;
                        final FlowColumnOverflow flowColumnOverflow6 = flowColumnOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i214) {
                                FlowLayoutKt.FlowColumn(modifier5, vertical4, horizontal3, i19, i20, flowColumnOverflow6, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i12 = i2;
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal9 = start;
                    int i214 = i23;
                    int i215 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList10 = new ArrayList();
                        arrayList10.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i216) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i216 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i216, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList10);
                        composerStartRestartGroup.updateRememberedValue(arrayList10);
                        obj = arrayList10;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11 = new ArrayList();
                        arrayList11.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i216) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i216 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i216, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11);
                        composerStartRestartGroup.updateRememberedValue(arrayList11);
                        obj = arrayList11;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts6 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy6 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap6 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier6 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy6, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap6, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier6, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts6.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal9;
                    i19 = i215;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i214;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal10 = start;
                    int i216 = i23;
                    int i217 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList12 = new ArrayList();
                        arrayList12.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i218) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i218 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i218, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList12);
                        composerStartRestartGroup.updateRememberedValue(arrayList12);
                        obj = arrayList12;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList13 = new ArrayList();
                        arrayList13.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i218) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i218 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i218, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList13);
                        composerStartRestartGroup.updateRememberedValue(arrayList13);
                        obj = arrayList13;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts7 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy7 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap7 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier7 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy7, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap7, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier7, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts7.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal10;
                    i19 = i217;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i216;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier6 = modifier2;
                    final Arrangement.Vertical vertical5 = top;
                    final FlowColumnOverflow flowColumnOverflow7 = flowColumnOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i218) {
                            FlowLayoutKt.FlowColumn(modifier6, vertical5, horizontal3, i19, i20, flowColumnOverflow7, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 384;
            horizontal2 = horizontal;
            i8 = i4 & 8;
            if (i8 != 0) {
                if ((i3 & 3072) == 0) {
                    i9 = i;
                    if (composerStartRestartGroup.changed(i9)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i5 |= i10;
                }
                i11 = i4 & 16;
                if (i11 != 0) {
                    if ((i3 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal11 = start;
                        int i218 = i23;
                        int i219 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList14 = new ArrayList();
                            arrayList14.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2110) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i2110 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i2110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList14);
                            composerStartRestartGroup.updateRememberedValue(arrayList14);
                            obj = arrayList14;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList15 = new ArrayList();
                            arrayList15.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2110) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i2110 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i2110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList15);
                            composerStartRestartGroup.updateRememberedValue(arrayList15);
                            obj = arrayList15;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts8 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy8 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap8 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier8 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy8, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap8, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier8, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts8.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal11;
                        i19 = i219;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i218;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal12 = start;
                        int i2110 = i23;
                        int i2111 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList16 = new ArrayList();
                            arrayList16.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2112) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i2112 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i2112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList16);
                            composerStartRestartGroup.updateRememberedValue(arrayList16);
                            obj = arrayList16;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList17 = new ArrayList();
                            arrayList17.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i2112) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i2112 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i2112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList17);
                            composerStartRestartGroup.updateRememberedValue(arrayList17);
                            obj = arrayList17;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts9 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy9 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap9 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier9 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy9, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap9, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier9, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts9.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal12;
                        i19 = i2111;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i2110;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier7 = modifier2;
                        final Arrangement.Vertical vertical6 = top;
                        final FlowColumnOverflow flowColumnOverflow8 = flowColumnOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2112) {
                                FlowLayoutKt.FlowColumn(modifier7, vertical6, horizontal3, i19, i20, flowColumnOverflow8, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i12 = i2;
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal13 = start;
                    int i2112 = i23;
                    int i2113 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList18 = new ArrayList();
                        arrayList18.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2114) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList18);
                        composerStartRestartGroup.updateRememberedValue(arrayList18);
                        obj = arrayList18;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList19 = new ArrayList();
                        arrayList19.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2114) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList19);
                        composerStartRestartGroup.updateRememberedValue(arrayList19);
                        obj = arrayList19;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts10 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy10 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap10 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier10 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy10, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap10, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier10, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts10.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal13;
                    i19 = i2113;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i2112;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal14 = start;
                    int i2114 = i23;
                    int i2115 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList110 = new ArrayList();
                        arrayList110.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2116) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList110);
                        composerStartRestartGroup.updateRememberedValue(arrayList110);
                        obj = arrayList110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList111 = new ArrayList();
                        arrayList111.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2116) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111);
                        composerStartRestartGroup.updateRememberedValue(arrayList111);
                        obj = arrayList111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts11 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy11 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap11 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier11 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy11, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap11, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier11, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts11.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal14;
                    i19 = i2115;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i2114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier8 = modifier2;
                    final Arrangement.Vertical vertical7 = top;
                    final FlowColumnOverflow flowColumnOverflow9 = flowColumnOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2116) {
                            FlowLayoutKt.FlowColumn(modifier8, vertical7, horizontal3, i19, i20, flowColumnOverflow9, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            i9 = i;
            i11 = i4 & 16;
            if (i11 != 0) {
                if ((i3 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i5 |= i13;
                }
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal15 = start;
                    int i2116 = i23;
                    int i2117 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList112 = new ArrayList();
                        arrayList112.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2118) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2118 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList112);
                        composerStartRestartGroup.updateRememberedValue(arrayList112);
                        obj = arrayList112;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList113 = new ArrayList();
                        arrayList113.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2118) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2118 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList113);
                        composerStartRestartGroup.updateRememberedValue(arrayList113);
                        obj = arrayList113;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts12 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy12 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap12 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier12 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy12, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap12, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier12, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts12.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal15;
                    i19 = i2117;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i2116;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal16 = start;
                    int i2118 = i23;
                    int i2119 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList114 = new ArrayList();
                        arrayList114.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21110) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i21110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i21110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList114);
                        composerStartRestartGroup.updateRememberedValue(arrayList114);
                        obj = arrayList114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList115 = new ArrayList();
                        arrayList115.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21110) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i21110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i21110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList115);
                        composerStartRestartGroup.updateRememberedValue(arrayList115);
                        obj = arrayList115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts13 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy13 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap13 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier13 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy13, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap13, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier13, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts13.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal16;
                    i19 = i2119;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i2118;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier9 = modifier2;
                    final Arrangement.Vertical vertical8 = top;
                    final FlowColumnOverflow flowColumnOverflow10 = flowColumnOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21110) {
                            FlowLayoutKt.FlowColumn(modifier9, vertical8, horizontal3, i19, i20, flowColumnOverflow10, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i12 = i2;
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal17 = start;
                int i21110 = i23;
                int i21111 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList116 = new ArrayList();
                    arrayList116.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21112) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList116);
                    composerStartRestartGroup.updateRememberedValue(arrayList116);
                    obj = arrayList116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList117 = new ArrayList();
                    arrayList117.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21112) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList117);
                    composerStartRestartGroup.updateRememberedValue(arrayList117);
                    obj = arrayList117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts14 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy14 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap14 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier14 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy14, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap14, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier14, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts14.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal17;
                i19 = i21111;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i21110;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal18 = start;
                int i21112 = i23;
                int i21113 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList118 = new ArrayList();
                    arrayList118.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21114) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21114 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList118);
                    composerStartRestartGroup.updateRememberedValue(arrayList118);
                    obj = arrayList118;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList119 = new ArrayList();
                    arrayList119.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21114) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21114 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList119);
                    composerStartRestartGroup.updateRememberedValue(arrayList119);
                    obj = arrayList119;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts15 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy15 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap15 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier15 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy15, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap15, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier15, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts15.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal18;
                i19 = i21113;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i21112;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier10 = modifier2;
                final Arrangement.Vertical vertical9 = top;
                final FlowColumnOverflow flowColumnOverflow11 = flowColumnOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21114) {
                        FlowLayoutKt.FlowColumn(modifier10, vertical9, horizontal3, i19, i20, flowColumnOverflow11, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 48;
        top = vertical;
        i6 = i4 & 4;
        if (i6 != 0) {
            if ((i3 & 384) == 0) {
                horizontal2 = horizontal;
                if (composerStartRestartGroup.changed(horizontal2)) {
                    i7 = Fields.RotationX;
                } else {
                    i7 = Fields.SpotShadowColor;
                }
                i5 |= i7;
            }
            i8 = i4 & 8;
            if (i8 != 0) {
                if ((i3 & 3072) == 0) {
                    i9 = i;
                    if (composerStartRestartGroup.changed(i9)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i5 |= i10;
                }
                i11 = i4 & 16;
                if (i11 != 0) {
                    if ((i3 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i5 |= i13;
                    }
                    i14 = i4 & 32;
                    if (i14 != 0) {
                        i5 |= 196608;
                    } else if ((i3 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i5 |= i15;
                    }
                    if ((i4 & 64) != 0) {
                        i5 |= 1572864;
                    } else if ((i3 & 1572864) == 0) {
                        if (composerStartRestartGroup.changedInstance(function3)) {
                            i16 = 1048576;
                        } else {
                            i16 = 524288;
                        }
                        i5 |= i16;
                    }
                    if ((i5 & 599187) == 599186) {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal19 = start;
                        int i21114 = i23;
                        int i21115 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1110 = new ArrayList();
                            arrayList1110.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21116) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i21116 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i21116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1110);
                            composerStartRestartGroup.updateRememberedValue(arrayList1110);
                            obj = arrayList1110;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1111 = new ArrayList();
                            arrayList1111.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21116) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i21116 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i21116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111);
                            composerStartRestartGroup.updateRememberedValue(arrayList1111);
                            obj = arrayList1111;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts16 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy16 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap16 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier16 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy16, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap16, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier16, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts16.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal19;
                        i19 = i21115;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i21114;
                    } else {
                        if (i21 != 0) {
                            companion = Modifier.INSTANCE;
                        } else {
                            companion = modifier;
                        }
                        if (i22 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i6 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i8 != 0) {
                            i17 = Integer.MAX_VALUE;
                        } else {
                            i17 = i9;
                        }
                        if (i11 == 0) {
                        }
                        if (i14 != 0) {
                            clip = FlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = flowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                        i18 = i5 & 458752;
                        if (i18 == 131072) {
                            z = true;
                        } else {
                            z = false;
                        }
                        objRememberedValue = composerStartRestartGroup.rememberedValue();
                        if (!z) {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        } else {
                            objRememberedValue = clip.createOverflowState$foundation_layout_release();
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                        }
                        flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        Arrangement.Horizontal horizontal110 = start;
                        int i21116 = i23;
                        int i21117 = i17;
                        flowColumnOverflow2 = clip;
                        multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                        if (i18 == 131072) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        if ((3670016 & i5) == 1048576) {
                            z3 = true;
                        } else {
                            z3 = false;
                        }
                        z4 = z3 | z2;
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z4) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1112 = new ArrayList();
                            arrayList1112.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21118) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i21118 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i21118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1112);
                            composerStartRestartGroup.updateRememberedValue(arrayList1112);
                            obj = arrayList1112;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1113 = new ArrayList();
                            arrayList1113.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i21118) {
                                    ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                    if ((i21118 & 3) == 2 && composer2.getSkipping()) {
                                        composer2.skipToGroupEnd();
                                        return;
                                    }
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(985886665, i21118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                    }
                                    function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }));
                            flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1113);
                            composerStartRestartGroup.updateRememberedValue(arrayList1113);
                            obj = arrayList1113;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                        Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts17 = LayoutKt.combineAsVirtualLayouts((List) obj);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                        zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                        if (!zChanged) {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        } else {
                            objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                            composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                        }
                        MeasurePolicy measurePolicy17 = (MeasurePolicy) objRememberedValue3;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                        currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                        CompositionLocalMap currentCompositionLocalMap17 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                        Modifier modifierMaterializeModifier17 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                        constructor = ComposeUiNode.INSTANCE.getConstructor();
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                        if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                            ComposablesKt.invalidApplier();
                        }
                        composerStartRestartGroup.startReusableNode();
                        if (composerStartRestartGroup.getInserting()) {
                            composerStartRestartGroup.createNode(constructor);
                        } else {
                            composerStartRestartGroup.useNode();
                        }
                        composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                        Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy17, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                        Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap17, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                        setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                        if (!composerM4037constructorimpl.getInserting()) {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        } else {
                            composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                            composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                        }
                        Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier17, ComposeUiNode.INSTANCE.getSetModifier());
                        function2CombineAsVirtualLayouts17.invoke(composerStartRestartGroup, 0);
                        composerStartRestartGroup.endNode();
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal3 = horizontal110;
                        i19 = i21117;
                        modifier2 = companion;
                        flowColumnOverflow3 = flowColumnOverflow2;
                        i20 = i21116;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        final Modifier modifier11 = modifier2;
                        final Arrangement.Vertical vertical10 = top;
                        final FlowColumnOverflow flowColumnOverflow12 = flowColumnOverflow3;
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i21118) {
                                FlowLayoutKt.FlowColumn(modifier11, vertical10, horizontal3, i19, i20, flowColumnOverflow12, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                            }
                        });
                    }
                }
                i5 |= 24576;
                i12 = i2;
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal111 = start;
                    int i21118 = i23;
                    int i21119 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1114 = new ArrayList();
                        arrayList1114.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211110) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1114);
                        composerStartRestartGroup.updateRememberedValue(arrayList1114);
                        obj = arrayList1114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1115 = new ArrayList();
                        arrayList1115.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211110) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211110 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1115);
                        composerStartRestartGroup.updateRememberedValue(arrayList1115);
                        obj = arrayList1115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts18 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy18 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap18 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier18 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy18, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap18, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier18, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts18.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal111;
                    i19 = i21119;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i21118;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal112 = start;
                    int i211110 = i23;
                    int i211111 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1116 = new ArrayList();
                        arrayList1116.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211112) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1116);
                        composerStartRestartGroup.updateRememberedValue(arrayList1116);
                        obj = arrayList1116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1117 = new ArrayList();
                        arrayList1117.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211112) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1117);
                        composerStartRestartGroup.updateRememberedValue(arrayList1117);
                        obj = arrayList1117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts19 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy19 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap19 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier19 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy19, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap19, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier19, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts19.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal112;
                    i19 = i211111;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i211110;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier12 = modifier2;
                    final Arrangement.Vertical vertical11 = top;
                    final FlowColumnOverflow flowColumnOverflow13 = flowColumnOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211112) {
                            FlowLayoutKt.FlowColumn(modifier12, vertical11, horizontal3, i19, i20, flowColumnOverflow13, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 3072;
            i9 = i;
            i11 = i4 & 16;
            if (i11 != 0) {
                if ((i3 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i5 |= i13;
                }
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal113 = start;
                    int i211112 = i23;
                    int i211113 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1118 = new ArrayList();
                        arrayList1118.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211114) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1118);
                        composerStartRestartGroup.updateRememberedValue(arrayList1118);
                        obj = arrayList1118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1119 = new ArrayList();
                        arrayList1119.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211114) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1119);
                        composerStartRestartGroup.updateRememberedValue(arrayList1119);
                        obj = arrayList1119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts110 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy110 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap110 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier110 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy110, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap110, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier110, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts110.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal113;
                    i19 = i211113;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i211112;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal114 = start;
                    int i211114 = i23;
                    int i211115 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11110 = new ArrayList();
                        arrayList11110.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211116) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11110);
                        composerStartRestartGroup.updateRememberedValue(arrayList11110);
                        obj = arrayList11110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11111 = new ArrayList();
                        arrayList11111.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i211116) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i211116 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i211116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11111);
                        composerStartRestartGroup.updateRememberedValue(arrayList11111);
                        obj = arrayList11111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts111 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy111 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap111 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier111 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy111, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap111, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier111, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts111.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal114;
                    i19 = i211115;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i211114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier13 = modifier2;
                    final Arrangement.Vertical vertical12 = top;
                    final FlowColumnOverflow flowColumnOverflow14 = flowColumnOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211116) {
                            FlowLayoutKt.FlowColumn(modifier13, vertical12, horizontal3, i19, i20, flowColumnOverflow14, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i12 = i2;
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal115 = start;
                int i211116 = i23;
                int i211117 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11112 = new ArrayList();
                    arrayList11112.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211118) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i211118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i211118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11112);
                    composerStartRestartGroup.updateRememberedValue(arrayList11112);
                    obj = arrayList11112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11113 = new ArrayList();
                    arrayList11113.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i211118) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i211118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i211118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11113);
                    composerStartRestartGroup.updateRememberedValue(arrayList11113);
                    obj = arrayList11113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts112 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy112 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap112 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier112 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy112, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap112, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier112, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts112.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal115;
                i19 = i211117;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i211116;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal116 = start;
                int i211118 = i23;
                int i211119 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11114 = new ArrayList();
                    arrayList11114.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111110) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i2111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i2111110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11114);
                    composerStartRestartGroup.updateRememberedValue(arrayList11114);
                    obj = arrayList11114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11115 = new ArrayList();
                    arrayList11115.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111110) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i2111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i2111110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11115);
                    composerStartRestartGroup.updateRememberedValue(arrayList11115);
                    obj = arrayList11115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts113 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy113 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap113 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier113 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy113, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap113, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier113, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts113.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal116;
                i19 = i211119;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i211118;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier14 = modifier2;
                final Arrangement.Vertical vertical13 = top;
                final FlowColumnOverflow flowColumnOverflow15 = flowColumnOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111110) {
                        FlowLayoutKt.FlowColumn(modifier14, vertical13, horizontal3, i19, i20, flowColumnOverflow15, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 384;
        horizontal2 = horizontal;
        i8 = i4 & 8;
        if (i8 != 0) {
            if ((i3 & 3072) == 0) {
                i9 = i;
                if (composerStartRestartGroup.changed(i9)) {
                    i10 = Fields.CameraDistance;
                } else {
                    i10 = Fields.RotationZ;
                }
                i5 |= i10;
            }
            i11 = i4 & 16;
            if (i11 != 0) {
                if ((i3 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i5 |= i13;
                }
                i14 = i4 & 32;
                if (i14 != 0) {
                    i5 |= 196608;
                } else if ((i3 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i5 |= i15;
                }
                if ((i4 & 64) != 0) {
                    i5 |= 1572864;
                } else if ((i3 & 1572864) == 0) {
                    if (composerStartRestartGroup.changedInstance(function3)) {
                        i16 = 1048576;
                    } else {
                        i16 = 524288;
                    }
                    i5 |= i16;
                }
                if ((i5 & 599187) == 599186) {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal117 = start;
                    int i2111110 = i23;
                    int i2111111 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11116 = new ArrayList();
                        arrayList11116.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111112) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2111112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2111112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11116);
                        composerStartRestartGroup.updateRememberedValue(arrayList11116);
                        obj = arrayList11116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11117 = new ArrayList();
                        arrayList11117.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111112) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2111112 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2111112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11117);
                        composerStartRestartGroup.updateRememberedValue(arrayList11117);
                        obj = arrayList11117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts114 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy114 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap114 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier114 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy114, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap114, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier114, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts114.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal117;
                    i19 = i2111111;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i2111110;
                } else {
                    if (i21 != 0) {
                        companion = Modifier.INSTANCE;
                    } else {
                        companion = modifier;
                    }
                    if (i22 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i6 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i8 != 0) {
                        i17 = Integer.MAX_VALUE;
                    } else {
                        i17 = i9;
                    }
                    if (i11 == 0) {
                    }
                    if (i14 != 0) {
                        clip = FlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = flowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                    i18 = i5 & 458752;
                    if (i18 == 131072) {
                        z = true;
                    } else {
                        z = false;
                    }
                    objRememberedValue = composerStartRestartGroup.rememberedValue();
                    if (!z) {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    } else {
                        objRememberedValue = clip.createOverflowState$foundation_layout_release();
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                    }
                    flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    Arrangement.Horizontal horizontal118 = start;
                    int i2111112 = i23;
                    int i2111113 = i17;
                    flowColumnOverflow2 = clip;
                    multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                    if (i18 == 131072) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    if ((3670016 & i5) == 1048576) {
                        z3 = true;
                    } else {
                        z3 = false;
                    }
                    z4 = z3 | z2;
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z4) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11118 = new ArrayList();
                        arrayList11118.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111114) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2111114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2111114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11118);
                        composerStartRestartGroup.updateRememberedValue(arrayList11118);
                        obj = arrayList11118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11119 = new ArrayList();
                        arrayList11119.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2111114) {
                                ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                                if ((i2111114 & 3) == 2 && composer2.getSkipping()) {
                                    composer2.skipToGroupEnd();
                                    return;
                                }
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(985886665, i2111114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                                }
                                function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }));
                        flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11119);
                        composerStartRestartGroup.updateRememberedValue(arrayList11119);
                        obj = arrayList11119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                    Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts115 = LayoutKt.combineAsVirtualLayouts((List) obj);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                    zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                    if (!zChanged) {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    } else {
                        objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                        composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                    }
                    MeasurePolicy measurePolicy115 = (MeasurePolicy) objRememberedValue3;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                    currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                    CompositionLocalMap currentCompositionLocalMap115 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                    Modifier modifierMaterializeModifier115 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                    constructor = ComposeUiNode.INSTANCE.getConstructor();
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                    if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                        ComposablesKt.invalidApplier();
                    }
                    composerStartRestartGroup.startReusableNode();
                    if (composerStartRestartGroup.getInserting()) {
                        composerStartRestartGroup.createNode(constructor);
                    } else {
                        composerStartRestartGroup.useNode();
                    }
                    composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                    Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy115, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                    Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap115, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                    setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                    if (!composerM4037constructorimpl.getInserting()) {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    } else {
                        composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                        composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                    }
                    Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier115, ComposeUiNode.INSTANCE.getSetModifier());
                    function2CombineAsVirtualLayouts115.invoke(composerStartRestartGroup, 0);
                    composerStartRestartGroup.endNode();
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal3 = horizontal118;
                    i19 = i2111113;
                    modifier2 = companion;
                    flowColumnOverflow3 = flowColumnOverflow2;
                    i20 = i2111112;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    final Modifier modifier15 = modifier2;
                    final Arrangement.Vertical vertical14 = top;
                    final FlowColumnOverflow flowColumnOverflow16 = flowColumnOverflow3;
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111114) {
                            FlowLayoutKt.FlowColumn(modifier15, vertical14, horizontal3, i19, i20, flowColumnOverflow16, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                        }
                    });
                }
            }
            i5 |= 24576;
            i12 = i2;
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal119 = start;
                int i2111114 = i23;
                int i2111115 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111110 = new ArrayList();
                    arrayList111110.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111116) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i2111116 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i2111116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111110);
                    composerStartRestartGroup.updateRememberedValue(arrayList111110);
                    obj = arrayList111110;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111111 = new ArrayList();
                    arrayList111111.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111116) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i2111116 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i2111116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111111);
                    composerStartRestartGroup.updateRememberedValue(arrayList111111);
                    obj = arrayList111111;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts116 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy116 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap116 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier116 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy116, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap116, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier116, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts116.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal119;
                i19 = i2111115;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i2111114;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal1110 = start;
                int i2111116 = i23;
                int i2111117 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111112 = new ArrayList();
                    arrayList111112.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111118) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i2111118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i2111118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111112);
                    composerStartRestartGroup.updateRememberedValue(arrayList111112);
                    obj = arrayList111112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111113 = new ArrayList();
                    arrayList111113.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2111118) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i2111118 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i2111118, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111113);
                    composerStartRestartGroup.updateRememberedValue(arrayList111113);
                    obj = arrayList111113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts117 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy117 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap117 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier117 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy117, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap117, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier117, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts117.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal1110;
                i19 = i2111117;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i2111116;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier16 = modifier2;
                final Arrangement.Vertical vertical15 = top;
                final FlowColumnOverflow flowColumnOverflow17 = flowColumnOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2111118) {
                        FlowLayoutKt.FlowColumn(modifier16, vertical15, horizontal3, i19, i20, flowColumnOverflow17, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 3072;
        i9 = i;
        i11 = i4 & 16;
        if (i11 != 0) {
            if ((i3 & 24576) == 0) {
                i12 = i2;
                if (composerStartRestartGroup.changed(i12)) {
                    i13 = Fields.Clip;
                } else {
                    i13 = Fields.Shape;
                }
                i5 |= i13;
            }
            i14 = i4 & 32;
            if (i14 != 0) {
                i5 |= 196608;
            } else if ((i3 & 196608) == 0) {
                if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i5 |= i15;
            }
            if ((i4 & 64) != 0) {
                i5 |= 1572864;
            } else if ((i3 & 1572864) == 0) {
                if (composerStartRestartGroup.changedInstance(function3)) {
                    i16 = 1048576;
                } else {
                    i16 = 524288;
                }
                i5 |= i16;
            }
            if ((i5 & 599187) == 599186) {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal1111 = start;
                int i2111118 = i23;
                int i2111119 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111114 = new ArrayList();
                    arrayList111114.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111110) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21111110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111114);
                    composerStartRestartGroup.updateRememberedValue(arrayList111114);
                    obj = arrayList111114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111115 = new ArrayList();
                    arrayList111115.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111110) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21111110 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21111110, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111115);
                    composerStartRestartGroup.updateRememberedValue(arrayList111115);
                    obj = arrayList111115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts118 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy118 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap118 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier118 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy118, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap118, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier118, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts118.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal1111;
                i19 = i2111119;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i2111118;
            } else {
                if (i21 != 0) {
                    companion = Modifier.INSTANCE;
                } else {
                    companion = modifier;
                }
                if (i22 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i6 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i8 != 0) {
                    i17 = Integer.MAX_VALUE;
                } else {
                    i17 = i9;
                }
                if (i11 == 0) {
                }
                if (i14 != 0) {
                    clip = FlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = flowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
                i18 = i5 & 458752;
                if (i18 == 131072) {
                    z = true;
                } else {
                    z = false;
                }
                objRememberedValue = composerStartRestartGroup.rememberedValue();
                if (!z) {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                } else {
                    objRememberedValue = clip.createOverflowState$foundation_layout_release();
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue);
                }
                flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                Arrangement.Horizontal horizontal1112 = start;
                int i21111110 = i23;
                int i21111111 = i17;
                flowColumnOverflow2 = clip;
                multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
                if (i18 == 131072) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                if ((3670016 & i5) == 1048576) {
                    z3 = true;
                } else {
                    z3 = false;
                }
                z4 = z3 | z2;
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z4) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111116 = new ArrayList();
                    arrayList111116.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111112) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21111112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21111112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111116);
                    composerStartRestartGroup.updateRememberedValue(arrayList111116);
                    obj = arrayList111116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111117 = new ArrayList();
                    arrayList111117.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21111112) {
                            ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                            if ((i21111112 & 3) == 2 && composer2.getSkipping()) {
                                composer2.skipToGroupEnd();
                                return;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(985886665, i21111112, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                            }
                            function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }));
                    flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111117);
                    composerStartRestartGroup.updateRememberedValue(arrayList111117);
                    obj = arrayList111117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
                Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts119 = LayoutKt.combineAsVirtualLayouts((List) obj);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
                zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                objRememberedValue3 = composerStartRestartGroup.rememberedValue();
                if (!zChanged) {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                } else {
                    objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                    composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
                }
                MeasurePolicy measurePolicy119 = (MeasurePolicy) objRememberedValue3;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
                currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
                CompositionLocalMap currentCompositionLocalMap119 = composerStartRestartGroup.getCurrentCompositionLocalMap();
                Modifier modifierMaterializeModifier119 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
                constructor = ComposeUiNode.INSTANCE.getConstructor();
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
                if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                    ComposablesKt.invalidApplier();
                }
                composerStartRestartGroup.startReusableNode();
                if (composerStartRestartGroup.getInserting()) {
                    composerStartRestartGroup.createNode(constructor);
                } else {
                    composerStartRestartGroup.useNode();
                }
                composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
                Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy119, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
                Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap119, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
                setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
                if (!composerM4037constructorimpl.getInserting()) {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                } else {
                    composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                    composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
                }
                Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier119, ComposeUiNode.INSTANCE.getSetModifier());
                function2CombineAsVirtualLayouts119.invoke(composerStartRestartGroup, 0);
                composerStartRestartGroup.endNode();
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal3 = horizontal1112;
                i19 = i21111111;
                modifier2 = companion;
                flowColumnOverflow3 = flowColumnOverflow2;
                i20 = i21111110;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                final Modifier modifier17 = modifier2;
                final Arrangement.Vertical vertical16 = top;
                final FlowColumnOverflow flowColumnOverflow18 = flowColumnOverflow3;
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111112) {
                        FlowLayoutKt.FlowColumn(modifier17, vertical16, horizontal3, i19, i20, flowColumnOverflow18, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                    }
                });
            }
        }
        i5 |= 24576;
        i12 = i2;
        i14 = i4 & 32;
        if (i14 != 0) {
            i5 |= 196608;
        } else if ((i3 & 196608) == 0) {
            if (composerStartRestartGroup.changed(flowColumnOverflow)) {
                i15 = Fields.RenderEffect;
            } else {
                i15 = 65536;
            }
            i5 |= i15;
        }
        if ((i4 & 64) != 0) {
            i5 |= 1572864;
        } else if ((i3 & 1572864) == 0) {
            if (composerStartRestartGroup.changedInstance(function3)) {
                i16 = 1048576;
            } else {
                i16 = 524288;
            }
            i5 |= i16;
        }
        if ((i5 & 599187) == 599186) {
            if (i21 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier;
            }
            if (i22 != 0) {
                top = Arrangement.INSTANCE.getTop();
            }
            if (i6 != 0) {
                start = Arrangement.INSTANCE.getStart();
            } else {
                start = horizontal2;
            }
            if (i8 != 0) {
                i17 = Integer.MAX_VALUE;
            } else {
                i17 = i9;
            }
            if (i11 == 0) {
            }
            if (i14 != 0) {
                clip = FlowColumnOverflow.INSTANCE.getClip();
            } else {
                clip = flowColumnOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
            i18 = i5 & 458752;
            if (i18 == 131072) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Arrangement.Horizontal horizontal1113 = start;
            int i21111112 = i23;
            int i21111113 = i17;
            flowColumnOverflow2 = clip;
            multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
            if (i18 == 131072) {
                z2 = true;
            } else {
                z2 = false;
            }
            if ((3670016 & i5) == 1048576) {
                z3 = true;
            } else {
                z3 = false;
            }
            z4 = z3 | z2;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                obj = objRememberedValue2;
                ArrayList arrayList111118 = new ArrayList();
                arrayList111118.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111114) {
                        ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                        if ((i21111114 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(985886665, i21111114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                        }
                        function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111118);
                composerStartRestartGroup.updateRememberedValue(arrayList111118);
                obj = arrayList111118;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList111119 = new ArrayList();
                arrayList111119.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111114) {
                        ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                        if ((i21111114 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(985886665, i21111114, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                        }
                        function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111119);
                composerStartRestartGroup.updateRememberedValue(arrayList111119);
                obj = arrayList111119;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
            Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts1110 = LayoutKt.combineAsVirtualLayouts((List) obj);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            MeasurePolicy measurePolicy1110 = (MeasurePolicy) objRememberedValue3;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap1110 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier1110 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy1110, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap1110, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier1110, ComposeUiNode.INSTANCE.getSetModifier());
            function2CombineAsVirtualLayouts1110.invoke(composerStartRestartGroup, 0);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            horizontal3 = horizontal1113;
            i19 = i21111113;
            modifier2 = companion;
            flowColumnOverflow3 = flowColumnOverflow2;
            i20 = i21111112;
        } else {
            if (i21 != 0) {
                companion = Modifier.INSTANCE;
            } else {
                companion = modifier;
            }
            if (i22 != 0) {
                top = Arrangement.INSTANCE.getTop();
            }
            if (i6 != 0) {
                start = Arrangement.INSTANCE.getStart();
            } else {
                start = horizontal2;
            }
            if (i8 != 0) {
                i17 = Integer.MAX_VALUE;
            } else {
                i17 = i9;
            }
            if (i11 == 0) {
            }
            if (i14 != 0) {
                clip = FlowColumnOverflow.INSTANCE.getClip();
            } else {
                clip = flowColumnOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-1704849416, i5, -1, "androidx.compose.foundation.layout.FlowColumn (FlowLayout.kt:156)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515615249, "CC(remember):FlowLayout.kt#9igjgp");
            i18 = i5 & 458752;
            if (i18 == 131072) {
                z = true;
            } else {
                z = false;
            }
            objRememberedValue = composerStartRestartGroup.rememberedValue();
            if (!z) {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            } else {
                objRememberedValue = clip.createOverflowState$foundation_layout_release();
                composerStartRestartGroup.updateRememberedValue(objRememberedValue);
            }
            flowLayoutOverflowState = (FlowLayoutOverflowState) objRememberedValue;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            Arrangement.Horizontal horizontal1114 = start;
            int i21111114 = i23;
            int i21111115 = i17;
            flowColumnOverflow2 = clip;
            multiContentMeasurePolicyColumnMeasurementMultiContentHelper = columnMeasurementMultiContentHelper(top, start, i17, i23, flowLayoutOverflowState, composerStartRestartGroup, (i5 >> 3) & 8190);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1515605194, "CC(remember):FlowLayout.kt#9igjgp");
            if (i18 == 131072) {
                z2 = true;
            } else {
                z2 = false;
            }
            if ((3670016 & i5) == 1048576) {
                z3 = true;
            } else {
                z3 = false;
            }
            z4 = z3 | z2;
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z4) {
                obj = objRememberedValue2;
                ArrayList arrayList1111110 = new ArrayList();
                arrayList1111110.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111116) {
                        ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                        if ((i21111116 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(985886665, i21111116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                        }
                        function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111110);
                composerStartRestartGroup.updateRememberedValue(arrayList1111110);
                obj = arrayList1111110;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList1111111 = new ArrayList();
                arrayList1111111.add(ComposableLambdaKt.composableLambdaInstance(985886665, true, new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21111116) {
                        ComposerKt.sourceInformation(composer2, "C169@6950L9:FlowLayout.kt#2w3rfo");
                        if ((i21111116 & 3) == 2 && composer2.getSkipping()) {
                            composer2.skipToGroupEnd();
                            return;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(985886665, i21111116, -1, "androidx.compose.foundation.layout.FlowColumn.<anonymous>.<anonymous> (FlowLayout.kt:169)");
                        }
                        function3.invoke(FlowColumnScopeInstance.INSTANCE, composer2, 6);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }));
                flowColumnOverflow2.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111111);
                composerStartRestartGroup.updateRememberedValue(arrayList1111111);
                obj = arrayList1111111;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1399185516, "CC(Layout)P(!1,2)174@7002L62,171@6888L182:Layout.kt#80mrfh");
            Function2<Composer, Integer, Unit> function2CombineAsVirtualLayouts1111 = LayoutKt.combineAsVirtualLayouts((List) obj);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -290761165, "CC(remember):Layout.kt#9igjgp");
            zChanged = composerStartRestartGroup.changed(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
            objRememberedValue3 = composerStartRestartGroup.rememberedValue();
            if (!zChanged) {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            } else {
                objRememberedValue3 = MultiContentMeasurePolicyKt.createMeasurePolicy(multiContentMeasurePolicyColumnMeasurementMultiContentHelper);
                composerStartRestartGroup.updateRememberedValue(objRememberedValue3);
            }
            MeasurePolicy measurePolicy1111 = (MeasurePolicy) objRememberedValue3;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1323940314, "CC(Layout)P(!1,2)79@3208L23,82@3359L411:Layout.kt#80mrfh");
            currentCompositeKeyHash = ComposablesKt.getCurrentCompositeKeyHash(composerStartRestartGroup, 0);
            CompositionLocalMap currentCompositionLocalMap1111 = composerStartRestartGroup.getCurrentCompositionLocalMap();
            Modifier modifierMaterializeModifier1111 = ComposedModifierKt.materializeModifier(composerStartRestartGroup, companion);
            constructor = ComposeUiNode.INSTANCE.getConstructor();
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -692256719, "CC(ReusableComposeNode)P(1,2)376@14062L9:Composables.kt#9igjgp");
            if (!(composerStartRestartGroup.getApplier() instanceof Applier)) {
                ComposablesKt.invalidApplier();
            }
            composerStartRestartGroup.startReusableNode();
            if (composerStartRestartGroup.getInserting()) {
                composerStartRestartGroup.createNode(constructor);
            } else {
                composerStartRestartGroup.useNode();
            }
            composerM4037constructorimpl = Updater.m4037constructorimpl(composerStartRestartGroup);
            Updater.m4044setimpl(composerM4037constructorimpl, measurePolicy1111, ComposeUiNode.INSTANCE.getSetMeasurePolicy());
            Updater.m4044setimpl(composerM4037constructorimpl, currentCompositionLocalMap1111, ComposeUiNode.INSTANCE.getSetResolvedCompositionLocals());
            setCompositeKeyHash = ComposeUiNode.INSTANCE.getSetCompositeKeyHash();
            if (!composerM4037constructorimpl.getInserting()) {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            } else {
                composerM4037constructorimpl.updateRememberedValue(Integer.valueOf(currentCompositeKeyHash));
                composerM4037constructorimpl.apply(Integer.valueOf(currentCompositeKeyHash), setCompositeKeyHash);
            }
            Updater.m4044setimpl(composerM4037constructorimpl, modifierMaterializeModifier1111, ComposeUiNode.INSTANCE.getSetModifier());
            function2CombineAsVirtualLayouts1111.invoke(composerStartRestartGroup, 0);
            composerStartRestartGroup.endNode();
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            horizontal3 = horizontal1114;
            i19 = i21111115;
            modifier2 = companion;
            flowColumnOverflow3 = flowColumnOverflow2;
            i20 = i21111114;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            final Modifier modifier18 = modifier2;
            final Arrangement.Vertical vertical17 = top;
            final FlowColumnOverflow flowColumnOverflow19 = flowColumnOverflow3;
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i21111116) {
                    FlowLayoutKt.FlowColumn(modifier18, vertical17, horizontal3, i19, i20, flowColumnOverflow19, function3, composer2, RecomposeScopeImplKt.updateChangedFlags(i3 | 1), i4);
                }
            });
        }
    }

    public static final MeasurePolicy rowMeasurementHelper(Arrangement.Horizontal horizontal, Arrangement.Vertical vertical, int i, Composer composer, int i2) {
        boolean z;
        ComposerKt.sourceInformationMarkerStart(composer, 1479255111, "C(rowMeasurementHelper)P(!1,2)380@13086L883:FlowLayout.kt#2w3rfo");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1479255111, i2, -1, "androidx.compose.foundation.layout.rowMeasurementHelper (FlowLayout.kt:379)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, -75342195, "CC(remember):FlowLayout.kt#9igjgp");
        if (((i2 & 14) ^ 6) > 4 && composer.changed(horizontal)) {
            z = true;
        } else if ((i2 & 6) == 4) {
            z = true;
        } else {
            z = false;
        }
        boolean z2 = z | ((((i2 & 112) ^ 48) > 32 && composer.changed(vertical)) || (i2 & 48) == 32) | ((((i2 & 896) ^ 384) > 256 && composer.changed(i)) || (i2 & 384) == 256);
        MeasurePolicy measurePolicyRememberedValue = composer.rememberedValue();
        if (z2 || measurePolicyRememberedValue == Composer.INSTANCE.getEmpty()) {
            final FlowMeasurePolicy flowMeasurePolicy = new FlowMeasurePolicy(true, horizontal, vertical, horizontal.getSpacing(), CROSS_AXIS_ALIGNMENT_TOP, vertical.getSpacing(), i, Integer.MAX_VALUE, FlowRowOverflow.INSTANCE.getVisible().createOverflowState$foundation_layout_release(), null);
            measurePolicyRememberedValue = new MeasurePolicy() {
                @Override
                public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public final MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
                    return flowMeasurePolicy.mo983measure3p2s80s(measureScope, CollectionsKt.listOf(list), j);
                }
            };
            composer.updateRememberedValue(measurePolicyRememberedValue);
        }
        MeasurePolicy measurePolicy = (MeasurePolicy) measurePolicyRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return measurePolicy;
    }

    public static final MultiContentMeasurePolicy rowMeasurementMultiContentHelper(Arrangement.Horizontal horizontal, Arrangement.Vertical vertical, int i, int i2, FlowLayoutOverflowState flowLayoutOverflowState, Composer composer, int i3) {
        boolean z;
        ComposerKt.sourceInformationMarkerStart(composer, -2134502475, "C(rowMeasurementMultiContentHelper)P(!1,4)414@14301L649:FlowLayout.kt#2w3rfo");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2134502475, i3, -1, "androidx.compose.foundation.layout.rowMeasurementMultiContentHelper (FlowLayout.kt:413)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 744443043, "CC(remember):FlowLayout.kt#9igjgp");
        if (((i3 & 14) ^ 6) > 4 && composer.changed(horizontal)) {
            z = true;
        } else if ((i3 & 6) == 4) {
            z = true;
        } else {
            z = false;
        }
        boolean zChanged = z | ((((i3 & 112) ^ 48) > 32 && composer.changed(vertical)) || (i3 & 48) == 32) | ((((i3 & 896) ^ 384) > 256 && composer.changed(i)) || (i3 & 384) == 256) | ((((i3 & 7168) ^ 3072) > 2048 && composer.changed(i2)) || (i3 & 3072) == 2048) | composer.changed(flowLayoutOverflowState);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new FlowMeasurePolicy(true, horizontal, vertical, horizontal.getSpacing(), CROSS_AXIS_ALIGNMENT_TOP, vertical.getSpacing(), i, i2, flowLayoutOverflowState, null);
            composer.updateRememberedValue(objRememberedValue);
        }
        FlowMeasurePolicy flowMeasurePolicy = (FlowMeasurePolicy) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return flowMeasurePolicy;
    }

    public static final MeasurePolicy columnMeasurementHelper(Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, int i, Composer composer, int i2) {
        boolean z;
        ComposerKt.sourceInformationMarkerStart(composer, -2013098357, "C(columnMeasurementHelper)P(2)443@15212L856:FlowLayout.kt#2w3rfo");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2013098357, i2, -1, "androidx.compose.foundation.layout.columnMeasurementHelper (FlowLayout.kt:442)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 1837869538, "CC(remember):FlowLayout.kt#9igjgp");
        if (((i2 & 14) ^ 6) > 4 && composer.changed(vertical)) {
            z = true;
        } else if ((i2 & 6) == 4) {
            z = true;
        } else {
            z = false;
        }
        boolean z2 = z | ((((i2 & 112) ^ 48) > 32 && composer.changed(horizontal)) || (i2 & 48) == 32) | ((((i2 & 896) ^ 384) > 256 && composer.changed(i)) || (i2 & 384) == 256);
        MeasurePolicy measurePolicyRememberedValue = composer.rememberedValue();
        if (z2 || measurePolicyRememberedValue == Composer.INSTANCE.getEmpty()) {
            final FlowMeasurePolicy flowMeasurePolicy = new FlowMeasurePolicy(false, horizontal, vertical, vertical.getSpacing(), CROSS_AXIS_ALIGNMENT_START, horizontal.getSpacing(), i, Integer.MAX_VALUE, FlowRowOverflow.INSTANCE.getVisible().createOverflowState$foundation_layout_release(), null);
            measurePolicyRememberedValue = new MeasurePolicy() {
                @Override
                public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$maxIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$maxIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$minIntrinsicHeight(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List list, int i3) {
                    return MeasurePolicy.CC.$default$minIntrinsicWidth(this, intrinsicMeasureScope, list, i3);
                }

                @Override
                public final MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
                    return flowMeasurePolicy.mo983measure3p2s80s(measureScope, CollectionsKt.listOf(list), j);
                }
            };
            composer.updateRememberedValue(measurePolicyRememberedValue);
        }
        MeasurePolicy measurePolicy = (MeasurePolicy) measurePolicyRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return measurePolicy;
    }

    public static final MultiContentMeasurePolicy columnMeasurementMultiContentHelper(Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, int i, int i2, FlowLayoutOverflowState flowLayoutOverflowState, Composer composer, int i3) {
        boolean z;
        ComposerKt.sourceInformationMarkerStart(composer, 748776953, "C(columnMeasurementMultiContentHelper)P(4)475@16365L652:FlowLayout.kt#2w3rfo");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(748776953, i3, -1, "androidx.compose.foundation.layout.columnMeasurementMultiContentHelper (FlowLayout.kt:474)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 287541334, "CC(remember):FlowLayout.kt#9igjgp");
        if (((i3 & 14) ^ 6) > 4 && composer.changed(vertical)) {
            z = true;
        } else if ((i3 & 6) == 4) {
            z = true;
        } else {
            z = false;
        }
        boolean zChanged = z | ((((i3 & 112) ^ 48) > 32 && composer.changed(horizontal)) || (i3 & 48) == 32) | ((((i3 & 896) ^ 384) > 256 && composer.changed(i)) || (i3 & 384) == 256) | ((((i3 & 7168) ^ 3072) > 2048 && composer.changed(i2)) || (i3 & 3072) == 2048) | composer.changed(flowLayoutOverflowState);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new FlowMeasurePolicy(false, horizontal, vertical, vertical.getSpacing(), CROSS_AXIS_ALIGNMENT_START, horizontal.getSpacing(), i, i2, flowLayoutOverflowState, null);
            composer.updateRememberedValue(objRememberedValue);
        }
        FlowMeasurePolicy flowMeasurePolicy = (FlowMeasurePolicy) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return flowMeasurePolicy;
    }

    public static final int minIntrinsicMainAxisSize(List<? extends IntrinsicMeasurable> list, Function3<? super IntrinsicMeasurable, ? super Integer, ? super Integer, Integer> function3, Function3<? super IntrinsicMeasurable, ? super Integer, ? super Integer, Integer> function4, int i, int i2, int i3, int i4, int i5, FlowLayoutOverflowState flowLayoutOverflowState) {
        if (list.isEmpty()) {
            return 0;
        }
        int size = list.size();
        int[] iArr = new int[size];
        for (int i6 = 0; i6 < size; i6++) {
            iArr[i6] = 0;
        }
        int size2 = list.size();
        int[] iArr2 = new int[size2];
        for (int i7 = 0; i7 < size2; i7++) {
            iArr2[i7] = 0;
        }
        int size3 = list.size();
        for (int i8 = 0; i8 < size3; i8++) {
            IntrinsicMeasurable intrinsicMeasurable = list.get(i8);
            int iIntValue = ((Number) function3.invoke(intrinsicMeasurable, Integer.valueOf(i8), Integer.valueOf(i))).intValue();
            iArr[i8] = iIntValue;
            iArr2[i8] = ((Number) function4.invoke(intrinsicMeasurable, Integer.valueOf(i8), Integer.valueOf(iIntValue))).intValue();
        }
        int i9 = Integer.MAX_VALUE;
        if (i5 != Integer.MAX_VALUE && i4 != Integer.MAX_VALUE) {
            i9 = i4 * i5;
        }
        int iMin = Math.min(i9 - (((i9 >= list.size() || !(flowLayoutOverflowState.getType$foundation_layout_release() == FlowLayoutOverflow.OverflowType.ExpandIndicator || flowLayoutOverflowState.getType$foundation_layout_release() == FlowLayoutOverflow.OverflowType.ExpandOrCollapseIndicator)) && (i9 < list.size() || i5 < flowLayoutOverflowState.getMinLinesToShowCollapse$foundation_layout_release() || flowLayoutOverflowState.getType$foundation_layout_release() != FlowLayoutOverflow.OverflowType.ExpandOrCollapseIndicator)) ? 0 : 1), list.size());
        int iSum = ArraysKt.sum(iArr) + ((list.size() - 1) * i2);
        if (size2 != 0) {
            int iM282getFirstimpl = iArr2[0];
            IntIterator it = new IntRange(1, ArraysKt.getLastIndex(iArr2)).iterator();
            while (it.hasNext()) {
                int i10 = iArr2[it.nextInt()];
                if (iM282getFirstimpl < i10) {
                    iM282getFirstimpl = i10;
                }
            }
            if (size != 0) {
                int i11 = iArr[0];
                IntIterator it2 = new IntRange(1, ArraysKt.getLastIndex(iArr)).iterator();
                while (it2.hasNext()) {
                    int i12 = iArr[it2.nextInt()];
                    if (i11 < i12) {
                        i11 = i12;
                    }
                }
                int i13 = i11;
                int i14 = iSum;
                while (i13 <= i14 && iM282getFirstimpl != i) {
                    iSum = (i13 + i14) / 2;
                    int i15 = i14;
                    int i16 = i13;
                    long jIntrinsicCrossAxisSize = intrinsicCrossAxisSize(list, iArr, iArr2, iSum, i2, i3, i4, i5, flowLayoutOverflowState);
                    iM282getFirstimpl = IntIntPair.m282getFirstimpl(jIntrinsicCrossAxisSize);
                    int iM283getSecondimpl = IntIntPair.m283getSecondimpl(jIntrinsicCrossAxisSize);
                    if (iM282getFirstimpl > i || iM283getSecondimpl < iMin) {
                        i13 = iSum + 1;
                        if (i13 > i15) {
                            return i13;
                        }
                        i14 = i15;
                    } else {
                        if (iM282getFirstimpl >= i) {
                            return iSum;
                        }
                        i14 = iSum - 1;
                        i13 = i16;
                    }
                }
                return iSum;
            }
            throw new NoSuchElementException();
        }
        throw new NoSuchElementException();
    }

    private static final long intrinsicCrossAxisSize(List<? extends IntrinsicMeasurable> list, final int[] iArr, final int[] iArr2, int i, int i2, int i3, int i4, int i5, FlowLayoutOverflowState flowLayoutOverflowState) {
        return intrinsicCrossAxisSize(list, new Function3<IntrinsicMeasurable, Integer, Integer, Integer>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue(), ((Number) obj3).intValue());
            }

            public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i6, int i7) {
                return Integer.valueOf(iArr[i6]);
            }
        }, new Function3<IntrinsicMeasurable, Integer, Integer, Integer>() {
            {
                super(3);
            }

            public Object invoke(Object obj, Object obj2, Object obj3) {
                return invoke((IntrinsicMeasurable) obj, ((Number) obj2).intValue(), ((Number) obj3).intValue());
            }

            public final Integer invoke(IntrinsicMeasurable intrinsicMeasurable, int i6, int i7) {
                return Integer.valueOf(iArr2[i6]);
            }
        }, i, i2, i3, i4, i5, flowLayoutOverflowState);
    }

    public static final long intrinsicCrossAxisSize(List<? extends IntrinsicMeasurable> list, Function3<? super IntrinsicMeasurable, ? super Integer, ? super Integer, Integer> function3, Function3<? super IntrinsicMeasurable, ? super Integer, ? super Integer, Integer> function4, int i, int i2, int i3, int i4, int i5, FlowLayoutOverflowState flowLayoutOverflowState) throws NoWhenBranchMatchedException {
        if (list.isEmpty()) {
            return IntIntPair.m278constructorimpl(0, 0);
        }
        FlowLayoutBuildingBlocks flowLayoutBuildingBlocks = new FlowLayoutBuildingBlocks(i4, flowLayoutOverflowState, OrientationIndependentConstraints.m1002constructorimpl(0, i, 0, Integer.MAX_VALUE), i5, i2, i3, null);
        IntrinsicMeasurable intrinsicMeasurable = (IntrinsicMeasurable) CollectionsKt.getOrNull(list, 0);
        int iIntValue = intrinsicMeasurable != null ? ((Number) function4.invoke(intrinsicMeasurable, 0, Integer.valueOf(i))).intValue() : 0;
        int iIntValue2 = intrinsicMeasurable != null ? ((Number) function3.invoke(intrinsicMeasurable, 0, Integer.valueOf(iIntValue))).intValue() : 0;
        int i6 = 0;
        int iM283getSecondimpl = 0;
        if (flowLayoutBuildingBlocks.m957getWrapInfoOpUlnko(list.size() > 1, 0, IntIntPair.m278constructorimpl(i, Integer.MAX_VALUE), intrinsicMeasurable == null ? null : IntIntPair.m275boximpl(IntIntPair.m278constructorimpl(iIntValue2, iIntValue)), 0, 0, 0, false, false).getIsLastItemInContainer()) {
            IntIntPair intIntPairM962ellipsisSizeF35zmw$foundation_layout_release = flowLayoutOverflowState.m962ellipsisSizeF35zmw$foundation_layout_release(intrinsicMeasurable != null, 0, 0);
            return IntIntPair.m278constructorimpl(intIntPairM962ellipsisSizeF35zmw$foundation_layout_release != null ? IntIntPair.m283getSecondimpl(intIntPairM962ellipsisSizeF35zmw$foundation_layout_release.getPackedValue()) : 0, 0);
        }
        int size = list.size();
        int i7 = i;
        int i8 = 0;
        int i9 = 0;
        int i10 = 0;
        int i11 = 0;
        while (i8 < size) {
            int i12 = i7 - iIntValue2;
            int i13 = i8 + 1;
            int iMax = Math.max(i10, iIntValue);
            IntrinsicMeasurable intrinsicMeasurable2 = (IntrinsicMeasurable) CollectionsKt.getOrNull(list, i13);
            int iIntValue3 = intrinsicMeasurable2 != null ? ((Number) function4.invoke(intrinsicMeasurable2, Integer.valueOf(i13), Integer.valueOf(i))).intValue() : 0;
            int iIntValue4 = intrinsicMeasurable2 != null ? ((Number) function3.invoke(intrinsicMeasurable2, Integer.valueOf(i13), Integer.valueOf(iIntValue3))).intValue() + i2 : 0;
            int i14 = i13 - i11;
            FlowLayoutBuildingBlocks.WrapInfo wrapInfoM957getWrapInfoOpUlnko = flowLayoutBuildingBlocks.m957getWrapInfoOpUlnko(i8 + 2 < list.size(), i14, IntIntPair.m278constructorimpl(i12, Integer.MAX_VALUE), intrinsicMeasurable2 == null ? null : IntIntPair.m275boximpl(IntIntPair.m278constructorimpl(iIntValue4, iIntValue3)), i6, iM283getSecondimpl, iMax, false, false);
            if (wrapInfoM957getWrapInfoOpUlnko.getIsLastItemInLine()) {
                iM283getSecondimpl += iMax + i3;
                FlowLayoutBuildingBlocks.WrapEllipsisInfo wrapEllipsisInfo = flowLayoutBuildingBlocks.getWrapEllipsisInfo(wrapInfoM957getWrapInfoOpUlnko, intrinsicMeasurable2 != null, i6, iM283getSecondimpl, i12, i14);
                int i15 = iIntValue4 - i2;
                i6++;
                if (wrapInfoM957getWrapInfoOpUlnko.getIsLastItemInContainer()) {
                    if (wrapEllipsisInfo != null) {
                        long ellipsisSize = wrapEllipsisInfo.getEllipsisSize();
                        if (!wrapEllipsisInfo.getPlaceEllipsisOnLastContentLine()) {
                            iM283getSecondimpl += IntIntPair.m283getSecondimpl(ellipsisSize) + i3;
                        }
                    }
                    i9 = i13;
                    break;
                }
                i7 = i;
                iIntValue2 = i15;
                i11 = i13;
                i10 = 0;
            } else {
                i7 = i12;
                i10 = iMax;
                iIntValue2 = iIntValue4;
            }
            iIntValue = iIntValue3;
            i8 = i13;
            i9 = i8;
        }
        return IntIntPair.m278constructorimpl(iM283getSecondimpl - i3, i9);
    }

    private static final Measurable safeNext(Iterator<? extends Measurable> it, FlowLineInfo flowLineInfo) {
        Measurable next;
        try {
            if (it instanceof ContextualFlowItemIterator) {
                Intrinsics.checkNotNull(flowLineInfo);
                next = ((ContextualFlowItemIterator) it).getNext$foundation_layout_release(flowLineInfo);
            } else {
                next = it.next();
            }
            return next;
        } catch (IndexOutOfBoundsException unused) {
            return null;
        }
    }

    public static final int mainAxisMin(IntrinsicMeasurable intrinsicMeasurable, boolean z, int i) {
        if (z) {
            return intrinsicMeasurable.minIntrinsicWidth(i);
        }
        return intrinsicMeasurable.minIntrinsicHeight(i);
    }

    public static final int crossAxisMin(IntrinsicMeasurable intrinsicMeasurable, boolean z, int i) {
        if (z) {
            return intrinsicMeasurable.minIntrinsicHeight(i);
        }
        return intrinsicMeasurable.minIntrinsicWidth(i);
    }

    public static final CrossAxisAlignment getCROSS_AXIS_ALIGNMENT_TOP() {
        return CROSS_AXIS_ALIGNMENT_TOP;
    }

    public static final CrossAxisAlignment getCROSS_AXIS_ALIGNMENT_START() {
        return CROSS_AXIS_ALIGNMENT_START;
    }

    public static final long m960measureAndCacherqJ1uqs(Measurable measurable, FlowLineMeasurePolicy flowLineMeasurePolicy, long j, Function1<? super Placeable, Unit> function1) {
        FlowLayoutData flowLayoutData;
        Measurable measurable2 = measurable;
        if (RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(measurable2)) == 0.0f) {
            RowColumnParentData rowColumnParentData = RowColumnImplKt.getRowColumnParentData(measurable2);
            if (((rowColumnParentData == null || (flowLayoutData = rowColumnParentData.getFlowLayoutData()) == null) ? null : Float.valueOf(flowLayoutData.getFillCrossAxisFraction())) == null) {
                Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
                function1.invoke(placeableMo6026measureBRTryo0);
                return IntIntPair.m278constructorimpl(flowLineMeasurePolicy.mainAxisSize(placeableMo6026measureBRTryo0), flowLineMeasurePolicy.crossAxisSize(placeableMo6026measureBRTryo0));
            }
        }
        int iMainAxisMin = mainAxisMin(measurable2, flowLineMeasurePolicy.isHorizontal(), Integer.MAX_VALUE);
        return IntIntPair.m278constructorimpl(iMainAxisMin, crossAxisMin(measurable2, flowLineMeasurePolicy.isHorizontal(), iMainAxisMin));
    }

    public static final MeasureResult m961placeHelperBmaY500(MeasureScope measureScope, long j, int i, int i2, int[] iArr, final MutableVector<MeasureResult> mutableVector, FlowLineMeasurePolicy flowLineMeasurePolicy, int[] iArr2) {
        int iCoerceIn;
        boolean zIsHorizontal = flowLineMeasurePolicy.isHorizontal();
        Arrangement.Vertical verticalArrangement = flowLineMeasurePolicy.getVerticalArrangement();
        Arrangement.Horizontal horizontalArrangement = flowLineMeasurePolicy.getHorizontalArrangement();
        if (zIsHorizontal) {
            if (verticalArrangement == null) {
                throw new IllegalArgumentException("null verticalArrangement".toString());
            }
            iCoerceIn = RangesKt.coerceIn((measureScope.roundToPx-0680j_4(verticalArrangement.getSpacing()) * (mutableVector.getSize() - 1)) + i2, Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(j));
            verticalArrangement.arrange(measureScope, iCoerceIn, iArr, iArr2);
        } else {
            if (horizontalArrangement == null) {
                throw new IllegalArgumentException("null horizontalArrangement".toString());
            }
            int iCoerceIn2 = RangesKt.coerceIn((measureScope.roundToPx-0680j_4(horizontalArrangement.getSpacing()) * (mutableVector.getSize() - 1)) + i2, Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(j));
            horizontalArrangement.arrange(measureScope, iCoerceIn2, iArr, measureScope.getLayoutDirection(), iArr2);
            iCoerceIn = iCoerceIn2;
        }
        int iCoerceIn3 = RangesKt.coerceIn(i, Constraints.getMinWidth-impl(j), Constraints.getMaxWidth-impl(j));
        if (!zIsHorizontal) {
            int i3 = iCoerceIn;
            iCoerceIn = iCoerceIn3;
            iCoerceIn3 = i3;
        }
        return MeasureScope.CC.layout$default(measureScope, iCoerceIn3, iCoerceIn, null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                MutableVector<MeasureResult> mutableVector2 = mutableVector;
                int size = mutableVector2.getSize();
                if (size > 0) {
                    MeasureResult[] content = mutableVector2.getContent();
                    int i4 = 0;
                    do {
                        content[i4].placeChildren();
                        i4++;
                    } while (i4 < size);
                }
            }
        }, 4, null);
    }

    public static final int maxIntrinsicMainAxisSize(List<? extends IntrinsicMeasurable> list, Function3<? super IntrinsicMeasurable, ? super Integer, ? super Integer, Integer> function3, int i, int i2, int i3) {
        int size = list.size();
        int i4 = 0;
        int iMax = 0;
        int i5 = 0;
        int i6 = 0;
        while (i4 < size) {
            int iIntValue = ((Number) function3.invoke(list.get(i4), Integer.valueOf(i4), Integer.valueOf(i))).intValue() + i2;
            int i7 = i4 + 1;
            if (i7 - i5 == i3 || i7 == list.size()) {
                iMax = Math.max(iMax, (i6 + iIntValue) - i2);
                i6 = 0;
                i5 = i4;
            } else {
                i6 += iIntValue;
            }
            i4 = i7;
        }
        return iMax;
    }

    public static final MeasureResult m959breakDownItemsdi9J0FM(MeasureScope measureScope, FlowLineMeasurePolicy flowLineMeasurePolicy, Iterator<? extends Measurable> it, float f, float f2, long j, int i, int i2, FlowLayoutOverflowState flowLayoutOverflowState) {
        FlowLayoutBuildingBlocks.WrapEllipsisInfo wrapEllipsisInfo;
        MutableIntObjectMap mutableIntObjectMap;
        ArrayList arrayList;
        int i3;
        int i4;
        int i5;
        int i6;
        long j2;
        IntIntPair intIntPairM275boximpl;
        IntIntPair intIntPairM275boximpl2;
        MutableIntList mutableIntList;
        MutableIntList mutableIntList2;
        int i7;
        int i8;
        Integer numValueOf;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        FlowLayoutBuildingBlocks.WrapEllipsisInfo wrapEllipsisInfo2;
        int i14;
        int iCoerceAtLeast;
        Iterator<? extends Measurable> it2 = it;
        MutableVector mutableVector = new MutableVector(new MeasureResult[16], 0);
        int i15 = Constraints.getMaxWidth-impl(j);
        int i16 = Constraints.getMinWidth-impl(j);
        int i17 = Constraints.getMaxHeight-impl(j);
        MutableIntObjectMap mutableIntObjectMapMutableIntObjectMapOf = IntObjectMapKt.mutableIntObjectMapOf();
        ArrayList arrayList2 = new ArrayList();
        int iCeil = (int) Math.ceil(measureScope.toPx-0680j_4(f));
        int iCeil2 = (int) Math.ceil(measureScope.toPx-0680j_4(f2));
        long jM1002constructorimpl = OrientationIndependentConstraints.m1002constructorimpl(0, i15, 0, i17);
        long jM1017toBoxConstraintsOenEA2s = OrientationIndependentConstraints.m1017toBoxConstraintsOenEA2s(OrientationIndependentConstraints.m1006copyyUG9Ft0$default(jM1002constructorimpl, 0, 0, 0, 0, 14, null), flowLineMeasurePolicy.isHorizontal() ? LayoutOrientation.Horizontal : LayoutOrientation.Vertical);
        final Ref.ObjectRef objectRef = new Ref.ObjectRef();
        ArrayList arrayList3 = arrayList2;
        int i18 = 0;
        FlowLineInfo flowLineInfo = it2 instanceof ContextualFlowItemIterator ? new FlowLineInfo(0, 0, measureScope.toDp-u2uoSUM(i15), measureScope.toDp-u2uoSUM(i17), null) : null;
        Measurable measurableSafeNext = !it.hasNext() ? null : safeNext(it2, flowLineInfo);
        IntIntPair intIntPairM275boximpl3 = measurableSafeNext != null ? IntIntPair.m275boximpl(m960measureAndCacherqJ1uqs(measurableSafeNext, flowLineMeasurePolicy, jM1017toBoxConstraintsOenEA2s, new Function1<Placeable, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable placeable) {
                objectRef.element = placeable;
            }
        })) : null;
        Integer numValueOf2 = intIntPairM275boximpl3 != null ? Integer.valueOf(IntIntPair.m282getFirstimpl(intIntPairM275boximpl3.getPackedValue())) : null;
        Integer numValueOf3 = intIntPairM275boximpl3 != null ? Integer.valueOf(IntIntPair.m283getSecondimpl(intIntPairM275boximpl3.getPackedValue())) : null;
        long j3 = jM1017toBoxConstraintsOenEA2s;
        FlowLineInfo flowLineInfo2 = flowLineInfo;
        MutableIntList mutableIntList3 = new MutableIntList(0, 1, null);
        MutableIntList mutableIntList4 = new MutableIntList(0, 1, null);
        FlowLayoutBuildingBlocks flowLayoutBuildingBlocks = new FlowLayoutBuildingBlocks(i, flowLayoutOverflowState, j, i2, iCeil, iCeil2, null);
        FlowLayoutBuildingBlocks.WrapInfo wrapInfoM957getWrapInfoOpUlnko = flowLayoutBuildingBlocks.m957getWrapInfoOpUlnko(it.hasNext(), 0, IntIntPair.m278constructorimpl(i15, i17), intIntPairM275boximpl3, 0, 0, 0, false, false);
        if (wrapInfoM957getWrapInfoOpUlnko.getIsLastItemInContainer()) {
            wrapEllipsisInfo = flowLayoutBuildingBlocks.getWrapEllipsisInfo(wrapInfoM957getWrapInfoOpUlnko, intIntPairM275boximpl3 != null, -1, 0, i15, 0);
        } else {
            wrapEllipsisInfo = null;
        }
        FlowLayoutBuildingBlocks.WrapEllipsisInfo wrapEllipsisInfo3 = wrapEllipsisInfo;
        MutableIntList mutableIntList5 = mutableIntList3;
        int i19 = i17;
        Measurable measurable = measurableSafeNext;
        int i20 = i16;
        int i21 = 0;
        int i22 = 0;
        int i23 = 0;
        int i24 = 0;
        int i25 = 0;
        int i26 = i15;
        while (!wrapInfoM957getWrapInfoOpUlnko.getIsLastItemInContainer() && measurable != null) {
            Intrinsics.checkNotNull(numValueOf2);
            int iIntValue = numValueOf2.intValue();
            Intrinsics.checkNotNull(numValueOf3);
            int i27 = i17;
            int i28 = i24 + iIntValue;
            int iMax = Math.max(i25, numValueOf3.intValue());
            int i29 = i26 - iIntValue;
            MutableIntList mutableIntList6 = mutableIntList4;
            int i30 = i23 + 1;
            int i31 = i15;
            flowLayoutOverflowState.setItemShown$foundation_layout_release(i30);
            arrayList3.add(measurable);
            final Ref.ObjectRef objectRef2 = objectRef;
            mutableIntObjectMapMutableIntObjectMapOf.set(i23, objectRef2.element);
            int i32 = i30 - i21;
            int i33 = i21;
            FlowLineInfo flowLineInfo3 = flowLineInfo2;
            boolean z = i32 < i;
            if (flowLineInfo3 != null) {
                int i34 = z ? i18 : i18 + 1;
                int i35 = z ? i32 : 0;
                if (z) {
                    i14 = 0;
                    iCoerceAtLeast = RangesKt.coerceAtLeast(i29 - iCeil, 0);
                } else {
                    i14 = 0;
                    iCoerceAtLeast = i31;
                }
                flowLineInfo3.m970update4j6BHR0$foundation_layout_release(i34, i35, measureScope.toDp-u2uoSUM(iCoerceAtLeast), measureScope.toDp-u2uoSUM(z ? i19 : RangesKt.coerceAtLeast((i19 - iMax) - iCeil2, i14)));
            } else {
                i20 = i20;
                arrayList3 = arrayList3;
                i30 = i30;
            }
            Measurable measurableSafeNext2 = !it.hasNext() ? null : safeNext(it2, flowLineInfo3);
            objectRef2.element = null;
            if (measurableSafeNext2 != null) {
                j2 = j3;
                intIntPairM275boximpl = IntIntPair.m275boximpl(m960measureAndCacherqJ1uqs(measurableSafeNext2, flowLineMeasurePolicy, j2, new Function1<Placeable, Unit>() {
                    {
                        super(1);
                    }

                    public Object invoke(Object obj) {
                        invoke((Placeable) obj);
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Placeable placeable) {
                        objectRef2.element = placeable;
                    }
                }));
            } else {
                j2 = j3;
                intIntPairM275boximpl = null;
            }
            Integer numValueOf4 = intIntPairM275boximpl != null ? Integer.valueOf(IntIntPair.m282getFirstimpl(intIntPairM275boximpl.getPackedValue()) + iCeil) : null;
            Integer numValueOf5 = intIntPairM275boximpl != null ? Integer.valueOf(IntIntPair.m283getSecondimpl(intIntPairM275boximpl.getPackedValue())) : null;
            boolean zHasNext = it.hasNext();
            long jM278constructorimpl = IntIntPair.m278constructorimpl(i29, i19);
            if (intIntPairM275boximpl == null) {
                intIntPairM275boximpl2 = null;
            } else {
                Intrinsics.checkNotNull(numValueOf4);
                int iIntValue2 = numValueOf4.intValue();
                Intrinsics.checkNotNull(numValueOf5);
                intIntPairM275boximpl2 = IntIntPair.m275boximpl(IntIntPair.m278constructorimpl(iIntValue2, numValueOf5.intValue()));
            }
            wrapInfoM957getWrapInfoOpUlnko = flowLayoutBuildingBlocks.m957getWrapInfoOpUlnko(zHasNext, i32, jM278constructorimpl, intIntPairM275boximpl2, i18, i22, iMax, false, false);
            if (wrapInfoM957getWrapInfoOpUlnko.getIsLastItemInLine()) {
                int iMin = Math.min(Math.max(i20, i28), i31);
                int i36 = i22 + iMax;
                FlowLayoutBuildingBlocks.WrapEllipsisInfo wrapEllipsisInfo4 = flowLayoutBuildingBlocks.getWrapEllipsisInfo(wrapInfoM957getWrapInfoOpUlnko, intIntPairM275boximpl != null, i18, i36, i29, i32);
                mutableIntList = mutableIntList6;
                mutableIntList.add(iMax);
                int i37 = (i27 - i36) - iCeil2;
                MutableIntList mutableIntList7 = mutableIntList5;
                i12 = i30;
                mutableIntList7.add(i12);
                i18++;
                i22 = i36 + iCeil2;
                i8 = i31;
                mutableIntList2 = mutableIntList7;
                i7 = i12;
                numValueOf = numValueOf4 != null ? Integer.valueOf(numValueOf4.intValue() - iCeil) : null;
                i9 = 0;
                i10 = i37;
                i11 = iMin;
                i13 = 0;
                wrapEllipsisInfo2 = wrapEllipsisInfo4;
                i15 = i8;
            } else {
                int i38 = i20;
                mutableIntList = mutableIntList6;
                i15 = i31;
                mutableIntList2 = mutableIntList5;
                i7 = i30;
                i8 = i29;
                numValueOf = numValueOf4;
                i9 = iMax;
                i10 = i19;
                i11 = i38;
                i12 = i33;
                i13 = i28;
                wrapEllipsisInfo2 = wrapEllipsisInfo3;
            }
            mutableIntList5 = mutableIntList2;
            wrapEllipsisInfo3 = wrapEllipsisInfo2;
            i21 = i12;
            arrayList3 = arrayList3;
            numValueOf3 = numValueOf5;
            it2 = it;
            objectRef = objectRef2;
            measurable = measurableSafeNext2;
            i23 = i7;
            i26 = i8;
            long j4 = j2;
            i20 = i11;
            i24 = i13;
            i25 = i9;
            i19 = i10;
            i17 = i27;
            mutableIntList4 = mutableIntList;
            numValueOf2 = numValueOf;
            mutableIntObjectMapMutableIntObjectMapOf = mutableIntObjectMapMutableIntObjectMapOf;
            flowLineInfo2 = flowLineInfo3;
            j3 = j4;
        }
        MutableIntObjectMap mutableIntObjectMap2 = mutableIntObjectMapMutableIntObjectMapOf;
        ArrayList arrayList4 = arrayList3;
        MutableIntList mutableIntList8 = mutableIntList4;
        MutableIntList mutableIntList9 = mutableIntList5;
        int i39 = i20;
        if (wrapEllipsisInfo3 != null) {
            arrayList = arrayList4;
            arrayList.add(wrapEllipsisInfo3.getEllipsis());
            mutableIntObjectMap = mutableIntObjectMap2;
            mutableIntObjectMap.set(arrayList.size() - 1, wrapEllipsisInfo3.getPlaceable());
            int i40 = mutableIntList9._size - 1;
            if (wrapEllipsisInfo3.getPlaceEllipsisOnLastContentLine()) {
                int size = mutableIntList9.getSize() - 1;
                mutableIntList8.set(i40, Math.max(mutableIntList8.get(i40), IntIntPair.m283getSecondimpl(wrapEllipsisInfo3.getEllipsisSize())));
                mutableIntList9.set(size, mutableIntList9.last() + 1);
            } else {
                mutableIntList8.add(IntIntPair.m283getSecondimpl(wrapEllipsisInfo3.getEllipsisSize()));
                mutableIntList9.add(mutableIntList9.last() + 1);
            }
        } else {
            mutableIntObjectMap = mutableIntObjectMap2;
            arrayList = arrayList4;
        }
        int size2 = arrayList.size();
        Object[] objArr = new Placeable[size2];
        for (int i41 = 0; i41 < size2; i41++) {
            objArr[i41] = mutableIntObjectMap.get(i41);
        }
        int size3 = mutableIntList9.getSize();
        int[] iArr = new int[size3];
        for (int i42 = 0; i42 < size3; i42++) {
            iArr[i42] = 0;
        }
        int i43 = 0;
        int size4 = mutableIntList9.getSize();
        int[] iArr2 = new int[size4];
        for (int i44 = 0; i44 < size4; i44++) {
            iArr2[i44] = 0;
        }
        MutableIntList mutableIntList10 = mutableIntList9;
        int[] iArr3 = mutableIntList10.content;
        int i45 = mutableIntList10._size;
        int iMax2 = i39;
        int i46 = 0;
        int i47 = 0;
        int i48 = 0;
        while (i46 < i45) {
            int i49 = iArr3[i46];
            int i50 = iMax2;
            int i51 = i45;
            int[] iArr4 = iArr3;
            int[] iArr5 = iArr2;
            int[] iArr6 = iArr;
            int i52 = i48;
            Object[] objArr2 = objArr;
            MutableIntList mutableIntList11 = mutableIntList8;
            int i53 = i43;
            int i54 = i46;
            MeasureResult measureResultMeasure = RowColumnMeasurePolicyKt.measure(flowLineMeasurePolicy, iMax2, Constraints.getMinHeight-impl(jM1002constructorimpl), Constraints.getMaxWidth-impl(jM1002constructorimpl), mutableIntList8.get(i46), iCeil, measureScope, arrayList, objArr, i52, i49, iArr6, i46);
            if (flowLineMeasurePolicy.isHorizontal()) {
                i5 = measureResultMeasure.getWidth();
                i6 = measureResultMeasure.getHeight();
            } else {
                i5 = measureResultMeasure.getHeight();
                i6 = measureResultMeasure.getWidth();
            }
            iArr5[i54] = i6;
            i47 += i6;
            iMax2 = Math.max(i50, i5);
            mutableVector.add(measureResultMeasure);
            i46 = i54 + 1;
            objArr = objArr2;
            i48 = i49;
            i45 = i51;
            iArr3 = iArr4;
            iArr2 = iArr5;
            iArr = iArr6;
            mutableIntList8 = mutableIntList11;
            i43 = i53;
        }
        int i55 = iMax2;
        int[] iArr7 = iArr2;
        int[] iArr8 = iArr;
        int i56 = i43;
        if (mutableVector.isEmpty()) {
            i3 = i56;
            i4 = i3;
        } else {
            i3 = i55;
            i4 = i47;
        }
        return m961placeHelperBmaY500(measureScope, j, i3, i4, iArr7, mutableVector, flowLineMeasurePolicy, iArr8);
    }
}
