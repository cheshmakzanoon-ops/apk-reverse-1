package androidx.compose.foundation.layout;

import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.math.MathKt;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u00008\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0015\n\u0002\b\u0003\u001a\u0085\u0001\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00042\u0006\u0010\u0007\u001a\u00020\u00042\u0006\u0010\b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\r0\f2\u000e\u0010\u000e\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00100\u000f2\u0006\u0010\u0011\u001a\u00020\u00042\u0006\u0010\u0012\u001a\u00020\u00042\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u00142\b\b\u0002\u0010\u0015\u001a\u00020\u0004H\u0000¢\u0006\u0002\u0010\u0016¨\u0006\u0017"}, d2 = {"measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/foundation/layout/RowColumnMeasurePolicy;", "mainAxisMin", "", "crossAxisMin", "mainAxisMax", "crossAxisMax", "arrangementSpacingInt", "measureScope", "Landroidx/compose/ui/layout/MeasureScope;", "measurables", "", "Landroidx/compose/ui/layout/Measurable;", "placeables", "", "Landroidx/compose/ui/layout/Placeable;", "startIndex", "endIndex", "crossAxisOffset", "", "currentLineIndex", "(Landroidx/compose/foundation/layout/RowColumnMeasurePolicy;IIIIILandroidx/compose/ui/layout/MeasureScope;Ljava/util/List;[Landroidx/compose/ui/layout/Placeable;II[II)Landroidx/compose/ui/layout/MeasureResult;", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class RowColumnMeasurePolicyKt {
    public static final MeasureResult measure(RowColumnMeasurePolicy rowColumnMeasurePolicy, int i, int i2, int i3, int i4, int i5, MeasureScope measureScope, List<? extends Measurable> list, Placeable[] placeableArr, int i6, int i7, int[] iArr, int i8) {
        int[] iArr2;
        int[] iArr3;
        float f;
        String str;
        long j;
        String str2;
        String str3;
        long j2;
        String str4;
        String str5;
        int i9;
        RowColumnMeasurePolicy rowColumnMeasurePolicy2;
        int i10;
        int iCoerceIn;
        int i11;
        float f2;
        String str6;
        String str7;
        long j3;
        int i12;
        String str8;
        String str9;
        int i13;
        String str10;
        String str11;
        long j4;
        FlowLayoutData flowLayoutData;
        String str12;
        String str13;
        String str14;
        long j5;
        String str15;
        int i14;
        float f3;
        String str16;
        char c;
        int iIntValue;
        int iIntValue2;
        int iMax;
        int i15;
        int[] iArr4;
        FlowLayoutData flowLayoutData2;
        List<? extends Measurable> list2 = list;
        int i16 = i7;
        int i17 = i16 - i6;
        int[] iArr5 = new int[i17];
        int i18 = i6;
        long j6 = i5;
        float f4 = 0.0f;
        int i19 = 0;
        int i20 = 0;
        int i21 = 0;
        int i22 = 0;
        boolean z = false;
        while (true) {
            Integer numValueOf = null;
            iArr2 = iArr5;
            if (i18 >= i16) {
                break;
            }
            int i23 = i22;
            Measurable measurable = list2.get(i18);
            RowColumnParentData rowColumnParentData = RowColumnImplKt.getRowColumnParentData(measurable);
            float weight = RowColumnImplKt.getWeight(rowColumnParentData);
            z = z || RowColumnImplKt.isRelative(rowColumnParentData);
            if (weight > 0.0f) {
                float f5 = f4 + weight;
                i21++;
                i18 = i18;
                j6 = j6;
                iArr4 = iArr2;
                i17 = i17;
                f4 = f5;
            } else {
                if (i4 != Integer.MAX_VALUE && rowColumnParentData != null && (flowLayoutData2 = rowColumnParentData.getFlowLayoutData()) != null) {
                    numValueOf = Integer.valueOf(Math.round(flowLayoutData2.getFillCrossAxisFraction() * i4));
                }
                int i24 = i3 - i20;
                Placeable placeableMo6026measureBRTryo0 = placeableArr[i18];
                if (placeableMo6026measureBRTryo0 == null) {
                    placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(RowColumnMeasurePolicy.CC.m1060createConstraintsxF2OJ5Q$default(rowColumnMeasurePolicy, 0, numValueOf != null ? numValueOf.intValue() : 0, i3 == Integer.MAX_VALUE ? Integer.MAX_VALUE : RangesKt.coerceAtLeast(i24, 0), numValueOf != null ? numValueOf.intValue() : i4, false, 16, null));
                }
                int iMainAxisSize = rowColumnMeasurePolicy.mainAxisSize(placeableMo6026measureBRTryo0);
                int iCrossAxisSize = rowColumnMeasurePolicy.crossAxisSize(placeableMo6026measureBRTryo0);
                iArr4 = iArr2;
                iArr4[i18 - i6] = iMainAxisSize;
                int iMin = Math.min(i5, RangesKt.coerceAtLeast(i24 - iMainAxisSize, 0));
                i20 = iMainAxisSize + iMin + i20;
                int iMax2 = Math.max(i23, iCrossAxisSize);
                placeableArr[i18] = placeableMo6026measureBRTryo0;
                i23 = iMax2;
                i19 = iMin;
                i21 = i21;
            }
            i18++;
            iArr5 = iArr4;
            f4 = f4;
            i17 = i17;
            i22 = i23;
            j6 = j6;
        }
        int i25 = i20;
        int i26 = i21;
        int i27 = i22;
        long j7 = j6;
        int i28 = i17;
        float f6 = f4;
        if (i26 == 0) {
            i10 = i25 - i19;
            iArr3 = iArr2;
            iCoerceIn = 0;
            i9 = i;
            i11 = i27;
            rowColumnMeasurePolicy2 = rowColumnMeasurePolicy;
        } else {
            int i29 = i3 != Integer.MAX_VALUE ? i3 : i;
            iArr3 = iArr2;
            long j8 = j7 * ((long) (i26 - 1));
            long jCoerceAtLeast = RangesKt.coerceAtLeast(((long) (i29 - i25)) - j8, 0L);
            float f7 = jCoerceAtLeast / f6;
            int i30 = i6;
            long jRound = jCoerceAtLeast;
            while (true) {
                f = f6;
                str = "arrangementSpacingTotal ";
                j = jCoerceAtLeast;
                str2 = "fixedSpace ";
                str3 = "weightChildrenCount ";
                j2 = j8;
                str4 = "targetSpace ";
                str5 = "mainAxisMin ";
                if (i30 >= i16) {
                    break;
                }
                float weight2 = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(list2.get(i30)));
                float f8 = f7 * weight2;
                try {
                    jRound -= (long) Math.round(f8);
                    i30++;
                    list2 = list;
                    i16 = i7;
                    f6 = f;
                    jCoerceAtLeast = j;
                    j8 = j2;
                } catch (IllegalArgumentException e) {
                    throw new IllegalArgumentException("This log indicates a hard-to-reproduce Compose issue, modified with additional debugging details. Please help us by adding your experiences to the bug link provided. Thank you for helping us improve Compose. https://issuetracker.google.com/issues/297974033 mainAxisMax " + i3 + "mainAxisMin " + i + "targetSpace " + i29 + "arrangementSpacingPx " + j7 + "weightChildrenCount " + i26 + "fixedSpace " + i25 + "arrangementSpacingTotal " + j2 + "remainingToTarget " + j + "totalWeight " + f + "weightUnitSpace " + f7 + "itemWeight " + weight2 + "weightedSize " + f8).initCause(e);
                }
            }
            i9 = i;
            String str17 = "weightedSize ";
            String str18 = "weightUnitSpace ";
            float f9 = f;
            String str19 = "totalWeight ";
            long j9 = j;
            String str20 = "remainingToTarget ";
            long j10 = j2;
            long j11 = j7;
            int iMax3 = i27;
            int i31 = 0;
            int i32 = i6;
            while (i32 < i7) {
                if (placeableArr[i32] == null) {
                    Measurable measurable2 = list.get(i32);
                    RowColumnParentData rowColumnParentData2 = RowColumnImplKt.getRowColumnParentData(measurable2);
                    float weight3 = RowColumnImplKt.getWeight(rowColumnParentData2);
                    String str21 = str4;
                    String str22 = str17;
                    Integer numValueOf2 = (i4 == Integer.MAX_VALUE || rowColumnParentData2 == null || (flowLayoutData = rowColumnParentData2.getFlowLayoutData()) == null) ? null : Integer.valueOf(Math.round(flowLayoutData.getFillCrossAxisFraction() * i4));
                    if (weight3 <= 0.0f) {
                        throw new IllegalStateException("All weights <= 0 should have placeables".toString());
                    }
                    int sign = MathKt.getSign(jRound);
                    int i33 = i26;
                    int i34 = i25;
                    jRound -= (long) sign;
                    float f10 = f7 * weight3;
                    float f11 = f7;
                    int iMax4 = Math.max(0, Math.round(f10) + sign);
                    try {
                        try {
                            if (RowColumnImplKt.getFill(rowColumnParentData2)) {
                                c = 65535;
                                int i35 = iMax4 != Integer.MAX_VALUE ? iMax4 : 0;
                                if (numValueOf2 != null) {
                                    iIntValue = numValueOf2.intValue();
                                } else {
                                    iIntValue = 0;
                                }
                                if (numValueOf2 != null) {
                                    iIntValue2 = numValueOf2.intValue();
                                } else {
                                    iIntValue2 = i4;
                                }
                                f3 = f11;
                                str14 = str21;
                                j5 = j10;
                                str15 = str5;
                                int i36 = iIntValue;
                                i14 = i33;
                                i12 = i34;
                                str13 = str3;
                                str16 = str;
                                str12 = str2;
                                j4 = j11;
                                Placeable placeableMo6026measureBRTryo1 = measurable2.mo6026measureBRTryo0(rowColumnMeasurePolicy.mo949createConstraintsxF2OJ5Q(i35, i36, iMax4, iIntValue2, true));
                                int iMainAxisSize2 = rowColumnMeasurePolicy.mainAxisSize(placeableMo6026measureBRTryo1);
                                int iCrossAxisSize2 = rowColumnMeasurePolicy.crossAxisSize(placeableMo6026measureBRTryo1);
                                iArr3[i32 - i6] = iMainAxisSize2;
                                i31 += iMainAxisSize2;
                                iMax3 = Math.max(iMax3, iCrossAxisSize2);
                                placeableArr[i32] = placeableMo6026measureBRTryo1;
                                str10 = str12;
                                str6 = str13;
                                str11 = str16;
                                str7 = str22;
                                f2 = f3;
                                j3 = j5;
                                str8 = str14;
                                str9 = str15;
                                i13 = i14;
                            } else {
                                c = 65535;
                            }
                            Placeable placeableMo6026measureBRTryo2 = measurable2.mo6026measureBRTryo0(rowColumnMeasurePolicy.mo949createConstraintsxF2OJ5Q(i35, i36, iMax4, iIntValue2, true));
                            int iMainAxisSize3 = rowColumnMeasurePolicy.mainAxisSize(placeableMo6026measureBRTryo2);
                            int iCrossAxisSize3 = rowColumnMeasurePolicy.crossAxisSize(placeableMo6026measureBRTryo2);
                            iArr3[i32 - i6] = iMainAxisSize3;
                            i31 += iMainAxisSize3;
                            iMax3 = Math.max(iMax3, iCrossAxisSize3);
                            placeableArr[i32] = placeableMo6026measureBRTryo2;
                            str10 = str12;
                            str6 = str13;
                            str11 = str16;
                            str7 = str22;
                            f2 = f3;
                            j3 = j5;
                            str8 = str14;
                            str9 = str15;
                            i13 = i14;
                        } catch (IllegalArgumentException e2) {
                            e = e2;
                            throw new IllegalArgumentException("This log indicates a hard-to-reproduce Compose issue, modified with additional debugging details. Please help us by adding your experiences to the bug link provided. Thank you for helping us improve Compose. https://issuetracker.google.com/issues/300280216 mainAxisMax " + i3 + str15 + i9 + str14 + i29 + "arrangementSpacingPx " + j4 + str13 + i14 + str12 + i12 + str16 + j5 + str20 + j9 + str19 + f9 + str18 + f3 + "weight " + weight3 + str22 + f10 + "crossAxisDesiredSize " + numValueOf2 + "remainderUnit " + sign + "childMainAxisSize " + iMax4).initCause(e);
                        }
                        if (numValueOf2 != null) {
                            iIntValue = numValueOf2.intValue();
                        } else {
                            iIntValue = 0;
                        }
                        if (numValueOf2 != null) {
                            iIntValue2 = numValueOf2.intValue();
                        } else {
                            iIntValue2 = i4;
                        }
                        f3 = f11;
                        str14 = str21;
                        j5 = j10;
                        str15 = str5;
                        int i37 = iIntValue;
                        i14 = i33;
                        i12 = i34;
                        str13 = str3;
                        str16 = str;
                        str12 = str2;
                        j4 = j11;
                    } catch (IllegalArgumentException e3) {
                        e = e3;
                        str12 = str2;
                        str13 = str3;
                        str14 = str21;
                        j5 = j10;
                        str15 = str5;
                        i12 = i34;
                        i14 = i33;
                        f3 = f11;
                        j4 = j11;
                        str16 = str;
                    }
                } else {
                    f2 = f7;
                    str6 = str3;
                    str7 = str17;
                    j3 = j10;
                    i12 = i25;
                    str8 = str4;
                    int i38 = i26;
                    str9 = str5;
                    String str23 = str;
                    i13 = i38;
                    long j12 = j11;
                    str10 = str2;
                    str11 = str23;
                    j4 = j12;
                }
                i32++;
                f9 = f9;
                str5 = str9;
                str4 = str8;
                i26 = i13;
                i25 = i12;
                f7 = f2;
                str17 = str7;
                str18 = str18;
                j10 = j3;
                j9 = j9;
                str19 = str19;
                str20 = str20;
                str = str11;
                long j13 = j4;
                str3 = str6;
                str2 = str10;
                j11 = j13;
            }
            rowColumnMeasurePolicy2 = rowColumnMeasurePolicy;
            i10 = i25;
            iCoerceIn = RangesKt.coerceIn((int) (((long) i31) + j10), 0, i3 - i10);
            i11 = iMax3;
        }
        if (z) {
            int iMax5 = 0;
            iMax = 0;
            for (int i39 = i6; i39 < i7; i39++) {
                Placeable placeable = placeableArr[i39];
                Intrinsics.checkNotNull(placeable);
                CrossAxisAlignment crossAxisAlignment = RowColumnImplKt.getCrossAxisAlignment(RowColumnImplKt.getRowColumnParentData(placeable));
                Integer numCalculateAlignmentLinePosition$foundation_layout_release = crossAxisAlignment != null ? crossAxisAlignment.calculateAlignmentLinePosition$foundation_layout_release(placeable) : null;
                if (numCalculateAlignmentLinePosition$foundation_layout_release != null) {
                    int iIntValue3 = numCalculateAlignmentLinePosition$foundation_layout_release.intValue();
                    int iCrossAxisSize4 = rowColumnMeasurePolicy2.crossAxisSize(placeable);
                    iMax5 = Math.max(iMax5, iIntValue3 != Integer.MIN_VALUE ? numCalculateAlignmentLinePosition$foundation_layout_release.intValue() : 0);
                    if (iIntValue3 == Integer.MIN_VALUE) {
                        iIntValue3 = iCrossAxisSize4;
                    }
                    iMax = Math.max(iMax, iCrossAxisSize4 - iIntValue3);
                }
            }
            i15 = iMax5;
        } else {
            iMax = 0;
            i15 = 0;
        }
        int iMax6 = Math.max(RangesKt.coerceAtLeast(i10 + iCoerceIn, 0), i9);
        int iMax7 = Math.max(i11, Math.max(i2, iMax + i15));
        int[] iArr6 = new int[i28];
        for (int i40 = 0; i40 < i28; i40++) {
            iArr6[i40] = 0;
        }
        rowColumnMeasurePolicy2.populateMainAxisPositions(iMax6, iArr3, iArr6, measureScope);
        return rowColumnMeasurePolicy.placeHelper(placeableArr, measureScope, i15, iArr6, iMax6, iMax7, iArr, i8, i6, i7);
    }
}
