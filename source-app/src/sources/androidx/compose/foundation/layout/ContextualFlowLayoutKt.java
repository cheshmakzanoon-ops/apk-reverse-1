package androidx.compose.foundation.layout;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.SubcomposeLayoutKt;
import androidx.compose.p002ui.layout.SubcomposeMeasureScope;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.RecomposeScopeImplKt;
import androidx.compose.runtime.ScopeUpdateScope;
import androidx.compose.runtime.internal.ComposableLambdaKt;
import androidx.compose.ui.unit.Constraints;
import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function4;

@Metadata(d1 = {"\u0000x\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\u0084\u0001\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\r21\u0010\u000e\u001a-\u0012\u0004\u0012\u00020\u0010\u0012\u0013\u0012\u00110\u0003¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0013\u0012\u0004\u0012\u00020\u00010\u000f¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007¢\u0006\u0002\u0010\u0016\u001a\u0084\u0001\u0010\u0017\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\u0018\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u001921\u0010\u000e\u001a-\u0012\u0004\u0012\u00020\u001a\u0012\u0013\u0012\u00110\u0003¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0013\u0012\u0004\u0012\u00020\u00010\u000f¢\u0006\u0002\b\u0014¢\u0006\u0002\b\u0015H\u0007¢\u0006\u0002\u0010\u001b\u001a¥\u0001\u0010\u001c\u001a\u0014\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u001f0\u000f2\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010 \u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\u00032\u0006\u0010!\u001a\u00020\"2\u0006\u0010\u0002\u001a\u00020\u00032\u0017\u0010#\u001a\u0013\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u00010%¢\u0006\u0002\b\u00140$2;\u0010&\u001a7\u0012\u0013\u0012\u00110\u0003¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0013\u0012\u0013\u0012\u00110'¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b((\u0012\u0004\u0012\u00020\u00010\u000f¢\u0006\u0002\b\u0014H\u0001¢\u0006\u0002\u0010)\u001a¥\u0001\u0010*\u001a\u0014\u0012\u0004\u0012\u00020\u001d\u0012\u0004\u0012\u00020\u001e\u0012\u0004\u0012\u00020\u001f0\u000f2\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010 \u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\u00032\u0006\u0010!\u001a\u00020\"2\u0006\u0010\u0002\u001a\u00020\u00032\u0017\u0010#\u001a\u0013\u0012\u000f\u0012\r\u0012\u0004\u0012\u00020\u00010%¢\u0006\u0002\b\u00140$2;\u0010&\u001a7\u0012\u0013\u0012\u00110\u0003¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b(\u0013\u0012\u0013\u0012\u00110'¢\u0006\f\b\u0011\u0012\b\b\u0012\u0012\u0004\b\b((\u0012\u0004\u0012\u00020\u00010\u000f¢\u0006\u0002\b\u0014H\u0001¢\u0006\u0002\u0010+¨\u0006,"}, d2 = {"ContextualFlowColumn", "", "itemCount", "", "modifier", "Landroidx/compose/ui/Modifier;", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "maxItemsInEachColumn", "maxLines", "overflow", "Landroidx/compose/foundation/layout/ContextualFlowColumnOverflow;", "content", "Lkotlin/Function2;", "Landroidx/compose/foundation/layout/ContextualFlowColumnScope;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "index", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "(ILandroidx/compose/ui/Modifier;Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;IILandroidx/compose/foundation/layout/ContextualFlowColumnOverflow;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)V", "ContextualFlowRow", "maxItemsInEachRow", "Landroidx/compose/foundation/layout/ContextualFlowRowOverflow;", "Landroidx/compose/foundation/layout/ContextualFlowRowScope;", "(ILandroidx/compose/ui/Modifier;Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;IILandroidx/compose/foundation/layout/ContextualFlowRowOverflow;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;II)V", "contextualColumnMeasureHelper", "Landroidx/compose/ui/layout/SubcomposeMeasureScope;", "Landroidx/compose/ui/unit/Constraints;", "Landroidx/compose/ui/layout/MeasureResult;", "maxItemsInMainAxis", "overflowState", "Landroidx/compose/foundation/layout/FlowLayoutOverflowState;", "overflowComposables", "", "Lkotlin/Function0;", "getComposable", "Landroidx/compose/foundation/layout/FlowLineInfo;", "info", "(Landroidx/compose/foundation/layout/Arrangement$Vertical;Landroidx/compose/foundation/layout/Arrangement$Horizontal;IILandroidx/compose/foundation/layout/FlowLayoutOverflowState;ILjava/util/List;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;I)Lkotlin/jvm/functions/Function2;", "contextualRowMeasurementHelper", "(Landroidx/compose/foundation/layout/Arrangement$Horizontal;Landroidx/compose/foundation/layout/Arrangement$Vertical;IILandroidx/compose/foundation/layout/FlowLayoutOverflowState;ILjava/util/List;Lkotlin/jvm/functions/Function4;Landroidx/compose/runtime/Composer;I)Lkotlin/jvm/functions/Function2;", "foundation-layout_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ContextualFlowLayoutKt {
    public static final void ContextualFlowRow(final int i, Modifier modifier, Arrangement.Horizontal horizontal, Arrangement.Vertical vertical, int i2, int i3, ContextualFlowRowOverflow contextualFlowRowOverflow, final Function4<? super ContextualFlowRowScope, ? super Integer, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i4, final int i5) {
        int i6;
        Modifier modifier2;
        int i7;
        Arrangement.Horizontal start;
        int i8;
        int i9;
        Arrangement.Vertical vertical2;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        Arrangement.Vertical top;
        int i19;
        ContextualFlowRowOverflow clip;
        int i20;
        boolean z;
        Object objRememberedValue;
        FlowLayoutOverflowState flowLayoutOverflowState;
        boolean z2;
        Object objRememberedValue2;
        Object obj;
        final Arrangement.Horizontal horizontal2;
        final ContextualFlowRowOverflow contextualFlowRowOverflow2;
        final int i21;
        final Modifier modifier3;
        final int i22;
        final Arrangement.Vertical vertical3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-341770689);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ContextualFlowRow)P(2,5,1,7,3,4,6)74@3434L65,77@3545L193,90@3961L267,82@3763L465,99@4233L90:ContextualFlowLayout.kt#2w3rfo");
        if ((i5 & 1) != 0) {
            i6 = i4 | 6;
        } else if ((i4 & 6) == 0) {
            i6 = (composerStartRestartGroup.changed(i) ? 4 : 2) | i4;
        } else {
            i6 = i4;
        }
        int i23 = i5 & 2;
        if (i23 == 0) {
            if ((i4 & 48) == 0) {
                modifier2 = modifier;
                i6 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i7 = i5 & 4;
            if (i7 != 0) {
                if ((i4 & 384) == 0) {
                    start = horizontal;
                    if (composerStartRestartGroup.changed(start)) {
                        i8 = Fields.RotationX;
                    } else {
                        i8 = Fields.SpotShadowColor;
                    }
                    i6 |= i8;
                }
                i9 = i5 & 8;
                if (i9 != 0) {
                    if ((i4 & 3072) == 0) {
                        vertical2 = vertical;
                        if (composerStartRestartGroup.changed(vertical2)) {
                            i10 = Fields.CameraDistance;
                        } else {
                            i10 = Fields.RotationZ;
                        }
                        i6 |= i10;
                    }
                    i11 = i5 & 16;
                    if (i11 != 0) {
                        if ((i4 & 24576) == 0) {
                            i12 = i2;
                            if (composerStartRestartGroup.changed(i12)) {
                                i13 = Fields.Clip;
                            } else {
                                i13 = Fields.Shape;
                            }
                            i6 |= i13;
                        }
                        i14 = i5 & 32;
                        if (i14 != 0) {
                            i6 |= 196608;
                        } else if ((i4 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i3)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i6 |= i15;
                        }
                        i16 = i5 & 64;
                        if (i16 != 0) {
                            i6 |= 1572864;
                        } else if ((i4 & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                                i17 = 1048576;
                            } else {
                                i17 = 524288;
                            }
                            i6 |= i17;
                        }
                        if ((i5 & Fields.SpotShadowColor) != 0) {
                            i6 |= 12582912;
                        } else if ((i4 & 12582912) == 0) {
                            if (composerStartRestartGroup.changedInstance(function4)) {
                                i18 = 8388608;
                            } else {
                                i18 = 4194304;
                            }
                            i6 |= i18;
                        }
                        if ((4793491 & i6) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                            if (i23 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i7 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            }
                            if (i9 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            } else {
                                top = vertical2;
                            }
                            if (i11 != 0) {
                                i19 = Integer.MAX_VALUE;
                            } else {
                                i19 = i12;
                            }
                            int i24 = i14 == 0 ? i3 : Integer.MAX_VALUE;
                            if (i16 != 0) {
                                clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                            } else {
                                clip = contextualFlowRowOverflow;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                            i20 = 3670016 & i6;
                            if (i20 == 1048576) {
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
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                            if (i20 == 1048576) {
                                z2 = true;
                            } else {
                                z2 = false;
                            }
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z2 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                obj = objRememberedValue2;
                                ArrayList arrayList = new ArrayList();
                                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList);
                                composerStartRestartGroup.updateRememberedValue(arrayList);
                                obj = arrayList;
                            }
                            obj = objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i25 = i6 >> 6;
                            Arrangement.Vertical vertical4 = top;
                            SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                                {
                                    super(4);
                                }

                                public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                    invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(int i26, FlowLineInfo flowLineInfo, Composer composer2, int i27) {
                                    ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(-8464804, i27, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                    }
                                    function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i26), composer2, Integer.valueOf((i27 << 3) & 112));
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i25 & 7168) | (i25 & 14) | 12582912 | (i25 & 112) | (i25 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            horizontal2 = start;
                            contextualFlowRowOverflow2 = clip;
                            i21 = i24;
                            modifier3 = modifier2;
                            i22 = i19;
                            vertical3 = vertical4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            i21 = i3;
                            modifier3 = modifier2;
                            horizontal2 = start;
                            vertical3 = vertical2;
                            i22 = i12;
                            contextualFlowRowOverflow2 = contextualFlowRowOverflow;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i26) {
                                    ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                                }
                            });
                        }
                    }
                    i6 |= 24576;
                    i12 = i2;
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList2 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList2);
                            composerStartRestartGroup.updateRememberedValue(arrayList2);
                            obj = arrayList2;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList3 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList3);
                            composerStartRestartGroup.updateRememberedValue(arrayList3);
                            obj = arrayList3;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i26 = i6 >> 6;
                        Arrangement.Vertical vertical5 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i27, FlowLineInfo flowLineInfo, Composer composer2, int i28) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i28, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i27), composer2, Integer.valueOf((i28 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i26 & 7168) | (i26 & 14) | 12582912 | (i26 & 112) | (i26 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical5;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList4 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList4);
                            composerStartRestartGroup.updateRememberedValue(arrayList4);
                            obj = arrayList4;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList5 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList5);
                            composerStartRestartGroup.updateRememberedValue(arrayList5);
                            obj = arrayList5;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i27 = i6 >> 6;
                        Arrangement.Vertical vertical6 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i28, FlowLineInfo flowLineInfo, Composer composer2, int i29) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i29, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i28), composer2, Integer.valueOf((i29 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i27 & 7168) | (i27 & 14) | 12582912 | (i27 & 112) | (i27 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical6;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i28) {
                                ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 3072;
                vertical2 = vertical;
                i11 = i5 & 16;
                if (i11 != 0) {
                    if ((i4 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i6 |= i13;
                    }
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList6 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList6);
                            composerStartRestartGroup.updateRememberedValue(arrayList6);
                            obj = arrayList6;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList7 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList7);
                            composerStartRestartGroup.updateRememberedValue(arrayList7);
                            obj = arrayList7;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i28 = i6 >> 6;
                        Arrangement.Vertical vertical7 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i29, FlowLineInfo flowLineInfo, Composer composer2, int i210) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i210, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i29), composer2, Integer.valueOf((i210 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i28 & 7168) | (i28 & 14) | 12582912 | (i28 & 112) | (i28 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical7;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList8 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList8);
                            composerStartRestartGroup.updateRememberedValue(arrayList8);
                            obj = arrayList8;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList9 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList9);
                            composerStartRestartGroup.updateRememberedValue(arrayList9);
                            obj = arrayList9;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i29 = i6 >> 6;
                        Arrangement.Vertical vertical8 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i210, FlowLineInfo flowLineInfo, Composer composer2, int i211) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i211, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i210), composer2, Integer.valueOf((i211 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i29 & 7168) | (i29 & 14) | 12582912 | (i29 & 112) | (i29 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical8;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i210) {
                                ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 24576;
                i12 = i2;
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList10 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList10);
                        composerStartRestartGroup.updateRememberedValue(arrayList10);
                        obj = arrayList10;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11);
                        composerStartRestartGroup.updateRememberedValue(arrayList11);
                        obj = arrayList11;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i210 = i6 >> 6;
                    Arrangement.Vertical vertical9 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i211, FlowLineInfo flowLineInfo, Composer composer2, int i212) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i212, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i211), composer2, Integer.valueOf((i212 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i210 & 7168) | (i210 & 14) | 12582912 | (i210 & 112) | (i210 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical9;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList12 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList12);
                        composerStartRestartGroup.updateRememberedValue(arrayList12);
                        obj = arrayList12;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList13 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList13);
                        composerStartRestartGroup.updateRememberedValue(arrayList13);
                        obj = arrayList13;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211 = i6 >> 6;
                    Arrangement.Vertical vertical10 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i212, FlowLineInfo flowLineInfo, Composer composer2, int i213) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i213, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i212), composer2, Integer.valueOf((i213 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211 & 7168) | (i211 & 14) | 12582912 | (i211 & 112) | (i211 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical10;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i212) {
                            ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 384;
            start = horizontal;
            i9 = i5 & 8;
            if (i9 != 0) {
                if ((i4 & 3072) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i6 |= i10;
                }
                i11 = i5 & 16;
                if (i11 != 0) {
                    if ((i4 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i6 |= i13;
                    }
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList14 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList14);
                            composerStartRestartGroup.updateRememberedValue(arrayList14);
                            obj = arrayList14;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList15 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList15);
                            composerStartRestartGroup.updateRememberedValue(arrayList15);
                            obj = arrayList15;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i212 = i6 >> 6;
                        Arrangement.Vertical vertical11 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i213, FlowLineInfo flowLineInfo, Composer composer2, int i214) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i214, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i213), composer2, Integer.valueOf((i214 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i212 & 7168) | (i212 & 14) | 12582912 | (i212 & 112) | (i212 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical11;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList16 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList16);
                            composerStartRestartGroup.updateRememberedValue(arrayList16);
                            obj = arrayList16;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList17 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList17);
                            composerStartRestartGroup.updateRememberedValue(arrayList17);
                            obj = arrayList17;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i213 = i6 >> 6;
                        Arrangement.Vertical vertical12 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i214, FlowLineInfo flowLineInfo, Composer composer2, int i215) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i215, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i214), composer2, Integer.valueOf((i215 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i213 & 7168) | (i213 & 14) | 12582912 | (i213 & 112) | (i213 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical12;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i214) {
                                ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 24576;
                i12 = i2;
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList18 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList18);
                        composerStartRestartGroup.updateRememberedValue(arrayList18);
                        obj = arrayList18;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList19 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList19);
                        composerStartRestartGroup.updateRememberedValue(arrayList19);
                        obj = arrayList19;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i214 = i6 >> 6;
                    Arrangement.Vertical vertical13 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i215, FlowLineInfo flowLineInfo, Composer composer2, int i216) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i216, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i215), composer2, Integer.valueOf((i216 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i214 & 7168) | (i214 & 14) | 12582912 | (i214 & 112) | (i214 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical13;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList110 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList110);
                        composerStartRestartGroup.updateRememberedValue(arrayList110);
                        obj = arrayList110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList111 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111);
                        composerStartRestartGroup.updateRememberedValue(arrayList111);
                        obj = arrayList111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i215 = i6 >> 6;
                    Arrangement.Vertical vertical14 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i216, FlowLineInfo flowLineInfo, Composer composer2, int i217) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i217, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i216), composer2, Integer.valueOf((i217 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i215 & 7168) | (i215 & 14) | 12582912 | (i215 & 112) | (i215 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical14;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i216) {
                            ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 3072;
            vertical2 = vertical;
            i11 = i5 & 16;
            if (i11 != 0) {
                if ((i4 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i6 |= i13;
                }
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList112 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList112);
                        composerStartRestartGroup.updateRememberedValue(arrayList112);
                        obj = arrayList112;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList113 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList113);
                        composerStartRestartGroup.updateRememberedValue(arrayList113);
                        obj = arrayList113;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i216 = i6 >> 6;
                    Arrangement.Vertical vertical15 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i217, FlowLineInfo flowLineInfo, Composer composer2, int i218) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i218, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i217), composer2, Integer.valueOf((i218 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i216 & 7168) | (i216 & 14) | 12582912 | (i216 & 112) | (i216 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical15;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList114 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList114);
                        composerStartRestartGroup.updateRememberedValue(arrayList114);
                        obj = arrayList114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList115 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList115);
                        composerStartRestartGroup.updateRememberedValue(arrayList115);
                        obj = arrayList115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i217 = i6 >> 6;
                    Arrangement.Vertical vertical16 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i218, FlowLineInfo flowLineInfo, Composer composer2, int i219) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i219, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i218), composer2, Integer.valueOf((i219 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i217 & 7168) | (i217 & 14) | 12582912 | (i217 & 112) | (i217 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical16;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i218) {
                            ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 24576;
            i12 = i2;
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList116 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList116);
                    composerStartRestartGroup.updateRememberedValue(arrayList116);
                    obj = arrayList116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList117 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList117);
                    composerStartRestartGroup.updateRememberedValue(arrayList117);
                    obj = arrayList117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i218 = i6 >> 6;
                Arrangement.Vertical vertical17 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i219, FlowLineInfo flowLineInfo, Composer composer2, int i2110) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i2110, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i219), composer2, Integer.valueOf((i2110 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i218 & 7168) | (i218 & 14) | 12582912 | (i218 & 112) | (i218 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical17;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList118 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList118);
                    composerStartRestartGroup.updateRememberedValue(arrayList118);
                    obj = arrayList118;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList119 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList119);
                    composerStartRestartGroup.updateRememberedValue(arrayList119);
                    obj = arrayList119;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i219 = i6 >> 6;
                Arrangement.Vertical vertical18 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i2110, FlowLineInfo flowLineInfo, Composer composer2, int i2111) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i2111, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2110), composer2, Integer.valueOf((i2111 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i219 & 7168) | (i219 & 14) | 12582912 | (i219 & 112) | (i219 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical18;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2110) {
                        ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 48;
        modifier2 = modifier;
        i7 = i5 & 4;
        if (i7 != 0) {
            if ((i4 & 384) == 0) {
                start = horizontal;
                if (composerStartRestartGroup.changed(start)) {
                    i8 = Fields.RotationX;
                } else {
                    i8 = Fields.SpotShadowColor;
                }
                i6 |= i8;
            }
            i9 = i5 & 8;
            if (i9 != 0) {
                if ((i4 & 3072) == 0) {
                    vertical2 = vertical;
                    if (composerStartRestartGroup.changed(vertical2)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i6 |= i10;
                }
                i11 = i5 & 16;
                if (i11 != 0) {
                    if ((i4 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i6 |= i13;
                    }
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1110 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1110);
                            composerStartRestartGroup.updateRememberedValue(arrayList1110);
                            obj = arrayList1110;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1111 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111);
                            composerStartRestartGroup.updateRememberedValue(arrayList1111);
                            obj = arrayList1111;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2110 = i6 >> 6;
                        Arrangement.Vertical vertical19 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i2111, FlowLineInfo flowLineInfo, Composer composer2, int i2112) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i2112, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2111), composer2, Integer.valueOf((i2112 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2110 & 7168) | (i2110 & 14) | 12582912 | (i2110 & 112) | (i2110 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical19;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        }
                        if (i9 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        } else {
                            top = vertical2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowRowOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1112 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1112);
                            composerStartRestartGroup.updateRememberedValue(arrayList1112);
                            obj = arrayList1112;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1113 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1113);
                            composerStartRestartGroup.updateRememberedValue(arrayList1113);
                            obj = arrayList1113;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111 = i6 >> 6;
                        Arrangement.Vertical vertical110 = top;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i2112, FlowLineInfo flowLineInfo, Composer composer2, int i2113) {
                                ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(-8464804, i2113, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                                }
                                function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2112), composer2, Integer.valueOf((i2113 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111 & 7168) | (i2111 & 14) | 12582912 | (i2111 & 112) | (i2111 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        horizontal2 = start;
                        contextualFlowRowOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        vertical3 = vertical110;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2112) {
                                ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 24576;
                i12 = i2;
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1114 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1114);
                        composerStartRestartGroup.updateRememberedValue(arrayList1114);
                        obj = arrayList1114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1115 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1115);
                        composerStartRestartGroup.updateRememberedValue(arrayList1115);
                        obj = arrayList1115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2112 = i6 >> 6;
                    Arrangement.Vertical vertical111 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2113, FlowLineInfo flowLineInfo, Composer composer2, int i2114) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i2114, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2113), composer2, Integer.valueOf((i2114 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2112 & 7168) | (i2112 & 14) | 12582912 | (i2112 & 112) | (i2112 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical111;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1116 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1116);
                        composerStartRestartGroup.updateRememberedValue(arrayList1116);
                        obj = arrayList1116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1117 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1117);
                        composerStartRestartGroup.updateRememberedValue(arrayList1117);
                        obj = arrayList1117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2113 = i6 >> 6;
                    Arrangement.Vertical vertical112 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2114, FlowLineInfo flowLineInfo, Composer composer2, int i2115) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i2115, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2114), composer2, Integer.valueOf((i2115 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2113 & 7168) | (i2113 & 14) | 12582912 | (i2113 & 112) | (i2113 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical112;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2114) {
                            ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 3072;
            vertical2 = vertical;
            i11 = i5 & 16;
            if (i11 != 0) {
                if ((i4 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i6 |= i13;
                }
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1118 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1118);
                        composerStartRestartGroup.updateRememberedValue(arrayList1118);
                        obj = arrayList1118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1119 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1119);
                        composerStartRestartGroup.updateRememberedValue(arrayList1119);
                        obj = arrayList1119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2114 = i6 >> 6;
                    Arrangement.Vertical vertical113 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2115, FlowLineInfo flowLineInfo, Composer composer2, int i2116) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i2116, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2115), composer2, Integer.valueOf((i2116 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2114 & 7168) | (i2114 & 14) | 12582912 | (i2114 & 112) | (i2114 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical113;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11110 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11110);
                        composerStartRestartGroup.updateRememberedValue(arrayList11110);
                        obj = arrayList11110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11111 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11111);
                        composerStartRestartGroup.updateRememberedValue(arrayList11111);
                        obj = arrayList11111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2115 = i6 >> 6;
                    Arrangement.Vertical vertical114 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2116, FlowLineInfo flowLineInfo, Composer composer2, int i2117) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i2117, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2116), composer2, Integer.valueOf((i2117 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2115 & 7168) | (i2115 & 14) | 12582912 | (i2115 & 112) | (i2115 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2116) {
                            ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 24576;
            i12 = i2;
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11112 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11112);
                    composerStartRestartGroup.updateRememberedValue(arrayList11112);
                    obj = arrayList11112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11113 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11113);
                    composerStartRestartGroup.updateRememberedValue(arrayList11113);
                    obj = arrayList11113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2116 = i6 >> 6;
                Arrangement.Vertical vertical115 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i2117, FlowLineInfo flowLineInfo, Composer composer2, int i2118) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i2118, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2117), composer2, Integer.valueOf((i2118 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2116 & 7168) | (i2116 & 14) | 12582912 | (i2116 & 112) | (i2116 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical115;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11114 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11114);
                    composerStartRestartGroup.updateRememberedValue(arrayList11114);
                    obj = arrayList11114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11115 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11115);
                    composerStartRestartGroup.updateRememberedValue(arrayList11115);
                    obj = arrayList11115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2117 = i6 >> 6;
                Arrangement.Vertical vertical116 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i2118, FlowLineInfo flowLineInfo, Composer composer2, int i2119) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i2119, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2118), composer2, Integer.valueOf((i2119 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2117 & 7168) | (i2117 & 14) | 12582912 | (i2117 & 112) | (i2117 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical116;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2118) {
                        ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 384;
        start = horizontal;
        i9 = i5 & 8;
        if (i9 != 0) {
            if ((i4 & 3072) == 0) {
                vertical2 = vertical;
                if (composerStartRestartGroup.changed(vertical2)) {
                    i10 = Fields.CameraDistance;
                } else {
                    i10 = Fields.RotationZ;
                }
                i6 |= i10;
            }
            i11 = i5 & 16;
            if (i11 != 0) {
                if ((i4 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i6 |= i13;
                }
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11116 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11116);
                        composerStartRestartGroup.updateRememberedValue(arrayList11116);
                        obj = arrayList11116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11117 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11117);
                        composerStartRestartGroup.updateRememberedValue(arrayList11117);
                        obj = arrayList11117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2118 = i6 >> 6;
                    Arrangement.Vertical vertical117 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2119, FlowLineInfo flowLineInfo, Composer composer2, int i21110) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i21110, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i2119), composer2, Integer.valueOf((i21110 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2118 & 7168) | (i2118 & 14) | 12582912 | (i2118 & 112) | (i2118 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical117;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    }
                    if (i9 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    } else {
                        top = vertical2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowRowOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11118 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11118);
                        composerStartRestartGroup.updateRememberedValue(arrayList11118);
                        obj = arrayList11118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11119 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11119);
                        composerStartRestartGroup.updateRememberedValue(arrayList11119);
                        obj = arrayList11119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2119 = i6 >> 6;
                    Arrangement.Vertical vertical118 = top;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i21110, FlowLineInfo flowLineInfo, Composer composer2, int i21111) {
                            ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-8464804, i21111, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                            }
                            function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21110), composer2, Integer.valueOf((i21111 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2119 & 7168) | (i2119 & 14) | 12582912 | (i2119 & 112) | (i2119 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    horizontal2 = start;
                    contextualFlowRowOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    vertical3 = vertical118;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21110) {
                            ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 24576;
            i12 = i2;
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111110 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111110);
                    composerStartRestartGroup.updateRememberedValue(arrayList111110);
                    obj = arrayList111110;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111111 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111111);
                    composerStartRestartGroup.updateRememberedValue(arrayList111111);
                    obj = arrayList111111;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21110 = i6 >> 6;
                Arrangement.Vertical vertical119 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21111, FlowLineInfo flowLineInfo, Composer composer2, int i21112) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i21112, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21111), composer2, Integer.valueOf((i21112 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21110 & 7168) | (i21110 & 14) | 12582912 | (i21110 & 112) | (i21110 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical119;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111112 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111112);
                    composerStartRestartGroup.updateRememberedValue(arrayList111112);
                    obj = arrayList111112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111113 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111113);
                    composerStartRestartGroup.updateRememberedValue(arrayList111113);
                    obj = arrayList111113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21111 = i6 >> 6;
                Arrangement.Vertical vertical1110 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21112, FlowLineInfo flowLineInfo, Composer composer2, int i21113) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i21113, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21112), composer2, Integer.valueOf((i21113 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111 & 7168) | (i21111 & 14) | 12582912 | (i21111 & 112) | (i21111 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical1110;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21112) {
                        ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 3072;
        vertical2 = vertical;
        i11 = i5 & 16;
        if (i11 != 0) {
            if ((i4 & 24576) == 0) {
                i12 = i2;
                if (composerStartRestartGroup.changed(i12)) {
                    i13 = Fields.Clip;
                } else {
                    i13 = Fields.Shape;
                }
                i6 |= i13;
            }
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111114 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111114);
                    composerStartRestartGroup.updateRememberedValue(arrayList111114);
                    obj = arrayList111114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111115 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111115);
                    composerStartRestartGroup.updateRememberedValue(arrayList111115);
                    obj = arrayList111115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21112 = i6 >> 6;
                Arrangement.Vertical vertical1111 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21113, FlowLineInfo flowLineInfo, Composer composer2, int i21114) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i21114, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21113), composer2, Integer.valueOf((i21114 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21112 & 7168) | (i21112 & 14) | 12582912 | (i21112 & 112) | (i21112 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical1111;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                }
                if (i9 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                } else {
                    top = vertical2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowRowOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowRowOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111116 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111116);
                    composerStartRestartGroup.updateRememberedValue(arrayList111116);
                    obj = arrayList111116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111117 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111117);
                    composerStartRestartGroup.updateRememberedValue(arrayList111117);
                    obj = arrayList111117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21113 = i6 >> 6;
                Arrangement.Vertical vertical1112 = top;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21114, FlowLineInfo flowLineInfo, Composer composer2, int i21115) {
                        ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-8464804, i21115, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                        }
                        function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21114), composer2, Integer.valueOf((i21115 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21113 & 7168) | (i21113 & 14) | 12582912 | (i21113 & 112) | (i21113 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                horizontal2 = start;
                contextualFlowRowOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                vertical3 = vertical1112;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21114) {
                        ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 24576;
        i12 = i2;
        i14 = i5 & 32;
        if (i14 != 0) {
            i6 |= 196608;
        } else if ((i4 & 196608) == 0) {
            if (composerStartRestartGroup.changed(i3)) {
                i15 = Fields.RenderEffect;
            } else {
                i15 = 65536;
            }
            i6 |= i15;
        }
        i16 = i5 & 64;
        if (i16 != 0) {
            i6 |= 1572864;
        } else if ((i4 & 1572864) == 0) {
            if (composerStartRestartGroup.changed(contextualFlowRowOverflow)) {
                i17 = 1048576;
            } else {
                i17 = 524288;
            }
            i6 |= i17;
        }
        if ((i5 & Fields.SpotShadowColor) != 0) {
            i6 |= 12582912;
        } else if ((i4 & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i18 = 8388608;
            } else {
                i18 = 4194304;
            }
            i6 |= i18;
        }
        if ((4793491 & i6) == 4793490) {
            if (i23 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i7 != 0) {
                start = Arrangement.INSTANCE.getStart();
            }
            if (i9 != 0) {
                top = Arrangement.INSTANCE.getTop();
            } else {
                top = vertical2;
            }
            if (i11 != 0) {
                i19 = Integer.MAX_VALUE;
            } else {
                i19 = i12;
            }
            if (i14 == 0) {
            }
            if (i16 != 0) {
                clip = ContextualFlowRowOverflow.INSTANCE.getClip();
            } else {
                clip = contextualFlowRowOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            i20 = 3670016 & i6;
            if (i20 == 1048576) {
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            if (i20 == 1048576) {
                z2 = true;
            } else {
                z2 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                obj = objRememberedValue2;
                ArrayList arrayList111118 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111118);
                composerStartRestartGroup.updateRememberedValue(arrayList111118);
                obj = arrayList111118;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList111119 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111119);
                composerStartRestartGroup.updateRememberedValue(arrayList111119);
                obj = arrayList111119;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21114 = i6 >> 6;
            Arrangement.Vertical vertical1113 = top;
            SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                {
                    super(4);
                }

                public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                    invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(int i21115, FlowLineInfo flowLineInfo, Composer composer2, int i21116) {
                    ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8464804, i21116, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                    }
                    function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21115), composer2, Integer.valueOf((i21116 << 3) & 112));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21114 & 7168) | (i21114 & 14) | 12582912 | (i21114 & 112) | (i21114 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            horizontal2 = start;
            contextualFlowRowOverflow2 = clip;
            i21 = i24;
            modifier3 = modifier2;
            i22 = i19;
            vertical3 = vertical1113;
        } else {
            if (i23 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i7 != 0) {
                start = Arrangement.INSTANCE.getStart();
            }
            if (i9 != 0) {
                top = Arrangement.INSTANCE.getTop();
            } else {
                top = vertical2;
            }
            if (i11 != 0) {
                i19 = Integer.MAX_VALUE;
            } else {
                i19 = i12;
            }
            if (i14 == 0) {
            }
            if (i16 != 0) {
                clip = ContextualFlowRowOverflow.INSTANCE.getClip();
            } else {
                clip = contextualFlowRowOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-341770689, i6, -1, "androidx.compose.foundation.layout.ContextualFlowRow (ContextualFlowLayout.kt:73)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235053714, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            i20 = 3670016 & i6;
            if (i20 == 1048576) {
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, 1235057394, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            if (i20 == 1048576) {
                z2 = true;
            } else {
                z2 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                obj = objRememberedValue2;
                ArrayList arrayList1111110 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111110);
                composerStartRestartGroup.updateRememberedValue(arrayList1111110);
                obj = arrayList1111110;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList1111111 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111111);
                composerStartRestartGroup.updateRememberedValue(arrayList1111111);
                obj = arrayList1111111;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21115 = i6 >> 6;
            Arrangement.Vertical vertical1114 = top;
            SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualRowMeasurementHelper(start, top, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(-8464804, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                {
                    super(4);
                }

                public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                    invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(int i21116, FlowLineInfo flowLineInfo, Composer composer2, int i21117) {
                    ComposerKt.sourceInformation(composer2, "C97@4208L14:ContextualFlowLayout.kt#2w3rfo");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-8464804, i21117, -1, "androidx.compose.foundation.layout.ContextualFlowRow.<anonymous> (ContextualFlowLayout.kt:91)");
                    }
                    function4.invoke(new ContextualFlowRowScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxMainAxisSize(), flowLineInfo.getMaxCrossAxisSize(), null), Integer.valueOf(i21116), composer2, Integer.valueOf((i21117 << 3) & 112));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21115 & 7168) | (i21115 & 14) | 12582912 | (i21115 & 112) | (i21115 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            horizontal2 = start;
            contextualFlowRowOverflow2 = clip;
            i21 = i24;
            modifier3 = modifier2;
            i22 = i19;
            vertical3 = vertical1114;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i21116) {
                    ContextualFlowLayoutKt.ContextualFlowRow(i, modifier3, horizontal2, vertical3, i22, i21, contextualFlowRowOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                }
            });
        }
    }

    public static final void ContextualFlowColumn(final int i, Modifier modifier, Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, int i2, int i3, ContextualFlowColumnOverflow contextualFlowColumnOverflow, final Function4<? super ContextualFlowColumnScope, ? super Integer, ? super Composer, ? super Integer, Unit> function4, Composer composer, final int i4, final int i5) {
        int i6;
        Modifier modifier2;
        int i7;
        Arrangement.Vertical top;
        int i8;
        int i9;
        Arrangement.Horizontal horizontal2;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        int i15;
        int i16;
        int i17;
        int i18;
        Arrangement.Horizontal start;
        int i19;
        ContextualFlowColumnOverflow clip;
        int i20;
        boolean z;
        Object objRememberedValue;
        FlowLayoutOverflowState flowLayoutOverflowState;
        boolean z2;
        Object objRememberedValue2;
        Object obj;
        final Arrangement.Vertical vertical2;
        final ContextualFlowColumnOverflow contextualFlowColumnOverflow2;
        final int i21;
        final Modifier modifier3;
        final int i22;
        final Arrangement.Horizontal horizontal3;
        ScopeUpdateScope scopeUpdateScopeEndRestartGroup;
        Composer composerStartRestartGroup = composer.startRestartGroup(-588476895);
        ComposerKt.sourceInformation(composerStartRestartGroup, "C(ContextualFlowColumn)P(2,5,7,1,3,4,6)149@6671L65,152@6782L193,165@7201L270,157@7000L471,175@7477L90:ContextualFlowLayout.kt#2w3rfo");
        if ((i5 & 1) != 0) {
            i6 = i4 | 6;
        } else if ((i4 & 6) == 0) {
            i6 = (composerStartRestartGroup.changed(i) ? 4 : 2) | i4;
        } else {
            i6 = i4;
        }
        int i23 = i5 & 2;
        if (i23 == 0) {
            if ((i4 & 48) == 0) {
                modifier2 = modifier;
                i6 |= composerStartRestartGroup.changed(modifier2) ? 32 : 16;
            }
            i7 = i5 & 4;
            if (i7 != 0) {
                if ((i4 & 384) == 0) {
                    top = vertical;
                    if (composerStartRestartGroup.changed(top)) {
                        i8 = Fields.RotationX;
                    } else {
                        i8 = Fields.SpotShadowColor;
                    }
                    i6 |= i8;
                }
                i9 = i5 & 8;
                if (i9 != 0) {
                    if ((i4 & 3072) == 0) {
                        horizontal2 = horizontal;
                        if (composerStartRestartGroup.changed(horizontal2)) {
                            i10 = Fields.CameraDistance;
                        } else {
                            i10 = Fields.RotationZ;
                        }
                        i6 |= i10;
                    }
                    i11 = i5 & 16;
                    if (i11 != 0) {
                        if ((i4 & 24576) == 0) {
                            i12 = i2;
                            if (composerStartRestartGroup.changed(i12)) {
                                i13 = Fields.Clip;
                            } else {
                                i13 = Fields.Shape;
                            }
                            i6 |= i13;
                        }
                        i14 = i5 & 32;
                        if (i14 != 0) {
                            i6 |= 196608;
                        } else if ((i4 & 196608) == 0) {
                            if (composerStartRestartGroup.changed(i3)) {
                                i15 = Fields.RenderEffect;
                            } else {
                                i15 = 65536;
                            }
                            i6 |= i15;
                        }
                        i16 = i5 & 64;
                        if (i16 != 0) {
                            i6 |= 1572864;
                        } else if ((i4 & 1572864) == 0) {
                            if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                                i17 = 1048576;
                            } else {
                                i17 = 524288;
                            }
                            i6 |= i17;
                        }
                        if ((i5 & Fields.SpotShadowColor) != 0) {
                            i6 |= 12582912;
                        } else if ((i4 & 12582912) == 0) {
                            if (composerStartRestartGroup.changedInstance(function4)) {
                                i18 = 8388608;
                            } else {
                                i18 = 4194304;
                            }
                            i6 |= i18;
                        }
                        if ((4793491 & i6) == 4793490 || !composerStartRestartGroup.getSkipping()) {
                            if (i23 != 0) {
                                modifier2 = Modifier.INSTANCE;
                            }
                            if (i7 != 0) {
                                top = Arrangement.INSTANCE.getTop();
                            }
                            if (i9 != 0) {
                                start = Arrangement.INSTANCE.getStart();
                            } else {
                                start = horizontal2;
                            }
                            if (i11 != 0) {
                                i19 = Integer.MAX_VALUE;
                            } else {
                                i19 = i12;
                            }
                            int i24 = i14 == 0 ? i3 : Integer.MAX_VALUE;
                            if (i16 != 0) {
                                clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                            } else {
                                clip = contextualFlowColumnOverflow;
                            }
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                            }
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                            i20 = 3670016 & i6;
                            if (i20 == 1048576) {
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
                            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                            if (i20 == 1048576) {
                                z2 = true;
                            } else {
                                z2 = false;
                            }
                            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                            if (!z2 || objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
                                obj = objRememberedValue2;
                                ArrayList arrayList = new ArrayList();
                                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList);
                                composerStartRestartGroup.updateRememberedValue(arrayList);
                                obj = arrayList;
                            }
                            obj = objRememberedValue2;
                            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                            int i25 = i6 >> 6;
                            Arrangement.Horizontal horizontal4 = start;
                            SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                                {
                                    super(4);
                                }

                                public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                    invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(int i26, FlowLineInfo flowLineInfo, Composer composer2, int i27) {
                                    ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventStart(302435318, i27, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                    }
                                    function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i26), composer2, Integer.valueOf((i27 << 3) & 112));
                                    if (ComposerKt.isTraceInProgress()) {
                                        ComposerKt.traceEventEnd();
                                    }
                                }
                            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i25 & 7168) | (i25 & 14) | 12582912 | (i25 & 112) | (i25 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                            vertical2 = top;
                            contextualFlowColumnOverflow2 = clip;
                            i21 = i24;
                            modifier3 = modifier2;
                            i22 = i19;
                            horizontal3 = horizontal4;
                        } else {
                            composerStartRestartGroup.skipToGroupEnd();
                            i21 = i3;
                            modifier3 = modifier2;
                            vertical2 = top;
                            horizontal3 = horizontal2;
                            i22 = i12;
                            contextualFlowColumnOverflow2 = contextualFlowColumnOverflow;
                        }
                        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                        if (scopeUpdateScopeEndRestartGroup != null) {
                            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                                {
                                    super(2);
                                }

                                public Object invoke(Object obj2, Object obj3) {
                                    invoke((Composer) obj2, ((Number) obj3).intValue());
                                    return Unit.INSTANCE;
                                }

                                public final void invoke(Composer composer2, int i26) {
                                    ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                                }
                            });
                        }
                    }
                    i6 |= 24576;
                    i12 = i2;
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList2 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList2);
                            composerStartRestartGroup.updateRememberedValue(arrayList2);
                            obj = arrayList2;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList3 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList3);
                            composerStartRestartGroup.updateRememberedValue(arrayList3);
                            obj = arrayList3;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i26 = i6 >> 6;
                        Arrangement.Horizontal horizontal5 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i27, FlowLineInfo flowLineInfo, Composer composer2, int i28) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i28, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i27), composer2, Integer.valueOf((i28 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i26 & 7168) | (i26 & 14) | 12582912 | (i26 & 112) | (i26 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal5;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList4 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList4);
                            composerStartRestartGroup.updateRememberedValue(arrayList4);
                            obj = arrayList4;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList5 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList5);
                            composerStartRestartGroup.updateRememberedValue(arrayList5);
                            obj = arrayList5;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i27 = i6 >> 6;
                        Arrangement.Horizontal horizontal6 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i28, FlowLineInfo flowLineInfo, Composer composer2, int i29) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i29, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i28), composer2, Integer.valueOf((i29 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i27 & 7168) | (i27 & 14) | 12582912 | (i27 & 112) | (i27 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal6;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i28) {
                                ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 3072;
                horizontal2 = horizontal;
                i11 = i5 & 16;
                if (i11 != 0) {
                    if ((i4 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i6 |= i13;
                    }
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList6 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList6);
                            composerStartRestartGroup.updateRememberedValue(arrayList6);
                            obj = arrayList6;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList7 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList7);
                            composerStartRestartGroup.updateRememberedValue(arrayList7);
                            obj = arrayList7;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i28 = i6 >> 6;
                        Arrangement.Horizontal horizontal7 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i29, FlowLineInfo flowLineInfo, Composer composer2, int i210) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i210, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i29), composer2, Integer.valueOf((i210 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i28 & 7168) | (i28 & 14) | 12582912 | (i28 & 112) | (i28 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal7;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList8 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList8);
                            composerStartRestartGroup.updateRememberedValue(arrayList8);
                            obj = arrayList8;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList9 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList9);
                            composerStartRestartGroup.updateRememberedValue(arrayList9);
                            obj = arrayList9;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i29 = i6 >> 6;
                        Arrangement.Horizontal horizontal8 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i210, FlowLineInfo flowLineInfo, Composer composer2, int i211) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i211, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i210), composer2, Integer.valueOf((i211 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i29 & 7168) | (i29 & 14) | 12582912 | (i29 & 112) | (i29 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal8;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i210) {
                                ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 24576;
                i12 = i2;
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList10 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList10);
                        composerStartRestartGroup.updateRememberedValue(arrayList10);
                        obj = arrayList10;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11);
                        composerStartRestartGroup.updateRememberedValue(arrayList11);
                        obj = arrayList11;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i210 = i6 >> 6;
                    Arrangement.Horizontal horizontal9 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i211, FlowLineInfo flowLineInfo, Composer composer2, int i212) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i212, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i211), composer2, Integer.valueOf((i212 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i210 & 7168) | (i210 & 14) | 12582912 | (i210 & 112) | (i210 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal9;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList12 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList12);
                        composerStartRestartGroup.updateRememberedValue(arrayList12);
                        obj = arrayList12;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList13 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList13);
                        composerStartRestartGroup.updateRememberedValue(arrayList13);
                        obj = arrayList13;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i211 = i6 >> 6;
                    Arrangement.Horizontal horizontal10 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i212, FlowLineInfo flowLineInfo, Composer composer2, int i213) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i213, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i212), composer2, Integer.valueOf((i213 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i211 & 7168) | (i211 & 14) | 12582912 | (i211 & 112) | (i211 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal10;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i212) {
                            ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 384;
            top = vertical;
            i9 = i5 & 8;
            if (i9 != 0) {
                if ((i4 & 3072) == 0) {
                    horizontal2 = horizontal;
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i6 |= i10;
                }
                i11 = i5 & 16;
                if (i11 != 0) {
                    if ((i4 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i6 |= i13;
                    }
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList14 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList14);
                            composerStartRestartGroup.updateRememberedValue(arrayList14);
                            obj = arrayList14;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList15 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList15);
                            composerStartRestartGroup.updateRememberedValue(arrayList15);
                            obj = arrayList15;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i212 = i6 >> 6;
                        Arrangement.Horizontal horizontal11 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i213, FlowLineInfo flowLineInfo, Composer composer2, int i214) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i214, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i213), composer2, Integer.valueOf((i214 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i212 & 7168) | (i212 & 14) | 12582912 | (i212 & 112) | (i212 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal11;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList16 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList16);
                            composerStartRestartGroup.updateRememberedValue(arrayList16);
                            obj = arrayList16;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList17 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList17);
                            composerStartRestartGroup.updateRememberedValue(arrayList17);
                            obj = arrayList17;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i213 = i6 >> 6;
                        Arrangement.Horizontal horizontal12 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i214, FlowLineInfo flowLineInfo, Composer composer2, int i215) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i215, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i214), composer2, Integer.valueOf((i215 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i213 & 7168) | (i213 & 14) | 12582912 | (i213 & 112) | (i213 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal12;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i214) {
                                ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 24576;
                i12 = i2;
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList18 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList18);
                        composerStartRestartGroup.updateRememberedValue(arrayList18);
                        obj = arrayList18;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList19 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList19);
                        composerStartRestartGroup.updateRememberedValue(arrayList19);
                        obj = arrayList19;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i214 = i6 >> 6;
                    Arrangement.Horizontal horizontal13 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i215, FlowLineInfo flowLineInfo, Composer composer2, int i216) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i216, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i215), composer2, Integer.valueOf((i216 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i214 & 7168) | (i214 & 14) | 12582912 | (i214 & 112) | (i214 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal13;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList110 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList110);
                        composerStartRestartGroup.updateRememberedValue(arrayList110);
                        obj = arrayList110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList111 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111);
                        composerStartRestartGroup.updateRememberedValue(arrayList111);
                        obj = arrayList111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i215 = i6 >> 6;
                    Arrangement.Horizontal horizontal14 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i216, FlowLineInfo flowLineInfo, Composer composer2, int i217) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i217, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i216), composer2, Integer.valueOf((i217 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i215 & 7168) | (i215 & 14) | 12582912 | (i215 & 112) | (i215 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal14;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i216) {
                            ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 3072;
            horizontal2 = horizontal;
            i11 = i5 & 16;
            if (i11 != 0) {
                if ((i4 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i6 |= i13;
                }
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList112 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList112);
                        composerStartRestartGroup.updateRememberedValue(arrayList112);
                        obj = arrayList112;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList113 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList113);
                        composerStartRestartGroup.updateRememberedValue(arrayList113);
                        obj = arrayList113;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i216 = i6 >> 6;
                    Arrangement.Horizontal horizontal15 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i217, FlowLineInfo flowLineInfo, Composer composer2, int i218) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i218, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i217), composer2, Integer.valueOf((i218 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i216 & 7168) | (i216 & 14) | 12582912 | (i216 & 112) | (i216 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal15;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList114 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList114);
                        composerStartRestartGroup.updateRememberedValue(arrayList114);
                        obj = arrayList114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList115 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList115);
                        composerStartRestartGroup.updateRememberedValue(arrayList115);
                        obj = arrayList115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i217 = i6 >> 6;
                    Arrangement.Horizontal horizontal16 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i218, FlowLineInfo flowLineInfo, Composer composer2, int i219) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i219, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i218), composer2, Integer.valueOf((i219 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i217 & 7168) | (i217 & 14) | 12582912 | (i217 & 112) | (i217 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal16;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i218) {
                            ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 24576;
            i12 = i2;
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList116 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList116);
                    composerStartRestartGroup.updateRememberedValue(arrayList116);
                    obj = arrayList116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList117 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList117);
                    composerStartRestartGroup.updateRememberedValue(arrayList117);
                    obj = arrayList117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i218 = i6 >> 6;
                Arrangement.Horizontal horizontal17 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i219, FlowLineInfo flowLineInfo, Composer composer2, int i2110) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i2110, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i219), composer2, Integer.valueOf((i2110 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i218 & 7168) | (i218 & 14) | 12582912 | (i218 & 112) | (i218 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal17;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList118 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList118);
                    composerStartRestartGroup.updateRememberedValue(arrayList118);
                    obj = arrayList118;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList119 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList119);
                    composerStartRestartGroup.updateRememberedValue(arrayList119);
                    obj = arrayList119;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i219 = i6 >> 6;
                Arrangement.Horizontal horizontal18 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i2110, FlowLineInfo flowLineInfo, Composer composer2, int i2111) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i2111, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2110), composer2, Integer.valueOf((i2111 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i219 & 7168) | (i219 & 14) | 12582912 | (i219 & 112) | (i219 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal18;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2110) {
                        ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 48;
        modifier2 = modifier;
        i7 = i5 & 4;
        if (i7 != 0) {
            if ((i4 & 384) == 0) {
                top = vertical;
                if (composerStartRestartGroup.changed(top)) {
                    i8 = Fields.RotationX;
                } else {
                    i8 = Fields.SpotShadowColor;
                }
                i6 |= i8;
            }
            i9 = i5 & 8;
            if (i9 != 0) {
                if ((i4 & 3072) == 0) {
                    horizontal2 = horizontal;
                    if (composerStartRestartGroup.changed(horizontal2)) {
                        i10 = Fields.CameraDistance;
                    } else {
                        i10 = Fields.RotationZ;
                    }
                    i6 |= i10;
                }
                i11 = i5 & 16;
                if (i11 != 0) {
                    if ((i4 & 24576) == 0) {
                        i12 = i2;
                        if (composerStartRestartGroup.changed(i12)) {
                            i13 = Fields.Clip;
                        } else {
                            i13 = Fields.Shape;
                        }
                        i6 |= i13;
                    }
                    i14 = i5 & 32;
                    if (i14 != 0) {
                        i6 |= 196608;
                    } else if ((i4 & 196608) == 0) {
                        if (composerStartRestartGroup.changed(i3)) {
                            i15 = Fields.RenderEffect;
                        } else {
                            i15 = 65536;
                        }
                        i6 |= i15;
                    }
                    i16 = i5 & 64;
                    if (i16 != 0) {
                        i6 |= 1572864;
                    } else if ((i4 & 1572864) == 0) {
                        if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                            i17 = 1048576;
                        } else {
                            i17 = 524288;
                        }
                        i6 |= i17;
                    }
                    if ((i5 & Fields.SpotShadowColor) != 0) {
                        i6 |= 12582912;
                    } else if ((i4 & 12582912) == 0) {
                        if (composerStartRestartGroup.changedInstance(function4)) {
                            i18 = 8388608;
                        } else {
                            i18 = 4194304;
                        }
                        i6 |= i18;
                    }
                    if ((4793491 & i6) == 4793490) {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1110 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1110);
                            composerStartRestartGroup.updateRememberedValue(arrayList1110);
                            obj = arrayList1110;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1111 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111);
                            composerStartRestartGroup.updateRememberedValue(arrayList1111);
                            obj = arrayList1111;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2110 = i6 >> 6;
                        Arrangement.Horizontal horizontal19 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i2111, FlowLineInfo flowLineInfo, Composer composer2, int i2112) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i2112, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2111), composer2, Integer.valueOf((i2112 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2110 & 7168) | (i2110 & 14) | 12582912 | (i2110 & 112) | (i2110 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal19;
                    } else {
                        if (i23 != 0) {
                            modifier2 = Modifier.INSTANCE;
                        }
                        if (i7 != 0) {
                            top = Arrangement.INSTANCE.getTop();
                        }
                        if (i9 != 0) {
                            start = Arrangement.INSTANCE.getStart();
                        } else {
                            start = horizontal2;
                        }
                        if (i11 != 0) {
                            i19 = Integer.MAX_VALUE;
                        } else {
                            i19 = i12;
                        }
                        if (i14 == 0) {
                        }
                        if (i16 != 0) {
                            clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                        } else {
                            clip = contextualFlowColumnOverflow;
                        }
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                        }
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        i20 = 3670016 & i6;
                        if (i20 == 1048576) {
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
                        ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                        if (i20 == 1048576) {
                            z2 = true;
                        } else {
                            z2 = false;
                        }
                        objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                        if (!z2) {
                            obj = objRememberedValue2;
                            ArrayList arrayList1112 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1112);
                            composerStartRestartGroup.updateRememberedValue(arrayList1112);
                            obj = arrayList1112;
                        } else {
                            obj = objRememberedValue2;
                            ArrayList arrayList1113 = new ArrayList();
                            clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1113);
                            composerStartRestartGroup.updateRememberedValue(arrayList1113);
                            obj = arrayList1113;
                        }
                        obj = objRememberedValue2;
                        ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                        int i2111 = i6 >> 6;
                        Arrangement.Horizontal horizontal110 = start;
                        SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                            {
                                super(4);
                            }

                            public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                                invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(int i2112, FlowLineInfo flowLineInfo, Composer composer2, int i2113) {
                                ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventStart(302435318, i2113, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                                }
                                function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2112), composer2, Integer.valueOf((i2113 << 3) & 112));
                                if (ComposerKt.isTraceInProgress()) {
                                    ComposerKt.traceEventEnd();
                                }
                            }
                        }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2111 & 7168) | (i2111 & 14) | 12582912 | (i2111 & 112) | (i2111 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                        vertical2 = top;
                        contextualFlowColumnOverflow2 = clip;
                        i21 = i24;
                        modifier3 = modifier2;
                        i22 = i19;
                        horizontal3 = horizontal110;
                    }
                    scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                    if (scopeUpdateScopeEndRestartGroup != null) {
                        scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                            {
                                super(2);
                            }

                            public Object invoke(Object obj2, Object obj3) {
                                invoke((Composer) obj2, ((Number) obj3).intValue());
                                return Unit.INSTANCE;
                            }

                            public final void invoke(Composer composer2, int i2112) {
                                ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                            }
                        });
                    }
                }
                i6 |= 24576;
                i12 = i2;
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1114 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1114);
                        composerStartRestartGroup.updateRememberedValue(arrayList1114);
                        obj = arrayList1114;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1115 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1115);
                        composerStartRestartGroup.updateRememberedValue(arrayList1115);
                        obj = arrayList1115;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2112 = i6 >> 6;
                    Arrangement.Horizontal horizontal111 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2113, FlowLineInfo flowLineInfo, Composer composer2, int i2114) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i2114, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2113), composer2, Integer.valueOf((i2114 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2112 & 7168) | (i2112 & 14) | 12582912 | (i2112 & 112) | (i2112 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal111;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1116 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1116);
                        composerStartRestartGroup.updateRememberedValue(arrayList1116);
                        obj = arrayList1116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1117 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1117);
                        composerStartRestartGroup.updateRememberedValue(arrayList1117);
                        obj = arrayList1117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2113 = i6 >> 6;
                    Arrangement.Horizontal horizontal112 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2114, FlowLineInfo flowLineInfo, Composer composer2, int i2115) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i2115, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2114), composer2, Integer.valueOf((i2115 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2113 & 7168) | (i2113 & 14) | 12582912 | (i2113 & 112) | (i2113 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal112;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2114) {
                            ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 3072;
            horizontal2 = horizontal;
            i11 = i5 & 16;
            if (i11 != 0) {
                if ((i4 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i6 |= i13;
                }
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList1118 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1118);
                        composerStartRestartGroup.updateRememberedValue(arrayList1118);
                        obj = arrayList1118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList1119 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1119);
                        composerStartRestartGroup.updateRememberedValue(arrayList1119);
                        obj = arrayList1119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2114 = i6 >> 6;
                    Arrangement.Horizontal horizontal113 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2115, FlowLineInfo flowLineInfo, Composer composer2, int i2116) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i2116, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2115), composer2, Integer.valueOf((i2116 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2114 & 7168) | (i2114 & 14) | 12582912 | (i2114 & 112) | (i2114 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal113;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11110 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11110);
                        composerStartRestartGroup.updateRememberedValue(arrayList11110);
                        obj = arrayList11110;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11111 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11111);
                        composerStartRestartGroup.updateRememberedValue(arrayList11111);
                        obj = arrayList11111;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2115 = i6 >> 6;
                    Arrangement.Horizontal horizontal114 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2116, FlowLineInfo flowLineInfo, Composer composer2, int i2117) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i2117, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2116), composer2, Integer.valueOf((i2117 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2115 & 7168) | (i2115 & 14) | 12582912 | (i2115 & 112) | (i2115 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal114;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i2116) {
                            ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 24576;
            i12 = i2;
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11112 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11112);
                    composerStartRestartGroup.updateRememberedValue(arrayList11112);
                    obj = arrayList11112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11113 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11113);
                    composerStartRestartGroup.updateRememberedValue(arrayList11113);
                    obj = arrayList11113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2116 = i6 >> 6;
                Arrangement.Horizontal horizontal115 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i2117, FlowLineInfo flowLineInfo, Composer composer2, int i2118) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i2118, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2117), composer2, Integer.valueOf((i2118 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2116 & 7168) | (i2116 & 14) | 12582912 | (i2116 & 112) | (i2116 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal115;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList11114 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11114);
                    composerStartRestartGroup.updateRememberedValue(arrayList11114);
                    obj = arrayList11114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList11115 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11115);
                    composerStartRestartGroup.updateRememberedValue(arrayList11115);
                    obj = arrayList11115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i2117 = i6 >> 6;
                Arrangement.Horizontal horizontal116 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i2118, FlowLineInfo flowLineInfo, Composer composer2, int i2119) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i2119, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2118), composer2, Integer.valueOf((i2119 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2117 & 7168) | (i2117 & 14) | 12582912 | (i2117 & 112) | (i2117 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal116;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i2118) {
                        ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 384;
        top = vertical;
        i9 = i5 & 8;
        if (i9 != 0) {
            if ((i4 & 3072) == 0) {
                horizontal2 = horizontal;
                if (composerStartRestartGroup.changed(horizontal2)) {
                    i10 = Fields.CameraDistance;
                } else {
                    i10 = Fields.RotationZ;
                }
                i6 |= i10;
            }
            i11 = i5 & 16;
            if (i11 != 0) {
                if ((i4 & 24576) == 0) {
                    i12 = i2;
                    if (composerStartRestartGroup.changed(i12)) {
                        i13 = Fields.Clip;
                    } else {
                        i13 = Fields.Shape;
                    }
                    i6 |= i13;
                }
                i14 = i5 & 32;
                if (i14 != 0) {
                    i6 |= 196608;
                } else if ((i4 & 196608) == 0) {
                    if (composerStartRestartGroup.changed(i3)) {
                        i15 = Fields.RenderEffect;
                    } else {
                        i15 = 65536;
                    }
                    i6 |= i15;
                }
                i16 = i5 & 64;
                if (i16 != 0) {
                    i6 |= 1572864;
                } else if ((i4 & 1572864) == 0) {
                    if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                        i17 = 1048576;
                    } else {
                        i17 = 524288;
                    }
                    i6 |= i17;
                }
                if ((i5 & Fields.SpotShadowColor) != 0) {
                    i6 |= 12582912;
                } else if ((i4 & 12582912) == 0) {
                    if (composerStartRestartGroup.changedInstance(function4)) {
                        i18 = 8388608;
                    } else {
                        i18 = 4194304;
                    }
                    i6 |= i18;
                }
                if ((4793491 & i6) == 4793490) {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11116 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11116);
                        composerStartRestartGroup.updateRememberedValue(arrayList11116);
                        obj = arrayList11116;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11117 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11117);
                        composerStartRestartGroup.updateRememberedValue(arrayList11117);
                        obj = arrayList11117;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2118 = i6 >> 6;
                    Arrangement.Horizontal horizontal117 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i2119, FlowLineInfo flowLineInfo, Composer composer2, int i21110) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i21110, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i2119), composer2, Integer.valueOf((i21110 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2118 & 7168) | (i2118 & 14) | 12582912 | (i2118 & 112) | (i2118 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal117;
                } else {
                    if (i23 != 0) {
                        modifier2 = Modifier.INSTANCE;
                    }
                    if (i7 != 0) {
                        top = Arrangement.INSTANCE.getTop();
                    }
                    if (i9 != 0) {
                        start = Arrangement.INSTANCE.getStart();
                    } else {
                        start = horizontal2;
                    }
                    if (i11 != 0) {
                        i19 = Integer.MAX_VALUE;
                    } else {
                        i19 = i12;
                    }
                    if (i14 == 0) {
                    }
                    if (i16 != 0) {
                        clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                    } else {
                        clip = contextualFlowColumnOverflow;
                    }
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                    }
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    i20 = 3670016 & i6;
                    if (i20 == 1048576) {
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
                    ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                    if (i20 == 1048576) {
                        z2 = true;
                    } else {
                        z2 = false;
                    }
                    objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                    if (!z2) {
                        obj = objRememberedValue2;
                        ArrayList arrayList11118 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11118);
                        composerStartRestartGroup.updateRememberedValue(arrayList11118);
                        obj = arrayList11118;
                    } else {
                        obj = objRememberedValue2;
                        ArrayList arrayList11119 = new ArrayList();
                        clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList11119);
                        composerStartRestartGroup.updateRememberedValue(arrayList11119);
                        obj = arrayList11119;
                    }
                    obj = objRememberedValue2;
                    ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                    int i2119 = i6 >> 6;
                    Arrangement.Horizontal horizontal118 = start;
                    SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                        {
                            super(4);
                        }

                        public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                            invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(int i21110, FlowLineInfo flowLineInfo, Composer composer2, int i21111) {
                            ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventStart(302435318, i21111, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                            }
                            function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21110), composer2, Integer.valueOf((i21111 << 3) & 112));
                            if (ComposerKt.isTraceInProgress()) {
                                ComposerKt.traceEventEnd();
                            }
                        }
                    }, composerStartRestartGroup, 54), composerStartRestartGroup, (i2119 & 7168) | (i2119 & 14) | 12582912 | (i2119 & 112) | (i2119 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                    vertical2 = top;
                    contextualFlowColumnOverflow2 = clip;
                    i21 = i24;
                    modifier3 = modifier2;
                    i22 = i19;
                    horizontal3 = horizontal118;
                }
                scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
                if (scopeUpdateScopeEndRestartGroup != null) {
                    scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                        {
                            super(2);
                        }

                        public Object invoke(Object obj2, Object obj3) {
                            invoke((Composer) obj2, ((Number) obj3).intValue());
                            return Unit.INSTANCE;
                        }

                        public final void invoke(Composer composer2, int i21110) {
                            ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                        }
                    });
                }
            }
            i6 |= 24576;
            i12 = i2;
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111110 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111110);
                    composerStartRestartGroup.updateRememberedValue(arrayList111110);
                    obj = arrayList111110;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111111 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111111);
                    composerStartRestartGroup.updateRememberedValue(arrayList111111);
                    obj = arrayList111111;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21110 = i6 >> 6;
                Arrangement.Horizontal horizontal119 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21111, FlowLineInfo flowLineInfo, Composer composer2, int i21112) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i21112, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21111), composer2, Integer.valueOf((i21112 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21110 & 7168) | (i21110 & 14) | 12582912 | (i21110 & 112) | (i21110 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal119;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111112 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111112);
                    composerStartRestartGroup.updateRememberedValue(arrayList111112);
                    obj = arrayList111112;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111113 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111113);
                    composerStartRestartGroup.updateRememberedValue(arrayList111113);
                    obj = arrayList111113;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21111 = i6 >> 6;
                Arrangement.Horizontal horizontal1110 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21112, FlowLineInfo flowLineInfo, Composer composer2, int i21113) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i21113, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21112), composer2, Integer.valueOf((i21113 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21111 & 7168) | (i21111 & 14) | 12582912 | (i21111 & 112) | (i21111 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal1110;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21112) {
                        ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 3072;
        horizontal2 = horizontal;
        i11 = i5 & 16;
        if (i11 != 0) {
            if ((i4 & 24576) == 0) {
                i12 = i2;
                if (composerStartRestartGroup.changed(i12)) {
                    i13 = Fields.Clip;
                } else {
                    i13 = Fields.Shape;
                }
                i6 |= i13;
            }
            i14 = i5 & 32;
            if (i14 != 0) {
                i6 |= 196608;
            } else if ((i4 & 196608) == 0) {
                if (composerStartRestartGroup.changed(i3)) {
                    i15 = Fields.RenderEffect;
                } else {
                    i15 = 65536;
                }
                i6 |= i15;
            }
            i16 = i5 & 64;
            if (i16 != 0) {
                i6 |= 1572864;
            } else if ((i4 & 1572864) == 0) {
                if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                    i17 = 1048576;
                } else {
                    i17 = 524288;
                }
                i6 |= i17;
            }
            if ((i5 & Fields.SpotShadowColor) != 0) {
                i6 |= 12582912;
            } else if ((i4 & 12582912) == 0) {
                if (composerStartRestartGroup.changedInstance(function4)) {
                    i18 = 8388608;
                } else {
                    i18 = 4194304;
                }
                i6 |= i18;
            }
            if ((4793491 & i6) == 4793490) {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111114 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111114);
                    composerStartRestartGroup.updateRememberedValue(arrayList111114);
                    obj = arrayList111114;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111115 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111115);
                    composerStartRestartGroup.updateRememberedValue(arrayList111115);
                    obj = arrayList111115;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21112 = i6 >> 6;
                Arrangement.Horizontal horizontal1111 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21113, FlowLineInfo flowLineInfo, Composer composer2, int i21114) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i21114, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21113), composer2, Integer.valueOf((i21114 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21112 & 7168) | (i21112 & 14) | 12582912 | (i21112 & 112) | (i21112 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal1111;
            } else {
                if (i23 != 0) {
                    modifier2 = Modifier.INSTANCE;
                }
                if (i7 != 0) {
                    top = Arrangement.INSTANCE.getTop();
                }
                if (i9 != 0) {
                    start = Arrangement.INSTANCE.getStart();
                } else {
                    start = horizontal2;
                }
                if (i11 != 0) {
                    i19 = Integer.MAX_VALUE;
                } else {
                    i19 = i12;
                }
                if (i14 == 0) {
                }
                if (i16 != 0) {
                    clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
                } else {
                    clip = contextualFlowColumnOverflow;
                }
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
                }
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                i20 = 3670016 & i6;
                if (i20 == 1048576) {
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
                ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
                if (i20 == 1048576) {
                    z2 = true;
                } else {
                    z2 = false;
                }
                objRememberedValue2 = composerStartRestartGroup.rememberedValue();
                if (!z2) {
                    obj = objRememberedValue2;
                    ArrayList arrayList111116 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111116);
                    composerStartRestartGroup.updateRememberedValue(arrayList111116);
                    obj = arrayList111116;
                } else {
                    obj = objRememberedValue2;
                    ArrayList arrayList111117 = new ArrayList();
                    clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111117);
                    composerStartRestartGroup.updateRememberedValue(arrayList111117);
                    obj = arrayList111117;
                }
                obj = objRememberedValue2;
                ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
                int i21113 = i6 >> 6;
                Arrangement.Horizontal horizontal1112 = start;
                SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                    {
                        super(4);
                    }

                    public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                        invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(int i21114, FlowLineInfo flowLineInfo, Composer composer2, int i21115) {
                        ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventStart(302435318, i21115, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                        }
                        function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21114), composer2, Integer.valueOf((i21115 << 3) & 112));
                        if (ComposerKt.isTraceInProgress()) {
                            ComposerKt.traceEventEnd();
                        }
                    }
                }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21113 & 7168) | (i21113 & 14) | 12582912 | (i21113 & 112) | (i21113 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
                if (ComposerKt.isTraceInProgress()) {
                    ComposerKt.traceEventEnd();
                }
                vertical2 = top;
                contextualFlowColumnOverflow2 = clip;
                i21 = i24;
                modifier3 = modifier2;
                i22 = i19;
                horizontal3 = horizontal1112;
            }
            scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
            if (scopeUpdateScopeEndRestartGroup != null) {
                scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke((Composer) obj2, ((Number) obj3).intValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(Composer composer2, int i21114) {
                        ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                    }
                });
            }
        }
        i6 |= 24576;
        i12 = i2;
        i14 = i5 & 32;
        if (i14 != 0) {
            i6 |= 196608;
        } else if ((i4 & 196608) == 0) {
            if (composerStartRestartGroup.changed(i3)) {
                i15 = Fields.RenderEffect;
            } else {
                i15 = 65536;
            }
            i6 |= i15;
        }
        i16 = i5 & 64;
        if (i16 != 0) {
            i6 |= 1572864;
        } else if ((i4 & 1572864) == 0) {
            if (composerStartRestartGroup.changed(contextualFlowColumnOverflow)) {
                i17 = 1048576;
            } else {
                i17 = 524288;
            }
            i6 |= i17;
        }
        if ((i5 & Fields.SpotShadowColor) != 0) {
            i6 |= 12582912;
        } else if ((i4 & 12582912) == 0) {
            if (composerStartRestartGroup.changedInstance(function4)) {
                i18 = 8388608;
            } else {
                i18 = 4194304;
            }
            i6 |= i18;
        }
        if ((4793491 & i6) == 4793490) {
            if (i23 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i7 != 0) {
                top = Arrangement.INSTANCE.getTop();
            }
            if (i9 != 0) {
                start = Arrangement.INSTANCE.getStart();
            } else {
                start = horizontal2;
            }
            if (i11 != 0) {
                i19 = Integer.MAX_VALUE;
            } else {
                i19 = i12;
            }
            if (i14 == 0) {
            }
            if (i16 != 0) {
                clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
            } else {
                clip = contextualFlowColumnOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            i20 = 3670016 & i6;
            if (i20 == 1048576) {
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            if (i20 == 1048576) {
                z2 = true;
            } else {
                z2 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                obj = objRememberedValue2;
                ArrayList arrayList111118 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111118);
                composerStartRestartGroup.updateRememberedValue(arrayList111118);
                obj = arrayList111118;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList111119 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList111119);
                composerStartRestartGroup.updateRememberedValue(arrayList111119);
                obj = arrayList111119;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21114 = i6 >> 6;
            Arrangement.Horizontal horizontal1113 = start;
            SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                {
                    super(4);
                }

                public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                    invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(int i21115, FlowLineInfo flowLineInfo, Composer composer2, int i21116) {
                    ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(302435318, i21116, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                    }
                    function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21115), composer2, Integer.valueOf((i21116 << 3) & 112));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21114 & 7168) | (i21114 & 14) | 12582912 | (i21114 & 112) | (i21114 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            vertical2 = top;
            contextualFlowColumnOverflow2 = clip;
            i21 = i24;
            modifier3 = modifier2;
            i22 = i19;
            horizontal3 = horizontal1113;
        } else {
            if (i23 != 0) {
                modifier2 = Modifier.INSTANCE;
            }
            if (i7 != 0) {
                top = Arrangement.INSTANCE.getTop();
            }
            if (i9 != 0) {
                start = Arrangement.INSTANCE.getStart();
            } else {
                start = horizontal2;
            }
            if (i11 != 0) {
                i19 = Integer.MAX_VALUE;
            } else {
                i19 = i12;
            }
            if (i14 == 0) {
            }
            if (i16 != 0) {
                clip = ContextualFlowColumnOverflow.INSTANCE.getClip();
            } else {
                clip = contextualFlowColumnOverflow;
            }
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventStart(-588476895, i6, -1, "androidx.compose.foundation.layout.ContextualFlowColumn (ContextualFlowLayout.kt:148)");
            }
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055927072, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            i20 = 3670016 & i6;
            if (i20 == 1048576) {
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
            ComposerKt.sourceInformationMarkerStart(composerStartRestartGroup, -1055923392, "CC(remember):ContextualFlowLayout.kt#9igjgp");
            if (i20 == 1048576) {
                z2 = true;
            } else {
                z2 = false;
            }
            objRememberedValue2 = composerStartRestartGroup.rememberedValue();
            if (!z2) {
                obj = objRememberedValue2;
                ArrayList arrayList1111110 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111110);
                composerStartRestartGroup.updateRememberedValue(arrayList1111110);
                obj = arrayList1111110;
            } else {
                obj = objRememberedValue2;
                ArrayList arrayList1111111 = new ArrayList();
                clip.addOverflowComposables$foundation_layout_release(flowLayoutOverflowState, arrayList1111111);
                composerStartRestartGroup.updateRememberedValue(arrayList1111111);
                obj = arrayList1111111;
            }
            obj = objRememberedValue2;
            ComposerKt.sourceInformationMarkerEnd(composerStartRestartGroup);
            int i21115 = i6 >> 6;
            Arrangement.Horizontal horizontal1114 = start;
            SubcomposeLayoutKt.SubcomposeLayout(modifier2, contextualColumnMeasureHelper(top, start, i19, i24, flowLayoutOverflowState, i, (List) obj, ComposableLambdaKt.rememberComposableLambda(302435318, true, new Function4<Integer, FlowLineInfo, Composer, Integer, Unit>() {
                {
                    super(4);
                }

                public Object invoke(Object obj2, Object obj3, Object obj4, Object obj5) {
                    invoke(((Number) obj2).intValue(), (FlowLineInfo) obj3, (Composer) obj4, ((Number) obj5).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(int i21116, FlowLineInfo flowLineInfo, Composer composer2, int i21117) {
                    ComposerKt.sourceInformation(composer2, "C172@7451L14:ContextualFlowLayout.kt#2w3rfo");
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventStart(302435318, i21117, -1, "androidx.compose.foundation.layout.ContextualFlowColumn.<anonymous> (ContextualFlowLayout.kt:166)");
                    }
                    function4.invoke(new ContextualFlowColumnScopeImpl(flowLineInfo.getLineIndex(), flowLineInfo.getPositionInLine(), flowLineInfo.getMaxCrossAxisSize(), flowLineInfo.getMaxMainAxisSize(), null), Integer.valueOf(i21116), composer2, Integer.valueOf((i21117 << 3) & 112));
                    if (ComposerKt.isTraceInProgress()) {
                        ComposerKt.traceEventEnd();
                    }
                }
            }, composerStartRestartGroup, 54), composerStartRestartGroup, (i21115 & 7168) | (i21115 & 14) | 12582912 | (i21115 & 112) | (i21115 & 896) | ((i6 << 15) & 458752)), composerStartRestartGroup, (i6 >> 3) & 14, 0);
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            vertical2 = top;
            contextualFlowColumnOverflow2 = clip;
            i21 = i24;
            modifier3 = modifier2;
            i22 = i19;
            horizontal3 = horizontal1114;
        }
        scopeUpdateScopeEndRestartGroup = composerStartRestartGroup.endRestartGroup();
        if (scopeUpdateScopeEndRestartGroup != null) {
            scopeUpdateScopeEndRestartGroup.updateScope(new Function2<Composer, Integer, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    invoke((Composer) obj2, ((Number) obj3).intValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(Composer composer2, int i21116) {
                    ContextualFlowLayoutKt.ContextualFlowColumn(i, modifier3, vertical2, horizontal3, i22, i21, contextualFlowColumnOverflow2, function4, composer2, RecomposeScopeImplKt.updateChangedFlags(i4 | 1), i5);
                }
            });
        }
    }

    public static final Function2<SubcomposeMeasureScope, Constraints, MeasureResult> contextualRowMeasurementHelper(Arrangement.Horizontal horizontal, Arrangement.Vertical vertical, int i, int i2, FlowLayoutOverflowState flowLayoutOverflowState, int i3, List<? extends Function2<? super Composer, ? super Integer, Unit>> list, Function4<? super Integer, ? super FlowLineInfo, ? super Composer, ? super Integer, Unit> function4, Composer composer, int i4) {
        boolean z;
        ComposerKt.sourceInformationMarkerStart(composer, -43351224, "C(contextualRowMeasurementHelper)P(1,7,3,4,6,2,5)343@13891L847:ContextualFlowLayout.kt#2w3rfo");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-43351224, i4, -1, "androidx.compose.foundation.layout.contextualRowMeasurementHelper (ContextualFlowLayout.kt:342)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 1138967354, "CC(remember):ContextualFlowLayout.kt#9igjgp");
        if (((i4 & 14) ^ 6) > 4 && composer.changed(horizontal)) {
            z = true;
        } else if ((i4 & 6) == 4) {
            z = true;
        } else {
            z = false;
        }
        boolean zChanged = z | ((((i4 & 112) ^ 48) > 32 && composer.changed(vertical)) || (i4 & 48) == 32) | ((((i4 & 896) ^ 384) > 256 && composer.changed(i)) || (i4 & 384) == 256) | ((((i4 & 7168) ^ 3072) > 2048 && composer.changed(i2)) || (i4 & 3072) == 2048) | composer.changed(flowLayoutOverflowState) | ((((458752 & i4) ^ 196608) > 131072 && composer.changed(i3)) || (i4 & 196608) == 131072) | ((((29360128 & i4) ^ 12582912) > 8388608 && composer.changed(function4)) || (i4 & 12582912) == 8388608);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new FlowMeasureLazyPolicy(true, horizontal, vertical, horizontal.getSpacing(), FlowLayoutKt.getCROSS_AXIS_ALIGNMENT_TOP(), vertical.getSpacing(), i3, i2, i, flowLayoutOverflowState, list, function4, null).getMeasurePolicy();
            composer.updateRememberedValue(objRememberedValue);
        }
        Function2<SubcomposeMeasureScope, Constraints, MeasureResult> function2 = (Function2) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return function2;
    }

    public static final Function2<SubcomposeMeasureScope, Constraints, MeasureResult> contextualColumnMeasureHelper(Arrangement.Vertical vertical, Arrangement.Horizontal horizontal, int i, int i2, FlowLayoutOverflowState flowLayoutOverflowState, int i3, List<? extends Function2<? super Composer, ? super Integer, Unit>> list, Function4<? super Integer, ? super FlowLineInfo, ? super Composer, ? super Integer, Unit> function4, Composer composer, int i4) {
        boolean z;
        ComposerKt.sourceInformationMarkerStart(composer, 1009762916, "C(contextualColumnMeasureHelper)P(7,1,3,4,6,2,5)383@15228L850:ContextualFlowLayout.kt#2w3rfo");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1009762916, i4, -1, "androidx.compose.foundation.layout.contextualColumnMeasureHelper (ContextualFlowLayout.kt:382)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, -1978242771, "CC(remember):ContextualFlowLayout.kt#9igjgp");
        if (((i4 & 14) ^ 6) > 4 && composer.changed(vertical)) {
            z = true;
        } else if ((i4 & 6) == 4) {
            z = true;
        } else {
            z = false;
        }
        boolean zChanged = z | ((((i4 & 112) ^ 48) > 32 && composer.changed(horizontal)) || (i4 & 48) == 32) | ((((i4 & 896) ^ 384) > 256 && composer.changed(i)) || (i4 & 384) == 256) | ((((i4 & 7168) ^ 3072) > 2048 && composer.changed(i2)) || (i4 & 3072) == 2048) | composer.changed(flowLayoutOverflowState) | ((((458752 & i4) ^ 196608) > 131072 && composer.changed(i3)) || (i4 & 196608) == 131072) | ((((29360128 & i4) ^ 12582912) > 8388608 && composer.changed(function4)) || (i4 & 12582912) == 8388608);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new FlowMeasureLazyPolicy(false, horizontal, vertical, vertical.getSpacing(), FlowLayoutKt.getCROSS_AXIS_ALIGNMENT_START(), horizontal.getSpacing(), i3, i2, i, flowLayoutOverflowState, list, function4, null).getMeasurePolicy();
            composer.updateRememberedValue(objRememberedValue);
        }
        Function2<SubcomposeMeasureScope, Constraints, MeasureResult> function2 = (Function2) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return function2;
    }
}
